class_name DungeonGenerator

const ROOM_SIZE_TILES = 9
const ROOM_SLOTS_IN_WORLD = 5

var rooms_layouts_data = preload("res://resources/room_layouts.png").get_data()

var tiles = []
var num_tiles_x = 0
var num_tiles_y = 0

var rng = RandomNumberGenerator.new()

func _init(input_tiles):
	tiles = input_tiles
	num_tiles_x = input_tiles.size()
	num_tiles_y = input_tiles[0].size()

func generate_dungeon():
	rng.randomize()
	###
	# start with a 2d array of room slots
	var rooms = []
	for room_x in ROOM_SLOTS_IN_WORLD:
		rooms.append([])
		for room_y in ROOM_SLOTS_IN_WORLD:
			rooms[room_x].append(null)
	# pick one of the slots as the first room
	var initial_room_x = rng.randi_range(0, ROOM_SLOTS_IN_WORLD - 1)
	var initial_room_y = rng.randi_range(0, ROOM_SLOTS_IN_WORLD - 1)
	var this_room_coords = [initial_room_x, initial_room_y]
	var rooms_coords = []
	rooms_coords.append(this_room_coords)
	# find available adjacent slots, pick one, add to list of rooms
	# repeat x times to create the happy path of the dungeon
	# store the happy path somewhere
	while rooms_coords.size() < 5:
		var adjacent_coords = get_adjacent_room_coords(this_room_coords)
		var new_room_coords = get_random_room_coords(adjacent_coords)
		if not rooms_coords.has(new_room_coords):
			rooms_coords.append(new_room_coords)
			this_room_coords = new_room_coords
	var happy_path_coords = rooms_coords.duplicate()
	# choose a random room
	# find available adjacent slots, pick one, add to list of rooms
	# repeat x times for branching paths
	var branch_rooms = []
	while branch_rooms.size() < 3:
		var room_to_branch_from = get_random_room_coords(rooms_coords)
		var adjacent_branch_coords = get_adjacent_room_coords(room_to_branch_from)
		var new_branch_coords = get_random_room_coords(adjacent_branch_coords)
		if not rooms_coords.has(new_branch_coords):
			rooms_coords.append(new_branch_coords)
			branch_rooms.append(new_branch_coords)
	###
	# now we have the map we need to build
	###
	# go through each room, and assign it a room layout
	# export room layout info to tiles (a 2d array)
	for room_coord in rooms_coords:
		var map_x = room_coord[0] * ROOM_SIZE_TILES
		var map_y = room_coord[1] * ROOM_SIZE_TILES
		tiles = generate_random_room(tiles, map_x, map_y)
	# fill in the outer walls
	for room_coord in rooms_coords:
		var adjacent_room_coords = get_adjacent_room_coords(room_coord)
		for adjacent_room_coord in adjacent_room_coords:
			if not rooms_coords.has(adjacent_room_coord):
				var direction = get_direction_from_coord_to_coord(room_coord, adjacent_room_coord)
				tiles = fill_wall_direction(tiles, room_coord, direction)
		if room_coord[0] == 0:
			tiles = fill_wall_direction(tiles, room_coord, "left")
		if room_coord[1] == 0:
			tiles = fill_wall_direction(tiles, room_coord, "up")
		if room_coord[0] == ROOM_SLOTS_IN_WORLD - 1:
			tiles = fill_wall_direction(tiles, room_coord, "right")
		if room_coord[1] == ROOM_SLOTS_IN_WORLD - 1:
			tiles = fill_wall_direction(tiles, room_coord, "down")
	# fill in spaces between 2 happy path rooms with wall tiles
	for index in happy_path_coords.size() - 1:
		var adjacent_room_coords = get_adjacent_room_coords(happy_path_coords[index])
		for adjacent_room_coord in adjacent_room_coords:
			if happy_path_coords.has(adjacent_room_coord):
				var match_adjacent_happy_path = false
				if index > 0:
					if adjacent_room_coord == happy_path_coords[index - 1]:
						match_adjacent_happy_path = true
				if index < happy_path_coords.size() - 1:
					if adjacent_room_coord == happy_path_coords[index + 1]:
						match_adjacent_happy_path = true
				if match_adjacent_happy_path == false:
					var direction = get_direction_from_coord_to_coord(happy_path_coords[index], adjacent_room_coord)
					tiles = fill_wall_direction(tiles, happy_path_coords[index], direction)
	# fill in spaces between branch rooms so they only have one entrance
	for coord in branch_rooms:
		var adjacent_room_coords = get_adjacent_room_coords(coord)
		var found_link_to_happy_path = false
		for adjacent_room_coord in adjacent_room_coords:
			if adjacent_room_coord in happy_path_coords:
				if found_link_to_happy_path == true:
					var direction = get_direction_from_coord_to_coord(adjacent_room_coord, coord)
					tiles = fill_wall_direction(tiles, adjacent_room_coord, direction)
				else:
					found_link_to_happy_path = true
	# TODO: put walls between branch rooms unless it would block access
	return tiles
	
func get_adjacent_room_coords(coords_array):
	var adjacent_coords = []
	var coords_x = coords_array[0]
	var coords_y = coords_array[1]
	if coords_x > 0:
		adjacent_coords.append([coords_x - 1, coords_y])
	if coords_x < ROOM_SLOTS_IN_WORLD - 1:
		adjacent_coords.append([coords_x + 1, coords_y])
	if coords_y > 0:
		adjacent_coords.append([coords_x, coords_y - 1])
	if coords_y < ROOM_SLOTS_IN_WORLD - 1:
		adjacent_coords.append([coords_x, coords_y + 1])
	adjacent_coords.shuffle()
	return adjacent_coords
	
func get_random_room_coords(coords_array):
	return coords_array[rng.randi_range(0, coords_array.size() - 1)]
	
func generate_random_room(tiles, map_x, map_y):
	# get possible rooms based on room layout data
	var image_size = rooms_layouts_data.get_size()
	var num_rooms_x = image_size.x / ROOM_SIZE_TILES
	var num_rooms_y = image_size.y / ROOM_SIZE_TILES
	# choose a random room based on number of available rooms
	var chosen_x = rng.randi_range(0, num_rooms_x - 1)
	var chosen_y = rng.randi_range(0, num_rooms_y - 1)
	# use the chosen values to get the starting position of the room in the image
	var start_x = chosen_x * ROOM_SIZE_TILES
	var start_y = chosen_y * ROOM_SIZE_TILES
	# loop through each pixel of the room
	for x in range(ROOM_SIZE_TILES):
		for y in range(ROOM_SIZE_TILES):
			rooms_layouts_data.lock()
			var pixel = rooms_layouts_data.get_pixel(start_x + x, start_y + y)
			# if the pixel is back, set the tile to a WallTile
			var new_tile = Tile.new(map_x + x, map_y + y)
			match pixel:
				Color.black:
					new_tile = WallTile.new(map_x + x, map_y + y)
				Color.white:
					new_tile = FloorTile.new(map_x + x, map_y + y)
			tiles[map_x + x][map_y + y] = new_tile
	return tiles

func get_direction_from_coord_to_coord(from_coord, to_coord):
	var from_coord_x = from_coord[0]
	var from_coord_y = from_coord[1]
	var to_coord_x = to_coord[0]
	var to_coord_y = to_coord[1]
	if to_coord_x > from_coord_x:
		return "right"
	elif to_coord_x < from_coord_x:
		return "left"
	elif to_coord_y > from_coord_y:
		return "down"
	elif to_coord_y < from_coord_y:
		return "up"
		

func fill_wall_direction(tiles, room_coord, direction):
	var room_coord_x = room_coord[0]
	var room_coord_y = room_coord[1]
	var map_x = room_coord_x * ROOM_SIZE_TILES
	var map_y = room_coord_y * ROOM_SIZE_TILES
	if direction == "up":
		for tile_x in range(map_x, map_x + ROOM_SIZE_TILES):
			tiles[tile_x][map_y] = WallTile.new(tile_x, map_y)
	if direction == "down":
		for tile_x in range(map_x, map_x + ROOM_SIZE_TILES):
			tiles[tile_x][map_y + ROOM_SIZE_TILES - 1] = WallTile.new(tile_x, map_y + ROOM_SIZE_TILES - 1)
	if direction == "left":
		for tile_y in range(map_y, map_y + ROOM_SIZE_TILES):
			tiles[map_x][tile_y] = WallTile.new(map_x, tile_y)
	if direction == "right":
		for tile_y in range(map_y, map_y + ROOM_SIZE_TILES):
			tiles[map_x + ROOM_SIZE_TILES - 1][tile_y] = WallTile.new(map_x + ROOM_SIZE_TILES - 1, tile_y)
	return tiles
