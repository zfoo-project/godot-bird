extends TileMap

# You can only create an AStar node from code, not from the Scene tab.
@onready var astar_node: AStar2D = AStar2D.new()

var map_size: Vector2i = get_used_rect().size

func _ready():
	# 遍历所有层，将可以寻路的tile加入Astar图的节点中
	for layer in range(get_layers_count()):
		var cells = get_used_cells(layer)
		for cell in cells:
			var tileData = get_cell_tile_data(layer, cell)
			var nav = tileData.get_navigation_polygon(0)
			if nav == null:
				continue
			var point_index = calculate_point_index(cell)
			astar_node.add_point(point_index, Vector2(cell.x, cell.y))
	
	# 移除有碰撞体的点
	for layer in range(get_layers_count()):
		var cells = get_used_cells(layer)
		for cell in cells:
			var tileData = get_cell_tile_data(layer, cell)
			var collision = tileData.get_collision_polygons_count(0)
			if collision <= 0:
				continue
			var point_index = calculate_point_index(cell)
			if astar_node.has_point(point_index):
				astar_node.remove_point(point_index)
	
	# 连接图的节点
	for id in astar_node.get_point_ids():
		var cellPosition = Vector2i(astar_node.get_point_position(id))
		var relativeCells: Array[Vector2i] = [
			cellPosition + Vector2i.RIGHT,
			cellPosition + Vector2i.LEFT,
			cellPosition + Vector2i.DOWN,
			cellPosition + Vector2i.UP,
		]
		for relativeCell in relativeCells:
			var relativeCellIndex = calculate_point_index(relativeCell)
			if is_outside_map_bounds(relativeCell):
				continue
			if astar_node.has_point(relativeCellIndex):
				astar_node.connect_points(id, relativeCellIndex, false)

func calculate_point_index(point: Vector2i) -> int:
	return point.x + point.y * map_size.x

func is_outside_map_bounds(point: Vector2i) -> bool:
	return point.x < 0 || point.y < 0 || point.x >= map_size.x || point.y >= map_size.y

func get_nav_path(startCellPosition: Vector2i, endCellPosition: Vector2i) -> PackedVector2Array:
	var navCellPath = astar_node.get_point_path(calculate_point_index(startCellPosition), calculate_point_index(endCellPosition))
	var localPath = PackedVector2Array()
	for cellPosition in navCellPath:
		localPath.push_back(map_to_local(Vector2i(cellPosition)))
	return localPath
