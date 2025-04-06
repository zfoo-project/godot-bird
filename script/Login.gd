extends Node2D

const RandomUtils = preload("res://zfoo/RandomUtils.gd")
const StringUtils = preload("res://zfoo/StringUtils.gd")
const LoginRequest = preload("res://protocol/protocol/login/LoginRequest.gd")
const LoginResponse = preload("res://protocol/protocol/login/LoginResponse.gd")
const GetPlayerInfoRequest = preload("res://protocol/protocol/login/GetPlayerInfoRequest.gd")
const GetPlayerInfoResponse = preload("res://protocol/protocol/login/GetPlayerInfoResponse.gd")

func _ready():
	$Timer.timeout.connect(onTimeout)
	$Control/Login.connect("pressed", Callable(self, "login"))
	Main.tcpClient.start()
	Main.showLoading()
	pass

func _exit_tree():
	Main.tcpClient.removeReceiver(self)
	pass

func _process(delta):
	if (Main.tcpClient.isConnected()):
		Main.unshowLoading()
	pass

func login():
	var account: String = $Control/Account.text
	var password = $Control/Password.text
	if StringUtils.isEmpty(account):
		Main.notify("账号名称不能为空")
		return
	if !account.to_lower().begins_with("bird") && !OS.has_feature("editor"):
		Main.notify("账号名称需要用 bird 开头")
		return
	
	var loginRequest = LoginRequest.new()
	loginRequest.account = account
	loginRequest.password = password
	var loginResponse: LoginResponse = await Main.tcpClient.asyncAsk(loginRequest)
	Main.token = loginResponse.token
	print(StringUtils.format("收到登录令牌token:[{}]", [loginResponse.token]))
	
	var getPlayerInfoRequest = GetPlayerInfoRequest.new()
	getPlayerInfoRequest.token = loginResponse.token
	var getPlayerInfoResponse: GetPlayerInfoResponse = await Main.tcpClient.asyncAsk(getPlayerInfoRequest)
	Main.playInfo = getPlayerInfoResponse
	Main.changeScene(Main.SCENE.Home)
	Main.notify(StringUtils.format("[{}] 欢迎回来", [getPlayerInfoResponse.playerInfo.name]))	
	pass

func onTimeout():
	var bird = preload("res://scene/effect/EffectFlyBird.tscn").instantiate()
	var createPositionY = randf_range(5, 500)
	bird.position.x = -10
	bird.position.y = createPositionY
	bird.speed = RandomUtils.randomIntRange(30, 500)
	var birdNode: AnimatedSprite2D = bird.get_node("Bird")
	birdNode.animation = RandomUtils.randomEle(Main.birdAnimations)
	birdNode.play()
	add_child(bird)
	pass
