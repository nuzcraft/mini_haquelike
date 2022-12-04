extends Node2D

class_name Hero

onready var animatedSprite := $AnimatedSprite

var tile_x: int = 0 setget set_tile_x, get_tile_x
var tile_y: int = 0 setget set_tile_y, get_tile_y

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
	
func set_tile_coords(param_array):
	self.tile_x = param_array[0]
	self.tile_y = param_array[1]
	
func move(delta_array):
	self.tile_x += delta_array[0]
	self.tile_y += delta_array[1]
	if delta_array[0] > 0:
		animatedSprite.flip_h = true
	elif delta_array[0] < 0:
		animatedSprite.flip_h = false
