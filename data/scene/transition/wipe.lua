-- Transition stages: in, out, finished
local wipe = {}

function wipe:load()
    self.stage = "in"
    self.progress = 0
    self.speed = 0.00001
end

function wipe:update(dt)
    if self.stage == "in" then
        smoof:new(self, {progress = 1}, self.speed, 0.01, false, {onArrive = function() self.stage = "out" end})
    elseif self.stage == "out" then
        smoof:new(self, {progress = 0}, self.speed, 0.01, false, {onArrive = function() self.stage = "finished" end})
    end
end

function wipe:draw()
    lg.setColor(0, 0, 0, 1)
    lg.rectangle("fill", lg.getWidth() * (1 - self.progress), 0, lg.getWidth(), lg.getHeight())
end

return wipe