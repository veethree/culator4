local function color(r, g, b, a)
    a = a or 255
    return {r / 255,  g / 255,  b / 255,  a / 255}
end
local accentColor = color(46, 104, 191)
return {
    animationSpeed = 10,
    key = {
        backgroundColor = color(220, 220, 220),
        foregroundColor = color(20, 20, 20),
        accentColor = accentColor,

        padding = 1,

        outline = false,
        outlineColor = color(237, 166, 78),
        outlineWidth = 1,

        font = "huge"
    },
    screen = {
        backgroundColor = color(200, 200, 200),
        foregroundColor = color(20, 20, 20),

        mainText = {
            color = color(20, 20, 20),
            font = {
                "huge",
                "larger",
                "large",
                "medium",
                "small",
                "smaller",
            },
            alignment = "right",
            horizontalPadding = 0.03 -- (Normalized)
        },
        formulaText = {
            color = color(40, 40, 40),
            font = "medium",
            alignment = "right",
            horizontalPadding = 0.03 -- (Normalized)
        },
        commentText = {
            color = accentColor,
            font = "medium",
            alignment = "center",
            horizontalPadding = 0 -- (Normalized)
        },
    },
    list = {
        backgroundColor = color(200, 200, 200),
        foregroundColor = color(20, 20, 20),
        titleColor = accentColor,
        curtainColor = color(0, 0, 0, 200),

        corner = 16,

        outline = false,
        outlineColor = accentColor,
        outlineWidth = 2,

        width = 0.9, -- (Normalized)
        height = 0.9, -- (Normalized)

        font = "larger",
        titleFont = "largeBold",
        alignment = "left",
        horizontalPadding = 0.02, -- (Normalized)
        verticalPadding = 0.01 -- (Normalized)
    }
}