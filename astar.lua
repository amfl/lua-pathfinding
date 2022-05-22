AStar = {
    maze = nil,
    start_node = nil,
    goal_node = nil,
}

-------------------------------
-- Serialization/Deserialization logic

function AStar:newFromFile(o, filename)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.maze = Maze:new()

    -- Iterate over file and populate the maze data.
    -- This doesn't have to be fast, it's just for testing.
    local num_lines = 0
    for line in io.lines(filename) do
        num_lines = num_lines + 1
        for i = 1, #line do
            local c = line:sub(i,i)
            local cost = c == '#' and 2 or 1
            self.maze:insertNode(cost)
        end
        self.maze.dimensions[1] = #line
    end

    self.maze.dimensions[2] = num_lines

    return self
end

-- This code is truly awful because I don't know the best way to have a
-- stringbuffer in lua
function AStar:serialize()
    local s = {}
    local c = 1

    for i, node in ipairs(self.maze.data) do
        -- TODO print start and goal
        s[c] = node.cost == 2 and '#' or 't'
        c = c + 1
        if i % self.maze.dimensions[1] == 0 then
            s[c] = '\n'
            c = c + 1
        end
    end

    return table.concat(s)
end

-------------------------------

Maze = {
    data = {},
    dimensions = {},
}
function Maze:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function Maze:getNeighbors(index)
    -- TODO implement me
    return {}
end
function Maze:insertNode(cost)
    local node = Node:new(nil, #self.data, cost)
    table.insert(self.data, node)
end

-------------------------------

Node = {
    index = -1,        -- Unique index of this node in the maze
    cost = math.huge,  -- Cost for moving onto this node
    parent = nil,      -- Reference to the node we used to get here
    g = nil,
    h = nil,
}
function Node:new(o, index, cost)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.index = index
    o.cost = cost or 0

    return o
end

-------------------------------

-- Path cost heuristic (estimation) function: Manhattan distance
function h(source_node, dest_node)
    return math.abs(source_node[1] - dest_node[1]) +
           math.abs(source_node[2] - dest_node[2])
end

-- Path cost function
function g(node)
    return 4
end
