extends CharacterBody2D

#基本逻辑在于利用ray.首先利用点乘舍弃与移动方向相反的ray.然后舍弃碰撞到碰撞体的ray.
#最后利用剩下的ray进行移动方向的改变.
#参考了https://www.youtube.com/watch?v=dzqtF_CmX-I这个视频.进行了一点改动.

@onready var Navga:NavigationAgent2D=$NavigationAgent2D
const speed = 300
var scope=60#射线长度/范围

var ray_direction=[]
var ray_true=[]
var ray_false=[]
var ray_angle
var dir=Vector2.ZERO
var velo=Vector2.ZERO

func _ready():
	ray_true.resize(8)
	ray_false.resize(8)
	ray_direction.resize(8)
	for i in 8:
		ray_angle=i*2*PI/8
		ray_direction[i]=Vector2.RIGHT.rotated(ray_angle)
		#print(i,'R',ray_direction[i])
		
func _physics_process(delta):
	#只有在发出寻路指令时才进行ray的判断
	set_ray_true()
	set_ray_false()
	set_direction()
	var desired_velocity=dir*speed
	velo=velo.lerp(desired_velocity,0.05)
	velocity=velo
	move_and_slide()
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Navga.set_target_location(event.position)
		
# 判定ray的方向是否与行进方向一致,负方向的ray将被舍弃(标记为0)
func set_ray_true():
	for i in 8:
		var aaa=ray_direction[i].dot((Navga.get_next_location()-self.position).normalized())
		#print('NEXT',Navga.get_next_location().normalized())
		ray_true[i]=0 if 0>aaa else aaa
		#print(i,'   ',ray_true[i])
			
# 判断ray是否碰撞到碰撞体,碰撞到碰撞体则舍弃(标记为0)	
func set_ray_false():
	var ray=get_world_2d().direct_space_state
	for i in 8:
		var ray_para = PhysicsRayQueryParameters2D.create(position,position+ray_direction[i].rotated(rotation)*scope,0xFFFFFFFF,[self.get_rid()])
		var bbb=ray.intersect_ray(ray_para)	
		ray_false[i]=1 if bbb else 0
	
#使用未被舍弃的ray进行更改路径的处理.
func set_direction():
	#舍去方向相反的ray
	for i in 8:
		if ray_false[i]>0:
			ray_true[i]=0
	dir=Vector2.ZERO
	#得到最终的经过ray计算修改的下一个点的方向
	for i in 8:
		dir+=ray_direction[i]*ray_true[i]
	dir=dir.normalized()
	
