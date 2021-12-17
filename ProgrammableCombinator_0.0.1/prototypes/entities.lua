local programmable_combinator = copyPrototype("programmable-speaker", "programmable-speaker", "programmable-combinator")
	programmable_combinator.icon = MOD_NAME.."/graphics/programmable-combinator-item.png"
	programmable_combinator.icon_size = 32
	programmable_combinator.energy_usage_per_tick = "1kW"
	programmable_combinator.sprite = 
	{
      layers =
      {
		{
			filename = MOD_NAME.."/graphics/programmable-combinator-entity.png",
			x = 158,
			y = 5,
			width = 79,
			height = 63,
			frame_count = 1,
			shift = {0.140625, 0.140625},
		},	
		}
	}
	

local programmable_combinator_input = copyPrototype("programmable-speaker", "programmable-speaker", "programmable-combinator-input")
	programmable_combinator_input.energy_usage_per_tick = "1W"
	programmable_combinator_input.icon = MOD_NAME.."/graphics/programmable-combinator-input-item.png"
	programmable_combinator_input.icon_size = 32
	programmable_combinator_input.sprite =
		{
		  layers =
		  {
			{
			  filename = MOD_NAME.."/graphics/programmable-combinator-input-entity.png",
			  priority = "extra-high",
			  width = 30,
			  height = 89,
			  shift = util.by_pixel(-2, -39.5),
			  hr_version = {
				filename = MOD_NAME.."/graphics/hr-programmable-combinator-input-entity.png",
				priority = "extra-high",
				width = 59,
				height = 178,
				shift = util.by_pixel(-2.25, -39.5),
				scale = 0.5,
			  }
			},
			{
			  filename = MOD_NAME.."/graphics/programmable-combinator-input-entity-shadow.png",
			  priority = "extra-high",
			  width = 119,
			  height = 25,
			  shift = util.by_pixel(52.5, -2.5),
			  draw_as_shadow = true,
			  hr_version = {
				filename = MOD_NAME.."/graphics/hr-programmable-combinator-input-entity.png",
				priority = "extra-high",
				width = 237,
				height = 50,
				shift = util.by_pixel(52.75, -3),
				draw_as_shadow = true,
				scale = 0.5,
			  }
			}
		  }
		}

local programmable_combinator_output = copyPrototype("constant-combinator", "constant-combinator", "programmable-combinator-output")
	programmable_combinator_output.icon = MOD_NAME.."/graphics/programmable-combinator-output-item.png"
	programmable_combinator_output.icon_size = 32
	programmable_combinator_output.sprites = 
		{
		  north =
		  {
			filename = MOD_NAME.."/graphics/programmable-combinator-output-entity.png",
			x = 158,
			y = 5,
			width = 79,
			height = 63,
			frame_count = 1,
			shift = {0.140625, 0.140625},
		  },
		  east =
		  {
			filename = MOD_NAME.."/graphics/programmable-combinator-output-entity.png",
			y = 5,
			width = 79,
			height = 63,
			frame_count = 1,
			shift = {0.140625, 0.140625},
		  },
		  south =
		  {
			filename = MOD_NAME.."/graphics/programmable-combinator-output-entity.png",
			x = 237,
			y = 5,
			width = 79,
			height = 63,
			frame_count = 1,
			shift = {0.140625, 0.140625},
		  },
		  west =
		  {
			filename = MOD_NAME.."/graphics/programmable-combinator-output-entity.png",
			x = 79,
			y = 5,
			width = 79,
			height = 63,
			frame_count = 1,
			shift = {0.140625, 0.140625},
		  }
		}

data:extend({programmable_combinator, programmable_combinator_input, programmable_combinator_output})

local function make_invisible(lua_table)
	local zero_point = {0.0,0.0}
	local empty_rect = {{0.0,0.0}, {0.0, 0.0}}
	local empty_sprite = 
	{
        filename = MOD_NAME.."/graphics/empty_1x1.png",
        x = 0,
        width = 1,
        height = 1,
        shift = util.by_pixel(0, 0),
        hr_version =
        {
          scale = 0,
          filename = MOD_NAME.."/graphics/empty_1x1.png",
          x = 0,
          width = 1,
          height = 1,
          shift = util.by_pixel(0, 0),
        },
      }	

	for key, value in pairs(lua_table) do
		if value and type(value) == "table" then
			-- replace sprites
			if value["filename"] and string.find( value["filename"],".png") then
				lua_table[key] = empty_sprite
				
			-- remove sounds, indicators, lights
			elseif key == "volume" or key == "intensity" then
				lua_table[key] = 0.0
				
			-- remove all boxes
			elseif 
					key == "input_connection_bounding_box" 
				or	key == "output_connection_bounding_box"
				or	key == "collision_box"
				or	key == "selection_box"
				then 
				lua_table[key] = empty_rect

			-- move connection_points to zero point
			elseif key == "red" or key == "green" or key == "copper" then
				lua_table[key] = zero_point
				
			else
				-- recursively...
				make_invisible(value)
			end
		end
	end
end

local invisible_constant_combinator = copyPrototype("constant-combinator", "constant-combinator", "invisible-constant-combinator")
	make_invisible(invisible_constant_combinator)

local invisible_decider_combinator = copyPrototype("decider-combinator", "decider-combinator", "invisible-decider-combinator")
	make_invisible(invisible_decider_combinator)
	
local invisible_arithmetic_combinator = copyPrototype("arithmetic-combinator", "arithmetic-combinator", "invisible-arithmetic-combinator")
	make_invisible(invisible_arithmetic_combinator)
		
local invisible_combinators = {invisible_constant_combinator, invisible_decider_combinator, invisible_arithmetic_combinator}		

--for _, entity in ipairs(data) do
--	-- entity.icon = empty
--		e
--	    entity.collision_mask = {"doodad-layer"},
--
--end

data:extend(invisible_combinators)


--------
--local programmable_combinator = copyPrototype("item", "constant-combinator", "programmable-combinator")
--	programmable_combinator_input.icon = MOD_NAME.."/graphics/programmable-combinator-item.png"
--
--local programmable_combinator_output = copyPrototype("item", "constant-combinator", "programmable-combinator-input")
--	programmable_combinator_input.icon = MOD_NAME.."/graphics/programmable-combinator-input-item.png"
--	
--local programmable_combinator_output = copyPrototype("item", "constant-combinator", "programmable-combinator-output")
--	programmable_combinator_input.icon = MOD_NAME.."/graphics/programmable-combinator-output-item.png"
--------


--addTechnologyUnlocksRecipe("circuit-network","programmable-combinator")
--addTechnologyUnlocksRecipe("circuit-network","programmable-combinator-input")
--addTechnologyUnlocksRecipe("circuit-network","programmable-combinator-output")
