extends Object


const TimeUtils = preload("res://zfoo/TimeUtils.gd")
const ArrayUtils = preload("res://zfoo/ArrayUtils.gd")
const CollectionUtils = preload("res://zfoo/CollectionUtils.gd")


const root: Array[Window] = [null]


static func init(rootNode: Window) -> void:
	root.clear()
	root.append(rootNode)
	pass
	
	
# 固定延迟执行的任务，delay为秒
static func schedule(callable: Callable, delaySeconds: float) -> void:
	var root: Window = root.front()
	root.create_tween().tween_callback(callable).set_delay(delaySeconds)
	pass
