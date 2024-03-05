local scenes = require("scenes")
local firstinstall = require("firstinstall")
local files        = require("files")
local json         = require("json")
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

    local lcs = files.load("config","settings.json")
    local binds = files.load("config","keybinds.json")
    if lcs and binds then
        local plcs = json.parse(lcs)
        local pbinds = json.parse(binds)
        scenes.globaldata:store("keybinds", plcs)
        scenes.globaldata:store("settings", pbinds)
    else
        scenes = firstinstall(scenes)
    end
    print(scenes.globaldata["Keybinds"])

    scenes.globaldata:store("font",love.graphics.newFont("assets/main.ttf", 40))
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

