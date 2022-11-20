extends Node2D

var tiles = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in 10:
		tiles.append([])
		for j in 10:
			tiles[i].append(Tile.new())
			
	print(tiles)
	print(tiles[0][9].isExplored)
	
