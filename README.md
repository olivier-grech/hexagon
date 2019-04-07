HEXAGÖN is a library for LÖVE used to draw and interact with hexagonal grids.

The library is small and consists only of the following methods:

```lua
hexagon.grid(width, height, hexagonSize, pointyTopped, shifted)
```

Return an object representing a grid of hexagon. Can be passed to the
`hexagon.drawGrid` method in order to draw it on screen.
* `width` is the number of hexagon on the horizontal side of the grid.
* `height` is the number of hexagon on the vertical side of the grid.
* `pointyTopped` is a boolean that makes the hexagons pointy topped if true.
* `shifted` is a boolean that makes the grid shifted if true.

```lua
hexagon.drawGrid(grid, canvas)
```

Draw an hexagon grid on the given canvas.
* `grid` is the grid to draw.
* `canvas` is the canvas on which to draw the grid.

```lua
hexagon.toPlanCoordinates(x, y, grid)
```

Given the coordinates `x, y` of an hexagon in `grid`, returns the coordinates of
its center.

```lua
hexagon.toHexagonCoordinates(x, y, gridOptions)
```

Given the coordinates `x, y` of a point, returns the coordinates of the hexagon
under that point in `grid`.

See the demo for an example.
