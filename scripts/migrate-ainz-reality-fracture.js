const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const projectRoot = path.resolve(__dirname, '..');
const sourceModelPath = 'C:\\Users\\Administrator\\Desktop\\特效（特效w3x整合出来的）\\tx131.mdx';
const outputDirectory = path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Line');
const textureDirectory = path.join(outputDirectory, 'Texture');
const outputModelPath = path.join(outputDirectory, 'AinzRealityFracture.mdx');
const textureMappings = [
  {
    index: 0,
    source: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Element', 'Ice', 'Texture', 'Dust3x.blp'),
    destinationName: 'AinzRealityFracture_01.blp',
  },
  {
    index: 1,
    source: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Element', 'Nature', 'Texture', 'firering1A.blp'),
    destinationName: 'AinzRealityFracture_02.blp',
  },
  {
    index: 2,
    source: 'C:\\Users\\Administrator\\Desktop\\特效（特效w3x整合出来的）\\ribbonne1_white.blp',
    destinationName: 'AinzRealityFracture_03.blp',
  },
  {
    index: 3,
    source: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Element', 'Ice', 'Texture', 'White_64_Foam1.blp'),
    destinationName: 'AinzRealityFracture_04.blp',
  },
];

for (const filePath of [sourceModelPath, ...textureMappings.map((mapping) => mapping.source)]) {
  if (!fs.existsSync(filePath)) throw new Error(`Missing Reality Fracture source asset: ${filePath}`);
}

const model = new Model();
model.loadMdx(fs.readFileSync(sourceModelPath));
if (model.textures.length !== textureMappings.length) {
  throw new Error(`Expected ${textureMappings.length} textures, found ${model.textures.length}`);
}

model.name = 'AinzRealityFracture';
fs.mkdirSync(textureDirectory, { recursive: true });
for (const mapping of textureMappings) {
  const destination = path.join(textureDirectory, mapping.destinationName);
  fs.copyFileSync(mapping.source, destination);
  model.textures[mapping.index].path = `Common\\Effect\\Form\\Line\\Texture\\${mapping.destinationName}`;
}

fs.mkdirSync(outputDirectory, { recursive: true });
fs.writeFileSync(outputModelPath, model.saveMdx());

const verified = new Model();
verified.loadMdx(fs.readFileSync(outputModelPath));
const expectedTexturePaths = textureMappings.map(
  (mapping) => `Common\\Effect\\Form\\Line\\Texture\\${mapping.destinationName}`,
);
const actualTexturePaths = verified.textures.map((texture) => texture.path);
if (verified.name !== 'AinzRealityFracture') {
  throw new Error(`Unexpected migrated model name: ${verified.name}`);
}
if (JSON.stringify(actualTexturePaths) !== JSON.stringify(expectedTexturePaths)) {
  throw new Error(`Migrated texture paths differ: ${JSON.stringify(actualTexturePaths)}`);
}
for (const texturePath of actualTexturePaths) {
  const diskPath = path.join(projectRoot, 'imports', ...texturePath.split('\\'));
  if (!fs.existsSync(diskPath)) throw new Error(`Migrated texture is missing: ${diskPath}`);
}

process.stdout.write(JSON.stringify({
  sourceModelPath,
  outputModelPath,
  bytes: fs.statSync(outputModelPath).size,
  sequences: verified.sequences.map((sequence) => sequence.name),
  textures: actualTexturePaths,
}, null, 2));
