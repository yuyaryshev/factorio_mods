data.raw.recipe["firearm-magazine"].result_count = 5
data.raw.recipe["firearm-magazine"].energy_required = data.raw.recipe["firearm-magazine"].energy_required * 5
data.raw.recipe["firearm-magazine"].ingredients = 
	{
      {"iron-plate", 1},
      {"coal", 8}, -- 20 original
	}

data.raw.recipe["piercing-rounds-magazine"].result_count = 5
data.raw.recipe["piercing-rounds-magazine"].energy_required = data.raw.recipe["piercing-rounds-magazine"].energy_required * 5
data.raw.recipe["piercing-rounds-magazine"].ingredients = 
	{
      {"firearm-magazine", 3}, -- 5 original
      {"steel-plate", 1},
      {"copper-plate", 3}, -- 5 original
	}

	
data.raw.recipe["shotgun-shell"].result_count = 10 * 20
data.raw.recipe["shotgun-shell"].energy_required = data.raw.recipe["shotgun-shell"].energy_required * 10
data.raw.recipe["shotgun-shell"].ingredients = 
	{
      {"copper-plate", 1},
      {"iron-plate", 1},
      {"coal", 25},
	}


data.raw.recipe["piercing-shotgun-shell"].result_count = 10
data.raw.recipe["piercing-shotgun-shell"].energy_required = data.raw.recipe["piercing-shotgun-shell"].energy_required * 10
data.raw.recipe["piercing-shotgun-shell"].ingredients = 
	{
      {"shotgun-shell", 20},
      {"copper-plate", 5},
      {"steel-plate", 2},
	}


data.raw.recipe["cannon-shell"].normal.result_count = 10 * 20
data.raw.recipe["cannon-shell"].normal.energy_required = data.raw.recipe["cannon-shell"].normal.energy_required * 10
data.raw.recipe["cannon-shell"].normal.ingredients = 
	{
        {"steel-plate", 2},
        {"plastic-bar", 10},
        {"explosives", 10},
	}


data.raw.recipe["cannon-shell"].expensive.result_count = 10 * 20
data.raw.recipe["cannon-shell"].expensive.energy_required = data.raw.recipe["cannon-shell"].expensive.energy_required * 10
data.raw.recipe["cannon-shell"].expensive.ingredients = 
	{
        {"steel-plate", 4},
        {"plastic-bar", 20},
        {"explosives", 20},
	}


data.raw.recipe["explosive-cannon-shell"].normal.result_count = 10 * 20
data.raw.recipe["explosive-cannon-shell"].normal.energy_required = data.raw.recipe["explosive-cannon-shell"].normal.energy_required * 10
data.raw.recipe["explosive-cannon-shell"].normal.ingredients = 
	{
        {"steel-plate", 3},
        {"plastic-bar", 10},
        {"explosives", 20},
	}


data.raw.recipe["explosive-cannon-shell"].expensive.result_count = 10 * 20
data.raw.recipe["explosive-cannon-shell"].expensive.energy_required = data.raw.recipe["explosive-cannon-shell"].expensive.energy_required * 10
data.raw.recipe["explosive-cannon-shell"].expensive.ingredients = 
	{
        {"steel-plate", 3},
        {"plastic-bar", 30},
        {"explosives", 40},
	}


data.raw.recipe["explosives"].normal.result_count = data.raw.recipe["explosives"].normal.result_count * 2
data.raw.recipe["explosives"].normal.energy_required = data.raw.recipe["explosives"].normal.energy_required * 2
data.raw.recipe["explosives"].normal.ingredients = 
  {
	{type="item", name="sulfur", amount=1},
	{type="item", name="coal", amount=3},
	{type="fluid", name="water", amount=20},
  }


data.raw.recipe["explosives"].expensive.result_count = data.raw.recipe["explosives"].expensive.result_count * 2
data.raw.recipe["explosives"].expensive.energy_required = data.raw.recipe["explosives"].expensive.energy_required * 2
data.raw.recipe["explosives"].expensive.ingredients = 
  {
	{type="item", name="sulfur", amount=2},
	{type="item", name="coal", amount=4},
	{type="fluid", name="water", amount=20},
  }


local ingredients = data.raw.recipe["military-science-pack"].ingredients
for i, ing in ipairs(ingredients) do
	if ing[1] == "gun-turret" then
		ingredients[i][1] = "stone-wall"
		ingredients[i][2] = 2
	end
	if ing[1] == "grenade" then
		ingredients[i][1] = "grenade"
		ingredients[i][2] = 5
	end	
end

data.raw.recipe["grenade"].result_count = 5
data.raw.recipe["grenade"].ingredients =
    {
      {"iron-plate", 1},
      {"coal", 10}
    }

data.raw.recipe["cluster-grenade"].result_count = 10
data.raw.recipe["cluster-grenade"].ingredients =
    {
      {"grenade", 10},
      {"explosives", 1},
      {"steel-plate", 1}
    }
