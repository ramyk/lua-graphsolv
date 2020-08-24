List = require "utils/listutils"
Set = require "utils/setutils"
Heap = require "utils/heaputils"

local function solve (graph, sld, depart, dest)
    local totrace = Heap:new(
        function (a,b)
            local node_a = a:popleft()
            local node_b = b:popleft()
            a:pushleft(node_a)
            b:pushleft(node_b)
            return (sld[dest][node_a[1]] < sld[dest][node_b[1]])
        end
        )
    local explored = Set:new()
    local curr_path = List:new()

    curr_path:pushleft({depart, 0})
    repeat
        local curr_node = curr_path:popleft()
        if curr_node[1] == dest then
            curr_path:pushleft(curr_node)
            return curr_path
        end
        for node,cost in pairs(graph[curr_node[1]]) do
            if not (explored:contains(node)) then
                local holder = curr_path:copy()
                holder:pushleft(curr_node)
                holder:pushleft({node, cost})
                totrace:insert(holder)
            end
        end
        explored:insert(curr_node[1])
        curr_path = totrace:pop()
    until not curr_path

    return nil
end

return { solve = solve }
