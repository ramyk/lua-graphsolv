list = require "utils/listutils"
graph = require "data/graphtn"
solver = require "algos/steephillclimb"

-- trip selection
local dpt = nil
repeat
    io.write("Departure: ")
    dpt = graph.encoder[io.read()]
until dpt
local dst = nil
repeat
    io.write("Destination: ")
    dst = graph.encoder[io.read()]
until dst

-- path solving
io.write("\n")
local path = solver.solve(graph.map, graph.sld, dpt, dst)
if path then
    -- formatting output
    local cost = 0
    io.write("Found Path: ")
    io.write(graph.decoder[path:popright()[1]])
    local node = path:popright()
    while node do
        cost = cost + node[2]
        io.write('--('..node[2]..')--')
        io.write(graph.decoder[node[1]])
        node = path:popright()
    end
    io.write("\nTotal Distance: "..cost)
else
    io.write("No path found!")
end
io.write('\n')
