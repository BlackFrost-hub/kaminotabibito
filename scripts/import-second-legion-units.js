// @noSelfInFile

const fs = require("fs");
const path = require("path");

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error("MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js");
}

const Model = require(modelLibraryPath).default;
const sanityTest = require(path.resolve(
  path.dirname(modelLibraryPath),
  "..", "..", "utils", "mdlx", "sanitytest", "sanitytest.js",
)).default;

const projectRoot = path.resolve(__dirname, "..");
const sourceRoot = "C:\\Users\\Administrator\\Desktop\\攻城";

const assets = [
  {
    source: path.join(sourceRoot, "弓箭手", "NightArcher.mdx"),
    destination: path.join(projectRoot, "imports", "Unit", "Minion", "SecondLegionArcher.mdx"),
  },
  {
    source: path.join(sourceRoot, "弓箭手", "NightArcher_portrait.mdx"),
    destination: path.join(projectRoot, "imports", "Unit", "Minion", "SecondLegionArcher_Portrait.mdx"),
  },
  {
    source: path.join(sourceRoot, "战士", "人类战士", "renleiSHEN.blp"),
    destination: path.join(projectRoot, "imports", "Unit", "Minion", "Texture", "SecondLegionWarriorBody.blp"),
  },
  {
    source: path.join(sourceRoot, "战士", "人类战士", "renleiTOU.blp"),
    destination: path.join(projectRoot, "imports", "Unit", "Minion", "Texture", "SecondLegionWarriorHead.blp"),
  },
  {
    source: path.join(sourceRoot, "暗夜精灵族近卫战士", "ancient guard7.mdx"),
    destination: path.join(projectRoot, "imports", "Unit", "Guard", "SecondLegionGuard.mdx"),
  },
  {
    source: path.join(sourceRoot, "术士（上层精灵）", "NightElfWarlockV1.03.mdx"),
    destination: path.join(projectRoot, "imports", "Unit", "Special", "SecondLegionWarlock.mdx"),
  },
];

const warriorSource = path.join(sourceRoot, "战士", "人类战士", "renleZS.mdx");
const warriorDestination = path.join(projectRoot, "imports", "Unit", "Minion", "SecondLegionWarrior.mdx");

function ensureSourceExists(filePath) {
  if (!fs.existsSync(filePath)) throw new Error(`Missing source asset: ${filePath}`);
}

function copyAsset(source, destination) {
  ensureSourceExists(source);
  fs.mkdirSync(path.dirname(destination), { recursive: true });
  fs.copyFileSync(source, destination);
}

function patchTextureSlot(buffer, oldPath, newPath) {
  const oldBytes = Buffer.from(`${oldPath}\0`, "ascii");
  const newBytes = Buffer.from(`${newPath}\0`, "ascii");
  const offset = buffer.indexOf(oldBytes);
  if (offset < 0) throw new Error(`Texture path not found: ${oldPath}`);
  if (newBytes.length > 260) throw new Error(`Texture path exceeds the 260-byte MDX slot: ${newPath}`);
  buffer.fill(0, offset, offset + 260);
  newBytes.copy(buffer, offset);
}

function loadModel(filePath) {
  const model = new Model();
  model.loadMdx(fs.readFileSync(filePath));
  return model;
}

for (const asset of assets) copyAsset(asset.source, asset.destination);

ensureSourceExists(warriorSource);
const warriorBuffer = fs.readFileSync(warriorSource);
patchTextureSlot(warriorBuffer, "renleiSHEN.blp", "Unit\\Minion\\Texture\\SecondLegionWarriorBody.blp");
patchTextureSlot(warriorBuffer, "renleiTOU.blp", "Unit\\Minion\\Texture\\SecondLegionWarriorHead.blp");
fs.mkdirSync(path.dirname(warriorDestination), { recursive: true });
fs.writeFileSync(warriorDestination, warriorBuffer);

const modelPaths = assets
  .filter((asset) => path.extname(asset.destination).toLowerCase() === ".mdx")
  .map((asset) => asset.destination)
  .concat(warriorDestination);

const verification = modelPaths.map((filePath) => {
  const model = loadModel(filePath);
  const sanity = sanityTest(model);
  if (sanity.errors !== 0) {
    throw new Error(`${path.basename(filePath)} failed structural verification: errors=${sanity.errors}`);
  }
  return {
    path: path.relative(projectRoot, filePath),
    name: model.name,
    sequences: model.sequences.length,
    textures: model.textures.map((texture) => texture.path).filter(Boolean),
    sanity: {
      errors: sanity.errors,
      severe: sanity.severe,
      warnings: sanity.warnings,
      unused: sanity.unused,
    },
  };
});

const warriorVerification = verification.find((entry) => entry.path.endsWith("SecondLegionWarrior.mdx"));
const expectedWarriorTextures = [
  "Unit\\Minion\\Texture\\SecondLegionWarriorBody.blp",
  "Unit\\Minion\\Texture\\SecondLegionWarriorHead.blp",
];
for (const expectedPath of expectedWarriorTextures) {
  if (!warriorVerification.textures.includes(expectedPath)) {
    throw new Error(`Warrior texture migration failed: ${expectedPath}`);
  }
}

console.log(JSON.stringify({
  copiedAssets: assets.map((asset) => path.relative(projectRoot, asset.destination)).concat(
    path.relative(projectRoot, warriorDestination),
  ),
  verification,
}, null, 2));
