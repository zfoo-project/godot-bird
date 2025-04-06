extends RefCounted

const ProtocolManager = preload("res://protocol/ProtocolManager.gd")
const ByteBuffer = preload("res://protocol/ByteBuffer.gd")
const SignalAttachment = preload("res://protocol/attachment/SignalAttachment.gd")

var client = StreamPeerTCP.new()

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
	pass

# It is necessary to call update every once in a while to start the network to send and receive
func update():
	tickReceive()
	tickSend()
	pass


class EncodedPacketInfo:
	extends RefCounted

	signal PacketSignal(packet: Object)

	var packet: RefCounted
	var attachment: SignalAttachment

	func _init(packet: Object, attachment: SignalAttachment):
		self.packet = packet
		self.attachment = attachment
		pass
	pass

class DecodedPacketInfo:
	extends RefCounted

	var packet: Object
	var attachment: SignalAttachment

	func _init(packet: Object, attachment: SignalAttachment):
		self.packet = packet
		self.attachment = attachment
		pass
	pass

var noneTime: int = 0
var errorTime: int = 0
var connectingTime: int = 0
var connectedTime: int = 0
var uuid: int = 0

var receiveQueue: Array[DecodedPacketInfo] = []
var sendQueue: Array[EncodedPacketInfo] = []

# SignalBridge
var signalAttachmentMap: Dictionary = {}
# PacketBus
var packetBus: Dictionary = {}


func isConnected() -> bool:
	var status = client.get_status()
	return true if status == StreamPeerTCP.STATUS_CONNECTED else false
	pass

func registerReceiver(protocol, callable: Callable):
	if packetBus.has(protocol.PROTOCOL_ID):
		var old = packetBus[protocol.PROTOCOL_ID]
		printerr(format("duplicate [protocol:{}] receiver [old:{}] [new:{}]", [protocol, old, callable]))
		return
	packetBus[protocol.PROTOCOL_ID] = callable
	pass

func removeReceiver(receiver):
	for key in packetBus.keys():
		var callable: Callable = packetBus[key]
		if callable.get_object_id() == receiver.get_instance_id():
			packetBus.erase(key)
	pass


func send(packet):
	if packet == null:
		printerr("null point exception")
	sendQueue.push_back(EncodedPacketInfo.new(packet, null))
	pass


func asyncAsk(packet):
	if packet == null:
		printerr("null point exception")
	var currentTime = Time.get_unix_time_from_system() * 1000
	var attachment: SignalAttachment = SignalAttachment.new()
	uuid = uuid + 1
	var signalId = uuid
	attachment.signalId = signalId
	attachment.timestamp = currentTime
	attachment.client = 12
	attachment.taskExecutorHash = -1
	var encodedPacketInfo: EncodedPacketInfo = EncodedPacketInfo.new(packet, attachment)
	sendQueue.push_back(encodedPacketInfo)
	# add attachment
	signalAttachmentMap[signalId] = encodedPacketInfo
	for key in signalAttachmentMap.keys():
		var oldAttachment = signalAttachmentMap[key].attachment
		if oldAttachment != null && currentTime - oldAttachment.timestamp > 60000:
			signalAttachmentMap.erase(key) # remove timeout packet
	var returnPacket = await encodedPacketInfo.PacketSignal
	# remove attachment
	signalAttachmentMap.erase(signalId)
	return returnPacket


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
		print(format("receive packet [{}]", [packet.PROTOCOL_CLASS_NAME]))
		print(packet)
		var attachment: SignalAttachment = null
		if buffer.isReadable() && buffer.readBool():
			attachment = ProtocolManager.read(buffer)
			var clientAttachment: EncodedPacketInfo = signalAttachmentMap[attachment.signalId]
			clientAttachment.emit_signal("PacketSignal", packet)
		else:
			if !packetBus.has(packet.PROTOCOL_ID):
				printerr(format("[protocol:{}][protocolId:{}] has no registration, please register for this protocol", [packet.PROTOCOL_CLASS_NAME, packet.PROTOCOL_ID]))
				return
			packetBus[packet.PROTOCOL_ID].call(packet)
	pass


func tickReceive():
	var currentTime = Time.get_unix_time_from_system()
	client.poll()
	var status = client.get_status()
	match status:
		StreamPeerTCP.STATUS_NONE:
			# 断线重连
			client.disconnect_from_host()
			client.connect_to_host(host, port)
			if (currentTime - noneTime) > 3:
				printerr(format("status none [{}] host [{}:{}]", ["开始断线重连", host, port]))
				noneTime = currentTime
		StreamPeerTCP.STATUS_ERROR:
			# 断线重连
			client.disconnect_from_host()
			client.connect_to_host(host, port)
			if (currentTime - errorTime) > 3:
				printerr(format("status error host [{}:{}]", [host, port]))
				errorTime = currentTime
		StreamPeerTCP.STATUS_CONNECTING:
			if (currentTime - connectingTime) > 3:
				print(format("status connecting host [{}:{}]", [host, port]))
				connectingTime = currentTime
		StreamPeerTCP.STATUS_CONNECTED:
			if (currentTime - connectedTime) > 60:
				print(format("status connected host [{}:{}]", [host, port]))
				connectedTime = currentTime
			if client.get_available_bytes() > 4:
				decodeAndReceive()
		_:
			print("tcp client unknown")
	pass


func tickSend():
	if sendQueue.is_empty():
		return
	var encodedPacketInfo = sendQueue.pop_front()
	client.poll()
	var status = client.get_status()
	match status:
		StreamPeerTCP.STATUS_NONE:
			sendQueue.push_back(encodedPacketInfo)
		StreamPeerTCP.STATUS_ERROR:
			sendQueue.push_back(encodedPacketInfo)
		StreamPeerTCP.STATUS_CONNECTING:
			sendQueue.push_back(encodedPacketInfo)
		StreamPeerTCP.STATUS_CONNECTED:
			encodeAndSend(encodedPacketInfo)
		_:
			print("tcp client unknown")
	pass


# other method
# 格式化字符串
func format(template: String, args: Array) -> String:
	return template.format(args, "{}")
