extends Sprite2D


# How fast the player will move (pixels/sec).
var speed = 400

func _ready():
	print(get_parent().get_node("Pipe1/Up").get_rid())
	print(get_parent().get_node("Pipe2/Up").get_rid())

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
	rayTest2()
	pass


# 必须使用全局坐标才能检测
func rayTest1():
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var ray: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(Vector2(0, 0), Vector2(100, 0))
	var result = space_state.intersect_ray(ray)
	if !result.is_empty():
		print(result)
	pass
	
func rayTest2():
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var ray: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(to_global(Vector2(0, 0)), to_global(Vector2(100, 0)))
	# use global coordinates, not local to node
	var result: Dictionary = space_state.intersect_ray(ray)
	if !result.is_empty():
		print("------------------------------------------------------------")
		for key in result:
			print("key-------")
			print(key)
			print("value--------")
			print(result[key])
	pass
