# 外置语音包分类清单

Boss Voice 按 BossKey 分文件登记：

```text
voice_pack_manifest/Boss/<BossKey>.json
```

每个 JSON 只记录一次源目录、MIX 内部目录和确认文件名：

```json
{
  "sourceDir": "audio_temp/Boss/Felice/Voice",
  "targetDir": "Sound/Boss/Felice/Voice",
  "files": [
    "felice_opening_example.mp3"
  ]
}
```

- `sourceDir` 相对项目根目录解析。
- `targetDir` 必须是 MPQ/MIX 内部路径。
- `files` 只登记用户确认并准备接入的 Voice，不放试听废稿。
- `voice_pack_manifest.json` 是旧版扁平清单，已停用并由 Git 忽略。
- 收集脚本默认递归读取本目录下的所有 JSON。

收集命令：

```powershell
python scripts/voice_pack_collect.py --manifest voice_pack_manifest --out build/voice-pack/mpq-root
```
