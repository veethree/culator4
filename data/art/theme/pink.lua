local function color(r, g, b, a)
    a = a or 255
    return {r / 255,  g / 255,  b / 255,  a / 255}
end
local a = color(240, 77, 191)
local b = color(18, 18, 18)
local c = color(18, 18, 18)
return {
    animationSpeed = 10,
    key = {
        backgroundColor = a,
        foregroundColor = b,
        accentColor = c,

        padding = 0,

        outline = true,
        outlineColor = c,
        outlineWidth = 1,

        font = "huge"
    },
    screen = {
        backgroundColor = a,
        foregroundColor = b,

        mainText = {
            color = b,
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
            color = b,
            font = "medium",
            alignment = "right",
            horizontalPadding = 0.03 -- (Normalized)
        },
        commentText = {
            color = b,
            font = "medium",
            alignment = "center",
            horizontalPadding = 0 -- (Normalized)
        },
    },
    list = {
        backgroundColor = c,
        foregroundColor = a,
        titleColor = a,
        curtainColor = color(0, 0, 0, 200),

        corner = 16,

        outline = false,
        outlineColor = a,
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