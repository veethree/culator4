-- vui: vui (veethree user interface) is a gui library for löve.
--
-- Core principles
--  vui has a container based structure. First a container must be created, Then ui elements can be added into it.
--  All ui elements live inside a container, Multiple containers can be created and managed seperately.
--  As an example, You would have a seperate container for your main menu, and your options menu.
--  ui elements can be customized easily via a "style" table.
--  Themes are also supported. somehow.
--
--
--
local vui = {
    element = {}
}
local _vui = {__index = vui}


-- Shorthands
local lg, fs, f, insert = love.graphics, love.filesystem, string.format, table.insert

-- Determining local directory
local localDirectory = (...):match("(.-)[^%.]+$"):sub(1, -2).."/vui"

-- Loading util module
local util = require(localDirectory:gsub("/", ".")..".util")

-- Discovering gui elements in the elements folder
for _, file in ipairs(fs.getDirectoryItems(localDirectory.."/elements")) do
    if file:find("%.lua$") then
        local name = file:match(".+%."):sub(1, -2)
        vui.element[name] = localDirectory.."/elements/"..file
    end
end

-- Hooks vui's callbacks to löves callbacks
function vui:hook()
    local callbacks = {"update", "draw", "keypressed", "keyreleased", "textinput", "mousepressed", "mousereleased", "wheelmoved", "resize"}
    for _, callback in pairs(callbacks) do
        util.hook(callback, self[callback], self)
    end
end

local defaultStyle = {
    backgroundColor = {0.2, 0.2, 0.2},
    foregroundColor = {0.9, 0.9, 0.9},
    disabledForegroundColor = {0.6, 0.6, 0.6},
    accentColor = {0.9, 0.9, 0.2},
    alternativeAccentColor = {0.1, 0.4, 0.9},
    horizontalPadding = 0.1,
    verticalPadding = 0
}

-- Setting up default properties
local emptyFunction = function() end
local elementCallbacks = {"mouseenter", "mouseleave", "mousepressed", "mousereleased", "mousedown", "wheelmoved", "keypressed", "keyreleased", "textinput"}
local defaultProperties = {
    x = 0,
    y = 0,
    width = 0.1,
    height = 0.1,
    origin = "left",
    text = "",
    mouseOver = false,
}
-- Adding elements to default properties
for _, callback in pairs(elementCallbacks) do defaultProperties[callback] = emptyFunction end

function vui.new(x, y, width, height, draw)
    local container = setmetatable({
        visible = false,
        x = x or 0,
        y = y or 0,
        width = width or lg.getWidth(),
        height = height or lg.getHeight(),
        elements = {},
        util = util,
        focusedElement = false,
        style = {},
        drawContainer = draw or false
    }, _vui)
    util.consolidate(container.style, defaultStyle)
    container:hook()
    return container
end

function vui:countElements()
    local c = 0
    for i,v in pairs(self.elements) do
        c = c + 1 
    end
    return c
end

-- Sets a default style, Note that it combines the default defaultStyle and the one provided
-- Meaning you can only replace certain keys, and the rest will default to their defaults. english.
function vui:setDefaultStyle(style)
    for key, value in pairs(style) do
        defaultStyle[key] = value
    end
end

function vui:show()
    self.visible = true
    for _, element in ipairs(self.elements) do
        element.mouseOver = false
    end
end

function vui:hide()
    self.visible = false
    for _, element in ipairs(self.elements) do
        element.mouseOver = false
    end
end

function vui:add(elementName, properties, style)
    assert(self.element[elementName], f("The element '%s' does not exist!", elementName))
    style = style or defaultStyle
    local element = fs.load(self.element[elementName])()

    util.consolidate(properties, defaultProperties)
    util.consolidate(element, properties)
    util.consolidate(style, defaultStyle)

    element.container = self
    element.style = style
    if type(element.load) == "function" then
        element:load()
    end
    insert(self.elements, element)
    return element
end

-- Callback functions
function vui:update(dt)
    if self.visible then
        local mx, my = love.mouse.getPosition()
        self.focuedElement = false
        for _, element in ipairs(self.elements) do
            if element.selected then 
                self.focuedElement = element
                break
            end
        end
        if not self.focuedElement then
            for _, element in ipairs(self.elements) do
                if util.pointInRect(mx, my, util.getRect(element)) then
                    if not element.mouseOver then
                        element.mouseenter(element)
                        element.mouseOver = true
                    end
                    if love.mouse.isDown(1) then
                        element.mousedown(element, mx, my)
                    end
                else
                    if element.mouseOver then
                        element.mouseleave(element, mx, my)
                        element.mouseOver = false
                    end
                end
            end
        end
    end
end

function vui:draw()
    if self.visible then
        if self.drawContainer then
            lg.setColor(self.style.foregroundColor)
            lg.rectangle("fill", self.x, self.y, self.width, self.height)
            lg.setColor(self.style.backgroundColor)
            lg.rectangle("fill", self.x, self.y, self.width, self.height)
        end

        local selected = {}
        for _, element in ipairs(self.elements) do
            if not element.selected then
                lg.setColor(1, 1, 1, 1)
                local x, y, width, height = util.getRect(element)
                element.draw(element, x, y, width, height)
            else
                selected[#selected+1] = element
            end
        end

        for _, element in ipairs(selected) do
            lg.setColor(1, 1, 1, 1)
            local x, y, width, height = util.getRect(element)
            element.draw(element, x, y, width, height)
        end
    end

end

function vui:keypressed(key)
    if self.visible then
        for _, element in ipairs(self.elements) do
            element.keypressed(element, key)
        end
    end
end

function vui:keyreleased(key)
    if self.visible then
        
    end
end

function vui:textinput(t)
    if self.visible then
        for _, element in ipairs(self.elements) do
            element.textinput(element, t)
        end
    end
end

function vui:mousepressed(x, y, button)
    if self.visible then
        if not self.focuedElement then
            for _, element in ipairs(self.elements) do
                if element.mouseOver then
                    element.mousepressed(element, x, y, button)
                end 
            end
        else
            local element = self.focuedElement
            self.focuedElement.mousepressed(element, x, y, button)
        end
    end
end

function vui:mousereleased(x, y, button)
    if self.visible then
        for _, element in ipairs(self.elements) do
            if element.mouseOver or element.selected then
                element.mousereleased(element, x, y, button)
            end 
        end
    end
end

function vui:wheelmoved(x, y)
    if self.visible then
        for _, element in ipairs(self.elements) do
            if element.mouseOver or element.selected then
                element.wheelmoved(element, x, y)
            end 
        end
    end
end

function vui:resize(width, height)
    self.width = width
    self.height = height
    for _, element in ipairs(self.elements) do
        if type(element.load) == "function" then
            element:load(true)
        end
    end
end

return vui