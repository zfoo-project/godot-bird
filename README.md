# godot-bird（鸟了个鸟）powered by godot 4.0

- frontend：[godot](https://github.com/godotengine/godot)

- backend：[zfoo tank game server of single-boot](https://github.com/zfoo-project/tank-game-server/blob/main/single-boot/src/test/java/com/zfoo/tank/single/boot/ApplicationTest.java)

- support await grammar of net request

```
var groupHistoryMessageResponse: GroupHistoryMessageResponse = await Main.tcpClient.asyncAsk(request)
```

- including GDScript serialization and deserialization.
```
ProtocolManager.write(buffer, ScoreRankRequest.new())

var request = ProtocolManager.read(buffer)
```
