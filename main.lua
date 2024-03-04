local scenes = require("scenes")
function love.load()
    scenes.globaldata:store("upscale",10)
    love.window.setMode(128*scenes.globaldata:get("upscale"),72*scenes.globaldata:get("upscale"))
    love.window.setTitle('Another Rhythm Game')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    scenes:new("game",require("scene/game"))
    
    local bm =require("songs.keepout.map")
    scenes.globaldata:store("map", bm.notes)
    scenes.globaldata:store("audio", "songs/keepout/" .. bm.meta.audio)

    scenes.globaldata:store("hitbox pos",-50)
    scenes.globaldata:store("colors",{
        {000/255, 191/255, 255/255}, -- up
        {139/255, 069/255, 019/255}, -- down
        {034/255, 139/255, 034/255}, -- left
        {255/255, 069/255, 000/255}, -- right
    })
    scenes.globaldata:store("foresight",1000)
    scenes:switch("game",scenes)
end

function love.keypressed(key)
    scenes.heldkeys[key] = true
    scenes.handledheldkeys[key] = true
end

function love.keyreleased(key)
    scenes.heldkeys[key] = false
    scenes.handledheldkeys[key] = false
end

function love.update(dt)
    scenes.update(dt)
end

function love.draw()
    scenes.draw()
end

