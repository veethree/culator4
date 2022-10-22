local checkbox = {
    type = "checkbox",
}

function checkbox:load(resize)
    self.height = self.container.util.normal(self.style.font:getAscent() - self.style.font:getDescent(), 0, self.container.height)
    self.width = self.container.util.normal(self.style.font:getWidth(self.text), 0, self.container.width) + self.height
    if not resize then
        self.checked = false
    end
end

function checkbox.mousepressed(self, x, y, button)
    self.checked = not self.checked
end

function checkbox.draw(self, x, y, width, height)
    -- lg.rectangle("line", x, y, width, height)
    lg.setColor(self.style.foregroundColor)
    lg.setFont(self.style.font)
    lg.printf(self.text, x, y, width, "right")

    local mode = "line"
    if self.checked then mode = "fill" end
    if self.mouseOver then
        lg.setColor(self.style.accentColor)
    end
    lg.rectangle(mode, x, y, height, height)
end

return checkbox