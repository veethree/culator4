--- A container for callback function that act on entities.
local system = {}
system.mt = {__index = system}
setmetatable(system, system.mt)

local defaultFilter = function() return true end

--- Creates a new system.
-- You can also call the module itself to create a new system.
-- @usage -- An example system that processes entities with a "position" component
-- mySystem = vecs.system()
-- :callback("filter", function(entity)
--     return entity.position
-- end)
-- :callback("update", function(entity)
--     -- Do stuff with the entity here
-- end)
function system.new()
    return setmetatable({
        filter = defaultFilter,
        pool = {}
    }, system.mt)
end

--- Adds a callback to a system.
-- Each callback function is called with the an entity as an argument, Followed by any arguments passed to world:cast().
-- This function returns the system, Therefore can be chained. (See example above)
-- @param callback (string) The name of the callback.
-- @param func (function) The function that will act as the callback.
-- @return self
function system:callback(callback, func)
    self[callback] = func
    return self
end

return setmetatable(system, {
    __call = function(_, ...)
        return system.new()
    end
})