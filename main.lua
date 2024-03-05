local scenes = require("scenes")
local love = love

function love.load()
    scenes.globaldata:store("upscale",10)
    love.window.setMode(128*scenes.globaldata:get("upscale"),72*scenes.globaldata:get("upscale"))
    love.window.setTitle('Another Rhythm Game')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    scenes:new("game",require("scene/game"))
    scenes:new("selector",require("scene/songselect"))
    scenes:new("main",require("scene/mainscreen"))
    scenes:new("settings",require("scene/settings"))
    scenes:new("keybinds",require("scene/keybinds"))

    scenes.globaldata:store("keybinds", {
        ["Up"] = "w",
        ["Down"] = "s",
        ["Left"] = "a",
        ["Right"] = "d",

        ["Pause"] = "escape",
        ["Confirm"] = "return",
    })

    scenes.globaldata:store("settings", {
        ["Sound"] = {
            ["Menu BGM"] = 0.5,
            ["Music"] = 0.5,
            ["SFX"] = 0.2,
        },
        ["Other"] = {
            ["Autoplay"] = false  
        }
    })

    scenes.globaldata:store("font",love.graphics.newFont("assets/main.ttf", 40))
    scenes.globaldata:store("autoplay",false)
    scenes.globaldata:store("hitbox pos",60)
    scenes.globaldata:store("colors",{
        {000/255, 191/255, 255/255}, -- up
        {139/255, 069/255, 019/255}, -- down
        {034/255, 139/255, 034/255}, -- left
        {255/255, 069/255, 000/255}, -- right
    })
    scenes.globaldata:store("foresight",1000)
    scenes:switch("main",scenes)
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

