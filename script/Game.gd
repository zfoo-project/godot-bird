extends Node2D

const RandomUtils = preload("res://zfoo/RandomUtils.gd")
const StringUtils = preload("res://zfoo/StringUtils.gd")
const Common = preload("res://script/Common.gd")
const GodotObjectResource = preload("res://storage/GodotObjectResource.gd")

@onready var camera2d: Camera2D = $Camera2d
@onready var bird: RigidBody2D = $Bird

@onready var lands: Node2D = $Lands
@onready var pipes: Node2D = $Pipes
@onready var hpAnimatedSprite2D: AnimatedSprite2D = $UI/HP/AnimatedSprite2d
@onready var birdSpeedUpEffect: GPUParticles2D = $BirdSpeedUpEffect


var objectResources: Dictionary = Main.resourceStorage.objectResources

var pipeInterval: int = 150
var pipeCount: int = 3
var isOver: bool = false

# 游戏开始的总时间
var gameTotalTime: float = 0
var godotResourcesTimerMap: Dictionary = {}

const enemies: Array[PackedScene] = [
	preload("res://scene/enemy/Fish.tscn"), 
	preload("res://scene/enemy/Shark.tscn"), 
	preload("res://scene/enemy/Cloud.tscn")
	]

func _ready():
	$ParallaxBackground/ParallaxLayer/Background.texture = Main.currentBackground
	bird.hpChangedEvent.connect(onHpChangedEvent)
	$Enemies/Timer.timeout.connect(onEnemiesTimeout)
	$HpItem/Timer.timeout.connect(onHpItemTimeout)
	$SpeedUpItem/Timer.timeout.connect(onSpeedUpItemTimeout)
	changeHp(bird.hp)
	# 以当前小鸟的位置，每隔pipeInterval间距生成水管
	for i in range(30):
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
	pass

func createPipe():
	var createPositionX = pipeCount * pipeInterval
	var createPositionY = randf_range(80, 320)
	
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


func onEnemiesTimeout():
	var enemy = RandomUtils.randomEle(enemies).instantiate()
	var createPositionY = randf_range(50, 450)
	enemy.position.x = bird.position.x + 1000
	enemy.position.y = createPositionY
	add_child(enemy)
	pass

func onHpItemTimeout():
	var hp = preload("res://scene/effect/EffectHp.tscn").instantiate()
	var createPositionY = randf_range(100, 300)
	hp.position.x = bird.position.x + 1500
	hp.position.y = createPositionY
	add_child(hp)
	hp.addHpSignal.connect(onHpItemEntered)
	pass

func onSpeedUpItemTimeout():
	var speedUp = preload("res://scene/effect/EffectSpeedUp.tscn").instantiate()
	var createPositionY = randf_range(100, 300)
	speedUp.position.x = bird.position.x + 1500
	speedUp.position.y = createPositionY
	add_child(speedUp)
	speedUp.speedUpSignal.connect(onSpeedUpItemEntered)
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
		if godotResourcesTimerMap[key] < gameTotalTime:
			continue
		# 生成物体
		var objectResource: GodotObjectResource = objectResources[key]
		var obj = load(objectResource.path).instantiate()
		var createPositionY = randf_range(objectResource.randomUpY, objectResource.randomDownY)
		obj.position.x = bird.position.x + objectResource.forwardX
		obj.position.y = createPositionY
		add_child(obj)
		if StringUtils.isNotEmpty(objectResource.signalBind):
			obj.connect(objectResource.signalBind, Callable(self, objectResource.callback))
		# 计算下一次的生成时间
		var nextTime = objectResource.refreshTime - objectResource.refreshAccelerate * (gameTotalTime / Common.gameMaxTimeSeconds())
		nextTime = max(nextTime, Common.objectCreateMinTimeSeconds())
		var nextRefreshTime: float = gameTotalTime + nextTime
		godotResourcesTimerMap[key] = nextRefreshTime
	pass
