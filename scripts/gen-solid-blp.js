/**
 * 生成纯色 BLP2 无压缩纹理文件（War3 FDF 兼容）
 * 用法: node scripts/gen-solid-blp.js
 *
 * BLP2 无压缩（compression=0）：每个像素 4 字节 BGRA
 * 这是 War3 引擎最通用的纹理格式
 */
const fs = require("fs");
const path = require("path");

/**
 * 创建纯色 BLP2 无压缩文件
 * BLP2 header (140 bytes):
 *   0-3:   "BLP2" magic
 *   4-7:   flags (0x00000008)
 *   8-11:  compression (0 = uncompressed BGRA)
 *   12-15: width
 *   16-19: height
 *   20-23: extraFlag (0x00000008)
 *   24-27: pictureType (0x00000003)
 *   28-31: pictureSubType (0x00000001)
 *   32-95:  mipmapOffsets[16] (uint32 x 16)
 *   96-159: mipmapSizes[16]  (uint32 x 16)
 *   160+:   BGRA pixel data (row-major, bottom-to-top)
 */
function createSolidBlp2(r, g, b, a = 255, w = 4, h = 4) {
  const headerSize = 160;
  const dataSize = w * h * 4; // 4 bytes per pixel (BGRA)
  const buf = Buffer.alloc(headerSize + dataSize);
  let o = 0;

  // Magic
  buf.write("BLP2", o); o += 4;
  // Flags
  buf.writeUInt32LE(0x00000008, o); o += 4;
  // Compression: 0 = uncompressed
  buf.writeUInt32LE(0, o); o += 4;
  // Width & Height
  buf.writeUInt32LE(w, o); o += 4;
  buf.writeUInt32LE(h, o); o += 4;
  // extraFlag
  buf.writeUInt32LE(0x00000008, o); o += 4;
  // pictureType
  buf.writeUInt32LE(0x00000003, o); o += 4;
  // pictureSubType
  buf.writeUInt32LE(0x00000001, o); o += 4;

  // mipmapOffsets[16] — first level at offset headerSize
  buf.writeUInt32LE(headerSize, o); o += 4;
  for (let i = 1; i < 16; i++) {
    buf.writeUInt32LE(0, o); o += 4;
  }

  // mipmapSizes[16] — first level size
  buf.writeUInt32LE(dataSize, o); o += 4;
  for (let i = 1; i < 16; i++) {
    buf.writeUInt32LE(0, o); o += 4;
  }

  // Pixel data: BGRA, bottom-to-top row order
  for (let y = h - 1; y >= 0; y--) {
    for (let x = 0; x < w; x++) {
      buf.writeUInt8(b, o++);
      buf.writeUInt8(g, o++);
      buf.writeUInt8(r, o++);
      buf.writeUInt8(a, o++);
    }
  }

  return buf;
}

const outDir = path.join(__dirname, "..", "imports", "war3mapImported");
const buildDir = path.join(__dirname, "..", ".build", "_warcraft_vscode_test", "resource", "war3mapImported");

// Track: 4x4 gold
const track = createSolidBlp2(255, 215, 0, 255, 4, 4);
fs.writeFileSync(path.join(outDir, "scrollbar-track-gold.blp"), track);
console.log("Created scrollbar-track-gold.blp (4x4, " + track.length + " bytes)");

// Thumb: 4x4 blue
const thumb = createSolidBlp2(68, 136, 255, 255, 4, 4);
fs.writeFileSync(path.join(outDir, "scrollbar-thumb-blue.blp"), thumb);
console.log("Created scrollbar-thumb-blue.blp (4x4, " + thumb.length + " bytes)");

// Copy to build output directory
try {
  fs.mkdirSync(buildDir, { recursive: true });
  fs.writeFileSync(path.join(buildDir, "scrollbar-track-gold.blp"), track);
  fs.writeFileSync(path.join(buildDir, "scrollbar-thumb-blue.blp"), thumb);
  console.log("Copied to build output: " + buildDir);
} catch (e) {
  console.log("Could not copy to build dir: " + e.message);
}
