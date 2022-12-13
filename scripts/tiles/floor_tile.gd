extends Tile

class_name FloorTile

func _init(x_param, y_param).(x_param, y_param):
	self.is_walkable = true
	self.tile_type = "FLOOR"
