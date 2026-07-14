const fs = require('fs');
const path = require('path');

const extensionRoot = path.join(
  process.env.USERPROFILE || '',
  '.vscode',
  'extensions',
  'syh1906.war3-texture-preview-1.2.4-win32-x64',
);
const { decodeTextureBuffer, encodeTextureBuffer } = require(
  path.join(extensionRoot, 'out', 'conversion', 'textureConvert.js'),
);

const projectRoot = path.resolve(__dirname, '..');
const sourcePath = path.join(projectRoot, 'image_temp', 'AinzUndeadArrowTexture-alpha.png');
const previewPath = path.join(projectRoot, 'image_temp', 'AinzUndeadArrowTexture-256.png');
const textureDirectory = path.join(projectRoot, 'imports', 'Common', 'Effect', 'Form', 'RiseFall', 'Texture');
const outputPath = path.join(textureDirectory, 'AinzUndeadArrowVolley.blp');
const outputWidth = 256;
const outputHeight = 128;

if (!fs.existsSync(sourcePath)) {
  throw new Error(`Missing chroma-keyed source: ${sourcePath}`);
}

const source = decodeTextureBuffer(fs.readFileSync(sourcePath), 'png');
let minX = source.width;
let minY = source.height;
let maxX = -1;
let maxY = -1;
for (let y = 0; y < source.height; y += 1) {
  for (let x = 0; x < source.width; x += 1) {
    if (source.rgba[(y * source.width + x) * 4 + 3] > 8) {
      minX = Math.min(minX, x);
      minY = Math.min(minY, y);
      maxX = Math.max(maxX, x);
      maxY = Math.max(maxY, y);
    }
  }
}
if (maxX < minX || maxY < minY) {
  throw new Error('Generated arrow texture has no visible pixels');
}

const padding = 12;
minX = Math.max(0, minX - padding);
minY = Math.max(0, minY - padding);
maxX = Math.min(source.width - 1, maxX + padding);
maxY = Math.min(source.height - 1, maxY + padding);
const cropWidth = maxX - minX + 1;
const cropHeight = maxY - minY + 1;
const scale = Math.min(248 / cropWidth, 112 / cropHeight);
const drawWidth = Math.max(1, Math.round(cropWidth * scale));
const drawHeight = Math.max(1, Math.round(cropHeight * scale));
const offsetX = Math.floor((outputWidth - drawWidth) / 2);
const offsetY = Math.floor((outputHeight - drawHeight) / 2);
const rgba = new Uint8ClampedArray(outputWidth * outputHeight * 4);

function samplePremultiplied(x, y) {
  const x0 = Math.max(0, Math.min(source.width - 1, Math.floor(x)));
  const y0 = Math.max(0, Math.min(source.height - 1, Math.floor(y)));
  const x1 = Math.min(source.width - 1, x0 + 1);
  const y1 = Math.min(source.height - 1, y0 + 1);
  const tx = x - x0;
  const ty = y - y0;
  const samples = [
    [x0, y0, (1 - tx) * (1 - ty)],
    [x1, y0, tx * (1 - ty)],
    [x0, y1, (1 - tx) * ty],
    [x1, y1, tx * ty],
  ];
  let alpha = 0;
  let red = 0;
  let green = 0;
  let blue = 0;
  for (const [sampleX, sampleY, weight] of samples) {
    const index = (sampleY * source.width + sampleX) * 4;
    const sampleAlpha = source.rgba[index + 3] / 255;
    alpha += sampleAlpha * weight;
    red += source.rgba[index] * sampleAlpha * weight;
    green += source.rgba[index + 1] * sampleAlpha * weight;
    blue += source.rgba[index + 2] * sampleAlpha * weight;
  }
  if (alpha <= 0.001) return [0, 0, 0, 0];
  return [red / alpha, green / alpha, blue / alpha, alpha * 255];
}

for (let y = 0; y < drawHeight; y += 1) {
  for (let x = 0; x < drawWidth; x += 1) {
    const sourceX = minX + (x + 0.5) / scale - 0.5;
    const sourceY = minY + (y + 0.5) / scale - 0.5;
    const color = samplePremultiplied(sourceX, sourceY);
    const outputIndex = ((offsetY + y) * outputWidth + offsetX + x) * 4;
    for (let channel = 0; channel < 4; channel += 1) rgba[outputIndex + channel] = color[channel];
  }
}

const image = { width: outputWidth, height: outputHeight, rgba };
fs.mkdirSync(textureDirectory, { recursive: true });
fs.writeFileSync(previewPath, encodeTextureBuffer(image, 'png'));
fs.writeFileSync(outputPath, encodeTextureBuffer(image, 'blp'));

const decoded = decodeTextureBuffer(fs.readFileSync(outputPath), 'blp');
let transparentPixels = 0;
let visiblePixels = 0;
for (let index = 3; index < decoded.rgba.length; index += 4) {
  if (decoded.rgba[index] === 0) transparentPixels += 1;
  if (decoded.rgba[index] > 16) visiblePixels += 1;
}
if (decoded.width !== outputWidth || decoded.height !== outputHeight || transparentPixels === 0 || visiblePixels === 0) {
  throw new Error('BLP round-trip verification failed');
}

process.stdout.write(JSON.stringify({
  sourcePath,
  previewPath,
  outputPath,
  width: decoded.width,
  height: decoded.height,
  bytes: fs.statSync(outputPath).size,
  transparentPixels,
  visiblePixels,
}, null, 2));
