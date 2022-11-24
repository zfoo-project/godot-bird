extends Node2D

@onready var line2D: Line2D = $Line2D
@onready var tilemap = $TileMap
@onready var player: CharacterBody2D = $Player

var speed : = 400
var path : = PackedVector2Array()


func _physics_process(delta: float) -> void:
	if path.is_empty():
		return
	var move_distance = speed * delta
	move_along_path(move_distance)
	player.move_and_slide()


func move_along_path(distance : float) -> void:
	for index in range(path.size()):
		var distance_to_next = player.position.distance_to(path[0])
		
		player.velocity = (path[0] - player.position).normalized() * speed
		if distance <= distance_to_next:
			break
		
		path.remove_at(0)
		pass


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
		
	var playerPosition = player.global_position
	var mousePosition = event.global_position
	var startCellPosition = tilemap.local_to_map(playerPosition)
	var endCellPosition = tilemap.local_to_map(mousePosition)
	var navPath = tilemap.get_nav_path(startCellPosition, endCellPosition)
	line2D.points = navPath
	path = navPath

