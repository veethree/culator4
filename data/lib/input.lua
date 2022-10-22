-- input.lua is a basic input handler library
-- How it works:
--  Keys can be bound to either actions or functions, Each binding also has a type, keypressed, keyreleased, or keydown.
--  A single key bind can have any number of keys associated with it.
--  This module only handes the keyboard in its current state, No gamepads or mouse
--  
-- function bind:
--  When a key is bound to a funciton, That function will automatically be called when
--  the appropriate key and event happens
-- Action bind:
--  When a key is bound to an action, The end user has to check for the action with input:isActionPressed/Released/Down
--
-- Callback functions
-- input.lua requires the following callback functions to function: keypressed, keyreleased & keydown. Keydown needs to be called
-- every frame, So it should be placed in love.update
-- Alternatively, You can call input:hook() to automatically hook the callback functions to the appropriate löve functions.

local function hook(callback, func, ...) 
    local arguments = {...}
    local base = love[callback] or function() end
    love[callback] = function(...)
        base(...)
        func(unpack(arguments), ...)
    end
end

local input = {
    bindings = {
        keypressed = {},
        keyreleased = {},
        keydown = {}
    },
    keysDown = {}, -- Holds a list off all keys currently down
    actionsDown = {},
    actionsPressed = {},
    actionsReleased = {}
}

-- Hooks the callback functions to löves callback functions
function input:hook()
    hook("keypressed", self.keypressed, self)
    hook("keyreleased", self.keyreleased, self)
    hook("update", self.keydown, self)
end

-- Ex input:bindToFunction("keypressed", {"escape", "x"}, love.event.push, "quit")
function input:bindToFunction(inputType, keys, func, ...)
    -- If keys is a string, Wrap it in a table for simplicity
    if type(keys) == "string" then
        keys = {keys}
    end

    insert(self.bindings[inputType], {
        type = "function",
        keys = keys,
        func = func,
        arguments = {...}
    })
end

-- ex: input:bindToAction("keydown", "w", "moveUp")
function input:bindToAction(inputType, keys, action)
    -- If keys is a string, Wrap it in a table for simplicity
    if type(keys) == "string" then
        keys = {keys}
    end

    insert(self.bindings[inputType], {
        type = "action",
        keys = keys,
        action = action
    })
end

-- This will only return true during the frame the press happened
function input:isActionPressed(action) 
    return self.actionsPressed[action] or false
end

-- This will only return true during the frame the release happened
function input:isActionReleased(action) 
    return self.actionsReleased[action] or false
end

-- This will return true as long as the action key is held down
function input:isActionDown(action) 
    return self.actionsDown[action] or false
end

-- Callbacks
function input:keypressed(key)
    self.keysDown[key] = true
    for _,binding in ipairs(self.bindings.keypressed) do
        local pressed = false
        for _, bindingKey in ipairs(binding.keys) do
            if key == bindingKey then
                pressed = true
                break
            end
        end

        if pressed then
            if binding.type == "function" then
                binding.func(unpack(binding.arguments))
            elseif binding.type == "action" then
                self.actionsPressed[binding.action] = true
            end
        end
    end
end

function input:keyreleased(key)
    self.keysDown[key] = nil
    self.actionsDown = {}
    for _,binding in ipairs(self.bindings.keyreleased) do
        local pressed = false
        for _, bindingKey in ipairs(binding.keys) do
            if key == bindingKey then
                pressed = true
                break
            end
        end

        if pressed then
            if binding.type == "function" then
                binding.func(unpack(binding.arguments))
            elseif binding.type == "action" then
                self.actionsReleased[binding.action] = true
            end
        end
    end
end

-- Creating an alias for simplicity
function input:keydown()
    for _,binding in ipairs(self.bindings.keydown) do
        local pressed = false
        for _, bindingKey in ipairs(binding.keys) do
            if self.keysDown[bindingKey] then
                pressed = true
                break
            end
        end

        if pressed then
            if binding.type == "function" then
                binding.func(unpack(binding.arguments))
            elseif binding.type == "action" then
                self.actionsDown[binding.action] = true
            end
        end
    end
    self.actionsPressed = {}
    self.actionsReleased = {}
end

return input