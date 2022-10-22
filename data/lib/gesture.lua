local gesture = {
    bound = {
        swipeLeft = {},
        swipeRight = {},
        swipeDown = {},
        swipeUp = {},
    }
}

local function pointInRect(px, py, rx, ry, rw, rh)
	return px > rx and px < rx + rw and py > ry and py < ry + rh
end

function gesture:load()
    self.threshold = lg.getWidth() * 0.3
    self.timeLimit = 1
    self.timeDown = 0
    self.touchDown = false
end

-- gest: Gesture ("swipeDown", "swipeUp", "swipeLeft", "swipeRight")
-- func: Function to be called when gesture is detected
-- startRect: A rectangle where the gesture can start ({x, y, width, height})
-- endRect: A rectangle where the gesture can endRect ({x, y, width, height})
-- condition: A function. Func is only called if this function returns true.
function gesture:bind(gest, func, startRect, endRect, condition)
    if type(condition) ~= "function" then condition = function() return true end end
    self.bound[gest][#self.bound[gest]+1] = {
        func = func,
        startRect = startRect or false,
        endRect = endRect or false,
        condition = condition
    }
end

function gesture:update(dt)
    if self.touchDown then
        self.timeDown = self.timeDown + dt
    end
end

function gesture:mousepressed(x, y, k)
    self.startX, self.startY = x, y
    self.touchDown = true
end

function gesture:mousereleased(x, y, k)
    self.endX, self.endY = x, y

    local xDiff = self.startX - self.endX
    local yDiff = self.startY - self.endY

    local gest = false

    if max(abs(xDiff), abs(yDiff)) > self.threshold then
        if abs(xDiff) > abs(yDiff) then
            if xDiff > 0 then
                gest = "swipeLeft"
            else
                gest = "swipeRight"
            end
        else
            if yDiff > 0 then
                gest = "swipeUp"
            else
                gest = "swipeDown"
            end
        end
    end

    if gest and self.timeDown < self.timeLimit then
        for i,v in ipairs(self.bound[gest]) do
            if v.startRect then
                if not pointInRect(self.startX, self.startY, v.startRect[1], v.startRect[2], v.startRect[3], v.startRect[4]) then
                    return
                end
            end
            if v.endRect then
                if not pointInRect(self.endX, self.endY, v.endRect[1], v.endRect[2], v.endRect[3], v.endRect[4]) then
                    return
                end
            end
            if v.condition() then 
                v.func()
            end
        end
    end
    self.touchDown = false
    self.timeDown = 0
end

return gesture