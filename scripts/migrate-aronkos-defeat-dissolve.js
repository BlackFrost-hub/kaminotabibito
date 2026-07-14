const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const libraryDirectory = path.dirname(modelLibraryPath);
const Sequence = require(path.join(libraryDirectory, 'sequence.js')).default;

const sourceDirectory = 'C:\\Users\\Administrator\\Desktop\\1111';
const sourceModelPath = path.join(sourceDirectory, 'sem_lan_huo.mdx');
const projectRoot = path.resolve(__dirname, '..');
const outputDirectory = path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'RiseFall');
const textureDirectory = path.join(outputDirectory, 'Texture');
const outputModelPath = path.join(outputDirectory, 'AronkosDefeatDissolve.mdx');
const textureMappings = [
  {
    index: 0,
    source: path.join(sourceDirectory, 'z_tt_se_qq_qun_941442872_sem_yin_fu_tt1.blp'),
    destinationName: 'AronkosDefeatDissolve_01.blp',
  },
  {
    index: 4,
    source: path.join(sourceDirectory, 'Textures', 'Flare.blp'),
    destinationName: 'AronkosDefeatDissolve_02.blp',
  },
];

for (const filePath of [sourceModelPath, ...textureMappings.map((mapping) => mapping.source)]) {
  if (!fs.existsSync(filePath)) throw new Error(`Missing exported source asset: ${filePath}`);
}

const model = new Model();
model.loadMdx(fs.readFileSync(sourceModelPath));
model.name = 'AronkosDefeatDissolve';

const birth = model.sequences[0];
birth.name = 'Birth';
birth.nonLooping = 1;
birth.extent.min.set([-200, -200, -50]);
birth.extent.max.set([200, 200, 450]);
birth.extent.boundsRadius = 500;
model.extent.min.set([-200, -200, -50]);
model.extent.max.set([200, 200, 450]);
model.extent.boundsRadius = 500;

function addCleanupSequence(name, start, end) {
  const sequence = new Sequence();
  sequence.name = name;
  sequence.interval.set([start, end]);
  sequence.nonLooping = 1;
  sequence.extent.min.set(model.extent.min);
  sequence.extent.max.set(model.extent.max);
  sequence.extent.boundsRadius = model.extent.boundsRadius;
  model.sequences.push(sequence);
}

addCleanupSequence('Stand', 8600, 8700);
addCleanupSequence('Death', 8800, 9000);

for (const [index, emitter] of model.particleEmitters2.entries()) {
  const emissionTrack = emitter.animations.find((animation) => animation.name === 'KP2E');
  if (emissionTrack) {
    for (const value of emissionTrack.values) value[0] *= (index === 10 || index === 13) ? 0 : 0.52;
  }
  emitter.speed *= index === 12 ? 0.38 : 0.7;
  emitter.variation *= 0.75;
  for (let segment = 0; segment < emitter.segmentAlphas.length; segment += 1) {
    emitter.segmentAlphas[segment] = Math.round(emitter.segmentAlphas[segment] * 0.68);
  }
  for (let segment = 0; segment < emitter.segmentScaling.length; segment += 1) {
    emitter.segmentScaling[segment] *= (index === 11 || index === 12) ? 0.55 : 0.7;
  }
  for (const color of emitter.segmentColors) {
    color[0] = Math.min(0.78, color[0] * 0.76 + 0.08);
    color[1] = Math.min(0.9, color[1] * 0.82 + 0.08);
    color[2] = Math.min(1, color[2] * 0.9 + 0.08);
  }
}

fs.mkdirSync(textureDirectory, { recursive: true });
for (const mapping of textureMappings) {
  const destination = path.join(textureDirectory, mapping.destinationName);
  fs.copyFileSync(mapping.source, destination);
  model.textures[mapping.index].path = `Common\\Effect\\Form\\RiseFall\\Texture\\${mapping.destinationName}`;
}

fs.mkdirSync(outputDirectory, { recursive: true });
fs.writeFileSync(outputModelPath, model.saveMdx());

const verified = new Model();
verified.loadMdx(fs.readFileSync(outputModelPath));
if (verified.name !== 'AronkosDefeatDissolve' || verified.sequences.map((sequence) => sequence.name).join(',') !== 'Birth,Stand,Death') {
  throw new Error('Migrated Aronkos defeat model failed structural verification');
}

process.stdout.write(JSON.stringify({
  sourceModelPath,
  outputModelPath,
  bytes: fs.statSync(outputModelPath).size,
  sequences: verified.sequences.map((sequence) => sequence.name),
  particleEmitters2: verified.particleEmitters2.length,
  textures: verified.textures.map((texture) => texture.path),
}, null, 2));
