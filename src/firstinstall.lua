local files = require("files")
local function init(scenes)
    print("first install")
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
            ["Autoplay"] = false,
            ["Skin (not implemented)"] = "Default",
        }
    })

    files.save("songs","readme.txt","drop your song data folders here")
    
    return scenes
end

return init