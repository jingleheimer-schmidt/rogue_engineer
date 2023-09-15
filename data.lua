
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

local enemy_loot = {
    ["unit"] = {
        ["small-biter"] = { min = 1, max = 10 },
        ["small-spitter"] = { min = 5, max = 15 },
        ["medium-biter"] = { min = 5, max = 20 },
        ["medium-spitter"] = { min = 10, max = 25 },
        ["big-biter"] = { min = 10, max = 30 },
        ["big-spitter"] = { min = 15, max = 35 },
        ["behemoth-biter"] = { min = 15, max = 40 },
        ["behemoth-spitter"] = { min = 20, max = 45 },
    },
    ["turret"] = {
        ["small-worm-turret"] = { min = 5, max = 25 },
        ["medium-worm-turret"] = { min = 10, max = 35 },
        ["big-worm-turret"] = { min = 15, max = 45 },
        ["behemoth-worm-turret"] = { min = 20, max = 55 },
    },
    ["unit-spawner"] = {
        ["biter-spawner"] = { min = 25, max = 75 },
        ["spitter-spawner"] = { min = 25, max = 75 },
    },
}
for type, names in pairs(enemy_loot) do
    for name, loot in pairs(names) do
        data.raw[type][name].loot = {
            {
                item = "coin",
                probability = 1,
                count_min = loot.min,
                count_max = loot.max,
            }
        }
    end
end

data.raw["character"]["character"].loot = {
    {
        item = "coin",
        probability = 1,
        count_min = 555,
        count_max = 999,
    }
}

local armor_costs = {
    ["light-armor"] = 500,
    ["heavy-armor"] = 1500,
    ["modular-armor"] = 3000,
    ["power-armor"] = 5000,
    ["power-armor-mk2"] = 8000,
}
for name, cost in pairs(armor_costs) do
    local recipe = data.raw["recipe"][name]
    recipe.ingredients = {
        { "coin", cost },
    }
    recipe.normal = nil
    recipe.expensive = nil
    recipe.enabled = true
    recipe.allow_intermediates = false
    recipe.allow_decomposition = false
    recipe.allow_as_intermediate = false
end

for _, recipe in pairs(data.raw["recipe"]) do
    if not armor_costs[recipe.name] then
        recipe.hide_from_player_crafting = true
        recipe.allow_intermediates = false
        recipe.allow_decomposition = false
        recipe.allow_as_intermediate = false
        if recipe.normal then
            recipe.normal.hide_from_player_crafting = true
            recipe.normal.allow_intermediates = false
            recipe.normal.allow_decomposition = false
            recipe.normal.allow_as_intermediate = false
        end
        if recipe.expensive then
            recipe.expensive.hide_from_player_crafting = true
            recipe.expensive.allow_intermediates = false
            recipe.expensive.allow_decomposition = false
            recipe.expensive.allow_as_intermediate = false
        end
    end
end

local rogue_subgroup = {
    type = "item-subgroup",
    name = "rogue-engineer",
    group = "combat",
    order = "aa-2",
}
data:extend{rogue_subgroup}

local loot_distance_recipe = {
    type = "recipe",
    name = "loot-distance",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 250 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 50, amount_max = 200 }
    },
    localised_name = { "recipe-name.loot-distance" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[1]",
    icon = data.raw["item"]["coin"].icon,
    icon_size = data.raw["item"]["coin"].icon_size,
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
data:extend{loot_distance_recipe}

local running_speed_recipe = {
    type = "recipe",
    name = "running-speed",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 250 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 50, amount_max = 200 }
    },
    localised_name = { "recipe-name.running-speed" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[2]",
    icon = data.raw["character"]["character"].icon,
    icon_size = data.raw["character"]["character"].icon_size,
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
data:extend{running_speed_recipe}

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
    energy_required = 5,
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
