extends Node2D

const RandomUtils = preload("res://zfoo/RandomUtils.gd")
const StringUtils = preload("res://zfoo/StringUtils.gd")
const Common = preload("res://script/Common.gd")
const GodotObjectResource = preload("res://storage/GodotObjectResource.gd")
const BattleResultRequest = preload("res://protocol/protocol/battle/BattleResultRequest.gd")

@onready var camera2d: Camera2D = $Camera2d
@onready var bird: RigidBody2D = $Bird

@onready var lands: Node2D = $Lands
@onready var pipes: Node2D = $Pipes
@onready var hpAnimatedSprite2D: AnimatedSprite2D = $UI/HP/AnimatedSprite2d
@onready var birdSpeedUpEffect: GPUParticles2D = $BirdSpeedUpEffect


var objectResources: Dictionary = Main.resourceStorage.objectResources

var pipeInterval: int = 170
var pipeCount: int = 4
var isOver: bool = false

# 游戏开始的总时间
var gameTotalTime: float = 0
var godotResourcesTimerMap: Dictionary = {}


func _ready():
	$ParallaxBackground/ParallaxLayer/Background.texture = Main.currentBackground
	bird.hpChangedEvent.connect(onHpChangedEvent)
	bird.attackEvent.connect(onAttackEvent)
	changeHp(bird.hp)
	# 以当前小鸟的位置，每隔pipeInterval间距生成水管
	for i in range(20):
		createPipe()
	
	$Timer.timeout.connect(onTimeout)
	for key in objectResources.keys():
		godotResourcesTimerMap[key] = objectResources[key].refreshTime
	pass

func changeHp(hp: int):
	$UI/HP/HP.text = String.num_int64(bird.hp)
	hpAnimatedSprite2D.play()
	pass

func _process(delta):
	gameTotalTime += delta
	# 移动相机
	camera2d.position.x = bird.position.x - bird.cameraOffset
	# 移动特效
	birdSpeedUpEffect.position = bird.position
	birdSpeedUpEffect.emitting = bird.isSpeedUp
	# 移动多少个屏幕背景
	var count = int(bird.position.x) / 1152
	lands.position.x = count * 1152
	# 血量小于0则结束游戏
	if (!isOver && bird.hp <= 0):
		endGame()
	if (hpAnimatedSprite2D.frame == 3):
		hpAnimatedSprite2D.frame = 0
		hpAnimatedSprite2D.stop()
	pass

func endGame():
	isOver = true
	Main.point = bird.point
	Main.changeScene(Main.SCENE.Over)
	# 游戏结束，给服务器发消息，一个水管算10分
	var request = BattleResultRequest.new()
	request.score = bird.point * 5
	Main.tcpClient.send(request)
	pass

func createPipe():
	var createPositionX = pipeCount * pipeInterval
	var createPositionY = randf_range(Common.pipeRandomDown(), Common.pipeRandomUp())
	
	var pipeResource = preload("res://scene/Pipe.tscn")
	var newPipe = pipeResource.instantiate()
	newPipe.position.x = createPositionX
	newPipe.position.y = createPositionY
	newPipe.name = String.num_int64(pipeCount)
	# 每隔10个水管，更换一下水管的颜色
	if (pipeCount / 10 % 2 == 1):
		newPipe.get_node("Up/Sprite2d").texture = preload("res://image/pipe2_up.png")
		newPipe.get_node("Down/Sprite2d").texture = preload("res://image/pipe2_down.png")
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

# 进入水管加分
func onBirdEntered(other_body):
	if (other_body == bird):
		$Bird/point.play()
		bird.point = bird.point + 1
	pass
	

func onHpChangedEvent(oldHp: int, hp: int):
	if (oldHp >  hp):
		var effectHit = preload("res://scene/effect/EffectHit.tscn").instantiate()
		effectHit.position = bird.position
		add_child(effectHit)
		changeHp(bird.hp)
	pass


func onAttackEvent(other_body):
	var effectAttack = preload("res://scene/effect/EffectAttack.tscn").instantiate()
	effectAttack.position = bird.position
	add_child(effectAttack)
	other_body.queue_free()
	pass

	
# 吃血包加血量
func onHpItemEntered(node: Node2D, other_body):
	if (other_body == bird):
		$Bird/hp.play()
		bird.hp = bird.hp + 1
		changeHp(bird.hp)
		node.queue_free()
	pass

func onSpeedUpItemEntered(node: Node2D, other_body):
	if (other_body == bird):
		$Bird/speedup_end.play()
		bird.speedUp()
		node.queue_free()
	pass

func onTimeout():
	for key in godotResourcesTimerMap.keys():
		var refreshTime: float = godotResourcesTimerMap[key]
		if refreshTime > gameTotalTime:
			continue
		# 生成物体
		var objectResource: GodotObjectResource = objectResources[key]
		var obj = load(objectResource.path).instantiate()
		var createPositionY = randf_range(objectResource.randomUpY, objectResource.randomDownY)
		obj.position.x = bird.position.x + objectResource.forwardX
		obj.position.y = createPositionY
		# 调整血包何加速包的x位置，让他们不和水管叠加
		if (objectResource.id == 1 || objectResource.id == 2):
			obj.position.x = pipeCount * pipeInterval - pipeInterval / 2
		add_child(obj)
		if StringUtils.isNotEmpty(objectResource.signalBind):
			obj.connect(objectResource.signalBind, Callable(self, objectResource.callback))
		# 计算下一次的生成时间
		var nextTime = objectResource.refreshTime - objectResource.refreshAccelerate * (gameTotalTime / Common.gameMaxTimeSeconds())
		nextTime = max(nextTime, objectResource.refreshMinTime)
		var nextRefreshTime: float = gameTotalTime + nextTime
		godotResourcesTimerMap[key] = nextRefreshTime
	pass
