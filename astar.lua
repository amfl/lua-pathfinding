require "util"

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

    self.start_node.g = 0 -- TODO maybe this should be in constructor?
                          -- Better - Passed into this function.

    -- Cache goal coords. Used for checking heuristic.
    local goal_coords = self.maze:getCoords(self.goal_node.index)

    -- loop stop when:
    --     You add the target node to the closed list (found the path!)
    --     Fail to find target node, and the open list is empty. (No path :c)
    while #self.open_list > 0 do -- TODO proper condition
        -- sort the open list by f value
        table.sort(self.open_list, function(n1, n2)
            return n1.f > n2.f
        end)

        -- Take the lowest:
        local n = table.remove(self.open_list)

        if n == self.goal_node then
            -- Found the path!
            break
        end

        --   Switch it to closed list
        table.insert(self.closed_list, n)

        -- For each neighbor:
        for _, neighbor in ipairs(self.maze:getNeighbors(n.index)) do
            -- If it is not walkable or if it is on the closed list (we've already visited it), ignore it.
            -- Lua has no `continue` statement (!?)
            if neighbor.cost ~= math.huge and
                    not table.contains(self.closed_list, neighbor) then

                -- Update heuristic if required
                if neighbor.h == math.huge then
                    neighbor.h = manhattan(goal_coords, self.maze:getCoords(neighbor.index))
                end

                -- Path cost of arriving at the neighbor this way
                local g = n.g + neighbor.cost

                if table.contains(self.open_list, neighbor) then
                -- If the neighbor is already on the open list, check to see if this path to that square is better, using G cost as the measure. A lower G means that this is a better path. If so, change the parent to this square, and recalculate G and F scores. (If you are keeping the open list sorted by F score, you may need to resort the list to account for the change.)
                    if g < neighbor.g then
                        neighbor.parent = n
                        neighbor.g = g
                        neighbor.f = neighbor.g + neighbor.h
                    end
                else
                -- If the neighbor isn't on the open list, add it to the open list. Make the current node the parent of this node. Record F, G, and H costs.
                    table.insert(self.open_list, neighbor)
                    neighbor.parent = n
                    neighbor.g = g
                    neighbor.f = neighbor.g + neighbor.h
                end
            end
        end
    end

    -- If we have a solution...
    if self.goal_node.parent ~= nil then
        -- Walk backwards down parents to reveal the final path.
        local n = self.goal_node
        repeat
            n = n.parent
            n.on_path = true
        until n.parent == nil
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
        elseif node.on_path then
            s[c] = '+'
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
    g = math.huge,     -- Distance between the current node and the start node.
    h = math.huge,     -- Heuristic - estimated distance from the current node to the end node.
    f = math.huge,     -- Total cost of the node. f = g + h, but we record it as a kind of cache.

    on_path = false,   -- Whether this node is on the most final, optimal path to the goal.
                       -- Used only for rendering output. Not important for algorithm.
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
