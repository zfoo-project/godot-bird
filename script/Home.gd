extends Node2D

const TimeUtils = preload("res://zfoo/TimeUtils.gd")
const StringUtils = preload("res://zfoo/StringUtils.gd")
const ScoreRankRequest =preload("res://protocol/protocol/cache/ScoreRankRequest.gd")
const ScoreRankResponse =preload("res://protocol/protocol/cache/ScoreRankResponse.gd")
const RankInfo = preload("res://protocol/protocol/common/RankInfo.gd")
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")
const GroupChatRequest = preload("res://protocol/protocol/chat/GroupChatRequest.gd")
const GroupChatMessageNotice = preload("res://protocol/protocol/chat/GroupChatMessageNotice.gd")
const GroupHistoryMessageRequest = preload("res://protocol/protocol/chat/GroupHistoryMessageRequest.gd")
const GroupHistoryMessageResponse = preload("res://protocol/protocol/chat/GroupHistoryMessageResponse.gd")


@onready var rankList: ItemList = $Control/RankList
@onready var chatPanel: Control = $Control/ChatPanel
@onready var messageList: ItemList = $Control/ChatPanel/MessageList

var ranks: Array[RankInfo] = []
var messages: Array[ChatMessage] = []

func _ready():
	$Control/Start.connect("pressed", Callable(self, "startGame"))
	$Control/RankButton.connect("pressed", Callable(self, "showRank"))
	$Control/Chat.connect("pressed", Callable(self, "showChat"))
	$Control/ChatPanel/Button.connect("pressed", Callable(self, "sendMessage"))
	# 每次到home场景都随机一个背景
	Main.randomBackground()
	$Background/Background.texture = Main.currentBackground
	$UI/Bird.animation = Main.currentAnimation
	pass

func _process(delta):
	var packet = Main.tcpClient.peekReceivePacket()
	if packet == null:
		return
	if packet is ScoreRankResponse:
		Main.tcpClient.popReceivePacket()
		ranks = packet.ranks
		updateRankList()
		print(StringUtils.format("收到排行榜信息ranks:[{}]", [packet.ranks.size()]))
	if packet is GroupChatMessageNotice:
		Main.tcpClient.popReceivePacket()
		messages.push_front(packet.chatMessage)
		print(StringUtils.format("收到聊天信息message:[{}]", [packet.chatMessage.message]))
		updateMessageList()
	if packet is GroupHistoryMessageResponse:
		Main.tcpClient.popReceivePacket()
		for chatMessage in packet.chatMessages:
			if messages.any(func(it: ChatMessage): return it.id == chatMessage.id):
				continue
			messages.push_back(chatMessage)
		messages.sort_custom(func(a, b): return a.id > b.id)
		print(StringUtils.format("收到聊天历史记录size:[{}]", [packet.chatMessages.size()]))
		updateMessageList()
	pass

func startGame():
	Main.changeScene(Main.SCENE.Game)
	pass

func _input(event):
	if event is InputEventScreenDrag:
		var scroll_by: float = -event.velocity.y / 50
		rankList.ensure_current_is_visible() # Auto scroll to show currently selected item.
		rankList.get_v_scroll_bar().value += scroll_by
		messageList.ensure_current_is_visible() # Auto scroll to show currently selected item.
		messageList.get_v_scroll_bar().value += scroll_by

func showRank():
	if (rankList.visible):
		rankList.visible = false
	else:
		rankList.visible = true
		Main.tcpClient.send(ScoreRankRequest.new())
	pass

func updateRankList():
	rankList.clear()
	var count = 1
	for rank in ranks:
		var score = rank.score
		var name = rank.playerInfo.name
		var time = rank.time
		var rankMessage = StringUtils.format("{} [{}] {} ", [TimeUtils.timeToDateString(time), score, name])
		if count == 1:
			rankList.add_item(rankMessage, preload("res://image/medals_3.png"))
		elif count == 2:
			rankList.add_item(rankMessage, preload("res://image/medals_2.png"))
		elif count == 3:
			rankList.add_item(rankMessage, preload("res://image/medals_1.png"))
		else:
			rankList.add_item(rankMessage, preload("res://image/medals_0.png"))
		count = count + 1
	pass


func showChat():
	if (chatPanel.visible):
		chatPanel.visible = false
	else:
		chatPanel.visible = true
		var request = GroupHistoryMessageRequest.new()
		if !messages.is_empty():
			request.lastMessageId = messages.back().id
		Main.tcpClient.send(request)
	pass

func sendMessage():
	var messageInput = $Control/ChatPanel/LineEdit
	var message: String = messageInput.text
	if StringUtils.isEmpty(message):
		Main.notify("发送的消息不能为空")
		return
	messageInput.text = StringUtils.EMPTY
	# 发送消息
	var request = GroupChatRequest.new()
	request.message = message
	Main.tcpClient.send(request)
	

func updateMessageList():
	messageList.clear()
	
	for chatMessage in messages:
		var name = chatMessage.name
		var message = chatMessage.message
		var timestamp = chatMessage.timestamp
		var info = StringUtils.format("[{}] {}: {} ", [TimeUtils.timeToDateString(timestamp), name, message])
		messageList.add_item(info)
	pass
