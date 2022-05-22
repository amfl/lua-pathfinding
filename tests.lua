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
    it('01', function()
      -- Serializing a freshly-read test case produces the same input.

      local testFile = "testdata/01a.txt"
      local map = fromFile(testFile)
      local serialized = map.serialize()

      local f = io.open(testFile, "r")
      local rawString = f.read()

      expect(serialized).to.equal(rawString)
    end)
  end)

  describe('End to end', function()
    it('01', function()
      local map = astarmap.fromFile("testdata/01a.txt")
      local solve = map.solve()
      local serialized = solve.serialize()

      expect(serialized).to.be.a('string')
      expect(estimate).to.equal(4)
    end)

  end)
end)
