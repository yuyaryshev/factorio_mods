data:extend({
  {
    type = "item-subgroup",
    name = "programmable-combinator-signal",
    group = "signals",
    order = "z[programmable-combinator-signal]"
  },

  {
    type = "virtual-signal",
    name = "programmable-combinator-channel",
    icon = MOD_NAME.."/graphics/programmable-combinator-channel-signal.png",
	icon_size = 32,
    subgroup = "programmable-combinator-signal",
    order = "z[programmable-combinator-signal]"
  },  
})