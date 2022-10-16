extends Node

@onready var dieAudio: AudioStreamPlayer = $DieAudio
@onready var swooshAudio: AudioStreamPlayer = $SwooshAudio
@onready var transitionAnimation: AnimationPlayer = $Transition/AnimationPlayer

# 场景常量数据
enum SCENE {Home, Game, Over}
const sceneMap: Dictionary = {
	SCENE.Home: "res://scene/Home.tscn",
	SCENE.Game: "res://scene/Game.tscn",
	SCENE.Over: "res://scene/Over.tscn"
}



var point: int = 0

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
	get_tree().change_scene_to_file(scenePath)
	transitionAnimation.play("fade-in")
	await transitionAnimation.animation_finished
	pass
