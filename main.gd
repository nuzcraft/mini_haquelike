extends Node2D

onready var tilemap := $WorldTileMap
onready var stage := $Stage
onready var hero := $Stage/Hero

const TILE_SIZE = 24

var ascii:bool = false
const ascii_tileset = preload("res://tilesets/AsciiTileSet.tres")
var tileset = null

var turn_taken = false

var enemy_scene = preload("res://scenes/Enemy.tscn")

func _ready():	
	toggle_ascii(ascii)
	
	var dungeonGenerator = DungeonGenerator.new(stage.map, 5, 3)
	var dungeonData = dungeonGenerator.generate_dungeon()
	stage.map = dungeonData.map
	var spawn_coords = dungeonData.spawn_coordinates
	stage.map.compute_astar()
	
	set_tilemap_cells()
	
	# set hero starting coords
	stage.hero = hero
	hero.set_tile_location(spawn_coords)
	
	# create a couple enemies	
	var enemy_spawn_coords = dungeonData.enemy_spawn_coordinates
#	enemy_spawn_coords = [[6, 6]]
	for coord in enemy_spawn_coords:
		stage.add_actor(Enemy, coord)
	
func _process(_delta):	
	if Input.is_action_just_pressed("ui_up"):
		try_move(hero, Vector2(0, -1))
	if Input.is_action_just_pressed("ui_down"):
		try_move(hero, Vector2(0, 1))
	if Input.is_action_just_pressed("ui_left"):
		try_move(hero, Vector2(-1, 0))
	if Input.is_action_just_pressed("ui_right"):
		try_move(hero, Vector2(1, 0))
	if Input.is_action_just_pressed("toggle_ascii"):
		ascii = !ascii
		toggle_ascii(ascii)
		
	if turn_taken:
		stage.map.compute_astar()
		for actor in get_tree().get_nodes_in_group("actors"):
			if actor != hero:
#				var path = actor.get_path_to_target(hero.get_position_vector())
				var actor_index = stage.map.astar.get_closest_point(actor.get_tile_location())
				var hero_index = stage.map.astar.get_closest_point(hero.get_tile_location())
				actor.path = stage.map.astar.get_point_path(actor_index, hero_index)
				if actor.get_next_move():
					try_move(actor, actor.get_next_move())
				
	
	turn_taken = false
	
func generate_tiles_array(x_size, y_size):
	var array = []
	for i in x_size:
		array.append([])
		for j in y_size:
			array[i].append(Tile.new(i, j))
	return array	
			
func set_tilemap_cells() -> void:
	tilemap.clear()
	var tiles = stage.map.get_tiles()
	for coord in tiles.keys():
		var tile = tiles[coord]
		var tile_type_int = tilemap.tile_type[tile.tile_type]
		tilemap.set_cell(coord.x, coord.y, tile_type_int)
	
func try_move(actor, delta: Vector2):
	if delta:
		var new_location = actor.get_tile_location() + delta
		var destination_tile = stage.map.get_tile(new_location)
		if destination_tile.get_is_walkable():
			actor.move(delta)
			if actor == hero:
				turn_taken = true
				
func toggle_ascii(is_ascii):
	if is_ascii:
		tileset = tilemap.get_tileset()
		tilemap.set_tileset(ascii_tileset)
	else:
		if not tileset == null:
			tilemap.set_tileset(tileset)
	hero.toggle_ascii(is_ascii)
	stage.toggle_ascii(is_ascii)
		
