data:extend({
  {
    type = "technology",
    name = "programmable-combinator",
    icon = MOD_NAME.."/graphics/programmable-combinator-technology.png",
	icon_size = 64,
    prerequisites = {"circuit-network"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "programmable-combinator"
      },
      {
        type = "unlock-recipe",
        recipe = "programmable-combinator-input"
      },
      {
        type = "unlock-recipe",
        recipe = "programmable-combinator-output"
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
