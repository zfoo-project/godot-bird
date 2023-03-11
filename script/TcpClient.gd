extends RefCounted

const ProtocolManager = preload("res://protocol/ProtocolManager.gd")
const ByteBuffer = preload("res://protocol/ByteBuffer.gd")
const SignalAttachment = preload("res://protocol/attachment/SignalAttachment.gd")


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
	print(format("tcp client connect threadId:[{}]", [connectThread.get_id()]))
	print(format("tcp client send threadId:[{}]", [sendThread.get_id()]))
	pass

	
class EncodedPacketInfo:
	extends RefCounted
	
	var packet: RefCounted
	var attachment: SignalAttachment
	
	func _init(packet: RefCounted, attachment: SignalAttachment):
		self.packet = packet
		self.attachment = attachment
		pass
	pass

class DecodedPacketInfo:
	extends RefCounted
	
	var packet: RefCounted
	var attachment: SignalAttachment
	
	func _init(packet: RefCounted, attachment: SignalAttachment):
		self.packet = packet
		self.attachment = attachment
		pass
	pass

var noneTime: int = 0
var errorTime: int = 0
var connectingTime: int = 0
var connectedTime: int = 0

var receiveQueue: Array[DecodedPacketInfo] = []
var sendQueue: Array[EncodedPacketInfo] = []

var receiveMutex: Mutex = Mutex.new()
var sendMutex: Mutex = Mutex.new()
var sendSemaphore: Semaphore = Semaphore.new()
# SignalBridge
var signalAttachmentMap: Dictionary = {}
var signalAttachmentMutex: Mutex = Mutex.new()
signal PacketSignal(signalId: int, packet: RefCounted)


func isConnected() -> bool:
	var status = client.get_status()
	return true if status == StreamPeerTCP.STATUS_CONNECTED else false
	pass


func popReceivePacket():
	if receiveQueue.is_empty():
		return null
	print(format("------------------------------ receive packet count [{}]", [receiveQueue.size()]))
	receiveMutex.lock()
	var decodedPacketInfo: DecodedPacketInfo = receiveQueue.pop_front()
	receiveMutex.unlock()
	return decodedPacketInfo.packet
	pass

# 查看服务器返回的第一个包
func peekReceivePacket():
	if receiveQueue.is_empty():
		return null
	return receiveQueue.front().packet
	pass


func send(packet):
	if packet == null:
		printerr("null point exception")
	addToSendQueue(EncodedPacketInfo.new(packet, null))
	sendSemaphore.post()
	pass


func asyncAsk(packet):
	if packet == null:
		printerr("null point exception")
	var attachment: SignalAttachment = SignalAttachment.new()
	var signalId = uuidInt()
	attachment.signalId = signalId
	attachment.client = true
	addToSendQueue(EncodedPacketInfo.new(packet, attachment))
	# add attachment
	signalAttachmentMutex.lock()
	signalAttachmentMap[signalId] = attachment
	for key in signalAttachmentMap.keys():
		pass
	signalAttachmentMutex.unlock()
	var returnPacket = await attachment.PacketSignal
	# remove attachment
	signalAttachmentMutex.lock()
	signalAttachmentMap.erase(signalId)
	signalAttachmentMutex.unlock()
	return returnPacket
	pass

	
func encodeAndSend(encodedPacketInfo: EncodedPacketInfo):
	var packet = encodedPacketInfo.packet
	var attachment = encodedPacketInfo.attachment
	var buffer = ByteBuffer.new()
	buffer.writeRawInt(0)
	ProtocolManager.write(buffer, packet)
	if attachment == null:
		buffer.writeBool(false)
	else:
		buffer.writeBool(true)
		ProtocolManager.write(buffer, attachment)
	var writeOffset = buffer.getWriteOffset();
	buffer.setWriteOffset(0)
	buffer.writeRawInt(writeOffset - 4)
	buffer.setWriteOffset(writeOffset)
	var data = buffer.toPackedByteArray()
	client.put_data(data)
	print(format("send packet [{}] [{}]", [packet.PROTOCOL_ID, packet._to_string()]))
	pass
	

func decodeAndReceive():
	var length = client.get_32()
	# tcp粘包拆包
	var data = client.get_data(length)
	if (data[0] == OK):
		var buffer = ByteBuffer.new()
		buffer.writePackedByteArray(PackedByteArray(data[1]))
		var packet = ProtocolManager.read(buffer)
		var attachment: SignalAttachment = null
		if buffer.isReadable() && buffer.readBool():
			attachment = ProtocolManager.read(buffer)
			var clientAttachment = signalAttachmentMap[attachment.signalId]
			clientAttachment.emit("PacketSignal", packet)
			return
		addToReceiveQueue(DecodedPacketInfo.new(packet, attachment))
		print(format("receive packet [{}]", [packet.PROTOCOL_CLASS_NAME]))
		print(packet.map())
	pass

func addToSendQueue(encodedPacketInfo: EncodedPacketInfo):
	sendMutex.lock()
	sendQueue.push_back(encodedPacketInfo)
	sendMutex.unlock()
	pass

func addToReceiveQueue(decodedPacketInfo: DecodedPacketInfo):
	receiveMutex.lock()
	receiveQueue.push_back(decodedPacketInfo)
	receiveMutex.unlock()
	pass

func tickConnect():
	while true:
		client.poll()
		
		var currentTime = Time.get_unix_time_from_system()
		var status = client.get_status()
		match status:
			StreamPeerTCP.STATUS_NONE:
				# 断线重连
				client.disconnect_from_host()
				client.connect_to_host(host, port)
				if (currentTime - noneTime) > 1:
					printerr(format("status none [{}] host [{}:{}]", ["开始断线重连", host, port]))
					noneTime = currentTime
			StreamPeerTCP.STATUS_ERROR:
				# 断线重连
				client.disconnect_from_host()
				client.connect_to_host(host, port)
				if (currentTime - errorTime) > 1:
					printerr(format("status error host [{}:{}]", [host, port]))
					errorTime = currentTime
			StreamPeerTCP.STATUS_CONNECTING:
				if (currentTime - connectingTime) > 1:
					print(format("status connecting host [{}:{}]", [host, port]))
					connectingTime = currentTime
			StreamPeerTCP.STATUS_CONNECTED:
				if (currentTime - connectedTime) > 1:
					print(format("status connected host [{}:{}]", [host, port]))
					connectedTime = currentTime
				if client.get_available_bytes() > 4:
					decodeAndReceive()
			_:
				print("tcp client unknown")
	pass


func tickSend():
	while true:
		if sendQueue.is_empty():
			sendSemaphore.wait()
			continue
			
		sendMutex.lock()
		var encodedPacketInfo = sendQueue.pop_front()
		sendMutex.unlock()
		
		client.poll()
		
		var status = client.get_status()
		match status:
			StreamPeerTCP.STATUS_NONE:
				addToSendQueue(encodedPacketInfo)
			StreamPeerTCP.STATUS_ERROR:
				addToSendQueue(encodedPacketInfo)
			StreamPeerTCP.STATUS_CONNECTING:
				addToSendQueue(encodedPacketInfo)
			StreamPeerTCP.STATUS_CONNECTED:
				encodeAndSend(encodedPacketInfo)
			_:
				print("tcp client unknown")
	pass
	


# other method
# 格式化字符串
func format(template: String, args: Array) -> String:
	return template.format(args, "{}")
	pass


var uuid = 0
var uuidMutex: Mutex = Mutex.new()
func uuidInt() -> int:
	uuidMutex.lock()
	uuid = uuid + 1
	var id = uuid
	uuidMutex.unlock()
	return id
	pass
