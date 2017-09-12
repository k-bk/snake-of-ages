Destructible = Object:extend()

function Destructible:new(x, y, hp)

    self.x = x
    self.y = y
    self.hp = hp
    self.destroyed = false
    self.img = Map.tileset[3] 
end

function Destructible:draw()
    love.graphics.draw(self.img, (self.x-1) * _tileSize, (self.y-1) * _tileSize)
end


