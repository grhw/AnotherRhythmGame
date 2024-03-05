local layer = {}
local notes = {}
local hit = {}
local time = 0
local audiotime = 0
local hitboxpos = 0
local foresight = 0
local colors = {}
local nextnote = {1,1,1}
local audio
local love = love
local hitsound

local counts = {}
local acc_counts = {} -- not accounts, acc counts!

local colormath = require("colormath")
local judgements = require("judgements")
local tablelength = require("tablelength")

local images = {}
local shaders = {}
local upscale = 0
local paused = false
local combo = 0

local lasthit = 0

function layer.load(scenes,tween)
    love.window.setTitle('ARG | In-game')
    layer.scenes = scenes
    layer.tween = tween

    combo = 0
    nextnote = {1,1,1}
    counts = {}
    acc_counts = {1}
    hit = {}
    lasthit = 0

    notes = scenes.globaldata:get("map")
    hitboxpos = scenes.globaldata:get("hitbox pos")
    colors = scenes.globaldata:get("colors")

    audio = love.audio.newSource(scenes.globaldata:get("audio"),"stream")
    hitsound = love.audio.newSource("assets/hit.ogg","stream")
    audio:stop()
    audio:setVolume(scenes.globaldata:get("settings")["Sound"]["Music"])
    hitsound:setVolume(scenes.globaldata:get("settings")["Sound"]["SFX"])

    upscale = scenes.globaldata:get("upscale")
    time = -1000

    images.target = love.graphics.newImage("assets/target.png")
    images.targetglow = love.graphics.newImage("assets/targetglow.png")
    images.hitcircle = love.graphics.newImage("assets/hitcircle.png")
    images.overlay = love.graphics.newImage("assets/hitcircleoverlay.png")
    images.gradient = love.graphics.newImage("assets/gradient.png")
    images.bg = love.graphics.newImage("assets/bg.png")

    images.arrows = {}
    images.arrows[1] = love.graphics.newImage("assets/arrows/a1.png")
    images.arrows[2] = love.graphics.newImage("assets/arrows/a2.png")
    images.arrows[3] = love.graphics.newImage("assets/arrows/a3.png")
    images.arrows[4] = love.graphics.newImage("assets/arrows/a4.png")

    paused = false
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

local function getnoteperc(time)
    return 1-math.abs(time-(hitboxpos/foresight))
end

local targetcolor = {1,1,1}
local function presskey(k)
    local p = getnoteperc(nextnote[2])
    if not hit[nextnote[3]] then
        if p > 0.5 then
            if k == nextnote[1] then
                local j,r = judgements.judge(p)
                count(j)
                table.insert(acc_counts,r/100)
                counts[j] = counts[j] + 1
                hit[nextnote[3]] = true
                targetcolor = colors[k]
                combo = combo + 1
                lasthit = time
                hitsound:stop()
                hitsound:play()
            else
                count("Misinput")
                combo = 0
                table.insert(acc_counts,0)
            end
        end
    end
end


function layer.update(dt)
    --time = time + (dt*1000)
    if not audiotime == audio:tell()*1000 then
        time = (audio:tell()*1000)-75
    end
    if audio:isPlaying() or time < 0 then
        time = time + dt*1000
    end
    if time < 1000 and time >= 0 and not audio:isPlaying() then
        audio:play()
    end
    audiotime = audio:tell()*1000

    if layer.scenes.globaldata:handlekey(layer.scenes.globaldata:get("keybinds")["Up"]) then
        presskey(1)
    elseif layer.scenes.globaldata:handlekey(layer.scenes.globaldata:get("keybinds")["Down"]) then
        presskey(2)
    elseif layer.scenes.globaldata:handlekey(layer.scenes.globaldata:get("keybinds")["Left"]) then
        presskey(3)
    elseif layer.scenes.globaldata:handlekey(layer.scenes.globaldata:get("keybinds")["Right"]) then
        presskey(4)
    end

    if layer.scenes.globaldata:handlekey(layer.scenes.globaldata:get("keybinds")["Pause"]) then
        if audio:isPlaying() then   
            audio:pause()
        else
            audio:play()
        end
        paused = not paused
    end
    if layer.scenes.globaldata:handlekey(layer.scenes.globaldata:get("keybinds")["Confirm"]) and not audio:isPlaying() then 
        audio:stop()
        layer.scenes:switch("selector",layer.scenes)
    end
    if time >= audio:getDuration()*1000 or tablelength(hit) >= tablelength(notes) then
        audio:stop()
        layer.scenes:switch("selector",layer.scenes)
    end
end

function layer.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(images.gradient,0,0,0,upscale,upscale)
    love.graphics.draw(images.bg,0,0,0,upscale,upscale)
    
    if layer.scenes.globaldata:get("autoplay") and getnoteperc(nextnote[2]) > 0.95 then
        presskey(nextnote[1])
    end

    foresight = layer.scenes.globaldata:get("foresight")
    local lowest = 1
    for notetime,note in pairs(notes) do
        local diff = notetime-time
        local perc = diff/foresight
        local px = perc*1280
        if not hit[notetime] then
            if px < 0 then
                hit[notetime] = note
                combo = 0
                table.insert(acc_counts,0)
                count("Miss")
            end
            if math.abs(diff) < foresight then
                local y = math.max(7.5*upscale,px-(75*upscale))
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
    love.graphics.setColor(targetcolor[1],targetcolor[2],targetcolor[3], 0.5)
    local tx,ty = hitboxpos+(2*upscale),(1.5*upscale)
    if layer.scenes.globaldata:technicallykeydown("w") or layer.scenes.globaldata:technicallykeydown("a") or layer.scenes.globaldata:technicallykeydown("s") or layer.scenes.globaldata:technicallykeydown("d") then
        love.graphics.setColor(targetcolor)
        love.graphics.draw(images.targetglow,tx-50,ty-50,0,1,1)
    end
    love.graphics.draw(images.target,tx,ty,0,upscale,upscale)

    love.graphics.setColor(1,1,1,1)
    local upsc = 3-math.max(1,math.min(200,math.abs(time-lasthit))/100)
    love.graphics.print(tostring(combo),15*upscale,50*upscale,0,2,upsc*2,0,0.5)
    love.graphics.print(tostring(math.floor(getacc()*100)/100).."%",15*upscale,45*upscale,0,1,1,0,0.5)
end
return layer