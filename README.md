# Pathfinding in Lua

- Intentionally no fancy graphical UI

## A* Notes

f(n) = g(n) + h(n)

Where:

- g(n) is path cost
- h(n) is heuristic (estimated) path cost

## TODO

Some kind of class, probably? Or just a table

Stuff that we need.

Serde
Text file -> Maze, which contains nodes.

AStar(maze, source_ref, goal_ref):

- Open list (Unvisited node refs)
- Closed list (Visited node refs)
- Source node ref
- Goal node ref
- Maze ref

- Serde functions (Or they can act upon AStar)

Maze:

Container for nodes. "Owns" them.

- GetNeighbors
- Dimensions

Nodes:

- Parent (How we got to this node)
- ~Coords~  Index (Maze knows how to translate index <-> coords because it knows dimensions)
- f, g, h (but f is entirely derived)
