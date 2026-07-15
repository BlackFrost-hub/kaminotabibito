const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const modelLibraryDirectory = path.dirname(modelLibraryPath);
const Sequence = require(path.join(modelLibraryDirectory, 'sequence.js')).default;
const Extent = require(path.join(modelLibraryDirectory, 'extent.js')).default;
const projectRoot = path.resolve(__dirname, '..');

function copyExtent(source, destination) {
  destination.min.set(source.min);
  destination.max.set(source.max);
  destination.boundsRadius = source.boundsRadius;
}

function addSequence(model, name, start, end, nonLooping = 1) {
  const sequence = new Sequence();
  sequence.name = name;
  sequence.interval.set([start, end]);
  sequence.nonLooping = nonLooping;
  copyExtent(model.extent, sequence.extent);
  model.sequences.push(sequence);
}

function fillSequenceExtents(model) {
  for (const geoset of model.geosets) {
    while (geoset.sequenceExtents.length < model.sequences.length) {
      const extent = new Extent();
      copyExtent(geoset.extent, extent);
      geoset.sequenceExtents.push(extent);
    }
  }
}

function setColor(target, color) {
  target.set(color);
}

function tintEmitters(model, colors) {
  for (let i = 0; i < model.particleEmitters2.length; i += 1) {
    const palette = colors[i % colors.length];
    const emitter = model.particleEmitters2[i];
    for (let segment = 0; segment < emitter.segmentColors.length; segment += 1) {
      setColor(emitter.segmentColors[segment], palette[Math.min(segment, palette.length - 1)]);
    }
  }
}

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

const sharedFlarePath = 'Common\\Effect\\Form\\Line\\Texture\\Flare.blp';
const migrations = [
  {
    name: 'AinzLifeShelterStatus',
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001181\\file_001181.mdx',
    destination: 'Common/Effect/Form/Aura/AinzLifeShelterStatus.mdx',
    textureMappings: [
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001181\\Textures\\ZK_light_12_gai.blp', 'Common/Effect/Form/Aura/Texture/AinzLifeShelter_ZKLight.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001181\\war3mapimported\\wgzy-file00002554_1.blp', 'Common/Effect/Form/Aura/Texture/AinzLifeShelter_Ring.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001181\\war3mapimported\\senji-slash-color-3-1_4.blp', 'Common/Effect/Form/Aura/Texture/AinzLifeShelter_Slash.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001181\\war3mapimported\\wgzy-file00002554_3.blp', 'Common/Effect/Form/Aura/Texture/AinzLifeShelter_StarA.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001181\\war3mapimported\\chikata-star-1.blp', 'Common/Effect/Form/Aura/Texture/AinzLifeShelter_StarB.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001181\\war3mapimported\\wgzy-file00002554_5.blp', 'Common/Effect/Form/Aura/Texture/AinzLifeShelter_StarC.blp'],
    ],
    transform(model) {
      const stand = model.sequences[0];
      stand.name = 'Stand';
      stand.nonLooping = 0;
      addSequence(model, 'Birth', 3501, 3502);
      addSequence(model, 'Death', 3503, 3504);
      model.geosetAnimations.forEach((animation, index) => {
        animation.flags |= 2;
        setColor(animation.color, index === 0 ? [1, 0.9, 0.56] : [1, 0.76, 0.28]);
      });
      tintEmitters(model, [
        [[1, 0.96, 0.75], [1, 0.82, 0.38], [0.82, 0.56, 0.16]],
        [[1, 1, 0.92], [1, 0.88, 0.5], [0.9, 0.65, 0.2]],
      ]);
    },
  },
  {
    name: 'ShalltearBloodExhaustionMark',
    source: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Debuff', 'ShalltearBloodDropMark.mdx'),
    destination: 'Common/Effect/Form/Debuff/ShalltearBloodExhaustionMark.mdx',
    texturePaths: [
      'Textures\\Flare.blp',
      'Textures\\Red_Glow3.blp',
      'Common\\Effect\\Form\\Debuff\\Texture\\Black32.blp',
      'Textures\\BloodWhiteSmall.blp',
      'UI\\Glues\\SinglePlayer\\Orc_Exp\\SKY1b.blp',
    ],
    transform(model) {
      const colors = [
        [0.8, 0.67, 0.7],
        [0.62, 0.3, 0.34],
        [0.36, 0.08, 0.1],
        [0.92, 0.83, 0.84],
        [0.5, 0.16, 0.2],
      ];
      model.geosetAnimations.forEach((animation, index) => {
        animation.flags |= 2;
        setColor(animation.color, colors[index % colors.length]);
      });
      tintEmitters(model, [
        [[0.9, 0.78, 0.8], [0.58, 0.22, 0.26], [0.28, 0.04, 0.06]],
      ]);
    },
  },
  {
    name: 'SpiritGuardSoulCollapse',
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001102\\file_001102.mdx',
    destination: 'Common/Effect/Form/Debuff/SpiritGuardSoulCollapse.mdx',
    texturePaths: [
      sharedFlarePath,
      'Common\\Effect\\Form\\Debuff\\Texture\\SpiritGuardSoulCollapse_Ghost.blp',
      'Common\\Effect\\Element\\Fantasy\\Texture\\star4_32.blp',
      'Common\\Effect\\Form\\Debuff\\Texture\\SpiritGuardSoulCollapse_Star6.blp',
      'Common\\Effect\\Element\\Fantasy\\Texture\\AZ_Star3.blp',
      'Common\\Effect\\Form\\Debuff\\Texture\\SpiritGuardSoulCollapse_Flare.blp',
      'Common\\Effect\\Form\\Debuff\\Texture\\SpiritGuardSoulCollapse_SmokeA.blp',
      'Common\\Effect\\Form\\Debuff\\Texture\\SpiritGuardSoulCollapse_Star.blp',
      'Common\\Effect\\Form\\Debuff\\Texture\\SpiritGuardSoulCollapse_SmokeB.blp',
    ],
    textureMappings: [
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_000799\\Textures\\Ghost1.blp', 'Common/Effect/Form/Debuff/Texture/SpiritGuardSoulCollapse_Ghost.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_000860\\war3mapImported\\star6.blp', 'Common/Effect/Form/Debuff/Texture/SpiritGuardSoulCollapse_Star6.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001102\\aztextures\\AZ_Flare1Q.blp', 'Common/Effect/Form/Debuff/Texture/SpiritGuardSoulCollapse_Flare.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001102\\aztextures\\AZ_Smoke1E.blp', 'Common/Effect/Form/Debuff/Texture/SpiritGuardSoulCollapse_SmokeA.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001102\\textures\\star2x2.blp', 'Common/Effect/Form/Debuff/Texture/SpiritGuardSoulCollapse_Star.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001102\\aztextures\\AZ_Smoke8x8a.blp', 'Common/Effect/Form/Debuff/Texture/SpiritGuardSoulCollapse_SmokeB.blp'],
    ],
    transform(model) {
      const birth = model.sequences[0];
      birth.name = 'Birth';
      birth.nonLooping = 1;
      addSequence(model, 'Stand', 1001, 1002, 0);
      addSequence(model, 'Death', 1003, 1004);
      model.geosetAnimations.forEach((animation) => {
        animation.flags |= 2;
        setColor(animation.color, [0.68, 0.82, 0.9]);
      });
      tintEmitters(model, [
        [[0.88, 0.94, 1], [0.35, 0.58, 0.78], [0.12, 0.22, 0.35]],
        [[0.75, 0.82, 0.9], [0.3, 0.4, 0.56], [0.08, 0.12, 0.2]],
      ]);
    },
  },
  {
    name: 'SpiritGuardSoulReflux',
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001190\\file_001190.mdx',
    destination: 'Common/Effect/Form/RiseFall/SpiritGuardSoulReflux.mdx',
    texturePaths: [sharedFlarePath, 'Common\\Effect\\Form\\Debuff\\Texture\\GenericGlow64.blp'],
    transform(model) {
      const birth = model.sequences[0];
      birth.name = 'Birth';
      birth.nonLooping = 1;
      addSequence(model, 'Stand', 3101, 3102, 0);
      addSequence(model, 'Death', 3103, 3104);
      tintEmitters(model, [
        [[0.48, 0.82, 1], [0.82, 0.94, 1], [0.35, 0.62, 0.85]],
        [[1, 0.82, 0.38], [0.95, 0.94, 0.76], [0.55, 0.68, 0.8]],
      ]);
    },
  },
  {
    name: 'SpiritGuardPurificationRecoil',
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001180\\file_001180.mdx',
    destination: 'Common/Effect/Form/Debuff/SpiritGuardPurificationRecoil.mdx',
    textureMappings: [
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001180\\war3mapImported\\VFX_TX_ququ_zuozhu_baoguang2.blp', 'Common/Effect/Form/Debuff/Texture/SpiritGuardPurificationRecoil_Burst.blp'],
      ['C:\\Users\\Administrator\\Desktop\\特效库\\MapTest\\file_001180\\war3mapImported\\VFX_TX_ququ_zuozhu_guanghuan3.blp', 'Common/Effect/Form/Debuff/Texture/SpiritGuardPurificationRecoil_Ring.blp'],
    ],
    texturePaths: [
      'Common\\Effect\\Form\\Debuff\\Texture\\SpiritGuardPurificationRecoil_Burst.blp',
      'Common\\Effect\\Form\\Debuff\\Texture\\SpiritGuardPurificationRecoil_Ring.blp',
      sharedFlarePath,
    ],
    transform(model) {
      const birth = model.sequences[0];
      birth.name = 'Birth';
      birth.nonLooping = 1;
      addSequence(model, 'Stand', 4001, 4002, 0);
      addSequence(model, 'Death', 4003, 4004);
      model.geosetAnimations.forEach((animation) => {
        animation.flags |= 2;
        setColor(animation.color, [0.86, 0.95, 1]);
      });
      tintEmitters(model, [
        [[1, 1, 1], [0.78, 0.92, 1], [0.52, 0.72, 0.9]],
      ]);
    },
  },
];

const results = [];
for (const migration of migrations) {
  if (!fs.existsSync(migration.source)) throw new Error(`Missing source model: ${migration.source}`);
  const model = new Model();
  model.loadMdx(fs.readFileSync(migration.source));
  model.name = migration.name;
  migration.transform(model);
  fillSequenceExtents(model);

  const copiedTextures = [];
  for (const mapping of migration.textureMappings || []) {
    const destination = copyTexture(mapping[0], mapping[1]);
    copiedTextures.push({ path: destination, hash: sha256(destination).slice(0, 16) });
  }
  const texturePaths = migration.texturePaths || (migration.textureMappings || []).map((mapping) => mapping[1].replaceAll('/', '\\'));
  if (texturePaths.length !== model.textures.length) {
    throw new Error(`${migration.name}: expected ${model.textures.length} texture paths, got ${texturePaths.length}`);
  }
  model.textures.forEach((texture, index) => {
    texture.path = texturePaths[index];
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
    path: destination,
    size: fs.statSync(destination).size,
    hash: sha256(destination).slice(0, 16),
    sequences: verified.sequences.map((sequence) => sequence.name),
    textures: verified.textures.map((texture) => texture.path),
    copiedTextures,
  });
}

console.log(JSON.stringify(results, null, 2));
