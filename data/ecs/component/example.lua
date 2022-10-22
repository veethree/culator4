--Component files return a populate function!

return function(component, a, b)
    component.a = a or false
    component.b = b or 1
end