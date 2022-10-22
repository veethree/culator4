return {
    window = {
        title = f("%s [%s]", NAME, VERSION),
        width = 540,
        height = 960,
        fullscreen = false,
        fullscreenType = "exclusive",
        vsync = true,
        resizable = false,
        minWidth = 100,
        minHeight = 100,
        edgeDeadZone = 0.05 -- Normalized, Area around the left & right edges where touches are ignored
    },
    screen = {
        decimalPlaces = 3
    },
    theme = "dark",
    equation = "",
    screenEquation = ""
}