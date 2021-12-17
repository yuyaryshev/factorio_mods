----Pollution Clean Factor----
EmissionsFactor = 10  --Defualt 10
--put a negative number ex:-100 to make trees produce pollution.

----Tree Collision Fix----
TreeCollision = true  --Defualt true
--This makes it easyer to walk through forest.

----Tree Loot----
TreeLoot = true  --Defualt false
--If tree is killed then drops 1-2 raw-wood.
--Percent drop mirriors rocks 1/4 to 1/2 minable quantity.

-- Cull Trees Rate (0 doesn't remove any trees (0% removal chance), 1 removes all trees (100% removal chance).)
removeTrees = 1.0-1.0/math.abs(EmissionsFactor)

-- Cull Rocks Rate (same as above but for rocks)
removeRocks = 0


