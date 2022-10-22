local scene = {
    loadedScenes = {},
    currentScene = false,
    currentSceneId = false,

    transition = {},
    transitionSwitched = false,
    transitionScene = false,
    transitionSceneData = false,
    currentTransition = false
}
local _scene = {__index = scene}

local fs = love.filesystem
local f = string.format

local function hook(callback, func, ...) 
    local arguments = {...}
    local base = love[callback] or function() end
    love[callback] = function(...)
        base(...)
        func(unpack(arguments), ...)
    end
end

-- Hooks scene.lua's callbacks to löves callbacks.
function scene:hook()
    local callbacks = {"update", "draw", "keypressed", "keyreleased", "textinput", "mousepressed", "mousereleased", "wheelmoved", "resize" }
    for _, callback in pairs(callbacks) do
        hook(callback, self[callback], self)
    end
end

-- Loads a transition file
function scene:newTransition(id, file)
    assert(self.transition[id] == nil, f("A transition with the id '%s' already exists!", id))
    self.transition[id] = fs.load(file)()
end

-- Loads a scene, But does not switch to it!
function scene:newScene(id, file)
    assert(self.loadedScenes[id] == nil, f("A scene with the id '%s' already exists!", id))
    self.loadedScenes[id] = fs.load(file)()
end

-- Switches to a scene
-- id: The id of the scene as defined in scene:newScene()
-- transition: The id of the transition as defined in scene:newTransition(), If nil or false, No transition will be used
-- data: Any data you want to pass to the new scene
function scene:switch(id, transition, data)
    assert(self.loadedScenes[id], f("Scene '%s' does not exist!", id))

    if not transition then
        self:switchNow(id, data)
        return
    end

    if not self:inTransition() then
        assert(self.transition[transition], f("Transition '%s' does not exist!", transition))
        self.transitionScene = id
        self.transitionSceneData = data
        self.currentTransition = self.transition[transition]
        if type(self.currentTransition.load) == "function" then
            self.currentTransition:load()
        end
    end
end

function scene:switchNow(id, data)
    self.currentScene = self.loadedScenes[id]
    self.currentSceneId = id
    if type(self.currentScene.load) == "function" then
        self.currentScene:load(data)
    end
end

function scene:inTransition()
    return self.transitionScene and true or false
end

function scene:get()
    return self.currentScene
end

-- Callback functions
function scene:update(dt)
    if self.currentScene then
        if type(self.currentScene.update) == "function" then
            self.currentScene:update(dt)
        end

        if self.transitionScene then
            self.currentTransition:update(dt)
            if self.currentTransition.stage == "out" then
                if not self.transitionSwitched then
                    self:switchNow(self.transitionScene, self.transitionSceneData)
                    self.transitionSwitched = true
                end
            elseif self.currentTransition.stage == "finished" then
                self.transitionScene = false
                self.transitionSceneData = false
                self.transitionSwitched = false
            end
        end
    end
end

function scene:draw()
    if self.currentScene then
        if type(self.currentScene.draw) == "function" then
            self.currentScene:draw()
        end

        if self.transitionScene then
            self.currentTransition:draw()
        end
    end
end

function scene:textinput(t)
    if self.currentScene then
        if type(self.currentScene.textinput) == "function" then
            self.currentScene:textinput(t)
        end
    end
end

function scene:keypressed(key)
    if self.currentScene then
        if type(self.currentScene.keypressed) == "function" then
            self.currentScene:keypressed(key)
        end
    end
end

function scene:keyreleased(key)
    if self.currentScene then
        if type(self.currentScene.keyreleased) == "function" then
            self.currentScene:keyreleased(key)
        end
    end
end

function scene:mousepressed(x, y, k)
    if self.currentScene then
        if type(self.currentScene.mousepressed) == "function" then
            self.currentScene:mousepressed(x, y, k)
        end
    end
end

function scene:mousereleased(x, y, k)
    if self.currentScene then
        if type(self.currentScene.mousereleased) == "function" then
            self.currentScene:mousereleased(x, y, k)
        end
    end
end

function scene:wheelmoved(x, y)
    if self.currentScene then
        if type(self.currentScene.wheelmoved) == "function" then
            self.currentScene:wheelmoved(x, y)
        end
    end
end

function scene:resize(width, height)
    if self.currentScene then
        if type(self.currentScene.resize) == "function" then
            self.currentScene:resize(width, height)
        end
    end
end

return scene