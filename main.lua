debug = false

Object = require "lib/classic"
require "player"
require "segment"
require "map"
require "item"
require "itemManager"

function love.load()

    -- Globals
    _tileSize = 32
    _points = 0

    love.graphics.setBackgroundColor(255,255,255)
    Map.load("map1")
    Map.updateCanvas()
    player = Player()
end

function love.update(dt)

    if not debug then
        player:update(dt)
        ItemMng:update(dt)
    end
end

function love.draw()

    Map.draw()
    ItemMng:draw()
    player:draw()
    if debug then
        love.graphics.print("Points: " .. _points, 20, 20)
        love.graphics.print("Speed: " .. 1 / player.room_speed, 20, 40)
        love.graphics.print("Length: " .. player.length, 20, 60)
    end
end

function love.keypressed(key)

    if key == 'q' then
        love.event.quit()
    elseif key == 'r' then
        love.load()
    elseif key == 'f1' then
        debug = not debug
    end
    player:keypressed(key)
end
