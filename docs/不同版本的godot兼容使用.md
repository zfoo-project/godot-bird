# 使用不同版本的godot如何避免版本冲突

- 在godot.exe的同级目录创建一个._sc_或者_sc_文件，这样不同版本的godot就可以使用不同的配置了，后面godot将自动使用self-contained-mode模式

- [self-contained-mode官方解释](https://docs.godotengine.org/en/latest/tutorials/io/data_paths.html#self-contained-mode)

- [参考github相关讨论](https://github.com/godotengine/godot-proposals/issues/2474)

## godot汉化

- godot 3.5 版本开始，汉化已经做的非常好了，直接设置语言就可以了

## 屏幕常用

- Editor | Editor Settings | Editor | Hide Console Window，设置控制台是否隐藏，3.5版本已经没有Hide Console Window这个选项了

- Editor | Editor Settings | Run | Window Placement | Rect，设置编辑器运行游戏窗口的位置

## godot 可以调用外部的IDE进行脚本的编辑，这里记录一下相关的配置

- 工欲善其事必先利其器，一款好用的编辑器可以极大的提高开发效率
- Godot 自带的代码编辑器对于代码提示使用起来比较难受、经常出现打完后不提示或者提示错误的情况，极度的不智能。
- 恰好官方就支持 VSCode 作为第三方编辑器，而且支持 Debug 调试功能，这里记录一下配置流程。

- 官方的Godot Tools插件支持断点调试，智能补全，文档查看等非常多的功能，支持比较全面

- 进入 Editor - EditorSetting - Text Editor - External，配置好 “Exec Path” 和 “Exec Flags” 后勾选 “Use External Editor”

- vscode 编辑器设置

```
/Programs/Microsoft VS Code/Code.exe
{project} --goto {file}:{line}:{col}
```

- idea 编辑器设置

```
C:/Program Files/JetBrains/IntelliJ
{project} {file}:{line}
```
