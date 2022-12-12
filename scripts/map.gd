class_name Map

var tiles = {}
var astar = AStar2D.new()

func get_tiles():
	return tiles

func add_tile(x, y, tile):
	var new_key = Vector2(x, y)
	tiles.erase(new_key)
	tiles[new_key] = tile.new(x, y)

func get_tile(x, y):
	return tiles[Vector2(x, y)]

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
					
func compute_astar():
	astar.clear()
	for vec in tiles.keys():
		# check if the vector is already a position in the astar map
		var point_found = false
		for point in astar.get_points():
			if astar.get_point_position(point) == vec:
				point_found = true
		if point_found:
			continue
		# check if the position is a walkable one
		if not tiles[vec].get_is_walkable():
			continue
		var main_point = astar.get_available_point_id()
		astar.add_point(main_point, vec)
		# let's do the same with adjacent tiles
		for adj_vec in get_adjacent_tiles(vec):
			if not tiles[adj_vec].get_is_walkable():
				continue
			var adj_point = null
			for point in astar.get_points():
				if astar.get_point_position(point) == adj_vec:
					adj_point = point
			if adj_point == null:
				adj_point = astar.get_available_point_id()
				astar.add_point(adj_point, adj_vec)
			astar.connect_points(main_point, adj_point)

	
		
		
	
