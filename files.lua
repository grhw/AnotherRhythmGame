local files = {}
local love = love
local lfs = love.filesystem

local function enu(folder, saveDir)
	local filesTable = lfs.getDirectoryItems(folder)
	if saveDir ~= "" and not lfs.isDirectory(saveDir) then lfs.createDirectory(saveDir) end
   
	for i,v in ipairs(filesTable) do
		local file = folder.."/"..v
		local saveFile = saveDir.."/"..v
		if saveDir == "" then saveFile = v end
      
		if lfs.isDirectory(file) then
			lfs.createDirectory(saveFile)
			enu(file, saveFile)
		else
			lfs.write(saveFile, tostring(lfs.read(file)))
		end
	end
end

function files.unzip(file, dir, delete)
	local dir = dir or ""
	local temp = tostring(math.random(1000, 2000))
	success = lfs.mount(file, temp)
		if success then enu(temp, dir) end
	lfs.unmount(file)
	if delete then lfs.remove(file) end
end

function files.save(folder,file,content)
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	if not love.filesystem.getInfo(folder) then
		love.filesystem.createDirectory(folder)
	end
	love.filesystem.setIdentity("AnotherRhythmGame/" .. folder)
	love.filesystem.write(file,content)
end

function files.load(folder,file)
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	if not love.filesystem.getInfo(folder) then
		love.filesystem.createDirectory(folder)
	end
	love.filesystem.setIdentity("AnotherRhythmGame/" .. folder)
	if love.filesystem.getInfo(file) then
		return love.filesystem.read(file)
	end
	return false
end

function files.ls(folder)
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	if not love.filesystem.getInfo(folder) then
		love.filesystem.createDirectory(folder)
		return {}
	end
	return love.filesystem.getDirectoryItems(folder)
end
return files