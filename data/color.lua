local function color(r, g, b, a)
    a = a or 255
    return {r / 255,  g / 255,  b / 255,  a / 255}
end
return {
    white = color(255, 255, 255),
    black = color(0, 0, 0),
    lightGray = color(200, 200, 200),
    midGray = color(128, 128, 128),
    darkGray = color(20, 20, 20),
    red = color(224, 38, 38),
    orange = color(240, 132, 31),
    yellow = color(237, 237, 21),
    limeGreen = color(158, 237, 21),
    green = color(57, 237, 21),
    mintGreen = color(21, 237, 111),
    lightBlue = color(21, 226, 237),
    skyBlue = color(21, 140, 237),
    blue = color(21, 43, 237),
    purple = color(111, 21, 237),
    pink = color(223, 21, 237),
    hotPink = color(237, 21, 158),
    brown = color(46, 30, 25),
    darkGreen = color(13, 36, 9),
    darkBlue = color(13, 13, 31),
}