NAME = "Culator 4"
VERSION = "v1.0"

-- Hijacking print function
local p = print

function print(...)
    local t = debug.getinfo(print)
    p(t["name"], ...)
end

-- Detecting platform
OS = love.system.getOS()
PLATFORM = "Desktop"
if OS == "Android" or OS == "iOS" then
    PLATFORM = "Mobile"
end

-- Debug
debugMode = false
useConfigFile = true -- If false, The defaultConfig.lua file will always be used

-- Shorthands
lg = love.graphics
fs = love.filesystem
kb = love.keyboard
lm = love.mouse
la = love.audio
random = math.random
floor = math.floor
max = math.max
min = math.min
abs = math.abs
noise = love.math.noise
sin = math.sin
cos = math.cos
f = string.format
insert = table.insert
remove = table.remove

function love.load()
    fs.setIdentity("Culator4")
    -- Loading the util module first, because it contains the requireFolder function
    require "data.lib.util"
    color = require "data.color"
    requireFolder("data/lib")
    exString:import()

    -- Loading / creating config file
    defaultConfig = require("data.defaultConfig")
    config = defaultConfig
    if useConfigFile then
        if fs.getInfo("config.lua") then
            config = ttf.load("config.lua")
        else
            ttf.save(config, "config.lua")
        end
    end

    -- Loading / Creating history file
    history = {}
    if fs.getInfo("history.lua") then
        history = ttf.load("history.lua") 
    else
        ttf.save(history, "history.lua")
    end

    -- Loading / Creating memory file
    memory = {}
    if fs.getInfo("memory.lua") then
        memory = ttf.load("memory.lua") 
    else
        ttf.save(memory, "memory.lua")
    end

    if PLATFORM == "Mobile" then
        config.window.fullscreen = true
        config.window.fullscreenType = "exclusive"
    end

    -- Creating the window
    -- love.window.setMode(config.window.width, config.window.height, {
    --     fullscreen = config.window.fullscreen,
    --     vsync = config.window.vsync,
    --     resizable = config.window.resizable,
    --     minwidth = config.window.minWidth,
    --     minheight = config.window.minHeight,
    --     fullscreentype = config.window.fullscreenType
    -- })
    love.window.setTitle(config.window.title)

    -- Löve configuration
    lg.setDefaultFilter("nearest", "nearest")
    lg.setLineStyle("rough")
    SAFE_X, SAFE_Y, SAFE_WIDTH, SAFE_HEIGHT = love.window.getSafeArea()
    -- SAFE_Y = 40
    -- SAFE_HEIGHT = lg.getHeight() - 100

    -- Scale values used for scaling. scale is used to scale scaleX and scaleY
    -- scaleX and scaleY are used to scale everything else.
    globalScale = 0.001
    scaleX = lg.getWidth() * globalScale
    scaleY = lg.getHeight() * globalScale
    scale = math.max(scaleX, scaleY) -- This is the "preferred" scale. Used for scaling things that need to scale evenely like sprites.

    -- Defining some fonts
    font = {
        smaller = lg.newFont("data/art/font/RobotoCondensed-Light.ttf", scaleX * 40),
        small = lg.newFont("data/art/font/RobotoCondensed-Light.ttf", scaleX * 50),
        medium = lg.newFont("data/art/font/RobotoCondensed-Light.ttf", scaleX * 60),
        large = lg.newFont("data/art/font/RobotoCondensed-Light.ttf", scaleX * 70),
        larger = lg.newFont("data/art/font/RobotoCondensed-Light.ttf", scaleX * 80),
        huge = lg.newFont("data/art/font/RobotoCondensed-Light.ttf", scaleX * 100),
        smallerBold = lg.newFont("data/art/font/RobotoCondensed-Bold.ttf", scaleX * 40),
        smallBold = lg.newFont("data/art/font/RobotoCondensed-Bold.ttf", scaleX * 50),
        mediumBold = lg.newFont("data/art/font/RobotoCondensed-Bold.ttf", scaleX * 60),
        largeBold = lg.newFont("data/art/font/RobotoCondensed-Bold.ttf", scaleX * 70),
        largerBold = lg.newFont("data/art/font/RobotoCondensed-Bold.ttf", scaleX * 80),
        hugeBold = lg.newFont("data/art/font/RobotoCondensed-Bold.ttf", scaleX * 100),
    }

    -- Loading scenes
    scene:hook()
    iterateDirectory("data/scene", function(file, path, type)
        if file:endsWith(".lua") then
            scene:newScene(getFileName(file), path)
        end
    end)

    -- Loading scene transitions
    iterateDirectory("data/scene/transition", function(file, path, type)
        if file:endsWith(".lua") then
            scene:newTransition(getFileName(file), path)
        end
    end)

    -- Input binding
    input:hook()
    input:bindToFunction("keypressed", "escape", love.event.push, "quit")
    input:bindToFunction("keypressed", "f1", function() debugMode = not debugMode end)
    -- 
    gesture:load()

    hook("draw", drawDebug)
    -- Hijacking getWidth and getHeight to deal with safe area
    getWidth = lg.getWidth
    getHeight = lg.getHeight

    function love.graphics.getWidth()
        return SAFE_WIDTH
    end

    function love.graphics.getHeight()
        return getHeight() - SAFE_Y
    end

    scene:switchNow("game")
end

function loadTheme(theme)
    if fs.getInfo(f("data/art/theme/%s.lua", theme)) then
        THEME = fs.load(f("data/art/theme/%s.lua", theme))()
        lg.setBackgroundColor(THEME.screen.backgroundColor)
        scene:get():refresh()
        config.theme = theme
        ttf.save(config, "config.lua")
    end
end

function love.update(dt)
    gesture:update(dt)
    smoof:update(dt)
end

function drawDebug()
    if debugMode then
        local debugString = f("FPS: %d\nPlatform: %s (%s)", love.timer.getFPS(), PLATFORM, OS)
        lg.setFont(font.smaller)
        lg.setColor(color.mintGreen)
        lg.print(debugString, 12, SAFE_Y + 12)
        lg.setColor(color.green)
        lg.rectangle("line", SAFE_X, SAFE_Y, SAFE_WIDTH, SAFE_HEIGHT)
    end
end

function love.draw()
    if debugMode then
        drawDebug()
    end
end

function love.resize(width, height)
    
end

function love.keypressed(key)
   
end

function love.keyreleased(key)
    
end

function love.textinput(t)

end

function love.mousepressed(x, y, button)
    gesture:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    gesture:mousereleased(x, y, button)
end

function love.touchpressed(id, x, y, dx, dy, pressure)

end

function love.touchreleased(id, x, y, dx, dy, pressure)

end

function love.wheelmoved(x, y)
    
end