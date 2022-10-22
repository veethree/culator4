local slider = {
    type = "slider",
}

function slider.mousedown(self, mx, my)
    local x, y, width, height = self.container.util.getRect(self)
    self.value = math.floor(self.container.util.lerp(self.container.util.normal(mx, x, x + width), self.minValue, self.maxValue))
end

function slider.mouseleave(self, mx, my)
    if love.mouse.isDown(1) then
        local x, y, width, height = self.container.util.getRect(self)
        if mx > x + width then
            self.value = self.maxValue
        elseif mx < x then
            self.value = self.minValue
        end
    end
end

function slider.draw(self, x, y, width, height)
    lg.setColor(self.style.backgroundColor)
    lg.rectangle("fill", x, y, width, height)

    lg.setColor(self.style.foregroundColor)
    lg.rectangle("fill", x  + width * self.container.util.normal(self.value, self.minValue, self.maxValue), y, width * 0.01, height)

    lg.setColor(self.style.foregroundColor)
    local text = self.text
    if self.mouseOver then
        lg.setColor(self.style.accentColor)
        text = self.value
    end
    --lg.rectangle("line", x, y, width, height)

    lg.setFont(self.style.font)
    local textY = self.container.util.centerTextVertically(self, self.text, self.style.font)
    lg.printf(text, x, textY, width, "center")

end

return slider