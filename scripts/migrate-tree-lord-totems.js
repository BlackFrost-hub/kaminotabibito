const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..");
const sourceDirectory = path.join(projectRoot, "map", "resource", "war3mapImported");
const targetDirectory = path.join(projectRoot, "imports", "Common", "Effect", "Form", "Marker");
const targetTextureDirectory = path.join(targetDirectory, "Texture");
const gameTextureDirectory = "Common\\Effect\\Form\\Marker\\Texture";

const privateTextureMigrations = [
  { sourceName: "Totem1.blp", targetName: "Totem1.blp" },
  { sourceName: "ShockRingCrescent.blp", targetName: "ShockRingCrescent.blp" },
  { sourceName: "ToonSmoke16_2.blp", targetName: "ToonSmoke16_2.blp" },
  { sourceName: "RIBBONBLUR1D.BLP", targetName: "RibbonBlur1D.blp" },
];

const modelMigrations = [
  {
    sourceName: "SentryTotem.mdx",
    targetName: "SentryTotem.mdx",
    textureReplacements: {
      "war3mapImported\\TOTEM1.BLP": `${gameTextureDirectory}\\Totem1.blp`,
      "war3mapImported\\SHOCKRINGCRESCENT.BLP": `${gameTextureDirectory}\\ShockRingCrescent.blp`,
      "war3mapImported\\TOONSMOKE16_2.BLP": `${gameTextureDirectory}\\ToonSmoke16_2.blp`,
    },
  },
  {
    sourceName: "FireTotem.mdx",
    targetName: "FireTotem.mdx",
    textureReplacements: {
      "war3mapImported\\TOTEM1.BLP": `${gameTextureDirectory}\\Totem1.blp`,
      "war3mapImported\\RIBBONBLUR1D.BLP": `${gameTextureDirectory}\\RibbonBlur1D.blp`,
    },
  },
];

function assertFile(filePath) {
  if (!fs.existsSync(filePath) || !fs.statSync(filePath).isFile()) {
    throw new Error(`Missing required asset: ${filePath}`);
  }
}

function sha256(filePath) {
  return crypto.createHash("sha256").update(fs.readFileSync(filePath)).digest("hex");
}

function readCString(buffer, offset, maxLength) {
  const end = buffer.indexOf(0, offset);
  const safeEnd = end === -1 || end > offset + maxLength ? offset + maxLength : end;
  return buffer.subarray(offset, safeEnd).toString("utf8");
}

function readTextureSlots(modelPath) {
  const buffer = fs.readFileSync(modelPath);
  if (buffer.toString("ascii", 0, 4) !== "MDLX") {
    throw new Error(`Invalid MDX header: ${modelPath}`);
  }

  const slots = [];
  let offset = 4;
  while (offset + 8 <= buffer.length) {
    const chunkId = buffer.toString("ascii", offset, offset + 4);
    const chunkSize = buffer.readUInt32LE(offset + 4);
    const chunkStart = offset + 8;
    const chunkEnd = chunkStart + chunkSize;
    if (chunkEnd > buffer.length) {
      throw new Error(`Invalid ${chunkId} chunk length: ${modelPath}`);
    }
    if (chunkId === "TEXS") {
      if (chunkSize % 268 !== 0) {
        throw new Error(`Unexpected TEXS record size: ${modelPath}`);
      }
      for (let textureOffset = chunkStart; textureOffset < chunkEnd; textureOffset += 268) {
        slots.push({
          pathOffset: textureOffset + 4,
          path: readCString(buffer, textureOffset + 4, 260),
        });
      }
    }
    offset = chunkEnd;
  }
  if (offset !== buffer.length) {
    throw new Error(`Trailing MDX data is not chunk-aligned: ${modelPath}`);
  }
  return { buffer, slots };
}

function writeTexturePath(buffer, pathOffset, texturePath) {
  const bytes = Buffer.from(texturePath, "utf8");
  if (bytes.length >= 260) {
    throw new Error(`Texture path exceeds MDX slot: ${texturePath}`);
  }
  buffer.fill(0, pathOffset, pathOffset + 260);
  bytes.copy(buffer, pathOffset);
}

function migrateModel(migration) {
  const sourcePath = path.join(sourceDirectory, migration.sourceName);
  const targetPath = path.join(targetDirectory, migration.targetName);
  assertFile(sourcePath);
  if (fs.existsSync(targetPath)) {
    throw new Error(`Target model already exists: ${targetPath}`);
  }

  const source = readTextureSlots(sourcePath);
  const replacements = migration.textureReplacements;
  const actualPaths = source.slots.map((slot) => slot.path);
  for (const oldPath of Object.keys(replacements)) {
    if (!actualPaths.includes(oldPath)) {
      throw new Error(`Expected texture reference is missing from ${migration.sourceName}: ${oldPath}`);
    }
  }

  for (const slot of source.slots) {
    const replacement = replacements[slot.path];
    if (replacement != null) writeTexturePath(source.buffer, slot.pathOffset, replacement);
  }
  fs.writeFileSync(targetPath, source.buffer);

  const verified = readTextureSlots(targetPath);
  const verifiedPaths = verified.slots.map((slot) => slot.path);
  for (const newPath of Object.values(replacements)) {
    if (!verifiedPaths.includes(newPath)) {
      throw new Error(`Migrated texture reference is missing from ${migration.targetName}: ${newPath}`);
    }
  }
  if (verifiedPaths.some((texturePath) => /^war3mapImported\\/i.test(texturePath))) {
    throw new Error(`Migrated model still references a private import path: ${targetPath}`);
  }

  return {
    sourcePath,
    targetPath,
    byteLength: fs.statSync(targetPath).size,
    sha256: sha256(targetPath),
    textures: verifiedPaths,
  };
}

function migrateTexture(migration) {
  const sourcePath = path.join(sourceDirectory, migration.sourceName);
  const targetPath = path.join(targetTextureDirectory, migration.targetName);
  assertFile(sourcePath);
  if (fs.existsSync(targetPath)) {
    throw new Error(`Target texture already exists: ${targetPath}`);
  }
  fs.copyFileSync(sourcePath, targetPath);
  if (sha256(sourcePath) !== sha256(targetPath)) {
    throw new Error(`Texture checksum verification failed: ${migration.targetName}`);
  }
  return {
    sourcePath,
    targetPath,
    byteLength: fs.statSync(targetPath).size,
    sha256: sha256(targetPath),
  };
}

function main() {
  fs.mkdirSync(targetDirectory, { recursive: true });
  fs.mkdirSync(targetTextureDirectory, { recursive: true });
  const textures = privateTextureMigrations.map(migrateTexture);
  const models = modelMigrations.map(migrateModel);
  console.log(JSON.stringify({ models, textures }, null, 2));
}

main();
