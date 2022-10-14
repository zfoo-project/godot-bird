extends Object

const StringUtils = preload("res://zfoo/StringUtils.gd")


const MIN_INT: int = -2147483648
const MAX_INT: int = 2147483647

static func randomBoolean() -> bool:
	return 1 == randi_range(0, 2)


# 获得随机数[-2^32, 2^32)
static func randomInt() -> int:
	return randomIntRange(MIN_INT, MAX_INT)

# 获得指定范围内的随机数 [0,limit)
static func randomIntLimit(limit: int) -> int:
	return randomIntRange(0, limit)

# 获得随机数[-2^32, 2^32)
static func randomIntRange(from: int, to: int) -> int:
	if from < MIN_INT:
		push_error(StringUtils.format("from [{}] shoud be >= [{}]", [from, MIN_INT]))
		return 0
	
	if to > MAX_INT:
		push_error(StringUtils.format("to [{}] should be <= [{}]", [from, MAX_INT]))
		return 0
	
	return randi_range(from, to - 1)

static func randomEle(array: Array):
	return array[randomIntLimit(array.size())]
