-- adds a recipe which is unlocked when the given technology is researched
function addTechnologyUnlocksRecipe(technologyName, recipeName)
	local tech = data.raw["technology"][technologyName]
	if tech then
		local recipe = data.raw.recipe[recipeName]
		if recipe == nil then
			error("Technology "..technologyName.." should unlock "..recipeName.." but recipe is not initialized yet")
		else
			data.raw["recipe"][recipeName].enabled = false
			if tech.effects == nil then
				tech.effects = {}
			end
			table.insert(tech.effects, {type = "unlock-recipe", recipe = recipeName })
		end
	else
		error("Technology "..technologyName.." not found when adding recipe "..recipeName..". Did you mean?")
		for name,_ in pairs(data.raw["technology"]) do
			error(" "..name)
		end
	end
end

function copyPrototype(type, name, newName)
  if not data.raw[type] then error("data.raw["..type.."] doesn't exist") end
  if not data.raw[type][name] then error("data.raw["..type.."]["..name.."] doesn't exist") end
  local p = table.deepcopy(data.raw[type][name])
  p.name = newName
  if p.minable and p.minable.result then
    p.minable.result = newName
  end
  if p.place_result then
    p.place_result = newName
  end
  if p.result then
    p.result = newName
  end
  if p.results then
		for _,result in pairs(p.results) do
			if result.name == name then
				result.name = newName
			end
		end
	end
  return p
end
