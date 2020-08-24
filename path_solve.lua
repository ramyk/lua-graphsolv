list = require "utils/listutils"

-- if using another graph, please
-- use the 'graphtn.lua' design
graph = require "data/graphtn"

-- update the solver by choosing one
-- from the 'algos' package
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
-- if using a heuristic-based solver add the 'graph.sld'
-- parameter as a second argument for the solve function
-- otherwise use it with only the standard 3 parameters
-- which are the graph, the departure and the destination
local path = solver.solve(graph.map, graph.sld, dpt, dst)
if path then
    -- formatting output as it's received
    -- as a reversed list of cities names
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
