--- A container for systems and entities.

-- Creating a refrence to the plugin module so the callbacks can be called
local path = (...):gsub("%.world", "")
local plugin = require(path..".plugin")

local world = {}
world.mt = {__index = world}
setmetatable(world, world.mt)

local insert, remove = table.insert, table.remove

local emptyFunction = function() end

--- Creates a new world.
-- You can also call the module itself to create a new world.
-- @usage -- myWorld = vecs.world()
function world.new()
    local instance = setmetatable({
        entity = vecs.spatial.new(),
        system = {},
        entitiesToRemove = {},
        callbacks = {
            onSystemAdd = emptyFunction,
            onSystemRemove = emptyFunction,
            onEntityAdd = emptyFunction,
            onEntityRemove = emptyFunction,
            onRefresh = emptyFunction,
            onClear = emptyFunction,
        }
    }, world.mt)

    return instance
end

--- Sets a world callback.
-- Available callbacks: onSystemAdd, onSystemRemove, onEntityAdd, onEntityRemove, onRefresh, onClear.
-- This function returns the world, Therefore can be chained.
-- @param callback (string) The name of the callback
-- @param func (function) A function to be used as the callback
-- @return self
function world:callback(callback, func)
    local invalidCallbackError = "Invalid callback. Available callbacks: "
    for key,_ in pairs(self.callbacks) do invalidCallbackError = invalidCallbackError.."'"..key.."', " end
    assert(self.callbacks[callback], invalidCallbackError)
    assert(type(func) == "function", "Invalid argument, Expected function got "..type(func))
    
    self.callbacks[callback] = func
    return self
end

--- Adds a system to the world.
-- Can take any number of systems as arguments.
-- @param ... Any number of systems.
-- @usage world:addSystem(system1, system2)
function world:addSystem(...)
    for _, system in ipairs({...}) do
        insert(self.system, system)
        self.callbacks.onSystemAdd(system)
        plugin:onSystemAdd(system)
    end
    self:refresh()
end

--- Removes a system from the world.
-- Can take any number of systems as arguments.
-- @param ... Any number of systems.
function world:removeSystem(...)
    for _, system in ipairs({...}) do
        remove(self.system, system.__index)
        self.callbacks.onSystemRemove(system)
        plugin:onSystemRemove(system)
    end
end

--- Adds an entity to the world.
-- Can take any number of entities as arguments.
-- @param ... Any number of entities.
function world:addEntity(...)
    for _, entity in ipairs({...}) do
        entity.__world = self
        local x, y = 0, 0
        if entity.position then
            x = entity.position.x
            y = entity.position.y
        end
        self.entity:insert(x, y, entity)
        self.callbacks.onEntityAdd(entity)
        plugin:onEntityAdd(entity)
    end
    self:refresh()
end

--- Removes an entity from the world.
-- Can take any number of entities as arguments.
-- @param ... Any number of entities.
function world:removeEntity(...)
    for _, entity in ipairs({...}) do
        insert(self.entitiesToRemove, entity)
        plugin:onEntityRemove(entity)
    end
    self:refresh()
end

--- Removes all entities from the world.
function world:clear()
    self.entity = {}
    self.callbacks.onClear()
    plugin:onClear()
    self:refresh()
end

--- Returns a list of entites from the world
-- The list can optionally be filtered via a filter function
-- @param filter A function that receives an entity as an argument, If the function returns a truthy value,
-- the entity is included in the list.
-- @return (table) A list of entities.
-- @return (number) The length of the list.
-- @usage -- Returns a list of all entities with a "position" and a "velocity" component
-- local list, len = world:getEntities(function(entity)
--     return entity.position and entity.velocity
-- end)
function world:getEntities(filter)
    filter = filter or function() return true end    
    local entities = {}
    local len = 0
    for _, entity in ipairs(self.entity) do
        if filter(entity) then
            insert(entities, entity)
            len = len + 1
        end
    end
    return entities, len
end

--- Refreshes the world.
-- Updates the system pools.
function world:refresh(x, y, width, height)
    x = x or 0
    y = y or 0
    width = width or lg.getWidth()
    height = height or lg.getHeight()

    local entityList = self.entity:queryRect(x, y, width, height)

    for _, entity in ipairs(self.entitiesToRemove) do
        self.entity:remove(entity)
        self.callbacks.onEntityRemove(entity)
    end

    for systemIndex, system in ipairs(self.system) do
        system.pool = {}
        system.__index = systemIndex
        for index, entity in ipairs(entityList) do
            entity.__index = index
            if system.filter(entity) then
                insert(system.pool, entity)
            end
        end
    end
    self.callbacks.onRefresh()
    plugin:onRefresh()
end

--- Count entities and systems currently in the world.
-- @return (number) Number of entities.
-- @return (number) Number of systems.
function world:count()
    return #self.entity, #self.system
end

--- Calls system callbacks.
-- Every system with a matching callback will be called.
-- @param callback (string) The system callback to call.
-- @param ... (any) Any arguments that should be passed to the callback.
-- @usage -- Call any system with a "update" callback, Passing along dt.
-- world:cast("update", dt)
function world:call(callback, ...)
    for _, system in ipairs(self.system) do
        if type(system[callback]) == "function" then
            for _, entity in ipairs(system.pool) do
                system[callback](entity, ...)
            end
        end
    end
end

-- Metamethods
world.mt.__call = function(self, ...)
    return self.new(...)
end

return world