local songindex = require("songs")
local files     = require("files")
local selected = 0
local upscale = 0
local love = love
local images = {}
local layer = {}
local songs = {}
local move = {0}
local font

function layer.load(scenes, tween)
    upscale = scenes.globaldata:get("upscale")
    love.window.setTitle('ARG | Song Selector')
    layer.scenes = scenes
    layer.tween = tween

    songs = {}
    for folder, data in pairs(songindex.getsongs()) do
        table.insert(songs, {folder, data})
    end

    images.gradient = love.graphics.newImage("assets/gradient.png")
    images.map = love.graphics.newImage("assets/select.png")
    font = layer.scenes.globaldata:get("font")
end
local sstween

function layer.update(dt)
    local changed = false
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Down"]) then
        selected = selected + 1
        changed = true
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Up"]) then
        selected = selected - 1
        changed = true
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Pause"]) then
        layer.scenes:switch("main", layer.scenes)
    end
    if layer.scenes.globaldata:handlekey(
        layer.scenes.globaldata:get("keybinds")["Confirm"]) then
        local bm = songs[selected + 1][2]
        files.duplicate(bm.audio,"session/"..bm.audioname)
        layer.scenes.globaldata:store("map", bm.notes)
        layer.scenes.globaldata:store("audio", "session/"..bm.audioname)

        layer.scenes:switch("game", layer.scenes)
    end
    if sstween then sstween:update(dt) end
    selected = selected % #songs
    if changed then
        sstween = layer.tween.new(0.1, move, {selected}, "outCirc")
        print(selected + 1)
    end
end
function layer.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.draw(images.gradient, 0, 0, 0, upscale, upscale)
    for i, v in pairs(songs) do
        local x = (((i - move[1]) * 4) - (140)) * upscale -- wtf
        local y = ((i - move[1]) * 15) * upscale
        if i == selected + 1 then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 0.5)
        end
        love.graphics.draw(images.map, x, y, 0, upscale, upscale)
        love.graphics.print(v[2].title, (x + (140 * upscale)), y + upscale)
        love.graphics.print(v[2].artist, (x + (140 * upscale)), (y + upscale) + 60)
    end
    -- love.graphics.print(songs[selected+1][1],0,36*upscale)
end
return layer
