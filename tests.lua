require "./lust"
require "./astar"
require "./util"

local lust = require 'lust'
local describe, it, expect = lust.describe, lust.it, lust.expect

describe('Lua Pathfinding demo', function()

  lust.before(function()
    -- This gets run before every test.
  end)

  describe('Utils', function()
    it('Can check if values exist in a table', function()
        local t = {4,7,5,2}

        expect(table.contains(t, 4)).to.equal(true)
        expect(table.contains(t, 5)).to.equal(true)
        expect(table.contains(t, 6)).to.equal(false)
    end)
  end)
  describe('Estimation', function() -- Can be nested
    it('Simple Manhattan', function()
      local estimate = manhattan({1,1}, {3,3})
      expect(estimate).to.be.a('number')
      expect(estimate).to.equal(4)
    end)
  end)

  describe('SerDe', function()
    it('Identity function', function()
      -- Serializing a freshly-read test case produces the same input.

      local testInput = "testdata/01a-basic.txt"
      local astar = AStar:newFromFile(nil, testInput)
      local serialized = astar:serialize()

      local f = io.open(testInput, "r")
      local rawString = f:read("*all")
      f:close()

      expect(serialized).to.equal(rawString)
    end)
  end)

  describe('Maze', function()
    it('Can calculate neighbors', function()
      local testInput = "testdata/01a-basic.txt"
      local astar = AStar:newFromFile(nil, testInput)

      local index = astar.start_node.index
      expect(index).to.equal(11)

      neighbors = astar.maze:getNeighbors(index)

      expect(neighbors).to.be.a('table')
      expect(#neighbors).to.equal(4)

      local neighborIds = {10, 12, 3, 19}
      for _, id in ipairs(neighborIds) do
          local neighbor = astar.maze.data[id]
          expect(neighbors).to.have(neighbor)
      end
    end)
    it('Can calculate neighbors around bounds', function()
      local testInput = "testdata/01a-basic.txt"
      local astar = AStar:newFromFile(nil, testInput)

      neighbors = astar.maze:getNeighbors(1)
      expect(#neighbors).to.equal(2)
      expect(neighbors).to.have(2)
      expect(neighbors).to.have(9)
    end)
    it ('Can determine coordinates when given an index', function()
      local testInput = "testdata/01a-basic.txt"
      local astar = AStar:newFromFile(nil, testInput)

      local index = astar.start_node.index

      local coords = astar.maze:getCoords(index)
      expect(coords).to.equal({3, 2})
    end)
  end)

  describe('End to end', function()
    for i=1,3 do

      it('E2E: Case ' .. i, function()
        local testInput = "testdata/0" .. i .. "a.txt"
        local testSolution = "testdata/0" .. i .. "b.txt"
        local astar = AStar:newFromFile(nil, testInput)
        astar:solve()
        local serialized = astar:serialize()

        local f = io.open(testSolution, "r")
        local solution = f:read("*all")
        f:close()

        expect(serialized).to.be.a('string')
        expect(serialized).to.equal(solution)
      end)
    end
  end)
end)
