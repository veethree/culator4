-- Various utility functions that help vui function right, Seperated to their own file for decluttering purposes
return {
    -- Checks if a point is inside a rectangle
    pointInRect = function(px, py, rx, ry, rw, rh)
        return px > rx and px < rx + rw and py > ry and py < ry + rh
    end,

    -- Hooks a function to a löve callback function
    hook = function (callback, func, ...) 
        local arguments = {...}
        local base = love[callback] or function() end
        love[callback] = function(...)
            base(...)
            func(unpack(arguments), ...)
        end
    end,

    -- Returns the elements rectangle in real coordinates!
    getRect = function(element)
        local x, y, width, height = element.container.x + element.x * element.container.width, element.container.y + element.y * element.container.height, element.container.width * element.width, element.container.height * element.height 
        if element.origin == "left" then
            return x, y, width, height
        elseif element.origin == "center" then
            return x - (width / 2), y - (height / 2), width, height
        elseif element.origin == "right" then
            return x - width, y, width, height
        end
    end,

    normal = function(val, min, max)
        return (val - min) / (max - min)
    end,

    lerp = function(val, min, max)
        return (max - min) * val + min
    end,

    -- Consolidates two tables, b is the dominant one
    consolidate = function(a, b, replace)
        for key,value in pairs(b) do
            if replace then
                a[key] = value
            else
                if not a[key] then
                    a[key] = value
                end
            end
        end
    end,

    positionTextInElement = function(element, text, font, alignment)
        alignment = alignment or "center"
        local x, y, width, height = element.container.util.getRect(element)
        local xOffset = 0

        if alignment == "left" then
            xOffset = width * element.style.horizontalPadding
        end


        local fontHeight = font:getAscent() - font:getDescent()
        local _, lines = font:getWrap(text, width)
        local textHeight = fontHeight * #lines
        return x + xOffset, y + (height / 2) - (textHeight / 2)
    end,

    -- Misleading name, Only centers on the y axis because the horizontal centering is handled by printf :D
    centerTextVertically = function(element, text, font)
        local x, y, width, height = element.container.util.getRect(element)
        local fontHeight = font:getAscent() - font:getDescent()
        local _, lines = font:getWrap(text, width)
        local textHeight = fontHeight * #lines
        return y + (height / 2) - (textHeight / 2)
    end
}