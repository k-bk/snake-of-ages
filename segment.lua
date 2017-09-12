Segment = Object:extend()

function Segment:new(x, y, direction)

    self.x = x 
    self.y = y 
    self.type = "normal"    -- types: normal, head, tail 
    self:findFrame(direction, direction)
end

function Segment:findFrame(directionLast, direction)
    self.frame = directionLast * 4 + direction 
    self.direction = direction
    self.directionLast = directionLast
end


