Map = {}

function load(map_name)

  io.input("maps/" .. map_name .. ".map")
  local file = io.read("*a")

  -- find tileset name
  local tileset_name = string.match(file, "tileset:%s*(%a+%.%a+)")
  -- find map width
  Map.width = string.match(file, "width:%s*(%d+)")
  -- find map height
  Map.height = string.match(file, "height:%s*(%d+)")

  -- read layers
  Map.layers = {}

  -- find layers tag (static/dynamic) and put into grid the "grid" chunk of file
  for tag, grid in string.gmatch(file, "layer:%s*(%a+)%s*{%s*(.-)%s*}") do

    -- make new layer every time keyword "layer:" is found
    table.insert(Map.layers, {})
    local layer = Map.layers[#Map.layers]
    layer.tag = tag

    -- go through the lines of grid
    for line in string.gmatch(grid, "[^\r\n]+") do
      table.insert(layer, {})
      row = layer[#layer]

      -- for every line of grid insert space separated numbers
      for value in string.gmatch(line, "%d+") do
        table.insert(row, value)
      end

    end
  end
end

load("map1")


