local tween = require("tween")
local scenes = {}
local public = {}
print("init")
scenes.globaldata = {}

scenes.heldkeys = {}
scenes.handledheldkeys = {}

scenes.scene = nil
local registered_scenes = {}

function scenes:new(name, module)
    local scene = {}
    if module.load then
        function scene.load(scenes) module.load(scenes, tween) end
    end

    if module.update then scene.update = module.update end

    if module.draw then scene.draw = module.draw end

    registered_scenes[name] = scene
    return scene
end

function scenes.load() if scenes.scene.load then scenes.scene.load() end end
function scenes.update(dt)
    if scenes.scene.update then scenes.scene.update(dt) end
end
function scenes.draw() if scenes.scene.draw then scenes.scene.draw() end end

function scenes:switch(name, scenes)
    scenes.scene = registered_scenes[name]
    scenes.scene.load(scenes)
end

function scenes.globaldata:iskeydown(k) return scenes.handledheldkeys[k] end
function scenes.globaldata:technicallykeydown(k) return scenes.heldkeys[k] end
function scenes.globaldata:handlekey(k)
    if scenes.handledheldkeys[k] then
        scenes.handledheldkeys[k] = false
        return true
    end
    return false
end
function scenes.globaldata:get(key) return public[key] end
function scenes.globaldata:store(key, value)
    public[key] = value
    return value
end

return scenes
