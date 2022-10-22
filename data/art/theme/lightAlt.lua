local function color(r, g, b, a)
    a = a or 255
    return {r / 255,  g / 255,  b / 255,  a / 255}
end
local accentColor = color(27, 38, 64)
local altAccentColor = color(11, 19, 36)
return {
    animationSpeed = 10,
    key = {
        backgroundColor = color(220, 220, 220),
        foregroundColor = accentColor,
        accentColor = accentColor,

        padding = 0,

        outline = false,
        outlineColor = color(237, 166, 78),
        outlineWidth = 1,

        font = "huge"
    },
    screen = {
        backgroundColor = altAccentColor,
        foregroundColor = color(220, 220, 220),

        mainText = {
            color = color(220, 220, 220),
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
            color = color(120, 120, 120),
            font = "medium",
            alignment = "center",
            horizontalPadding = 0 -- (Normalized)
        },
    },
    list = {
        backgroundColor = color(200, 200, 200),
        foregroundColor = accentColor,
        titleColor = accentColor,
        curtainColor = color(0, 0, 0, 200),

        corner = 16,

        outline = false,
        outlineColor = accentColor,
        outlineWidth = 2,

        width = 0.9, -- (Normalized)
        height = 0.9, -- (Normalized)

        font = "larger",
        titleFont = "large",
        alignment = "left",
        horizontalPadding = 0.02, -- (Normalized)
        verticalPadding = 0.01 -- (Normalized)
    }
}