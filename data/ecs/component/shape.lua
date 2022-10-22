-- A shape component, Shape can be any löve primative with the exception of polygon
-- In case of a circle, the width parameter will be used as the radius and height as segments
return function(component, shape, drawMode, width, height)
    component.shape = shape or "rectangle"
    component.drawMode = drawMode or "fill"
    component.width = width or 32
    component.height = height or 32
end