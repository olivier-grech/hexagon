function love.load()
    package.path = package.path .. ";../hexagon.lua"
    hexagon = require("hexagon")
    canvas = love.graphics.newCanvas(800, 600)

    hexagonOptions = {
        hexagonSize = 50,
        vertical = true
    }

    gridOptions = {
        hexagonOptions = hexagonOptions,
        gridSize = 5,
        shifted = false,
        canvas = canvas,
        x = 60,
        y = 60
    }

    hexagon.grid(gridOptions)
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    resultX, resultY = hexagon.toHexagonCoordinates(mouseX - gridOptions.x, mouseY - gridOptions.y, gridOptions)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(canvas)
    hexX, hexY = hexagon.toPlanCoordinates(resultX, resultY, gridOptions)
    hexagon.hexagon(hexX, hexY, hexagonOptions)
end
