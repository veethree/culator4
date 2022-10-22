-- Various utility functions
--Weighted random
function wRand(weights)
    local weightSum = 0
    for i,v in ipairs(weights) do weightSum = weightSum + v end 
    local target = weightSum * random()
    local rSum = 0
    for i,v in ipairs(weights) do
        rSum = rSum + v
        if rSum > target then
            return i
        end
    end
end

-- Formats an equation so the numbers in it have commas (1234+4321 > 1,234+4,321)
function formatEquation(equation)
    local split = {}
    for word in tostring(equation):gmatch("[%d%.]+.?") do
        if #word > 1 then
            if not tonumber(word:sub(-1)) then
                split[#split+1] = word:sub(1, -2)
                split[#split+1] = word:sub(-1)
            else
                split[#split+1] = word
            end
        else
            split[#split+1] = word  
        end
    end

    local reconstructed = ""
    for i,v in ipairs(split) do 
        if tonumber(v) then v = comma(v) end
        reconstructed = reconstructed .. v
    end
    return reconstructed
end

function reverse(tab)
    local res = {}
    for i=#tab, 1, -1 do
        res[#res+1] = tab[i]
    end
    return res
end

function randomAverage(total, items, difference)
    local list = {}
    local average = total / items

    -- First stage
    -- Creating the initial list. Does not add up to "total" yet.
    local sum = 0
    for i=1, items do
        list[i] = math.floor(average + math.random(-difference, difference))
        sum = sum + list[i]
    end

    -- Calculating the error, And adding/subtracting the average
    -- error from the list items
    local error = total - sum
    local averageError = error / items
    sum = 0
    for i=1, items do
        list[i] = list[i] + averageError
        sum = sum + list[i]

        error = error - averageError
        if math.floor(error) == 0 then
            break
        end
    end

    -- Rounding numbers 
    sum = 0
    for i=1, items do
        list[i] = math.floor(list[i])
        sum = sum + list[i]
        --print(list[i])
    end

    -- If there's a remainder, Add it to a random item.
    if sum ~= total then
        local i = math.random(items)
        list[i] = list[i] + (total - sum) 
    end
    
    local finalSum = 0
    for i=1, items do
        finalSum = finalSum + list[i]
    end
    return list
end

function setAlpha(a)
    local r, g, b = lg.getColor()
    lg.setColor(r, g, b, a)
end

-- Source: http://lua-users.org/wiki/FormattingNumbers
function comma(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
        break
        end
    end
    return formatted
end

-- Hooks a custom function to a löve callback
function hook(callback, func, ...)
    local arguments = {...}
    local base = love[callback] or function() end
    love[callback] = function(...)
        base(...)
        func(unpack(arguments))
    end
end

-- Source: http://lua-users.org/wiki/CopyTable
function copyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[copyTable(orig_key)] = copyTable(orig_value)
        end
        setmetatable(copy, copyTable(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Converts a color from 0-255 to 0-1, returns a table
local function convertColor(r, g, b, a)
    a = a or 255
    return {r / 255,  g / 255,  b / 255,  a / 255}
end

-- Runs a function for each item in a directory
-- The function receives the following arguments, in this order:
--  fileName: The file name, ex: "main.lua"
-- filePath: The path to the file, ex: "data/art/player.png"
-- fileType: The type of file, Directory or file
function iterateDirectory(directory, func)
    assert(fs.getInfo(directory), f("The directory '%s' doesn't exist", directory))

    func = func or function() end

    for _, file in ipairs(fs.getDirectoryItems(directory)) do
        local path = directory.."/"..file
        local fileType = fs.getInfo(path).type
        func(file, path, fileType)
    end
end

function requireFolder(folder)
    if fs.getInfo(folder) then
        for i,v in ipairs(fs.getDirectoryItems(folder)) do
            if fs.getInfo(folder.."/"..v).type == "directory" then
                _G[v] = require(folder.."."..v)
            else
                if getFileType(v) == "lua" then
                    _G[getFileName(v)] = require(folder.."."..getFileName(v))
                end
            end
        end
    else
        error(string.format("Folder '%s' does not exists", folder))
    end
end

function getFileType(file_name)
    return string.match(file_name, "%..+"):sub(2)
end

function getFileName(file_name)
    return string.match(file_name, ".+%."):sub(1, -2) 
end

function setColor(r, g, b, a)
    lg.setColor(convertColor(r, g, b, a))
end

function loadAtlas(path, tileWidth, tileHeight, padding)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	end

	local a = {}
	local img = love.graphics.newImage(path)
	local width = math.floor(img:getWidth() / tileWidth)
	local height = math.floor(img:getHeight() / tileHeight)
		
	local x, y = padding, padding
	for i=1, width * height do
		a[i] = love.graphics.newQuad(x, y, tileWidth, tileHeight, img:getWidth(), img:getHeight())
		x = x + tileWidth + padding
		if x > ((width-1) * tileWidth) then
			x = padding
			y = y + tileHeight + padding
		end
	end

	return img, a
end