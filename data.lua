
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

local ability_subgroup = {
    type = "item-subgroup",
    name = "abilities",
    group = "combat",
    order = "aa-1",
}
data:extend{ability_subgroup}

local unlock_ability_recipe = {
    type = "recipe",
    name = "unlock-ability",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 250 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 50, amount_max = 200 }
    },
    localised_name = { "recipe-name.unlock-ability" },
    subgroup = "abilities",
    order = "abilities-[a]-[1]",
    icon = data.raw["capsule"]["artillery-targeting-remote"].icon,
    icon_size = data.raw["capsule"]["artillery-targeting-remote"].icon_size,
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
data:extend{unlock_ability_recipe}

local extra_life_recipe = {
    type = "recipe",
    name = "extra-life",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 500 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 50, amount_max = 200 }
    },
    localised_name = { "recipe-name.extra-life" },
    subgroup = "abilities",
    order = "abilities-[a]-[2]",
    icon = data.raw["tool"]["automation-science-pack"].icon,
    icon_size = data.raw["tool"]["automation-science-pack"].icon_size,
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
data:extend{extra_life_recipe}

local restore_health_recipe = {
    type = "recipe",
    name = "restore-health",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 250 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 50, amount_max = 200 }
    },
    localised_name = { "recipe-name.restore-health" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[4]",
    icon = data.raw["capsule"]["raw-fish"].icon,
    icon_size = data.raw["capsule"]["raw-fish"].icon_size,
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
data:extend{restore_health_recipe}

local repair_armor_recipe = {
    type = "recipe",
    name = "repair-armor",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 250 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 50, amount_max = 200 }
    },
    localised_name = { "recipe-name.repair-armor" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[5]",
    icon = data.raw["repair-tool"]["repair-pack"].icon,
    icon_size = data.raw["repair-tool"]["repair-pack"].icon_size,
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
data:extend{repair_armor_recipe}

local technology_subgroup = {
    type = "item-subgroup",
    name = "technologies",
    group = "combat",
    order = "tt-1",
}
data:extend{technology_subgroup}

local infinite_technology_unit = {
    count_formula = "L",
    ingredients =
    {
        { "automation-science-pack", 1 },
        -- { "logistic-science-pack",   1 },
        -- { "chemical-science-pack",   1 },
        -- { "military-science-pack",   1 },
        -- { "utility-science-pack",    1 },
        -- { "space-science-pack",      1 }
    },
    time = 60
}

local follower_robot_count_technology = deepcopy(data.raw["technology"]["follower-robot-count-7"])
follower_robot_count_technology.name = "rogue-follower-robot-count"
follower_robot_count_technology.prerequisites = nil
follower_robot_count_technology.unit = infinite_technology_unit
follower_robot_count_technology.max_level = "infinite"
follower_robot_count_technology.effects = {
    {
        type = "maximum-following-robots-count",
        modifier = 1
    }
}
data:extend{follower_robot_count_technology}

local follower_robot_count_recipe = {
    type = "recipe",
    name = "follower-robot-count",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 10, amount_max = 50 }
    },
    localised_name = { "technology-name.rogue-follower-robot-count"},
    localised_description = { "technology-description.rogue-follower-robot-count"},
    subgroup = "technologies",
    order = "technologies-[a]-[1]",
    icon = deepcopy(data.raw["technology"]["follower-robot-count-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["follower-robot-count-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["follower-robot-count-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
for _, icon_data in pairs(follower_robot_count_recipe.icons) do
    if icon_data.shift then
        icon_data.shift[1] = icon_data.shift[1] / -15
        icon_data.shift[2] = icon_data.shift[2] / 8
    end
end
data:extend{follower_robot_count_recipe}

local physical_projectile_damage_technology = deepcopy(data.raw["technology"]["physical-projectile-damage-7"])
physical_projectile_damage_technology.name = "rogue-physical-projectile-damage"
physical_projectile_damage_technology.prerequisites = nil
physical_projectile_damage_technology.unit = infinite_technology_unit
physical_projectile_damage_technology.max_level = "infinite"
physical_projectile_damage_technology.effects = {
    {
        type = "ammo-damage",
        ammo_category = "bullet",
        modifier = 0.1
    },
    {
        type = "turret-attack",
        turret_id = "gun-turret",
        modifier = 0.1
    },
    {
        type = "ammo-damage",
        ammo_category = "shotgun-shell",
        modifier = 0.1
    },
    {
        type = "ammo-damage",
        ammo_category = "cannon-shell",
        modifier = 0.1
    }
}
data:extend{physical_projectile_damage_technology}

local physical_projectile_damage_recipe = {
    type = "recipe",
    name = "physical-projectile-damage",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 10, amount_max = 50 }
    },
    localised_name = { "technology-name.rogue-physical-projectile-damage"},
    localised_description = { "technology-description.rogue-physical-projectile-damage"},
    subgroup = "technologies",
    order = "technologies-[weapon]-[damage]",
    icon = deepcopy(data.raw["technology"]["physical-projectile-damage-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["physical-projectile-damage-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["physical-projectile-damage-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
for _, icon_data in pairs(physical_projectile_damage_recipe.icons) do
    if icon_data.shift then
        icon_data.shift[1] = icon_data.shift[1] / -15
        icon_data.shift[2] = icon_data.shift[2] / 8
    end
end
data:extend{physical_projectile_damage_recipe}

local energy_weapons_damage_technology = deepcopy(data.raw["technology"]["energy-weapons-damage-7"])
energy_weapons_damage_technology.name = "rogue-energy-weapons-damage"
energy_weapons_damage_technology.prerequisites = nil
energy_weapons_damage_technology.unit = infinite_technology_unit
energy_weapons_damage_technology.max_level = "infinite"
energy_weapons_damage_technology.effects = {
    {
        type = "ammo-damage",
        ammo_category = "laser",
        modifier = 0.1
    },
    {
        type = "ammo-damage",
        ammo_category = "electric",
        modifier = 0.1
    },
    {
        type = "ammo-damage",
        ammo_category = "beam",
        modifier = 0.1
    }
}
data:extend{energy_weapons_damage_technology}

local energy_weapons_damage_recipe = {
    type = "recipe",
    name = "energy-weapons-damage",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 10, amount_max = 50 }
    },
    localised_name = { "technology-name.rogue-energy-weapons-damage"},
    localised_description = { "technology-description.rogue-energy-weapons-damage"},
    subgroup = "technologies",
    order = "technologies-[laser]-[damage]",
    icon = deepcopy(data.raw["technology"]["energy-weapons-damage-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["energy-weapons-damage-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["energy-weapons-damage-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
for _, icon_data in pairs(energy_weapons_damage_recipe.icons) do
    if icon_data.shift then
        icon_data.shift[1] = icon_data.shift[1] / -15
        icon_data.shift[2] = icon_data.shift[2] / 8
    end
end
data:extend{energy_weapons_damage_recipe}

local stronger_explosives_technology = deepcopy(data.raw["technology"]["stronger-explosives-7"])
stronger_explosives_technology.name = "rogue-stronger-explosives"
stronger_explosives_technology.prerequisites = nil
stronger_explosives_technology.unit = infinite_technology_unit
stronger_explosives_technology.max_level = "infinite"
stronger_explosives_technology.effects = {
    {
        type = "ammo-damage",
        ammo_category = "rocket",
        modifier = 0.1
    },
    {
        type = "ammo-damage",
        ammo_category = "grenade",
        modifier = 0.1
    },
    {
        type = "ammo-damage",
        ammo_category = "landmine",
        modifier = 0.1
    }
}
data:extend{stronger_explosives_technology}

local stronger_explosives_recipe = {
    type = "recipe",
    name = "stronger-explosives",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 10, amount_max = 50 }
    },
    localised_name = { "technology-name.rogue-stronger-explosives"},
    localised_description = { "technology-description.rogue-stronger-explosives"},
    subgroup = "technologies",
    order = "technologies-[explosives]-[damage]",
    icon = deepcopy(data.raw["technology"]["stronger-explosives-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["stronger-explosives-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["stronger-explosives-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
for _, icon_data in pairs(stronger_explosives_recipe.icons) do
    if icon_data.shift then
        icon_data.shift[1] = icon_data.shift[1] / -15
        icon_data.shift[2] = icon_data.shift[2] / 8
    end
end
data:extend{stronger_explosives_recipe}

local refined_flammables_technology = deepcopy(data.raw["technology"]["refined-flammables-7"])
refined_flammables_technology.name = "rogue-refined-flammables"
refined_flammables_technology.prerequisites = nil
refined_flammables_technology.unit = infinite_technology_unit
refined_flammables_technology.max_level = "infinite"
refined_flammables_technology.effects = {
    {
        type = "ammo-damage",
        ammo_category = "flamethrower",
        modifier = 0.1
    },
    {
        type = "turret-attack",
        turret_id = "flamethrower-turret",
        modifier = 0.1
    }
}
data:extend{refined_flammables_technology}

local refined_flammables_recipe = {
    type = "recipe",
    name = "refined-flammables",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 10, amount_max = 50 }
    },
    localised_name = { "technology-name.rogue-refined-flammables"},
    localised_description = { "technology-description.rogue-refined-flammables"},
    subgroup = "technologies",
    order = "technologies-[flammables]-[damage]",
    icon = deepcopy(data.raw["technology"]["refined-flammables-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["refined-flammables-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["refined-flammables-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
for _, icon_data in pairs(refined_flammables_recipe.icons) do
    if icon_data.shift then
        icon_data.shift[1] = icon_data.shift[1] / -15
        icon_data.shift[2] = icon_data.shift[2] / 8
    end
end
data:extend{refined_flammables_recipe}

local weapon_shooting_speed_technology = deepcopy(data.raw["technology"]["weapon-shooting-speed-6"])
weapon_shooting_speed_technology.name = "rogue-weapon-shooting-speed"
weapon_shooting_speed_technology.prerequisites = nil
weapon_shooting_speed_technology.unit = infinite_technology_unit
weapon_shooting_speed_technology.max_level = "infinite"
weapon_shooting_speed_technology.effects = {
    {
        type = "gun-speed",
        ammo_category = "bullet",
        modifier = 0.1
    },
    {
        type = "gun-speed",
        ammo_category = "shotgun-shell",
        modifier = 0.1
    },
    {
        type = "gun-speed",
        ammo_category = "cannon-shell",
        modifier = 1.1
    },
    {
        type = "gun-speed",
        ammo_category = "rocket",
        modifier = 0.1
    }
}
data:extend{weapon_shooting_speed_technology}

local weapon_shooting_speed_recipe = {
    type = "recipe",
    name = "weapon-shooting-speed",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 10, amount_max = 50 }
    },
    localised_name = { "technology-name.rogue-weapon-shooting-speed"},
    localised_description = { "technology-description.rogue-weapon-shooting-speed"},
    subgroup = "technologies",
    order = "technologies-[weapon]-[speed]",
    icon = deepcopy(data.raw["technology"]["weapon-shooting-speed-6"].icon),
    icon_size = deepcopy(data.raw["technology"]["weapon-shooting-speed-6"].icon_size),
    icons = deepcopy(data.raw["technology"]["weapon-shooting-speed-6"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
for _, icon_data in pairs(weapon_shooting_speed_recipe.icons) do
    if icon_data.shift then
        icon_data.shift[1] = icon_data.shift[1] / -15
        icon_data.shift[2] = icon_data.shift[2] / 8
    end
end
data:extend{weapon_shooting_speed_recipe}

local laser_shooting_speed_technology = deepcopy(data.raw["technology"]["laser-shooting-speed-6"])
laser_shooting_speed_technology.name = "rogue-laser-shooting-speed"
laser_shooting_speed_technology.prerequisites = nil
laser_shooting_speed_technology.unit = infinite_technology_unit
laser_shooting_speed_technology.max_level = "infinite"
laser_shooting_speed_technology.effects = {
    {
        type = "gun-speed",
        ammo_category = "laser",
        modifier = 0.1
    }
}
data:extend{laser_shooting_speed_technology}

local laser_shooting_speed_recipe = {
    type = "recipe",
    name = "laser-shooting-speed",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 10, amount_max = 50 }
    },
    localised_name = { "technology-name.rogue-laser-shooting-speed"},
    localised_description = { "technology-description.rogue-laser-shooting-speed"},
    subgroup = "technologies",
    order = "technologies-[laser]-[speed]",
    icon = deepcopy(data.raw["technology"]["laser-shooting-speed-6"].icon),
    icon_size = deepcopy(data.raw["technology"]["laser-shooting-speed-6"].icon_size),
    icons = deepcopy(data.raw["technology"]["laser-shooting-speed-6"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 10,
}
for _, icon_data in pairs(laser_shooting_speed_recipe.icons) do
    if icon_data.shift then
        icon_data.shift[1] = icon_data.shift[1] / -15
        icon_data.shift[2] = icon_data.shift[2] / 8
    end
end
data:extend{laser_shooting_speed_recipe}
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
