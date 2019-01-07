data:extend({
    {
        type = "bool-setting",
        name = "ReallyPressureTanks_enable",
        localised_name = "Enable Really Pressure Tanks",
        localised_description = "Converts all items with type='storage-tank' and specified name and capacity to high pressure tanks. Will affect vanilla and modded items.",
        setting_type = "startup",
        default_value = true
    },
    {
        type = "string-setting",
        name = "ReallyPressureTanks_name_mask",
        localised_name = "Name mask",
        localised_description = "Only convert into pressure tank if internal entity's name contain this string.",
        setting_type = "startup",
        default_value = "tank"
    },
    {
        type = "double-setting",
        name = "ReallyPressureTanks_min_capacity",
        localised_name = "Min capacity",
        localised_description = "Only convert into pressure tank if internal entity's capacity is more than this value",
        setting_type = "startup",
        default_value = 10.0
    },
    {
        type = "bool-setting",
        name = "ReallyPressureTanks_upgrade_pumps",
        localised_name = "Upgrade pumps",
        localised_description = "Upgrades all pumps (type=='pump'). Pressure difference will much less affect pumps. You'll have hard time filling a pressure tank without this up to 100% full.",
        setting_type = "startup",
        default_value = true
    },	
})