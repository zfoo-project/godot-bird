extends Object

const ArrayUtils = preload("res://zfoo/ArrayUtils.gd")

const EMPTY: String = ""
const EMPTY_JSON: String = "{}"

# Checks if a String is empty ("") or null
static func isEmpty(s: String) -> bool:
	return s == null or s.length() == 0


# 检查是否为空的字符串
static func isBlank(s: String) -> bool:
	if isEmpty(s):
		return true
	
	if isEmpty(s.strip_edges(true, true)):
		return true
		
	return false

# 格式化字符串
static func format(template: String, args: Array) -> String:
	if isEmpty(template) or ArrayUtils.isEmpty(args):
		return template
		
	return template.format(args, EMPTY_JSON)
	
