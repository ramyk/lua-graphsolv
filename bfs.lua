List = require "listutils"
Set = require "setutils"

local function solve (graph, depart, dest)
    local totrace = List:new()
    local explored = Set:new()
    local curr_path = {}
    
    table.insert(curr_path, {depart, 0})
    repeat
        local curr_node = curr_path[#curr_path][1]
        if curr_node == dest then return curr_path end
        for node,cost in pairs(graph[curr_node]) do
            if not (explored:contains(node)) then
                local holder = {}
                for _,v in ipairs(curr_path) do
                    table.insert(holder, v)
                end
                table.insert(holder, {node, cost})
                totrace:pushright(holder)
            end
        end
        explored:insert(curr_node)
        curr_path = totrace:popleft()
    until not curr_path

    return nil
end

return { solve = solve }
