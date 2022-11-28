extends Node2D

onready var tilemap := $WorldTileMap

func _ready():
	
	# create a simple 2d array to hold our initial map of tiles 
	var tiles = generate_world()
	set_tilemap_cells(tiles)
	
func generate_world():
	var tiles = []
	# fill space with empty tiles
	for i in 45:
		tiles.append([])
		for j in 25:
			tiles[i].append(Tile.new(i, j))
	
	# replace the tiles we want with new ones
	var start_x = 20
	var start_y = 10
	for i in range(start_x, 10 + start_x):
		for j in range(start_y, 10 + start_y):
			if j%2 == 0:
				tiles[i][j] = WallTile.new(i, j)
			else:
				tiles[i][j] = FloorTile.new(i, j)
	return tiles	
		
func set_tilemap_cells(tiles) -> void:
	tilemap.clear()
	for tile_row in tiles:
		for tile in tile_row:
			var tile_type_int = tilemap.tile_type[tile.tile_type]
			tilemap.set_cell(tile.x, tile.y, tile_type_int)
