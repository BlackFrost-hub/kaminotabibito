# GPT-SoVITS 完整训练实战流程

本文记录本项目在 Windows、RTX 3050 Laptop 4GB、GPT-SoVITS `v2ProPlus` 环境下已经实际跑通的完整流程。目标是把角色原始视频或音频做成可重复使用的 GPT 与 SoVITS 权重，再批量生成 Warcraft III Boss Voice。

固定安装路径、端口和启动方法见 `10-GPT-SoVITS本地训练与启动.md`；外置 MIX 打包见 `08-外置语音MIX包操作指令.md`。

## 执行摘要

1. 准备单角色原始视频或音频，优先无 BGM、无混响、无他人串音。
2. 转为单声道 WAV；先按停顿切片，再单独执行日语 ASR。
3. 人工校对 `.list`，删除非日语、错误说话人、纯噪声和无法可靠标注的片段。
4. WebUI `1A` 完成训练集格式化。
5. `1Ba` 训练 SoVITS，`1Bb` 训练 GPT；4GB 显存从 `batch size = 1` 开始。
6. `1C` 是推理，不是第三段训练。加载 GPT `.ckpt` 与 SoVITS `.pth` 后试听组合。
7. 批量生成前确认加载的是自训练双权重，不是官方 `s2G2333k.pth`。
8. 候选只进入 `audio_temp`；人工确认后才写配置、manifest 和实际播放代码。

## 一、固定环境

```text
GPT-SoVITS：D:\AI\GPT-SoVITS
WebUI：D:\AI\GPT-SoVITS\go-webui.bat
Python：D:\AI\GPT-SoVITS\runtime\python.exe
WebUI：http://127.0.0.1:9874/
GPU：NVIDIA GeForce RTX 3050 Laptop GPU，4GB
PyTorch：2.11.0+cu126
Torchaudio：2.11.0+cu126
TorchCodec：0.11.1+cpu
MarkupSafe：2.1.5
模型方向：v2ProPlus
```

验证环境：

```powershell
Set-Location "D:\AI\GPT-SoVITS"
.\runtime\python.exe -c "import torch, torchaudio, torchcodec; print(torch.__version__); print(torchaudio.__version__); print(torchcodec.__version__); print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0))"
```

训练正常时不要因为出现新版本就自行升级。PyTorch、Torchaudio、TorchCodec、CUDA 和 GPT-SoVITS 代码必须整套验证，避免重复下载数 GB 的 wheel 后引入新冲突。

## 二、素材要求

### 推荐素材

- 同一个角色、同一个声优、同一种主要语言。
- 单句之间有明显停顿，方便按静音切分。
- 干净台词优先于时长。无 BGM 的 6 分钟素材可以训练出可用模型，但情绪覆盖和稳定性有限。
- 更理想的是 `10-30` 分钟有效干净人声，包含项目实际需要的平静、命令、愤怒、低语等状态。
- 不要为了凑时长加入战斗音效、音乐、严重混响、其他角色或严重压缩片段。

### 语气词

- `啊、嗯、哦、哼、叹气` 等纯语气并非必须保留。
- 能准确描述且音质干净时可以少量保留；无法稳定标注、只有呼吸或接近噪声时直接删除。
- 不要把日语语气词误标成 `EN`，也不要用错误英文单词硬凑文本。
- 训练集不是字幕收藏，删除低质量片段通常比保留更有价值。

## 三、视频转音频

先保留 WAV 母版：

```powershell
ffmpeg -y -i "source.mp4" -vn -ar 44100 -ac 1 -c:a pcm_s16le "source_44100_mono.wav"
```

规则：

- 保留原视频，不覆盖。
- WAV 母版、`sliced` 和 `asr` 分目录存放，避免多批素材同名冲突。
- 素材已经是干净单人声时，不强制使用 UVR5；每多一次分离或降噪都可能损失音色细节。
- 只有确实存在 BGM、伴奏或明显混响时才使用 UVR5，并试听是否出现水声、电音或齿音。

## 四、切片与 ASR

### 切片不是识别

“音频切分”通常按静音和停顿拆文件，不会自动知道台词内容。切片完成后仍需单独执行 ASR。

切片目标：

- 单片通常 `2-10` 秒。
- 一片尽量只有一句完整台词。
- 不切断单词，不保留很长的首尾空白。
- 连续长句按自然停顿拆分，不要切成大量零碎音节。

### 日语 ASR

- 语言直接选择 `JA`，不要依赖自动语言判断。
- Whisper 容易误认角色名、技能名、片假名和古风措辞；识别结果只是初稿。
- GUI 在 `2-3` 秒内显示“完成”但没有输出时，应检查终端、输入目录、输出目录和模型是否真正加载。
- 任务管理器显示核显活动不等于 CUDA 未工作；以 `torch.cuda.is_available()`、NVIDIA 显存和训练日志为准。

## 五、校对 `.list`

标准格式：

```text
绝对音频路径|说话人名|JA|日语文本
```

示例：

```text
C:\dataset\sliced\voice_001.wav|ainz|JA|我が名を知るがよい
```

校对规则：

1. 音频、说话人、语言和文本必须一一对应。
2. 目标为日语模型时，删除所有非 `JA` 行；不要只改语言标签掩盖真实外语。
3. 删除不存在的文件、空文本、重复切片、串音和明显 ASR 幻觉。
4. 角色名与片假名按实际听感校对。用户懂日语时，人工听写优先于 Whisper。
5. 标点只负责可读性，文本不能比实际发音多字或少字。
6. 多批素材可以合并 `.list`，但文件路径、说话人名和切片文件名不能冲突。
7. 合并前保留原始 `.list` 备份，方便回查错误来源。

只抽查 `5%` 能发现明显系统性问题，但正式训练还应检查：

- 每个素材来源的开头、中段和结尾。
- 片假名、角色名、数字、咒语和长句。
- ASR 语言判断异常的全部行。
- 时长过短、过长和音量异常的全部片段。

## 六、WebUI 的 1A、1B、1C

### `1A-训练集格式化工具`

`1A` 是训练前的数据特征准备，不是模型训练。当前版本通常包含：

- `1Aa`：文本分词与特征提取。
- `1Ab`：语音自监督特征提取。
- `1Ac`：语义 token 提取。

要求：

- 使用最终校对后的 `.list`。
- 版本选择与计划训练的 `v2ProPlus` 一致。
- 每一步都确认终端实际遍历切片；GUI 瞬间提示“完成”不能证明成功。
- 输出目录应出现对应实验名的特征文件。
- 某一步失败后不要直接继续下一步，否则训练可能读取空目录或旧缓存。

### `1Ba-SoVITS 训练`

SoVITS 主要学习音色、发声质感和声学细节。

RTX 3050 Laptop 4GB 建议起点：

```text
版本：v2ProPlus
FP16：开启
batch size：1
梯度累积：按 WebUI 可用项开启
epoch：先跑 8-10，并保留中间权重
```

- `batch size = 2` 不是质量门槛；4GB 显存不稳定时退回 `1`。
- 显存接近 `3.8/4.0GB` 属于高风险边缘，后台 CUDA 任务可能导致中断。
- GPU 利用率偶尔降到 `0%`、显存仍占用，可能正在加载数据、保存权重或做 CPU 预处理，不代表必然卡死。
- 笔记本训练前接电源并使用高性能模式。停止时确认 checkpoint 已落盘再关机。
- 当前本机训练脚本做过单 GPU Windows 兼容修正，不要无证据重复覆盖：

```text
D:\AI\GPT-SoVITS\GPT_SoVITS\s2_train.py
D:\AI\GPT-SoVITS\GPT_SoVITS\s1_train.py
D:\AI\GPT-SoVITS\GPT_SoVITS\AR\data\bucket_sampler.py
```

### `1Bb-GPT 训练`

GPT 主要学习文本到语义 token 的节奏、停顿、读法和韵律倾向。

- 同样从低 batch 开始，不照抄高显存教程参数。
- 先训练约 `8-10` 个 epoch，并保留多个 checkpoint。
- GPT epoch 与 SoVITS epoch 不要求编号相同，可以交叉组合试听。
- epoch 更高不等于更像；过拟合可能增加机械感、重复、拖音和读法不稳定。

### `1C-推理`

`1C` 是加载权重进行 TTS 推理，不是第三段训练：

- 只要求完成训练时，`1Ba + 1Bb` 即可。
- 需要试听、比较和批量生成时才进入 `1C`。
- 最终推理验证不能省略，否则无法知道哪个 checkpoint 组合更合适。

## 七、权重保存与选择

典型输出：

```text
GPT：D:\AI\GPT-SoVITS\GPT_weights_v2ProPlus\<name>-eXX.ckpt
SoVITS：D:\AI\GPT-SoVITS\SoVITS_weights_v2ProPlus\<name>_eXX_sXXXX.pth
```

长期保存：

- 校对后的 `.list`。
- 原始 WAV 和最终切片。
- GPT `.ckpt` 与 SoVITS `.pth`。
- 训练参数和版本。
- 若干干净情绪参考音频及其准确文本。

权重选择：

1. 固定测试文本、参考音频和随机参数。
2. 先比较多个 SoVITS epoch，再比较多个 GPT epoch。
3. 先听发音、音色、电音、鼻音、齿音和拖音，再看相似度分数。
4. speaker similarity 只能辅助排序，不能替代人工听感。
5. 多个 checkpoint 听不出差异时，选择更稳定、较早且记录清楚的一组。

安兹本次实际选定：

```text
GPT：ainz_v1-e10.ckpt
SoVITS：ainz_v1_e8_s2560.pth
```

## 八、确认加载自训练双权重

推理必须同时加载 GPT 和 SoVITS：

- GPT `.ckpt` 负责语义和韵律。
- SoVITS `.pth` 负责目标音色与声学还原。
- 只选择参考音频、仍使用官方 SoVITS，不等于使用训练好的角色音色。

本地脚本使用自定义配置时，权重配置必须位于 `custom` 节点，或显式完成自训练 VITS 权重初始化。日志应显示：

```text
Loading Text2Semantic weights from ...\GPT_weights_v2ProPlus\<custom>.ckpt
Loading VITS weights from ...\SoVITS_weights_v2ProPlus\<custom>.pth
```

若日志出现官方 `s2G2333k.pth`，说明 SoVITS 没有切到自训练权重。该次相似度和试听结果无效，必须修正后重新生成。

## 九、参考音频

硬要求：

- 时长必须在 `3-10` 秒。
- 单人、干净、无 BGM、无重混响、无战斗音效。
- `prompt_text` 与实际发音完全一致。
- 日语参考使用 `prompt_lang = all_ja`。
- 不包含很长的首尾静音。

禁止：

- 给低于 3 秒的怒喊前后补静音，只为绕过长度检查。
- 随意拼接不连续情绪片段，却不修改 prompt 文本。
- 用平静参考生成怒吼后，只靠后期增益冒充演技。

本次已确认：给 `2.08` 秒怒喊补静音会导致持续宽带电音和语义失控。长度限制是有效输入约束，不应绕过。

没有合格的强情绪参考时：

1. 接受较克制的 TTS 版本；或
2. 先获得演技正确的音频，再走 `2-GPT-SoVITS-变声`；或
3. 补充合法、干净的同角色强情绪素材后重新训练。

## 十、日语与片假名

- 日本作品中的外来技能名、人物名和专有名词通常使用片假名。
- 直接喊技能真名时使用片假名；普通描述句不必强行外来语化。
- Whisper 经常误认角色名和长片假名，人工试听优先。
- 连续长片假名可能触发语义 token 过长、拖音或电音，不能因为“生成完成”就自动通过。
- 可以在自然语义边界使用日语逗号或句号，但必须试听停顿是否自然。
- 分句生成再拼接只是修复手段，不保证演技一致；用户不认可就回到原语气，不继续堆后期。

## 十一、低显存与故障判断

CUDA 验证：

```powershell
Set-Location "D:\AI\GPT-SoVITS"
.\runtime\python.exe -c "import torch; print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0)); print(torch.__version__)"
```

- 4GB 显存达到 `3.8GB` 时，不同时启动第二个训练或推理进程。
- SFX 下载型 API 通常不占本机 GPU，但训练稳定优先。
- 显存占用高而利用率暂时为 0，先看终端是否仍有 epoch、step、保存或加载输出。
- 真正卡死通常同时表现为：长时间无日志、GPU/CPU 无变化、权重文件时间不更新。
- `torchcodec` 使用 CPU wheel 不代表训练只走 CPU。
- 当前 `gradio 4.44.1` 使用 MarkupSafe `2.1.5`；不要看到 pip warning 就重装整个 runtime。

## 十二、批量生成

批量脚本必须记录：

- GPT 与 SoVITS 权重绝对路径。
- 每条文本、语言、参考音频和 prompt 文本。
- seed、speed、top_k、top_p、temperature、repetition penalty。
- WAV 母版与 MP3 输出目录。

推荐结构：

```text
audio_temp/Boss/<BossKey>/Voice/
  01_xxx.mp3
  02_xxx.mp3
  _wav_master/
  _alternates/
  试听记录.md
```

规则：

- 候选使用独立文件名，不覆盖用户已确认版本。
- 多分支台词可保留多个正式文件，但显示台词数组与配音资源数组长度必须一致。
- 共享 Boss 台词播放器使用同一个随机下标选择显示文本和 Voice。
- 批量中断后，只有 WAV 与 MP3 都存在时才能跳过该条。

## 十三、质量检查

自动检查至少覆盖：

- 文件存在且大小非零。
- MP3 规格、采样率、声道、码率和时长。
- 峰值是否接近静音或已经削波。
- ASR 与目标文本的明显偏差。
- 频谱是否出现贯穿长时间的宽带电音。

```powershell
ffprobe -v error -show_entries format=duration:stream=codec_name,sample_rate,channels,bit_rate -of default=noprint_wrappers=1 "voice.mp3"
ffmpeg -hide_banner -i "voice.mp3" -af volumedetect -f null NUL
```

自动检查不能决定最终听感：

- ASR 会误判片假名、专名和古风日语。
- 正常时长和峰值不代表语气正确。
- 频谱正常不代表没有轻微电音。
- 用户人工试听是最终选择依据；技术检查只排除明显损坏。

典型废稿：

- 持续数秒的电音、蜂鸣或宽带噪声。
- 短词生成成 `5-13` 秒拖音。
- 峰值很低、实际只有残音或近似静音。
- 发音正确但角色语气不合适。
- 叠加过多压缩、增益和失真后不再像原声。

废稿可以留在 `_alternates` 追踪，但试听记录必须标注“禁止接入”。用户后来明确选中某版本时，以最新确认覆盖旧状态，并复制到 Voice 根目录的稳定正式文件名。

## 十四、项目接入

用户确认前：

- 文件只放 `audio_temp`。
- 不写 TS 或 manifest。
- 不迁入 `imports`。

用户确认后：

1. 把所选候选复制到 `audio_temp/Boss/<BossKey>/Voice/` 根目录，使用稳定正式文件名。
2. 更新 Boss 配置的中文 `台词` 与 `配音资源`。
3. 代码路径使用 `Sound\Boss\<BossKey>\Voice\<file>.mp3`。
4. 更新 `voice_pack_manifest/Boss/<BossKey>.json`。
5. 复用共享 `Boss台词广播`，不要为每个技能直接创建 Sound 句柄。
6. Voice 不得阻塞技能、阶段或挑战收束；外置包缺失时游戏机制仍须正常。
7. 构建 TypeScript，并检查生成 Lua 的路径、随机分支和无 `self` 调用。
8. 用户要求更新外置包时，再按 `08-外置语音MIX包操作指令.md` 重建 MPQ/MIX。

manifest 示例：

```json
{
  "sourceDir": "audio_temp/Boss/AinzOoalGown/Voice",
  "targetDir": "Sound/Boss/AinzOoalGown/Voice",
  "files": [
    "01_intro_trial.mp3",
    "11_fallen_down.mp3",
    "ainz_fallen_down_super_tier_01.mp3"
  ]
}
```

## 十五、完成检查表

- [ ] 原始素材与来源可追溯。
- [ ] WAV 母版、切片和 `.list` 均有备份。
- [ ] `.list` 全部为正确说话人、语言和文本。
- [ ] `1A` 各步骤真实产出，不是 GUI 空完成。
- [ ] `1Ba` SoVITS 与 `1Bb` GPT 均保存多个权重。
- [ ] 推理日志确认加载自训练 GPT 与 SoVITS。
- [ ] 参考音频真实位于 `3-10` 秒，不补静音绕过。
- [ ] 候选完成规格、时长、峰值、ASR 和人工试听。
- [ ] 用户选择已记录，废稿状态清楚。
- [ ] 正式文件位于 Voice 根目录，代码不引用 `_alternates`。
- [ ] TS 配置、触发、manifest 与 MIX target 一致。
- [ ] TS 有改动时，已按 [TS 构建验证分流](../../../tooling/build/map-packaging-after-ts-build.mdc#ts-构建验证分流) 完成构建并检查相关生成 Lua；只有用户明确要求最终整体验收时才运行完整 `npm run build`。
- [ ] 需要部署时才重建并复制外置 MIX。
