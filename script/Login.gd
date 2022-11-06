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


func _process(delta):
	if (Main.tcpClient.isConnected()):
		Main.unshowLoading()
	var packet = Main.tcpClient.peekReceivePacket()
	if packet == null:
		return
	if packet is LoginResponse:
		Main.tcpClient.popReceivePacket()
		Main.token = packet.token
		print(StringUtils.format("收到登录令牌token:[{}]", [packet.token]))
	elif packet is GetPlayerInfoResponse:
		Main.tcpClient.popReceivePacket()
		Main.playInfo = packet
		Main.changeScene(Main.SCENE.Home)
		Main.notify(StringUtils.format("[{}] 欢迎回来", [packet.playerInfo.name]))
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
	var request = LoginRequest.new()
	request.account = account
	request.password = password
	Main.tcpClient.send(request)
	pass

func onTimeout():
	var bird = preload("res://scene/effect/EffectFlyBird.tscn").instantiate()
	var createPositionY = randf_range(5, 500)
	bird.position.x = -10
	bird.position.y = createPositionY
	bird.get_node("Bird").animation = RandomUtils.randomEle(Main.birdAnimations)
	bird.speed = RandomUtils.randomIntRange(30, 500)
	add_child(bird)
	pass
