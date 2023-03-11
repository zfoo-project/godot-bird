extends Node2D

var count = 0
signal HelloSignal(a: int, b: String)

func _ready():
	$StartAwait.connect("pressed", Callable(self, "startAwait"))
	$EmitSignal.connect("pressed", Callable(self, "emitSignal"))
	pass


func startAwait():
	print("*******************************************")
	var reslt = await wait_confirmation()
	print("-------------------------------------------")
	print(reslt)
	pass
	

func wait_confirmation():
	print("await ", count)
	var helloSginal = await self.HelloSignal
	print("User confirmed ", helloSginal)
	return helloSginal[0]

	
func emitSignal():
	count = count + 1
	print("emit signal ", count)
	self.emit_signal("HelloSignal", count, "Hello World")
	pass
