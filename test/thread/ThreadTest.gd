extends Node2D


var count = 0
var mutex: Mutex = Mutex.new()

func _ready():
	for i in range(100):
		var thread = Thread.new()
		thread.start(Callable(self, "tick"))
	pass


func tick():
	for i in range(1000000):
		mutex.lock()
		count = count + 1
		mutex.unlock()
	pass

func _process(delta):
	if count % 100 == 0:
		print(count)
	pass
