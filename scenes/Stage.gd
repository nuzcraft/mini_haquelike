extends Node

class_name Stage

var map = Map.new()
var astar = AStar2D.new()
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
		
func try_move(actor, delta: Vector2):
	if delta:
		var new_location = actor.get_tile_location() + delta
		var destination_tile = map.get_tile(new_location)
		if destination_tile.get_is_walkable():
			actor.move(delta)
			if actor == hero:
				return true
	return false

func compute_astar():
	astar.clear()
	var tiles = map.get_tiles()
	for vec in tiles.keys():
		# check if the vector is already a position in the astar map
		if not tiles[vec].get_is_walkable():
			continue
		var main_point = null
		for point in astar.get_points():
			if astar.get_point_position(point) == vec:
				main_point = point
		if main_point == null:
			main_point = astar.get_available_point_id()
			astar.add_point(main_point, vec)
		# let's do the same with adjacent tiles
		for adj_vec in map.get_adjacent_tiles(vec):
			if not tiles[adj_vec].get_is_walkable():
				continue
			var adj_point = null
			for point in astar.get_points():
				if astar.get_point_position(point) == adj_vec:
					adj_point = point
			if adj_point == null:
				adj_point = astar.get_available_point_id()
				astar.add_point(adj_point, adj_vec)
			astar.connect_points(main_point, adj_point)	
			
func take_actors_turns():
	compute_astar()
	for actor in actors:
		if actor != hero:
			var actor_index = astar.get_closest_point(actor.get_tile_location())
			var hero_index = astar.get_closest_point(hero.get_tile_location())
			actor.path = astar.get_point_path(actor_index, hero_index)
			if actor.get_next_move():
				try_move(actor, actor.get_next_move())
