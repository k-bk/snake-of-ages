ItemMng = {}

ItemMng.array = {}
ItemMng.gfx = love.graphics.newImage("gfx/food.png")


function ItemMng:newItem(value)

    table.insert(self.array, Item(value, 8))
    self.lastValue = value
end

function ItemMng:update(dt)

    for i, item in ipairs(self.array) do
        if item.destroyed then
            table.remove(self.array, i)
        else
            item:update(dt)
        end
    end
    if #self.array < 1 then
        self:newItem(self.lastValue)
    end
end

function ItemMng:draw()

    for _, item in ipairs(self.array) do
        if not item.destroyed then 
            item:draw(self.gfx)
        end
    end
end

function ItemMng:collision(x, y, new_value)

    for _, item in ipairs(self.array) do
        if item.x == x and item.y == y then
            item.destroyed = true
            _points = _points + item.value
            self:newItem(new_value)
            return true
        end
    end
    return false
end
