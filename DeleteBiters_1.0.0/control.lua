local function clear_biters(area, silent)
  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered({force="enemy", area=area})) do
	  if entity.prototype.speed ~= nil then
        entity.destroy();
      end
    end
  end
end

script.on_init(function()
  clear_biters()
end)

script.on_nth_tick(5*60, function()
  clear_biters()
end)
