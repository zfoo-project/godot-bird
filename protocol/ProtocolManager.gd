const SignalAttachment = preload("res://protocol/attachment/SignalAttachment.gd")
const GatewayAttachment = preload("res://protocol/attachment/GatewayAttachment.gd")
const UdpAttachment = preload("res://protocol/attachment/UdpAttachment.gd")
const HttpAttachment = preload("res://protocol/attachment/HttpAttachment.gd")
const NoAnswerAttachment = preload("res://protocol/attachment/NoAnswerAttachment.gd")
const AuthUidToGatewayCheck = preload("res://protocol/model/AuthUidToGatewayCheck.gd")
const AuthUidToGatewayConfirm = preload("res://protocol/model/AuthUidToGatewayConfirm.gd")
const AuthUidAsk = preload("res://protocol/model/AuthUidAsk.gd")
const GatewaySessionInactiveAsk = preload("res://protocol/model/GatewaySessionInactiveAsk.gd")
const GatewaySynchronizeSidAsk = preload("res://protocol/model/GatewaySynchronizeSidAsk.gd")
const Message = preload("res://protocol/common/Message.gd")
const Error = preload("res://protocol/common/Error.gd")
const Heartbeat = preload("res://protocol/common/Heartbeat.gd")
const Ping = preload("res://protocol/common/Ping.gd")
const Pong = preload("res://protocol/common/Pong.gd")
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
const AdminPlayerLevelAsk = preload("res://protocol/protocol/admin/AdminPlayerLevelAsk.gd")
const AdminCurrencyAsk = preload("res://protocol/protocol/admin/AdminCurrencyAsk.gd")
const TestRequest = preload("res://protocol/protocol/TestRequest.gd")
const TestResponse = preload("res://protocol/protocol/TestResponse.gd")
const BattleScoreAsk = preload("res://protocol/protocol/cache/BattleScoreAsk.gd")
const BattleScoreAnswer = preload("res://protocol/protocol/cache/BattleScoreAnswer.gd")
const ScoreRankRequest = preload("res://protocol/protocol/cache/ScoreRankRequest.gd")
const ScoreRankResponse = preload("res://protocol/protocol/cache/ScoreRankResponse.gd")
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")
const GroupChatMessageNotice = preload("res://protocol/protocol/chat/GroupChatMessageNotice.gd")
const GroupChatRequest = preload("res://protocol/protocol/chat/GroupChatRequest.gd")
const GroupHistoryMessageRequest = preload("res://protocol/protocol/chat/GroupHistoryMessageRequest.gd")
const GroupHistoryMessageResponse = preload("res://protocol/protocol/chat/GroupHistoryMessageResponse.gd")

const protocols: Dictionary = {
	0: SignalAttachment,
	1: GatewayAttachment,
	2: UdpAttachment,
	3: HttpAttachment,
	4: NoAnswerAttachment,
	20: AuthUidToGatewayCheck,
	21: AuthUidToGatewayConfirm,
	22: AuthUidAsk,
	23: GatewaySessionInactiveAsk,
	24: GatewaySynchronizeSidAsk,
	100: Message,
	101: Error,
	102: Heartbeat,
	103: Ping,
	104: Pong,
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
	1200: AdminPlayerLevelAsk,
	1201: AdminCurrencyAsk,
	1300: TestRequest,
	1301: TestResponse,
	3000: BattleScoreAsk,
	3001: BattleScoreAnswer,
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
	var protocolId = buffer.readShort();
	var protocol = protocols[protocolId]
	var packet = protocol.read(buffer);
	return packet;
