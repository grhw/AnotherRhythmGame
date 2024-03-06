local jsmo = {}

function jsmo.encode(t)
    local final = {}

    local function walk(path, tbl)
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                walk(path .. "//" .. tostring(k), v)
            else
                table.insert(final, path .. "//" .. tostring(k) .. "||" .. tostring(v))
            end
        end
    end

    walk("", t)

    return table.concat(final,"++")
end

function jsmo.decode(encode)
    local decodedTable = {}

    for entry in encode:gmatch(("[^\\+\\+]+")) do
        local path, value = entry:match("^(.+)||(.+)$")

        local keys = {}
        for key in path:gmatch("[^//]+") do
            table.insert(keys, key)
        end

        local currentTable = decodedTable
        for i, key in ipairs(keys) do
            if i == #keys then
                currentTable[tostring(key)] = tostring(value)
            else
                currentTable[tostring(key)] = currentTable[tostring(key)] or {}
                currentTable = currentTable[tostring(key)]
            end
        end
    end


    return decodedTable
end

return jsmo