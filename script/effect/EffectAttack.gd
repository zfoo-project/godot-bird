extends Node2D


@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.animation_finished.connect(onAnimationFinished)
	animationPlayer.play()
	pass


func onAnimationFinished(anim_name):
	animationPlayer.stop()
	queue_free()
	pass
