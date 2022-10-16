extends Node2D


func _ready():
	$Control/Score.text = String.num_int64(Main.point)
	$Control/Menu.connect("pressed", Callable(self, "home"))
	pass
	
func home():
	Main.changeScene(Main.SCENE.Home)
	pass
