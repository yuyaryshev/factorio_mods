data.raw.item["copper-ore"].stack_size = 200
data.raw.item["iron-ore"].stack_size = 200
data.raw.item["stone"].stack_size = 200
data.raw.item["uranium-ore"].stack_size = 200
data.raw.item["coal"].stack_size = 200
data.raw.item["solid-fuel"].stack_size = 200
data.raw.item["iron-plate"].stack_size = 200
data.raw.item["copper-plate"].stack_size = 200
data.raw.item["steel-plate"].stack_size = 200
data.raw.item["rocket-fuel"].stack_size = 100
data.raw.item["pipe"].stack_size = 500
data.raw.item["steam-engine"].stack_size = 50
data.raw.item["transport-belt"].stack_size = 200
data.raw.item["underground-belt"].stack_size = 100
data.raw.item["splitter"].stack_size = 100
data.raw.item["fast-transport-belt"].stack_size = 200
data.raw.item["fast-underground-belt"].stack_size = 100
data.raw.item["fast-splitter"].stack_size = 100
data.raw.item["express-transport-belt"].stack_size = 200
data.raw.item["express-underground-belt"].stack_size = 100
data.raw.item["express-splitter"].stack_size = 100
data.raw.item["wood"].stack_size = 500
data.raw.item["copper-cable"].stack_size = 500
data.raw.item["stone-brick"].stack_size = 200

data.raw.item["landfill"].stack_size = 5000
--data.raw.item["rail"].stack_size = 5000
data.raw.item["concrete"].stack_size = 5000

for i, recipe in pairs(data.raw.recipe) do
  if
    recipe.name == "programmable-speaker" or
    recipe.name == "logistic-train-stop" or
    recipe.name == "arithmetic-combinator" or
    recipe.name == "decider-combinator" or
    recipe.name == "constant-combinator" or
    recipe.name == "filter-inserter" or
    recipe.name == "rail-signal" or
    recipe.name == "locomotive" or
    recipe.name == "power-switch" or
    recipe.name == "rail-chain-signal"
  then
    bobmods.lib.recipe.replace_ingredient(recipe.name, "electronic-circuit", "basic-circuit-board")
  end
end

data:extend(
{
	{
		type = "selection-tool",
		name = "beltconnect-planner",
		icon = "__lordodin_changes__/graphics/icons/beltconnect-planner.png",
		icon_size = 32,
		flags = { "goes-to-quickbar" },
		subgroup = "tool",
		order = "c[automated-construction]-a[blueprint]",
		stack_size = 1,
		draw_label_for_cursor_render = true,
		selection_color = { r = 0, g = 0, b = 1 },
		alt_selection_color = { r = 1, g = 0, b = 0 },
		selection_mode = { "blueprint", "matches-force" },
		alt_selection_mode = { "blueprint", "matches-force" },
		selection_cursor_box_type = "entity",
		alt_selection_cursor_box_type = "entity"
	},
	{
		type = "recipe",
		name = "beltconnect-planner",
		energy_required = 0.01,
		ingredients = {},
		result = "beltconnect-planner",
		enabled = true
	},
})


data:extend({
{
    type = "item",
    name = "waterfill",
    tooltip = "wftt",
    icon = "__lordodin_changes__/graphics/water.png",
    icon_size = 128,
    flags = {"goes-to-main-inventory"},
    subgroup = "terrain",
    order = "c[landfill]-a[dirt]",
    stack_size = 1000,
    place_as_tile =
    {
      result = "water",
      condition_size = 1,
      condition = { "water-tile" }
    }
  },
    {
    type = "recipe",
    name = "waterfill",
    energy_required = 1,
    enabled = true,
    ingredients =
    {
    },
    result= "waterfill",
    result_count = 1
  }
  })
  