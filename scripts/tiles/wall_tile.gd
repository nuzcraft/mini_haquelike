extends Tile

class_name WallTile

func _init(x_param, y_param).(x_param, y_param):
	self.is_walkable = false
	self.tile_type = "WALL"
	self.explored_tile_type = "EXPLORED_WALL"
