extends StaticBody2D

var speed: int = 100

func _ready():
	$VisibleOnScreenNotifier2d.screen_exited.connect(onScreenExited)
	pass

func _physics_process(delta):
	position.x = position.x - speed * delta
	pass

func onScreenExited():
	queue_free()
	pass
