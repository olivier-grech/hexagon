function love.load()
    -- Import the HEXAGÖN library
    package.path = package.path .. ";../hexagon.lua"
    hexagon = require("hexagon")

    -- Create a 5*5 grid
    demoGrid = hexagon.grid(5, 5, 50, true, false)

    -- Create a canvas on which to draw the grid
    demoCanvas = love.graphics.newCanvas(800, 600)
end

function love.update(dt)
    -- Get the mouse cursor position
    mouseX, mouseY = love.mouse.getPosition()

    -- Calculate the coordinates of the mouse cursor in the hexagon grid
    resultX, resultY = hexagon.toHexagonCoordinates(mouseX, mouseY, demoGrid)
end

function love.draw()
    -- Draw the demonstration grid on the canvas
    hexagon.drawGrid(demoGrid, demoCanvas)

    -- Draw the canvas on screen
    love.graphics.draw(demoCanvas)

    -- Display the coordinates
    if resultX == -1 or resultY == -1 then
        love.graphics.print("Out of grid", 600, 500)
    else
        love.graphics.print("Hexagon coordinates: "..resultX.." "..resultY, 600, 500)
    end
end
