const fs = require("fs");
const path = require("path");

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error("MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js");
}

const Model = require(modelLibraryPath).default;
const sanityTest = require(path.resolve(path.dirname(modelLibraryPath), "..", "..", "utils", "mdlx", "sanitytest", "sanitytest.js")).default;
const projectRoot = path.resolve(__dirname, "..");
const sourceModelPath = "C:\\Users\\Administrator\\Desktop\\特效库\\技能特效2\\devilslam\\devilslam.mdx";
const targetModelPath = path.join(projectRoot, "imports", "Common", "Effect", "Form", "Explosion", "DevilSlam.mdx");

const expectedTextures = [
  "Textures\\firering6.blp",
  "Textures\\Shadow.blp",
  "Textures\\Shockwave10.blp",
  "Textures\\RibbonBlur1b.blp",
  "Textures\\firering1A.blp",
  "Textures\\Flare.blp",
  "Textures\\star3.blp",
  "Units\\Creeps\\Revenant\\BlueWaves.blp",
];

function repairNativeTexturePath(texturePath) {
  const normalized = texturePath.replace(/\//g, "\\");
  const lower = normalized.toLowerCase();
  if (lower.endsWith("\\textures\\shadow.blp")) return "Textures\\Shadow.blp";
  if (lower.endsWith("\\textures\\flare.blp")) return "Textures\\Flare.blp";
  return normalized;
}

function main() {
  if (!fs.existsSync(sourceModelPath)) throw new Error("Missing source model: " + sourceModelPath);

  const model = new Model();
  model.loadMdx(fs.readFileSync(sourceModelPath));
  for (const texture of model.textures) texture.path = repairNativeTexturePath(texture.path);

  const actualTextures = model.textures.map(function getTexturePath(texture) { return texture.path; });
  if (JSON.stringify(actualTextures) !== JSON.stringify(expectedTextures)) {
    throw new Error("Unexpected DevilSlam texture table: " + JSON.stringify(actualTextures));
  }

  fs.mkdirSync(path.dirname(targetModelPath), { recursive: true });
  fs.writeFileSync(targetModelPath, Buffer.from(model.saveMdx()));

  const verified = new Model();
  verified.loadMdx(fs.readFileSync(targetModelPath));
  const verifiedTextures = verified.textures.map(function getTexturePath(texture) { return texture.path; });
  if (JSON.stringify(verifiedTextures) !== JSON.stringify(expectedTextures)) {
    throw new Error("DevilSlam texture verification failed: " + JSON.stringify(verifiedTextures));
  }
  const sanity = sanityTest(verified);
  const allowedSevere = new Set(['Missing "Stand" sequence', 'Missing "Death" sequence']);
  const unexpectedSevere = sanity.nodes.filter(function isUnexpectedSevere(node) {
    return node.type === "severe" && !allowedSevere.has(node.message);
  });
  if (sanity.errors !== 0 || sanity.severe !== 2 || unexpectedSevere.length > 0) {
    throw new Error(`DevilSlam failed structural verification: errors=${sanity.errors}, severe=${sanity.severe}`);
  }

  console.log(JSON.stringify({
    source: sourceModelPath,
    target: targetModelPath,
    byteLength: fs.statSync(targetModelPath).size,
    textures: verifiedTextures,
    sanity: {
      errors: sanity.errors,
      severe: sanity.severe,
      warnings: sanity.warnings,
      unused: sanity.unused,
    },
  }, null, 2));
}

main();
