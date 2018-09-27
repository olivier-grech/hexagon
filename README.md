HEXAGÖN is a library for LÖVE used to draw and interact with hexagonal grids.

The library is small and consists only of the following methods:

```lua
hexagon.hexagon(x, y, hexagonOptions)
```

Given the coordinates `x, y`, draw an hexagon with the parameters defined in the
table `hexagonOptions`. The possible parameters are as follow:

* `hexagonSize` is a number representing the distance in pixels between the
  center of the hexagon and one of its vertices.
* `vertical` is a boolean which make the hexagon pointy topped if set to true.

```lua
hexagon.grid(gridOptions)
```

Draw a grid of hexagon with the parameters defined in the table `gridOptions`.
The possible parameters are as follow:

* `hexagonOptions` is a table defined above.
* `gridSize` is the number of hexagon in one side of the grid.
* `shifted` is a boolean which make the grid shifted if true. See the 
screenshots below.
* `canvas` is a LÖVE canvas on which to draw the grid.
* `x` is a number representing the horizontal position of the grid.
* `y` is a number representing the vertical position of the grid.

```lua
hexagon.toPlanCoordinates(x, y, gridOptions)
```

Given the coordinates `x, y` of an hexagon in the grid representend by
`gridOptions`, returns the coordinates of its center.

```lua
hexagon.toHexagonCoordinates(x, y, gridOptions)
```

Given the coordinates `x, y` of a point, returns the coordinates of the hexagon
under that point in the grid represented by `gridOptions`.

See the demo for an example.