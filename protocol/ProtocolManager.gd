const SignalAttachment = preload("res://protocol/attachment/SignalAttachment.gd")
const Message = preload("res://protocol/common/Message.gd")
const Error = preload("res://protocol/common/Error.gd")
const Heartbeat = preload("res://protocol/common/Heartbeat.gd")
const Ping = preload("res://protocol/common/Ping.gd")
const Pong = preload("res://protocol/common/Pong.gd")
const PairIntLong = preload("res://protocol/common/PairIntLong.gd")
const PairLong = preload("res://protocol/common/PairLong.gd")
const PairString = preload("res://protocol/common/PairString.gd")
const PairLS = preload("res://protocol/common/PairLS.gd")
const TripleLong = preload("res://protocol/common/TripleLong.gd")
const TripleString = preload("res://protocol/common/TripleString.gd")
const TripleLSS = preload("res://protocol/common/TripleLSS.gd")
const PlayerInfo = preload("res://protocol/protocol/common/PlayerInfo.gd")
const CurrencyVo = preload("res://protocol/protocol/common/CurrencyVo.gd")
const RankInfo = preload("res://protocol/protocol/common/RankInfo.gd")
const LoginRequest = preload("res://protocol/protocol/login/LoginRequest.gd")
const LoginResponse = preload("res://protocol/protocol/login/LoginResponse.gd")
const LogoutRequest = preload("res://protocol/protocol/login/LogoutRequest.gd")
const LogoutResponse = preload("res://protocol/protocol/login/LogoutResponse.gd")
const GetPlayerInfoRequest = preload("res://protocol/protocol/login/GetPlayerInfoRequest.gd")
const GetPlayerInfoResponse = preload("res://protocol/protocol/login/GetPlayerInfoResponse.gd")
const BattleResultRequest = preload("res://protocol/protocol/battle/BattleResultRequest.gd")
const BattleResultResponse = preload("res://protocol/protocol/battle/BattleResultResponse.gd")
const CurrencyUpdateNotice = preload("res://protocol/protocol/CurrencyUpdateNotice.gd")
const PlayerExpNotice = preload("res://protocol/protocol/PlayerExpNotice.gd")
const TestRequest = preload("res://protocol/protocol/TestRequest.gd")
const TestResponse = preload("res://protocol/protocol/TestResponse.gd")
const ScoreRankRequest = preload("res://protocol/protocol/cache/ScoreRankRequest.gd")
const ScoreRankResponse = preload("res://protocol/protocol/cache/ScoreRankResponse.gd")
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")
const GroupChatMessageNotice = preload("res://protocol/protocol/chat/GroupChatMessageNotice.gd")
const GroupChatRequest = preload("res://protocol/protocol/chat/GroupChatRequest.gd")
const GroupHistoryMessageRequest = preload("res://protocol/protocol/chat/GroupHistoryMessageRequest.gd")
const GroupHistoryMessageResponse = preload("res://protocol/protocol/chat/GroupHistoryMessageResponse.gd")

const protocols: Dictionary = {
	0: SignalAttachment,
	100: Message,
	101: Error,
	102: Heartbeat,
	103: Ping,
	104: Pong,
	110: PairIntLong,
	111: PairLong,
	112: PairString,
	113: PairLS,
	114: TripleLong,
	115: TripleString,
	116: TripleLSS,
	400: PlayerInfo,
	401: CurrencyVo,
	402: RankInfo,
	1000: LoginRequest,
	1001: LoginResponse,
	1002: LogoutRequest,
	1003: LogoutResponse,
	1004: GetPlayerInfoRequest,
	1005: GetPlayerInfoResponse,
	1006: BattleResultRequest,
	1007: BattleResultResponse,
	1100: CurrencyUpdateNotice,
	1101: PlayerExpNotice,
	1300: TestRequest,
	1301: TestResponse,
	3002: ScoreRankRequest,
	3003: ScoreRankResponse,
	4000: ChatMessage,
	4001: GroupChatMessageNotice,
	4002: GroupChatRequest,
	4003: GroupHistoryMessageRequest,
	4004: GroupHistoryMessageResponse
}

static func getProtocol(protocolId: int):
	return protocols[protocolId]

static func newInstance(protocolId: int):
	var protocol = protocols[protocolId]
	return protocol.new()

static func write(buffer, packet):
	var protocolId: int = packet.PROTOCOL_ID
	buffer.writeShort(protocolId)
	var protocol = protocols[protocolId]
	protocol.write(buffer, packet)

static func read(buffer):
	var protocolId = buffer.readShort()
	var protocol = protocols[protocolId]
	var packet = protocol.read(buffer)
	return packet
