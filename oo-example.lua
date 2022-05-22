-- https://www.tutorialspoint.com/lua/lua_object_oriented.htm

Rect = { area = 0, length = 0; breadth = 0 }

function Rect:new(o, length, breadth)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.length = length
    self.breadth = breadth
    return o
end

function Rect:area()
    return self.length * self.breadth
end

r = Rect:new(nil, 10, 20)
print(r.length)
print(r:area())  -- 200
