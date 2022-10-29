extends Node

const FileUtils = preload("res://zfoo/FileUtils.gd")
const RandomUtils = preload("res://zfoo/RandomUtils.gd")
const ByteBufferStorage =preload("res://storage/ByteBuffer.gd")
const ProtocolManagerStorage = preload("res://storage/ProtocolManager.gd")
const ResourceStorage = preload("res://storage/ResourceStorage.gd")

@onready var dieAudio: AudioStreamPlayer = $DieAudio
@onready var swooshAudio: AudioStreamPlayer = $SwooshAudio
@onready var transitionAnimation: AnimationPlayer = $Transition/AnimationPlayer

# 场景常量数据
enum SCENE {Home, Game, Over}
const sceneMap: Dictionary = {
	SCENE.Home: preload("res://scene/Home.tscn"),
	SCENE.Game: preload("res://scene/Game.tscn"),
	SCENE.Over: preload("res://scene/Over.tscn")
}

# 背景图片数据
const backgrounds: Array[Resource] = [preload("res://image/bg_day.png"), preload("res://image/bg_night.png")]
# 当前的背景，随机一个
var currentBackground = backgrounds.front()

# 小鸟动画数据
var birdAnimations: Array[String] = ["blue", "red", "yellow"]
var currentAnimation = birdAnimations.front()

var point: int = 0

# excel配置表数据
var resourceStorage: ResourceStorage

func _init():
	# 加载配置表的数据
	var buffer = ByteBufferStorage.new()
	var poolByteArray = FileUtils.readFileToByteArray("res://godot_resource_binary.cfg")
	buffer.writePackedByteArray(poolByteArray)
	var packet = ProtocolManagerStorage.read(buffer)
	resourceStorage = packet
	pass

func _ready():
	swooshAudio.play()
	transitionAnimation.play("fade-in")
	await transitionAnimation.animation_finished
	pass

func changeScene(scene: SCENE):
	var scenePath = sceneMap[scene]
	if (scene == SCENE.Over):
		dieAudio.play()
	else:
		swooshAudio.play()
	transitionAnimation.play_backwards("fade-in")
	await transitionAnimation.animation_finished
	get_tree().change_scene_to_packed(scenePath)
	transitionAnimation.play("fade-in")
	await transitionAnimation.animation_finished
	pass

func randomBackground():
	currentBackground = RandomUtils.randomEle(backgrounds)
	currentAnimation = RandomUtils.randomEle(birdAnimations)
	pass
