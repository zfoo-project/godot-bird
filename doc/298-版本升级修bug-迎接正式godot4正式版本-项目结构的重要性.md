# 版本升级修bug

- 代码报错
  ![Image text](image/298/img_1.png)

- 小鸟的动画没有播放出来，一个一个运行之前的测试用例，最小化定位出错的位置
  ![Image text](image/298/img.png)
  ![Image text](image/298/img_2.png)
  ![Image text](image/298/img_3.png)

- Array -> Array[xxx]，泛型转换错误
  ![Image text](image/298/img_4.png)


- 新建立的线程里面的代码无法断点，只能打印日志查看；如果里面有报错线程就会立即退出，不会有如何警告
  ![Image text](image/298/img_5.png)