# 1. 射线检测的概念

- 引子

```
在一款游戏中使用检测手法是十分常见的。比如说玩家自动来到某个地方触发剧情，判断子弹击中玩家的部位并造成相应血量。。。
这其实都是碰撞检测的相关体现。但是，虽然碰撞检测在日常使用中相当普遍，但是碰撞检测也有相应的局限性。
比如说主角被人拿枪指着时会有相应提示（感觉我的游戏偏好要在博客里面暴露光了），又或者是我们拿鼠标光标指向某些物体时显示出物体的
具体信息（就比如像是城市模拟经营，我们想知道这个建筑具体是啥东西；又比如即时战略游戏我们想看一个兵种的具体血量等属性），
那碰撞检测就显得见襟捉肘了。我总不能对着光标方向创建一个透明长方体来检测碰撞吧。
但这样就显得很繁琐了。这时候我们就可以引入一个全新的检测手法：也就是射线检测了。
我们可以像超市自动开关门那样引出一个射线，如果射线指向了某些特定属性的物体就会发出信号。这也是射线检测的基本方法。
```

- 射线是啥

```
在进入射线检测的正题前，我们先回顾一下小学的知识：射线是个啥？
百度百科上写的是：具有特定能量的粒子束或光子束流。
看到这里你肯定十分疑惑，因为我也很疑惑，然后我发现我复制粘贴错了。

射线实际上是：直线上的一点和它一旁的部分所组成的图形。它由一个起始点开始，向着一个方向放出无限长的线。
当线与我们想要检测的物体重合就会发出信号。就实际例子上来说，我们在射击游戏中端着枪，枪口到远处就算是一个射线。
虽然我很想把射线一次全部整完，但由于射线检测在2D和3D的区别还是蛮大的，所以还是分成两个部分一起说吧。
```

- 官方的参考文档，射线相关

```
https://docs.godotengine.org/zh_CN/stable/tutorials/physics/ray-casting.html
```

# 2. RayCast2D

- RayCast2D是godot内置的节点，大部分情况下已经能够满足我们日常的使用

- 使用方式也是比较简单

# 3. PhysicsServer2D

- 发生碰撞时，result 字典包含以下数据：

```
{
   position: Vector2 # point in world space for collision
   normal: Vector2 # normal in world space for collision
   collider: Object # Object collided or null (if unassociated)
   collider_id: ObjectID # Object it collided against
   rid: RID # RID it collided against
   shape: int # shape index of collider
   metadata: Variant() # metadata of collider
}
```


