const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const projectRoot = path.resolve(__dirname, '..');
const portalDirectory = path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Portal');
const textureDirectory = path.join(portalDirectory, 'Texture');
const effectLibraryRoot = 'C:\\Users\\Administrator\\Desktop\\特效库';
const blueStarGamePath = 'resource\\textures\\Blue_Star2.blp';

const textureCopies = [
  {
    source: path.join(effectLibraryRoot, 'MapTest', 'file_000881', 'war3mapimported', 'flarer1white.blp'),
    destinationName: 'RicketVoidEscape_Flare.blp',
  },
  {
    source: path.join(effectLibraryRoot, 'MapTest', 'file_001133', 'war3mapImported', 'frostnova_light_white.blp'),
    destinationName: 'RicketVoidEscape_FrostNovaLightWhite.blp',
  },
  {
    source: path.join(effectLibraryRoot, 'MapTest', 'file_001133', 'war3mapImported', 'MG_Flare.blp'),
    destinationName: 'RicketVoidEscape_MGFlare.blp',
  },
  {
    source: path.join(effectLibraryRoot, 'MapTest', 'file_000711', 'Textures', 'white.blp'),
    destinationName: 'RicketVoidEscape_White.blp',
  },
  {
    source: path.join(effectLibraryRoot, 'AZ200个特效1', 'JNTX (230)', 'massteleportcircle.blp'),
    destinationName: 'PalaceSecretRoomTeleportCircle.blp',
  },
];

const modelMappings = [
  {
    source: path.join(effectLibraryRoot, '1200个整理好的特效', '传送', 'sem_chuan_song.mdx'),
    destinationName: 'RicketSecretRoomShift.mdx',
    modelName: 'RicketSecretRoomShift',
    texturePaths: [
      'Textures\\grad2d.blp',
      'Textures\\Star8c.blp',
    ],
  },
  {
    source: path.join(effectLibraryRoot, 'MapTest', 'file_001133', 'file_001133.mdx'),
    destinationName: 'RicketVoidEscape.mdx',
    modelName: 'RicketVoidEscape',
    texturePaths: [
      'Common\\Effect\\Form\\Portal\\Texture\\RicketVoidEscape_Flare.blp',
      'Common\\Effect\\Form\\Portal\\Texture\\RicketVoidEscape_FrostNovaLightWhite.blp',
      'Common\\Effect\\Form\\Portal\\Texture\\RicketVoidEscape_MGFlare.blp',
      'Common\\Effect\\Form\\Portal\\Texture\\RicketVoidEscape_White.blp',
    ],
  },
  {
    source: path.join(effectLibraryRoot, 'AZ200个特效1', 'JNTX (230)', 'JNTX (230).mdx'),
    destinationName: 'PalaceSecretRoomArrival.mdx',
    modelName: 'PalaceSecretRoomArrival',
    texturePaths: [
      'Textures\\GenericGlowX.blp',
      'Textures\\GenericGlow5.blp',
      'abilities\\Spells\\Human\\MassTeleport\\Rune1.blp',
      blueStarGamePath,
      'Common\\Effect\\Form\\Portal\\Texture\\PalaceSecretRoomTeleportCircle.blp',
    ],
  },
  {
    source: path.join(effectLibraryRoot, 'AZ200个特效1', 'JNTX (231)', 'JNTX (231).mdx'),
    destinationName: 'RoyalBloodlineGate.mdx',
    modelName: 'RoyalBloodlineGate',
    texturePaths: [
      'Textures\\GenericGlow2_64_blue.blp',
      'Textures\\GenericGlow5.blp',
      'abilities\\Spells\\Human\\MassTeleport\\Rune1.blp',
      blueStarGamePath,
      'Common\\Effect\\Form\\Portal\\Texture\\PalaceSecretRoomTeleportCircle.blp',
    ],
  },
];

function sha256(filePath) {
  return crypto.createHash('sha256').update(fs.readFileSync(filePath)).digest('hex').toUpperCase();
}

function verifyGameTexturePath(gamePath) {
  if (gamePath === blueStarGamePath) {
    const existingTexture = path.join(projectRoot, 'imports', ...gamePath.split('\\'));
    if (!fs.existsSync(existingTexture)) throw new Error(`Missing reused texture: ${existingTexture}`);
  }
}

for (const texture of textureCopies) {
  if (!fs.existsSync(texture.source)) throw new Error(`Missing source texture: ${texture.source}`);
}

for (const mapping of modelMappings) {
  if (!fs.existsSync(mapping.source)) throw new Error(`Missing source model: ${mapping.source}`);
}

fs.mkdirSync(textureDirectory, { recursive: true });
for (const texture of textureCopies) {
  fs.copyFileSync(texture.source, path.join(textureDirectory, texture.destinationName));
}

const result = [];
for (const mapping of modelMappings) {
  const model = new Model();
  model.loadMdx(fs.readFileSync(mapping.source));
  if (model.textures.length !== mapping.texturePaths.length) {
    throw new Error(`${mapping.destinationName}: expected ${mapping.texturePaths.length} textures, got ${model.textures.length}`);
  }

  model.name = mapping.modelName;
  mapping.texturePaths.forEach((texturePath, index) => {
    model.textures[index].path = texturePath;
    verifyGameTexturePath(texturePath);
  });

  const destination = path.join(portalDirectory, mapping.destinationName);
  fs.writeFileSync(destination, model.saveMdx());

  const verified = new Model();
  verified.loadMdx(fs.readFileSync(destination));
  const actualTexturePaths = verified.textures.map((texture) => texture.path);
  if (verified.name !== mapping.modelName || JSON.stringify(actualTexturePaths) !== JSON.stringify(mapping.texturePaths)) {
    throw new Error(`${mapping.destinationName}: migrated model verification failed`);
  }
  if (actualTexturePaths.some((texturePath) => texturePath.includes('imports\\') || texturePath.includes('Desktop'))) {
    throw new Error(`${mapping.destinationName}: source path remains in migrated model`);
  }

  result.push({
    model: path.relative(projectRoot, destination),
    bytes: fs.statSync(destination).size,
    sha256: sha256(destination),
    sequences: verified.sequences.map((sequence) => sequence.name),
    textures: actualTexturePaths,
  });
}

for (const texture of textureCopies) {
  const destination = path.join(textureDirectory, texture.destinationName);
  result.push({
    texture: path.relative(projectRoot, destination),
    bytes: fs.statSync(destination).size,
    sha256: sha256(destination),
  });
}

process.stdout.write(`${JSON.stringify(result, null, 2)}\n`);
