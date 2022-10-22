-- This module loads tiled maps and has a few handy functions for dealing with them
local tiled = {}
local _tiled = {__index = tiled}

function tiled.new(path)
    assert(fs.getInfo(path), f("'%s' doesn't exist", path))
    return setmetatable({
        map = fs.load(path)()
    }, _tiled)
end

-- Iterates each tile in a layer
-- Optionally takes x, y, and tileSize to scale and offset the tileX and tileY that's passed to func
function tiled:iterateTiles(layerIndex, func, x, y, tileSize)
    assert(self.map.layers[layerIndex], f("Layer %d doesn't exists", layerIndex))
    x = x or 0
    y = y or 0
    tileSize = tileSize or 1
    local layer = self.map.layers[layerIndex]
    if layer.type == "tilelayer" then
        local tileX, tileY = 0, 0
        for _, tile in ipairs(layer.data) do
            func(tile, x + tileX * tileSize, y + tileY * tileSize)
            tileX = tileX + 1
            if tileX > layer.width then
                tileX = 1
                tileY = tileY + 1
            end
        end
    end
end

-- get layer by name
function tiled:getLayerByName(layerName)
    for index, layer in ipairs(self.map.layers) do
        if layer.name == layerName then
            return layer, index
        end
    end
    return false
end

-- Sets the tile atlas for this map
-- image should be the tileset, and quads the quads in a table, e.g the output from "loadAtlas"
-- Must be called before the draw function
function tiled:setTileAtlas(image, quads)
    self.tileSet = image
    self.quad = quads
    self.spriteBatch = lg.newSpriteBatch(self.tileSet)
end

function tiled:drawLayer(layer, x, y, tileSize)
    self.spriteBatch:clear()

    self:iterateTiles(layer, function(tile, tileX, tileY)
        if tile > 0 then
            self.spriteBatch:add(self.quad[tile], x + tileX * tileSize, y + tileY * tileSize, 0, tileSize / self.map.tilewidth , tileSize / self.map.tileheight)
        end
    end)
    lg.setColor(color.white)
    lg.draw(self.spriteBatch)
end

function tiled:draw(x, y, tileSize)
    for index, layer in ipairs(self.map.layers) do
        if layer.type == "tilelayer" then
            self:drawLayer(index, x, y, tileSize)
        end
    end
end

return tiled