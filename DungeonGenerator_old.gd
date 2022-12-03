const ROOM_SIZE = 9
const ROOM_SLOTS_IN_WORLD = 7

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
	tiles = create_rect_in_2d_array(tiles, 0, 0, num_tiles_x, num_tiles_y, Tile)
	var rooms = generate_empty_2d_array(ROOM_SLOTS_IN_WORLD, ROOM_SLOTS_IN_WORLD)
	# choose a random room to start
	var first_room_coords_array = get_not_null_random_coords_in_2d_array(rooms)

	###
	# start with an 2d array of room slots
	# pick one of the slots as the first room
	# find available adjacent slots, pick one, add to list of rooms
	# repeat x times to create the happy path of the dungeon
	# store the happy path somewhere
	# choose a random room
	# find available adjacent slots, pick one, add to list of rooms
	# repeat x times for branching paths
	###
	# now we have the map we need to build
	###
	# go through each room, and assign it a room layout
	# export room layout info to tiles (a 2d array)
	# fill in the outer walls
	# fill in spaces between 2 happy path rooms with wall tiles
	# return tiles array
	###
	
#	tiles = generate_random_room(tiles, 11, 1)
#	tiles = generate_random_room(tiles, 20, 1)
#	tiles = generate_random_room(tiles, 11, 10)
#	tiles = generate_random_room(tiles, 20, 10)
	return tiles

func generate_empty_2d_array(x_size, y_size):
	var array = []
	# fill space with empty tiles
	for i in x_size:
		array.append([])
		for j in y_size:
			array[i].append(null)
	return array

func create_rect_in_2d_array(array, start_x, start_y, width, height, tile):
	for i in range(start_x, start_x + width):
		for j in range(start_y, start_y + height):
			array[i][j] = tile.new(i, j)
	return array
	
func create_room_in_2d_array(array, start_x, start_y, width, height):
	array = create_rect_in_2d_array(array, start_x, start_y, width, height, WallTile)
	array = create_rect_in_2d_array(array, start_x + 1, start_y + 1, width - 2, height - 2, FloorTile)
	return array
	
func generate_random_room(tiles, map_x, map_y):
	# get possible rooms based on room layout data
	var image_size = rooms_layouts_data.get_size()
	var num_rooms_x = image_size.x / ROOM_SIZE
	var num_rooms_y = image_size.y / ROOM_SIZE
	# choose a random room based on number of available rooms
	var chosen_x = rng.randi_range(0, num_rooms_x - 1)
	var chosen_y = rng.randi_range(0, num_rooms_y - 1)
	# use the chosen values to get the starting position of the room in the image
	var start_x = chosen_x * ROOM_SIZE
	var start_y = chosen_y * ROOM_SIZE
	# loop through each pixel of the room
	for x in range(ROOM_SIZE):
		for y in range(ROOM_SIZE):
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
	
func get_random_coords_in_2d_array(array):
	var x_length = array.size()
	var y_length = array[0].size()
	
	var rand_x = rng.randi_range(0, x_length)
	var rand_y = rng.randi_range(0, y_length)
	return [rand_x, rand_y]
	
func get_not_null_random_coords_in_2d_array(array):
	var result = null
	while not result:
		result = get_random_coords_in_2d_array(array)
	return result
	
func get_adjacent_coord_arrays(coord_array, array):
	var coord_x = coord_array[0]
	var coord_y = coord_array[1]
	var adjacent_coord_arrays = []
	
	if coord_x + 1 < array.size():
		adjacent_coord_arrays.append([coord_x + 1, coord_y])
	if coord_x > 0:
		adjacent_coord_arrays.append([coord_x - 1, coord_y])
	if coord_y + 1 < array[0].size():
		adjacent_coord_arrays.append([coord_x, coord_y + 1])
	if coord_y > 0:
		adjacent_coord_arrays.append([coord_x, coord_y - 1])
	
	return adjacent_coord_arrays
		
