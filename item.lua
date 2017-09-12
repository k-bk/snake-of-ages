Item = Object:extend()

function Item:new(value, timer)

    self:randomizeSpawn()
    self.value = value
    self.timer = timer
    self.destroyed = false
end

function Item:update(dt)

    self.timer = self.timer - dt
    if self.timer < 0 then
        self.destroyed = true
    end
end

function Item:draw(img)
    love.graphics.draw(img, (self.x-1) * _tileSize, (self.y-1) * _tileSize)
end

function Item:randomizeSpawn()

    repeat
        self.x = love.math.random(Map.width)
        self.y = love.math.random(Map.height)
    until Map.flags[self.y][self.x] == 0
end
