package fun.jiucai.bogers.controller;

import com.zfoo.net.NetContext;
import com.zfoo.net.anno.PacketReceiver;
import com.zfoo.net.router.attachment.GatewayAttachment;
import com.zfoo.net.session.Session;
import com.zfoo.orm.OrmContext;
import com.zfoo.orm.anno.EntityCacheAutowired;
import com.zfoo.orm.cache.IEntityCache;
import com.zfoo.protocol.collection.CollectionUtils;
import fun.jiucai.bogers.entity.PlayerEntity;
import fun.jiucai.bogers.entity.RoomEntity;
import fun.jiucai.bogers.protocol.room.*;
import fun.jiucai.bogers.resource.I18n;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;


@Component
@Slf4j
public class RoomController {

    @EntityCacheAutowired
    private IEntityCache<Long, RoomEntity> roomEntities;


    @PacketReceiver
    public void atJoinRoomRequest(Session session, JoinRoomRequest request, GatewayAttachment attachment) {
        var uid = attachment.getUid();
        var sid = attachment.getSid();

        var roomId = request.roomId();

        log.info("atJoinRoomRequest uid:[{}][{}] roomId:[{}]", uid, sid, roomId);

        var roomEntity = roomEntities.load(roomId);
        var currentUserIds = roomEntity.getPlayers();
        if (currentUserIds.size() >= roomEntity.getMaxNums()) {
            NetContext.getRouter().send(session, I18n.Ids.room_max_num_limit.error(), attachment);
            return;
        }

        // 房间里没有该玩家则添加数据
        var matchPlayer = roomEntity.matchPlayerById(uid);
        if (matchPlayer == null) {
            var player = OrmContext.getAccessor().load(uid, PlayerEntity.class);
            matchPlayer = player.toPlayerInfo();
            roomEntity.getPlayers().add(matchPlayer);
        }

        if (roomEntity.getOwner() == 0) {
            roomEntity.setOwner(uid);
        }


        roomEntities.update(roomEntity);

        var response = new JoinRoomResponse(roomEntity.toRoom());
        NetContext.getRouter().send(session, response, attachment);

        // 转发给lobby，记录一下加入的房间，方便断线重连
    }

    @PacketReceiver
    public void atExitRoomRequest(Session session, ExitRoomRequest request, GatewayAttachment attachment) {
        var uid = attachment.getUid();
        var sid = attachment.getSid();

        var roomId = request.roomId();

        log.info("atExitRoomRequest uid:[{}][{}] roomId:[{}]", uid, sid, roomId);

        var roomEntity = roomEntities.load(roomId);
        if (roomEntity.getPlayers().stream().noneMatch(it -> it.getId() == uid)) {
            NetContext.getRouter().send(session, I18n.Ids.room_no_player.error(), attachment);
            return;
        }

        roomEntity.getPlayers().removeIf(it -> it.getId() == uid);

        // 房间没人则销毁房间和ds
        if (CollectionUtils.isEmpty(roomEntity.getPlayers())) {
            log.info("atExitRoomRequest no players and close roomId:[{}]", roomId);
            roomEntities.update(roomEntity);
            NetContext.getRouter().send(session, new ExitRoomResponse(), attachment);
            return;
        }


        roomEntities.update(roomEntity);

        NetContext.getRouter().send(session, new ExitRoomResponse(), attachment);

        var targets = roomEntity.toPlayerIds();
        var notice = new ExitRoomNotice(roomEntity.toRoom(), roomEntity.getPlayers());
        NetContext.getConsumer().send(notice, roomId);
    }


    @PacketReceiver
    public void atRoomInfoAsk(Session session, RoomInfoAsk ask) {
        var roomId = ask.getRoomId();
        log.info("atRoomInfoAsk roomId:[{}]", roomId);
        var roomEntity = roomEntities.load(roomId);
        var room = roomEntity.toRoom();
        var answer = new RoomInfoAnswer(room, roomEntity.getRoomServerAddress());
        NetContext.getRouter().send(session, answer);
    }

}
