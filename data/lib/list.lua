local list = {
    anim = 0,
    targetAnim = 0,
    list = {{}},
    page = 1,
    pages = 1,
    title = "list",
    subtitle = ""
}

-- lst: List to be displayed
-- title: Title displayed on top of the window
-- itemPressed: Function thats called when an item on the list is pressed
function list:show(lst, title, itemPressed, subtitle)
    lst = lst or {"no list"}

    self.targetAnim = 1
    self.visible = true
    self.list = self:splitList(lst)
    self.page = 1
    self.pages = #self.list
    self.title = title or "list"
    self.subtitle = subtitle or ""
    self.itemPressed = itemPressed or function() end
    self.ignorePress = true
    self.transition = true
end

function list:switchPage(p)
    local page = self.page + p
    if page > self.pages then
        page = self.pages
    elseif page < 1 then
        page = 1
    end
    self.page = page
end

function list:hide()
    self.targetAnim = 0
    self.visible = false
    self.transition = true
end

function list:load()
    self.width = lg.getWidth() * THEME.list.width 
    self.height = (lg.getHeight() * THEME.list.height)
    self.x = SAFE_X + (lg.getWidth() - self.width) / 2
    self.y = SAFE_Y + (lg.getHeight() - self.height) / 2
    self.transition = false
end

function list:splitList(list)
    local res = {{}}
    local fnt = font[THEME.list.font]
    self.lineHeight = fnt:getAscent() - fnt:getDescent()
    self.linesPerPage = floor(self.height / self.lineHeight) - 1


    local page = 1
    local currenti = 0
    for i,v in ipairs(list) do
        currenti = currenti + 1
        res[page][currenti] = v
        if currenti >= self.linesPerPage then
            page = page + 1
            currenti = 0
            res[page] = {}
        end
    end

    return res
end

function list:update(dt)
    self.anim = self.anim + (self.targetAnim - self.anim) * THEME.animationSpeed * dt
    if math.abs(self.anim - self.targetAnim) < 0.001 then
        self.transition = false
        self.anim = self.targetAnim
    end
end

function list:mousepressed(x, y, button) 
    if x > self.x and x < self.x + self.width and y > self.y + self.lineHeight and y < self.height and not self.ignorePress then
        local index = floor((y - SAFE_Y) / self.lineHeight) - 1 + (self.linesPerPage * (self.page - 1))
        if index <= #self.list[self.page] then
            self.itemPressed(self.list[self.page][index])
        end
    end
    self.ignorePress = false
end

function list:draw()
    lg.setColor(THEME.list.curtainColor)
    setAlpha(THEME.list.curtainColor[4] * self.anim)
    lg.rectangle("fill", 0, 0, getWidth(), getHeight())
    -- Background
    lg.setColor(THEME.list.backgroundColor)
    setAlpha(self.anim)
    local width = self.width
    local height = self.height * self.anim

    local x = self.x
    local y = SAFE_Y + (lg.getHeight() - height) / 2

    lg.rectangle("fill", x, y, width, height, THEME.list.corner, THEME.list.corner)

    if THEME.list.outline then
        lg.setColor(THEME.list.outlineColor)
        setAlpha(self.anim)
        local lw = lg.getLineWidth() 
        lg.setLineWidth(THEME.list.outlineWidth)
        lg.rectangle("line", x, y, width, height)
        lg.setLineWidth(lw)
    end

    lg.setColor(THEME.list.titleColor)
    setAlpha(self.anim)
    lg.setFont(font[THEME.list.titleFont])
    lg.printf(self.title, self.x, self.y + (self.height * THEME.list.verticalPadding) * self.anim, self.width, "center")

    --- content
    lg.setColor(THEME.list.foregroundColor)
    setAlpha(self.anim)
    lg.setFont(font[THEME.list.font])
    local fontHeight = lg.getFont():getAscent() - lg.getFont():getDescent()
    for i,v in ipairs(self.list[self.page]) do
        local text = v
        if #formatEquation(v) > 0 then
            text = formatEquation(v)
        end
        lg.printf(text, 
            x + (width * THEME.list.horizontalPadding) * self.anim, 
            y + (height * THEME.list.verticalPadding) + (fontHeight * (i)) * self.anim, 
            width, THEME.list.alignment)
    end

    lg.setColor(THEME.list.titleColor)
    setAlpha(self.anim)
    lg.setFont(font[THEME.list.titleFont])
    lg.printf(f("%s/%s", self.page, self.pages), 
        self.x - (self.width * THEME.list.horizontalPadding), 
        SAFE_Y + self.height - (self.height * THEME.list.verticalPadding), 
        self.width, "right")

    lg.setColor(THEME.list.titleColor)
    setAlpha(self.anim)
    lg.setFont(font.smaller)
    lg.printf(self.subtitle, self.x, SAFE_Y + self.height, self.width, "center")
end

return list