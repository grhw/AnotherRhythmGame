local jsmo = require("jsonstressesmeout")
local files = require("files")
local waitingnew = false
local waitingfor = ""
local keybinds = {}
local selected = 0
local upscale = 0
local love = love
local images = {}
local length = 0
local layer = {}
local settings
local selkey
local font

function layer.load(scenes, tween)
    upscale = scenes.globaldata:get("upscale")
    love.window.setTitle('Another Rhythm Game')
    layer.scenes = scenes
    layer.tween = tween

    images.gradient = love.graphics.newImage("assets/gradient.png")
    font = layer.scenes.globaldata:get("font")
    keybinds = scenes.globaldata:get("keybinds")
end

function layer.update(dt)
    for k, v in pairs(layer.scenes.heldkeys) do
        if waitingnew and layer.scenes.globaldata:handlekey(k) then
            waitingnew = false
            keybinds[waitingfor] = k
        end
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Confirm"]) then
        waitingnew = true
        waitingfor = selkey
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Pause"]) then
        files.save("config", "keybinds.jsmo",
                   jsmo.encode(layer.scenes.globaldata:get("keybinds")))
        layer.scenes:switch("main", layer.scenes)
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Down"]) then
        selected = selected + 1
    elseif layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Up"]) then
        selected = selected - 1
    end
    selected = selected % length
end
function layer.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.draw(images.gradient, 0, 0, 0, upscale, upscale)
    local i = 0
    for name, key in pairs(keybinds) do
        i = i + 1
        local final = "  " .. name
        if i == selected + 1 then
            final = "> " .. name
            selkey = name
        end
        love.graphics.print(final .. " [" .. key .. "]", 7 * upscale,
                            (i * 5) * upscale, 0, 1, 1)
    end
    if i > length then length = i end
end
return layer
