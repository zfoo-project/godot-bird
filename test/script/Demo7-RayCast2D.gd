extends Sprite2D


# How fast the player will move (pixels/sec).
var speed = 400

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() <= 0:
		return
	
	velocity = velocity.normalized() * speed
	position += velocity * delta

func _physics_process(delta):
	var rayCast2D: RayCast2D = $RayCast2D
	if rayCast2D.is_colliding():
		print(rayCast2D.get_collider())
