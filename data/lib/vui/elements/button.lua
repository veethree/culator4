local button = {
    type = "button",
}

function button.draw(self, x, y, width, height)
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
end

return button