const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const sourceRoot = path.resolve(process.argv[2] || 'C:\\Users\\Administrator\\Desktop\\投射物');
const targetRoot = path.resolve(process.argv[3] || path.join(process.cwd(), 'imports', 'Common', 'Effect', 'Projectile'));
const textureRoot = path.join(targetRoot, 'Texture');

const nativeRoots = new Set([
  'textures',
  'replaceabletextures',
  'units',
  'ui',
  'abilities',
  'objects',
  'doodads',
  'environment',
  'terrainart',
  'sharedmodels',
  'sound',
  'models',
]);

function walk(root) {
  const result = [];
  for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
    const fullPath = path.join(root, entry.name);
    if (entry.isDirectory()) result.push(...walk(fullPath));
    else result.push(fullPath);
  }
  return result;
}

function hashFile(filePath) {
  return crypto.createHash('sha256').update(fs.readFileSync(filePath)).digest('hex').toUpperCase();
}

function safeName(name) {
  return name.replace(/[^A-Za-z0-9_.-]/g, '_').replace(/_+/g, '_').slice(0, 72);
}

function readCString(buffer, offset, maxLength) {
  let end = offset;
  const limit = offset + maxLength;
  while (end < limit && buffer[end] !== 0) end += 1;
  return buffer.subarray(offset, end).toString('utf8');
}

function writeTexturePath(buffer, offset, texturePath) {
  const encoded = Buffer.from(texturePath, 'utf8');
  if (encoded.length >= 260) throw new Error(`Texture path is too long: ${texturePath}`);
  buffer.fill(0, offset, offset + 260);
  encoded.copy(buffer, offset);
}

function parseTextureEntries(buffer) {
  if (buffer.toString('ascii', 0, 4) !== 'MDLX') return [];
  const entries = [];
  let offset = 4;
  while (offset + 8 <= buffer.length) {
    const tag = buffer.toString('ascii', offset, offset + 4);
    const size = buffer.readUInt32LE(offset + 4);
    const dataStart = offset + 8;
    const dataEnd = dataStart + size;
    if (dataEnd > buffer.length) throw new Error(`Invalid MDX chunk ${tag}`);
    if (tag === 'TEXS') {
      const entrySize = 268;
      if (size % entrySize !== 0) throw new Error(`Invalid TEXS size: ${size}`);
      for (let cursor = dataStart; cursor < dataEnd; cursor += entrySize) {
        entries.push({ path: readCString(buffer, cursor + 4, 260), pathOffset: cursor + 4 });
      }
    }
    offset = dataEnd;
  }
  return entries;
}

function findCaseInsensitive(root, relativePath) {
  const parts = relativePath.split(/[\\/]+/).filter(Boolean);
  let current = root;
  for (const part of parts) {
    if (!fs.existsSync(current) || !fs.statSync(current).isDirectory()) return null;
    const match = fs.readdirSync(current).find((name) => name.toLowerCase() === part.toLowerCase());
    if (!match) return null;
    current = path.join(current, match);
  }
  return fs.existsSync(current) && fs.statSync(current).isFile() ? current : null;
}

function isNativePath(texturePath) {
  const firstPart = texturePath.split(/[\\/]/)[0].toLowerCase();
  return nativeRoots.has(firstPart);
}

function sourceTag(modelPath) {
  const relative = path.relative(sourceRoot, modelPath).split(path.sep);
  const parts = relative.slice(0, -1).map(safeName).filter(Boolean);
  return parts.length ? parts.slice(-2).join('_') : 'root';
}

function chooseModelPath(modelPath, usedNames) {
  const original = path.basename(modelPath);
  const originalKey = original.toLowerCase();
  const existing = new Set(fs.readdirSync(targetRoot).map((name) => name.toLowerCase()));
  if (!existing.has(originalKey) && !usedNames.has(originalKey)) {
    usedNames.add(originalKey);
    return path.join(targetRoot, original);
  }
  const extension = path.extname(original);
  const stem = path.basename(original, extension);
  const tag = sourceTag(modelPath);
  let index = 1;
  while (true) {
    const candidate = `${stem}__src_${tag}${index > 1 ? `_${index}` : ''}${extension}`;
    const key = candidate.toLowerCase();
    if (!existing.has(key) && !usedNames.has(key)) {
      usedNames.add(key);
      return path.join(targetRoot, candidate);
    }
    index += 1;
  }
}

function existingTextureByHash() {
  const result = new Map();
  if (!fs.existsSync(textureRoot)) return result;
  for (const file of walk(textureRoot)) {
    if (path.extname(file).toLowerCase() !== '.blp') continue;
    const hash = hashFile(file);
    if (!result.has(hash)) result.set(hash, file);
  }
  return result;
}

fs.mkdirSync(targetRoot, { recursive: true });
fs.mkdirSync(textureRoot, { recursive: true });

const reportPath = path.join(targetRoot, '投射物迁移清单.md');
const previousTargets = new Map();
if (fs.existsSync(reportPath)) {
  const reportLines = fs.readFileSync(reportPath, 'utf8').split(/\r?\n/);
  let currentTarget = null;
  for (const line of reportLines) {
    if (line.startsWith('## ')) currentTarget = line.slice(3).trim();
    else if (currentTarget && line.startsWith('- 源：`') && line.endsWith('`')) {
      const source = line.slice('- 源：`'.length, -1);
      previousTargets.set(source, currentTarget);
    }
  }
}

const models = walk(sourceRoot).filter((file) => path.extname(file).toLowerCase() === '.mdx');
const usedNames = new Set();
const textureByHash = existingTextureByHash();
const copiedTextures = new Map();
const report = [];
let copiedModels = 0;
let reusedModels = 0;
let rewrittenPaths = 0;
let nativePaths = 0;
let unresolvedPaths = 0;

for (const modelPath of models) {
  const originalBuffer = fs.readFileSync(modelPath);
  const buffer = Buffer.from(originalBuffer);
  const textureEntries = parseTextureEntries(buffer);
  const modelReport = {
    source: path.relative(sourceRoot, modelPath),
    target: null,
    native: [],
    rewritten: [],
    unresolved: [],
  };

  for (const entry of textureEntries) {
    const texturePath = entry.path;
    if (!texturePath) continue;
    if (isNativePath(texturePath)) {
      nativePaths += 1;
      modelReport.native.push(texturePath);
      continue;
    }

    const sourceTexture = findCaseInsensitive(path.dirname(modelPath), texturePath);
    if (!sourceTexture) {
      unresolvedPaths += 1;
      modelReport.unresolved.push(texturePath);
      continue;
    }

    const hash = hashFile(sourceTexture);
    let targetTexture = textureByHash.get(hash) || copiedTextures.get(hash);
    if (!targetTexture) {
      const sourceName = path.basename(sourceTexture);
      const targetName = `ptl_${hash.slice(0, 12)}_${safeName(sourceName)}`;
      targetTexture = path.join(textureRoot, targetName);
      fs.copyFileSync(sourceTexture, targetTexture);
      copiedTextures.set(hash, targetTexture);
      textureByHash.set(hash, targetTexture);
    }
    const gamePath = path.relative(process.cwd(), targetTexture).replaceAll(path.sep, '\\');
    writeTexturePath(buffer, entry.pathOffset, gamePath);
    rewrittenPaths += 1;
    modelReport.rewritten.push(`${texturePath} -> ${gamePath}`);
  }

  const relativeSource = path.relative(sourceRoot, modelPath).replaceAll(path.sep, '\\');
  const previousTarget = previousTargets.get(relativeSource);
  const targetModel = previousTarget
    ? path.resolve(process.cwd(), previousTarget)
    : chooseModelPath(modelPath, usedNames);
  if (fs.existsSync(targetModel)) reusedModels += 1;
  else copiedModels += 1;
  fs.writeFileSync(targetModel, buffer);
  modelReport.target = path.relative(process.cwd(), targetModel).replaceAll(path.sep, '\\');
  report.push(modelReport);
}

const lines = [
  '# 投射物资源迁移清单',
  '',
  `- 源目录：\`${sourceRoot}\``,
  `- 目标目录：\`${path.relative(process.cwd(), targetRoot).replaceAll(path.sep, '\\')}\``,
  `- 新复制模型：${copiedModels}`,
  `- 已复用迁移模型：${reusedModels}`,
  `- 私有贴图重写：${rewrittenPaths}`,
  `- 原生贴图保留：${nativePaths}`,
  `- 未解析贴图：${unresolvedPaths}`,
  '',
  '> 源目录未删除。模型同名时使用 `__src_...` 后缀，避免覆盖项目原有文件。',
  '> `Textures\\`、`ReplaceableTextures\\`、`Units\\`、`UI\\`、`Abilities\\` 等原生路径未改写。',
  '',
];
for (const item of report) {
  lines.push(`## ${item.target}`);
  lines.push(`- 源：\`${item.source}\``);
  if (item.rewritten.length) {
    lines.push('- 私有贴图：');
    for (const value of item.rewritten) lines.push(`  - \`${value}\``);
  }
  if (item.native.length) lines.push(`- 保留原生贴图：${item.native.map((value) => `\`${value}\``).join(', ')}`);
  if (item.unresolved.length) lines.push(`- 未解析贴图：${item.unresolved.map((value) => `\`${value}\``).join(', ')}`);
  lines.push('');
}
fs.writeFileSync(reportPath, `${lines.join('\n')}\n`, 'utf8');

console.log(JSON.stringify({
  sourceRoot,
  targetRoot,
  copiedModels,
  copiedTextures: copiedTextures.size,
  rewrittenPaths,
  nativePaths,
  unresolvedPaths,
  reportPath,
}, null, 2));
