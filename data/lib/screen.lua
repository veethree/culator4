local screen = {}
local mt = {__index = screen}

function screen.new(x, y, width, height)
    return setmetatable({
        x = x or SAFE_X,
        y = y or SAFE_Y,
        width = width or lg.getWidth(),
        height = height or lg.getHeight(),
        padding = 0.1, -- Normalized value
        mainText = "",
        formulaText = "",
        commentText = "",

    }, mt)
end

function screen:print(text)
    self.mainText = text or ""
end

function screen:printComment(text)
    self.commentText = text or ""
end

function screen:printFormula(text)
    self.formulaText = text or ""
    config.screenEquation = self.formulaText
    ttf.save(config, "config.lua")
end

function screen:read()
    return self.mainText
end

function screen:drawText()

end


function screen:draw()
    lg.setColor(THEME.screen.backgroundColor)
    lg.rectangle("fill", self.x, self.y, self.width, self.height)

    -- formula Text
    lg.setFont(font[THEME.screen.formulaText.font])
    lg.setColor(THEME.screen.formulaText.color)
    local horizontalPadding = THEME.screen.formulaText.horizontalPadding
    if THEME.screen.formulaText.alignment == "right" then
        horizontalPadding = -horizontalPadding
    end
    local formulaText =  formatEquation(self.formulaText)
    lg.printf(formulaText, self.width * horizontalPadding, SAFE_Y + self.height * 0.5, self.width, THEME.screen.formulaText.alignment)

    -- Main
    local fonts = THEME.screen.mainText.font
    
    local fits = false
    for i,fnt in ipairs(fonts) do
        local w, lines = font[fnt]:getWrap(self.mainText, self.width)
        if #lines == 1 then
            lg.setFont(font[fnt])
            fits = true
            break
        end
    end

    lg.setColor(THEME.screen.mainText.color)
    local horizontalPadding = THEME.screen.mainText.horizontalPadding
    if THEME.screen.mainText.alignment == "right" then
        horizontalPadding = -horizontalPadding
    end
    local y = SAFE_Y + self.height * 0.8 - (lg.getFont():getAscent() - lg.getFont():getDescent())

    local mainText = formatEquation(self.mainText)
    lg.printf(mainText, self.width * horizontalPadding, y, self.width, THEME.screen.mainText.alignment)

    -- comment
    lg.setFont(font[THEME.screen.commentText.font])
    lg.setColor(THEME.screen.commentText.color)
    local horizontalPadding = THEME.screen.commentText.horizontalPadding
    if THEME.screen.commentText.alignment == "right" then
        horizontalPadding = -horizontalPadding
    end
    lg.printf(self.commentText, self.width * horizontalPadding, SAFE_Y + self.height * 0.88, self.width, THEME.screen.commentText.alignment)
end

return screen