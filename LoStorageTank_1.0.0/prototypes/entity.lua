data.raw["item"]["storage-tank"].stack_size = 10
data.raw["storage-tank"]["storage-tank"].fast_replaceable_group = "storage-tank"

local tank2 = copyPrototype("storage-tank", "storage-tank", "lo-storage-tank")
tank2.max_health = 10000
tank2.fluid_box =
{
  base_area = 10000,
  pipe_covers = pipecoverspictures(),
  pipe_connections =
  {
    { position = {-1, -2} },
    { position = {2, 1} },
    { position = {1, 2} },
    { position = {-2, -1} },
    { position = {1, -2} },
    { position = {2, -1} },
    { position = {-2, 1} },
    { position = {-1, 2} },
  }
}
tank2.rotatable = false
tank2.two_direction_only = true
tank2.pictures.picture =
{
  sheet =
  {
    filename = "__LoStorageTank__/graphics/entity/lo-storage-tank.png",
    priority = "extra-high",
    frames = 1,
    width = 140,
    height = 115,
    shift = {0.6875, 0.109375}
  }
}

data:extend({
  tank2
})


local tank3 = copyPrototype("storage-tank", "lo-storage-tank", "lo-storage-tank2")
tank3.max_health = 200000
tank3.fluid_box.base_area = 320000
tank3.pictures.picture.sheet.filename = "__LoStorageTank__/graphics/entity/lo-storage-tank2.png"

data:extend({
  tank3
})


local tank4 = copyPrototype("storage-tank", "lo-storage-tank", "lo-storage-tank3")
tank4.max_health = 200000
tank4.fluid_box.base_area = 1000000000
tank4.pictures.picture.sheet.filename = "__LoStorageTank__/graphics/entity/lo-storage-tank3.png"

data:extend({
  tank4
})