extends Node2D

class_name Actor

onready var animatedSprite := $AnimatedSprite

var ascii: bool = false
var spriteFrames = null
var asciiSpriteFrames = preload("res://scenes/ActorAsciiSpriteFrames.tres")

var tile_location: Vector2 = Vector2(0, 0) setget set_tile_location, get_tile_location
var path = []

const TILE_SIZE = 24

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_tile_location(location: Vector2):
	tile_location = location
	position.x = location.x * TILE_SIZE
	position.y = location.y * TILE_SIZE
	
func get_tile_location():
	return tile_location
	
func move(delta: Vector2):
	self.tile_location += delta
	if ascii:
		animatedSprite.flip_h = false
	else:
		if delta.x > 0:
			animatedSprite.flip_h = true
		elif delta.x < 0:
			animatedSprite.flip_h = false
		
func get_next_move():
	if path.size() > 1:
		var move_vector = path[1] - get_tile_location()
		if not move_vector == null:
			return move_vector
			
func toggle_ascii(is_ascii):
	ascii = is_ascii
	if ascii:
		spriteFrames = animatedSprite.get_sprite_frames()
		animatedSprite.set_sprite_frames(asciiSpriteFrames)
		animatedSprite.flip_h = false
	else:
		if !spriteFrames == null:
			animatedSprite.set_sprite_frames(spriteFrames)
	
