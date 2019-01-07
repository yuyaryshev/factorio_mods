for _,force in pairs(game.forces) do
	-- Did you try turning it off and on again? :)
	-- Pretty sure this doesn't actually do anything, since these trigger before the mod's control.lua runs, so it isn't listening for the events. Was worth a try though.
  if force.technologies["alien-hybrid-upgrade-1"].researched then
    force.technologies["alien-hybrid-upgrade-1"].researched = false
	force.technologies["alien-hybrid-upgrade-1"].researched = true
  end
  if force.technologies["alien-hybrid-upgrade-2"].researched then
    force.technologies["alien-hybrid-upgrade-2"].researched = false
	force.technologies["alien-hybrid-upgrade-2"].researched = true
  end
  if force.technologies["alien-hybrid-upgrade-3"].researched then
    force.technologies["alien-hybrid-upgrade-3"].researched = false
	force.technologies["alien-hybrid-upgrade-3"].researched = true
  end
  if force.technologies["alien-hybrid-upgrade-4"].researched then
    force.technologies["alien-hybrid-upgrade-4"].researched = false
	force.technologies["alien-hybrid-upgrade-4"].researched = true
  end
end