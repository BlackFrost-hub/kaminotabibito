/** Install the unified white telegraph artwork and add 1-second animated arrows. */
const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const sourceDir = path.join(root, "image_temp", "telegraph-style");
const outputDir = path.join(root, "imports", "resource", "models", "Tip", "skillTip");
const templateDir = path.join(__dirname, "assets", "telegraph-templates");
const extensionRoot = path.join(
  process.env.USERPROFILE || "",
  ".vscode",
  "extensions",
  "syh1906.war3-texture-preview-1.2.4-win32-x64"
);
const mdlxRoot = path.join(
  extensionRoot,
  "node_modules",
  "mdx-m3-viewer",
  "dist",
  "cjs",
  "parsers",
  "mdlx"
);
const { decodeTextureBuffer, encodeTextureBuffer } = require(
  path.join(extensionRoot, "out", "conversion", "textureConvert.js")
);
const { Model, Texture, Material, Layer, Geoset, Bone } = require(mdlxRoot).default;
const { Vector3Animation } = require(path.join(mdlxRoot, "animations.js"));

const arrowGamePath = "resource\\models\\Tip\\skillTip\\UnifiedTip_Arrow.blp";

function pngToBlp(sourceName, outputName) {
  const source = path.join(sourceDir, sourceName);
  const output = path.join(outputDir, outputName);
  const image = decodeTextureBuffer(fs.readFileSync(source), "png");
  fs.writeFileSync(output, encodeTextureBuffer(image, "blp"));
  console.log(`created ${path.relative(root, output)}`);
}

function createWhiteArrowBlp() {
  const rgba = new Uint8ClampedArray(8 * 8 * 4);
  rgba.fill(255);
  const output = path.join(outputDir, "UnifiedTip_Arrow.blp");
  fs.writeFileSync(output, encodeTextureBuffer({ width: 8, height: 8, rgba }, "blp"));
  console.log(`created ${path.relative(root, output)}`);
}

function makeAdditiveMaterial(textureId, alpha, priorityPlane) {
  const material = new Material();
  material.flags = 1;
  material.priorityPlane = priorityPlane;
  const layer = new Layer();
  layer.filterMode = 3;
  layer.flags = 1 | 16 | 32;
  layer.textureId = textureId;
  layer.alpha = alpha;
  material.layers.push(layer);
  return material;
}

function addArrowMaterials(model, glowAlpha = 0.26) {
  const texture = new Texture();
  texture.path = arrowGamePath;
  const textureId = model.textures.length;
  model.textures.push(texture);
  const glowMaterialId = model.materials.length;
  model.materials.push(makeAdditiveMaterial(textureId, glowAlpha, 8));
  const bodyMaterialId = model.materials.length;
  model.materials.push(makeAdditiveMaterial(textureId, 0.94, 9));
  return { glowMaterialId, bodyMaterialId };
}

function addQuad(vertices, faces, ax, ay, bx, by, cx, cy, dx, dy, z) {
  const base = vertices.length / 3;
  vertices.push(ax, ay, z, bx, by, z, cx, cy, z, dx, dy, z);
  faces.push(base, base + 1, base + 2, base, base + 2, base + 3);
}

function addTriangle(vertices, faces, ax, ay, bx, by, cx, cy, z) {
  const base = vertices.length / 3;
  vertices.push(ax, ay, z, bx, by, z, cx, cy, z);
  faces.push(base, base + 1, base + 2);
}

function extentForVertices(vertices) {
  let minX = Infinity;
  let minY = Infinity;
  let minZ = Infinity;
  let maxX = -Infinity;
  let maxY = -Infinity;
  let maxZ = -Infinity;
  for (let i = 0; i < vertices.length; i += 3) {
    minX = Math.min(minX, vertices[i]);
    minY = Math.min(minY, vertices[i + 1]);
    minZ = Math.min(minZ, vertices[i + 2]);
    maxX = Math.max(maxX, vertices[i]);
    maxY = Math.max(maxY, vertices[i + 1]);
    maxZ = Math.max(maxZ, vertices[i + 2]);
  }
  return {
    min: new Float32Array([minX, minY, minZ]),
    max: new Float32Array([maxX, maxY, maxZ]),
    boundsRadius: Math.max(Math.hypot(minX, minY), Math.hypot(maxX, maxY)),
  };
}

function makeArrowGeoset(model, vertices, faces, materialId, boneId) {
  const geoset = new Geoset();
  const vertexCount = vertices.length / 3;
  geoset.vertices = new Float32Array(vertices);
  geoset.normals = new Float32Array(Array.from({ length: vertexCount }, () => [0, 0, 1]).flat());
  geoset.faceTypeGroups = new Uint32Array([4]);
  geoset.faceGroups = new Uint32Array([faces.length]);
  geoset.faces = new Uint16Array(faces);
  geoset.vertexGroups = new Uint8Array(vertexCount);
  geoset.matrixGroups = new Uint32Array([1]);
  geoset.matrixIndices = new Uint32Array([boneId]);
  geoset.materialId = materialId;
  geoset.selectionGroup = 0;
  // Arrow geometry stays inside the source telegraph bounds, so the parser's
  // native extent objects can be reused without rebuilding binary MDX structs.
  geoset.extent = model.geosets[0].extent;
  geoset.sequenceExtents = model.geosets[0].sequenceExtents;
  geoset.uvSets = [new Float32Array(Array.from({ length: vertexCount }, () => [0.5, 0.5]).flat())];
  return geoset;
}

function animatedScale(model, axis) {
  const keys = new Map();
  const small = axis === "x" ? [0.015, 1, 1] : [1, 0.015, 1];
  const early = axis === "x" ? [0.08, 1, 1] : [1, 0.08, 1];
  const middle = axis === "x" ? [0.68, 1, 1] : [1, 0.68, 1];
  const full = [1, 1, 1];
  const set = (frame, value) => keys.set(Math.round(frame), value);

  for (const sequence of model.sequences) {
    const [start, end] = sequence.interval;
    const duration = Math.max(1, end - start);
    const name = sequence.name.toLowerCase();
    if (name.includes("birth")) {
      set(start, small);
      set(start + duration * 0.1, early);
      set(start + duration * 0.7, middle);
      set(end, full);
    } else if (name.includes("death")) {
      set(start, full);
      set(end, small);
    } else {
      set(start, full);
      set(end, full);
    }
  }

  const frames = [...keys.keys()].sort((a, b) => a - b);
  const animation = new Vector3Animation();
  animation.name = "KGSC";
  animation.interpolationType = 1;
  animation.frames = frames;
  animation.values = frames.map(frame => new Float32Array(keys.get(frame)));
  return animation;
}

function addArrowBone(model, name, pivot, axis) {
  const objectId = model.pivotPoints.length;
  const bone = new Bone();
  bone.name = name;
  bone.objectId = objectId;
  bone.geosetId = -1;
  bone.geosetAnimationId = -1;
  bone.animations.push(animatedScale(model, axis));
  model.bones.push(bone);
  model.pivotPoints.push(new Float32Array(pivot));
  return objectId;
}

function modelBounds(model) {
  const vertices = model.geosets[0].vertices;
  let minX = Infinity;
  let minY = Infinity;
  let maxX = -Infinity;
  let maxY = -Infinity;
  for (let i = 0; i < vertices.length; i += 3) {
    minX = Math.min(minX, vertices[i]);
    minY = Math.min(minY, vertices[i + 1]);
    maxX = Math.max(maxX, vertices[i]);
    maxY = Math.max(maxY, vertices[i + 1]);
  }
  return { minX, minY, maxX, maxY, width: maxX - minX, length: maxY - minY };
}

function scaleExtentAlongY(extent, factor) {
  if (!extent) return;
  extent.min[1] *= factor;
  extent.max[1] *= factor;
  extent.boundsRadius *= Math.max(1, factor);
}

function scaleModelAlongY(model, factor) {
  for (const geoset of model.geosets) {
    for (let i = 1; i < geoset.vertices.length; i += 3) {
      geoset.vertices[i] *= factor;
    }
    scaleExtentAlongY(geoset.extent, factor);
    for (const extent of geoset.sequenceExtents) scaleExtentAlongY(extent, factor);
  }
  for (const pivot of model.pivotPoints) pivot[1] *= factor;
  scaleExtentAlongY(model.extent, factor);
  for (const sequence of model.sequences) scaleExtentAlongY(sequence.extent, factor);
}

const RECT_ARROW_PROFILE = {
  startFraction: 0.12,
  tipFraction: 0.86,
  headLengthByWidth: 0.34,
  shaftHalfGlow: 0.048,
  shaftHalfBody: 0.030,
  headHalfGlow: 0.19,
  headHalfBody: 0.15,
  glowAlpha: 0.18,
};

const LINE_ARROW_PROFILE = {
  startFraction: 0.14,
  tipFraction: 0.74,
  headLengthByWidth: 0.24,
  shaftHalfGlow: 0.040,
  shaftHalfBody: 0.028,
  headHalfGlow: 0.12,
  headHalfBody: 0.095,
  glowAlpha: 0.14,
};

function createLongArrow(bounds, glow, profile) {
  const vertices = [];
  const faces = [];
  const startY = bounds.minY + bounds.length * profile.startFraction;
  const tipY = bounds.minY + bounds.length * profile.tipFraction;
  // The head is width-driven and therefore identical across every aspect
  // ratio; only the shaft gains length in longer preset models.
  const headBaseY = tipY - bounds.width * profile.headLengthByWidth;
  const shaftHalf = bounds.width * (glow ? profile.shaftHalfGlow : profile.shaftHalfBody);
  const headHalf = bounds.width * (glow ? profile.headHalfGlow : profile.headHalfBody);
  const z = glow ? 5 : 7;
  addQuad(
    vertices,
    faces,
    -shaftHalf,
    startY,
    shaftHalf,
    startY,
    shaftHalf,
    headBaseY,
    -shaftHalf,
    headBaseY,
    z
  );
  addTriangle(vertices, faces, -headHalf, headBaseY, headHalf, headBaseY, 0, tipY, z);
  return { vertices, faces, pivot: [0, startY, 0] };
}

function addLongCenterArrow(model, profile = RECT_ARROW_PROFILE) {
  const bounds = modelBounds(model);
  const { glowMaterialId, bodyMaterialId } = addArrowMaterials(model, profile.glowAlpha);
  const glow = createLongArrow(bounds, true, profile);
  const body = createLongArrow(bounds, false, profile);
  const boneId = addArrowBone(model, "ArrowExtendForward", glow.pivot, "y");
  model.geosets.push(makeArrowGeoset(model, glow.vertices, glow.faces, glowMaterialId, boneId));
  model.geosets.push(makeArrowGeoset(model, body.vertices, body.faces, bodyMaterialId, boneId));
}

function addLineCenterArrow(model) {
  addLongCenterArrow(model, LINE_ARROW_PROFILE);
}

function addDirectionalArrow(vertices, faces, angle, inner, tip, headBase, shaftHalf, headHalf, z) {
  const cosine = Math.cos(angle);
  const sine = Math.sin(angle);
  const point = (forward, side) => [
    forward * cosine - side * sine,
    forward * sine + side * cosine,
  ];
  const shaftA = point(inner, -shaftHalf);
  const shaftB = point(headBase, -shaftHalf);
  const shaftC = point(headBase, shaftHalf);
  const shaftD = point(inner, shaftHalf);
  addQuad(
    vertices,
    faces,
    shaftA[0], shaftA[1],
    shaftB[0], shaftB[1],
    shaftC[0], shaftC[1],
    shaftD[0], shaftD[1],
    z
  );
  const headA = point(headBase, -headHalf);
  const headTip = point(tip, 0);
  const headB = point(headBase, headHalf);
  addTriangle(vertices, faces, headA[0], headA[1], headTip[0], headTip[1], headB[0], headB[1], z);
}

function createCircleArrowPair(radius, axis, glow) {
  const vertices = [];
  const faces = [];
  const inner = radius * 0.12;
  const tip = radius * 0.66;
  const headBase = radius * 0.49;
  const shaftHalf = radius * (glow ? 0.031 : 0.022);
  const headHalf = radius * (glow ? 0.115 : 0.095);
  const z = glow ? 5.5 : 6;
  const angles = axis === "x" ? [0, Math.PI] : [Math.PI / 2, -Math.PI / 2];
  for (const angle of angles) {
    addDirectionalArrow(vertices, faces, angle, inner, tip, headBase, shaftHalf, headHalf, z);
  }
  return { vertices, faces };
}

function addFourCircleArrows(model) {
  const bounds = modelBounds(model);
  const radius = Math.max(Math.abs(bounds.minX), Math.abs(bounds.maxX), Math.abs(bounds.minY), Math.abs(bounds.maxY));
  const { glowMaterialId, bodyMaterialId } = addArrowMaterials(model, 0.16);
  const horizontalBoneId = addArrowBone(model, "ArrowExtendEastWest", [0, 0, 0], "x");
  const verticalBoneId = addArrowBone(model, "ArrowExtendNorthSouth", [0, 0, 0], "y");

  for (const [axis, boneId] of [["x", horizontalBoneId], ["y", verticalBoneId]]) {
    const glow = createCircleArrowPair(radius, axis, true);
    const body = createCircleArrowPair(radius, axis, false);
    model.geosets.push(makeArrowGeoset(model, glow.vertices, glow.faces, glowMaterialId, boneId));
    model.geosets.push(makeArrowGeoset(model, body.vertices, body.faces, bodyMaterialId, boneId));
  }
}

function neutralizeColorAnimations(model) {
  for (const geosetAnimation of model.geosetAnimations) {
    geosetAnimation.color = new Float32Array([1, 1, 1]);
    for (const animation of geosetAnimation.animations) {
      if (animation.name === "KGAC") {
        animation.values = animation.values.map(() => new Float32Array([1, 1, 1]));
      }
    }
  }
}

function normalizeBirthToOneSecond(model) {
  for (const sequence of model.sequences) {
    if (sequence.name.toLowerCase().includes("birth")) {
      const start = sequence.interval[0];
      sequence.interval = new Uint32Array([start, start + 1000]);
      sequence.nonLooping = 1;
    }
  }
}

function patchModelTexture(templateName, outputName, oldGamePath, newGamePath, enhance) {
  const model = fs.readFileSync(path.join(templateDir, templateName));
  const oldPath = Buffer.from(`${oldGamePath}\0`, "ascii");
  const newPath = Buffer.from(`${newGamePath}\0`, "ascii");
  const offset = model.indexOf(oldPath);
  if (offset < 0) throw new Error(`${templateName}: texture path not found: ${oldGamePath}`);
  if (newPath.length > 260) throw new Error(`Texture path exceeds the 260-byte MDX slot: ${newGamePath}`);
  model.fill(0, offset, offset + 260);
  newPath.copy(model, offset);
  const parsed = new Model();
  parsed.load(model);
  neutralizeColorAnimations(parsed);
  normalizeBirthToOneSecond(parsed);
  enhance(parsed);
  const output = path.join(outputDir, outputName);
  fs.writeFileSync(output, Buffer.from(parsed.saveMdx()));
  console.log(`created ${path.relative(root, output)}`);
}

const oldSquarePath = "resource\\models\\Tip\\skillTip\\Abiltip_Square.blp";
const oldRingPath = "resource\\models\\Tip\\skillTip\\Mr.War3_Ring.blp";
const oldThickRingPath = "resource\\models\\Tip\\skillTip\\Abiltip_ring.blp";
const oldPingPath = "UI\\MiniMap\\ping4.blp";
const rectPath = "resource\\models\\Tip\\skillTip\\UnifiedTip_Rect.blp";
const linePath = "resource\\models\\Tip\\skillTip\\UnifiedTip_Line.blp";
const ringPath = "resource\\models\\Tip\\skillTip\\UnifiedTip_Ring.blp";

pngToBlp("telegraph-rectangle-white.png", "UnifiedTip_Rect.blp");
pngToBlp("telegraph-line-white.png", "UnifiedTip_Line.blp");
pngToBlp("telegraph-ring-white.png", "UnifiedTip_Ring.blp");
createWhiteArrowBlp();

for (let ratio = 1; ratio <= 6; ratio++) {
  patchModelTexture(
    `Abiltip_Square${ratio}x.mdx`,
    `UnifiedTip_Rect${ratio}x.mdx`,
    oldSquarePath,
    rectPath,
    addLongCenterArrow
  );
}
for (const [templateRatio, targetRatio] of [[1, 1.5], [2, 2.5], [3, 3.5]]) {
  patchModelTexture(
    `Abiltip_Square${templateRatio}x.mdx`,
    `UnifiedTip_Rect${String(targetRatio).replace(".", "_")}x.mdx`,
    oldSquarePath,
    rectPath,
    model => {
      scaleModelAlongY(model, targetRatio / templateRatio);
      addLongCenterArrow(model);
    }
  );
}
for (let ratio = 1; ratio <= 6; ratio++) {
  patchModelTexture(
    `Abiltip_Square${ratio}x.mdx`,
    `UnifiedTip_Line${ratio}x.mdx`,
    oldSquarePath,
    linePath,
    addLineCenterArrow
  );
}
for (const [templateRatio, targetRatio] of [[1, 1.5], [2, 2.5], [3, 3.5]]) {
  patchModelTexture(
    `Abiltip_Square${templateRatio}x.mdx`,
    `UnifiedTip_Line${String(targetRatio).replace(".", "_")}x.mdx`,
    oldSquarePath,
    linePath,
    model => {
      scaleModelAlongY(model, targetRatio / templateRatio);
      addLineCenterArrow(model);
    }
  );
}
patchModelTexture("mr.war3_ring.mdx", "UnifiedTip_Ring.mdx", oldRingPath, ringPath, addFourCircleArrows);
patchModelTexture("Abiltip_ring.mdx", "UnifiedTip_RingThick.mdx", oldThickRingPath, ringPath, addFourCircleArrows);
patchModelTexture("Tip_ring_A.mdx", "UnifiedTip_Ring_A.mdx", oldPingPath, ringPath, addFourCircleArrows);
patchModelTexture("Tip_ring_B.mdx", "UnifiedTip_Ring_B.mdx", oldPingPath, ringPath, addFourCircleArrows);
patchModelTexture("Tip_ring_C.mdx", "UnifiedTip_Ring_C.mdx", oldPingPath, ringPath, addFourCircleArrows);
