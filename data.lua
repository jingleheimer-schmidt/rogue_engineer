
local constants = require("constants")
require("util")
local deepcopy = util.table.deepcopy

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
    local icon_position = animation_data.icon_position
    local icon = {
        type = "sprite",
        name = animation_name .. "_icon",
        filename = "__rogue_engineer__/graphics/" .. animation_data.filename,
        width = animation_data.width,
        height = animation_data.height,
        scale = 1,
        x = icon_position and icon_position.x or (animation_data.width * 3),
        y = icon_position and icon_position.y or (animation_data.height * ((animation_data.frame_count / animation_data.line_length) / 4)),
    }
    data:extend{icon}
end

for _, character_prototype in pairs(data.raw.character) do
    character_prototype.healing_per_tick = 0
end

local discharge_defender = deepcopy(data.raw["combat-robot"]["defender"])
discharge_defender.name = "discharge-defender"
discharge_defender.attack_parameters = deepcopy(data.raw["active-defense-equipment"]["discharge-defense-equipment"].attack_parameters)
discharge_defender.attack_parameters.cooldown = 60 * 33
discharge_defender.time_to_live = 60 * 60 * 1.125
data:extend{discharge_defender}

local no_damage_laser_beam = deepcopy(data.raw["beam"]["laser-beam"])
no_damage_laser_beam.name = "no-damage-laser-beam"
no_damage_laser_beam.action = nil
data:extend{no_damage_laser_beam}

local font_size = 25

local arena_gui_font_default = deepcopy(data.raw["font"]["default"])
arena_gui_font_default.name = "arena-gui-default"
arena_gui_font_default.size = font_size
data:extend{arena_gui_font_default}

local arena_gui_font_default_semibold = deepcopy(data.raw["font"]["default-semibold"])
arena_gui_font_default_semibold.name = "arena-gui-default-semibold"
arena_gui_font_default_semibold.size = font_size
data:extend{arena_gui_font_default_semibold}

local arena_gui_font_default_bold = deepcopy(data.raw["font"]["default-bold"])
arena_gui_font_default_bold.name = "arena-gui-default-bold"
arena_gui_font_default_bold.size = font_size
data:extend{arena_gui_font_default_bold}

local light_armor = deepcopy(data.raw["armor"]["light-armor"])
light_armor.name = "rogue-light-armor"
light_armor.localised_name = { "item-name.light-armor" }
light_armor.localised_description = { "item-description.light-armor" }
light_armor.infinite = false
light_armor.durability = 100
light_armor.equipment_grid = nil
data:extend{light_armor}

local heavy_armor = deepcopy(data.raw["armor"]["heavy-armor"])
heavy_armor.name = "rogue-heavy-armor"
heavy_armor.localised_name = { "item-name.heavy-armor" }
heavy_armor.localised_description = { "item-description.heavy-armor" }
heavy_armor.infinite = false
heavy_armor.durability = 150
heavy_armor.equipment_grid = nil
data:extend{heavy_armor}

local modular_armor = deepcopy(data.raw["armor"]["modular-armor"])
modular_armor.name = "rogue-modular-armor"
modular_armor.localised_name = { "item-name.modular-armor" }
modular_armor.localised_description = { "item-description.modular-armor" }
modular_armor.infinite = false
modular_armor.durability = 200
modular_armor.equipment_grid = nil
data:extend{modular_armor}

local power_armor = deepcopy(data.raw["armor"]["power-armor"])
power_armor.name = "rogue-power-armor"
power_armor.localised_name = { "item-name.power-armor" }
power_armor.localised_description = { "item-description.power-armor" }
power_armor.infinite = false
power_armor.durability = 250
power_armor.equipment_grid = nil
data:extend{power_armor}

local power_armor_mk2 = deepcopy(data.raw["armor"]["power-armor-mk2"])
power_armor_mk2.name = "rogue-power-armor-mk2"
power_armor_mk2.localised_name = { "item-name.power-armor-mk2" }
power_armor_mk2.localised_description = { "item-description.power-armor-mk2" }
power_armor_mk2.infinite = false
power_armor_mk2.durability = 300
power_armor_mk2.equipment_grid = nil
data:extend{power_armor_mk2}

local enemy_loot = {
    ["unit"] = {
        ["small-biter"] = { min = 1, max = 10 },
        ["small-armoured-biter"] = { min = 1, max = 10 },
        ["small-spitter"] = { min = 5, max = 15 },
        ["medium-biter"] = { min = 5, max = 20 },
        ["medium-armoured-biter"] = { min = 5, max = 20 },
        ["medium-spitter"] = { min = 10, max = 25 },
        ["big-biter"] = { min = 10, max = 30 },
        ["big-armoured-biter"] = { min = 10, max = 30 },
        ["big-spitter"] = { min = 15, max = 35 },
        ["behemoth-biter"] = { min = 15, max = 40 },
        ["behemoth-armoured-biter"] = { min = 15, max = 40 },
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
        local enemy = data.raw[type][name] --[[@type data.UnitPrototype|data.TurretPrototype|data.EnemySpawnerPrototype]]
        enemy.loot = {
            {
                item = "coin",
                probability = 1,
                count_min = loot.min,
                count_max = loot.max,
            }
        }
        if enemy.movement_speed then
            enemy.movement_speed = enemy.movement_speed * 0.55
        end
    end
end

data.raw["character"]["character"].loot = {
    {
        item = "coin",
        probability = 1,
        count_min = 25,
        count_max = 55,
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
    local recipe = deepcopy(data.raw["recipe"][name])
    recipe.name = "rogue-" .. name
    recipe.result = "rogue-" .. name
    recipe.ingredients = { { "coin", cost } }
    recipe.normal = nil
    recipe.expensive = nil
    recipe.results = nil
    recipe.enabled = true
    recipe.allow_intermediates = false
    recipe.allow_decomposition = false
    recipe.allow_as_intermediate = false
    data:extend{recipe}
end

local function shift_bonus_icon_from_tech_to_recipe(recipe)
    for _, icon_data in pairs(recipe.icons) do
        if icon_data.shift then
            icon_data.shift[1] = icon_data.shift[1] / -15
            icon_data.shift[2] = icon_data.shift[2] / 8
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

local loot_distance_icon = util.technology_icon_constant_range()[2]
local movement_speed_icon = util.technology_icon_constant_movement_speed()[2]
local productivity_icon = util.technology_icon_constant_productivity()[2]

local loot_distance_recipe = {
    type = "recipe",
    name = "loot-distance",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 150 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 1, amount_max = 15 }
    },
    localised_name = { "recipe-name.loot-distance" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[3]",
    icon = deepcopy(data.raw["item"]["coin"].icon),
    icon_size = deepcopy(data.raw["item"]["coin"].icon_size),
    icons = deepcopy(data.raw["item"]["coin"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 2.5,
}
-- loot_distance_recipe.icons = loot_distance_recipe.icons or {
--     { icon = loot_distance_recipe.icon, icon_size = loot_distance_recipe.icon_size },
-- }
-- table.insert(loot_distance_recipe.icons, loot_distance_icon)
-- shift_bonus_icon_from_tech_to_recipe(loot_distance_recipe)
data:extend{loot_distance_recipe}

local running_speed_recipe = {
    type = "recipe",
    name = "running-speed",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
    },
    localised_name = { "recipe-name.running-speed" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[1]",
    icon = deepcopy(data.raw["character"]["character"].icon),
    icon_size = deepcopy(data.raw["character"]["character"].icon_size),
    icons = deepcopy(data.raw["character"]["character"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 2.5,
}
running_speed_recipe.icons = running_speed_recipe.icons or {
    { icon = running_speed_recipe.icon, icon_size = running_speed_recipe.icon_size },
}
table.insert(running_speed_recipe.icons, movement_speed_icon)
shift_bonus_icon_from_tech_to_recipe(running_speed_recipe)
data:extend{running_speed_recipe}

local health_bonus_recipe = {
    type = "recipe",
    name = "health-bonus",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 100 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
    },
    localised_name = { "recipe-name.health-bonus" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[2]",
    icon = deepcopy(data.raw["unit"]["small-biter"].icon),
    icon_size = deepcopy(data.raw["unit"]["small-biter"].icon_size),
    icons = deepcopy(data.raw["unit"]["small-biter"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 2.5,
}
health_bonus_recipe.icons = health_bonus_recipe.icons or {
    { icon = health_bonus_recipe.icon, icon_size = health_bonus_recipe.icon_size },
}
table.insert(health_bonus_recipe.icons, productivity_icon)
shift_bonus_icon_from_tech_to_recipe(health_bonus_recipe)
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 25 }
    },
    localised_name = { "recipe-name.unlock-ability" },
    subgroup = "abilities",
    order = "abilities-[a]-[1]",
    icon = deepcopy(data.raw["capsule"]["artillery-targeting-remote"].icon),
    icon_size = deepcopy(data.raw["capsule"]["artillery-targeting-remote"].icon_size),
    icons = deepcopy(data.raw["capsule"]["artillery-targeting-remote"].icons),
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 50 }
    },
    localised_name = { "recipe-name.extra-life" },
    subgroup = "abilities",
    order = "abilities-[a]-[2]",
    icon = deepcopy(data.raw["tool"]["automation-science-pack"].icon),
    icon_size = deepcopy(data.raw["tool"]["automation-science-pack"].icon_size),
    icons = deepcopy(data.raw["tool"]["automation-science-pack"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
data:extend{extra_life_recipe}

local vampire_workout_recipe = {
    type = "recipe",
    name = "vampire-strength",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 500 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 1, amount_max = 50 }
    },
    localised_name = { "recipe-name.vampire-strength" },
    subgroup = "abilities",
    order = "abilities-[a]-[3]",
    icon = deepcopy(data.raw["tool"]["space-science-pack"].icon),
    icon_size = deepcopy(data.raw["tool"]["space-science-pack"].icon_size),
    icons = deepcopy(data.raw["tool"]["space-science-pack"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
data:extend{vampire_workout_recipe}

-- local revive_friend_recipe = {
--     type = "recipe",
--     name = "revive-friend",
--     enabled = true,
--     ingredients = {
--         { type = "item", name = "coin", amount = 500 },
--     },
--     results = {
--         { type = "item", name = "coin", amount_min = 1, amount_max = 50 }
--     },
--     localised_name = { "recipe-name.revive-friend" },
--     subgroup = "abilities",
--     order = "abilities-[a]-[4]",
--     icon = deepcopy(data.raw["unit"]["compilatron"].icon),
--     icon_size = deepcopy(data.raw["unit"]["compilatron"].icon_size),
--     icons = deepcopy(data.raw["unit"]["compilatron"].icons),
--     allow_intermediates = false,
--     allow_decomposition = false,
--     allow_as_intermediate = false,
--     show_amount_in_title = false,
--     energy_required = 10,
-- }
-- data:extend{revive_friend_recipe}

local restore_health_recipe = {
    type = "recipe",
    name = "restore-health",
    enabled = true,
    ingredients = {
        { type = "item", name = "coin", amount = 250 },
    },
    results = {
        { type = "item", name = "coin", amount_min = 1, amount_max = 25 }
    },
    localised_name = { "recipe-name.restore-health" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[4]",
    icon = deepcopy(data.raw["capsule"]["raw-fish"].icon),
    icon_size = deepcopy(data.raw["capsule"]["raw-fish"].icon_size),
    icons = deepcopy(data.raw["capsule"]["raw-fish"].icons),
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 25 }
    },
    localised_name = { "recipe-name.repair-armor" },
    subgroup = "rogue-engineer",
    order = "rogue-[a]-[5]",
    icon = deepcopy(data.raw["repair-tool"]["repair-pack"].icon),
    icon_size = deepcopy(data.raw["repair-tool"]["repair-pack"].icon_size),
    icons = deepcopy(data.raw["repair-tool"]["repair-pack"].icons),
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
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
    energy_required = 5,
}
shift_bonus_icon_from_tech_to_recipe(follower_robot_count_recipe)
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
    },
    localised_name = { "technology-name.rogue-physical-projectile-damage"},
    localised_description = { "technology-description.rogue-physical-projectile-damage"},
    subgroup = "technologies",
    order = "technologies-[damage]-[weapon]",
    icon = deepcopy(data.raw["technology"]["physical-projectile-damage-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["physical-projectile-damage-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["physical-projectile-damage-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
shift_bonus_icon_from_tech_to_recipe(physical_projectile_damage_recipe)
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
    },
    localised_name = { "technology-name.rogue-energy-weapons-damage"},
    localised_description = { "technology-description.rogue-energy-weapons-damage"},
    subgroup = "technologies",
    order = "technologies-[damage]-[laser]",
    icon = deepcopy(data.raw["technology"]["energy-weapons-damage-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["energy-weapons-damage-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["energy-weapons-damage-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
shift_bonus_icon_from_tech_to_recipe(energy_weapons_damage_recipe)
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
    },
    localised_name = { "technology-name.rogue-stronger-explosives"},
    localised_description = { "technology-description.rogue-stronger-explosives"},
    subgroup = "technologies",
    order = "technologies-[damage]-[explosives]",
    icon = deepcopy(data.raw["technology"]["stronger-explosives-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["stronger-explosives-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["stronger-explosives-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
shift_bonus_icon_from_tech_to_recipe(stronger_explosives_recipe)
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
    },
    localised_name = { "technology-name.rogue-refined-flammables"},
    localised_description = { "technology-description.rogue-refined-flammables"},
    subgroup = "technologies",
    order = "technologies-[damage]-[flammables]",
    icon = deepcopy(data.raw["technology"]["refined-flammables-7"].icon),
    icon_size = deepcopy(data.raw["technology"]["refined-flammables-7"].icon_size),
    icons = deepcopy(data.raw["technology"]["refined-flammables-7"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
shift_bonus_icon_from_tech_to_recipe(refined_flammables_recipe)
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
    },
    localised_name = { "technology-name.rogue-weapon-shooting-speed"},
    localised_description = { "technology-description.rogue-weapon-shooting-speed"},
    subgroup = "technologies",
    order = "technologies-[speed]-[weapon]",
    icon = deepcopy(data.raw["technology"]["weapon-shooting-speed-6"].icon),
    icon_size = deepcopy(data.raw["technology"]["weapon-shooting-speed-6"].icon_size),
    icons = deepcopy(data.raw["technology"]["weapon-shooting-speed-6"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
shift_bonus_icon_from_tech_to_recipe(weapon_shooting_speed_recipe)
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
        { type = "item", name = "coin", amount_min = 1, amount_max = 10 }
    },
    localised_name = { "technology-name.rogue-laser-shooting-speed"},
    localised_description = { "technology-description.rogue-laser-shooting-speed"},
    subgroup = "technologies",
    order = "technologies-[speed]-[laser]",
    icon = deepcopy(data.raw["technology"]["laser-shooting-speed-6"].icon),
    icon_size = deepcopy(data.raw["technology"]["laser-shooting-speed-6"].icon_size),
    icons = deepcopy(data.raw["technology"]["laser-shooting-speed-6"].icons),
    allow_intermediates = false,
    allow_decomposition = false,
    allow_as_intermediate = false,
    show_amount_in_title = false,
    energy_required = 5,
}
shift_bonus_icon_from_tech_to_recipe(laser_shooting_speed_recipe)
data:extend{laser_shooting_speed_recipe}

data.raw["item"]["coin"].stack_size = 250

local laser_turret = deepcopy(data.raw["electric-turret"]["laser-turret"])
laser_turret.name = "rogue-laser-turret"
laser_turret.minable.result = "rogue-laser-turret"
laser_turret.energy_source = {type = "void"}
laser_turret.max_health = laser_turret.max_health / 3
laser_turret.localised_name = { "entity-name.laser-turret" }
laser_turret.localised_description = { "entity-description.laser-turret" }
data:extend{laser_turret}

local laser_turret_item = deepcopy(data.raw["item"]["laser-turret"])
laser_turret_item.name = "rogue-laser-turret"
laser_turret_item.place_result = "rogue-laser-turret"
laser_turret_item.localised_name = { "item-name.laser-turret" }
laser_turret_item.localised_description = { "item-description.laser-turret" }
data:extend{laser_turret_item}

local function validate_abilities()
    local to_log = {}
    for name, ability_data in pairs(constants.ability_data) do
        local cooldown_upgrade_count = 0
        local damage_upgrade_count = 0
        local radius_upgrade_count = 0
        local total_upgrade_count = 0
        if ability_data.upgrade_order then
            for _, upgrade in pairs(ability_data.upgrade_order) do
                if upgrade == "cooldown" then
                    cooldown_upgrade_count = cooldown_upgrade_count + 1
                end
                if upgrade == "damage" then
                    damage_upgrade_count = damage_upgrade_count + 1
                end
                if upgrade == "radius" then
                    radius_upgrade_count = radius_upgrade_count + 1
                end
                total_upgrade_count = total_upgrade_count + 1
            end
        end
        if cooldown_upgrade_count + damage_upgrade_count + radius_upgrade_count > 0 then
            to_log[name] = {
                -- cooldown_default = ability_data.default_cooldown,
                -- cooldown_upgrade_count = cooldown_upgrade_count,
                cooldown_at_max_upgrade = ability_data.default_cooldown - (cooldown_upgrade_count * ability_data.cooldown_multiplier),
                -- damage_default = ability_data.default_damage,
                -- damage_upgrade_count = damage_upgrade_count,
                damage_at_max_upgrade = ability_data.default_damage + (damage_upgrade_count * ability_data.damage_multiplier),
                -- radius_default = ability_data.default_radius,
                -- radius_upgrade_count = radius_upgrade_count,
                radius_at_max_upgrade = ability_data.default_radius + (radius_upgrade_count * ability_data.radius_multiplier),
                total_upgrade_count = total_upgrade_count,
            }
        end
    end
    log(serpent.block(to_log))
end
validate_abilities()
