--- A collection of utility functions.
local util = {}
local path = (...):gsub("%.util", "")
local component = require(path..".component")
local entity = require(path..".entity")

local fs = love.filesystem

-- Source: http://lua-users.org/wiki/CopyTable
function util.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[util.copy(orig_key)] = util.copy(orig_value)
        end
        setmetatable(copy, util.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--- Loads a component from a file.
-- @param file (string) A path to a file containing a component.
-- @usage -- The file should look something like this
-- return {
--     __name = "Component name",
--     __populate = function(component, arg)
--         component.arg = "Something"
--     end
-- }
function util.componentFromFile(file)
    assert(fs.getInfo(file), f("File '%s' does not exist", file))
    local comp = fs.load(file)()
    return component(comp.__name, comp.__populate)
end

--- Loads an entity from a file.
-- @param file (string) A path to a file containing an entity.
-- @usage -- The file should look something like this
-- return function(entity)
--     entity:addComponent("position", 100, 100)
--     entity:addComponent("health", 100)    
-- end
function util.entityFromFile(file)
    assert(fs.getInfo(file), f("File '%s' does not exist", file))
    local create = fs.load(file)()
    local ent = entity()
    create(ent)

    return ent
end

return util