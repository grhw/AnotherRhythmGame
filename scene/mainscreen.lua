local buttons = {
    ["Play"] = "selector",
    ["Settings"] = "settings",
    ["Keybinds"] = "keybinds"
}
local selected = 0
local images = {}
local love = love
local upscale = 0
local layer = {}
local sk = ""
local font

function layer.load(scenes, tween)
    upscale = scenes.globaldata:get("upscale")
    love.window.setTitle('Another Rhythm Game')
    layer.scenes = scenes
    layer.tween = tween

    images.gradient = love.graphics.newImage("assets/gradient.png")
    images.splash = love.graphics.newImage("assets/splash.png")
    font = layer.scenes.globaldata:get("font")
end

function layer.update(dt)
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Down"]) then
        selected = selected + 1
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Up"]) then
        selected = selected - 1
    end
    -- print(layer.scenes.globaldata:get("keybinds")["Confirm"])
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Confirm"]) then
        layer.scenes:switch(sk, layer.scenes)
    end
    selected = selected % 3
end
function layer.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.draw(images.gradient, 0, 0, 0, upscale, upscale)
    love.graphics.draw(images.splash, 0, 0, 0, upscale, upscale)
    local i = 0
    table.sort(buttons)
    for text, scenename in pairs(buttons) do
        i = i + 1
        local final = "  " .. text
        if i == selected + 1 then
            final = "> " .. text
            sk = scenename
        end
        love.graphics.print(final, 5 * upscale, ((i * 5) + 45) * upscale, 0, 1,
                            1)
    end
end
return layer
