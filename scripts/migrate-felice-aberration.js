const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}
const textureConvertLibraryPath = process.env.WAR3_TEXTURE_CONVERT_LIB;
if (!textureConvertLibraryPath) {
  throw new Error('WAR3_TEXTURE_CONVERT_LIB must point to war3-texture-preview/out/conversion/textureConvert.js');
}

const Model = require(modelLibraryPath).default;
const { decodeTextureBuffer, encodeTextureBuffer } = require(textureConvertLibraryPath);
const sanityTest = require(path.resolve(
  path.dirname(modelLibraryPath),
  '..', '..', 'utils', 'mdlx', 'sanitytest', 'sanitytest.js',
)).default;

const projectRoot = path.resolve(__dirname, '..');
const sourceRoot = 'C:\\Users\\Administrator\\Desktop\\宜兴华';
const sourceModelPath = path.join(sourceRoot, '7.mdx');
const sourceTexturePath = path.join(sourceRoot, 'war3mapImported', 'hidden zombie_index.blp');
const modelPath = path.join(projectRoot, 'imports', 'Boss', 'Felice', 'FeliceAberration.mdx');
const texturePath = path.join(projectRoot, 'imports', 'Boss', 'Felice', 'Texture', 'FeliceAberration_Index.blp');
const gameTexturePath = 'Boss\\Felice\\Texture\\FeliceAberration_Index.blp';

function loadModel(filePath) {
  const data = fs.readFileSync(filePath);
  const model = new Model();
  model.loadMdx(data);
  return model;
}

function cloneTrackValue(value) {
  return new value.constructor(value);
}

function collectAnimations(root) {
  const animations = [];
  const visited = new WeakSet();
  const stack = [root];
  while (stack.length > 0) {
    const value = stack.pop();
    if (!value || typeof value !== 'object' || ArrayBuffer.isView(value) || visited.has(value)) continue;
    visited.add(value);
    if (Array.isArray(value.animations)) animations.push(...value.animations);
    for (const [key, child] of Object.entries(value)) {
      if (key === 'animations' || !child || typeof child !== 'object' || ArrayBuffer.isView(child)) continue;
      if (Array.isArray(child)) stack.push(...child);
      else stack.push(child);
    }
  }
  return animations;
}

function repairAnimationOpeningTracks(model) {
  let repairCount = 0;
  for (const animation of collectAnimations(model)) {
    if (!Array.isArray(animation.frames) || animation.frames.length === 0 || animation.globalSequenceId !== -1) continue;
    for (const sequence of model.sequences) {
      const start = sequence.interval[0];
      const end = sequence.interval[1];
      if (animation.frames.includes(start)) continue;
      const firstIndex = animation.frames.findIndex((frame) => frame > start && frame <= end);
      if (firstIndex === -1) continue;
      animation.frames.splice(firstIndex, 0, start);
      animation.values.splice(firstIndex, 0, cloneTrackValue(animation.values[firstIndex]));
      if (animation.interpolationType > 1) {
        animation.inTans.splice(firstIndex, 0, cloneTrackValue(animation.inTans[firstIndex]));
        animation.outTans.splice(firstIndex, 0, cloneTrackValue(animation.outTans[firstIndex]));
      }
      repairCount += 1;
    }
  }
  return repairCount;
}

function downsampleHalf(image) {
  const width = Math.max(1, Math.floor(image.width / 2));
  const height = Math.max(1, Math.floor(image.height / 2));
  const rgba = new Uint8ClampedArray(width * height * 4);
  for (let y = 0; y < height; y += 1) {
    for (let x = 0; x < width; x += 1) {
      const destination = (y * width + x) * 4;
      for (let channel = 0; channel < 4; channel += 1) {
        let sum = 0;
        for (let offsetY = 0; offsetY < 2; offsetY += 1) {
          for (let offsetX = 0; offsetX < 2; offsetX += 1) {
            const source = (((y * 2 + offsetY) * image.width) + x * 2 + offsetX) * 4 + channel;
            sum += image.rgba[source];
          }
        }
        rgba[destination + channel] = Math.round(sum / 4);
      }
    }
  }
  return { width, height, rgba };
}

for (const requiredPath of [sourceModelPath, sourceTexturePath]) {
  if (!fs.existsSync(requiredPath)) throw new Error(`Missing source asset: ${requiredPath}`);
}

const model = loadModel(sourceModelPath);
if (model.textures.length !== 1 || model.textures[0].path !== 'war3mapImported\\hidden zombie_index.blp') {
  throw new Error(`Unexpected texture layout: ${model.textures.map((texture) => texture.path).join(', ')}`);
}

model.name = 'FeliceAberration';
model.textures[0].path = gameTexturePath;
const repairedOpeningTracks = repairAnimationOpeningTracks(model);
fs.mkdirSync(path.dirname(modelPath), { recursive: true });
fs.mkdirSync(path.dirname(texturePath), { recursive: true });
fs.writeFileSync(modelPath, model.saveMdx());
const sourceTexture = decodeTextureBuffer(fs.readFileSync(sourceTexturePath), 'blp');
const projectTexture = sourceTexture.width > 256 || sourceTexture.height > 256
  ? downsampleHalf(sourceTexture)
  : sourceTexture;
fs.writeFileSync(texturePath, encodeTextureBuffer(projectTexture, 'blp'));

const verified = loadModel(modelPath);
const sanity = sanityTest(verified);
if (sanity.errors !== 0 || sanity.severe !== 0) {
  throw new Error(`Migrated model failed sanity: errors=${sanity.errors}, severe=${sanity.severe}`);
}
if (verified.textures[0].path !== gameTexturePath || !fs.existsSync(texturePath)) {
  throw new Error('Migrated model texture path verification failed');
}

console.log(JSON.stringify({
  modelPath,
  texturePath,
  textureReference: verified.textures[0].path,
  textureSize: [projectTexture.width, projectTexture.height],
  repairedOpeningTracks,
  sequences: verified.sequences.map((sequence) => sequence.name),
  sanity: {
    errors: sanity.errors,
    severe: sanity.severe,
    warnings: sanity.warnings,
    unused: sanity.unused,
  },
}, null, 2));
