const fs = require("fs");
const path = require("path");

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error("MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js");
}

const Model = require(modelLibraryPath).default;
const modelLibraryDirectory = path.dirname(modelLibraryPath);
const Sequence = require(path.join(modelLibraryDirectory, "sequence.js")).default;
const Extent = require(path.join(modelLibraryDirectory, "extent.js")).default;
const projectRoot = path.resolve(__dirname, "..");
const sourceRoot = "C:\\Users\\Administrator\\Desktop\\特效库\\技能特效1 (1)";
const sourceModelPath = path.join(sourceRoot, "155", "155.mdx");
const targetDirectory = path.join(projectRoot, "imports", "Common", "Effect", "Form", "Explosion");
const targetTextureDirectory = path.join(targetDirectory, "Texture");
const targetModelPath = path.join(targetDirectory, "TrollChiefExpandingShockwaveImpact.mdx");
const gameTextureDirectory = "Common\\Effect\\Form\\Explosion\\Texture";

const textureMigrations = [
  {
    index: 0,
    source: path.join(sourceRoot, "155", "z_tt_se_qq_qun_941442872_sem_tu_jia_shu_chu_xian_tt5.blp"),
    targetName: "TrollChiefExpandingShockwaveImpact_01.blp",
  },
  {
    index: 1,
    source: path.join(sourceRoot, "107", "z_tt_se_qq_qun_941442872_sem_huo_yan_qiu_tt1.blp"),
    targetName: "TrollChiefExpandingShockwaveImpact_02.blp",
  },
  {
    index: 3,
    source: path.join(sourceRoot, "155", "z_tt_se_qq_qun_941442872_sem_te_xiao_2_5_tt1.blp"),
    targetName: "TrollChiefExpandingShockwaveImpact_03.blp",
  },
];

function assertSourceFile(filePath) {
  if (!fs.existsSync(filePath) || !fs.statSync(filePath).isFile()) {
    throw new Error("Missing source asset: " + filePath);
  }
}

function migrateTexture(model, migration) {
  assertSourceFile(migration.source);
  const targetPath = path.join(targetTextureDirectory, migration.targetName);
  fs.copyFileSync(migration.source, targetPath);
  model.textures[migration.index].path = gameTextureDirectory + "\\" + migration.targetName;
}

function copyExtent(source, destination) {
  destination.min.set(source.min);
  destination.max.set(source.max);
  destination.boundsRadius = source.boundsRadius;
}

function addSafetyDeathSequence(model) {
  const stand = model.sequences[0];
  const death = new Sequence();
  death.name = "Death";
  death.interval.set([stand.interval[1] + 1, stand.interval[1] + 2]);
  death.nonLooping = 1;
  copyExtent(model.extent, death.extent);
  model.sequences.push(death);

  for (const geoset of model.geosets) {
    const extent = new Extent();
    copyExtent(geoset.extent, extent);
    geoset.sequenceExtents.push(extent);
  }
}

function main() {
  assertSourceFile(sourceModelPath);
  fs.mkdirSync(targetTextureDirectory, { recursive: true });

  const model = new Model();
  model.loadMdx(fs.readFileSync(sourceModelPath));
  model.name = "TrollChiefExpandingShockwaveImpact";
  addSafetyDeathSequence(model);

  for (const migration of textureMigrations) {
    migrateTexture(model, migration);
  }
  fs.writeFileSync(targetModelPath, Buffer.from(model.saveMdx()));

  const verified = new Model();
  verified.loadMdx(fs.readFileSync(targetModelPath));
  if (verified.name !== "TrollChiefExpandingShockwaveImpact") {
    throw new Error("Migrated model verification failed");
  }

  console.log(JSON.stringify({
    model: targetModelPath,
    byteLength: fs.statSync(targetModelPath).size,
    sequences: verified.sequences.map(function getSequenceName(sequence) { return sequence.name; }),
    textures: verified.textures.map(function getTexturePath(texture) { return texture.path; }),
  }, null, 2));
}

main();
