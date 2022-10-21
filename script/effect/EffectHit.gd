extends Node2D

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2d

func _ready():
	animatedSprite2D.animation_finished.connect(onAnimationFinished)
	animatedSprite2D.play()
	pass


func onAnimationFinished():
	animatedSprite2D.stop()
	animatedSprite2D.queue_free()
	pass
