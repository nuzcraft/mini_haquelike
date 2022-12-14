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
	
	set_tilemap_cells()
	
	stage.hero = hero
	hero.set_tile_location(spawn_coords)
	
	var enemy_spawn_coords = dungeonData.enemy_spawn_coordinates
	for coord in enemy_spawn_coords:
		stage.add_actor(Enemy, coord)
		
	stage.compute_astar()
	
func _process(_delta):	
	if Input.is_action_just_pressed("ui_up"):
		turn_taken = stage.try_move(hero, Vector2(0, -1))
	if Input.is_action_just_pressed("ui_down"):
		turn_taken = stage.try_move(hero, Vector2(0, 1))
	if Input.is_action_just_pressed("ui_left"):
		turn_taken = stage.try_move(hero, Vector2(-1, 0))
	if Input.is_action_just_pressed("ui_right"):
		turn_taken = stage.try_move(hero, Vector2(1, 0))
	if Input.is_action_just_pressed("toggle_ascii"):
		ascii = !ascii
		toggle_ascii(ascii)
		
	if turn_taken:
		stage.take_actors_turns()
				
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
				
func toggle_ascii(is_ascii):
	if is_ascii:
		tileset = tilemap.get_tileset()
		tilemap.set_tileset(ascii_tileset)
	else:
		if not tileset == null:
			tilemap.set_tileset(tileset)
	hero.toggle_ascii(is_ascii)
	stage.toggle_ascii(is_ascii)
		
