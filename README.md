# godot-bird（鸟了个鸟）powered by godot 4.2

- frontend：[godot](https://github.com/godotengine/godot)

- backend：[server](./server/src/main/java/fun/jiucai/bogers/Application.java)

- support await grammar of net request

```
var groupHistoryMessageResponse: GroupHistoryMessageResponse = await Main.tcpClient.asyncAsk(request)
```

- including GDScript serialization and deserialization.
```
ProtocolManager.write(buffer, ScoreRankRequest.new())

var request = ProtocolManager.read(buffer)
```
