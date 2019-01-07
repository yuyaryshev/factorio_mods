
-- Code and resources adapted from GotLag's FlowControl, MIT licence - thanks!
-- I'd be very happy if you merge-in my mod to yours with a setting (alike Enable Really High Pressure Tanks)
local empty_sprite =
{
  filename = "__core__/graphics/empty.png",
  priority = "extra-high",
  width = 1,
  height = 1,
  frame_count = 1
}

-- Pipe Elbow ****************************************************************************
local pipe_elbow = util.table.deepcopy(data.raw["storage-tank"]["storage-tank"])
pipe_elbow.name = "pipe-elbow"
pipe_elbow.icon = "__ReallyPressureTanks__/graphics/icon/pipe-elbow.png"
pipe_elbow.minable = data.raw["pipe"]["pipe"].minable
pipe_elbow.corpse = "small-remnants"
pipe_elbow.max_health = data.raw["pipe"]["pipe"].max_health
pipe_elbow.resistances = data.raw["pipe"]["pipe"].resistances
pipe_elbow.fast_replaceable_group = data.raw["pipe"]["pipe"].fast_replaceable_group
pipe_elbow.collision_box = data.raw["pipe"]["pipe"].collision_box
pipe_elbow.selection_box = data.raw["pipe"]["pipe"].selection_box
pipe_elbow.fluid_box =
{
  base_area = 1,
  pipe_covers = pipecoverspictures(),
  pipe_connections =
  {
    { position = {1, 0} },
    { position = {0, 1} }
  },
}
pipe_elbow.two_direction_only = false
pipe_elbow.pictures =
{
  picture =
  {
    north = pipepictures().corner_down_right,
    east = pipepictures().corner_down_left,
    south = pipepictures().corner_up_left,
    west = pipepictures().corner_up_right
  },
  gas_flow = empty_sprite,
  fluid_background = empty_sprite,
  window_background = empty_sprite,
  flow_sprite = empty_sprite
}
pipe_elbow.circuit_wire_max_distance = 0
pipe_elbow.working_sound = nil

-- Pipe Junction *************************************************************************
local pipe_junction = util.table.deepcopy(pipe_elbow)
pipe_junction.name = "pipe-junction"
pipe_junction.icon = "__ReallyPressureTanks__/graphics/icon/pipe-junction.png"
pipe_junction.fluid_box.pipe_connections =
{
  { position = {1, 0} },
  { position = {0, 1} },
  { position = {-1, 0} }
}
-- pipe_junction.pictures.picture.sheet.filename =
  -- "__ReallyPressureTanks__/graphics/entity/pipes/pipe-junction.png"
pipe_junction.pictures =
{
  picture =
  {
    north = pipepictures().t_down,
    east = pipepictures().t_left,
    south = pipepictures().t_up,
    west = pipepictures().t_right
  },
  gas_flow = empty_sprite,
  fluid_background = empty_sprite,
  window_background = empty_sprite,
  flow_sprite = empty_sprite
}

-- Pipe Straight *************************************************************************
local pipe_straight = util.table.deepcopy(pipe_elbow)
pipe_straight.name = "pipe-straight"
pipe_straight.icon = "__ReallyPressureTanks__/graphics/icon/pipe-straight.png"
pipe_straight.fluid_box.pipe_connections =
{
  { position = {0, -1} },
  { position = {0, 1} }
}
pipe_straight.pictures =
{
  picture =
  {
    north = pipepictures().straight_vertical,
    east = pipepictures().straight_horizontal,
    south = pipepictures().straight_vertical,
    west = pipepictures().straight_horizontal
  },
  gas_flow = empty_sprite,
  fluid_background = empty_sprite,
  window_background = empty_sprite,
  flow_sprite = empty_sprite
}

-- Check Valve ***************************************************************************
local check_valve = util.table.deepcopy(pipe_straight)
check_valve.name = "check-valve"
check_valve.icon = "__ReallyPressureTanks__/graphics/icon/check-valve.png"
check_valve.minable = {mining_time = 1, result = "check-valve"}
check_valve.fluid_box =
{
  base_area = 1,
  pipe_covers = pipecoverspictures(),
  pipe_connections =
  {
    { position = {0, 1}, type="output" },
    { position = {0, -1} }
  },
}
check_valve.pictures.picture =
{
  sheet =
  {
    filename = "__ReallyPressureTanks__/graphics/entity/check-valve/check-valve.png",
    priority = "extra-high",
    frames = 4,
    width = 58,
    height = 55,
    shift = {0.28125, -0.078125}
  }
}
check_valve.circuit_wire_connection_points =
{
  {
    shadow =
    {
      red = {0.171875, 0.140625},
      green = {0.171875, 0.265625},
    },
    wire =
    {
      red = {-0.53125, -0.15625},
      green = {-0.53125, 0},
    }
  },
  {
    shadow =
    {
      red = {0.890625, 0.703125},
      green = {0.75, 0.75},
    },
    wire =
    {
      red = {0.34375, 0.28125},
      green = {0.34375, 0.4375},
    }
  },
  {
    shadow =
    {
      red = {0.15625, 0.0625},
      green = {0.09375, 0.125},
    },
    wire =
    {
      red = {-0.53125, -0.09375},
      green = {-0.53125, 0.03125},
    }
  },
  {
    shadow =
    {
      red = {0.796875, 0.703125},
      green = {0.625, 0.75},
    },
    wire =
    {
      red = {0.40625, 0.28125},
      green = {0.40625, 0.4375},
    }
  }
}
check_valve.circuit_connector_sprites = circuit_connector_definitions["inserter"].sprites
-- {
  -- get_circuit_connector_sprites({-0.40625, -0.3125}, nil, 24),
  -- get_circuit_connector_sprites({0.125, 0.21875}, {0.34375, 0.40625}, 18),
  -- get_circuit_connector_sprites({-0.40625, -0.25}, nil, 24),
  -- get_circuit_connector_sprites({0.203125, 0.203125}, {0.25, 0.40625}, 18),
-- }
check_valve.circuit_wire_max_distance =
  data.raw["storage-tank"]["storage-tank"].circuit_wire_max_distance

local high_valves_level = 0.95
  
-- High Overflow Valve ************************************************************************
local high_overflow_valve = util.table.deepcopy(check_valve)
high_overflow_valve.name = "high-overflow-valve"
high_overflow_valve.icon = "__ReallyPressureTanks__/graphics/icon/high-overflow-valve.png"
high_overflow_valve.minable.result = "high-overflow-valve"
high_overflow_valve.fluid_box.base_level = 1 + high_valves_level
high_overflow_valve.pictures.picture.sheet.filename =
  "__ReallyPressureTanks__/graphics/entity/high-overflow-valve/high-overflow-valve.png"

-- High Underflow Valve ***********************************************************************
local high_underflow_valve = util.table.deepcopy(high_overflow_valve)
high_underflow_valve.name = "high-underflow-valve"
high_underflow_valve.icon = "__ReallyPressureTanks__/graphics/icon/high-underflow-valve.png"
high_underflow_valve.minable.result = "high-underflow-valve"
high_underflow_valve.fluid_box.base_level = high_valves_level
high_underflow_valve.pictures.picture.sheet.filename =
  "__ReallyPressureTanks__/graphics/entity/high-underflow-valve/high-underflow-valve.png"
  
-- High pipe ***********************************************************************
local high_pipe = util.table.deepcopy(data.raw["pipe"]["pipe"])
high_pipe.name = "high-pipe"
high_pipe.icon = "__ReallyPressureTanks__/graphics/icon/high-pipe.png"
high_pipe.minable.result = "pipe"
high_pipe.fluid_box.base_level = 1
high_pipe.placeable_by = {item = "pipe", count = 1}
--high_underflow_valve.pictures.picture.sheet.filename = "__ReallyPressureTanks__/graphics/entity/high-underflow-valve/high-underflow-valve.png"

-- Insert Entities ***********************************************************************
data:extend(
{
  high_overflow_valve,
  high_underflow_valve,
  high_pipe,
})