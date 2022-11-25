extends CharacterBody2D

#基本逻辑在于利用ray.首先利用点乘舍弃与移动方向相反的ray.然后舍弃碰撞到碰撞体的ray.
#最后利用剩下的ray进行移动方向的改变.
#参考了https://www.youtube.com/watch?v=dzqtF_CmX-I这个视频.进行了一点改动.

@onready var nav_2d: NavigationAgent2D = $NavigationAgent2D
const speed = 300
var scope=400#射线长度/范围

var ray_direction=[]
var dir=Vector2.ZERO
var velo=Vector2.ZERO

func _ready():
	ray_direction.resize(8)
	for i in 8:
		var ray_angle=i*2*PI/8
		ray_direction[i]=Vector2.RIGHT.rotated(ray_angle)
		#print(i,'R',ray_direction[i])
		
func _physics_process(delta):
	if nav_2d.is_navigation_finished() || nav_2d.get_final_location() == Vector2.ZERO:
		return
	#只有在发出寻路指令时才进行ray的判断
	set_ray_true()
	var desired_velocity=dir*speed
	velo=velo.lerp(desired_velocity, 0.05)
	velocity=velo
	move_and_slide()
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		nav_2d.set_target_location(event.position)
		nav_2d.get_next_location()
		var navPath = nav_2d.get_nav_path()
		get_parent().get_node("Line2D").points = navPath
		
# 判定ray的方向是否与行进方向一致,负方向的ray将被舍弃(标记为0)
func set_ray_true():
	dir = Vector2.ZERO
	
	var next_position = nav_2d.get_next_location()
	var direct_space_state = get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.create(position, next_position, 0xFFFFFFFF, [self.get_rid()])
	var result = direct_space_state.intersect_ray(params)
	# 如果和目标点没有碰撞，直接返回，用当前位置到下一个点的位置当作方向
	if (result.is_empty()):
		dir = (next_position - position).normalized()
		return
	# 如果有碰撞，则8个方向中寻找一个没有发生碰撞并且不是相反方向的继续移动
	for i in 8:
		#舍去方向相反的ray
		var dotValue = ray_direction[i].dot(next_position - position)
		if dotValue < 0:
			continue
		# 判断ray是否碰撞到碰撞体，取第一个没有发生碰撞的方向射线
		var direction_params = PhysicsRayQueryParameters2D.create(position, position + ray_direction[i] * scope, 0xFFFFFFFF, [self.get_rid()])
		if (direct_space_state.intersect_ray(direction_params).is_empty()):
			dir = ray_direction[i].normalized()
			break
