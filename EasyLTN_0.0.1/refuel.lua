function refuel(train, refuel_setting)
	if train.valid and train.locomotives and #train.locomotives.front_movers + #train.locomotives.back_movers> 0 then
		for _, loco in pairs(train.locomotives.front_movers, train.locomotives.back_movers) do
			local fuel_inventory = loco.get_fuel_inventory()
			
			local filled_stacks = 0.0
			for item_name, cnt in pairs(fuel_inventory.get_contents()) do
				filled_stacks = filled_stacks + cnt*1.0/game.item_prototypes[item_name].stack_size
			end
			
			if filled_stacks/#fuel_inventory < refuel_setting then
				addScheduleNext(train, "Refuel")
				return
			end			
		end		
	end
end