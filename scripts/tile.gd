class_name Tile

var x: int setget ,get_x
var y: int setget, get_y
var is_explored: bool = false setget set_is_explored,get_is_explored
var is_walkable: bool = true setget set_is_walkable,get_is_walkable
var is_visible: bool = false setget set_is_visible,get_is_visible
var tile_type = "EMPTY"

func _init(x_param, y_param):
	x = x_param
	y = y_param

# setters and getters
func get_x():
	return x
	
func get_y():
	return y

func set_is_explored(value: bool):
	is_explored = value
	
func get_is_explored() -> bool:
	return is_explored
	
func set_is_walkable(value: bool):
	is_walkable = value
	
func get_is_walkable() -> bool:
	return is_walkable
	
func set_is_visible(value: bool):
	is_visible = value
	
func get_is_visible() -> bool:
	return is_visible
