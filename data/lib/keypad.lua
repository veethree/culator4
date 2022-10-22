local keypad = {}
local keypad_meta = {__index = keypad}

function keypad.new()
    local kp = setmetatable({
        layout = {},
        rowHeights = {}
    }, keypad_meta)

    return kp
end

-- Expects a theme table
function keypad:setTheme(theme)
    theme = theme
end

function keypad:addRow(keys, settings, theme)
    for i,v in ipairs(keys) do
        v.anim = 0
        v.targetAnim = 0
    end
    self.layout[#self.layout+1] = {
        keys = keys,
        settings = settings,
    }
    return self
end

function keypad:drawKey(key)
    local theme = copyTable(THEME.key)
    if key.theme then
        for key, val in pairs(key.theme) do
            theme[key] = val
        end
    end
    -- Calculating positition and size with respect to padding
    local x = key.x + theme.padding
    local y = key.y + theme.padding
    local width = key.width - (theme.padding * 2)
    local height = key.height - (theme.padding * 2)
    -- Background 
    lg.setColor(theme.backgroundColor)
    lg.rectangle("fill", x, y, width, height)
    
    lg.setColor(color.white)
    setAlpha(key.anim * 0.5)
    lg.rectangle("fill", x, y, width, height)

    -- Outline
    if theme.outline then
        local lw = lg.getLineWidth()
        lg.setLineWidth(theme.outlineWidth)
        lg.setColor(theme.outlineColor)
        lg.rectangle("line", x, y, width, height)
        lg.setLineWidth(lw)
    end

    -- Text
    local font = font[theme.font]
    local textHeight = font:getAscent() - font:getDescent()
    local textY = y + (height - textHeight) / 2 - ((textHeight * 0.2) * key.anim)
    lg.setColor(theme.foregroundColor)
    lg.setFont(font)
    lg.printf(key.text, x, textY, width, "center")
end

-- Calculates "real" row heights so the keyboard fills up the draw area properly
function keypad:calculateRowHeights()
    local heightSum = 0
    for y, row in ipairs(self.layout) do
        heightSum = heightSum + row.settings.height
    end
    local difference = #self.layout - heightSum
    local delta = difference / #self.layout

    for i, row in ipairs(self.layout) do
        self.rowHeights[i] = row.settings.height + delta
    end
end

-- Calculates all the key positions and stores them in the key objects
function keypad:calculateKeyPositions(xOffset, yOffset, width, height)
    width = width - (THEME.key.padding * 2)
    height = height - (THEME.key.padding * 2)
    local rowY = 0
    for y, row in ipairs(self.layout) do
        local keyHeight = (height / #self.layout) * self.rowHeights[y]
        for x, key in ipairs(row.keys) do
            local keyWidth = (width / #row.keys)
            key.x = SAFE_X + (xOffset + THEME.key.padding) + keyWidth * (x - 1)
            key.y = SAFE_Y + (yOffset + THEME.key.padding) + rowY
            key.width = keyWidth
            key.height = keyHeight
        end   
        rowY = rowY + keyHeight
    end
end

function keypad:update(dt)
    for y, row in ipairs(self.layout) do
        for x, key in ipairs(row.keys) do
            key.anim = key.anim + (key.targetAnim - key.anim) * THEME.animationSpeed * dt
        end   
    end
end

function keypad:draw()
    for y, row in ipairs(self.layout) do
        for x, key in ipairs(row.keys) do
            self:drawKey(key)
        end   
    end
end

function keypad:mousepressed(x, y, mouse)
    if x > (lg.getWidth() * config.window.edgeDeadZone) and x < lg.getWidth() - (lg.getWidth() * config.window.edgeDeadZone) then
        for _, row in ipairs(self.layout) do
            for _, key in ipairs(row.keys) do
                if fmath.pointInRect(x, y, key.x, key.y, key.width, key.height) then
                    key.anim = 1
                    if type(key.func) == "function" then
                        key.func(key)
                    end
                end
            end   
        end
    end
end

return keypad