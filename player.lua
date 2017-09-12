Player = Object:extend()

function Player:new(x, y)

    -- Coordinates
    self.x = x or 0
    self.y = y or 0

    dir = { 
        up = 0,
        right = 1,
        down = 2,
        left = 3 
    }
    self.direction = "right" 
    self.directionInput = self.direction
    self.directionLast = self.direction

    -- Speed of the snake
    self.delay = 0
    self.room_speed = 0.3

    -- Body segments
    self.length = 3 
    self.segments = {}

    -- Graphics
    self:loadSprite()

    -- Input
    self.input1 = nil
    self.input2 = nil

    -- States
    self.loopAllowed = true     -- no screen border collisions

    ItemMng:newItem(1) 
end

function Player:update(dt)

    self.delay = self.delay + dt

    if self.delay >= self.room_speed then
        -- Managing input
        self:manageInputQueue()
        self.direction = self.directionInput
        -- Setting the timer
        self.delay  = self.delay - self.room_speed
        -- Store old player's position
        self.oldX, self.oldY = self.x, self.y

        -- Change destination coordinates accordingly
        if self.direction == "up" then
            self.y = self.y - 1
        elseif self.direction == "down" then
            self.y = self.y + 1
        elseif self.direction == "left" then
            self.x = self.x - 1
        elseif self.direction == "right" then
            self.x = self.x + 1
        end
        -- Update the direction of last segment (if any exists)
        if #self.segments > 0 then
            last_seg = self.segments[#self.segments]
            last_seg:findFrame(dir[self.directionLast], dir[self.direction])
        end
        -- Loop the snake around the screen
        if self.loopAllowed then
            self.x = self.x % Map.width
            self.y = self.y % Map.height
        end
        self:collisionManager()
        self:destroySegment()
    end

    -- FIXME hard coded speed change 
    self.room_speed = 5 / (10 + _points)
end

function Player:newSegment()
    --  Function places a new segment on actual player's coordinates,

    if #self.segments > 0 then
        self.segments[#self.segments].type = "normal"
    end

    -- Place new segment at the end of segments table
    local new_seg = Segment(self.x, self.y, dir[self.direction])
    -- Put a flag (there is segment) at player's coordinates
    Map.eventLayer[self.y+1][self.x+1] = 2
    table.insert(self.segments, new_seg)
    -- Update the direction of the head
    self.directionLast = self.direction

    if #self.segments > 0 then
        self.segments[#self.segments].type = "head"
    end
end

function Player:destroySegment()

    if #self.segments > self.length then
        local tail = self.segments[1]
        Map.eventLayer[tail.y+1][tail.x+1] = 0 
        table.remove(self.segments, 1)
    end
    if #self.segments > 0 then
        self.segments[1].type = "tail"
    end
end

function Player:draw()

    if debug then
        local spriteNum = dir[self.directionLast]*4 + dir[self.direction]
        love.graphics.draw(self.img, self.sprites[spriteNum], self.x * _tileSize, self.y * _tileSize)
    end

    -- Draw the body segments
    for _, seg in ipairs(self.segments) do
        if seg.type == "normal" then
            love.graphics.draw(self.img, self.sprites[seg.frame], seg.x * _tileSize, seg.y * _tileSize)
        elseif seg.type == "head" then
            love.graphics.draw(self.imgHead, self.sprites[seg.frame], seg.x * _tileSize, seg.y * _tileSize)
        elseif seg.type == "tail" then
            love.graphics.draw(self.imgTail, self.sprites[seg.frame], seg.x * _tileSize, seg.y * _tileSize)
        end
    end
end

function Player:keypressed(key)

    -- check if it is any of directional keys
    if dir[key] then 
        -- check whether input storage is empty
        if self.input1 == nil then
            -- if presses the opposite arrow - do nothing 
            if (dir[key] + dir[self.direction])%2 ~= 0 then
                self.input1 = key
            end
            self.input2 = nil
        -- if there is already some input
        elseif self.input2 == nil and self.input1 ~= key  and (dir[key] + dir[self.input1])%2 ~= 0 then
            self.input2 = key
        end
    end
end

function Player:loadSprite()

    self.img = love.graphics.newImage("gfx/snake.png")
    self.imgHead = love.graphics.newImage("gfx/snake_head.png")
    self.imgTail = love.graphics.newImage("gfx/snake_tail.png")
    self.sprites = {}

    -- Cut image into quads (sprites)
    for i = 0, 15 do
        sprite = love.graphics.newQuad(i * _tileSize, 0, _tileSize, _tileSize, self.img:getDimensions())
        self.sprites[i] = sprite
    end
end
        
function Player:collisionManager()

    local flag = Map.getFlag(self.x - 1, self.y - 1)
    if     flag == 0 then           -- normal tile
        self:newSegment()
    elseif flag == 1 or flag == 2 then       -- solid block
        self.x, self.y = self.oldX, self.oldY
        self.length = self.length - 1
    end
    if ItemMng:collision(self.x+1, self.y+1, 1) then
        self.length = self.length + 1
    end

    -- Manage restart TODO restart event
    if self.length < 1 then love.load() end
end

function Player:manageInputQueue()
    --  It manages the storage of input on so-called two element queue.
    -- Player can press both arrows together (in one grid-frame) and 
    -- both movements will be executed.
    
    if self.input1 then
        self.directionInput = self.input1
        self.input1 = self.input2
        self.input2 = nil
    end
end

