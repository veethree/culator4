--- A module that creates and keeps track of components.
-- @module component
local component = {
    __type = "component",
    components = {}
}
component.mt = {
    __index = component,
    __tostring = function(self, ...)
        local str = "{"
        for key, val in pairs(self) do
            str = str..key.." = "..tostring(val)..", "
        end
        str = str.."}"
        return str
    end
}

-- Local variables
local emptyFunction = function() end
local f = string.format

--- Creates a new component.
-- You can also call the module itself to create a new component.
-- @param name (string) The name for the component.
-- @param populateFunction (function) A function that receives an empty component as an argument, And should populate it with values.
-- @usage -- A position component 
-- component.new("position", function(component, x, y)
--     component.x = x or 0
--     component.y = y or 0 
-- end)
function component.new(name, populateFunction)
    assert(component.components[name] == nil, f("A component with the name '%s' already exists!", name))
    local c = {
        __name = name,
        __populate = populateFunction or emptyFunction
    }
    component.components[name] = c
    return component.components[name]
end

--- Creates a new instance of a component.
-- This is used internally to add components to entities.
-- @param name (string) Name of the component to be isntanced.
-- @param ... (any) Arguments for the components populate function.
-- @usage local position = component:newInstance("position", 100, 100)
function component:newInstance(name, ...)
    assert(self.components[name], f("Component '%s' is not defined", name))
    local instance = {__name = name}
    self.components[name].__populate(instance, ...)
    return setmetatable(instance, self.mt)
end

return setmetatable(component, {
    __call = function(_, ...)
        return component.new(...)
    end
})