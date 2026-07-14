# 外置语音 MIX 包 AI 操作指令

本文给后续 AI / 接力线程使用。目标是把已确认的 Boss Voice 打成可选外置语音包 `.mix`，放进 Warcraft III 目录。语音包缺失时，地图机制、中文系统消息和关键 SFX 必须仍然正常。

## 何时执行

- 只有 manifest 新增、替换或删除了已确认 Voice，或用户明确要求重建语音包时，才重新打 MPQ/MIX。
- 普通代码、SFX、规则或中文台词修改不触发语音包重建。
- 重建前先验证 manifest source 全部存在、target 无重复且与代码路径一致。
- 游戏或 MPQEditor 占用目标 MIX 时，不结束用户进程；等用户关闭，或输出带时间戳的测试包。

## 固定约定

- 项目根目录：`C:\Users\Administrator\Desktop\syzl`
- manifest 目录：`voice_pack_manifest/Boss/`
- 收集脚本：`scripts/voice_pack_collect.py`
- MPQ 根目录：`build\voice-pack\mpq-root`
- MPQ 文件：`build\voice-pack\syzl_voice_pack_v001.mpq`
- MIX 文件：`build\voice-pack\syzl_voice_pack_v001.mix`
- loader DLL：`tools\voice-pack-loader\build\syzl_voice_pack_loader.dll`
- Warcraft III 目录：`F:\Warcraft III Frozen Throne`
- MPQEditor：`C:\Users\Administrator\Downloads\Win32\MPQEditor.exe`
- 推荐 MPQ 命令行工具：`tools\mpqcli\mpqcli.exe`

MPQ / MIX 内部资源路径固定使用：

```text
Sound/Boss/<BossKey>/Voice/<file>.mp3
```

代码、配置、manifest 的路径必须和 MPQ 内部路径完全一致，不要多一层 `mpq-root/`。

## manifest 写法

`voice_pack_manifest/Boss/<BossKey>.json` 只记录用户已经确认的 Voice，不记录试听废稿。

```json
{
  "sourceDir": "audio_temp/Boss/Thranduil/Voice",
  "targetDir": "Sound/Boss/Thranduil/Voice",
  "files": [
    "file.mp3"
  ]
}
```

要求：

- `sourceDir` 是项目内试听源目录，通常为 `audio_temp/Boss/<BossKey>/Voice`。
- `targetDir` 是 MPQ/MIX 内部目录，固定为 `Sound/Boss/<BossKey>/Voice`。
- `files` 只写确认文件名，不重复完整 source/target。
- Boss Voice 建议放外置包；关键战斗 SFX 仍优先放地图内资源。

## 自动流程

在项目根目录执行：

```powershell
python scripts/voice_pack_collect.py --manifest voice_pack_manifest --out build/voice-pack/mpq-root
```

这一步会清空并重建：

```text
build\voice-pack\mpq-root
build\voice-pack\mpq-root\(listfile)
```

如果报 `FileNotFoundError`，先修 manifest 的 `source`，不要硬打包。

## 推荐：命令行生成 MPQ

后续优先使用 `mpqcli`，不要再默认卡在 MPQEditor GUI。

工具位置：

```text
tools\mpqcli\mpqcli.exe
```

来源：

```text
https://github.com/thegraydot/mpqcli/releases/download/v0.10.0/mpqcli-windows-amd64.exe
```

重建 MPQ：

```powershell
$mpq = "build\voice-pack\syzl_voice_pack_v001.mpq"
if (Test-Path -LiteralPath $mpq) { Remove-Item -LiteralPath $mpq -Force }
& "tools\mpqcli\mpqcli.exe" create --game warcraft3 --output $mpq "build\voice-pack\mpq-root"
```

检查 MPQ 内容：

```powershell
& "tools\mpqcli\mpqcli.exe" list "build\voice-pack\syzl_voice_pack_v001.mpq"
& "tools\mpqcli\mpqcli.exe" verify "build\voice-pack\syzl_voice_pack_v001.mpq"
```

确认内部路径必须长这样：

```text
Sound\Boss\Thranduil\Voice\xxx.mp3
```

## 备用：MPQEditor GUI 步骤

只有在 `mpqcli` 不可用时，才使用 MPQEditor GUI。

1. 打开：

```text
C:\Users\Administrator\Downloads\Win32\MPQEditor.exe
```

2. 新建 MPQ：

```text
C:\Users\Administrator\Desktop\syzl\build\voice-pack\syzl_voice_pack_v001.mpq
```

3. 兼容性选择：

```text
Warcraft III - The Frozen Throne
```

4. 用“从文件夹创建 / add folder / create from folder”方式导入：

```text
C:\Users\Administrator\Desktop\syzl\build\voice-pack\mpq-root
```

5. 检查 MPQ 内部能看到类似：

```text
Sound\Boss\Thranduil\Voice\xxx.mp3
```

不能是：

```text
mpq-root\Sound\Boss\...
```

## 合成 MIX

MPQ 准备好后执行：

```powershell
tools\voice-pack-loader\make_mix.bat tools\voice-pack-loader\build\syzl_voice_pack_loader.dll build\voice-pack\syzl_voice_pack_v001.mpq build\voice-pack\syzl_voice_pack_v001.mix
```

MIX 的组成关系是：

```text
MIX = loader DLL + MPQ 资源数据
```

- MPQ 是语音资源主体。
- loader DLL 负责调用 Storm 的 `SFileOpenArchive` 加载 MPQ。
- 普通外置语音包优先级使用 `0x0A`。
- 只有明确需要覆盖地图内同路径资源时才使用 `0x11`。
- 这是 DLL 加载路线，只用于项目认可的发布和测试环境。

成功后复制到 Warcraft III 目录：

```powershell
Copy-Item -LiteralPath "build\voice-pack\syzl_voice_pack_v001.mix" -Destination "F:\Warcraft III Frozen Throne\syzl_voice_pack_v001.mix" -Force
```

如果提示目标文件被占用，通常是 Warcraft III 或 MPQEditor 正在使用旧包。处理方式：

- 优先让用户关闭 Warcraft III / MPQEditor 后再覆盖。
- 如果需要立即测试，可以复制成带版本号的新文件，例如：

```powershell
Copy-Item -LiteralPath "build\voice-pack\syzl_voice_pack_v001.mix" -Destination "F:\Warcraft III Frozen Throne\syzl_voice_pack_v001_YYYYMMDD_HHMM.mix" -Force
```

## 发布文件与版本清单

正式发布时至少随地图提供：

```text
syzl_voice_pack_v001.mix
syzl_voice_pack_manifest.txt
```

`syzl_voice_pack_manifest.txt` 至少记录：

- 外置语音包版本。
- 包含的 BossKey。
- Voice 文件总数。
- 生成日期。
- 对应地图版本。

地图本体继续包含战斗机制、中文系统台词和关键 SFX。玩家没有安装外置 MIX 时，只缺少可选 Boss Voice，战斗和剧情推进仍必须正常。

## 验证方式

当前测试命令是：

```text
testvoice
```

已验证：外置 `.mix` 在 Warcraft III 目录中时，游戏内可以播放外置 MP3。

后续接入正式 Boss Voice 时注意：

- 地图内中文系统消息照常显示。
- 语音播放只是锦上添花，不得影响技能逻辑。
- 不要让机制等待语音播完。
- 不要依赖语音文件是否存在来推进战斗。

## 后续 AI 接力检查清单

1. 先确认用户要打包的是 Voice，不是核心 SFX。
2. 检查 `voice_pack_manifest/Boss/` 是否包含所有已确认 Voice。
3. 跑 `voice_pack_collect.py`。
4. 如 manifest 内容变化，优先用 `mpqcli create --game warcraft3` 重新生成 MPQ；`mpqcli` 不可用时才用 MPQEditor GUI。
5. 跑 `make_mix.bat` 合成 MIX。
6. 复制到 `F:\Warcraft III Frozen Throne`。
7. 如复制失败且提示文件占用，说明原因，并复制一个带时间戳的测试文件或等用户关闭游戏后重试。
8. 最终回复要说明：文件数量、MIX 路径、是否覆盖成功、是否需要用户进游戏测试。
