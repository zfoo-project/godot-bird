extends Node2D


@onready var nav_2d : NavigationAgent2D = $Player/NavigationAgent2D
@onready var player : CharacterBody2D = $Player
@onready var line2D : Line2D = $Line2D

var speed = 400

func _physics_process(delta):
	if nav_2d.is_navigation_finished() || nav_2d.get_final_location() == Vector2.ZERO:
		return
	
	var target = nav_2d.get_next_location()
	var direction = (target - player.position).normalized() * speed
	
	player.velocity = direction
	nav_2d.set_velocity(direction)
	player.move_and_slide()
	line2D.points = nav_2d.get_nav_path()

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
		
	var playerPosition = player.global_position
	var mousePosition = event.global_position
	nav_2d.set_target_location(mousePosition)

