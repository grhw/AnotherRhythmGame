local jsmo = {}

function jsmo.encode(t)
    local final = {}

    local function walk(path, tbl)
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                walk(path .. "//" .. tostring(k), v)
            else
                table.insert(final, path .. "//" .. tostring(k) .. "||" .. tostring(v) .. "--" .. tostring(type(v)))
            end
        end
    end

    walk("", t)

    return table.concat(final,"++")
end

function jsmo.decode(encode)
    local decodedTable = {}

    for entry in encode:gmatch(("[^\\+\\+]+")) do
        local path, nvalue = entry:match("^(.+)||(.+)$")

        local keys = {}
        for key in path:gmatch("[^//]+") do
            table.insert(keys, key)
        end

        local currentTable = decodedTable
        for i, key in ipairs(keys) do
            local d = {}
            print(nvalue)
            for v in nvalue:gmatch("[^\\-\\-]+") do
                table.insert(d,v)
                print(v)
            end
            local value = d[1]
            local valuetype = d[2]
            print(value,valuetype)
            if i == #keys then
                if valuetype == tostring(type("")) then
                    currentTable[tostring(key)] = tostring(value)
                elseif valuetype == tostring(type(1)) then
                    currentTable[tostring(key)] = tonumber(value)
                elseif valuetype == tostring(type(true)) then
                    if value == "true" then
                        currentTable[tostring(key)] = true                        
                    else
                        currentTable[tostring(key)] = false
                    end
                end
            else
                currentTable[tostring(key)] = currentTable[tostring(key)] or {}
                currentTable = currentTable[tostring(key)]
            end
        end
    end


    return decodedTable
end

return jsmo