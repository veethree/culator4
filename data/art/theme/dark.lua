local function color(r, g, b, a)
    a = a or 255
    return {r / 255,  g / 255,  b / 255,  a / 255}
end
local accentColor = color(46, 104, 191)
return {
    animationSpeed = 10,
    key = {
        backgroundColor = color(21, 25, 36),
        foregroundColor = color(183, 203, 247),
        accentColor = accentColor,

        padding = 1,

        outline = false,
        outlineColor = accentColor,
        outlineWidth = 1,

        font = "huge"
    },
    screen = {
        backgroundColor = color(7, 12, 23),
        foregroundColor = color(200, 200, 200),

        mainText = {
            color = color(200, 200, 200),
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
            color = color(120, 120, 120),
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
        backgroundColor = color(7, 12, 23),
        foregroundColor = color(200, 200, 200),
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