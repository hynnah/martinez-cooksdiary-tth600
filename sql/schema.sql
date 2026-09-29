CREATE DATABASE IF NOT EXISTS cooksdiary
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE cooksdiary;

CREATE TABLE IF NOT EXISTS recipes (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(200)      NOT NULL,
  category    VARCHAR(100)      NOT NULL DEFAULT 'Uncategorised',
  cook_time   INT UNSIGNED      NOT NULL DEFAULT 0,
  image_url   VARCHAR(500)      NOT NULL DEFAULT '',
  ingredients JSON              NOT NULL,
  steps       JSON              NOT NULL,
  created_at  TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO recipes (title, category, cook_time, image_url, ingredients, steps) VALUES
(
  'Lemon & Thyme Roast Chicken', 'Mains', 80, '',
  JSON_ARRAY('1 whole chicken, about 1.6kg', '2 lemons', '6 sprigs thyme', '4 tbsp butter, softened', 'Sea salt and black pepper', '1 head garlic, halved'),
  JSON_ARRAY(
    'Heat the oven to 200C. Sit the chicken on a board and pat the skin dry.',
    'Mash the butter with the zest of one lemon, the thyme leaves and a good pinch of salt.',
    'Push the butter under the skin of the breasts. Halve both lemons and put them in the cavity with the garlic.',
    'Roast for 70 minutes, basting twice, until the juices run clear at the thigh.',
    'Rest for 15 minutes before carving. Spoon the pan juices over the meat.'
  )
),
(
  'Saffron Risotto', 'Mains', 35, '',
  JSON_ARRAY('300g carnaroli rice', '1 litre hot chicken stock', 'Large pinch saffron threads', '1 small onion, finely diced', '100ml dry white wine', '60g butter', '50g parmesan, grated'),
  JSON_ARRAY(
    'Steep the saffron in a ladle of the hot stock.',
    'Sweat the onion in half the butter until translucent, without colour.',
    'Add the rice and toast for two minutes, then pour in the wine and let it go.',
    'Add stock a ladle at a time, stirring, for 18 minutes. Add the saffron stock halfway.',
    'Off the heat, beat in the rest of the butter and the parmesan. Rest two minutes, then serve loose.'
  )
),
(
  'Brown Butter Madeleines', 'Baking', 25, '',
  JSON_ARRAY('100g butter', '100g plain flour', '100g caster sugar', '2 eggs', '1 tsp honey', '½ tsp baking powder', 'Zest of 1 lemon'),
  JSON_ARRAY(
    'Brown the butter until it smells of hazelnuts, then cool to room temperature.',
    'Whisk the eggs, sugar and honey to a pale ribbon.',
    'Fold in the flour and baking powder, then the butter and zest.',
    'Chill the batter for at least an hour — the bump depends on it.',
    'Bake at 210C for 9 minutes in a buttered tin. Eat warm.'
  )
),
(
  'Charred Broccoli, Anchovy & Chilli', 'Sides', 18, '',
  JSON_ARRAY('400g tenderstem broccoli', '4 anchovy fillets in oil', '1 red chilli, sliced', '2 cloves garlic, sliced', '3 tbsp olive oil', 'Squeeze of lemon'),
  JSON_ARRAY(
    'Blanch the broccoli for two minutes, then drain very well.',
    'Warm the oil with the anchovies until they melt, then add garlic and chilli.',
    'Get a pan smoking hot and char the broccoli in one layer, turning once.',
    'Pour over the anchovy oil, squeeze on lemon and serve straight away.'
  )
),
(
  'Buckwheat Pancakes', 'Breakfast', 20, '',
  JSON_ARRAY('120g buckwheat flour', '80g plain flour', '2 tsp baking powder', '300ml buttermilk', '1 egg', '1 tbsp maple syrup', 'Butter for the pan'),
  JSON_ARRAY(
    'Whisk the dry ingredients in one bowl, the wet in another.',
    'Combine with a few strokes only — lumps are fine.',
    'Rest the batter 10 minutes while the pan heats.',
    'Cook in butter over medium heat until bubbles set, then flip.'
  )
),
(
  'Dark Chocolate Olive Oil Cake', 'Baking', 45, '',
  JSON_ARRAY('150ml mild olive oil', '180g dark chocolate, 70%', '150g caster sugar', '3 eggs', '100g ground almonds', '40g cocoa', 'Pinch of salt'),
  JSON_ARRAY(
    'Melt the chocolate and stir in the olive oil.',
    'Whisk the eggs and sugar until thick, then fold in the chocolate.',
    'Fold in the almonds, cocoa and salt.',
    'Bake at 170C for 35 minutes — the centre should still wobble.',
    'Cool in the tin. Serve with creme fraiche.'
  )
),
(
  'Slow-Braised Beef Shin with Gremolata', 'Mains', 210, '',
  JSON_ARRAY('1.2kg beef shin, cut into thick rounds', '2 onions, sliced', '2 carrots, in chunks', '3 sticks celery, in chunks', '1 tbsp tomato puree', '400ml red wine', '500ml beef stock', '2 bay leaves', 'Zest of 1 lemon, 1 clove garlic and a handful of parsley for the gremolata'),
  JSON_ARRAY(
    'Take the beef out of the fridge an hour early and season it heavily with salt.',
    'Heat a heavy casserole and brown the shin hard on both sides, in batches. Set it aside.',
    'Lower the heat and sweat the onions, carrots and celery in the same pan until soft and sweet.',
    'Stir in the tomato puree and cook it out for two minutes until it darkens.',
    'Pour in the wine, scrape the base clean and reduce by half.',
    'Return the beef, add the stock and bay, and bring to a bare simmer.',
    'Cover and cook at 150C for three hours, turning the pieces once at the halfway mark.',
    'Chop the parsley with the lemon zest and garlic to make the gremolata.',
    'Lift out the beef, reduce the sauce if it needs it, and serve with the gremolata scattered over.'
  )
);
