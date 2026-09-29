const API = './api/recipes.php';

async function handle(res) {
  if (!res.ok) {
    let message = 'Request failed (' + res.status + ')';
    try {
      const body = await res.json();
      if (body && body.error) message = body.error;
    } catch (e) { /* response wasn't JSON — keep the generic message */ }
    throw new Error(message);
  }
  return res.status === 204 ? null : res.json();
}

/** Fetches every recipe from the database. */
export async function load() {
  const res = await fetch(API);
  return handle(res);
}

/** Fetches one recipe by id. Returns null if it doesn't exist. */
export async function get(id) {
  const res = await fetch(API + '?id=' + encodeURIComponent(id));
  if (res.status === 404) return null;
  return handle(res);
}

/**
 * Creates a recipe (no id on the payload) or updates one (id present).
 * Returns the saved recipe as stored, id included.
 */
export async function upsert(recipe) {
  const isNew = !recipe.id;
  const url = isNew ? API : API + '?id=' + encodeURIComponent(recipe.id);
  const res = await fetch(url, {
    method: isNew ? 'POST' : 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(recipe)
  });
  return handle(res);
}

/** Deletes a recipe by id and returns the remaining list. */
export async function remove(id) {
  const res = await fetch(API + '?id=' + encodeURIComponent(id), { method: 'DELETE' });
  await handle(res);
  return load();
}

/** Distinct, first-seen-order category list — unchanged, still a plain sync helper. */
export function categories(list) {
  const seen = [];
  list.forEach(r => { if (r.category && seen.indexOf(r.category) < 0) seen.push(r.category); });
  return seen;
}

/** Splits a textarea's value into trimmed, non-empty lines — unchanged. */
export function splitLines(text) {
  return String(text || '').split('\n').map(s => s.trim()).filter(Boolean);
}
