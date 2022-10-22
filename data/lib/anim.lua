-- A minimal animation library
local anim = {}
local anim_meta = {__index = anim}

local function loadAtlas(path, tileWidth, tileHeight, padding)
    assert(fs.getInfo(path), f("'%s' doesn't exist", path))
	local a = {}
	local img = love.graphics.newImage(path)
	local width = math.floor(img:getWidth() / tileWidth)
	local height = math.floor(img:getHeight() / tileHeight)
		
	local x, y = padding, padding
	for i=1, width * height do
		a[i] = love.graphics.newQuad(x, y, tileWidth, tileHeight, img:getWidth(), img:getHeight())
		x = x + tileWidth + padding
		if x > (width * tileWidth) then
			x = padding
			y = y + tileHeight + padding
		end
	end

	return img, a
end

-- Creates a new animation
-- path: Path to the spritesheet for the animation.
-- tilewidth & tileHeight: The width & height of the tiles in the spritesheet
-- padding: Padding of the spritesheet
-- loop: If false, The animation will play once, then stop
function anim.new(path, tileWidth, tileHeight, padding, loop)
    padding = padding or 0
    local img, frames = loadAtlas(path, tileWidth, tileHeight, padding)
    return setmetatable({
        image = img,
        frames = frames,
        currentFrame = 1,
        frameTime = 0.1,
        tick = 0,
        play = false,
        loop = loop,
        tileWidth = tileWidth,
        tileHeight = tileHeight
    }, anim_meta)
end

function anim:start(reset)
    if reset then self:reset() end
    self.play = true
end

function anim:stop()
    self.play = false
end

function anim:reset()
    self.currentFrame = 1
end

function anim:setFrameTime(frameTime)
    if type(frameTime) == "table" then
        assert(#frameTime == #self.frames, "The frameTime table length must match the frames in the animation")
    end
    self.frameTime = frameTime
end

function anim:setFrame(frame)
    self.currentFrame = frame
    if self.currentFrame > #self.frames then
        self.currentFrame = #self.frames
    elseif self.currentFrame < 1 then
        self.currentFrame = 1
    end
end

function anim:update(dt)
    if self.play then
        self.tick = self.tick + dt

        local frameTime
        if type(self.frameTime) == "table" then
            frameTime = self.frameTime[self.currentFrame] 
        elseif type(self.frameTime) == "number" then
            frameTime = self.frameTime
        end
        if self.tick > frameTime then
            self.currentFrame = self.currentFrame + 1
            if self.currentFrame > #self.frames then
                if not self.loop then
                    self:reset()
                    self:stop()
                end
                self.currentFrame = 1
            end 
            self.tick = 0
        end
    end
end

function anim:draw(x, y, rotation, scaleX, scaleY, originX, originY)
    lg.draw(self.image, self.frames[self.currentFrame], math.floor(x), math.floor(y), rotation or 0, scaleX or 0, scaleY or 0, originX or 0, originY or 0) 
end

return anim