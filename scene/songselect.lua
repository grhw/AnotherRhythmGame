local songindex = require("songs.index")
local layer = {}
local songs = {}
local selected = 0
local images = {}
local upscale = 0

function layer.load(scenes,tween)
    upscale = scenes.globaldata:get("upscale")
    love.window.setTitle('ARG | Song Selector')
    layer.scenes = scenes
    layer.tween = tween
    songs = {}
    for name,folder in pairs(songindex) do
        table.insert(songs,{name,folder})
    end

    images.gradient = love.graphics.newImage("assets/gradient.png")
end

function layer.update(dt)
    if layer.scenes.globaldata:handlekey("s") then
        selected = selected+1
    end
    if layer.scenes.globaldata:handlekey("w") then
        selected = selected-1
    end
    if layer.scenes.globaldata:handlekey("e") then
        local f = songs[selected+1][2]
        local bm = require("songs."..f..".map")
        layer.scenes.globaldata:store("map", bm.notes)
        layer.scenes.globaldata:store("audio", "songs/"..f.."/".. bm.meta.audio)

        layer.scenes:switch("game",layer.scenes)
    end
    selected = selected%#songs
end
function layer.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.gradient,0,0,0,upscale,upscale)
    love.graphics.print(songs[selected+1][1],0,36*upscale)
end
return layer