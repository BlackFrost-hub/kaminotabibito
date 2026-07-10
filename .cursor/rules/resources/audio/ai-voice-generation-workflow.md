# AI 配音生成工作流入口

这份文件只保留入口索引。具体规则和声线库已经拆分到：

```text
.cursor/rules/resources/audio/ai-voice-generation/
```

## 阅读顺序

1. `ai-voice-generation/README.md`：总指引和目录说明。
2. `ai-voice-generation/00-生成工作流.md`：生成、压缩、模型、确认与接入边界。
3. `ai-voice-generation/09-配音台词与分段提示词.md`：英文改写、情绪弧线和分段标签。
4. `ai-voice-generation/07-选型速查.md`：按角色类型快速选声线。
5. 需要具体声线时，再打开对应分类文件：
   - `01-精灵贵族与人类统帅.md`
   - `02-恶魔与黑暗反派.md`
   - `03-兽族巨魔地精.md`
   - `04-古树自然神谕.md`
   - `05-亡灵吸血鬼盗贼女巫.md`
   - `06-怪物异形诅咒.md`

## 核心规则

- Boss Voice 试听稿只生成到 `audio_temp`。
- Voice 不迁入地图 `imports`；用户确认后登记 `voice_pack_manifest/Boss/<BossKey>.json`，代码使用外置 MIX 内部路径。
- 用户确认只表示候选通过；是否接入配置、重建 MIX 仍按明确指令执行。
- 游戏内中文系统消息和 AI 配音文本可以分开：`台词` 保持中文，`配音台词` 记录英文 TTS 文本。
- 带 `[angry]`、`[stern]`、`[fading]` 等情绪标签的英文台词优先用 `eleven_v3`。
- 不要用 `eleven_multilingual_v2` 生成带英文情绪标签的台词，它可能把标签读出来。
- 怪物拟声 / Creature Vocal SFX 不是 Voice 台词，不能和剧情台词、宝箱、系统提示混用。

## 默认路径

```text
试听源文件：C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\<BossKey>\Voice\
MIX 内部路径：Sound/Boss/<BossKey>/Voice/
manifest：voice_pack_manifest/Boss/<BossKey>.json
```

## 快速命令

生成：

```powershell
python scripts\elevenlabs_tts_generation.py "TEXT" "OUTPUT_PATH" VOICE_ID eleven_v3 0.48 0.84 0.55 1.00 mp3_44100_128 true en
```

压缩 64kbps mono：

```powershell
ffmpeg -y -i input.mp3 -ar 44100 -ac 1 -b:a 64k output_64k.mp3
```
