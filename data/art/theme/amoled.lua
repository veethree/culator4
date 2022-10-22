local function color(r, g, b, a)
    a = a or 255
    return {r / 255,  g / 255,  b / 255,  a / 255}
end
local a = color(0, 0, 0)
local b = color(188, 198, 214)
local c = color(93, 104, 122)
return {
    animationSpeed = 10,
    key = {
        backgroundColor = a,
        foregroundColor = b,
        accentColor = b,

        padding = 0,

        outline = false,
        outlineColor = b,
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
            color = c,
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
        backgroundColor = a,
        foregroundColor = b,
        titleColor = b,
        curtainColor = color(0, 0, 0, 200),

        corner = 16,

        outline = false,
        outlineColor = b,
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