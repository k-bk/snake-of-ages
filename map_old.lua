Map = {}

-- Genereal properties
Map.width = nil     -- second line in map file
Map.height = nil
Map.grid = {
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
  { 0, 0, 0, 1, 0, 2, 0, 0, 0, 0, 1, 0, 2, 0, 0, 1, 0},
  { 0, 0, 2, 0, 0, 2, 1, 0, 0, 2, 0, 0, 2, 1, 0, 0, 0},
  { 2, 0, 2, 0, 0, 2, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 2},
  { 2, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2},
  { 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2},
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  { 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 2, 0},
  { 2, 0, 1, 0, 0, 0, 0, 2, 0, 1, 0, 0, 0, 0, 2, 2, 0},
  { 0, 0, 2, 0, 0, 2, 1, 0, 0, 2, 0, 0, 2, 1, 0, 0, 0},
  { 2, 0, 2, 0, 0, 2, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 2},
  { 2, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2},
  { 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2},
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  { 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 2, 0},
  { 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}
}

Map.eventLayer = {}

function Map.draw()

  love.graphics.draw(Map.canvas, 0, 0)
end

function Map.prepareTiles()

  -- set canvas
  Map.canvas = love.graphics.newCanvas(Map.width * _tileSize, Map.height * _tileSize)

  -- Cut tileset into single tiles and read flags
  io.input("maps/" .. Map.tileset.name)
  local tileset_width = io.read("*number", "*l") 
  local flag_str = io.read()
  -- Compare sizes
  if tileset_width ~= love.graphics.getWidth(Map.tileset.image) / _tileSize then
    assert("Tileset size in px does not match size given in maps/" .. Map.tileset.name .. " file")
  end

  for i = 0, tileset_width-1 do
    local tile = love.graphics.newQuad(i*_tileSize, 0, _tileSize, _tileSize, Map.tileset.image:getDimensions()) 
    Map.tileset[i] = tile
    Map.tileset.flags[i] = flag_str[i]
  end

end

function Map.load(mapName)

  io.input("maps/" .. mapName)
  local tileset_name = io.read()

  Map.tileset = {
    name = tileset_name,
    image = love.graphics.newImage("gfx/" .. tileset_name .. ".png"),
    flags = {},
  }
  Map.width = io.read("*number")
  Map.height = io.read("*number", "*l")

  -- load map to array
  for i = 1,Map.height do
    Map.grid[i] = {}
    local row = io.read()
    for j = 1,#row do 
      Map.grid[i][j] = row[j]
    end
  end

  Map.prepareTiles()
end

function Map.getFlag(x, y)

  return Map.tileset.flags[Map.grid[x][y]]
end

function Map.updateCanvas()

  love.graphics.setCanvas(Map.canvas)
  for y = 1, Map.height do
    for x = 1, Map.width do
      love.graphics.draw(Map.tileset.image, Map.tileset[Map.grid[y-1][x-1]], (x-1) * _tileSize, (y-1) * _tileSize)
    end
  end
  love.graphics.setCanvas()
end
