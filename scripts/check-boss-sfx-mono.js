const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const projectRoot = path.resolve(__dirname, "..");
const bossSoundRoot = path.join(projectRoot, "imports", "Sound", "Boss");
const audioExtensions = new Set([".mp3", ".wav", ".ogg", ".flac", ".m4a"]);

function collectBossSfxFiles(directory, insideSfx, result) {
  const entries = fs.readdirSync(directory, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      collectBossSfxFiles(fullPath, insideSfx || entry.name.toLowerCase() === "sfx", result);
      continue;
    }
    if (!insideSfx || !entry.isFile()) continue;
    if (audioExtensions.has(path.extname(entry.name).toLowerCase())) result.push(fullPath);
  }
}

function probeAudio(filePath) {
  const probe = spawnSync("ffprobe", [
    "-v", "error",
    "-select_streams", "a:0",
    "-show_entries", "stream=codec_name,sample_rate,channels,channel_layout,bit_rate",
    "-of", "json",
    filePath,
  ], { encoding: "utf8", windowsHide: true });

  if (probe.error) throw new Error("无法启动 ffprobe：" + probe.error.message);
  if (probe.status !== 0) throw new Error((probe.stderr || "ffprobe 读取失败").trim());

  const parsed = JSON.parse(probe.stdout);
  if (!Array.isArray(parsed.streams) || parsed.streams.length === 0) {
    throw new Error("没有音频流");
  }
  return parsed.streams[0];
}

function relativePath(filePath) {
  return path.relative(projectRoot, filePath).replace(/\\/g, "/");
}

function convertToMono(record) {
  const filePath = record.filePath;
  const extension = path.extname(filePath).toLowerCase();
  if (extension !== ".mp3") throw new Error("自动修复当前只支持 MP3：" + relativePath(filePath));

  const temporaryPath = filePath.slice(0, -extension.length) + ".mono.tmp" + extension;
  const convert = spawnSync("ffmpeg", [
    "-v", "error",
    "-y",
    "-i", filePath,
    "-map_metadata", "0",
    "-ac", "1",
    "-ar", record.stream.sample_rate || "44100",
    "-b:a", record.stream.bit_rate || "64000",
    temporaryPath,
  ], { encoding: "utf8", windowsHide: true });

  if (convert.error) throw new Error("无法启动 ffmpeg：" + convert.error.message);
  if (convert.status !== 0) {
    if (fs.existsSync(temporaryPath)) fs.unlinkSync(temporaryPath);
    throw new Error((convert.stderr || "ffmpeg 转码失败").trim());
  }

  const verified = probeAudio(temporaryPath);
  if (verified.channels !== 1) {
    fs.unlinkSync(temporaryPath);
    throw new Error("转码结果仍非单声道：" + relativePath(filePath));
  }
  fs.renameSync(temporaryPath, filePath);
}

function main() {
  if (!fs.existsSync(bossSoundRoot)) throw new Error("Boss 音效目录不存在：" + bossSoundRoot);

  const files = [];
  collectBossSfxFiles(bossSoundRoot, false, files);
  files.sort((left, right) => left.localeCompare(right, "en"));

  const mono = [];
  const nonMono = [];
  const failed = [];
  const bossStats = new Map();

  for (const filePath of files) {
    const bossName = path.relative(bossSoundRoot, filePath).split(path.sep)[0];
    const stats = bossStats.get(bossName) || { total: 0, mono: 0, nonMono: 0, failed: 0 };
    stats.total += 1;
    bossStats.set(bossName, stats);

    try {
      const stream = probeAudio(filePath);
      const record = { filePath, stream };
      if (stream.channels === 1) {
        mono.push(record);
        stats.mono += 1;
      } else {
        nonMono.push(record);
        stats.nonMono += 1;
      }
    } catch (error) {
      failed.push({ filePath, error: error instanceof Error ? error.message : String(error) });
      stats.failed += 1;
    }
  }

  console.log("Boss SFX 单声道检查");
  console.log(`扫描=${files.length} 单声道=${mono.length} 非单声道=${nonMono.length} 读取失败=${failed.length}`);
  console.log("");
  console.log("按 Boss 汇总：");
  for (const [bossName, stats] of [...bossStats.entries()].sort()) {
    console.log(`  ${bossName}: 总数=${stats.total} 单声道=${stats.mono} 非单声道=${stats.nonMono} 失败=${stats.failed}`);
  }

  if (nonMono.length > 0) {
    console.log("");
    console.log("非单声道文件：");
    for (const record of nonMono) {
      const stream = record.stream;
      console.log(`  [${stream.channels}ch/${stream.channel_layout || "unknown"}] ${relativePath(record.filePath)}`);
    }
  }

  if (process.argv.includes("--fix") && nonMono.length > 0) {
    console.log("");
    console.log("开始转换非单声道 Boss SFX...");
    let fixed = 0;
    for (const record of nonMono) {
      convertToMono(record);
      fixed += 1;
      console.log(`  [${fixed}/${nonMono.length}] ${relativePath(record.filePath)}`);
    }
    console.log(`已转换 ${fixed} 个文件。请再次运行检查确认结果。`);
    return;
  }

  if (failed.length > 0) {
    console.log("");
    console.log("读取失败文件：");
    for (const record of failed) console.log(`  ${relativePath(record.filePath)}: ${record.error}`);
  }

  if (nonMono.length > 0 || failed.length > 0) process.exitCode = 1;
}

main();
