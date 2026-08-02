/**
 * 生成炫酷的 1 秒动态扇形预警模型。
 *
 * - 底层：能量填充、双层亮边、刻度弧和速度纹。
 * - 上层：独立箭头网格以骨骼 X 轴缩放，从脚下向前延伸。
 * - Birth 动画严格为 0~1000ms，因此特效速度 1.0 对应 1 秒。
 */
const fs = require("fs");
const os = require("os");
const path = require("path");

const SIZE = 256;
const root = path.join(__dirname, "..");
const outputDir = path.join(root, "imports", "resource", "models", "Tip", "skillTip");
const templateModel = path.join(__dirname, "assets", "telegraph-templates", "AbilTipSX.mdx");
const { writeWarcraftCompatibleTransparentBlp } = require(path.join(root, "scripts", "war3-transparent-blp.js"));
const aiSectorPath = path.join(root, "image_temp", "telegraph-style", "telegraph-sector-white.png");
const baseFillTexturePath = path.join(outputDir, "SimpleSectorTipFill.blp");
const baseOutlineTexturePath = path.join(outputDir, "SimpleSectorTip.blp");
const sectorAngle = Number(process.env.SECTOR_ANGLE || 80);
if (!Number.isFinite(sectorAngle) || sectorAngle <= 0 || sectorAngle > 360) {
  throw new Error(`SECTOR_ANGLE must be within (0, 360], got ${process.env.SECTOR_ANGLE}`);
}
// 角度变体默认使用 256×256，保留原无后缀 80°资源的 512×512贴图。
const sectorOutlineTextureSize = Number(process.env.SECTOR_TEXTURE_SIZE || 256);
if (!Number.isInteger(sectorOutlineTextureSize) || sectorOutlineTextureSize < 64 || sectorOutlineTextureSize > 1024) {
  throw new Error(`SECTOR_TEXTURE_SIZE must be an integer within [64, 1024], got ${process.env.SECTOR_TEXTURE_SIZE}`);
}
const sectorSuffix = process.env.SECTOR_SUFFIX !== undefined
  ? process.env.SECTOR_SUFFIX
  : (sectorAngle === 80 ? "" : `_${sectorAngle}`);
const 是角度变体 = sectorAngle !== 80 || sectorSuffix !== "";
const 使用共享原始贴图 = 是角度变体 && process.env.SECTOR_USE_SHARED_TEXTURES !== "0";
const 原始扇形总角度 = 80;
const 扇形底板横向比例 = Math.tan(sectorAngle * Math.PI / 360)
  / Math.tan(原始扇形总角度 * Math.PI / 360);
const modelStem = `SimpleSectorTip${sectorSuffix}`;
const outputModel = path.join(outputDir, `${modelStem}.mdx`);
const outputTexture = path.join(outputDir, `${modelStem}.blp`);
const fillTexture = path.join(outputDir, `${modelStem}Fill.blp`);
const glowTexture = path.join(outputDir, `${modelStem}Glow.blp`);
const 贴图前缀 = 使用共享原始贴图 ? "SimpleSectorTip" : modelStem;
const gameTexturePath = `resource\\models\\Tip\\skillTip\\${贴图前缀}Fill.blp`;
const gameOutlinePath = `resource\\models\\Tip\\skillTip\\${贴图前缀}.blp`;
const gameGlowPath = `resource\\models\\Tip\\skillTip\\${贴图前缀}Glow.blp`;

function getTextureTools() {
  const extensionRoot = path.join(
    process.env.USERPROFILE || "",
    ".vscode",
    "extensions",
    "syh1906.war3-texture-preview-1.2.4-win32-x64"
  );
  return require(path.join(extensionRoot, "out", "conversion", "textureConvert.js"));
}

function getNativeBlpTools() {
  const nativeConverterPath = process.env.WAR3_NATIVE_BLP_CONVERT_LIB || path.join(
    process.env.USERPROFILE || "",
    ".vscode",
    "extensions",
    "shiyueqq1023261581.war3icon-0.0.2",
    "out",
    "command",
    "helper",
    "blp2img.js"
  );
  return require(nativeConverterPath);
}

function 读取PNG贴图(filePath) {
  return getTextureTools().decodeTextureBuffer(fs.readFileSync(filePath), "png");
}

function 读取BLP贴图(filePath) {
  const temporaryPngPath = path.join(os.tmpdir(), `syzl-sector-source-${process.pid}-${Date.now()}.png`);
  try {
    getNativeBlpTools().blp2Image(filePath, temporaryPngPath, "png");
    return 读取PNG贴图(temporaryPngPath);
  } finally {
    if (fs.existsSync(temporaryPngPath)) fs.unlinkSync(temporaryPngPath);
  }
}

function 按角度变换贴图(image, sourceTotalAngle, targetTotalAngle) {
  if (!image || sourceTotalAngle <= 0 || targetTotalAngle <= 0) return image;

  const sourceHalfAngle = sourceTotalAngle * Math.PI / 360;
  const targetHalfAngle = targetTotalAngle * Math.PI / 360;
  const xScale = Math.tan(sourceHalfAngle) / Math.tan(targetHalfAngle);
  const centerX = image.width / 2;
  const rgba = new Uint8ClampedArray(image.width * image.height * 4);

  for (let y = 0; y < image.height; y++) {
    for (let x = 0; x < image.width; x++) {
      const sourceX = centerX + (x - centerX) * xScale;
      if (sourceX < 0 || sourceX >= image.width - 1) continue;

      const left = Math.floor(sourceX);
      const right = left + 1;
      const ratio = sourceX - left;
      const outputIndex = (y * image.width + x) * 4;
      const leftIndex = (y * image.width + left) * 4;
      const rightIndex = (y * image.width + right) * 4;
      for (let channel = 0; channel < 4; channel++) {
        rgba[outputIndex + channel] = Math.round(
          image.rgba[leftIndex + channel] * (1 - ratio) + image.rgba[rightIndex + channel] * ratio
        );
      }
    }
  }

  return { width: image.width, height: image.height, rgba };
}

function 重采样贴图(image, targetSize) {
  if (!image || targetSize <= 0 || (image.width === targetSize && image.height === targetSize)) return image;

  const rgba = new Uint8ClampedArray(targetSize * targetSize * 4);
  for (let y = 0; y < targetSize; y++) {
    const sourceY = (y + 0.5) * image.height / targetSize - 0.5;
    const top = Math.max(0, Math.min(image.height - 1, Math.floor(sourceY)));
    const bottom = Math.max(0, Math.min(image.height - 1, top + 1));
    const yRatio = Math.max(0, Math.min(1, sourceY - top));

    for (let x = 0; x < targetSize; x++) {
      const sourceX = (x + 0.5) * image.width / targetSize - 0.5;
      const left = Math.max(0, Math.min(image.width - 1, Math.floor(sourceX)));
      const right = Math.max(0, Math.min(image.width - 1, left + 1));
      const xRatio = Math.max(0, Math.min(1, sourceX - left));
      const outputIndex = (y * targetSize + x) * 4;
      const topLeft = (top * image.width + left) * 4;
      const topRight = (top * image.width + right) * 4;
      const bottomLeft = (bottom * image.width + left) * 4;
      const bottomRight = (bottom * image.width + right) * 4;

      for (let channel = 0; channel < 4; channel++) {
        const topValue = image.rgba[topLeft + channel] * (1 - xRatio) + image.rgba[topRight + channel] * xRatio;
        const bottomValue = image.rgba[bottomLeft + channel] * (1 - xRatio) + image.rgba[bottomRight + channel] * xRatio;
        rgba[outputIndex + channel] = Math.round(topValue * (1 - yRatio) + bottomValue * yRatio);
      }
    }
  }

  return { width: targetSize, height: targetSize, rgba };
}

function 缩放范围Y(extent, scale) {
  if (!extent || !extent.min || !extent.max) return;
  extent.min[1] *= scale;
  extent.max[1] *= scale;
  extent.boundsRadius = Math.max(extent.boundsRadius, Math.abs(extent.min[1]), Math.abs(extent.max[1]));
}

function 缩放扇形底板横向比例(geoset, scale) {
  if (!geoset || scale <= 0 || scale === 1) return;

  for (let i = 1; i < geoset.vertices.length; i += 3) {
    geoset.vertices[i] *= scale;
  }

  缩放范围Y(geoset.extent, scale);
  if (geoset.sequenceExtents) {
    for (const extent of geoset.sequenceExtents) 缩放范围Y(extent, scale);
  }
}

function 尝试读取原始风格贴图() {
  if (使用共享原始贴图) return null;
  if (sectorAngle === 80 && sectorSuffix === "") return null;
  if (!fs.existsSync(baseFillTexturePath)) return null;

  const 原始轮廓 = fs.existsSync(aiSectorPath)
    ? 读取PNG贴图(aiSectorPath)
    : (fs.existsSync(baseOutlineTexturePath) ? 读取BLP贴图(baseOutlineTexturePath) : null);
  if (!原始轮廓) return null;

  return {
    轮廓: 重采样贴图(按角度变换贴图(原始轮廓, 80, sectorAngle), sectorOutlineTextureSize),
    填充: 重采样贴图(按角度变换贴图(读取BLP贴图(baseFillTexturePath), 80, sectorAngle), Math.min(sectorOutlineTextureSize, 256)),
  };
}

function getMdlxTools() {
  const extensionRoot = path.join(
    process.env.USERPROFILE || "",
    ".vscode",
    "extensions",
    "syh1906.war3-texture-preview-1.2.4-win32-x64"
  );
  const mdlxRoot = path.join(extensionRoot, "node_modules", "mdx-m3-viewer", "dist", "cjs", "parsers", "mdlx");
  const tools = require(mdlxRoot).default;
  const animations = require(path.join(mdlxRoot, "animations.js"));
  return { ...tools, ...animations };
}

const fillPixels = new Uint8ClampedArray(SIZE * SIZE * 4);
const outlinePixels = new Uint8ClampedArray(SIZE * SIZE * 4);
const apexX = SIZE / 2;
const apexY = SIZE - 8;
// 模型网格前向约 450、横向约 900；贴图虽是正方形，但世界坐标不是正方形。
// 所有扇形距离必须先换算到模型世界坐标，否则圆弧会在贴图左右两侧被裁断。
const modelForwardLength = 450;
const modelLateralWidth = 900;
const outerRadius = 420;
const halfAngle = sectorAngle * Math.PI / 360;

function smoothstep(a, b, value) {
  const t = Math.max(0, Math.min(1, (value - a) / (b - a)));
  return t * t * (3 - 2 * t);
}

function addPixel(target, x, y, r, g, b, alpha) {
  if (x < 0 || y < 0 || x >= SIZE || y >= SIZE || alpha <= 0) return;
  const i = (y * SIZE + x) * 4;
  const sourceAlpha = Math.max(0, Math.min(1, alpha / 255));
  const targetAlpha = target[i + 3] / 255;
  const outputAlpha = sourceAlpha + targetAlpha * (1 - sourceAlpha);
  if (outputAlpha <= 0) return;
  target[i] = Math.round((r * sourceAlpha + target[i] * targetAlpha * (1 - sourceAlpha)) / outputAlpha);
  target[i + 1] = Math.round((g * sourceAlpha + target[i + 1] * targetAlpha * (1 - sourceAlpha)) / outputAlpha);
  target[i + 2] = Math.round((b * sourceAlpha + target[i + 2] * targetAlpha * (1 - sourceAlpha)) / outputAlpha);
  target[i + 3] = Math.round(outputAlpha * 255);
}

function lineDistance(px, py, ax, ay, bx, by) {
  const dx = bx - ax;
  const dy = by - ay;
  const t = Math.max(0, Math.min(1, ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy)));
  return Math.hypot(px - ax - dx * t, py - ay - dy * t);
}

function drawLine(ax, ay, bx, by, width, alpha) {
  const minX = Math.floor(Math.min(ax, bx) - width - 1);
  const maxX = Math.ceil(Math.max(ax, bx) + width + 1);
  const minY = Math.floor(Math.min(ay, by) - width - 1);
  const maxY = Math.ceil(Math.max(ay, by) + width + 1);
  for (let y = minY; y <= maxY; y++) {
    for (let x = minX; x <= maxX; x++) {
      const d = lineDistance(x + 0.5, y + 0.5, ax, ay, bx, by);
      if (d < width) addPixel(outlinePixels, x, y, 255, 248, 218, alpha * (1 - d / width));
    }
  }
}

// 半透明能量底面、边缘辉光和外弧。
for (let y = 0; y < SIZE; y++) {
  for (let x = 0; x < SIZE; x++) {
    const dx = (x + 0.5 - apexX) * modelLateralWidth / SIZE;
    const forward = (apexY - (y + 0.5)) * modelForwardLength / SIZE;
    if (forward <= 0) continue;
    const radius = Math.hypot(dx, forward);
    const angle = Math.abs(Math.atan2(dx, forward));
    if (radius > outerRadius + 9 || angle > halfAngle + 0.025) continue;

    const center = Math.max(0, 1 - angle / halfAngle);
    const front = smoothstep(20, outerRadius, radius);
    const noise = (Math.sin(radius * 0.095 + angle * 19) + Math.sin(radius * 0.032 - angle * 31)) * 0.5;
    // Additive 在本项目运行环境里最稳：透明区保持纯黑，绝不会压暗整张矩形面片。
    // 通过降低像素 RGB 本身控制填充亮度，不依赖 Blend/BLP alpha。
    const fill = 15 + center * 9 + front * 5 + noise * 2;
    // Neutral grayscale fill: the game's effect RGB can tint it cleanly.
    addPixel(fillPixels, x, y, fill, fill, fill, 255);

    const sideDistance = radius * Math.sin(Math.max(0, halfAngle - angle));
    if (sideDistance < 7) addPixel(outlinePixels, x, y, 255, 255, 242, 255 * (1 - sideDistance / 7));
    if (sideDistance > 14 && sideDistance < 19) {
      addPixel(outlinePixels, x, y, 255, 215, 145, 150 * (1 - Math.abs(sideDistance - 16.5) / 2.5));
    }

    const outerDistance = Math.abs(radius - outerRadius);
    if (outerDistance < 6) addPixel(outlinePixels, x, y, 255, 255, 242, 255 * (1 - outerDistance / 6));
    const innerOutlineDistance = Math.abs(radius - (outerRadius - 13));
    if (innerOutlineDistance < 3) {
      addPixel(outlinePixels, x, y, 255, 205, 125, 165 * (1 - innerOutlineDistance / 3));
    }

    // 内部刻度保持较暗，不能抢过真正的范围轮廓。
    for (const [arcRadius, arcAlpha] of [[125, 28], [245, 38], [350, 52]]) {
      const d = Math.abs(radius - arcRadius);
      if (d < 2.4) addPixel(outlinePixels, x, y, 255, 215, 155, arcAlpha * (1 - d / 2.4));
    }
  }
}

// 左右对称速度纹，呼应参考图中的进攻方向感。
for (const side of [-1, 1]) {
  drawLine(apexX + side * 10, apexY - 58, apexX + side * 38, apexY - 166, 1.3, 82);
  drawLine(apexX + side * 16, apexY - 92, apexX + side * 44, apexY - 196, 0.9, 62);
  drawLine(apexX + side * 24, apexY - 135, apexX + side * 46, apexY - 210, 0.7, 45);
}

function writeTransparentBlp(image, outputPath) {
  writeWarcraftCompatibleTransparentBlp(image, outputPath);
}

function addQuad(vertices, faces, x1, x2, y1, y2, z) {
  const base = vertices.length / 3;
  vertices.push(x1, y1, z, x1, y2, z, x2, y1, z, x2, y2, z);
  faces.push(base, base + 1, base + 2, base + 3, base + 2, base + 1);
}

function addTriangle(vertices, faces, ax, ay, bx, by, cx, cy, z) {
  const base = vertices.length / 3;
  vertices.push(ax, ay, z, bx, by, z, cx, cy, z);
  faces.push(base, base + 1, base + 2);
}

function createArrowGeometry(glow) {
  const vertices = [];
  const faces = [];
  const shaftHalf = glow ? 16 : 8;
  const headHalf = glow ? 62 : 46;
  const z = glow ? 2.5 : 4;
  addQuad(vertices, faces, 30, 286, -shaftHalf, shaftHalf, z);
  addTriangle(vertices, faces, 248, -headHalf, 418, 0, 248, headHalf, z);
  return { vertices, faces };
}

function makeArrowGeoset(Geoset, template, materialId, glow) {
  const geometry = createArrowGeometry(glow);
  const vertexCount = geometry.vertices.length / 3;
  const geoset = new Geoset();
  geoset.vertices = new Float32Array(geometry.vertices);
  geoset.normals = new Float32Array(Array.from({ length: vertexCount }, () => [0, 0, 1]).flat());
  geoset.faceTypeGroups = new Uint32Array([4]);
  geoset.faceGroups = new Uint32Array([geometry.faces.length]);
  geoset.faces = new Uint16Array(geometry.faces);
  geoset.vertexGroups = new Uint8Array(vertexCount);
  geoset.matrixGroups = new Uint32Array([1]);
  geoset.matrixIndices = new Uint32Array([1]);
  geoset.materialId = materialId;
  geoset.selectionGroup = 0;
  geoset.extent = template.extent;
  geoset.sequenceExtents = template.sequenceExtents;
  geoset.uvSets = [new Float32Array(Array.from({ length: vertexCount }, () => [0.5, 0.5]).flat())];
  return geoset;
}

function makeOutlineGeoset(Geoset, template, materialId) {
  const geoset = new Geoset();
  geoset.vertices = new Float32Array(template.vertices);
  for (let i = 2; i < geoset.vertices.length; i += 3) geoset.vertices[i] += 1.5;
  geoset.normals = new Float32Array(template.normals);
  geoset.faceTypeGroups = new Uint32Array(template.faceTypeGroups);
  geoset.faceGroups = new Uint32Array(template.faceGroups);
  geoset.faces = new Uint16Array(template.faces);
  geoset.vertexGroups = new Uint8Array(template.vertexGroups);
  geoset.matrixGroups = new Uint32Array(template.matrixGroups);
  geoset.matrixIndices = new Uint32Array(template.matrixIndices);
  geoset.materialId = materialId;
  geoset.selectionGroup = template.selectionGroup;
  geoset.extent = template.extent;
  geoset.sequenceExtents = template.sequenceExtents;
  geoset.uvSets = template.uvSets.map(uv => new Float32Array(uv));
  return geoset;
}

function makeAdditiveMaterial(Material, Layer, textureId, alpha, priorityPlane) {
  const material = new Material();
  material.flags = 1;
  material.priorityPlane = priorityPlane;
  const layer = new Layer();
  layer.filterMode = 3; // Additive
  layer.flags = 1 | 16 | 32; // Unshaded | TwoSided | Unfogged
  layer.textureId = textureId;
  layer.alpha = alpha;
  material.layers.push(layer);
  return material;
}

function createAnimatedModel() {
  const { Model, Texture, Material, Layer, Geoset, Bone, Vector3Animation } = getMdlxTools();
  const model = new Model();
  model.load(fs.readFileSync(templateModel));
  model.name = `${modelStem}Animated`;
  model.blendTime = 100;
  model.textures[0].path = gameTexturePath;
  model.materials[0].layers[0].filterMode = 3; // Additive：黑色透明区不产生矩形压暗。
  model.materials[0].layers[0].alpha = 1;
  for (const geosetAnimation of model.geosetAnimations) {
    geosetAnimation.color = new Float32Array([1, 1, 1]);
    for (const animation of geosetAnimation.animations) {
      if (animation.name === "KGAC") {
        animation.values = animation.values.map(() => new Float32Array([1, 1, 1]));
      }
    }
  }

  // 统一成：Birth 1 秒、Stand 1 秒循环、Death 0.2 秒。
  model.sequences[0].name = "Birth";
  model.sequences[0].interval = new Uint32Array([0, 1000]);
  model.sequences[0].nonLooping = 1;
  model.sequences[1].name = "Stand";
  model.sequences[1].interval = new Uint32Array([1000, 2000]);
  model.sequences[1].nonLooping = 0;
  model.sequences[2].name = "Death";
  model.sequences[2].interval = new Uint32Array([2000, 2200]);
  model.sequences[2].nonLooping = 1;

  const outlineTexture = new Texture();
  outlineTexture.path = gameOutlinePath;
  model.textures.push(outlineTexture);
  const arrowTexture = new Texture();
  arrowTexture.path = gameGlowPath;
  model.textures.push(arrowTexture);
  model.materials.push(makeAdditiveMaterial(Material, Layer, 1, 1, 1));
  model.materials.push(makeAdditiveMaterial(Material, Layer, 2, 0.24, 2));
  model.materials.push(makeAdditiveMaterial(Material, Layer, 2, 0.92, 3));

  const arrowBone = new Bone();
  arrowBone.name = "ArrowExtend";
  arrowBone.objectId = 1;
  arrowBone.geosetId = -1;
  arrowBone.geosetAnimationId = -1;
  const scaling = new Vector3Animation();
  scaling.name = "KGSC";
  scaling.interpolationType = 1; // Linear
  scaling.frames = [0, 100, 700, 1000, 1250, 1500, 1750, 2000, 2200];
  scaling.values = [
    [0.01, 0.78, 1], [0.08, 0.88, 1], [0.66, 1.04, 1], [1, 1, 1],
    [1, 1.08, 1], [1, 0.96, 1], [1, 1.08, 1], [1, 1, 1], [1, 0.01, 1],
  ].map(value => new Float32Array(value));
  arrowBone.animations.push(scaling);
  model.bones.push(arrowBone);
  model.pivotPoints.push(new Float32Array([0, 0, 0]));

  const templateGeoset = model.geosets[0];
  if (使用共享原始贴图) {
    缩放扇形底板横向比例(templateGeoset, 扇形底板横向比例);
  }
  model.geosets.push(makeOutlineGeoset(Geoset, templateGeoset, 1));
  model.geosets.push(makeArrowGeoset(Geoset, templateGeoset, 2, true));
  model.geosets.push(makeArrowGeoset(Geoset, templateGeoset, 3, false));
  const lateralExtent = 450 * (使用共享原始贴图 ? 扇形底板横向比例 : 1);
  model.extent.min = new Float32Array([-25, -lateralExtent, 0]);
  model.extent.max = new Float32Array([425, lateralExtent, 6]);
  model.extent.boundsRadius = Math.max(620, Math.sqrt(450 * 450 + lateralExtent * lateralExtent));
  return Buffer.from(model.saveMdx());
}

const 原始风格贴图 = 尝试读取原始风格贴图();
if (使用共享原始贴图) {
  // 角度变体复用原始贴图，角度由 MDX 底板横向比例表达，避免重复导入大贴图。
} else if (原始风格贴图) {
  writeTransparentBlp(原始风格贴图.轮廓, outputTexture);
  writeTransparentBlp(原始风格贴图.填充, fillTexture);
} else if (sectorAngle === 80 && sectorSuffix === "" && fs.existsSync(aiSectorPath)) {
  writeTransparentBlp(读取PNG贴图(aiSectorPath), outputTexture);
  writeTransparentBlp({ width: SIZE, height: SIZE, rgba: fillPixels }, fillTexture);
} else {
  writeTransparentBlp({ width: SIZE, height: SIZE, rgba: outlinePixels }, outputTexture);
  writeTransparentBlp({ width: SIZE, height: SIZE, rgba: fillPixels }, fillTexture);
}
if (!使用共享原始贴图) {
  const glowPixels = new Uint8ClampedArray(8 * 8 * 4);
  for (let i = 0; i < glowPixels.length; i += 4) {
    glowPixels[i] = 255;
    glowPixels[i + 1] = 255;
    glowPixels[i + 2] = 255;
    glowPixels[i + 3] = 255;
  }
  // Glow 贴图是全不透明白色，由材质 alpha 控制亮度，不属于透明面片贴图。
  fs.writeFileSync(glowTexture, getTextureTools().encodeTextureBuffer({ width: 8, height: 8, rgba: glowPixels }, "blp"));
}
fs.writeFileSync(outputModel, createAnimatedModel());
console.log(`sector angle ${sectorAngle} degrees`);
console.log(`created ${path.relative(root, outputModel)}`);
if (!使用共享原始贴图) {
  console.log(`created ${path.relative(root, outputTexture)}`);
  console.log(`created ${path.relative(root, fillTexture)}`);
  console.log(`created ${path.relative(root, glowTexture)}`);
} else {
  console.log(`reused ${贴图前缀}*.blp`);
}
