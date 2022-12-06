extends Node2D

onready var tilemap := $WorldTileMap
onready var hero := $Hero

const WORLD_SIZE_X = 50
const WORLD_SIZE_Y = 50
const TILE_SIZE = 24

var tiles

func _ready():
	tiles = generate_tiles_array(WORLD_SIZE_X, WORLD_SIZE_Y)
	var dungeonGenerator = DungeonGenerator.new(tiles)
	var dungeonData = dungeonGenerator.generate_dungeon()
	tiles = dungeonData.tiles
	var spawn_coords = dungeonData.spawn_coordinates
	set_tilemap_cells(tiles)
	
	# set hero starting coords
	hero.set_tile_coords(spawn_coords)
	
	# create a couple enemies
	var enemy_scene = load("res://scenes/Enemy.tscn")
	for i in 3:
		var enemy: Enemy = enemy_scene.instance()
		var new_coords = spawn_coords
		new_coords[1] += 3*i + 1
		enemy.set_tile_coords(new_coords)
		add_child(enemy)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		try_move(hero, [0, -1])
	if Input.is_action_just_pressed("ui_down"):
		try_move(hero, [0, 1])
	if Input.is_action_just_pressed("ui_left"):
		try_move(hero, [-1, 0])
	if Input.is_action_just_pressed("ui_right"):
		try_move(hero, [1, 0])
	
func generate_tiles_array(x_size, y_size):
	var array = []
	for i in x_size:
		array.append([])
		for j in y_size:
			array[i].append(Tile.new(i, j))
	return array	
		
func set_tilemap_cells(tiles) -> void:
	tilemap.clear()
	for tile_row in tiles:
		for tile in tile_row:
			var tile_type_int = tilemap.tile_type[tile.tile_type]
			tilemap.set_cell(tile.x, tile.y, tile_type_int)
	
func try_move(actor, delta_array):
	var new_tile_x = actor.tile_x + delta_array[0]
	var new_tile_y = actor.tile_y + delta_array[1]
	var destination_tile = tiles[new_tile_x][new_tile_y]
	if destination_tile.get_is_walkable():
		actor.move(delta_array)
	
