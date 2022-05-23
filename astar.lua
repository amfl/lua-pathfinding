AStar = {
    maze = nil,
    start_node = nil,
    goal_node = nil,
    open_list = nil,     -- Unvisited node refs
    closed_list = nil,   -- Visited node refs
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
    self.open_list = {self.start_node}
    self.closed_list = {}

    -- loop:
    --   Stop when:
    --     You add the target node to the closed list (found the path!)
    --     Fail to find target node, and the open list is empty. (No path :c)
    while false do -- TODO proper condition
        -- sort the open list by f value
        table.sort(self.open_list, function(n1, n2)
            return n1.f < n2.f
        end)

        -- Take the lowest:
        local n = table.remove(self.open_list)

        --   Switch it to closed list
        table.insert(self.closed_list, n)

        -- For each neighbor:
        for neighbor in self.maze:getNeighbors(n.index) do
            -- If it is not walkable or if it is on the closed list (we've already visited it), ignore it.
            -- Lua has no `continue` statement (!?)
            if neighbor.cost ~= math.huge and
                table.contains(self.closed, neighbor) then

        --     If it isn't on the open list, add it to the open list. Make the current node the parent of this node. Record F, G, and H costs.
        --     If it is already on the open list, check to see if this path to that square is better, using G cost as the measure. A lower G means that this is a better path. If so, change the parent to this square, and recalculate G and F scores. (If you are keeping the open list sorted by F score, you may need to resort the list to account for the change.)
        -- Now walk backwards down parents.
            end
        end

    end

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
    -- TODO WARNING: There's no bounds checking here!
    return {
        self.data[index-1],
        self.data[index+1],
        self.data[index-self.dimensions[1]],
        self.data[index+self.dimensions[1]],
    }
end
function Maze:getCoords(index)
    return {
        index % self.dimensions[1],                  -- x
        math.floor(index / self.dimensions[1]) + 1,  -- y
    }
end

-- Create a new node with the given cost, assign it an ID, and return it.
-- This function should be called for each node in a new maze in left->right,
-- top->bottom order, because the ID will later be used to determine
-- neighbors.
function Maze:insertNode(cost)
    local node = Node:new(nil, #self.data + 1, cost)
    table.insert(self.data, node)
    return node
end

-------------------------------

Node = {
    index = -1,        -- Unique index of this node in the maze
    cost = math.huge,  -- Cost for moving onto this node
    parent = nil,      -- Reference to the node we used to get here
    g = math.huge,
    h = math.huge,
    f = math.huge,
}
function Node:new(o, index, cost)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.index = index
    o.cost = cost or 0
    o.g = math.huge
    o.h = math.huge
    o.f = math.huge

    return o
end

-------------------------------

-- Path cost heuristic (estimation) function: Manhattan distance
function manhattan(source_node, dest_node)
    return math.abs(source_node[1] - dest_node[1]) +
           math.abs(source_node[2] - dest_node[2])
end

-- Path cost function
function g(node)
    return 4
end
