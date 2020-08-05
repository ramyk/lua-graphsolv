List = require "listutils"
Set = require "setutils"

local function solve (graph, sld, depart, dest)
    local function compare (a,b)
        return sld[dest][a] < sld[dest][b]
    end
    local explored = Set:new()
    local path = List:new()
    local trials = 0
    local stuck = true
    local steepest = nil

    path:pushleft({depart, 0})
    repeat
        trials = trials + 1
        local curr_node = path:popleft()
        path:pushleft(curr_node)
        if curr_node[1] == dest then return path end
        stuck = true
        steepest = curr_node
        for node,cost in pairs(graph[curr_node[1]]) do
            if not (explored:contains(node)) and compare(node, steepest[1]) then
                steepest = {node, cost}
                stuck = false
            end
        end
        if steepest ~= curr_node then
            path:pushleft(steepest)
            explored:insert(steepest[1])
        end
    until stuck or trials >= 100

    if trials >= 100 then
        io.write("Time limit exceeded at "..steepest[1])
    elseif stuck then
        io.write("Stuck at "..steepest[1])
    end

    return nil
end

return { solve = solve }
