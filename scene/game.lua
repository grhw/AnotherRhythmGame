local layer = {}
local notes = {}
local hit = {}
local time = 0
local hitboxpos = 0
local foresight = 0
local colors = {}
local nextnote = {1,1,1}
local audio = nil

local counts = {}
local acc_counts = {} -- not accounts, acc counts!

local colormath = require("colormath")
local judgements = require("judgements")

local images = {}
local upscale = 0

function layer.load(scenes,tween)
    love.window.setTitle('ARG | In-game')
    layer.scenes = scenes
    layer.tween = tween

    nextnote = {1,1,1}
    counts = {}
    acc_counts = {1}
    hit = {}

    notes = scenes.globaldata:get("map")
    hitboxpos = scenes.globaldata:get("hitbox pos")
    colors = scenes.globaldata:get("colors")

    audio = love.audio.newSource(scenes.globaldata:get("audio"),"stream")
    audio:play()

    upscale = scenes.globaldata:get("upscale")
    hit = {}
    time = 0

    images.target = love.graphics.newImage("assets/target.png")
    images.hitcircle = love.graphics.newImage("assets/hitcircle.png")
    images.overlay = love.graphics.newImage("assets/hitcircleoverlay.png")
    images.bg = love.graphics.newImage("assets/bg.png")

    images.arrows = {}
    images.arrows[1] = love.graphics.newImage("assets/arrows/a1.png")
    images.arrows[2] = love.graphics.newImage("assets/arrows/a2.png")
    images.arrows[3] = love.graphics.newImage("assets/arrows/a3.png")
    images.arrows[4] = love.graphics.newImage("assets/arrows/a4.png")
end

local function count(j)
    if not counts[j] then
        counts[j] = 1
    end
    print(j)
end

local function getacc()
    local sum = 0
    for _,v in pairs(acc_counts) do
        sum = sum + v
    end
    return (sum/#acc_counts)*100 
end

local function presskey(k)
    local p = 1-math.abs(nextnote[2]-(hitboxpos/foresight))
    if not hit[nextnote[3]] then
        if p > 0.5 then
            if k == nextnote[1] then
                local j = judgements.judge(p)
                count(j)
                table.insert(acc_counts,p)
                counts[j] = counts[j] + 1
                hit[nextnote[3]] = true
            else
                count("Misinput")
                table.insert(acc_counts,50)
            end
        end
    end
end

function layer.update(dt)
    --time = time + (dt*1000)
    time = audio:tell()*1000

    if layer.scenes.globaldata:handlekey("w") then
        presskey(1)
    elseif layer.scenes.globaldata:handlekey("s") then
        presskey(2)
    elseif layer.scenes.globaldata:handlekey("a") then
        presskey(3)
    elseif layer.scenes.globaldata:handlekey("d") then
        presskey(4)
    end
end
function layer.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(images.bg,0,0,0,upscale,upscale)
    
    foresight = layer.scenes.globaldata:get("foresight")
    local lowest = 1
    for notetime,note in pairs(notes) do
        local diff = notetime-time
        local perc = diff/foresight
        local px = perc*1280
        if not hit[notetime] then
            if px < 0 then
                hit[notetime] = note
                count("Miss")
            end
            if math.abs(diff) < foresight then
                local y = math.max(75,px-750)
                love.graphics.setColor(colors[note])
                love.graphics.draw(images.hitcircle,px,y,0,upscale,upscale)
                love.graphics.setColor(1,1,1,1)
                love.graphics.draw(images.overlay,px,y,0,upscale,upscale)
                love.graphics.draw(images.arrows[note],px,y,0,upscale,upscale)    
            end
            if perc < lowest then
                lowest = perc
                nextnote = {note,perc,notetime}
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 0.5)
    if layer.scenes.globaldata:technicallykeydown("w") or layer.scenes.globaldata:technicallykeydown("a") or layer.scenes.globaldata:technicallykeydown("s") or layer.scenes.globaldata:technicallykeydown("d") then
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(images.target,hitboxpos+130,15,0,upscale,upscale)
end
return layer