--- A container for components.
local path = (...):gsub("%.entity", "")
local component = require(path..".component")

local entity = {}
entity.mt = {
    __index = entity,
    __tostring = function(self, ...)
        local str = "Entity: {"
        for key, val in pairs(self) do
            str = str..key.." = "..tostring(val)..", "
        end
        str = str.."}"
        return str
    end
}

setmetatable(entity, entity.mt)

--- Creates a new entity
-- If a world is provided as an argument, The entity will be added to the world on creation.
-- You can also call the module itself to create a new entity.
-- @param world (world) The world the entity will live in. Optional.
-- @usage -- Example player entity
-- player = vecs.entity()
-- :addComponent("position", 100, 100)
-- :addComponent("health", 100)
function entity.new(world)
    local ent = setmetatable({}, entity.mt)
    if world then
        world:addEntity(ent)
        ent.__world = world
    end
    return ent
end

--- Adds a component to the entity.
-- @param key (string) The key the component should be stored as, Defaults to the name of the component.
-- @param name (string) Name of the component to be added.
-- @param ... (any) Arguments for the components populate function.
function entity:addComponent(key, name, ...)
    local comp = component:newInstance(name, ...)
    self[key or comp.__name] = comp
    if self.__world then self.__world:refresh() end
    return self
end

--- Removes a component from an entity.
-- @param name (string) The name of the component to be removed.
function entity:removeComponent(name) 
    if self[name] then
        self[name] = nil        
        if self.__world then self.__world:refresh() end
        return true
    end
    return false
end

return setmetatable(entity, {
    __call = function(_, ...)
        return entity.new(...)
    end
})