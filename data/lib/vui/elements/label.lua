local label = {
    type = "label",
}

function label:load()
    self.width = self.container.util.normal(self.style.font:getWidth(self.text), 0, self.container.width)
    self.height = self.container.util.normal(self.style.font:getAscent() - self.style.font:getDescent(), 0, self.container.height)
end

function label.draw(self, x, y, width, height)
    lg.setColor(self.style.foregroundColor)
    lg.setFont(self.style.font)
    lg.printf(self.text, x, y, width, "center")
end

return label