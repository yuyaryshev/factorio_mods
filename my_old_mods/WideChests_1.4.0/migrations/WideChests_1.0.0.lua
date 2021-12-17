game.reload_script()

for _, force in pairs(game.forces) do
	force.reset_recipes()
	force.reset_technologies()

	if force.technologies["steel-processing"] then
		if force.technologies["steel-processing"].researched then
			force.recipes["merge-chest-selector"].enabled = true
		end
	end
end