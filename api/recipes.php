<?php
/*
  /api/recipes.php — the only backend endpoint this app needs.
 
    GET    /api/recipes.php            -> list all recipes
    GET    /api/recipes.php?id=5       -> one recipe
    POST   /api/recipes.php            -> create (JSON body, no id)
    PUT    /api/recipes.php?id=5       -> update (JSON body)
    DELETE /api/recipes.php?id=5       -> delete
 
  Recipe JSON shape (matches the frontend exactly):
     { id, title, category, cookTime, imageUrl, ingredients: [string], steps: [string] }
 */

require __DIR__ . '/db.php';

function row_to_recipe(array $row): array {
    return [
        'id'          => (string) $row['id'],
        'title'       => $row['title'],
        'category'    => $row['category'],
        'cookTime'    => (int) $row['cook_time'],
        'imageUrl'    => $row['image_url'],
        'ingredients' => json_decode($row['ingredients'], true) ?: [],
        'steps'       => json_decode($row['steps'], true) ?: [],
    ];
}

function read_json_body(): ?array {
    $data = json_decode(file_get_contents('php://input'), true);
    return is_array($data) ? $data : null;
}

function fail(int $code, string $message): void {
    http_response_code($code);
    echo json_encode(['error' => $message]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int) $_GET['id'] : null;

switch ($method) {

    case 'GET':
        if ($id) {
            $stmt = $pdo->prepare('SELECT * FROM recipes WHERE id = ?');
            $stmt->execute([$id]);
            $row = $stmt->fetch();
            if (!$row) fail(404, 'Recipe not found.');
            echo json_encode(row_to_recipe($row));
        } else {
            $rows = $pdo->query('SELECT * FROM recipes ORDER BY id ASC')->fetchAll();
            echo json_encode(array_map('row_to_recipe', $rows));
        }
        break;

    case 'POST':
        $data = read_json_body();
        if (!$data || empty(trim($data['title'] ?? ''))) {
            fail(400, 'A recipe title is required.');
        }

        $stmt = $pdo->prepare(
            'INSERT INTO recipes (title, category, cook_time, image_url, ingredients, steps)
             VALUES (?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([
            trim($data['title']),
            trim($data['category'] ?? '') ?: 'Uncategorised',
            (int) ($data['cookTime'] ?? 0),
            trim($data['imageUrl'] ?? ''),
            json_encode($data['ingredients'] ?? [], JSON_UNESCAPED_UNICODE),
            json_encode($data['steps'] ?? [], JSON_UNESCAPED_UNICODE),
        ]);

        $newId = (int) $pdo->lastInsertId();
        $stmt = $pdo->prepare('SELECT * FROM recipes WHERE id = ?');
        $stmt->execute([$newId]);
        http_response_code(201);
        echo json_encode(row_to_recipe($stmt->fetch()));
        break;
    case 'PUT':
        if (!$id) fail(400, 'An id is required to update a recipe.');
        $data = read_json_body();
        if (!$data || empty(trim($data['title'] ?? ''))) {
            fail(400, 'A recipe title is required.');
        }

        $stmt = $pdo->prepare(
            'UPDATE recipes
             SET title = ?, category = ?, cook_time = ?, image_url = ?, ingredients = ?, steps = ?
             WHERE id = ?'
        );
        $stmt->execute([
            trim($data['title']),
            trim($data['category'] ?? '') ?: 'Uncategorised',
            (int) ($data['cookTime'] ?? 0),
            trim($data['imageUrl'] ?? ''),
            json_encode($data['ingredients'] ?? [], JSON_UNESCAPED_UNICODE),
            json_encode($data['steps'] ?? [], JSON_UNESCAPED_UNICODE),
            $id,
        ]);

        $stmt = $pdo->prepare('SELECT * FROM recipes WHERE id = ?');
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        if (!$row) fail(404, 'Recipe not found.');
        echo json_encode(row_to_recipe($row));
        break;

    case 'DELETE':
        if (!$id) fail(400, 'An id is required to delete a recipe.');
        $stmt = $pdo->prepare('DELETE FROM recipes WHERE id = ?');
        $stmt->execute([$id]);
        echo json_encode(['deleted' => true, 'id' => (string) $id]);
        break;

    default:
        fail(405, 'Method not allowed.');
}
