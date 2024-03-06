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
	local success = lfs.mount(file, temp)
		if success then enu(temp, dir) end
	lfs.unmount(file)
	if delete then lfs.remove(file) end
end

function files.save(folder,file,content)
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	if not love.filesystem.getInfo(folder) then
		love.filesystem.createDirectory(folder)
	end
	love.filesystem.setIdentity("AnotherRhythmGame/" .. folder,false)
	love.filesystem.write(file,content)
end

function files.load(folder,file)
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	if not love.filesystem.getInfo(folder) then
		love.filesystem.createDirectory(folder)
	end
	love.filesystem.setIdentity("AnotherRhythmGame/" .. folder,false)
	if love.filesystem.getInfo(file) then
		local fl = love.filesystem.read(file)
		return fl
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

function files.inspect(folder,path)
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	love.filesystem.setIdentity("AnotherRhythmGame/" .. folder,false)
	return love.filesystem.getInfo(path)
end

function files.require(folder,file)
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	love.filesystem.setIdentity("AnotherRhythmGame/" .. folder,false)
	return love.filesystem.load(file)()
end

function files.duplicate(fromfile,tofolder)
	local copied = io.open(fromfile, "rb")
	local pasted = io.open(tofolder, "w+b")
	if copied and pasted then -- lol
		pasted:write(copied:read("*all"))
		copied:close()
		pasted:close()
	end
end

function files.duplicate_to_game(folder,file,gamefolder) -- it's  files.duplicate() but files.get_real() first 
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	love.filesystem.setIdentity("AnotherRhythmGame/" .. folder,false)
	local real -- how to make the warning stfu
	real = files.get_real(folder,file)
	files.duplicate(real,gamefolder)
end

function files.get_real(folder,file) -- GET REAL
	love.filesystem.setIdentity("AnotherRhythmGame",false)
	love.filesystem.setIdentity("AnotherRhythmGame/" .. folder,false)
	return love.filesystem.getRealDirectory(file).. "/"..file
end
return files