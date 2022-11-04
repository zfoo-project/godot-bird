extends RefCounted

const StringUtils = preload("res://zfoo/StringUtils.gd")
const TimeUtils = preload("res://zfoo/TimeUtils.gd")
const ProtocolManager = preload("res://protocol/ProtocolManager.gd")
const ByteBuffer = preload("res://protocol/ByteBuffer.gd")

var client = WebSocketPeer.new()

var connectThread = Thread.new()
var sendThread = Thread.new()

var url: String

func _init(url: String):
	self.url = url
	pass

func start():
	var result = client.connect_to_url(url)
	connectThread.start(Callable(self, "tickConnect"))
	sendThread.start(Callable(self, "tickSend"))
	print(StringUtils.format("websocket client connect threadId:[{}] connect:[{}]", [connectThread.get_id(), result]))
	print(StringUtils.format("websocket client send threadId:[{}]", [sendThread.get_id()]))
	

var noneTime: int = 0
var errorTime: int = 0
var connectingTime: int = 0
var connectedTime: int = 0

var receivePackets: Array = []
var sendPackets: Array = []

var receiveMutex: Mutex = Mutex.new()
var sendMutex: Mutex = Mutex.new()
var sendSemaphore: Semaphore = Semaphore.new()

func pushReceivePacket(packet):
	receiveMutex.lock()
	receivePackets.push_back(packet)
	receiveMutex.unlock()

func popReceivePacket():
	var packet = null
	if receivePackets.is_empty():
		return packet
	receiveMutex.lock()
	packet = receivePackets.pop_front()
	receiveMutex.unlock()
	return packet

func sendSync(packet):
	var buffer = ByteBuffer.new()
	buffer.writeRawInt(0)
	ProtocolManager.write(buffer, packet)
	var writeOffset = buffer.getWriteOffset();
	buffer.setWriteOffset(0)
	buffer.writeRawInt(writeOffset - 4)
	buffer.setWriteOffset(writeOffset)
	var data = buffer.toPackedByteArray()
	client.put_packet(data)
	print(StringUtils.format("send packet [{}]", [packet]))
	

func send(packet):
	if packet == null:
		printerr("null point exception")
	print("dddddddddddddddddddddddddddddddddddddddd")
	pushSendPacket(packet)
	sendSemaphore.post()
	print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")

func pushSendPacket(packet):
	sendMutex.lock()
	sendPackets.push_back(packet)
	sendMutex.unlock()

func popSendPacket():
	var packet = null
	if sendPackets.is_empty():
		return packet
	sendMutex.lock()
	packet = sendPackets.pop_front()
	sendMutex.unlock()
	return packet

func tickConnect():
	while true:
		client.poll()
		
		var currentTime = TimeUtils.currentTimeMillis()
		var status = client.get_ready_state()
		
		match status:
			WebSocketPeer.STATE_CLOSED:
				# 断线重连
				client.close()
				client.connect_to_url(url)
				if (currentTime - noneTime) > TimeUtils.MILLIS_PER_SECOND:
					printerr(StringUtils.format("status none [{}] host [{}]", ["开始断线重连", url]))
					noneTime = currentTime
			WebSocketPeer.STATE_CLOSING:
				if (currentTime - errorTime) > TimeUtils.MILLIS_PER_SECOND:
					printerr(StringUtils.format("status error host [{}]", [url]))
					errorTime = currentTime
			WebSocketPeer.STATE_CONNECTING:
				if (currentTime - connectingTime) > TimeUtils.MILLIS_PER_SECOND:
					print(StringUtils.format("status connecting host [{}]", [url]))
					connectingTime = currentTime
			WebSocketPeer.STATE_OPEN:
				if (currentTime - connectedTime) > TimeUtils.MILLIS_PER_MINUTE:
					print(StringUtils.format("status connected host [{}]", [url]))
					connectedTime = currentTime
				
				var packetCount = client.get_available_packet_count()
				if packetCount > 0:
					print(StringUtils.format("receive packetCount [{}]", [packetCount]))
					var data = client.get_packet()
					var buffer = ByteBuffer.new()
					buffer.writePackedByteArray(data)
					for i in range(packetCount):
						var packet = ProtocolManager.read(buffer)
						pushReceivePacket(packet)
						print(StringUtils.format("receive packet [{}]", [packet]))
			_:
				print("websocket client unknown")
	pass


func tickSend():
	while true:
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		var packet = popSendPacket()
		if packet == null:
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")
			sendSemaphore.wait()
			continue
		print("ccccccccccccccccccccccccccccccccccccccccccccccccccccc")
		client.poll()
		
		var status = client.get_ready_state()
		match status:
			WebSocketPeer.STATE_CLOSED:
				pushSendPacket(packet)
			WebSocketPeer.STATE_CLOSING:
				pushSendPacket(packet)
			WebSocketPeer.STATE_CONNECTING:
				pushSendPacket(packet)
			WebSocketPeer.STATE_OPEN:
				sendSync(packet)
			_:
				print("websocket client unknown")
	pass
	
