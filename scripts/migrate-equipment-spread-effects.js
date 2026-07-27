const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const projectRoot = path.resolve(__dirname, '..');

function sha256(filePath) {
  return crypto.createHash('sha256').update(fs.readFileSync(filePath)).digest('hex').toUpperCase();
}

function copyTexture(source, relativeDestination) {
  const destination = path.join(projectRoot, 'imports', ...relativeDestination.split('/'));
  fs.mkdirSync(path.dirname(destination), { recursive: true });
  if (fs.existsSync(destination) && sha256(destination) !== sha256(source)) {
    throw new Error(`Refusing to overwrite a different texture: ${destination}`);
  }
  if (!fs.existsSync(destination)) fs.copyFileSync(source, destination);
  return destination;
}

const migrations = [
  {
    name: 'BlueSoulFlashSpread',
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001339\\file_001339.mdx',
    destination: 'Common/Effect/Form/Spread/BlueSoulFlashSpread.mdx',
    textureMappings: [
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_000818\\Textures\\Shockwave10.blp', 'Common/Effect/Form/Spread/Texture/BlueSoulFlashSpread_Shockwave.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001339\\war3mapimported\\BlueLens.blp', 'Common/Effect/Form/Spread/Texture/BlueSoulFlashSpread_Lens.blp'],
    ],
    texturePaths: [
      'Common\\Effect\\Form\\Spread\\Texture\\BlueSoulFlashSpread_Shockwave.blp',
      'Common\\Effect\\Form\\Line\\Texture\\Flare.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\BlueSoulFlashSpread_Lens.blp',
    ],
  },
  {
    name: 'az_shanxian02',
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\az_shanxian02.mdx',
    destination: 'Common/Effect/Form/Spread/az_shanxian02.mdx',
    textureMappings: [
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\AZ_FlareWhite1.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_AZ_FlareWhite1.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\AZ_Flashb5.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_AZ_Flashb5.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\AZ_Shockwave17.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_AZ_Shockwave17.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\star2x2.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_star2x2.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\AZ_Flashb3.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_AZ_Flashb3.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\128\\Textures\\Flare.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_Flare.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\AZ_lightning_4x4.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_AZ_lightning_4x4.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\AZ_Petal1.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_AZ_Petal1.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\az_shanxian02\\AZ_Shockwave21.blp', 'Common/Effect/Form/Spread/Texture/az_shanxian02_AZ_Shockwave21.blp'],
    ],
    texturePaths: [
      'Common\\Effect\\Form\\Spread\\Texture\\TX_JN_QUSANBO_0.blp',
      'Common\\Effect\\Element\\Fantasy\\Texture\\star5tga.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_AZ_Shockwave21.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_AZ_FlareWhite1.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_AZ_Flashb5.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_AZ_Shockwave17.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_star2x2.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_AZ_Flashb3.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_Flare.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_AZ_lightning_4x4.blp',
      'Common\\Effect\\Form\\Spread\\Texture\\az_shanxian02_AZ_Petal1.blp',
      'Textures\\Smoke.blp',
    ],
  },
];

const results = [];
for (const migration of migrations) {
  if (!fs.existsSync(migration.source)) throw new Error(`Missing source model: ${migration.source}`);
  for (const mapping of migration.textureMappings) copyTexture(mapping[0], mapping[1]);

  const model = new Model();
  model.loadMdx(fs.readFileSync(migration.source));
  model.name = migration.name;
  if (model.textures.length !== migration.texturePaths.length) {
    throw new Error(`${migration.name}: expected ${model.textures.length} texture paths, got ${migration.texturePaths.length}`);
  }
  model.textures.forEach((texture, index) => {
    texture.path = migration.texturePaths[index];
  });

  const destination = path.join(projectRoot, 'imports', ...migration.destination.split('/'));
  fs.mkdirSync(path.dirname(destination), { recursive: true });
  fs.writeFileSync(destination, model.saveMdx());

  const verified = new Model();
  verified.loadMdx(fs.readFileSync(destination));
  const invalidTexture = verified.textures.find((texture) => /^[A-Za-z]:\\|war3mapimported/i.test(texture.path));
  if (invalidTexture) throw new Error(`${migration.name}: invalid texture path ${invalidTexture.path}`);
  results.push({
    name: migration.name,
    destination,
    size: fs.statSync(destination).size,
    hash: sha256(destination),
    sequences: verified.sequences.map((sequence) => sequence.name),
    textures: verified.textures.map((texture) => texture.path),
  });
}

console.log(JSON.stringify(results, null, 2));
