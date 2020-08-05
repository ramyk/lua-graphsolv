List = require "listutils"
Heap = require "heaputils"

local function pathcost (path)
    local cost = 0
    local tab = path:table()
    for k,node in pairs(tab) do
        cost = cost + node[2]
    end
    return cost
end

local function solve (graph, sld, depart, dest)
    local totrace = Heap:new(
        function (a,b)
            local node_a = a:popleft()
            local node_b = b:popleft()
            a:pushleft(node_a)
            b:pushleft(node_b)
            return (pathcost(a) + sld[dest][node_a[1]]) < (pathcost(b) + sld[dest][node_b[1]])
        end
        )
    local explored = {}
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
            if explored[node] == nil or (explored[node] > cost + curr_cost) then
                local holder = curr_path:copy()
                holder:pushleft(curr_node)
                holder:pushleft({node, cost})
                totrace:insert(holder)
            end
        end
        explored[curr_node[1]] = curr_cost
        curr_path = totrace:pop()
    until not curr_path

    return nil
end

return { solve = solve }
