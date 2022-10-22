return function(component, x, y, rotation, scaleX, scaleY, originX, originY)
    component.x = x or 0
    component.y = y or 0
    component.rotation = rotation or 0
    component.scaleX = scaleX or 1
    component.scaleY = scaleY or 1
    component.originX = originX or 0
    component.originY = originY or 0
end