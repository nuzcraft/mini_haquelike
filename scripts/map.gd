class_name Map

var tiles = {}

func get_tiles():
	return tiles

func add_tile(x, y, tile):
	var new_key = Vector2(x, y)
	tiles.erase(new_key)
	tiles[new_key] = tile.new(x, y)

func get_tile(location: Vector2):
	return tiles[location]

func get_adjacent_tiles(vec):
	var adjacent_tiles = {}
	var x = vec.x
	var y = vec.y
	for i in [-1, 0, 1]:
		for j in [-1, 0, 1]:
			if (i == 0 or j == 0) and i != j:
				var new_vec = Vector2(x + i, y + j)
				if tiles.has(new_vec):
					adjacent_tiles[new_vec] = tiles[new_vec]
	return adjacent_tiles
	
func get_surrounding_tiles(vec):
	var surrounding_tiles = {}
	var x = vec.x
	var y = vec.y
	for i in [-1, 0, 1]:
		for j in [-1, 0, 1]:
			if not (i == 0 and j == 0):
				var new_vec = Vector2(x + i, y + j)
				if tiles.has(new_vec):
					surrounding_tiles[new_vec] = tiles[new_vec]
	return surrounding_tiles
