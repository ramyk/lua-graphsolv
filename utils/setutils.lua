Set = {}

function Set:new ()
    local set = {}
    setmetatable(set, self)
    self.__index = self
    return set
end

function Set.fromlist (list)
    local s = {}
    for _,v in ipairs(list) do s[v] = true end
    return s
end

function Set:insert (item)
    self[item] = true
end

function Set:remove (item)
    self[item] = nil
end

function Set:contains (item)
    return not (self[item] == nil)
end

return Set
