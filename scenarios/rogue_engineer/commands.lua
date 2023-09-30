
local arena_util = require("arena_util")
local create_arena_surface = arena_util.create_arena_surface
local replenish_arena_enemies = arena_util.replenish_arena_enemies
local destroy_arena_enemies = arena_util.destroy_arena_enemies

local function delete_arena_surface()
    local surface = game.surfaces["arena"]
    if surface then
        game.delete_surface(surface)
    end
end

---@param event EventData.on_surface_deleted
local function on_surface_deleted(event)
    if event.surface_index == game.surfaces["arena"].index then
        create_arena_surface()
    end
end
