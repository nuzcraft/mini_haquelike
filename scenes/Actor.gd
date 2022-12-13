extends Node2D

class_name Actor

onready var animatedSprite := $AnimatedSprite

var tile_x: int = 0 setget set_tile_x, get_tile_x
var tile_y: int = 0 setget set_tile_y, get_tile_y
var path = []

const TILE_SIZE = 24

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_tile_x(x_param):
	tile_x = x_param
	position.x = x_param * TILE_SIZE
	
func get_tile_x():
	return tile_x
	
func set_tile_y(y_param):
	tile_y = y_param
	position.y = y_param * TILE_SIZE
	
func get_tile_y():
	return tile_y
	
func get_position_vector() -> Vector2:
	return Vector2(tile_x, tile_y)
	
func set_tile_coords(param_array):
	self.tile_x = param_array[0]
	self.tile_y = param_array[1]
	
func move(delta: Vector2):
	self.tile_x += delta.x
	self.tile_y += delta.y
	if delta.x > 0:
		animatedSprite.flip_h = true
	elif delta.x < 0:
		animatedSprite.flip_h = false
		
func get_next_move():
	if path.size() > 1:
		return path[1] - get_position_vector()
