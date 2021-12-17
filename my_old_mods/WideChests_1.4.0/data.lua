if not MergingChests then MergingChests = {} end

local HardMaxSize = 42

require("config")

if MergingChests.MaxSize < 2 then
	MergingChests.MaxSize = 2
elseif MergingChests.MaxSize > HardMaxSize then
	MergingChests.MaxSize = HardMaxSize
end

require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")