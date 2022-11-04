extends RefCounted

const StringUtils = preload("res://zfoo/StringUtils.gd")
const TimeUtils = preload("res://zfoo/TimeUtils.gd")
const ProtocolManager = preload("res://protocol/ProtocolManager.gd")
const ByteBuffer = preload("res://protocol/ByteBuffer.gd")

var client = StreamPeerTCP.new()

var connectThread = Thread.new()
var sendThread = Thread.new()

var host: String
var port: int

func _init(hostAndPort: String):
	var splits = hostAndPort.split(":")
	host = splits[0]
	port = splits[1].to_int()
	pass

func start():
	client.big_endian = true
	client.connect_to_host(host, port)
	connectThread.start(Callable(self, "tickConnect"))
	sendThread.start(Callable(self, "tickSend"))
	print(StringUtils.format("tcp client connect threadId:[{}]", [connectThread.get_id()]))
	print(StringUtils.format("tcp client send threadId:[{}]", [sendThread.get_id()]))
	

var noneTime: int = 0
var errorTime: int = 0
var connectingTime: int = 0
var connectedTime: int = 0

var receivePackets: Array = []
var sendPackets: Array = []

var receiveMutex: Mutex = Mutex.new()
var sendMutex: Mutex = Mutex.new()
var sendSemaphore: Semaphore = Semaphore.new()

func isConnected() -> bool:
	var status = client.get_status()
	return true if status == StreamPeerTCP.STATUS_CONNECTED else false

func pushReceivePacket(packet):
	receiveMutex.lock()
	receivePackets.push_back(packet)
	receiveMutex.unlock()

func popReceivePacket():
	var packet = null
	if receivePackets.is_empty():
		return packet
	print("------------------------------")
	print(receivePackets.size())
	receiveMutex.lock()
	packet = receivePackets.pop_front()
	receiveMutex.unlock()
	return packet

# 查看服务器返回的第一个包
func peekReceivePacket():
	var packet = null
	if receivePackets.is_empty():
		return packet
	return receivePackets.front()
	
func sendSync(packet):
	var buffer = ByteBuffer.new()
	buffer.writeRawInt(0)
	ProtocolManager.write(buffer, packet)
	var writeOffset = buffer.getWriteOffset();
	buffer.setWriteOffset(0)
	buffer.writeRawInt(writeOffset - 4)
	buffer.setWriteOffset(writeOffset)
	var data = buffer.toPackedByteArray()
	client.put_data(data)
	print(StringUtils.format("send packet [{}]", [packet.PROTOCOL_ID]))
	

func send(packet):
	if packet == null:
		printerr("null point exception")
	pushSendPacket(packet)
	sendSemaphore.post()

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
		var status = client.get_status()
		match status:
			StreamPeerTCP.STATUS_NONE:
				# 断线重连
				client.disconnect_from_host()
				client.connect_to_host(host, port)
				if (currentTime - noneTime) > TimeUtils.MILLIS_PER_SECOND:
					printerr(StringUtils.format("status none [{}] host [{}:{}]", ["开始断线重连", host, port]))
					noneTime = currentTime
			StreamPeerTCP.STATUS_ERROR:
				if (currentTime - errorTime) > TimeUtils.MILLIS_PER_SECOND:
					printerr(StringUtils.format("status error host [{}:{}]", [host, port]))
					errorTime = currentTime
			StreamPeerTCP.STATUS_CONNECTING:
				if (currentTime - connectingTime) > TimeUtils.MILLIS_PER_SECOND:
					print(StringUtils.format("status connecting host [{}:{}]", [host, port]))
					connectingTime = currentTime
			StreamPeerTCP.STATUS_CONNECTED:
				if (currentTime - connectedTime) > TimeUtils.MILLIS_PER_MINUTE:
					print(StringUtils.format("status connected host [{}:{}]", [host, port]))
					connectedTime = currentTime
				if client.get_available_bytes() > 4:
					var length = client.get_32()
					# tcp粘包拆包
					var data = client.get_data(length)
					if (data[0] == OK):
						var buffer = ByteBuffer.new()
						buffer.writePackedByteArray(PackedByteArray(data[1]))
						var packet = ProtocolManager.read(buffer)
						pushReceivePacket(packet)
						print(StringUtils.format("receive packet [{}]", [packet.PROTOCOL_ID]))
			_:
				print("tcp client unknown")
	pass


func tickSend():
	while true:
		var packet = popSendPacket()
		if packet == null:
			sendSemaphore.wait()
			continue
		
		client.poll()
		
		var status = client.get_status()
		match status:
			StreamPeerTCP.STATUS_NONE:
				pushSendPacket(packet)
			StreamPeerTCP.STATUS_ERROR:
				pushSendPacket(packet)
			StreamPeerTCP.STATUS_CONNECTING:
				pushSendPacket(packet)
			StreamPeerTCP.STATUS_CONNECTED:
				sendSync(packet)
			_:
				print("tcp client unknown")
	pass
	
