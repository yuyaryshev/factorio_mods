require "./config"

script.on_event(defines.events.on_chunk_generated, function(e)
     for key, entity in pairs(e.surface.find_entities(e.area)) do
        local removeEntity = false
		-- If Entity is a tree, and the remove rate is greater than 0.
        if entity.type == "tree" and removeTrees > 0 then
			-- If remove rate is less than 1, chance it. 
			if removeTrees < 1 then
				rand = math.random()
				if rand < removeTrees then
					removeEntity = true
				end
			-- If remove rate is 1, don't waste processing time on random numbers, just remove it.
			else
				removeEntity = true
			end
		-- If entity is a rock, do same as above.
        elseif entity.name == "stone-rock" and removeRocks > 0 then
			-- If remove rate is less than 1, chance it. 
			if removeRocks < 1 then
				rand = math.random()
				if rand < removeRocks then
					removeEntity = true
				end
			-- If remove rate is 1, don't waste processing time on random numbers, just remove it.
			else
				removeEntity = true
			end
        end
		
		-- If we've designated it to be remove, remove it.
        if removeEntity then
            entity.destroy()
        end
    end
end)