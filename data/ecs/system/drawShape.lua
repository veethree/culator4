-- Shape drawing system. It will process entities with a shape, transform and visible components
return vecs.system()
:callback("filter", function(entity)
    return entity.position and entity.shape and entity.visible
end)
:callback("draw", function(entity)
    if entity.color then
        lg.setColor(entity.color.r, entity.color.g, entity.color.b, entity.color.a)
    else
        lg.setColor(color.white)
    end
    lg[entity.shape.shape](entity.shape.drawMode, entity.position.x, entity.position.y, entity.shape.width, entity.shape.height)

    -- DEbug situation
    if entity.angle then
        local x = entity.position.x + 50 * cos(entity.angle) 
        local y = entity.position.y + 50 * sin(entity.angle) 
        lg.circle("fill", x, y, 2)
    end
end)