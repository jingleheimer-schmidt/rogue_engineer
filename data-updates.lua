
local cluster_grenade = data.raw["capsule"]["cluster-grenade"]
for _, fish in pairs(data.raw["fish"]) do
    fish.stack_size = 1
    fish.capsule_action = cluster_grenade.capsule_action
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

for _, tree in pairs(data.raw["tree"]) do
    tree.loot = tree.loot or {}
    table.insert(tree.loot, { item = "coin", count_min = 1, count_max = 15  })
    tree.max_health = tree.max_health * 10
end

for _, entity in pairs(data.raw["simple-entity"]) do
    if entity.name:find("rock") then
        entity.loot = entity.loot or {}
        table.insert(entity.loot, { item = "coin", count_min = 5, count_max = 30  })
        entity.max_health = entity.max_health * 10
    end
end

local visible_technologies = {
    ["rogue-follower-robot-count"] = true,
    ["rogue-physical-projectile-damage"] = true,
    ["rogue-energy-weapons-damage"] = true,
    ["rogue-stronger-explosives"] = true,
    ["rogue-refined-flammables"] = true,
    ["rogue-weapon-shooting-speed"] = true,
    ["rogue-laser-shooting-speed"] = true,
}

for _, technology in pairs(data.raw["technology"]) do
    technology.hidden = not visible_technologies[technology.name]
    if technology.normal then
        technology.normal.hidden = not visible_technologies[technology.name]
    end
    if technology.expensive then
        technology.expensive.hidden = not visible_technologies[technology.name]
    end
end

local visible_recipes = {
    ["unlock-ability"] = true,
    ["extra-life"] = true,
    ["vampire-strength"] = true,
    -- ["revive-friend"] = true,

    ["running-speed"] = true,
    ["health-bonus"] = true,
    ["loot-distance"] = true,
    ["restore-health"] = true,
    ["repair-armor"] = true,

    ["light-armor"] = true,
    ["heavy-armor"] = true,
    ["modular-armor"] = true,
    ["power-armor"] = true,
    ["power-armor-mk2"] = true,

    ["follower-robot-count"] = true,
    ["physical-projectile-damage"] = true,
    ["energy-weapons-damage"] = true,
    ["stronger-explosives"] = true,
    ["refined-flammables"] = true,
    ["weapon-shooting-speed"] = true,
    ["laser-shooting-speed"] = true,
}

for _, recipe in pairs(data.raw["recipe"]) do
    recipe.hide_from_player_crafting = not visible_recipes[recipe.name]
    recipe.allow_intermediates = false
    recipe.allow_decomposition = false
    recipe.allow_as_intermediate = false
    if recipe.normal then
        recipe.normal.hide_from_player_crafting = not visible_recipes[recipe.name]
        recipe.normal.allow_intermediates = false
        recipe.normal.allow_decomposition = false
        recipe.normal.allow_as_intermediate = false
    end
    if recipe.expensive then
        recipe.expensive.hide_from_player_crafting = not visible_recipes[recipe.name]
        recipe.expensive.allow_intermediates = false
        recipe.expensive.allow_decomposition = false
        recipe.expensive.allow_as_intermediate = false
    end
end

local rusty_locale = require '__rusty-locale__.locale'
local constants = require 'constants'
local ability_datas = constants.ability_data

for ability_name, ability_data in pairs(ability_datas) do
    local technologies = {
        ["follower-robot-count"] = "follower_robot_count",
        ["physical-projectile-damage"] = "physical_projectile_damage",
        ["energy-weapons-damage"] = "energy_weapons_damage",
        ["stronger-explosives"] = "stronger_explosives",
        ["refined-flammables"] = "refined_flammables",
        ["weapon-shooting-speed"] = "weapon_shooting_speed",
        ["laser-shooting-speed"] = "laser_shooting_speed",
    }
    local affected_technologies = {
        follower_robot_count = false,
        physical_projectile_damage = false,
        energy_weapons_damage = false,
        stronger_explosives = false,
        refined_flammables = false,
        weapon_shooting_speed = false,
        laser_shooting_speed = false,
    }
    for _, upgrade_type in pairs(ability_data.upgrade_order or {}) do
        if technologies[upgrade_type] then
            if upgrade_type == "follower-robot-count" then
                affected_technologies.follower_robot_count = true
            elseif upgrade_type == "physical-projectile-damage" then
                affected_technologies.physical_projectile_damage = true
            elseif upgrade_type == "energy-weapons-damage" then
                affected_technologies.energy_weapons_damage = true
            elseif upgrade_type == "stronger-explosives" then
                affected_technologies.stronger_explosives = true
            elseif upgrade_type == "refined-flammables" then
                affected_technologies.refined_flammables = true
            elseif upgrade_type == "weapon-shooting-speed" then
                affected_technologies.weapon_shooting_speed = true
            elseif upgrade_type == "laser-shooting-speed" then
                affected_technologies.laser_shooting_speed = true
            end
        end
    end
    for technology_name, underscore_name in pairs(technologies) do
        if affected_technologies[underscore_name] then
            local technology = data.raw["technology"]["rogue-" .. technology_name]
            if technology then
                local locale = rusty_locale.of(technology)
                local description = locale.description
                technology.localised_description = {"", description, "\n", { "ability_name." .. ability_name }}
            end
            local recipe = data.raw["recipe"][technology_name]
            if recipe then
                local locale = rusty_locale.of(recipe)
                local description = locale.description
                recipe.localised_description = {"", description, "\n", { "ability_name." .. ability_name }}
            end
        end
    end
end
