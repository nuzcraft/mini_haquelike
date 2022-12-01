class_name DungeonGenerator

const ROOM_SIZE = 9

var rooms_layouts_data = preload("res://resources/room_layouts.png").get_data()

var tiles = []
var num_tiles_x = 0
var num_tiles_y = 0

var rng = RandomNumberGenerator.new()

func _init(input_tiles):
	tiles = input_tiles
	num_tiles_x = tiles.size()
	num_tiles_y = tiles[0].size()

func generate_dungeon():
	rng.randomize()
	tiles = create_rect_in_2d_array(tiles, 0, 0, num_tiles_x, num_tiles_y, Tile)
	tiles = generate_random_room(tiles, 11, 1)
	tiles = generate_random_room(tiles, 20, 1)
	tiles = generate_random_room(tiles, 11, 10)
	tiles = generate_random_room(tiles, 20, 10)
	return tiles

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