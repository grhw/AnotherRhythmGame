notes = {}
raw = ''

pos = {
    448: 4,
    320: 3,
    192: 2,
    64: 1,
}

with open("bm.osu","r") as f:
    raw = f.read().split("\n")

for i in raw:
    data = i.split(',')

    notes[float(data[2])] = pos[int(data[0])]
final = []
for i in notes.keys():
    final.append(f"[{i}] = {notes[i]}")

with open("map.lua","w+") as f:
    f.write('local map = {}\nmap.meta = {\n    ["title"] = "",\n    ["creator"] = "",\n    ["audio"] = "audio.ogg"\n}\n\nmap.notes = {' + ",".join(final) + '}\nreturn map')