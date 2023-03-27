# godot-bird（鸟了个鸟）powered by godot 4.0

- frontend：[godot](https://github.com/godotengine/godot)

- backend：[zfoo](https://github.com/zfoo-project/zfoo) ，Use Maven install before running [zfoo](https://github.com/zfoo-project/zfoo)

- support await grammar of net request

```
var groupHistoryMessageResponse: GroupHistoryMessageResponse = await Main.tcpClient.asyncAsk(request)
```

- including GDScript serialization and deserialization.
```
ProtocolManager.write(buffer, ScoreRankRequest.new())

var request = ProtocolManager.read(buffer)
```
