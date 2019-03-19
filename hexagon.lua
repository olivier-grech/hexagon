local hexagon = {}

function hexagon.hexagon(x, y, hexagonOptions)
    local vertical = hexagonOptions.vertical
    local hexagonSize = hexagonOptions.hexagonSize

    local vertices = {}

    if vertical then
        table.insert(vertices, x)
        table.insert(vertices, y + hexagonSize)
        for i = 1, 5 do
            table.insert(vertices, x + hexagonSize * math.sin(i * math.pi / 3))
            table.insert(vertices, y + hexagonSize * math.cos(i * math.pi / 3))
        end
    else
        table.insert(vertices, x + hexagonSize)
        table.insert(vertices, y)
        for i = 1, 5 do
            table.insert(vertices, x + hexagonSize * math.cos(i * math.pi / 3))
            table.insert(vertices, y + hexagonSize * math.sin(i * math.pi / 3))
        end
    end

    love.graphics.polygon("line", vertices)
end

function hexagon.grid(gridOptions)
    local gridSize = gridOptions.gridSize

    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 0, 0, 1)
    for i = 1, gridSize do
        for j = 1, gridSize do
            hx, hy = hexagon.toPlanCoordinates(i, j, gridOptions)
            hexagon.hexagon(hx, hy, gridOptions.hexagonOptions)
        end
    end

    love.graphics.setCanvas()
end

-- Given the coordinates of an hexagon in the grid, return the coordinates of its center in the plan
function hexagon.toPlanCoordinates(x, y, gridOptions)
    local vertical = gridOptions.hexagonOptions.vertical
    local hexagonSize = gridOptions.hexagonOptions.hexagonSize
    local shifted = gridOptions.shifted

    if vertical then
        hx = x * 2 * hexagonSize * (math.sin(math.pi / 3))
        hy = hexagonSize + (y - 1) * hexagonSize * (math.cos(math.pi / 3) + 1)

        if (shifted and y % 2 == 0) or (not shifted and y % 2 == 1) then
            hx = hx - hexagonSize * (math.sin(math.pi / 3))
        end
    else
        hx = hexagonSize + (x - 1) * hexagonSize * (math.cos(math.pi / 3) + 1)
        hy = y * 2 * hexagonSize * (math.sin(math.pi / 3))

        if (shifted and x % 2 == 0) or (not shifted and x % 2 == 1) then
            hy = hy - hexagonSize * (math.sin(math.pi / 3))
        end
    end

    return hx + gridOptions.x, hy + gridOptions.y
end

-- Given the coordinates of a point in the plan, return the coordinates of the hexagon under that point in the grid
function hexagon.toHexagonCoordinates(x, y, gridOptions)
    local vertical = gridOptions.hexagonOptions.vertical
    local gridSize = gridOptions.gridSize

    local resultX = 0
    local resultY = 0

    if vertical then
        resultX, resultY = toHexagonCoordinatesVertical(x, y, gridOptions)
    else
        resultX, resultY = toHexagonCoordinatesHorizontal(x, y, gridOptions)
    end

    -- Out of the grid
    if resultX < 1 or resultX > gridSize or resultY < 1 or resultY > gridSize then
        resultX = -1
        resultY = -1
    end

    return resultX, resultY
end

function toHexagonCoordinatesHorizontal(x, y, gridOptions)
    local hexagonSize = gridOptions.hexagonOptions.hexagonSize
    local shifted = gridOptions.shifted

    local tileX = 0
    local tileY = 0
    local tileThirdWidth = hexagonSize * math.cos(math.pi / 3)
    local tileWidth = 3 * tileThirdWidth
    local tileHalfHeight = hexagonSize * math.cos(math.pi / 6)
    local tileHeight = 2 * tileHalfHeight

    -- We use math.ceil because we start the coordinates at 1 and not 0
    tileX = math.ceil(x / tileWidth)

    if math.fmod(x, tileWidth) < tileThirdWidth then
        if (not shifted and tileX % 2 == 0) or (shifted and tileX % 2 == 1) then
            tileY = math.ceil(y / tileHeight)
            offset = 0
        else
            tileY = math.ceil((y - tileHalfHeight) / tileHeight)
            offset = tileHalfHeight
        end

        -- Uncertain, so we check which hexagon is the nearest
        xA = (tileX - 1) * tileWidth + hexagonSize
        xB = (tileX - 1) * tileWidth + tileThirdWidth - hexagonSize
        xC = xA
        yA = (tileY - 1) * tileHeight + offset
        yB = yA + tileHeight / 2
        yC = yB + tileHeight / 2

        distanceToA = distanceBetween(x, y, xA, yA)
        distanceToB = distanceBetween(x, y, xB, yB)
        distanceToC = distanceBetween(x, y, xC, yC)

        if (not shifted and tileX % 2 == 0) or (shifted and tileX % 2 == 1) then
            hexagonA = {X = tileX, Y = tileY - 1}
            hexagonC = {X = tileX, Y = tileY}
        else
            hexagonA = {X = tileX, Y = tileY}
            hexagonC = {X = tileX, Y = tileY + 1}
        end
        hexagonB = {X = tileX - 1, Y = tileY}

        possibleHexagons = {[distanceToA] = hexagonA, [distanceToB] = hexagonB, [distanceToC] = hexagonC}
        distances = {}

        for k in pairs(possibleHexagons) do
            table.insert(distances, k)
        end
        table.sort(distances)

        closerHexagon = possibleHexagons[distances[1]]
        resultX = closerHexagon.X
        resultY = closerHexagon.Y
    else
        if (not shifted and tileX % 2 == 0) or (shifted and tileX % 2 == 1) then
            tileY = math.ceil((y - tileHalfHeight) / tileHeight)
        else
            tileY = math.ceil(y / tileHeight)
        end

        resultX = tileX
        resultY = tileY
    end

    return resultX, resultY
end

function toHexagonCoordinatesVertical(x, y, gridOptions)
    local hexagonSize = gridOptions.hexagonOptions.hexagonSize
    local shifted = gridOptions.shifted

    local tileX = 0
    local tileY = 0
    local tileThirdHeight = hexagonSize * math.cos(math.pi / 3)
    local tileHeight = 3 * tileThirdHeight
    local tileHalfWidth = hexagonSize * math.cos(math.pi / 6)
    local tileWidth = 2 * tileHalfWidth

    -- We use math.ceil because we start the coordinates at 1 and not 0
    tileY = math.ceil(y / tileHeight)

    if math.fmod(y, tileHeight) < tileThirdHeight then
        if (not shifted and tileY % 2 == 0) or (shifted and tileY % 2 == 1) then
            tileX = math.ceil(x / tileWidth)
            offset = 0
        else
            tileX = math.ceil((x - tileHalfWidth) / tileWidth)
            offset = tileHalfWidth
        end

        -- Uncertain, so we check which hexagon is the nearest
        yA = (tileY - 1) * tileHeight + hexagonSize
        yB = (tileY - 1) * tileHeight + tileThirdHeight - hexagonSize
        yC = yA
        xA = (tileX - 1) * tileWidth + offset
        xB = xA + tileWidth / 2
        xC = xB + tileWidth / 2

        distanceToA = distanceBetween(x, y, xA, yA)
        distanceToB = distanceBetween(x, y, xB, yB)
        distanceToC = distanceBetween(x, y, xC, yC)

        if (not shifted and tileY % 2 == 0) or (shifted and tileY % 2 == 1) then
            hexagonA = {Y = tileY, X = tileX - 1}
            hexagonC = {Y = tileY, X = tileX}
        else
            hexagonA = {Y = tileY, X = tileX}
            hexagonC = {Y = tileY, X = tileX + 1}
        end
        hexagonB = {Y = tileY - 1, X = tileX}

        possibleHexagons = {[distanceToA] = hexagonA, [distanceToB] = hexagonB, [distanceToC] = hexagonC}
        distances = {}

        for k in pairs(possibleHexagons) do
            table.insert(distances, k)
        end
        table.sort(distances)

        closerHexagon = possibleHexagons[distances[1]]
        resultX = closerHexagon.X
        resultY = closerHexagon.Y
    else
        if (not shifted and tileY % 2 == 0) or (shifted and tileY % 2 == 1) then
            tileX = math.ceil((x - tileHalfWidth) / tileWidth)
        else
            tileX = math.ceil(x / tileWidth)
        end

        resultX = tileX
        resultY = tileY
    end

    return resultX, resultY
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
end

return hexagon
