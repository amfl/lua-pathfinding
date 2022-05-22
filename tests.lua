require "./lust"
require "./astar"

local lust = require 'lust'
local describe, it, expect = lust.describe, lust.it, lust.expect

describe('Lua Pathfinding demo', function()

  lust.before(function()
    -- This gets run before every test.
  end)

  describe('Estimation', function() -- Can be nested
    it('Simple Manhattan', function()
      local estimate = h({1,1}, {3,3})
      expect(estimate).to.be.a('number')
      expect(estimate).to.equal(4)
    end)
  end)

  describe('SerDe', function()
    it('Identity function', function()
      -- Serializing a freshly-read test case produces the same input.

      local testFile = "testdata/01a-basic.txt"
      local astar = AStar:newFromFile(nil, "testdata/01a-basic.txt")
      local serialized = astar:serialize()

      local f = io.open(testFile, "r")
      local rawString = f:read("*all")
      f:close()

      expect(serialized).to.equal(rawString)
    end)
  end)

  describe('End to end', function()
    it('01', function()
      local testFile = "testdata/01a-basic.txt"
      local astar = AStar:newFromFile(nil, "testdata/01a-basic.txt")
      astar:solve()
      local serialized = astar:serialize()

      local f = io.open(testFile, "r")
      local solution = f:read("*all")
      f:close()

      expect(serialized).to.be.a('string')
      expect(serialized).to.equal(solution)
    end)

  end)
end)
