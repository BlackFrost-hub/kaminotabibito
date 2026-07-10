# 外置语音包制作工作流

目标：把可选 Boss Voice 放进外置语音包。没有语音包时，地图仍正常运行，只是少播放配音。

## 资源分层

- 地图本体：机制、中文系统台词、关键 SFX。
- 外置语音包：Boss 开场、阶段、死亡、剧情类 Voice。
- 不要让机制依赖语音是否存在或是否播放完成。

## 路径规范

语音包内路径建议固定为：

```text
Sound/Boss/<BossKey>/Voice/<file>.mp3
```

地图代码、配置和外置包内路径必须一致。

## 清单驱动收集

1. 在 `voice_pack_manifest/Boss/` 中按 BossKey 维护分类 JSON。
2. 每个文件只把用户确认过的语音文件名写进 `files`。
3. 执行：

```powershell
python scripts/voice_pack_collect.py --manifest voice_pack_manifest --out build/voice-pack/mpq-root
```

脚本会生成：

```text
build/voice-pack/mpq-root/
build/voice-pack/mpq-root/(listfile)
```

这个目录就是 MPQ 的根目录。

## MPQ 制作

用 MPQMaster / Ladik MPQ Editor 新建 MPQ，把 `build/voice-pack/mpq-root/` 下的文件按相同路径加入。

当前本机可用的 Win32 版 MPQEditor：

```text
C:\Users\Administrator\Downloads\Win32\MPQEditor.exe
```

建议：

- 保留 `(listfile)`。
- 使用压缩。
- 只放 Voice，不放关键机制 SFX。
- 每次发包记录版本号，例如 `syzl_voice_pack_v001.mpq`。

## MIX 制作

社区教程里的 MIX 实质是：

```text
MIX = 加载 DLL + MPQ 资源数据
```

项目内已准备最小 loader 模板：

```text
tools/voice-pack-loader/
```

如果使用该路线：

- MPQ 是资源主体。
- DLL 负责调用 Storm 的 `SFileOpenArchive`。
- 普通外置包优先级可用 `0x0A`。
- 若要覆盖地图内资源，教程使用 `0x11`。
- 这属于 DLL 加载路线，只建议用于社区认可的发布环境。

## 发布建议

随地图附带：

```text
syzl_voice_pack_v001.mix
syzl_voice_pack_manifest.txt
```

manifest 至少写：

- 语音包版本。
- 包含的 BossKey。
- 文件数量。
- 生成日期。
- 对应地图版本。

没有语音包时，玩家只缺英文配音，中文台词和战斗机制必须正常。
