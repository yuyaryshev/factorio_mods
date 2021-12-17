--[[
	See control.lua about stealing my code.

	What you see here is a simple file that disables player crafting.
]]--
local handcraft_category="handcraft_category"

data:extend(
  {
    {
      type = "recipe-category",
      name = handcraft_category
    }
  }
)

data.raw.player.player.crafting_categories = {handcraft_category}

data.raw["recipe"]["iron-axe"].energy_required = 0.4
data.raw["recipe"]["blueprint"].energy_required = 0.01

for i, obj in pairs(data.raw["recipe"]) do
	if obj.energy_required ~= nil and obj.energy_required < 0.5 then
		obj.category = handcraft_category
	end
end
