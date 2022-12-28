tool
extends TileSet

const WALL = 0
const EXPLORED_WALL = 3

var binds = {
	WALL: [EXPLORED_WALL],
	EXPLORED_WALL: [WALL]
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
