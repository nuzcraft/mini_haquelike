extends Node2D

var tiles = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# create a simple 2d array to hold our initial map of tiles 
	for i in 10:
		tiles.append([])
		for j in 10:
			tiles[i].append(Tile.new())
			

