-- Transition stages: in, out, finished
local fade = {}

function fade:load()
    self.stage = "in"
    self.progress = 0
    self.speed = 0.00001
end

function fade:update(dt)
    if self.stage == "in" then
        smoof:new(self, {progress = 1}, self.speed, 0.01, false, {onArrive = function() self.stage = "out" end})
        --function smoof:new(object, target, smoof_value, completion_threshold, bind, callback)
    elseif self.stage == "out" then
        smoof:new(self, {progress = 0}, self.speed, 0.01, false, {onArrive = function() self.stage = "finished" end})
    end
end

function fade:draw()
    lg.setColor(0, 0, 0, self.progress)
    lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())
end

return fade