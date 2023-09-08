
local constants = require("__rogue_engineer__/constants")

for animation_name, animation_data in pairs(constants.ability_data) do
    local animation = {
        type = "animation",
        name = animation_name,
        filename = "__rogue_engineer__/graphics/" .. animation_data.filename,
        width = animation_data.width,
        height = animation_data.height,
        frame_count = animation_data.frame_count,
        line_length = animation_data.line_length,
        animation_speed = 1,
        scale = 1,
    }
    data:extend{animation}
end

for _, character_prototype in pairs(data.raw.character) do
    character_prototype.healing_per_tick = 0
end

local discharge_defender = table.deepcopy(data.raw["combat-robot"]["defender"])
discharge_defender.name = "discharge-defender"
discharge_defender.attack_parameters = table.deepcopy(data.raw["active-defense-equipment"]["discharge-defense-equipment"].attack_parameters)
discharge_defender.attack_parameters.cooldown = 60 * 33
discharge_defender.time_to_live = 60 * 60 * 1.125
data:extend{discharge_defender}

local no_damage_laser_beam = table.deepcopy(data.raw["beam"]["laser-beam"])
no_damage_laser_beam.name = "no-damage-laser-beam"
no_damage_laser_beam.action = nil
data:extend{no_damage_laser_beam}

local font_size = 25

local arena_gui_font_default = table.deepcopy(data.raw["font"]["default"])
arena_gui_font_default.name = "arena-gui-default"
arena_gui_font_default.size = font_size
data:extend{arena_gui_font_default}

local arena_gui_font_default_semibold = table.deepcopy(data.raw["font"]["default-semibold"])
arena_gui_font_default_semibold.name = "arena-gui-default-semibold"
arena_gui_font_default_semibold.size = font_size
data:extend{arena_gui_font_default_semibold}

local arena_gui_font_default_bold = table.deepcopy(data.raw["font"]["default-bold"])
arena_gui_font_default_bold.name = "arena-gui-default-bold"
arena_gui_font_default_bold.size = font_size
data:extend{arena_gui_font_default_bold}

local light_armor = data.raw["armor"]["light-armor"]
light_armor.infinite = false
light_armor.durability = 100

local heavy_armor = data.raw["armor"]["heavy-armor"]
heavy_armor.infinite = false
heavy_armor.durability = 150

local modular_armor = data.raw["armor"]["modular-armor"]
modular_armor.infinite = false
modular_armor.durability = 200

local power_armor = data.raw["armor"]["power-armor"]
power_armor.infinite = false
power_armor.durability = 250

local power_armor_mk2 = data.raw["armor"]["power-armor-mk2"]
power_armor_mk2.infinite = false
power_armor_mk2.durability = 300

}
}

local health_bonus_recipe = {
    type = "recipe",
    name = "health-bonus",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 250 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 50, amount_max = 200 }
    },
    localised_name = { "recipe-name.health-bonus" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[3]",
    icon = data.raw["unit"]["small-biter"].icon,
    icon_size = data.raw["unit"]["small-biter"].icon_size,
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 2.5,
}
data:extend{health_bonus_recipe}

local raw_fish = data.raw["capsule"]["raw-fish"]
local cluster_grenade = data.raw["capsule"]["cluster-grenade"]
raw_fish.stack_size = 1
raw_fish.capsule_action = cluster_grenade.capsule_action
raw_fish.subgroup = "rogue-engineer"
raw_fish.order = "rogue-[b]-[1]"

for _, fish in pairs(data.raw["fish"]) do
    if fish.mineable then
        if fish.mineable.results then
            for _, result in pairs(fish.mineable.results) do
                result.amount = 1
            end
        end
        if fish.mineable.result then
            fish.mineable.count = 1
        end
    end
end

data.raw["item"]["coin"].stack_size = 250
