class_name Map

var tiles = {}

func get_tiles():
	return tiles

func add_tile(x, y, tile):
	var new_key = Vector2(x, y)
	tiles.erase(new_key)
	tiles[new_key] = tile.new(x, y)

func get_tile(x, y):
	return tiles[Vector2(x, y)]
