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

const migrations = [
  {
    source: 'C:\\Users\\Administrator\\Desktop\\model\\特效\\857E11CC536A66CC82BC141037285105\\VFX_Heartbreak_bb.mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Debuff', 'AinzHeartGrasp.mdx'),
    name: 'AinzHeartGrasp',
  },
  {
    source: 'D:\\solar_workspace\\cache\\model\\6F450BB057EB8489C3F0C3BAFE9BB286\\blackakiha.mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Line', 'BansheeGrayShockwave.mdx'),
    name: 'BansheeGrayShockwave',
  },
  {
    source: 'D:\\solar_workspace\\cache\\model\\C9724D99CAB961A64B2EFE7CFA7DF167\\yue.mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'RiseFall', 'ShalltearBloodMoonAux.mdx'),
    name: 'ShalltearBloodMoonAux',
    textureSourceDirectory: 'D:\\solar_workspace\\cache\\model\\C9724D99CAB961A64B2EFE7CFA7DF167\\_sl_tex\\yue',
    textureDestinationDirectory: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'RiseFall', 'Texture'),
  },
  {
    source: 'C:\\Users\\Administrator\\Desktop\\Wing000025\\Wing000025.mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Debuff', 'AlbedoWingBind.mdx'),
    name: 'AlbedoWingBind',
    textureMappings: [0, 1, 2, 3].map((textureIndex) => ({
      textureIndex,
      source: `C:\\Users\\Administrator\\Desktop\\Wing000025\\Wing000025_${textureIndex}.blp`,
      destinationName: `AlbedoWingBind_${String(textureIndex + 1).padStart(2, '0')}.blp`,
      gameDirectory: 'Common\\Effect\\Form\\Debuff\\Texture',
      destinationDirectory: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Debuff', 'Texture'),
    })),
  },
  {
    source: 'C:\\Users\\Administrator\\Desktop\\Texiao000054\\Texiao000054.mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Explosion', 'AlbedoDarkGoldBarrierBreak.mdx'),
    name: 'AlbedoDarkGoldBarrierBreak',
    textureMappings: [{
      textureIndex: 3,
      source: 'C:\\Users\\Administrator\\Desktop\\Texiao000054\\Texiao000054_3.blp',
      destinationName: 'AlbedoDarkGoldBarrierBreak_01.blp',
      gameDirectory: 'Common\\Effect\\Form\\Explosion\\Texture',
      destinationDirectory: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Explosion', 'Texture'),
    }],
  },
  {
    source: 'C:\\Users\\Administrator\\Desktop\\Texiao000681\\Texiao000681.mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Line', 'ShalltearBloodReturnRibbon.mdx'),
    name: 'ShalltearBloodReturnRibbon',
    textureMappings: [0, 1, 2, 3, 4].map((textureIndex) => ({
      textureIndex,
      source: `C:\\Users\\Administrator\\Desktop\\Texiao000681\\Texiao000681_${textureIndex}.blp`,
      destinationName: `ShalltearBloodReturnRibbon_${String(textureIndex + 1).padStart(2, '0')}.blp`,
      gameDirectory: 'Common\\Effect\\Form\\Line\\Texture',
      destinationDirectory: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Line', 'Texture'),
    })),
  },
  {
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\1500个特效模型\\[TX] (757)\\[TX] (757).mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Debuff', 'AlbedoWingBindCore.mdx'),
    name: 'AlbedoWingBindCore',
  },
  {
    source: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Shield', 'EquipmentShieldFlash.mdx'),
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'Shield', 'AlbedoDarkGoldBarrier.mdx'),
    name: 'AlbedoDarkGoldBarrier',
  },
  {
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\[精品特效]200个打包演示图\\2\\2.mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'RiseFall', 'ShalltearBloodRebirthWeave.mdx'),
    name: 'ShalltearBloodRebirthWeave',
    textureMappings: [{
      textureIndex: 0,
      source: 'C:\\Users\\Administrator\\Desktop\\特效库\\[精品特效]200个打包演示图\\138\\war3mapImported\\AZ_Sputtering.blp',
      destinationName: 'ShalltearBloodRebirthWeave_01.blp',
      gameDirectory: 'Common\\Effect\\Form\\RiseFall\\Texture',
      destinationDirectory: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'RiseFall', 'Texture'),
    }],
  },
  {
    source: 'C:\\Users\\Administrator\\Desktop\\特效库\\1200个整理好的特效\\女神之瞳\\sem_nv_shen_zhi_tong.mdx',
    destination: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'RiseFall', 'ShalltearBloodRebirthShell.mdx'),
    name: 'ShalltearBloodRebirthShell',
    textureMappings: [1, 2].map((number, textureIndex) => ({
      textureIndex,
      source: `C:\\Users\\Administrator\\Desktop\\特效库\\1200个整理好的特效\\女神之瞳\\z_tt_se_qq_qun_941442872_sem_nv_shen_zhi_tong_tt${number}.blp`,
      destinationName: `ShalltearBloodRebirthShell_${String(number).padStart(2, '0')}.blp`,
      gameDirectory: 'Common\\Effect\\Form\\RiseFall\\Texture',
      destinationDirectory: path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'RiseFall', 'Texture'),
    })),
  },
];

function addSequence(model, name, start, end) {
  const sequence = new Sequence();
  sequence.name = name;
  sequence.interval.set([start, end]);
  sequence.nonLooping = 1;
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

function setColor(target, red, green, blue) {
  target.set([red, green, blue]);
}

function transformModel(model, name) {
  if (name === 'AlbedoWingBind') {
    const stand = model.sequences.find((sequence) => sequence.name.toLowerCase() === 'stand');
    const death = model.sequences.find((sequence) => sequence.name.toLowerCase() === 'death');
    const birth = model.sequences.find((sequence) => sequence.interval[0] === 2000);
    if (!birth || !stand || !death) {
      throw new Error(`${name}: expected Stand, Birth placeholder, and Death sequences`);
    }
    stand.name = 'Stand';
    birth.name = 'Birth';
    birth.nonLooping = 1;
    death.name = 'Death';
  }

  if (name === 'AlbedoDarkGoldBarrierBreak') {
    const geosetColors = [
      [1, 0.58, 0.08],
      [0.35, 0.14, 0.01],
      [1, 0.76, 0.22],
      [1, 0.58, 0.08],
      [1, 0.88, 0.48],
    ];
    model.geosetAnimations.forEach((animation, index) => {
      animation.flags |= 2;
      setColor(animation.color, ...geosetColors[index]);
    });
    model.textures[6].path = 'Textures\\GenericGlow64.blp';
    const goldColors = [
      [[1, 0.42, 0.02], [1, 0.68, 0.08], [0.5, 0.15, 0.01]],
      [[1, 0.62, 0.08], [1, 0.38, 0.01], [0.55, 0.18, 0.01]],
      [[1, 0.72, 0.18], [1, 0.45, 0.02], [0.6, 0.2, 0.01]],
      [[1, 0.88, 0.5], [1, 0.62, 0.12], [0.55, 0.2, 0.02]],
      [[1, 0.82, 0.35], [1, 0.48, 0.03], [0.5, 0.15, 0.01]],
      [[1, 0.72, 0.14], [1, 0.45, 0.02], [0.55, 0.16, 0.01]],
      [[1, 0.9, 0.55], [1, 0.62, 0.1], [0.55, 0.18, 0.01]],
    ];
    model.particleEmitters2.forEach((emitter, emitterIndex) => {
      emitter.segmentColors.forEach((color, segmentIndex) => {
        setColor(color, ...goldColors[emitterIndex][segmentIndex]);
      });
    });
  }

  if (name === 'ShalltearBloodReturnRibbon') {
    addSequence(model, 'Stand', 1100, 1101);
    addSequence(model, 'Death', 1102, 1103);
    fillSequenceExtents(model);
    model.geosetAnimations.forEach((animation) => {
      animation.flags |= 2;
      setColor(animation.color, 1, 0.055, 0.035);
    });
    const bloodColors = [
      [[1, 0.08, 0.04], [0.78, 0.01, 0.015], [0.35, 0, 0]],
      [[1, 0.12, 0.06], [0.82, 0.015, 0.02], [0.4, 0, 0]],
      [[1, 0.2, 0.12], [0.9, 0.025, 0.025], [0.42, 0, 0]],
      [[1, 0.16, 0.1], [0.85, 0.02, 0.02], [0.38, 0, 0]],
      [[1, 0.1, 0.05], [0.72, 0.01, 0.015], [0.3, 0, 0]],
    ];
    model.particleEmitters2.forEach((emitter, emitterIndex) => {
      emitter.name = `BloodReturnEmitter${emitterIndex + 1}`;
      emitter.segmentColors.forEach((color, segmentIndex) => {
        setColor(color, ...bloodColors[emitterIndex][segmentIndex]);
      });
    });
  }

  if (name === 'AlbedoWingBindCore') {
    const stand = model.sequences.find((sequence) => sequence.name === 'Death');
    if (!stand) {
      throw new Error(`${name}: expected the source Death sequence`);
    }
    stand.name = 'Stand';
    stand.nonLooping = 0;
    addSequence(model, 'Birth', 1400, 1401);
    addSequence(model, 'Death', 1402, 1403);
    fillSequenceExtents(model);
    model.textures[1].path = 'Textures\\GenericGlow64.blp';
    model.textures[2].path = 'Textures\\RibbonNE1_White.blp';
    const gold = [
      [1, 0.72, 0.18],
      [1, 0.48, 0.04],
      [0.5, 0.16, 0.01],
    ];
    model.particleEmitters2.forEach((emitter, emitterIndex) => {
      emitter.name = `WingBindCoreEmitter${emitterIndex + 1}`;
      emitter.segmentColors.forEach((color, segmentIndex) => {
        setColor(color, ...gold[segmentIndex]);
      });
    });
    model.ribbonEmitters.forEach((ribbon, index) => {
      ribbon.name = `WingBindCoreRibbon${index + 1}`;
      setColor(ribbon.color, index % 2 === 0 ? 1 : 0.82, index % 2 === 0 ? 0.5 : 0.32, 0.03);
    });
  }

  if (name === 'AlbedoDarkGoldBarrier') {
    model.geosetAnimations.forEach((animation) => {
      animation.flags |= 2;
      setColor(animation.color, 1, 0.58, 0.1);
    });
    fillSequenceExtents(model);
  }

  if (name === 'ShalltearBloodRebirthWeave') {
    addSequence(model, 'Birth', 3400, 3401);
    fillSequenceExtents(model);
    model.textures[1].path = 'Textures\\Flare.blp';
    model.geosetAnimations.forEach((animation) => {
      animation.flags |= 2;
      setColor(animation.color, 0.92, 0.025, 0.035);
    });
    model.particleEmitters2.forEach((emitter) => {
      emitter.segmentColors.forEach((color, index) => {
        setColor(color, index === 1 ? 0.78 : 1, index === 1 ? 0.015 : 0.08, index === 1 ? 0.02 : 0.045);
      });
    });
  }

  if (name === 'ShalltearBloodRebirthShell') {
    addSequence(model, 'Birth', 16667, 16668);
    addSequence(model, 'Death', 16669, 16670);
    fillSequenceExtents(model);
    model.geosetAnimations.forEach((animation, index) => {
      animation.flags |= 2;
      setColor(animation.color, index === 0 ? 0.9 : 1, 0.02, index === 2 ? 0.04 : 0.025);
    });
  }
}

const results = [];
for (const migration of migrations) {
  const model = new Model();
  model.loadMdx(fs.readFileSync(migration.source));
  model.name = migration.name;
  transformModel(model, migration.name);

  if (migration.name === 'BansheeGrayShockwave') {
    for (const [name, start, end] of [['Stand', 1401, 1402], ['Death', 1403, 1404]]) {
      const sequence = new Sequence();
      sequence.name = name;
      sequence.interval.set([start, end]);
      sequence.nonLooping = 1;
      copyExtent(model.extent, sequence.extent);
      model.sequences.push(sequence);
    }
    for (const geoset of model.geosets) {
      while (geoset.sequenceExtents.length < model.sequences.length) {
        const extent = new Extent();
        copyExtent(geoset.extent, extent);
        geoset.sequenceExtents.push(extent);
      }
    }
  }

  const copiedTextures = [];
  if (migration.textureSourceDirectory) {
    const sourceTextures = fs.readdirSync(migration.textureSourceDirectory)
      .filter((fileName) => fileName.toLowerCase().endsWith('.blp'))
      .sort();
    if (sourceTextures.length !== model.textures.length) {
      throw new Error(`${migration.name}: expected ${model.textures.length} textures, found ${sourceTextures.length}`);
    }
    fs.mkdirSync(migration.textureDestinationDirectory, { recursive: true });
    sourceTextures.forEach((fileName, index) => {
      const destinationName = `${migration.name}_${String(index + 1).padStart(2, '0')}.blp`;
      const destination = path.join(migration.textureDestinationDirectory, destinationName);
      fs.copyFileSync(path.join(migration.textureSourceDirectory, fileName), destination);
      model.textures[index].path = `Common\\Effect\\Form\\RiseFall\\Texture\\${destinationName}`;
      copiedTextures.push(destination);
    });
  }

  for (const textureMapping of migration.textureMappings || []) {
    fs.mkdirSync(textureMapping.destinationDirectory, { recursive: true });
    const destination = path.join(textureMapping.destinationDirectory, textureMapping.destinationName);
    fs.copyFileSync(textureMapping.source, destination);
    model.textures[textureMapping.textureIndex].path = `${textureMapping.gameDirectory}\\${textureMapping.destinationName}`;
    copiedTextures.push(destination);
  }

  fs.mkdirSync(path.dirname(migration.destination), { recursive: true });
  fs.writeFileSync(migration.destination, model.saveMdx());

  const verified = new Model();
  verified.loadMdx(fs.readFileSync(migration.destination));
  if (verified.name !== migration.name) {
    throw new Error(`${migration.name}: verification failed`);
  }
  results.push({
    name: migration.name,
    destination: migration.destination,
    byteLength: fs.statSync(migration.destination).size,
    sequences: verified.sequences.map((sequence) => sequence.name),
    textures: verified.textures.map((texture) => texture.path),
    copiedTextures,
  });
}

console.log(JSON.stringify(results, null, 2));
