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
  for tag, grid in string.gmatch(file, "layer:%s*(%a+)%s*(%d+%s*)") do
    print("tag: " .. tag)
    print("grid: " .. grid)
  end
end

load("map1")


