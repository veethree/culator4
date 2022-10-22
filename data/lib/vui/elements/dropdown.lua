local dropdown = {
    type = "dropdown",
    selectedItem = 1,
}

function dropdown:load(resize)
    if not resize then
        self.text = self.items[self.selectedItem]
        self.selected = false
        self.drawHeight = self.height
    end
end

function dropdown.mousepressed(self, x, y)
    self.selected = not self.selected
    if not self.selected then
        self.text = self.items[self.selectedItem]
    end
end

function dropdown.draw(self, x, y, width, height)
    local height = self.container.height * self.drawHeight 
    local mx, my = love.mouse.getPosition()
    lg.setColor(self.style.backgroundColor)
    lg.rectangle("fill", x, y, width, height)

    lg.setColor(self.style.foregroundColor)
    lg.setFont(self.style.font)
    local textY = self.container.util.centerTextVertically(self, self.text, self.style.font)
    lg.printf(self.text, x, textY, width, "center")

    if self.mouseOver then
        lg.setColor(self.style.accentColor)
        lg.rectangle("line", x, y, width, height)
    end

    if self.selected then
        for i, item in ipairs(self.items) do
            local itemX, itemY = x, y + (height * i)
            lg.setColor(self.style.backgroundColor)
            lg.rectangle("fill", x, itemY, width, height)

            lg.setColor(self.style.foregroundColor)
            local textY = self.container.util.centerTextVertically(self, self.text, self.style.font) + (height * i)
            lg.printf(item, x, textY, width, "center")

            if self.container.util.pointInRect(mx, my, itemX, itemY, width, height) then
                lg.setColor(self.style.accentColor)
                lg.rectangle("line", x, itemY, width, height)
                self.selectedItem = i
            end
        end
    end
end

return dropdown