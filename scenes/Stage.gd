extends Node

class_name Stage

var map = Map.new()
var actors = []
var hero: Hero

var actor_scene_dict = {
	Enemy: preload("res://scenes/Enemy.tscn")
}

func add_actor(actor_class, location: Vector2):
	var actor = actor_scene_dict[actor_class].instance()
	actor.set_tile_location(location)
	add_child(actor)	
	actors.append(actor)
	
func toggle_ascii(is_ascii):
	for actor in actors:
		actor.toggle_ascii(is_ascii)

