local jsmo = require("jsonstressesmeout")
local selci, seli = "Other", "Autoplay"
local files = require("files")
local selected = 0
local upscale = 0
local love = love
local images = {}
local length = 0
local layer = {}
local settings
local sk = ""
local font

function layer.load(scenes, tween)
    upscale = scenes.globaldata:get("upscale")
    love.window.setTitle('Another Rhythm Game')
    layer.scenes = scenes
    layer.tween = tween

    images.gradient = love.graphics.newImage("assets/gradient.png")
    font = layer.scenes.globaldata:get("font")
    settings = scenes.globaldata:get("settings")
end

function layer.update(dt)
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Down"]) then
        selected = selected + 1
    elseif layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Up"]) then
        selected = selected - 1
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Confirm"]) then
        print(selci, seli, settings[selci][seli])
        if type(settings[selci][seli]) == type(true) then
            settings[selci][seli] = not settings[selci][seli]
        end
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Pause"]) then
        files.save("config", "settings.jsmo",
                   jsmo.encode(layer.scenes.globaldata:get("settings")))
        layer.scenes:switch("main", layer.scenes)
    end
    if type(settings[selci][seli]) == type(1) then
        if layer.scenes.globaldata:handlekey(
            layer.scenes.globaldata:get("keybinds")["Right"]) then
            settings[selci][seli] = settings[selci][seli] + 0.1
        elseif layer.scenes.globaldata:handlekey(
            layer.scenes.globaldata:get("keybinds")["Left"]) then
            settings[selci][seli] = settings[selci][seli] - 0.1
        end
        if selci == "Sound" then
            settings[selci][seli] = math.min(1,
                                             math.max(0, settings[selci][seli]))
        end
    end
    selected = selected % length
end
function layer.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.draw(images.gradient, 0, 0, 0, upscale, upscale)
    love.graphics.print("Save folder: "..files.get_real("",""),0,0,0,0.2,0.2)
    local i = 0
    local renderoffset = 0
    local categi = 0
    for category, contents in pairs(settings) do
        renderoffset = renderoffset + 2
        categi = categi + 1
        love.graphics.print(category, 5 * upscale, (renderoffset * 5) * upscale,
                            0, 1, 1)
        for key, value in pairs(contents) do
            renderoffset = renderoffset + 1
            i = i + 1
            local final = "  " .. key
            if i == selected + 1 then
                selci, seli = category, key
                final = "> " .. key
            end
            love.graphics.print(final .. " [" .. tostring(value) .. "]",
                                7 * upscale, (renderoffset * 5) * upscale, 0, 1,
                                1)
        end
    end
    if length < i then length = i end
    layer.scenes.globaldata:store("settings", settings)
end
return layer
