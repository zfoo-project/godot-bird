extends Node2D


@onready var camera2d: Camera2D = $Camera2d
@onready var bird: RigidBody2D = $Bird

@onready var lands: Node2D = $Lands
@onready var pipes: Node2D = $Pipes

signal end_game(point: int)

var pipeInterval: int = 150
var pipeCount: int = 3

func _ready():
	# 以当前小鸟的位置，每隔pipeInterval间距生成水管
	for i in range(30):
		createPipe()
	pass

func _process(delta):
	# 移动相机
	camera2d.position.x = bird.position.x - 90
	# 移动多少个屏幕背景
	var count = int(bird.position.x) / 1152
	lands.position.x = count * 1152
	# 血量小于0则结束游戏
	if (bird.hp <= 0):
		emit_signal("end_game", bird.point)
	pass


func createPipe():
	var createPositionX = pipeCount * pipeInterval
	var createPositionY = randf_range(80, 320)
	
	var pipeResource = preload("res://scene/Pipe.tscn")
	var newPipe = pipeResource.instantiate()
	newPipe.position.x = createPositionX
	newPipe.position.y = createPositionY
	newPipe.name = String.num_int64(pipeCount)
	pipes.add_child(newPipe)
	
	newPipe.get_node("VisibleOnScreenNotifier2d").screen_exited.connect(onPipeScreenExited.bind(newPipe))
	newPipe.get_node("Coin").connect("body_entered", Callable(self, "onBirdEntered"))
	#newPipe.get_node("Coin").body_entered.connect(onBirdEntered)
	
	pipeCount = pipeCount + 1
	pass

func onPipeScreenExited(exitedPipe: Node2D):
	exitedPipe.queue_free()
	createPipe()
	pass
	
func onBirdEntered(other_body):
	if (other_body == bird):
		$Bird/point.play()
		bird.point = bird.point + 1
	pass
