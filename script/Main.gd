extends Node

@onready var dieAudio: AudioStreamPlayer = $DieAudio
@onready var swooshAudio: AudioStreamPlayer = $SwooshAudio
@onready var transitionAnimation: AnimationPlayer = $Transition/AnimationPlayer

var point: int = 0

func _ready():
	swooshAudio.play()
	transitionAnimation.play("fade-in")
	await transitionAnimation.animation_finished
	pass

func changeScene(scenePath: String):
	swooshAudio.play()
	transitionAnimation.play_backwards("fade-in")
	await transitionAnimation.animation_finished
	get_tree().change_scene_to_file(scenePath)
	transitionAnimation.play("fade-in")
	pass
