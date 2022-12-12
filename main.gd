extends Node2D

onready var tilemap := $WorldTileMap
onready var hero := $Hero

const TILE_SIZE = 24

var map = Map.new()
var turn_taken = false

var enemy_scene = preload("res://scenes/Enemy.tscn")

func _ready():	
	var dungeonGenerator = DungeonGenerator.new(map)
	var dungeonData = dungeonGenerator.generate_dungeon()
	map = dungeonData.map
	var spawn_coords = dungeonData.spawn_coordinates
#	map.compute_astar()

	map = Map.new()
	for i in range(10):
		for j in range(10):
			if i == 0:
				map.add_tile(i, j, WallTile)
			else:
				map.add_tile(i, j, FloorTile)
	spawn_coords = [2, 2]
	map.compute_astar()
	print(map.astar.get_points())
	print(map.astar.get_point_position(1))
	print(map.astar.get_point_position(66))
	print(map.astar.get_point_path(1, 66))
	
	set_tilemap_cells()
	
	# set hero starting coords
	hero.set_tile_coords(spawn_coords)
	
	# create a couple enemies	
	var enemy_spawn_coords = dungeonData.enemy_spawn_coordinates
	enemy_spawn_coords = [[6, 6]]
	for coord in enemy_spawn_coords:
		var enemy: Enemy = enemy_scene.instance()
		enemy.set_tile_coords(coord)
		add_child(enemy)
	
func _process(_delta):
	
	map.compute_astar()
	for actor in get_tree().get_nodes_in_group("actors"):
		actor.astar = map.astar
	
	if Input.is_action_just_pressed("ui_up"):
		try_move(hero, [0, -1])
	if Input.is_action_just_pressed("ui_down"):
		try_move(hero, [0, 1])
	if Input.is_action_just_pressed("ui_left"):
		try_move(hero, [-1, 0])
	if Input.is_action_just_pressed("ui_right"):
		try_move(hero, [1, 0])
		
	if turn_taken:
		for actor in get_tree().get_nodes_in_group("actors"):
			if actor != hero:
				var path = actor.get_path_to_target(hero.get_position_vector())
				print(actor.get_position_vector())
				print(path)
#				try_move(actor, actor.get_next_move())
				
	
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
	var tiles = map.get_tiles()
	for coord in tiles.keys():
		var tile = tiles[coord]
		var tile_type_int = tilemap.tile_type[tile.tile_type]
		tilemap.set_cell(coord.x, coord.y, tile_type_int)
	
func try_move(actor, delta_array):
	var new_tile_x = actor.tile_x + delta_array[0]
	var new_tile_y = actor.tile_y + delta_array[1]
	var destination_tile = map.get_tile(new_tile_x, new_tile_y)
	if destination_tile.get_is_walkable():
		actor.move(delta_array)
		if actor == hero:
			turn_taken = true
	
