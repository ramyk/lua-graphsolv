List = require "utils/listutils"
Set = require "utils/setutils"

local function solve (graph, depart, dest)
    local totrace = List:new()
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
                totrace:pushright(holder)
            end
        end
        explored:insert(curr_node[1])
        curr_path = totrace:popleft()
    until not curr_path

    return nil
end

return { solve = solve }
