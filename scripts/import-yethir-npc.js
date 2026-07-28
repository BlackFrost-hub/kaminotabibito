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
const sourceRoot = "C:\\Users\\Administrator\\Desktop\\20191014ca3f70a4-8a84-459a-824f-63b141a3f4ed";
const destinationRoot = path.join(projectRoot, "imports", "Unit", "NPC", "02-Chapter", "Elf");
const textureRoot = path.join(destinationRoot, "Texture", "Yethir");
const modelSource = path.join(sourceRoot, "DreadNightElfWarrior.mdx");
const modelDestination = path.join(destinationRoot, "Yethir.mdx");

const textureNames = [
  "DreadNightElfWarrior.blp",
  "DreadNightElfWarrior_Hair.blp",
  "NIGHTELFMALEEYEGLOW.blp",
  "DreadNightElfWarrior_Cap.blp",
  "DreadNightElfWarrior_Helm.blp",
  "DreadNightElfWarrior_Shulder.blp",
  "DreadNightElfWarrior_Helm_Eyepatch.blp",
  "Sword_1H_Long_D_03_V01.blp",
];

function ensureFileExists(filePath) {
  if (!fs.existsSync(filePath)) throw new Error(`Missing source asset: ${filePath}`);
}

ensureFileExists(modelSource);
fs.mkdirSync(textureRoot, { recursive: true });

for (const textureName of textureNames) {
  const source = path.join(sourceRoot, textureName);
  const destination = path.join(textureRoot, textureName);
  ensureFileExists(source);
  fs.copyFileSync(source, destination);
}

const model = new Model();
model.loadMdx(fs.readFileSync(modelSource));
for (const texture of model.textures) {
  if (!texture.path) continue;
  const textureName = path.win32.basename(texture.path);
  if (!textureNames.includes(textureName)) {
    throw new Error(`Unexpected Yethir texture dependency: ${texture.path}`);
  }
  texture.path = path.win32.join("Unit", "NPC", "02-Chapter", "Elf", "Texture", "Yethir", textureName);
}
fs.writeFileSync(modelDestination, model.saveMdx());

const verified = new Model();
verified.loadMdx(fs.readFileSync(modelDestination));
const sanity = sanityTest(verified);
if (sanity.errors !== 0) {
  throw new Error(`Yethir model failed structural verification: errors=${sanity.errors}`);
}

const expectedTexturePaths = textureNames.map((textureName) =>
  path.win32.join("Unit", "NPC", "02-Chapter", "Elf", "Texture", "Yethir", textureName),
);
const actualTexturePaths = verified.textures.map((texture) => texture.path).filter(Boolean);
if (JSON.stringify(actualTexturePaths) !== JSON.stringify(expectedTexturePaths)) {
  throw new Error(`Yethir texture migration failed: ${JSON.stringify(actualTexturePaths)}`);
}

console.log(JSON.stringify({
  model: path.relative(projectRoot, modelDestination),
  textures: textureNames.map((textureName) => path.relative(projectRoot, path.join(textureRoot, textureName))),
  sequences: verified.sequences.map((sequence) => sequence.name),
  sanity: {
    errors: sanity.errors,
    severe: sanity.severe,
    warnings: sanity.warnings,
    unused: sanity.unused,
  },
}, null, 2));
