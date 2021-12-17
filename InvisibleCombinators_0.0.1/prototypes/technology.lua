data:extend({
  {
    type = "technology",
    name = "invisible-combinator",
    icon = MOD_NAME.."/graphics/invisible-combinator-technology.png",
	icon_size = 64,
    prerequisites = {"circuit-network"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "invisible-combinator"
      },
      {
        type = "unlock-recipe",
        recipe = "invisible-combinator-input"
      },
      {
        type = "unlock-recipe",
        recipe = "invisible-combinator-output"
      },
    },
    unit =
    {
      count = 50,
      ingredients = {
         {"science-pack-1", 1}
        ,{"science-pack-2", 1}
      },
      time = 2000
    },
    order = "c-g-c"
  }
})
