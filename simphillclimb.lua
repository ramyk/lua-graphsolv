List = require "listutils"
Set = require "setutils"
Heap = require "heaputils"

local function solve (graph, sld, depart, dest)
    local function compare (a,b)
        return sld[dest][a] < sld[dest][b]
    end
    local explored = Set:new()
    local path = List:new()
    local trials = 0
    local stuck = true

    path:pushleft({depart, 0})
    repeat
        trials = trials + 1
        local curr_node = path:popleft()
        if curr_node[1] == dest then
            path:pushleft(curr_node)
            return path
        end
        stuck = true
        for node,cost in pairs(graph[curr_node[1]]) do
            if not (explored:contains(node)) and compare(node, curr_node[1]) then
                path:pushleft(curr_node)
                path:pushleft({node, cost})
                stuck = false
                break
            end
        end
        explored:insert(curr_node[1])
    until stuck or trials >= 100

    if stuck then
        io.write("Stuck at "..path:popleft()[1])
    elseif trials >= 100 then
        io.write("Time limit exceeded at "..path:popleft()[1])
    end

    return nil
end

return { solve = solve }
