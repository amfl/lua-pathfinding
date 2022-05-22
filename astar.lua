AStar = {
    maze = nil,
    start_node = nil,
    goal_node = nil,
}

-------------------------------
-- Serialization/Deserialization logic

function AStar:newFromFile(o, filename)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.maze = Maze:new()

    -- Iterate over file and populate the maze data.
    -- This doesn't have to be fast, it's just for testing.
    local num_lines = 0
    for line in io.lines(filename) do
        num_lines = num_lines + 1
        for i = 1, #line do
            local c = line:sub(i,i)
            local cost = c == '#' and 2 or 1
            local node = o.maze:insertNode(cost)

            if c == '@' then
                self.start_node = node
            elseif c == '!' then
                self.goal_node = node
            end
        end
        o.maze.dimensions[1] = #line
    end

    o.maze.dimensions[2] = num_lines

    return o
end

function AStar:solve()
    return nil
end

-- This code is truly awful because I don't know the best way to have a
-- stringbuffer in lua
function AStar:serialize()
    local s = {}
    local c = 1

    for i, node in ipairs(self.maze.data) do
        if node == self.start_node then
            s[c] = '@'
        elseif node == self.goal_node then
            s[c] = '!'
        elseif node.cost == 2 then
            s[c] = '#'
        elseif node.cost == 1 then
            s[c] = ' '
        else
            s[c] = '?'
        end
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
    data = nil,
    dimensions = nil,
}
function Maze:new(o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.data = {}
    o.dimensions = {}

    return o
end
function Maze:getNeighbors(index)
    -- TODO implement me
    return {}
end

-- Create a new node with the given cost, assign it an ID, and return it.
-- This function should be called for each node in a new maze in left->right,
-- top->bottom order, because the ID will later be used to determine
-- neighbors.
function Maze:insertNode(cost)
    local node = Node:new(nil, #self.data, cost)
    table.insert(self.data, node)
    return node
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
