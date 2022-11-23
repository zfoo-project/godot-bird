extends Node2D


@onready var nav_2d : NavigationAgent2D = $Player/NavigationAgent2D
@onready var player : CharacterBody2D = $Player
@onready var line2D : Line2D = $Line2D

var speed : = 400
var path : = PackedVector2Array()

var lastPosition: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if path.is_empty():
		return
	lastPosition = player.position
	var move_distance : = speed * delta
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
	nav_2d.set_target_location(mousePosition)
	nav_2d.get_next_location()
	var navPath = nav_2d.get_nav_path()
	line2D.points = navPath
	path = navPath

