# War3 外置语音包 MIX Loader

本目录用于制作 syzl 可选外置语音包。

社区方案本质：

```text
物编/代码路径: yourmapname/xxx.mp3 或 Sound/Boss/xxx.mp3
MPQ 内路径: 必须完全一致
MIX 文件: loader DLL + MPQ 二进制合并
```

`.mix` 文件前半段是一个可加载 DLL，后半段追加 MPQ 数据。DLL 加载后调用 Storm 的 `SFileOpenArchive` 打开“自身文件”，War3 后续就能按 MPQ 路径读资源。

## 文件说明

- `syzl_voice_pack_loader.cpp`：加载自身 MIX 的 DLL 源码。
- `Storm266.h`：最小 Storm 函数声明。
- `make_mix.bat`：把 DLL 和 MPQ 二进制合并成 MIX。

## 路径规则

地图里引用的路径和 MPQ 内路径必须完全一致。

例如地图配置写：

```text
Sound/Boss/Thranduil/Voice/thranduil_opening_law_warning_jude_02_v3_64k.mp3
```

MPQ 内也必须是：

```text
Sound/Boss/Thranduil/Voice/thranduil_opening_law_warning_jude_02_v3_64k.mp3
```

不要多一层 `mpq-root/`。

## 优先级

`SFileOpenArchive` 第二个参数是读取优先级。

- `0x0A`：普通外置资源包，低于地图内资源。
- `0x11`：覆盖地图内资源。

语音包建议默认 `0x0A`，因为 Voice 是锦上添花，不应该覆盖关键地图资源。

如果你明确要用外置语音覆盖地图内同路径语音，再改成 `0x11`。

## 生成 MIX

先准备：

```text
syzl_voice_pack_loader.dll
syzl_voice_pack_v001.mpq
```

当前本机已安装 Visual Studio Build Tools。重新编译 loader：

```powershell
New-Item -ItemType Directory -Force tools\voice-pack-loader\build
cmd /c "call ""C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars32.bat"" >nul && cl /nologo /EHsc /LD tools\voice-pack-loader\syzl_voice_pack_loader.cpp /Itools\voice-pack-loader /Fetools\voice-pack-loader\build\syzl_voice_pack_loader.dll /link /NOLOGO"
```

然后运行：

```bat
make_mix.bat syzl_voice_pack_loader.dll syzl_voice_pack_v001.mpq syzl_voice_pack_v001.mix
```

生成后把 `.mix` 放到社区工具/魔兽目录要求的位置。

## 当前缺口

本机目前没有检测到 C/C++ 编译器，所以源码已准备好，但还不能在本机直接编译 DLL。

可选路线：

1. 安装 Visual Studio Build Tools 后编译。
2. 使用社区现成 `load.dll`，直接和 MPQ 合并。
3. 用其他作者已验证的 MIX loader 替换本目录源码。
