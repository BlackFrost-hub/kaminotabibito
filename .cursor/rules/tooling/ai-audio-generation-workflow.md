# AI 音频生成规则

## 适用范围

- 本规则用于项目中的 AI 生成音效流程
- 当前默认来源网站为 ElevenLabs Sound Effects
- 当前本地生成脚本为 `scripts/elevenlabs_sound_generation.py`

## 来源

- 网站：`https://elevenlabs.io/sound-effects`
- API：`https://api.elevenlabs.io/v1/sound-generation`

说明：

- 网页版适合先快速试听、找方向、看多个不同版本
- API 版适合项目内批量生成、固定命名、自动分类、重复调用

## 基本原则

- 临时生成音频一律先输出到项目根目录的 `audio_temp/`
- `audio_temp/` 仅用于试听和筛选，不直接作为正式打包资源目录
- 确认可用后，再人工移动到正式资源目录，例如 `imports/Sound/...`
- 不要把 API Key 写进脚本、仓库、提交记录或文档示例
- API Key 统一走环境变量 `ELEVENLABS_API_KEY`

## 目录规则

- 临时目录根路径：`audio_temp/`
- 允许按用途建立二级、三级或更多层目录
- 推荐分类示例：
  - `audio_temp/dragon/roar/`
  - `audio_temp/demon/scream/`
  - `audio_temp/demon/spell/`
  - `audio_temp/ui/alert/`

正式资源落地时，按项目真实资源结构手动整理到：

- `imports/Sound/...`

## Boss 资源映射

- Boss 音效和配音的临时试听根目录固定为：
  - `C:\Users\Administrator\Desktop\syzl\audio_temp`
- 如果最终正式资源规划为 `imports/Sound/Boss/<BossKey>/`
  - 音效试听目录必须转换为：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\<BossKey>\SFX\`
  - 配音试听目录必须转换为：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\<BossKey>\Voice\`
- `SFX` 用于技能音效、命中、蓄力、机制反馈、场地提示等
- `Voice` 用于 Boss 配音、台词、喊话、战吼等
- 试听确认前，不要移动或复制到 `imports/Sound/Boss/...`
- 输出结果时同时给出：
  - 临时文件绝对路径
  - 推荐版本
  - 建议最终 `imports/Sound/...` 路径
- 除非已经明确完成迁移和代码配置，不要声称资源已接入项目
- 单个 Boss 的 SFX 文件数量按机制密度判断：至少保留 7 个核心反馈，最多 16 个文件。
- 优先生成/接入：阶段变化、核心机制启动、关键命中/惩罚、召唤或场地机制的强反馈、最终大招结算。
- 默认不生成：只增加气氛的装饰音、每种颜色/元素的微小差异音、高频循环氛围音、已有视觉/UI 足够清楚的小动作音。
- 时长按实际声音动作和听感决定，不要默认都压到 1 秒内，也不要默认都做成长音。命中、小提示通常可 0.5-1.2 秒；关键机制、阶段强化、机制启动、大招结算可 1.5-4.5 秒。若短音生成不出想要的完整动作，应优先放宽时长试听，再裁剪或压缩。

## 脚本位置

- 脚本：`scripts/elevenlabs_sound_generation.py`

脚本参数顺序：

```powershell
python scripts\elevenlabs_sound_generation.py "PROMPT" DURATION_SECONDS_OR_AUTO "OUTPUT_PATH_OR_DIR" OUTPUT_FORMAT VARIANT_COUNT PROMPT_INFLUENCE LOOP
```

参数说明：

- `PROMPT`：英文提示词
- `DURATION_SECONDS_OR_AUTO`：时长，单位秒，或使用 `auto`
- `OUTPUT_PATH_OR_DIR`：可传完整文件路径，也可直接传文件夹路径
- `OUTPUT_FORMAT`：当前默认常用 `mp3_44100_128`
- `VARIANT_COUNT`：生成变体数量，当前脚本上限为 5
- `PROMPT_INFLUENCE`：提示词影响力，范围 `0-1`，当前默认建议 `0.7`
- `LOOP`：是否循环，支持 `true/false`、`on/off`、`1/0`

## 环境变量

当前 PowerShell 会话设置：

```powershell
$env:ELEVENLABS_API_KEY="你的真实apikey"
```

写入用户环境变量，供以后新开的 PowerShell 使用：

```powershell
setx ELEVENLABS_API_KEY "你的真实apikey"
```

注意：

- `setx` 只影响新开的终端窗口
- 当前已打开的 PowerShell 需要重新执行 `$env:ELEVENLABS_API_KEY=...` 或重开窗口

## 输出规则

### 传完整文件路径

```powershell
python scripts\elevenlabs_sound_generation.py "A short demonic roar, deep and brutal, isolated game sound effect" 1.5 "audio_temp\demon\roar\demon_roar.mp3" mp3_44100_128 3 0.7 false
```

输出结果：

- `audio_temp\demon\roar\demon_roar_01.mp3`
- `audio_temp\demon\roar\demon_roar_02.mp3`
- `audio_temp\demon\roar\demon_roar_03.mp3`

### 传文件夹路径

```powershell
python scripts\elevenlabs_sound_generation.py "A short demonic roar, deep and brutal, isolated game sound effect" auto "audio_temp\demon\roar" mp3_44100_128 3 0.7 false
```

输出结果：

- `audio_temp\demon\roar\elevenlabs_sound_effect_01.mp3`
- `audio_temp\demon\roar\elevenlabs_sound_effect_02.mp3`
- `audio_temp\demon\roar\elevenlabs_sound_effect_03.mp3`

### 环境音循环示例

```powershell
python scripts\elevenlabs_sound_generation.py "A looping cave fire ambience, low flames, dark fantasy environment, isolated game sound effect, no music" auto "audio_temp\environment\fire_loop" mp3_44100_128 2 0.5 true
```

## 提示词规则

- 优先使用英文提示词
- 明确声音主体：如 dragon, demon, monster, spell, UI click
- 明确情绪和质感：deep, brutal, sharp, feral, painful, dark, infernal
- 明确用途：`isolated game sound effect`
- 尽量排除杂项：`no music, no ambience`

推荐结构：

```text
[主体] + [动作/发声方式] + [情绪/质感] + isolated game sound effect + no music, no ambience
```

示例：

- 龙吼：
  - `A short dragon roar, powerful and feral, isolated creature game sound effect, no music, no ambience`
- 恶魔怪叫：
  - `A sharp demonic scream, wild and painful, isolated game sound effect, no music, no ambience`
- 恶魔施法：
  - `A dark demonic spell cast sound, infernal energy burst, isolated game sound effect, no music, no ambience`

## 当前推荐工作流

1. 先在网页端用简短提示词试方向
2. 确认方向后，先判断能否拆成可控声音层；除极简单、单一动作短音效外，Boss SFX 尽量拆分生成再合成
3. 用 API 在项目里批量生成 1 到 5 个变体或分层素材
4. 全部输出到 `audio_temp/` 分类目录
5. 人工试听，挑选最合适的版本或合成方案
6. 选中的音频再移动到 `imports/Sound/...`
7. 如需进一步适配魔兽，再单独做压缩、转码或命名整理

## 音效分层与合成优先

- Boss SFX 默认优先评估拆分生成；只要音效包含多个动作、材质、能量变化、怪物拟声或前后阶段，就尽量拆成多个可控层分别生成，再叠加、延迟、裁剪或混音合成为最终试听候选。
- 极简单、单一动作、单一材质的短促反馈可以直接生成 1 到 2 个完整变体，不必为了拆分而拆分。
- 常见拆分方式：起手层 / 主冲击层 / 尾音层，材质层 / 能量层 / 低频确认层，动作声 / 元素声 / 爆裂补层，怪物拟声层 / 机制能量层 / 环境反馈层。
- Boss SFX 需求里应优先写明是否拆层；若拆层，应说明每层承担的机制语义、建议延迟和混音关系。
- 中间层、素材层、失败版、旧版和 `_raw` 文件只用于试听与合成，不作为最终候选；最终回传必须标明可用的单文件混音版或明确的组合播放方案。
- 若最终采用组合播放方案，必须记录每个文件的播放顺序、建议延迟、用途定位和是否需要降低音量或仅在特定波次播放。

## 当前默认约定

- 生成阶段默认输出格式：`mp3_44100_128`
- 生成阶段默认提示词影响力：`0.7`
- 试听筛选阶段优先保留较高质量版本
- 真正进图前，再按地图体积要求决定是否继续压缩

## 备注

- ElevenLabs 的 TTS 排名不等于音效生成能力排名，音效质量要单独试听判断
- 同一提示词每次生成会有随机性，适合一次生成多个变体后筛选
- 对短音效来说，1.0 到 1.8 秒通常够用；过长往往会拖尾或混入不必要内容
