-- -----------------------
-- Map:
--  outer functions:
--      - draw(tx, ty) - draws the map (all layers) starting from (tx, ty) coordinates
--      - load(map_name) - loads a ~/maps/name.map file and fills each layer
--  inner functions:
--      - prepareTiles - reads the tileset, cuts it into quads
Map = {
  width = nil,
  height = nil,
  layers = {},
}

function Map.draw(tx, ty)
  for _,layer in ipairs(Map.layers) do
    love.graphics.draw(layer.canvas, tx, ty)
  end
end

function Map.load(map_name)

  io.input("maps/" .. map_name .. ".map")
  local file = io.read("*a")

  -- find tileset name
  local tileset_name = string.match(file, "tileset:%s*(%a+%.%a+)")
  -- find map width
  Map.width = string.match(file, "width:%s*(%d+)")
  -- find map height
  Map.height = string.match(file, "height:%s*(%d+)")

  -- read layers
  for start in string.gmatch(file, "layer:()") do
    for num in string.gmatch() do

    end
  end
    
    
end

return Map
