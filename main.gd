extends Node2D

onready var tilemap := $WorldTileMap

const WORLD_SIZE_X = 45
const WORLD_SIZE_Y = 25

func _ready():
	# create a simple 2d array to hold our initial map of tiles 
	var tiles = generate_empty_world(WORLD_SIZE_X, WORLD_SIZE_Y)
	var dungeonGenerator = DungeonGenerator.new(tiles)
	tiles = dungeonGenerator.generate_dungeon()
	set_tilemap_cells(tiles)
	
func generate_empty_world(x_size, y_size):
	var tiles = []
	# fill space with empty tiles
	for i in x_size:
		tiles.append([])
		for j in y_size:
			tiles[i].append(null)
	return tiles	
		
func set_tilemap_cells(tiles) -> void:
	tilemap.clear()
	for tile_row in tiles:
		for tile in tile_row:
			var tile_type_int = tilemap.tile_type[tile.tile_type]
			tilemap.set_cell(tile.x, tile.y, tile_type_int)
	

