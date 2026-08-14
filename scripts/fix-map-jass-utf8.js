const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");

const projectRoot = path.resolve(__dirname, "..");
const mapPath = path.join(projectRoot, "map.w3x");
const defaultW2lPath = "F:\\1.9.4k3_雪月编辑器\\plugin\\w3x2lni_zhCN_v2.7.3\\w2l.exe";
const w2lPath = process.env.W2L_PATH || defaultW2lPath;

function runW2l(args) {
  const result = spawnSync(w2lPath, args, {
    cwd: projectRoot,
    stdio: "inherit",
    windowsHide: true,
  });
  if (result.error) throw result.error;
  if (result.status !== 0) {
    throw new Error("w2l failed with exit code " + result.status + ": " + args[0]);
  }
}

function decodeUtf8Strict(bytes) {
  return new TextDecoder("utf-8", { fatal: true }).decode(bytes);
}

function normalizeMixedJass(jassPath) {
  const source = fs.readFileSync(jassPath);
  const utf8Decoder = new TextDecoder("utf-8", { fatal: true });
  const gbkDecoder = new TextDecoder("gbk", { fatal: true });
  const utf8Encoder = new TextEncoder();
  const output = [];
  let lineStart = 0;
  let convertedLines = 0;

  for (let index = 0; index <= source.length; index++) {
    if (index < source.length && source[index] !== 0x0a) continue;

    const hasCarriageReturn = index > lineStart && source[index - 1] === 0x0d;
    const lineEnd = hasCarriageReturn ? index - 1 : index;
    const line = source.subarray(lineStart, lineEnd);

    try {
      utf8Decoder.decode(line);
      output.push(line);
    } catch (_) {
      const decoded = gbkDecoder.decode(line);
      output.push(Buffer.from(utf8Encoder.encode(decoded)));
      convertedLines++;
    }

    if (index < source.length) {
      output.push(Buffer.from(hasCarriageReturn ? "\r\n" : "\n"));
    }
    lineStart = index + 1;
  }

  if (convertedLines > 0) fs.writeFileSync(jassPath, Buffer.concat(output));
  return convertedLines;
}

function validateJass(jassPath) {
  const text = decodeUtf8Strict(fs.readFileSync(jassPath));
  if (!text.includes("function main takes nothing returns nothing")) {
    throw new Error("war3map.j is missing the main function");
  }
  if (!text.includes("function config takes nothing returns nothing")) {
    throw new Error("war3map.j is missing the config function");
  }
}

function timestamp() {
  return new Date().toISOString().replace(/[-:]/g, "").replace(/[TZ.]/g, "_");
}

function main() {
  if (!fs.existsSync(mapPath)) throw new Error("Map not found: " + mapPath);
  if (!fs.existsSync(w2lPath)) throw new Error("w2l not found: " + w2lPath);

  const temporaryRoot = fs.mkdtempSync(path.join(os.tmpdir(), "syzl-map-jass-utf8-"));
  const unpackedPath = path.join(temporaryRoot, "unpacked");
  const verificationPath = path.join(temporaryRoot, "verification");
  const fixedMapPath = path.join(temporaryRoot, "map_utf8.w3x");

  try {
    runW2l(["unpack", mapPath, unpackedPath]);
    const unpackedJassPath = path.join(unpackedPath, "war3map.j");
    const convertedLines = normalizeMixedJass(unpackedJassPath);
    validateJass(unpackedJassPath);

    if (convertedLines === 0) {
      console.log("fix-map-jass-utf8: map.w3x war3map.j is already valid UTF-8.");
      return;
    }

    runW2l(["pack", unpackedPath, fixedMapPath]);
    runW2l(["unpack", fixedMapPath, verificationPath]);
    validateJass(path.join(verificationPath, "war3map.j"));

    const backupPath = path.join(os.tmpdir(), "syzl_map_before_jass_utf8_" + timestamp() + ".w3x");
    fs.copyFileSync(mapPath, backupPath);
    fs.copyFileSync(fixedMapPath, mapPath);

    console.log("fix-map-jass-utf8: converted " + convertedLines + " line(s).");
    console.log("fix-map-jass-utf8: backup: " + backupPath);
  } finally {
    fs.rmSync(temporaryRoot, { recursive: true, force: true });
  }
}

main();
