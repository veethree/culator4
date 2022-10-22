local textbox = {
    type = "textbox",
}

function textbox:load()
    self.limit = 100
end

function textbox.mousepressed(self, x, y)
    self.selected = not self.selected
end

function textbox.textinput(self, t)
    if self.selected then
        if #self.text < self.limit then
            self.text = self.text..t
        end
    end
end

function textbox.keypressed(self, key)
    if self.selected then
        if key == "backspace" then
            self.text = self.text:sub(1, -2)
        end
    end
end

function textbox.draw(self, x, y, width, height)
    lg.setColor(self.style.backgroundColor)
    lg.rectangle("fill", x, y, width, height)

    lg.setColor(self.style.disabledForegroundColor)
    lg.setFont(self.style.font)
    local textX, textY = self.container.util.positionTextInElement(self, self.text, self.style.font, "left")
    local text = self.placeholder
    if #self.text > 0 then
        text = self.text 
        lg.setColor(self.style.foregroundColor)
    end
    lg.printf(text, textX, textY, width - (width * self.style.horizontalPadding * 2), "center")

    if self.mouseOver then
        lg.setColor(self.style.accentColor)
        lg.rectangle("line", x, y, width, height)
    end
end

return textbox