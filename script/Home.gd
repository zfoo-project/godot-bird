extends Node2D

const TimeUtils = preload("res://zfoo/TimeUtils.gd")
const StringUtils = preload("res://zfoo/StringUtils.gd")
const ScoreRankRequest =preload("res://protocol/cache/ScoreRankRequest.gd")
const ScoreRankResponse =preload("res://protocol/cache/ScoreRankResponse.gd")
const RankInfo = preload("res://protocol/common/RankInfo.gd")
const ChatMessage = preload("res://protocol/chat/ChatMessage.gd")
const GroupChatRequest = preload("res://protocol/chat/GroupChatRequest.gd")
const GroupChatMessageNotice = preload("res://protocol/chat/GroupChatMessageNotice.gd")
const GroupHistoryMessageRequest = preload("res://protocol/chat/GroupHistoryMessageRequest.gd")
const GroupHistoryMessageResponse = preload("res://protocol/chat/GroupHistoryMessageResponse.gd")


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
	$UI/Bird.play()
	$Control/Currency/Gold.text = String.num_int64(Main.playInfo.currencyVo.gold)
	$Control/Currency/Gem.text = String.num_int64(Main.playInfo.currencyVo.gem)
	Main.tcpClient.registerReceiver(GroupChatMessageNotice, Callable(self, "atGroupChatMessageNotice"))
	pass

func _exit_tree():
	Main.tcpClient.removeReceiver(self)
	pass

func atGroupChatMessageNotice(response: GroupChatMessageNotice):
	messages.push_front(response.chatMessage)
	print(StringUtils.format("收到聊天信息message:[{}]", [response.chatMessage.message]))
	updateMessageList()
	pass


func startGame():
	Main.changeScene(Main.SCENE.Game)
	pass

func _input(event):
	if event is InputEventScreenDrag:
		var scroll_by: float = -event.velocity.y / 50
		rankList.get_v_scroll_bar().value += scroll_by
		messageList.get_v_scroll_bar().value += scroll_by

func showRank():
	if (rankList.visible):
		rankList.visible = false
	else:
		rankList.visible = true
		var scoreRankResponse: ScoreRankResponse = await Main.tcpClient.asyncAsk(ScoreRankRequest.new())
		ranks = scoreRankResponse.ranks
		updateRankList()
		print(StringUtils.format("收到排行榜信息ranks:[{}]", [scoreRankResponse.ranks.size()]))
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
		var groupHistoryMessageResponse: GroupHistoryMessageResponse = await Main.tcpClient.asyncAsk(request)
		for chatMessage in groupHistoryMessageResponse.chatMessages:
			if messages.any(func(it: ChatMessage): return it.id == chatMessage.id):
				continue
			messages.push_back(chatMessage)
		messages.sort_custom(func(a, b): return a.id > b.id)
		updateMessageList()
		print(StringUtils.format("收到聊天历史记录size:[{}]", [groupHistoryMessageResponse.chatMessages.size()]))
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
	pass
	

func updateMessageList():
	messageList.clear()
	
	for chatMessage in messages:
		var name = chatMessage.name
		var message = chatMessage.message
		var timestamp = chatMessage.timestamp
		var info = StringUtils.format("[{}] {}: {} ", [TimeUtils.timeToDateString(timestamp), name, message])
		messageList.add_item(info)
	pass
