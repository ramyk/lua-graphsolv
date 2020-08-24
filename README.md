# lua-graphsolv
A project I've created for some fun and practice of basic and semi-advanced search agents using the Lua language.

The search problem was a simple path-finding problem, also if the algorithm allows it, we try to return the least costly path between the departure and the destination.

The graph nodes used for this problem are the central cities of the Tunisian governorates. Each city is only connected to the governorates that it has direct geographical access to it. As such, the maximum branching factor of the example graph constructed is 7.

The search algorithms implemented are:
- [x] Breadth-First Search
- [x] Depth-First Search
- [x] Uniform Cost Search (Dijkstra without the memorization of all paths)
- [x] Greedy Search
- [x] A-star Search
- [x] Hill Climbing Algorithm
- [x] Steepest-Ascent Hill Climbing
