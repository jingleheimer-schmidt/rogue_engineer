
local function create_arena_surface()
    local map_gen_settings = {
        terrain_segmentation = 3,
        water = 1/4,
        -- autoplace_controls = {
        --     ["coal"] = {frequency = 0, size = 0, richness = 0},
        --     ["stone"] = {frequency = 0, size = 0, richness = 0},
        --     ["copper-ore"] = {frequency = 0, size = 0, richness = 0},
        --     ["iron-ore"] = {frequency = 0, size = 0, richness = 0},
        --     ["uranium-ore"] = {frequency = 0, size = 0, richness = 0},
        --     ["crude-oil"] = {frequency = 0, size = 0, richness = 0},
        --     ["trees"] = {frequency = 0, size = 0, richness = 0},
        --     ["enemy-base"] = {frequency = 0, size = 0, richness = 0},
        -- },
        width = 5000,
        height = 5000,
        seed = math.random(1, 1000000),
        starting_area = 1/4,
        starting_points = {{x = 0, y = 0}},
        peaceful_mode = false,
    }
    if not game.surfaces.arena then
        game.create_surface("arena", map_gen_settings)
        game.surfaces.arena.always_day = true
    end
end

local function replenish_arena_enemies()
    local arena_surface = game.surfaces.arena
    local enemies = {
        "small-worm-turret",
        "medium-worm-turret",
        "big-worm-turret",
        "behemoth-worm-turret",
        "biter-spawner",
        "spitter-spawner",
    }
    arena_surface.regenerate_entity(enemies)
end

local function destroy_arena_enemies()
    local enemies = game.surfaces.arena.find_entities_filtered{
        force = "enemy",
    }
    for _, enemy in pairs(enemies) do
        enemy.destroy()
    end
end

return {
    create_arena_surface = create_arena_surface,
    replenish_arena_enemies = replenish_arena_enemies,
    destroy_arena_enemies = destroy_arena_enemies,
}
