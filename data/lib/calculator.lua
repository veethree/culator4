-- Calculator module that does the calculator stuff
local utf8 = require "utf8"
local calculator = {
    equation = ""
}

function calculator:load()
    self.equation = config.equation
    SCREEN:print(self.equation)
end

function calculator:append(t)
    if not scene:get().randomAverage.total then
        SCREEN:printComment()
    end
    -- Operators
    if not tonumber(t) then -- If operator
        if not self.equation:endsWith("%d") then
            return
        end
    end
    -- Decimal
    if t == "." then
        -- #TODO Implement this
    end
    self.equation = self.equation .. t
    config.equation = self.equation
    ttf.save(config, "config.lua")
    SCREEN:print(self.equation)
end

function calculator:clear()
    self.equation = ""
    config.equation = self.equation
    ttf.save(config, "config.lua")
    SCREEN:print(self.equation)
    SCREEN:printFormula()
end

function calculator:backspace()
    local offset = utf8.offset(self.equation, -1)
    if offset then
        self.equation = self.equation:sub(1, offset - 1)
    end
    config.equation = self.equation
    ttf.save(config, "config.lua")
    SCREEN:print(self.equation)
end

function calculator:solve()
    if #self.equation > 0 then
        local func, err = loadstring(f("return tostring(%s)", self.equation))
        if func then
            if history[#history] ~= self.equation then
                history[#history+1] = self.equation
            end
            ttf.save(history, "history.lua")
            SCREEN:printFormula(self.equation)
            self.equation = func()
            config.equation = self.equation
            ttf.save(config, "config.lua")
            SCREEN:print(self.equation)
        else
            SCREEN:print(err)
        end
    end
end


return calculator