local files = require("files")
local songs = {}

local function attemptload(folder)
    print(folder)
    local bm = {}
    local s,e = pcall(function()
        local loaded = files.require(folder,"map.lua")
        bm.title = loaded.meta["title"]
        bm.artist = loaded.meta["artist"]
        bm.creator = loaded.meta["creator"]
        bm.audioname = loaded.audio

        print(loaded)

        if files.inspect(folder,bm.audioname) then
            assert("no audio")
        end

        bm.audio = files.get_real(folder,bm.audioname)

        bm.notes = loaded.notes
    end)

    print(e)

    return s and bm
end

function songs.getsongs()
    local songs = {}
    for _,folder in pairs(files.ls("songs")) do
        if files.inspect("songs",folder).type == "directory" then
            local loaded = attemptload("songs/"..folder)
            songs[folder] = loaded
        end
    end

    return songs
end

return songs