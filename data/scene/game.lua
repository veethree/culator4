local game = {}

function game:load()
    -- Keeping the theme global becase its easier that way
    loadTheme(config.theme)
    lg.setBackgroundColor(THEME.screen.backgroundColor)
    list:load()

    -- Screen
    self:refresh()
    SCREEN = screen.new(SAFE_X, SAFE_Y, lg.getWidth(), self.keypadHeight)
    calculator:load()
    -- Random average business
    self.randomAverage = {
        total = false,
        items = false,
        difference = 80
    }


    gesture:bind("swipeDown", function() list:hide() end)
    gesture:bind("swipeRight", function() 
        if list.visible then
            list:switchPage(-1)
        end
    end)
    gesture:bind("swipeLeft", function() 
        if list.visible then
            list:switchPage(1)
        end
    end)

    
    -- Show history gesture
    gesture:bind("swipeRight", function() 
        print("history")
        list:show(history, "History", false, "Swipe up to clear history")
    end, {0, 0, lg.getWidth() * config.window.edgeDeadZone, lg.getHeight()}, false, function()
        return not list.visible
    end)

    -- Show Memory gesture
    gesture:bind("swipeRight", function() 
        print("memory")
        list:show(memory, "Memory", function(item)
            list:hide()
            SCREEN:print(item)  
            SCREEN:printComment("Recalled from memory")  
        end, "Swipe up to clear memory")
    end, {0, 0, lg.getWidth() * config.window.edgeDeadZone, lg.getHeight()}, false, function()
        return list.visible and list.title == "History" and not list.transition
    end)

    -- Clear History gesture
    gesture:bind("swipeUp", function() 
        SCREEN:printComment("History Cleared")
        history = {}
        ttf.save(history, "history.lua")
        list:hide()
    end, false, false, function()
        return list.visible and list.title == "History"
    end)

    -- Clear memory gesture
    gesture:bind("swipeUp", function() 
        SCREEN:printComment("Memory Cleared")
        memory = {}
        ttf.save(memory, "memory.lua")
        list:hide()
    end, false, false, function()
        return list.visible and list.title == "Memory"
    end)

    gesture:bind("swipeUp", function() 
        SCREEN:printComment("Config Cleared")
        config = defaultConfig
        ttf.save(config, "config.lua")
        list:hide()
        loadTheme(config.theme)
    end, false, false, function()
        return list.visible and list.title == "Select Theme"
    end)

    -- Theme selection gesture
    local themes = {}
    iterateDirectory("data/art/theme", function(file)
        themes[#themes+1] = getFileName(file)
    end)
    gesture:bind("swipeLeft", function() 
        list:show(themes, "Select Theme", function(item)
            loadTheme(item)
        end, "Swipe up to clear config")
    end, {lg.getWidth() - (lg.getWidth() * config.window.edgeDeadZone), 0, lg.getWidth() * config.window.edgeDeadZone, lg.getHeight()})

    SCREEN:printComment("Welcome to culator 4")
    SCREEN:printFormula(config.screenEquation)
end

function game:refresh()
    -- Defining Keypad
    self.keypad = keypad.new()
    self.keypad:addRow({
        {text = "Random Average", func = function(key) 
            local total = SCREEN:read()
            if not tonumber(total) then 
                SCREEN:printComment("Invalid input")
                return 
            end
            self.randomAverage.total = total
            calculator:clear()
            SCREEN:printComment("Enter items")
        end, theme = {font = "smaller", backgroundColor = THEME.key.accentColor, foregroundColor = THEME.key.backgroundColor}},

        {text = "Store In Memory", func = function(key)
            local val = SCREEN:read()
            if #val > 0 then
                for i,v in ipairs(memory) do
                    if v == val then
                        SCREEN:printComment("Value already in memory")
                        return
                    end
                end
                memory[#memory+1] = SCREEN:read()
                ttf.save(memory, "memory.lua")
                SCREEN:printComment("Stored in memory")
            else
                SCREEN:printComment("No value")
            end
        end, theme = {font = "smaller", backgroundColor = THEME.key.accentColor, foregroundColor = THEME.key.backgroundColor}}},
        {height = 0.5})
    :addRow({
        {text = "c", func = function(key) 
            calculator:clear() 
            SCREEN:printComment()
            self.randomAverage.total = false
            self.randomAverage.items = false
        end},
        {text = "*", func = function(key) calculator:append("*") end},
        {text = "<", func = function(key) calculator:backspace() end}},
        {height = 1, color = color.red})

    :addRow({
        {text = "7", func = function(key) calculator:append(key.text) end},
        {text = "8", func = function(key) calculator:append(key.text) end},
        {text = "9", func = function(key) calculator:append(key.text) end},
        {text = "/", func = function(key) calculator:append(key.text) end}},
        {height = 1, color = color.red})
    :addRow({
        {text = "4", func = function(key) calculator:append(key.text) end},
        {text = "5", func = function(key) calculator:append(key.text) end},
        {text = "6", func = function(key) calculator:append(key.text) end},
        {text = "+", func = function(key) calculator:append(key.text) end}},
        {height = 1, color = color.red})
    :addRow({
        {text = "1", func = function(key) calculator:append(key.text) end},
        {text = "2", func = function(key) calculator:append(key.text) end},
        {text = "3", func = function(key) calculator:append(key.text) end},
        {text = "-", func = function(key) calculator:append(key.text) end}},
        {height = 1, color = color.red})
    :addRow({
        {text = "0", func = function(key) calculator:append(key.text) end},
        {text = ".", func = function(key) calculator:append(key.text) end},
        {text = "=", func = function(key) 
            if self.randomAverage.total then
                local items = SCREEN:read()
                if tonumber(SCREEN:read()) then
                    items = tonumber(items)
                    if items > 0 then
                        self.randomAverage.items = items
                        local lst = randomAverage(self.randomAverage.total, self.randomAverage.items, self.randomAverage.difference)
                        list:show(lst, "Random Average")
                        SCREEN:printComment()
                        calculator:clear()
                        return
                    end
                end
            end
            calculator:solve() 
        end}},
        {height = 1, color = color.red})

    self.keypad:calculateRowHeights()

    self.keypadHeight = lg.getHeight() * 0.4
    self.keypad:calculateKeyPositions(0, self.keypadHeight, lg.getWidth(), lg.getHeight() - self.keypadHeight)
end

function game:update(dt)
    list:update(dt)
    self.keypad:update(dt)
end

function game:draw()
    self.keypad:draw()
    SCREEN:draw()
    list:draw()
end

function game:keypressed(key)
    if key == "space" then
        loadTheme("light")
    end
end

function game:keyreleased(key)

end

function game:textinput(t)

end

function game:mousepressed(x, y, button)
    if not list.visible then
        self.keypad:mousepressed(x, y, button)
    else
    end
end

function game:mousereleased(x, y, button)
    if list.visible then
        list:mousepressed(x, y, button)
    end
end

function game:wheelmoved(x, y)
    
end

return game