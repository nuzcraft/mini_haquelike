extends Node2D

class_name Actor

onready var animatedSprite := $AnimatedSprite
onready var target_sprite_position = animatedSprite.position

var ascii: bool = false
var spriteFrames = null
var asciiSpriteFrames = preload("res://scenes/ActorAsciiSpriteFrames.tres")

var tile_location: Vector2 = Vector2(0, 0) setget set_tile_location, get_tile_location
var path = []
var fov_range = 4

var animatedSprite_position_tween

const TILE_SIZE = 24

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
#func _process(delta):
#	animatedSprite.position = animatedSprite.position.move_toward(target_sprite_position, 120.0 * delta)
#	animatedSprite.position = move_toward(animatedSprite.position, target_sprite_position, 1.0) * delta

func set_tile_location(location: Vector2):
	tile_location = location
	position.x = location.x * TILE_SIZE
	position.y = location.y * TILE_SIZE
	
func set_sprite_position(delta: Vector2):
	animatedSprite.position -= delta * TILE_SIZE
	var tile_dist = (target_sprite_position - animatedSprite.position) / TILE_SIZE
	var tween_time = (abs(tile_dist.x) + abs(tile_dist.y)) * 0.25
	if animatedSprite_position_tween:
		animatedSprite_position_tween.kill()
	animatedSprite_position_tween = get_tree().create_tween()
	animatedSprite_position_tween.tween_property(animatedSprite, "position", target_sprite_position, tween_time)

	
func get_tile_location():
	return tile_location
	
func move(delta: Vector2):
	self.tile_location += delta
	set_sprite_position(delta)
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
	
