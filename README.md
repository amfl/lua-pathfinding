# Pathfinding in Lua

A simple exploration of A* pathfinding algorithm in lua.
Built as a learning exercise.

- Intentionally no fancy graphical UI
- Test suite with https://github.com/bjornbytes/lust

## Usage

```sh
# Run tests
lua tests.lua

# Run example program using test data
lua main.lua
##########################
#    #   #    #     #    #
#    #   #               #
#      @ #  ++++++++++   #
#  +++++ #  + #  ####+   #
## +######  + #   #  ++  #
#  ++++++++++ #   #  #+# #
###############   #   +  #
#             ##  #   +  #
#     +++     # ######+  #
#   !++#+++++++++++++++  #
#      #                 #
##########################
```

## A* Notes

https://medium.com/@nicholas.w.swift/easy-a-star-pathfinding-7e6689c7f7b2

f(n) = g(n) + h(n)

Where:

- g(n) is path cost
- h(n) is heuristic (estimated) path cost

## Implementation Notes

AStar(maze, source_ref, goal_ref):

- Open list (Unvisited node refs)
- Closed list (Visited node refs)
- Source node ref
- Goal node ref
- Maze ref

- Serde functions

Maze:

Container for nodes. "Owns" them.

- GetNeighbors
- Dimensions

Nodes:

- Parent (How we got to this node)
- Index (Maze knows how to translate index <-> coords because it knows dimensions)
- f, g, h (but f is entirely derived)
