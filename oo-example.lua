-- https://www.tutorialspoint.com/lua/lua_object_oriented.htm

Rect = { area = 0, length = 0; breadth = 0 }

function Rect:new(o, length, breadth)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    -- o.length = length
    o.breadth = breadth
    return o
end

function Rect:area()
    return self.length * self.breadth
end

r = Rect:new(nil, 10, 20)
x = Rect:new(nil, 50, 20)
r.length = 10
x.length = 50
print(r.length)
print(x.length)
print(r:area())  -- 200
print(x:area())  -- 1000
