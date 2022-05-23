require "astar"

astar = AStar:newFromFile(nil, "testdata/03a.txt")

astar:solve()

print(astar:serialize())
