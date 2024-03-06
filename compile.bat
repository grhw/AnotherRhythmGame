7z a compiled/comp.zip ./src/*
cd compiled
copy /b "C:\\Program Files\\LOVE\\love.exe"+comp.zip "Windows/ARG.exe"
cd ..