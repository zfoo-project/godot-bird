extends Object


# 一秒钟对应的纳秒数
const NANO_PER_SECOND: int = 1_000_000_000
# 一秒钟对应的毫秒数
const MILLIS_PER_SECOND: int = 1 * 1000
# 一分钟对应的毫秒数
const MILLIS_PER_MINUTE = 1 * 60 * MILLIS_PER_SECOND
# 一个小时对应的毫秒数
const MILLIS_PER_HOUR = 1 * 60 * MILLIS_PER_MINUTE
# 8个小时对应的毫秒数
const MILLIS_PER_HOUR_8 = 8 * 60 * MILLIS_PER_MINUTE
# 一天对应的毫秒数
const MILLIS_PER_DAY = 1 * 24 * MILLIS_PER_HOUR
# 一周对应的毫秒数
const MILLIS_PER_WEEK = 1 * 7 * MILLIS_PER_HOUR


	
# 获取精确的时间戳，单位为毫秒
static func currentTimeMillis() -> int:
	return (Time.get_unix_time_from_system() * MILLIS_PER_SECOND) as int


static func timeToString(timestamp: int) -> String:
	@warning_ignore("integer_division")
	return Time.get_datetime_string_from_unix_time((timestamp + MILLIS_PER_HOUR_8) / MILLIS_PER_SECOND, true)

static func timeToDateString(timestamp: int) -> String:
	@warning_ignore("integer_division")
	return Time.get_date_string_from_unix_time((timestamp + MILLIS_PER_HOUR_8) / MILLIS_PER_SECOND)
