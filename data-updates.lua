
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
    table.insert(tree.loot, { item = "coin", count_min = 0, count_max = 4 })
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
