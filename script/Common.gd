extends Object


static func gameMaxTimeSeconds() -> float:
	return Main.resourceStorage.commonResources["gameMaxTimeSeconds"].value.to_float()

static func pipeInterval() -> int:
	return Main.resourceStorage.commonResources["pipeInterval"].value.to_int()

static func pipeRandomDown() -> int:
	return Main.resourceStorage.commonResources["pipeRandomDown"].value.to_float()

static func pipeRandomUp() -> int:
	return Main.resourceStorage.commonResources["pipeRandomUp"].value.to_float()

static func birdInitHp() -> int:
	return Main.resourceStorage.commonResources["birdInitHp"].value.to_int()

static func birdInitSpeed() -> float:
	return Main.resourceStorage.commonResources["birdInitSpeed"].value.to_float()

static func birdSpeedUp() -> float:
	return Main.resourceStorage.commonResources["birdSpeedUp"].value.to_float()

static func birdSpeedUpContinueTime() -> float:
	return Main.resourceStorage.commonResources["birdSpeedUpContinueTime"].value.to_float()

static func birdFlyUpSpeed() -> float:
	return Main.resourceStorage.commonResources["birdFlyUpSpeed"].value.to_float()

static func birdSpeedUpFlyUpSpeed() -> float:
	return Main.resourceStorage.commonResources["birdSpeedUpFlyUpSpeed"].value.to_float()

static func birdGravityScale() -> float:
	return Main.resourceStorage.commonResources["birdGravityScale"].value.to_float()

static func cameraInitOffset() -> float:
	return Main.resourceStorage.commonResources["cameraInitOffset"].value.to_float()	

static func cameraSpeedUpOffset() -> float:
	return Main.resourceStorage.commonResources["cameraSpeedUpOffset"].value.to_float()

static func cameraMoveSpeed() -> float:
	return Main.resourceStorage.commonResources["cameraMoveSpeed"].value.to_float()

static func speedCloud() -> float:
	return Main.resourceStorage.commonResources["speedCloud"].value.to_float()
	
static func speedFish() -> float:
	return Main.resourceStorage.commonResources["speedFish"].value.to_float()
	
static func speedShark() -> float:
	return Main.resourceStorage.commonResources["speedShark"].value.to_float()
