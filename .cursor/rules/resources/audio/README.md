# 音频资源规则索引

本目录集中存放 Boss SFX、Boss Voice、AI 生成、试听目录、播放封装、外置语音 MIX 包规则。

## 优先阅读

| 任务 | 先读 |
|------|------|
| 生成 Boss 技能音效 / SFX | [`audio-temp-workflow.mdc`](audio-temp-workflow.mdc)、[`ai-audio-generation-workflow.md`](ai-audio-generation-workflow.md) |
| 生成 Boss 台词配音 / Voice | [`ai-voice-generation-workflow.md`](ai-voice-generation-workflow.md)、[`ai-voice-generation/README.md`](ai-voice-generation/README.md) |
| 选择 ElevenLabs 声线 | [`ai-voice-generation/07-选型速查.md`](ai-voice-generation/07-选型速查.md)，再按角色类型打开分类文件 |
| 外置语音 MIX 包制作 | [`ai-voice-generation/08-外置语音MIX包操作指令.md`](ai-voice-generation/08-外置语音MIX包操作指令.md) |
| 游戏内播放音效函数 | [`sound-and-encapsulation.mdc`](sound-and-encapsulation.mdc) |

## 常用路径

```text
试听根目录：C:\Users\Administrator\Desktop\syzl\audio_temp\
Boss SFX：audio_temp\Boss\<BossKey>\SFX\
Boss Voice：audio_temp\Boss\<BossKey>\Voice\
SFX 正式资源：imports/Sound/Boss/<BossKey>/SFX/
Voice MIX 内路径：Sound/Boss/<BossKey>/Voice/
外置语音包 manifest：voice_pack_manifest/Boss/<BossKey>.json
外置语音包构建目录：build/voice-pack/
```

## 关键提醒

- SFX 和 Voice 都先生成到 `audio_temp`。确认后按类型处理：SFX 按明确指令迁入 `imports/Sound/...`；Boss Voice 记录到 `voice_pack_manifest/Boss/<BossKey>.json` 并进入外置 MIX，不要混入地图 `imports`。
- Creature Vocal SFX / 怪物拟声不是 Voice 台词。
- `Sound3DII_CooPlayReuse` 是默认 3D 坐标复用播放入口；稀有 4 路叠放才用 `Sound3DII_CooPlayPool4MultiInstanceRare`。
- 外置语音 `.mix` 是锦上添花资源包；缺失时不应影响游戏主流程。
