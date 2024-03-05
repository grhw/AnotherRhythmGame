local network = {}

function network.download(url,file)
    local http = require('socket.http')
    local body, code = http.request(url)
    if not body then error(code) end
    
    local f = assert(io.open(file, 'wb'))
    f:write(body)
    f:close() 
end