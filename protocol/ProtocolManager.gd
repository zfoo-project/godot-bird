const SignalAttachment = preload("./attachment/SignalAttachment.gd")
const GatewayAttachment = preload("./attachment/GatewayAttachment.gd")
const UdpAttachment = preload("./attachment/UdpAttachment.gd")
const HttpAttachment = preload("./attachment/HttpAttachment.gd")
const NoAnswerAttachment = preload("./attachment/NoAnswerAttachment.gd")
const Message = preload("./common/Message.gd")
const Error = preload("./common/Error.gd")
const Heartbeat = preload("./common/Heartbeat.gd")
const Ping = preload("./common/Ping.gd")
const Pong = preload("./common/Pong.gd")
const PairIntLong = preload("./common/PairIntLong.gd")
const PairLong = preload("./common/PairLong.gd")
const PairString = preload("./common/PairString.gd")
const PairLS = preload("./common/PairLS.gd")
const TripleLong = preload("./common/TripleLong.gd")
const TripleString = preload("./common/TripleString.gd")
const TripleLSS = preload("./common/TripleLSS.gd")
const PlayerInfo = preload("./common/PlayerInfo.gd")
const CurrencyVo = preload("./common/CurrencyVo.gd")
const RankInfo = preload("./common/RankInfo.gd")
const LoginRequest = preload("./login/LoginRequest.gd")
const LoginResponse = preload("./login/LoginResponse.gd")
const LogoutRequest = preload("./login/LogoutRequest.gd")
const LogoutResponse = preload("./login/LogoutResponse.gd")
const GetPlayerInfoRequest = preload("./login/GetPlayerInfoRequest.gd")
const GetPlayerInfoResponse = preload("./login/GetPlayerInfoResponse.gd")
const BattleResultRequest = preload("./battle/BattleResultRequest.gd")
const BattleResultResponse = preload("./battle/BattleResultResponse.gd")
const KickPlayerNotice = preload("./login/KickPlayerNotice.gd")
const CurrencyUpdateNotice = preload("./notice/CurrencyUpdateNotice.gd")
const PlayerExpNotice = preload("./notice/PlayerExpNotice.gd")
const AdminPlayerLevelAsk = preload("./admin/AdminPlayerLevelAsk.gd")
const AdminCurrencyAsk = preload("./admin/AdminCurrencyAsk.gd")
const CreateRoomRequest = preload("./room/CreateRoomRequest.gd")
const CreateRoomResponse = preload("./room/CreateRoomResponse.gd")
const BattleScoreAsk = preload("./cache/BattleScoreAsk.gd")
const BattleScoreAnswer = preload("./cache/BattleScoreAnswer.gd")
const ScoreRankRequest = preload("./cache/ScoreRankRequest.gd")
const ScoreRankResponse = preload("./cache/ScoreRankResponse.gd")
const ChatMessage = preload("./chat/ChatMessage.gd")
const GroupChatMessageNotice = preload("./chat/GroupChatMessageNotice.gd")
const GroupChatRequest = preload("./chat/GroupChatRequest.gd")
const GroupHistoryMessageRequest = preload("./chat/GroupHistoryMessageRequest.gd")
const GroupHistoryMessageResponse = preload("./chat/GroupHistoryMessageResponse.gd")
const ExitRoomNotice = preload("./room/ExitRoomNotice.gd")
const ExitRoomRequest = preload("./room/ExitRoomRequest.gd")
const ExitRoomResponse = preload("./room/ExitRoomResponse.gd")
const JoinRoomNotice = preload("./room/JoinRoomNotice.gd")
const JoinRoomRequest = preload("./room/JoinRoomRequest.gd")
const JoinRoomResponse = preload("./room/JoinRoomResponse.gd")
const Room = preload("./room/Room.gd")
const RoomInfoAsk = preload("./room/RoomInfoAsk.gd")
const RoomInfoAnswer = preload("./room/RoomInfoAnswer.gd")

static var protocols: Dictionary[int, RefCounted] = {}
static var protocolClassMap: Dictionary[int, Object] = {}

static func initProtocol():
	protocols[0] = SignalAttachment.SignalAttachmentRegistration.new()
	protocolClassMap[0] = SignalAttachment
	protocols[2] = GatewayAttachment.GatewayAttachmentRegistration.new()
	protocolClassMap[2] = GatewayAttachment
	protocols[3] = UdpAttachment.UdpAttachmentRegistration.new()
	protocolClassMap[3] = UdpAttachment
	protocols[4] = HttpAttachment.HttpAttachmentRegistration.new()
	protocolClassMap[4] = HttpAttachment
	protocols[5] = NoAnswerAttachment.NoAnswerAttachmentRegistration.new()
	protocolClassMap[5] = NoAnswerAttachment
	protocols[100] = Message.MessageRegistration.new()
	protocolClassMap[100] = Message
	protocols[101] = Error.ErrorRegistration.new()
	protocolClassMap[101] = Error
	protocols[102] = Heartbeat.HeartbeatRegistration.new()
	protocolClassMap[102] = Heartbeat
	protocols[103] = Ping.PingRegistration.new()
	protocolClassMap[103] = Ping
	protocols[104] = Pong.PongRegistration.new()
	protocolClassMap[104] = Pong
	protocols[110] = PairIntLong.PairIntLongRegistration.new()
	protocolClassMap[110] = PairIntLong
	protocols[111] = PairLong.PairLongRegistration.new()
	protocolClassMap[111] = PairLong
	protocols[112] = PairString.PairStringRegistration.new()
	protocolClassMap[112] = PairString
	protocols[113] = PairLS.PairLSRegistration.new()
	protocolClassMap[113] = PairLS
	protocols[114] = TripleLong.TripleLongRegistration.new()
	protocolClassMap[114] = TripleLong
	protocols[115] = TripleString.TripleStringRegistration.new()
	protocolClassMap[115] = TripleString
	protocols[116] = TripleLSS.TripleLSSRegistration.new()
	protocolClassMap[116] = TripleLSS
	protocols[400] = PlayerInfo.PlayerInfoRegistration.new()
	protocolClassMap[400] = PlayerInfo
	protocols[401] = CurrencyVo.CurrencyVoRegistration.new()
	protocolClassMap[401] = CurrencyVo
	protocols[402] = RankInfo.RankInfoRegistration.new()
	protocolClassMap[402] = RankInfo
	protocols[1000] = LoginRequest.LoginRequestRegistration.new()
	protocolClassMap[1000] = LoginRequest
	protocols[1001] = LoginResponse.LoginResponseRegistration.new()
	protocolClassMap[1001] = LoginResponse
	protocols[1002] = LogoutRequest.LogoutRequestRegistration.new()
	protocolClassMap[1002] = LogoutRequest
	protocols[1003] = LogoutResponse.LogoutResponseRegistration.new()
	protocolClassMap[1003] = LogoutResponse
	protocols[1004] = GetPlayerInfoRequest.GetPlayerInfoRequestRegistration.new()
	protocolClassMap[1004] = GetPlayerInfoRequest
	protocols[1005] = GetPlayerInfoResponse.GetPlayerInfoResponseRegistration.new()
	protocolClassMap[1005] = GetPlayerInfoResponse
	protocols[1006] = BattleResultRequest.BattleResultRequestRegistration.new()
	protocolClassMap[1006] = BattleResultRequest
	protocols[1007] = BattleResultResponse.BattleResultResponseRegistration.new()
	protocolClassMap[1007] = BattleResultResponse
	protocols[1010] = KickPlayerNotice.KickPlayerNoticeRegistration.new()
	protocolClassMap[1010] = KickPlayerNotice
	protocols[1100] = CurrencyUpdateNotice.CurrencyUpdateNoticeRegistration.new()
	protocolClassMap[1100] = CurrencyUpdateNotice
	protocols[1101] = PlayerExpNotice.PlayerExpNoticeRegistration.new()
	protocolClassMap[1101] = PlayerExpNotice
	protocols[1200] = AdminPlayerLevelAsk.AdminPlayerLevelAskRegistration.new()
	protocolClassMap[1200] = AdminPlayerLevelAsk
	protocols[1201] = AdminCurrencyAsk.AdminCurrencyAskRegistration.new()
	protocolClassMap[1201] = AdminCurrencyAsk
	protocols[1500] = CreateRoomRequest.CreateRoomRequestRegistration.new()
	protocolClassMap[1500] = CreateRoomRequest
	protocols[1501] = CreateRoomResponse.CreateRoomResponseRegistration.new()
	protocolClassMap[1501] = CreateRoomResponse
	protocols[3000] = BattleScoreAsk.BattleScoreAskRegistration.new()
	protocolClassMap[3000] = BattleScoreAsk
	protocols[3001] = BattleScoreAnswer.BattleScoreAnswerRegistration.new()
	protocolClassMap[3001] = BattleScoreAnswer
	protocols[3002] = ScoreRankRequest.ScoreRankRequestRegistration.new()
	protocolClassMap[3002] = ScoreRankRequest
	protocols[3003] = ScoreRankResponse.ScoreRankResponseRegistration.new()
	protocolClassMap[3003] = ScoreRankResponse
	protocols[4000] = ChatMessage.ChatMessageRegistration.new()
	protocolClassMap[4000] = ChatMessage
	protocols[4001] = GroupChatMessageNotice.GroupChatMessageNoticeRegistration.new()
	protocolClassMap[4001] = GroupChatMessageNotice
	protocols[4002] = GroupChatRequest.GroupChatRequestRegistration.new()
	protocolClassMap[4002] = GroupChatRequest
	protocols[4003] = GroupHistoryMessageRequest.GroupHistoryMessageRequestRegistration.new()
	protocolClassMap[4003] = GroupHistoryMessageRequest
	protocols[4004] = GroupHistoryMessageResponse.GroupHistoryMessageResponseRegistration.new()
	protocolClassMap[4004] = GroupHistoryMessageResponse
	protocols[6007] = ExitRoomNotice.ExitRoomNoticeRegistration.new()
	protocolClassMap[6007] = ExitRoomNotice
	protocols[6008] = ExitRoomRequest.ExitRoomRequestRegistration.new()
	protocolClassMap[6008] = ExitRoomRequest
	protocols[6009] = ExitRoomResponse.ExitRoomResponseRegistration.new()
	protocolClassMap[6009] = ExitRoomResponse
	protocols[6010] = JoinRoomNotice.JoinRoomNoticeRegistration.new()
	protocolClassMap[6010] = JoinRoomNotice
	protocols[6011] = JoinRoomRequest.JoinRoomRequestRegistration.new()
	protocolClassMap[6011] = JoinRoomRequest
	protocols[6012] = JoinRoomResponse.JoinRoomResponseRegistration.new()
	protocolClassMap[6012] = JoinRoomResponse
	protocols[6013] = Room.RoomRegistration.new()
	protocolClassMap[6013] = Room
	protocols[6014] = RoomInfoAsk.RoomInfoAskRegistration.new()
	protocolClassMap[6014] = RoomInfoAsk
	protocols[6015] = RoomInfoAnswer.RoomInfoAnswerRegistration.new()
	protocolClassMap[6015] = RoomInfoAnswer
	pass

static func getProtocol(protocolId: int):
	return protocols[protocolId]

static func getProtocolClass(protocolId: int):
	return protocolClassMap[protocolId]

static func newInstance(protocolId: int):
	var protocol = protocolClassMap[protocolId]
	return protocol.new()

static func write(buffer, packet):
	var protocolId: int = packet.protocolId()
	buffer.writeShort(protocolId)
	var protocol = protocols[protocolId]
	protocol.write(buffer, packet)

static func read(buffer):
	var protocolId = buffer.readShort()
	var protocol = protocols[protocolId]
	var packet = protocol.read(buffer)
	return packet
