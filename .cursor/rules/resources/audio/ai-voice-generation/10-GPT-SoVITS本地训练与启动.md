# GPT-SoVITS 本地训练与启动

本页记录当前电脑上 GPT-SoVITS ProPlus 的固定安装、启动和使用约定。用户说“启动 GPT-SoVITS”“打开语音克隆”“打开本地配音工具”时，直接按本页执行，不要重新询问安装路径，也不要重复安装。

## 固定环境

```text
程序目录：D:\AI\GPT-SoVITS
启动文件：D:\AI\GPT-SoVITS\go-webui.bat
本地 WebUI：http://127.0.0.1:9874/
Python 运行环境：D:\AI\GPT-SoVITS\runtime
Miniconda：D:\AI\Miniconda3
基础权重：D:\AI\GPT-SoVITS\GPT_SoVITS\pretrained_models
ProPlus 权重：D:\AI\GPT-SoVITS\GPT_SoVITS\pretrained_models\v2Pro
```

当前硬件与运行环境：

- GPU：NVIDIA GeForce RTX 3050 Laptop GPU，4GB 显存。
- Python：3.11，放在项目独立 `runtime` 中，不使用系统 Python。
- PyTorch：`2.11.0+cu126`。
- Torchaudio：`2.11.0+cu126`。
- TorchCodec：`0.11.1+cpu`。
- MarkupSafe：`2.1.5`，用于兼容当前 Gradio。
- CUDA：已经验证 `torch.cuda.is_available() == true`，设备为 `NVIDIA GeForce RTX 3050 Laptop GPU`。
- 主模型方向：GPT-SoVITS v2ProPlus，优先日语动漫角色声线相似度。
- 用户接受较慢生成速度，优先音色相似度、稳定性和多候选筛选。

## “启动”指令

用户只说“启动 GPT-SoVITS”时：

1. 检查本机 `9874` 端口是否已经监听。
2. 如果已经运行，只打开 `http://127.0.0.1:9874/`，不要启动第二份进程。
3. 如果没有运行，启动 `D:\AI\GPT-SoVITS\go-webui.bat`。
4. 等待 `9874` 端口监听，再检查首页 HTTP 状态是否为 `200`。
5. 验证成功后打开浏览器页面。
6. 提醒用户：使用期间保持启动控制台窗口开启；关闭控制台会停止 WebUI。

“启动”不代表更新、重装或重新下载。除非用户明确要求，否则不要执行：

- `git pull`
- 重装 Python、PyTorch 或 requirements
- 重新下载基础权重
- 删除或重建 `runtime`
- 同时启动多个 WebUI 实例

## 启动命令参考

检查端口：

```powershell
Get-NetTCPConnection -State Listen -LocalPort 9874 -ErrorAction SilentlyContinue
```

启动：

```powershell
Start-Process -FilePath "D:\AI\GPT-SoVITS\go-webui.bat" -WorkingDirectory "D:\AI\GPT-SoVITS"
```

检查页面：

```powershell
curl.exe -s -o NUL -w "%{http_code}" "http://127.0.0.1:9874/"
```

## 页面职责

### `0-前置数据集获取工具`

用于准备训练数据，不是自动抓取角色音频：

- UVR5 人声与伴奏分离
- 去混响、去延迟
- 长音频切片
- 日语 ASR 标注
- 训练文本校对

素材已经是干净单人声时，不要强制经过 UVR5；直接切片与标注可以减少音质损失。

### `1-GPT-SoVITS-TTS`

训练和文字转语音输出都在本页：

- 数据格式化
- SoVITS 训练
- GPT 训练
- TTS 推理

训练后长期保存并配套使用：

- GPT 权重：`.ckpt`
- SoVITS 权重：`.pth`
- 情绪参考音频
- 标注文本和训练配置

### `2-GPT-SoVITS-变声`

用于音频到音频的音色转换，不是普通文字转语音。适合先获得带演技的基础语音，再保留节奏、停顿、喊叫和情绪，转换成目标角色音色。

## 当前训练偏好

- 目标是授权或可合法使用的日本动漫二次元角色声线。
- 批量日语台词优先使用 v2ProPlus 微调模型。
- 4GB 显存训练默认使用 FP16、`batch size = 1` 和梯度累积。
- 不要把“训练轮数更多”直接等同于“更像”；保存多个 checkpoint，实际试听选择。
- 数据质量优先于训练速度：严格去除 BGM、混响、战斗音效、串音和错误日文标注。
- 平静、愤怒、低语、受伤、癫狂、死亡等参考音频分目录保存；推理时按目标情绪选择参考。
- 普通批量台词走 TTS；要求极强演技的关键句可先演出，再走变声。

完整的素材准备、标注、`1A/1B/1C`、低显存训练、权重筛选、推理质检与项目接入流程见 `11-GPT-SoVITS完整训练实战流程.md`。

## 常见提示

- 启动时提示缺少 `s1v3.ckpt` 不代表 ProPlus 不可用；当前主要权重位于 `pretrained_models\v2Pro`。
- WebUI 是本地浏览器 GUI，不是传统桌面 `.exe` 软件。
- RTX 3050 与更高端 NVIDIA 显卡在相同模型、数据和有效训练参数下不会天然产生不同音色；高端显卡主要减少耗时、提高可用批次并方便更多实验。
- 正式大规模训练可以临时租用 RTX 3090/4090 云实例，训练完成后把 `.ckpt`、`.pth`、参考音频与配置下载回本机继续推理。
