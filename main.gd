extends Node2D

onready var tilemap := $WorldTileMap

func _ready():
	
	# create a simple 2d array to hold our initial map of tiles 
	var tiles = [];
	for i in 10:
		tiles.append([])
		for j in 10:
			if j%2 == 0:
				tiles[i].append(WallTile.new(i, j))
			else:
				tiles[i].append(FloorTile.new(i, j))
			
	generate_world(tiles)
	
func generate_world(tiles):
	tilemap.clear()
	for tile_row in tiles:
		for tile in tile_row:
			var tile_type_int = tilemap.tile_type[tile.tile_type]
			tilemap.set_cell(tile.x, tile.y, tile_type_int)
