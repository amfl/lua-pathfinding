require "astar"

astar = AStar:newFromFile(nil, "testdata/01a-basic.txt")

dimensions = astar.maze.dimensions
print(dimensions[1], dimensions[2])

print(astar:serialize())
