
local big_kit = 
	{
	chest = {
		{name="medium-electric-pole",count=150},
		{name="constant-combinator",count=50},
		{name="decider-combinator",count=50},
		{name="arithmetic-combinator",count=50},
		{name="filter-inserter",count=150},
		{name="transport-belt",count=600},
		{name="fast-inserter",count=100},
		{name="rail-chain-signal",count=150},
		{name="rail",count=3000},
		{name="iron-plate",count=400},
		{name="copper-plate",count=400},
		{name="steel-plate",count=400},
		{name="stone-brick",count=400},
		{name="steel-chest",count=100},
		{name="logistic-chest-passive-provider",count=100},
		{name="logistic-chest-storage",count=50},
		{name="logistic-chest-requester",count=100},
--		{name="science-pack-1",count=600},
--		{name="science-pack-2",count=400},
--		{name="glass",count=400},
		{name="cargo-wagon",count=20},
		{name="logistic-train-stop",count=50},
		{name="roboport",count=2},
		{name="construction-robot",count=150},
		},
	inv = {
		{name="logistic-robot",count=300},
		{name="landfill",count=5000},
		{name="gun-turret",count=50},	
		{name="firearm-magazine",count=600},
		{name="medium-electric-pole",count=50},
		{name="big-electric-pole",count=150},
	--	{name="boiler",count=8},
		{name="steam-engine",count=50},
		{name="electric-mining-drill",count=150},
		{name="fast-inserter",count=100},
		{name="filter-inserter",count=50},
		{name="transport-belt",count=400},
		
		{name="locomotive",count=10},
		{name="cargo-wagon",count=20},
		{name="rail-chain-signal",count=150},
		{name="rail-signal",count=100},
		{name="rail",count=1000},
		{name="iron-plate",count=400},
		{name="copper-plate",count=200},
		{name="logistic-train-stop",count=20},
		{name="steel-chest",count=100},
--		{name="loader",count=50},
		{name="deadlock-loader-item-1",count=50},
		{name="steel-plate",count=200},
		{name="stone-brick",count=100},
		
		
		{name="constant-combinator",count=50},
		{name="decider-combinator",count=50},
		{name="arithmetic-combinator",count=50},
		},

	quick={
		{name="medium-electric-pole",count=50},
		{name="transport-belt",count=200},
		{name="fast-inserter",count=200},
		{name="assembling-machine-3",count=5},
		{name="steel-chest",count=50},	
--		{name="loader",count=50},
		{name="deadlock-loader-item-1",count=50},
		{name="small-lamp",count=50},
		{name="rail",count=1000},
		{name="electric-mining-drill",count=50},
		},
	researched_techs = {
		["electronics"]=true,
		["logistics"]=true,
		["automation"]=true,
		["automation-2"]=true,
		["circuit-network"]=true,

		["rail-signals"]=true,
		["automated-rail-transportation"]=true,
		["railway"]=true,
		["steel"]=true,
		["steel-processing"]=true,
		["beltplanner"]=true,
		}		
	}
	


local small_kit = 
	{
	chest = {
		{name="transport-belt",count=800},
		{name="raw-wood",count=1000},
		{name="iron-plate",count=10000},
		{name="copper-plate",count=6000},
		{name="steel-plate",count=1000},
		{name="stone-brick",count=1000},
		{name="stone",count=200},
		{name="steel-chest",count=50},
--		{name="glass",count=2000},
		{name="landfill",count=5000},
		{name="constant-combinator",count=50},
		{name="decider-combinator",count=50},
		{name="arithmetic-combinator",count=50},
		{name="medium-electric-pole",count=500},
		{name="inserter",count=100},
		{name="assembling-machine-1",count=50},
		{name="roboport",count=2},
		{name="logistic-robot",count=100},
		{name="construction-robot",count=50},
		{name="logistic-chest-passive-provider",count=100},
		{name="logistic-chest-storage",count=50},
		{name="logistic-chest-requester",count=100},
		},
	inv = {
		{name="medium-electric-pole",count=100},
		{name="gun-turret",count=50},	
		{name="firearm-magazine",count=500},
		{name="boiler",count=50},
		{name="steam-engine",count=50},
		{name="inserter",count=100},
		{name="transport-belt",count=400},
		
		{name="iron-plate",count=5000},
		{name="copper-plate",count=3000},
		{name="steel-chest",count=50},
		{name="loader",count=50},
		{name="steel-plate",count=200},
		{name="stone-brick",count=100},
		},

	quick={
		{name="medium-electric-pole",count=50},
		{name="transport-belt",count=200},
		{name="inserter",count=50},
		{name="assembling-machine-1",count=50},
		{name="steel-chest",count=50},	
		{name="loader",count=50},
		{name="small-lamp",count=50},
		{name="electric-mining-drill",count=20},
		},
	researched_techs = {
		["electronics"]=true,
		["logistics"]=true,
		["automation"]=true,
		["circuit-network"]=true,
		["steel"]=true,
		["steel-processing"]=true,
		["beltplanner"]=true,
		}		
	}
	


local smallest_kit = 
	{
	inv = {
		{name="transport-belt",count=600},
		{name="inserter",count=100},
		{name="landfill",count=5000},
		{name="medium-electric-pole",count=500},
		{name="big-electric-pole",count=50},
		{name="gun-turret",count=50},
		{name="boiler",count=1},
		{name="steam-engine",count=1},
		{name="assembling-machine-2",count=5},
		{name="electric-mining-drill",count=5},
		{name="stone",count=200},
		{name="raw-wood",count=200},
		{name="iron-plate",count=200},
		{name="copper-plate",count=100},
		
		{name="roboport",count=2},
		{name="logistic-robot",count=200},
		{name="construction-robot",count=100},
		{name="logistic-chest-passive-provider",count=200},
		{name="logistic-chest-storage",count=4},
		{name="logistic-chest-requester",count=200},
		},

	quick={},
	researched_techs = {
		["automation"]=true,
		["circuit-network"]=true,
		["beltplanner"]=true,
	}
	}

local smallest_kit2 = 
	{
	inv = {
		{name="landfill",count=5000},
		{name="boiler",count=1},
		{name="steam-engine",count=1},
		{name="assembling-machine-2",count=5},
		{name="electric-mining-drill",count=5},
		{name="stone",count=200},
		{name="raw-wood",count=200},
		{name="iron-plate",count=200},
		{name="copper-plate",count=100},
		},

	quick={},
	researched_techs = {
		["automation"]=true,
		["circuit-network"]=true,
		["beltplanner"]=true,
	}
	}



current_kit = smallest_kit2