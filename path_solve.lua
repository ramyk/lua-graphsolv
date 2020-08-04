list = require "listutils"
graph = require "graphtn"
solver = require "dfs"

-- trip selection
io.write("Departure: ")
local dpt = io.read()
io.write("Destination: ")
local dst = io.read()

-- path solving
io.write("\n")
local path = solver.solve(graph.map,
                          graph.encoder[dpt],
                          graph.encoder[dst])
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
