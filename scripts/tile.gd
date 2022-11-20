class_name Tile

var isExplored: bool
var isWalkable: bool
var isVisible: bool

func _init(explored: bool = true, walkable: bool = true, visible: bool = true):
	isExplored = explored;
	isWalkable = walkable;
	isVisible = visible;
