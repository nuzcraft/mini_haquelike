class_name AStarGenerator

var tiles = []

func _init(input_tiles):
	tiles = input_tiles

func generate_astar():
	var astar = AStar2D.new()
