List = require "listutils"
Set = require "setutils"
Heap = require "heaputils"

local function pathcost (path)
    local cost = 0
    local tab = path:table()
    for k,node in pairs(tab) do
        cost = cost + node[2]
    end
    return cost
end

local function pathcompare (p1, p2)
    return pathcost(p1) < pathcost(p2)
end

local function solve (graph, depart, dest)
    local totrace = Heap:new(pathcompare)
    local explored = Set:new()
    local curr_path = List:new()

    curr_path:pushleft({depart, 0})
    repeat
        local curr_cost = pathcost(curr_path)
        local curr_node = curr_path:popleft()
        if curr_node[1] == dest then
            curr_path:pushleft(curr_node)
            return curr_path
        end
        for node,cost in pairs(graph[curr_node[1]]) do
            if not (explored:contains({node, curr_cost + cost})) then
                local holder = curr_path:copy()
                holder:pushleft(curr_node)
                holder:pushleft({node, cost})
                totrace:insert(holder)
            end
        end
        explored:insert({curr_node[1], curr_cost})
        curr_path = totrace:pop()
    until not curr_path

    return nil
end

return { solve = solve }
