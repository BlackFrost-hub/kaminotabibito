const crypto = require('crypto');
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const projectRoot = path.resolve(__dirname, '..');
const bossEffectRoot = path.join(
  projectRoot,
  'TS',
  '系统',
  '03．技能系统',
  '05．单位技能',
  '03．Boss技能',
);
const candidateRecordPath = path.join(bossEffectRoot, 'Boss特效候选筛选记录.md');
const libraryRecordPath = path.join(bossEffectRoot, '特效库.md');
const manifestPath = path.join(__dirname, 'boss-effect-candidate-manifest.json');
const migrationResultPath = path.join(__dirname, 'boss-effect-migration-results.json');
const projectEffectRoot = path.join(projectRoot, 'imports', 'Common', 'Effect');
const projectImportsRoot = path.join(projectRoot, 'imports');
const physicalLibraryRoots = [
  'C:\\Users\\Administrator\\Desktop\\魔法效果',
  'C:\\Users\\Administrator\\Desktop\\特效（特效w3x整合出来的）',
  'C:\\Users\\Administrator\\Desktop\\特效库',
];
const supplementalModelSourceRoots = [
  path.join(projectRoot, 'map', 'resource'),
];
const modelSourceAliases = new Map([
  ['tx23.mdx', ['tx 23.mdx']],
  ['tx27.mdx', ['tx 27.mdx']],
]);
const preferredSourcePaths = new Map([
  ['!blackgetsuga!.mdx', 'C:\\Users\\Administrator\\Desktop\\魔法效果\\冲击\\blackgetsuga\\!blackgetsuga!.mdx'],
  ['5.mdx', 'C:\\Users\\Administrator\\Desktop\\特效库\\技能特效1 (1)\\5\\5.mdx'],
  ['51.mdx', 'C:\\Users\\Administrator\\Desktop\\特效库\\技能特效1 (1)\\51\\51.mdx'],
  ['entanglingbonestarget.mdx', 'C:\\Users\\Administrator\\Desktop\\魔法效果\\其他\\EntanglingBonesTarget.mdx'],
  ['fate.mdx', 'C:\\Users\\Administrator\\Desktop\\魔法效果\\魔幻\\菲特魔法阵\\fate.mdx'],
  ['grandundeadaura.mdx', 'C:\\Users\\Administrator\\Desktop\\魔法效果\\邪恶\\六芒星光环\\GrandUndeadAura.mdx'],
]);
const documentedMigrationTargets = new Map([
  ['[tx] (1285).mdx', 'Common\\Effect\\Form\\Shield\\AlbedoDarkGoldBarrier.mdx'],
  ['[tx] (757).mdx', 'Common\\Effect\\Form\\Debuff\\AlbedoWingBindCore.mdx'],
  ['2.mdx', 'Common\\Effect\\Form\\RiseFall\\ShalltearBloodRebirthWeave.mdx'],
  ['blackakiha.mdx', 'Common\\Effect\\Form\\Line\\BansheeGrayShockwave.mdx'],
  ['equipmentshieldflash.mdx', 'Common\\Effect\\Form\\Shield\\AlbedoDarkGoldBarrier.mdx'],
  ['sem_lan_huo.mdx', 'Common\\Effect\\Form\\RiseFall\\AronkosDefeatDissolve.mdx'],
  ['sem_nv_shen_zhi_tong.mdx', 'Common\\Effect\\Form\\RiseFall\\ShalltearBloodRebirthShell.mdx'],
  ['spiritarrow_byepsilon.mdx', 'Common\\Effect\\Form\\RiseFall\\AinzUndeadArrowVolley.mdx'],
  ['texiao000054.mdx', 'Common\\Effect\\Form\\Explosion\\AlbedoDarkGoldBarrierBreak.mdx'],
  ['texiao000681.mdx', 'Common\\Effect\\Form\\Line\\ShalltearBloodReturnRibbon.mdx'],
  ['tx131.mdx', 'Common\\Effect\\Form\\Line\\AinzRealityFracture.mdx'],
  ['vfx_heartbreak_bb.mdx', 'Common\\Effect\\Form\\Debuff\\AinzHeartGrasp.mdx'],
  ['wing000025.mdx', 'Common\\Effect\\Form\\Debuff\\AlbedoWingBind.mdx'],
  ['yue.mdx', 'Common\\Effect\\Form\\RiseFall\\ShalltearBloodMoonAux.mdx'],
]);

const deterministicMigrationPlans = new Map(Object.entries({
  '23ys_hitblp1.mdx': { category: ['Form', 'MagicCircle'], fileName: 'AinzFallingSkyMagicCircle.mdx' },
  '398.mdx': { category: ['Form', 'Spread'], fileName: 'AlbedoBlackWingSweepPressure.mdx' },
  '422.mdx': { category: ['Form', 'Illusion'], fileName: 'ShalltearBloodMirrorSurface.mdx' },
  'bigyelloworbshield.mdx': { category: ['Form', 'Shield'], fileName: 'BigYellowOrbShield.mdx' },
  'blackhole2.mdx': { category: ['Element', 'Dark'], fileName: 'blackhole2.mdx' },
  'blightwalkeraura.mdx': { category: ['Form', 'Aura'], fileName: 'BlightwalkerAura.mdx' },
  'dds2136-01.mdx': { category: ['Form', 'Debuff'], fileName: 'dds2136-01.mdx' },
  'deathwave.mdx': { category: ['Form', 'Line'], fileName: 'DeathWave.mdx' },
  'dustwave.mdx': { category: ['Form', 'Explosion'], fileName: 'dustwave.mdx' },
  'electricblizztarget2.mdx': { category: ['Form', 'RiseFall'], fileName: 'ElectricBlizzTarget2.mdx' },
  'fate.mdx': { category: ['Form', 'MagicCircle'], fileName: 'fate.mdx' },
  'holyshield_state.mdx': { category: ['Form', 'Shield'], fileName: 'holyshield_state.mdx' },
  'jntx (305).mdx': { category: ['Form', 'MagicCircle'], fileName: 'SpiritGuardSoulSeal.mdx' },
  'jntx (418).mdx': { category: ['Form', 'Rotate'], fileName: 'ShalltearBloodMoonHorizontalSlash.mdx' },
  'jntx (422).mdx': { category: ['Form', 'Rotate'], fileName: 'ShalltearBloodMoonDiagonalSlash.mdx' },
  'long.mdx': { category: ['Form', 'Aura'], fileName: 'long.MDX' },
  'peasantgrave1.mdx': { category: ['Form', 'Marker'], fileName: 'PeasantGrave1.mdx' },
  'qianbenying8.mdx': { category: ['Form', 'Spread'], fileName: 'qianbenying8.mdx' },
  'qishi.mdx': { category: ['Form', 'Illusion'], fileName: 'qishi.mdx' },
  'tx_cb_anyingcb.mdx': { category: ['Form', 'Spread'], fileName: 'AlbedoShadowWingSweep.mdx' },
  'tx_jn_xuechi.mdx': { category: ['Form', 'MagicCircle'], fileName: 'ShalltearBloodPoolRitual.mdx' },
  'tx132.mdx': { category: ['Form', 'Spread'], fileName: 'AlbedoWingFeather.mdx' },
  'xxx10.mdx': { category: ['Form', 'MagicCircle'], fileName: 'AronkosSoulSwordSigil.mdx' },
  'yaya d texiao.mdx': { category: ['Form', 'Spread'], fileName: 'AlbedoWhiteVioletWingSweep.mdx' },
  'yaya morph texiao.mdx': { category: ['Form', 'Explosion'], fileName: 'ShalltearRebirthBurst.mdx' },
  'yelloworbshield.mdx': { category: ['Form', 'Shield'], fileName: 'YellowOrbShield.mdx' },
  'youmu_w_eff1.mdx': { category: ['Form', 'Rotate'], fileName: 'youmu_w_eff1.mdx' },
  'zdgq.mdx': { category: ['Form', 'Explosion'], fileName: 'zdgq.mdx' },
  'jntx (257).mdx': { category: ['Form', 'Debuff'], fileName: 'SpiritGuardMoonBind.mdx' },
  'jntx (491).mdx': { category: ['Form', 'Line'], fileName: 'ShalltearBloodReturnArc.mdx' },
  'tx_jn_qusanbo.mdx': { category: ['Form', 'Spread'], fileName: 'AronkosAwakeningSoulWave.mdx' },
}));
const initialMigrationCandidateNames = new Set(deterministicMigrationPlans.keys());
for (const [sourceName, plan] of Object.entries({
  '!blackgetsuga!.mdx': { category: ['Projectile'], fileName: 'ShalltearBloodMoonCrescent.mdx' },
  '348.mdx': { category: ['Form', 'Aura'], fileName: 'AronkosGraveSoulField.mdx' },
  '368.mdx': { category: ['Form', 'RiseFall'], fileName: 'AronkosSoulReleasePillar.mdx' },
  'bloodsigil.mdx': { category: ['Form', 'MagicCircle'], fileName: 'BloodSigil.mdx' },
  'bloodslam.mdx': { category: ['Form', 'Explosion'], fileName: 'BloodSlam.mdx' },
  'bloody fang.mdx': { category: ['Projectile'], fileName: 'Bloody Fang.mdx' },
  'byakuganaura.mdx': { category: ['Form', 'Debuff'], fileName: 'byakuganaura.mdx' },
  'crimsonwake.mdx': { category: ['Form', 'Spread'], fileName: 'CrimsonWake.mdx' },
  'divineseal.mdx': { category: ['Form', 'MagicCircle'], fileName: 'DivineSeal.mdx' },
  'entanglingbonestarget.mdx': { category: ['Form', 'Debuff'], fileName: 'EntanglingBonesTarget.mdx' },
  'jntx (159).mdx': { category: ['Form', 'Explosion'], fileName: 'AinzFallingSkyImpact.mdx' },
  'jntx (161).mdx': { category: ['Form', 'RiseFall'], fileName: 'AronkosMeteorDescentGuide.mdx' },
  'jntx (272).mdx': { category: ['Form', 'Debuff'], fileName: 'ShalltearBloodDropMark.mdx' },
  'jntx (37).mdx': { category: ['Form', 'MagicCircle'], fileName: 'AinzCastingOuterCircle.mdx' },
  'jntx (371).mdx': { category: ['Form', 'Explosion'], fileName: 'ShalltearRebirthImpact.mdx' },
  'jntx (428).mdx': { category: ['Form', 'Explosion'], fileName: 'AlbedoDarkGoldHeavyImpact.mdx' },
  'jntx (432).mdx': { category: ['Form', 'Line'], fileName: 'AronkosSoulSlashVolley.mdx' },
  'jntx (434).mdx': { category: ['Form', 'Debuff'], fileName: 'AinzTimeStopClockFace.mdx' },
  'jntx (470).mdx': { category: ['Form', 'MagicCircle'], fileName: 'AinzDeathMagicCharge.mdx' },
  'jntx (50).mdx': { category: ['Form', 'Rotate'], fileName: 'AinzBlackGoldPortalVortex.mdx' },
  'jntx (527).mdx': { category: ['Form', 'Line'], fileName: 'AronkosSoulSlashImpact.mdx' },
  'jntx (528).mdx': { category: ['Form', 'Line'], fileName: 'AronkosSoulSlashTrail.mdx' },
  'jntx (530).mdx': { category: ['Form', 'MagicCircle'], fileName: 'AinzUndeadSummonInnerCircle.mdx' },
  'jntx (543).mdx': { category: ['Form', 'Shield'], fileName: 'AlbedoGuardianShieldStatus.mdx' },
  'jntx (549).mdx': { category: ['Form', 'Shield'], fileName: 'AlbedoGuardianShieldBreakMark.mdx' },
  'jntx (553).mdx': { category: ['Form', 'RiseFall'], fileName: 'AronkosSoulReleaseAux.mdx' },
  'jntx (557).mdx': { category: ['Form', 'MagicCircle'], fileName: 'AronkosMeteorGraveRune.mdx' },
  'jntx (564).mdx': { category: ['Form', 'Line'], fileName: 'AinzAlbedoGuardianLink.mdx' },
  'jntx (565).mdx': { category: ['Form', 'Line'], fileName: 'ShalltearBloodReturnLink.mdx' },
  'jntx (91).mdx': { category: ['Form', 'Illusion'], fileName: 'AinzBlackGoldPortalFrame.mdx' },
  'jntx (92).mdx': { category: ['Form', 'MagicCircle'], fileName: 'AinzBlackGoldPortalGroundRing.mdx' },
  'jrfb10.mdx': { category: ['Form', 'Explosion'], fileName: 'AronkosGraveDustWhirl.mdx' },
  'newdirtexnofire.mdx': { category: ['Form', 'Explosion'], fileName: 'AronkosGraveDustImpact.mdx' },
  'powerstone.mdx': { category: ['Form', 'Marker'], fileName: 'PowerStone.mdx' },
  'red quick.mdx': { category: ['Projectile'], fileName: 'Red Quick.mdx' },
  'ringofbright.mdx': { category: ['Form', 'MagicCircle'], fileName: 'RingOfBright.mdx' },
  'senbonzakurapart.mdx': { category: ['Form', 'Spread'], fileName: 'ShalltearRosePetalFragments.mdx' },
  'shatteredhandbanner.mdx': { category: ['Form', 'Marker'], fileName: 'shatteredhandbanner.mdx' },
  'sound.mdx': { category: ['Form', 'Debuff'], fileName: 'AlbedoGoldenRestraintCore.mdx' },
  't_bloodex-special-2.mdx': { category: ['Form', 'Aura'], fileName: 'ShalltearBloodMirrorField.mdx' },
  'tx103.mdx': { category: ['Form', 'Explosion'], fileName: 'ShalltearBloodMoonImpact.mdx' },
  'tx116.mdx': { category: ['Form', 'RiseFall'], fileName: 'AronkosSoulRiseRing.mdx' },
  'tx130.mdx': { category: ['Form', 'MagicCircle'], fileName: 'ShalltearBloodSigilActivation.mdx' },
  'ultradivineseal.mdx': { category: ['Form', 'MagicCircle'], fileName: 'UltraDivineSeal.mdx' },
  'void.mdx': { category: ['Element', 'Dark'], fileName: 'void.mdx' },
  'wisp.mdx': { category: ['Form', 'Aura'], fileName: 'wisp.mdx' },
  'yang_tx1.mdx': { category: ['Form', 'Rotate'], fileName: 'AinzBlackGoldPortalCore.mdx' },
  'yhxingluoblue.mdx': { category: ['Form', 'RiseFall'], fileName: 'AronkosMeteorImpactPillar.mdx' },
  'yx_npc_xuemojian.mdx': { category: ['Form', 'MagicCircle'], fileName: 'ShalltearBloodSwordRitualSigil.mdx' },
})) {
  deterministicMigrationPlans.set(sourceName, plan);
}
for (const [sourceName, plan] of Object.entries({
  'deathgatefull.mdx': { category: ['Form', 'Illusion'], fileName: 'AinzUndeadSummonGate.mdx' },
  'lasercannon.mdx': { category: ['Form', 'RiseFall'], fileName: 'AinzFallingSkyLaser.mdx' },
  'swipecaster.mdx': { category: ['Form', 'Line'], fileName: 'ShalltearWideBloodSweep.mdx' },
  'tx23.mdx': { category: ['Form', 'Explosion'], fileName: 'AronkosGraveSmokeBurst.mdx' },
  'tx27.mdx': { category: ['Form', 'RiseFall'], fileName: 'AronkosSoulLightPillar.mdx' },
  '5.mdx': { category: ['Form', 'MagicCircle'], fileName: 'AinzFallingSkyWarmGoldCircle.mdx' },
  '51.mdx': { category: ['Element', 'Dark'], fileName: 'ShalltearBloodMirrorVoid.mdx' },
  'grandundeadaura.mdx': { category: ['Form', 'MagicCircle'], fileName: 'GrandUndeadAura.mdx' },
  'holyaura.mdx': { category: ['Form', 'Aura'], fileName: 'AinzLifeAnchorHolyAura.mdx' },
  'divinebarrier.mdx': { category: ['Form', 'Shield'], fileName: 'DivineBarrier.mdx' },
  'yellow ball2.mdx': { category: ['Form', 'Aura'], fileName: 'Yellow Ball2.mdx' },
  'jntx (151).mdx': { category: ['Form', 'Explosion'], fileName: 'AronkosMeteorAftershock.mdx' },
  'jntx (160).mdx': { category: ['Form', 'Explosion'], fileName: 'AronkosMeteorLandingBurst.mdx' },
  'jntx (375).mdx': { category: ['Form', 'Debuff'], fileName: 'AinzTimeStopGearFragmentsA.mdx' },
  'jntx (376).mdx': { category: ['Form', 'Debuff'], fileName: 'AinzTimeStopGearFragmentsB.mdx' },
  'jntx (436).mdx': { category: ['Form', 'Spread'], fileName: 'ShalltearBloodPoolSpread.mdx' },
})) {
  deterministicMigrationPlans.set(sourceName, plan);
}

const deepResolvedCandidateNames = new Set([
  'jntx (257).mdx',
  'jntx (491).mdx',
  'tx_jn_qusanbo.mdx',
]);

const explicitExclusionPatterns = [
  /全部不合适/,
  /不采用/,
  /整组淘汰/,
  /明确淘汰/,
  /重复副本/,
  /被更优候选替换/,
];
const positiveDecisionPatterns = [
  /首选/,
  /备选/,
  /保留/,
  /暂用/,
  /已迁入/,
  /已生成/,
  /已派生/,
  /已升级/,
  /已接入待实测/,
  /已实测确认/,
];
const knownWarcraftBuiltinTextures = new Set([
  'buildings\\human\\humanshipyard\\humanshipyard.blp',
  'textures\\blue_star.blp',
  'textures\\flare.blp',
  'textures\\genericglow64.blp',
  'textures\\ribbonblur1.blp',
  'textures\\shadow.blp',
  'textures\\star2_32.blp',
  'textures\\tornado1.blp',
  'textures\\white.blp',
]);
let warcraftBuiltinTextureIndex = {
  installRoot: null,
  archives: [],
  byPath: new Map(),
};

function readWarcraftInstallRootFromRegistry() {
  try {
    const output = execFileSync(
      'reg.exe',
      ['query', 'HKCU\\Software\\Blizzard Entertainment\\Warcraft III', '/v', 'InstallPath'],
      { encoding: 'utf8', windowsHide: true },
    );
    const match = output.match(/InstallPath\s+REG_\w+\s+(.+)$/mi);
    return match ? match[1].trim() : null;
  } catch (error) {
    return null;
  }
}

function buildWarcraftBuiltinTextureIndex() {
  const installRoot = process.env.WAR3_ROOT || readWarcraftInstallRootFromRegistry();
  const mpqCliPath = path.join(projectRoot, 'tools', 'mpqcli', 'mpqcli.exe');
  if (!installRoot || !fs.existsSync(mpqCliPath)) {
    return { installRoot: installRoot || null, archives: [], byPath: new Map() };
  }

  const archiveNames = ['war3.mpq', 'War3x.mpq', 'War3Patch.mpq', 'War3xLocal.mpq'];
  const byPath = new Map();
  const archives = [];
  for (const archiveName of archiveNames) {
    const archivePath = path.join(installRoot, archiveName);
    if (!fs.existsSync(archivePath)) continue;
    const listing = execFileSync(mpqCliPath, ['list', archivePath], {
      encoding: 'utf8',
      maxBuffer: 64 * 1024 * 1024,
      windowsHide: true,
    });
    const files = listing.split(/\r?\n/).map((line) => line.trim()).filter(Boolean);
    archives.push({ name: archiveName, path: archivePath, fileCount: files.length });
    for (const file of files) {
      const normalized = file.replace(/\//g, '\\').toLowerCase();
      if (!/\.(?:blp|tga|dds)$/.test(normalized)) continue;
      if (!byPath.has(normalized)) byPath.set(normalized, []);
      byPath.get(normalized).push(archiveName);
    }
  }
  return { installRoot, archives, byPath };
}

function isKnownWarcraftBuiltinTexture(texturePath) {
  const normalized = texturePath.replace(/\//g, '\\').toLowerCase();
  return knownWarcraftBuiltinTextures.has(normalized) || warcraftBuiltinTextureIndex.byPath.has(normalized);
}

function isBuiltinTextureStatus(status) {
  return status === 'builtin-replaceable' || status === 'builtin-whitelist' || status === 'builtin-mpq';
}

function readUtf8(filePath) {
  return fs.readFileSync(filePath, 'utf8').replace(/^\uFEFF/, '');
}

function splitMarkdownRow(line) {
  const body = line.trim().replace(/^\|/, '').replace(/\|$/, '');
  const cells = [];
  let current = '';
  let escaped = false;
  let inCode = false;
  for (const character of body) {
    if (escaped) {
      current += character;
      escaped = false;
      continue;
    }
    if (character === '\\') {
      current += character;
      escaped = true;
      continue;
    }
    if (character === '`') {
      inCode = !inCode;
      current += character;
      continue;
    }
    if (character === '|' && !inCode) {
      cells.push(current.trim());
      current = '';
      continue;
    }
    current += character;
  }
  cells.push(current.trim());
  return cells;
}

function isSeparatorRow(cells) {
  return cells.length > 0 && cells.every((cell) => /^:?-{3,}:?$/.test(cell));
}

function parseMarkdownTables(text, sourceName) {
  const lines = text.split(/\r?\n/);
  const tables = [];
  for (let index = 0; index < lines.length - 1; index += 1) {
    if (!lines[index].trim().startsWith('|')) continue;
    const headers = splitMarkdownRow(lines[index]);
    const separator = splitMarkdownRow(lines[index + 1]);
    if (headers.length !== separator.length || !isSeparatorRow(separator)) continue;

    const rows = [];
    let rowIndex = index + 2;
    while (rowIndex < lines.length && lines[rowIndex].trim().startsWith('|')) {
      const cells = splitMarkdownRow(lines[rowIndex]);
      const fields = {};
      headers.forEach((header, cellIndex) => {
        fields[header] = cells[cellIndex] || '';
      });
      rows.push({ line: rowIndex + 1, fields, raw: lines[rowIndex] });
      rowIndex += 1;
    }
    tables.push({
      source: sourceName,
      headerLine: index + 1,
      endLine: rowIndex,
      markdownLineCount: rowIndex - index,
      headers,
      rows,
    });
    index = rowIndex - 1;
  }
  return tables;
}

function walkFiles(root, predicate) {
  if (!fs.existsSync(root)) return [];
  const result = [];
  const pending = [root];
  while (pending.length > 0) {
    const current = pending.pop();
    for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
      const fullPath = path.join(current, entry.name);
      if (entry.isDirectory()) pending.push(fullPath);
      else if (predicate(fullPath, entry.name)) result.push(fullPath);
    }
  }
  return result;
}

function sha256(filePath) {
  return crypto.createHash('sha256').update(fs.readFileSync(filePath)).digest('hex').toUpperCase();
}

function normalizeModelName(value) {
  return path.win32.basename(value.trim().replace(/^`|`$/g, '')).trim();
}

function extractCodeSpans(text) {
  return [...text.matchAll(/`([^`]+)`/g)].map((match) => match[1].trim());
}

function extractFallbackMdxNames(text) {
  const names = [];
  const expression = /(?:^|[\\/（(、，,;+；])\s*([^`\\/（(、，,;+；]+?\.mdx)/gi;
  for (const match of text.matchAll(expression)) {
    const name = normalizeModelName(match[1]);
    if (/^\d+\)\.mdx$/i.test(name)) continue;
    if (name.toLowerCase().endsWith('.mdx')) names.push(name);
  }
  return names;
}

function buildKnownNameIndex(modelPaths) {
  const index = new Map();
  for (const modelPath of modelPaths) {
    const name = path.basename(modelPath);
    const key = name.toLowerCase();
    if (!index.has(key)) index.set(key, { name, paths: [] });
    index.get(key).paths.push(modelPath);
  }
  return index;
}

function expandNumericRange(expression, knownNames) {
  const match = expression.match(/^(.+?)(\d+)~(\d+)([^\\/]*)\.mdx$/i);
  if (!match) return [];
  const [, prefix, startText, endText, suffix] = match;
  const start = Number(startText);
  const end = Number(endText);
  const width = Math.max(startText.length, endText.length);
  const names = [];
  for (let value = start; value <= end; value += 1) {
    const expected = `${prefix}${String(value).padStart(width, '0')}${suffix}.mdx`.toLowerCase();
    if (knownNames.has(expected)) names.push(knownNames.get(expected).name);
  }
  return names;
}

function matchModelsInText(text, knownNames) {
  const matched = new Map();
  const expressions = extractCodeSpans(text);
  for (const expression of expressions) {
    const exactName = normalizeModelName(expression);
    for (const name of expandNumericRange(exactName, knownNames)) {
      matched.set(name.toLowerCase(), name);
    }
    if (expression.includes('*')) {
      const base = exactName;
      const pattern = new RegExp(`^${base.replace(/[.+?^${}()|[\\]\\]/g, '\\$&').replace(/\\\*/g, '.*')}${base.toLowerCase().endsWith('.mdx') ? '' : '(?:\\.mdx)?'}$`, 'i');
      for (const [key, value] of knownNames) {
        if (pattern.test(value.name)) matched.set(key, value.name);
      }
    }
    if (!expression.includes('*') && exactName.toLowerCase().endsWith('.mdx') && !exactName.includes('~')) {
      const key = exactName.toLowerCase();
      matched.set(key, knownNames.has(key) ? knownNames.get(key).name : exactName);
    }
  }
  for (const name of extractFallbackMdxNames(text)) {
    const key = name.toLowerCase();
    if (matched.has(key)) continue;
    matched.set(key, knownNames.has(key) ? knownNames.get(key).name : name);
  }
  return [...matched.values()].sort((left, right) => left.localeCompare(right, 'zh-CN'));
}

function classifyDecision(fields) {
  const conclusion = fields['结论'] || fields['状态'] || '';
  const followUp = fields['后续动作'] || fields['替换原因'] || '';
  const combined = `${conclusion} ${followUp}`;
  if (explicitExclusionPatterns.some((pattern) => pattern.test(combined))) return 'excluded';
  if (/未评审/.test(conclusion)) return 'unreviewed';
  if (positiveDecisionPatterns.some((pattern) => pattern.test(conclusion))) return 'included';
  return 'needs-review';
}

function countBy(values) {
  const result = {};
  for (const value of values) result[value || '(empty)'] = (result[value || '(empty)'] || 0) + 1;
  return Object.fromEntries(Object.entries(result).sort((left, right) => right[1] - left[1]));
}

function relativeOrAbsolute(filePath) {
  if (filePath.toLowerCase().startsWith(projectRoot.toLowerCase())) {
    return path.relative(projectRoot, filePath).replace(/\\/g, '/');
  }
  return filePath;
}

function groupSourceIdentities(sourceRecords) {
  const identities = new Map();
  for (const source of sourceRecords) {
    if (!identities.has(source.sha256)) {
      identities.set(source.sha256, {
        sha256: source.sha256,
        bytes: source.bytes,
        paths: [],
        exactProjectMatches: new Set(),
      });
    }
    const identity = identities.get(source.sha256);
    identity.paths.push(source.path);
    source.exactProjectMatches.forEach((projectPath) => identity.exactProjectMatches.add(projectPath));
  }
  return [...identities.values()]
    .map((identity) => ({
      ...identity,
      paths: identity.paths.sort(),
      exactProjectMatches: [...identity.exactProjectMatches].sort(),
    }))
    .sort((left, right) => left.sha256.localeCompare(right.sha256));
}

function findDocumentedAbsoluteModels(...texts) {
  const result = new Set();
  for (const text of texts) {
    for (const code of extractCodeSpans(text)) {
      if (!/^[A-Za-z]:\\/.test(code) || !code.toLowerCase().endsWith('.mdx')) continue;
      if (fs.existsSync(code)) result.add(path.resolve(code));
    }
  }
  return [...result];
}

function findModelLibraryPath() {
  const candidates = [
    process.env.MDX_MODEL_LIB,
    path.join(
      process.env.USERPROFILE || '',
      '.vscode',
      'extensions',
      'syh1906.war3-texture-preview-1.2.4-win32-x64',
      'node_modules',
      'mdx-m3-viewer',
      'dist',
      'cjs',
      'parsers',
      'mdlx',
      'model.js',
    ),
  ].filter(Boolean);
  const found = candidates.find((candidate) => fs.existsSync(candidate));
  if (!found) throw new Error('Cannot locate mdx-m3-viewer model.js; set MDX_MODEL_LIB');
  return found;
}

function normalizePathForLookup(value) {
  return path.resolve(value).replace(/\//g, '\\').toLowerCase();
}

function normalizeTextureReference(value) {
  return value.replace(/\//g, '\\').replace(/^\\+/, '').toLowerCase();
}

function buildTextureIndex(roots) {
  const records = [];
  const byBaseName = new Map();
  const normalizedRoots = roots.map((root) => ({ root: path.resolve(root), normalized: normalizePathForLookup(root) }));
  for (const { root } of normalizedRoots) {
    for (const texturePath of walkFiles(root, (filePath) => /\.(?:blp|tga)$/i.test(filePath))) {
      const record = {
        path: path.resolve(texturePath),
        root,
        relativePath: path.relative(root, texturePath).replace(/\//g, '\\'),
        normalizedPath: normalizePathForLookup(texturePath),
      };
      records.push(record);
      const key = path.basename(texturePath).toLowerCase();
      if (!byBaseName.has(key)) byBaseName.set(key, []);
      byBaseName.get(key).push(record);
    }
  }
  return { records, byBaseName, roots: normalizedRoots };
}

function uniqueExistingPaths(paths) {
  return [...new Set(paths.map((filePath) => path.resolve(filePath)))].filter((filePath) => fs.existsSync(filePath));
}

function dependencySourceRecords(paths) {
  return uniqueExistingPaths(paths).map((candidatePath) => ({
    path: candidatePath,
    bytes: fs.statSync(candidatePath).size,
    sha256: sha256(candidatePath),
    exactProjectMatches: [],
  }));
}

function findContainingSearchRoot(filePath) {
  const normalized = normalizePathForLookup(filePath);
  return textureSearchIndex.roots
    .filter(({ normalized: root }) => normalized === root || normalized.startsWith(`${root}\\`))
    .sort((left, right) => right.normalized.length - left.normalized.length)[0];
}

function commonPathSegmentCount(leftPath, rightPath) {
  const left = normalizePathForLookup(leftPath).split('\\');
  const right = normalizePathForLookup(rightPath).split('\\');
  let count = 0;
  while (count < left.length && count < right.length && left[count] === right[count]) count += 1;
  return count;
}

function dependencyCandidateScore(modelPath, candidatePath, texturePath) {
  const modelDirectory = path.dirname(modelPath);
  const candidateDirectory = path.dirname(candidatePath);
  const normalizedModelDirectory = normalizePathForLookup(modelDirectory);
  const normalizedCandidate = normalizePathForLookup(candidatePath);
  const normalizedReference = normalizeTextureReference(texturePath);
  let score = commonPathSegmentCount(modelDirectory, candidateDirectory) * 100;
  if (normalizedCandidate === normalizePathForLookup(path.join(modelDirectory, path.basename(texturePath)))) score += 12000;
  if (normalizedCandidate.startsWith(`${normalizedModelDirectory}\\`)) score += 8000;
  if (normalizedCandidate.endsWith(`\\${normalizedReference}`)) score += 5000;
  const sourceRoot = findContainingSearchRoot(modelPath);
  const candidateRoot = findContainingSearchRoot(candidatePath);
  if (sourceRoot && candidateRoot && sourceRoot.normalized === candidateRoot.normalized) score += 1000;
  const packageHints = ['textures', 'war3mapimported', '_sl_tex'];
  if (packageHints.some((hint) => normalizedCandidate.includes(`\\${hint}\\`))) score += 50;
  return score;
}

function selectDependencyIdentity(modelPath, texturePath, candidatePaths, resolutionMethod) {
  const identities = groupSourceIdentities(dependencySourceRecords(candidatePaths));
  if (identities.length === 0) return null;
  if (identities.length === 1) {
    return { status: resolutionMethod, sourceIdentity: identities[0], candidateIdentityCount: 1 };
  }
  const scored = identities.map((identity) => ({
    identity,
    score: Math.max(...identity.paths.map((candidatePath) => dependencyCandidateScore(modelPath, candidatePath, texturePath))),
  })).sort((left, right) => right.score - left.score || left.identity.sha256.localeCompare(right.identity.sha256));
  if (scored[0].score > scored[1].score) {
    return {
      status: 'resolved-nearest-package',
      sourceIdentity: scored[0].identity,
      candidateIdentityCount: identities.length,
      candidateScores: scored.map(({ identity, score }) => ({ sha256: identity.sha256, score, paths: identity.paths })),
    };
  }
  return {
    status: 'ambiguous-dependency',
    sourceIdentities: identities,
    candidateScores: scored.map(({ identity, score }) => ({ sha256: identity.sha256, score, paths: identity.paths })),
  };
}

function collectLocalDependencyCandidates(modelPath, texturePath) {
  const modelDirectory = path.dirname(modelPath);
  const modelStem = path.basename(modelPath, path.extname(modelPath));
  const candidates = [];
  if (path.win32.isAbsolute(texturePath)) candidates.push(texturePath);
  const referenceParts = texturePath.replace(/\//g, '\\').split('\\').filter(Boolean);
  candidates.push(path.join(modelDirectory, ...referenceParts));
  candidates.push(path.join(modelDirectory, path.basename(texturePath)));

  const containingRoot = findContainingSearchRoot(modelPath);
  let ancestor = modelDirectory;
  while (ancestor && (!containingRoot || normalizePathForLookup(ancestor).startsWith(containingRoot.normalized))) {
    candidates.push(path.join(ancestor, ...referenceParts));
    candidates.push(path.join(ancestor, 'Textures', path.basename(texturePath)));
    candidates.push(path.join(ancestor, 'war3mapImported', path.basename(texturePath)));
    candidates.push(path.join(ancestor, '_sl_tex', path.basename(texturePath)));
    candidates.push(path.join(ancestor, '_sl_tex', modelStem, path.basename(texturePath)));
    const parent = path.dirname(ancestor);
    if (parent === ancestor) break;
    ancestor = parent;
  }
  return uniqueExistingPaths(candidates);
}

function collectTailDependencyCandidates(texturePath) {
  const normalizedReference = normalizeTextureReference(texturePath);
  if (!normalizedReference.includes('\\')) return [];
  return textureSearchIndex.records
    .filter((record) => record.normalizedPath.endsWith(`\\${normalizedReference}`))
    .map((record) => record.path);
}

function inspectTextureDependency(texture, modelPath, textureIndex) {
  const texturePath = (texture.path || '').replace(/\//g, '\\');
  const replaceableId = Number(texture.replaceableId || 0);
  if (replaceableId !== 0 || !texturePath) {
    return { index: textureIndex, path: texturePath, replaceableId, status: 'builtin-replaceable' };
  }

  const projectPath = path.join(projectImportsRoot, ...texturePath.split('\\'));
  if (fs.existsSync(projectPath)) {
    return {
      index: textureIndex,
      path: texturePath,
      replaceableId,
      status: 'project-existing',
      resolvedPath: relativeOrAbsolute(projectPath),
      sha256: sha256(projectPath),
    };
  }

  const normalizedTexturePath = texturePath.toLowerCase();
  const builtinArchives = warcraftBuiltinTextureIndex.byPath.get(normalizedTexturePath);
  if (builtinArchives) {
    return {
      index: textureIndex,
      path: texturePath,
      replaceableId,
      status: 'builtin-mpq',
      archives: builtinArchives,
    };
  }

  const localCandidates = collectLocalDependencyCandidates(modelPath, texturePath);
  const localResolution = selectDependencyIdentity(modelPath, texturePath, localCandidates, 'resolved-source-local');
  if (localResolution && localResolution.status !== 'ambiguous-dependency') {
    return { index: textureIndex, path: texturePath, replaceableId, ...localResolution };
  }

  const tailCandidates = collectTailDependencyCandidates(texturePath);
  const tailResolution = selectDependencyIdentity(modelPath, texturePath, tailCandidates, 'resolved-relative-tail');
  if (tailResolution && tailResolution.status !== 'ambiguous-dependency') {
    return { index: textureIndex, path: texturePath, replaceableId, ...tailResolution };
  }

  const baseNameRecords = textureSearchIndex.byBaseName.get(path.basename(texturePath).toLowerCase()) || [];
  const allCandidates = uniqueExistingPaths([
    ...localCandidates,
    ...tailCandidates,
    ...baseNameRecords.map((record) => record.path),
  ]);
  if (knownWarcraftBuiltinTextures.has(normalizedTexturePath)) {
    return {
      index: textureIndex,
      path: texturePath,
      replaceableId,
      status: 'builtin-whitelist',
      discoveredExternalIdentities: groupSourceIdentities(dependencySourceRecords(allCandidates)),
    };
  }
  const globalResolution = selectDependencyIdentity(modelPath, texturePath, allCandidates, 'resolved-unique-basename');
  if (globalResolution) return { index: textureIndex, path: texturePath, replaceableId, ...globalResolution };
  return { index: textureIndex, path: texturePath, replaceableId, status: 'truly-missing' };
}

let textureSearchIndex = { records: [], byBaseName: new Map(), roots: [] };

function inspectModel(modelPath, Model) {
  try {
    const model = new Model();
    model.loadMdx(fs.readFileSync(modelPath));
    const textures = model.textures.map((texture, index) => inspectTextureDependency(texture, modelPath, index));
    const blockingTextures = textures.filter((texture) =>
      texture.status === 'truly-missing' || texture.status === 'ambiguous-dependency',
    );
    return {
      status: blockingTextures.length === 0 ? 'ready' : 'blocked-dependency',
      name: model.name,
      sequences: model.sequences.map((sequence) => sequence.name),
      textures,
      blockingTextureCount: blockingTextures.length,
      dependencyStatusStats: countBy(textures.map((texture) => texture.status)),
    };
  } catch (error) {
    return { status: 'parse-error', error: String(error && error.stack ? error.stack : error) };
  }
}

function buildAuditManifest() {
  const candidateText = readUtf8(candidateRecordPath);
  const libraryText = readUtf8(libraryRecordPath);
  const candidateTables = parseMarkdownTables(candidateText, 'Boss特效候选筛选记录.md');
  const libraryTables = parseMarkdownTables(libraryText, '特效库.md');
  const screenshotTable = candidateTables.find((table) => table.headers.includes('日期/批次'));
  if (!screenshotTable) throw new Error('Cannot find the screenshot review table by its headers');

  const physicalModelPaths = physicalLibraryRoots.flatMap((root) =>
    walkFiles(root, (filePath) => filePath.toLowerCase().endsWith('.mdx')),
  );
  const supplementalModelPaths = supplementalModelSourceRoots.flatMap((root) =>
    walkFiles(root, (filePath) => filePath.toLowerCase().endsWith('.mdx')),
  );
  const documentedAbsoluteModelPaths = findDocumentedAbsoluteModels(candidateText, libraryText);
  const externalModelPaths = uniqueExistingPaths([
    ...physicalModelPaths,
    ...supplementalModelPaths,
    ...documentedAbsoluteModelPaths,
  ]);
  const projectModelPaths = walkFiles(projectEffectRoot, (filePath) => filePath.toLowerCase().endsWith('.mdx'));
  const allImportedModelPaths = walkFiles(projectImportsRoot, (filePath) => filePath.toLowerCase().endsWith('.mdx'));
  const knownNames = buildKnownNameIndex([...externalModelPaths, ...allImportedModelPaths]);
  warcraftBuiltinTextureIndex = buildWarcraftBuiltinTextureIndex();

  const rows = screenshotTable.rows.map((row, index) => {
    const candidateTextValue = row.fields['候选编号/名称'] || row.fields['候选模型'] || '';
    const resourceTextValue = row.fields['资源路径'] || row.fields['游戏内路径'] || '';
    return {
      id: `screenshot-${String(index + 1).padStart(3, '0')}`,
      line: row.line,
      batch: row.fields['日期/批次'] || '',
      boss: row.fields.Boss || '',
      usage: row.fields['技能或节点'] || row.fields['当前用途'] || '',
      candidateText: candidateTextValue,
      resourceText: resourceTextValue,
      conclusion: row.fields['结论'] || row.fields['状态'] || '',
      decision: classifyDecision(row.fields),
      sourceModels: matchModelsInText(candidateTextValue, knownNames),
      destinationModels: matchModelsInText(resourceTextValue, knownNames),
      reason: row.fields['评审理由'] || '',
      followUp: row.fields['后续动作'] || '',
    };
  });

  const unique = new Map();
  function addUnique(name, data) {
    const key = name.toLowerCase();
    if (!unique.has(key)) unique.set(key, { name, mentions: [], decisions: new Set() });
    const item = unique.get(key);
    item.mentions.push(data);
    item.decisions.add(data.decision);
  }
  for (const row of rows) {
    for (const name of row.sourceModels) addUnique(name, { rowId: row.id, role: 'source', decision: row.decision });
    for (const name of row.destinationModels) addUnique(name, { rowId: row.id, role: 'destination', decision: row.decision });
  }
  for (const name of matchModelsInText(libraryText, knownNames)) {
    addUnique(name, { source: '特效库.md', role: 'record', decision: 'documented' });
  }

  const rowsById = new Map(rows.map((row) => [row.id, row]));
  const documentedPathSet = new Set(documentedAbsoluteModelPaths.map((filePath) => filePath.toLowerCase()));
  const Model = require(findModelLibraryPath()).default;
  textureSearchIndex = buildTextureIndex([
    projectImportsRoot,
    ...physicalLibraryRoots,
    ...supplementalModelSourceRoots,
    ...documentedAbsoluteModelPaths.map(path.dirname),
  ]);

  const projectHashes = new Map();
  for (const modelPath of projectModelPaths) {
    const hash = sha256(modelPath);
    if (!projectHashes.has(hash)) projectHashes.set(hash, []);
    projectHashes.get(hash).push(relativeOrAbsolute(modelPath));
  }

  const uniqueCandidates = [...unique.values()]
    .map((item) => {
      const sourceNames = new Set([
        item.name.toLowerCase(),
        ...(modelSourceAliases.get(item.name.toLowerCase()) || []).map((name) => name.toLowerCase()),
      ]);
      const externalMatches = externalModelPaths.filter((modelPath) =>
        sourceNames.has(path.basename(modelPath).toLowerCase()),
      );
      const projectMatches = projectModelPaths.filter(
        (modelPath) => path.basename(modelPath).toLowerCase() === item.name.toLowerCase(),
      );
      const externalSources = externalMatches.map((modelPath) => {
        const hash = sha256(modelPath);
        return {
          path: modelPath,
          origin: documentedPathSet.has(modelPath.toLowerCase()) ? 'documented-absolute' : 'physical-library',
          bytes: fs.statSync(modelPath).size,
          sha256: hash,
          exactProjectMatches: projectHashes.get(hash) || [],
        };
      });
      const sourceIdentities = groupSourceIdentities(externalSources);
      const sourceMentions = item.mentions.filter((mention) => mention.role === 'source');
      const includedMentions = sourceMentions.filter((mention) => mention.decision === 'included');
      const associatedRows = includedMentions.map((mention) => rowsById.get(mention.rowId)).filter(Boolean);
      const associatedTargets = [...new Set(associatedRows.flatMap((row) => row.destinationModels))];
      const existingTargets = associatedTargets.flatMap((targetName) => {
        const target = knownNames.get(targetName.toLowerCase());
        if (!target) return [];
        return target.paths
          .filter((targetPath) => targetPath.toLowerCase().startsWith(projectImportsRoot.toLowerCase()))
          .map(relativeOrAbsolute);
      });
      const exactReusePaths = [...new Set(sourceIdentities.flatMap((identity) => identity.exactProjectMatches))];
      const authoritativeIdentities = sourceIdentities.filter((identity) =>
        identity.paths.some((sourcePath) => documentedPathSet.has(sourcePath.toLowerCase())),
      );
      let selectedIdentity = null;
      if (sourceIdentities.length === 1) selectedIdentity = sourceIdentities[0];
      else if (authoritativeIdentities.length === 1) selectedIdentity = authoritativeIdentities[0];
      else if (preferredSourcePaths.has(item.name.toLowerCase())) {
        const preferredPath = normalizePathForLookup(preferredSourcePaths.get(item.name.toLowerCase()));
        selectedIdentity = sourceIdentities.find((identity) =>
          identity.paths.some((sourcePath) => normalizePathForLookup(sourcePath) === preferredPath),
        ) || null;
      }

      const configuredPlan = deterministicMigrationPlans.get(item.name.toLowerCase()) || null;
      const documentedTarget = documentedMigrationTargets.get(item.name.toLowerCase()) || null;
      const confirmedExistingTargets = existingTargets.filter((targetPath) => {
        if (configuredPlan && configuredPlan.category && configuredPlan.fileName) {
          const expectedSuffix = path.join(...configuredPlan.category, configuredPlan.fileName)
            .replace(/\//g, '\\')
            .toLowerCase();
          return targetPath.replace(/\//g, '\\').toLowerCase().endsWith(expectedSuffix);
        }
        if (documentedTarget) {
          return targetPath.replace(/\//g, '\\').toLowerCase().endsWith(documentedTarget.toLowerCase());
        }
        return path.basename(targetPath).toLowerCase() === item.name.toLowerCase();
      });

      let migrationStatus = 'documented-only';
      let inspection = null;
      if (includedMentions.length > 0) {
        if (confirmedExistingTargets.length > 0) migrationStatus = 'already-migrated-or-explicit';
        else if (exactReusePaths.length > 0) migrationStatus = 'exact-project-reuse';
        else if (projectMatches.length > 0) migrationStatus = 'existing-project-name';
        else if (sourceIdentities.length === 0) migrationStatus = 'missing-source';
        else if (!selectedIdentity) migrationStatus = 'ambiguous-source';
        else {
          inspection = inspectModel(selectedIdentity.paths[0], Model);
          migrationStatus = inspection.status === 'ready' ? 'ready-to-migrate' : inspection.status;
        }
      }
      const migrationPlan = configuredPlan && configuredPlan.category
        ? {
          ...configuredPlan,
          destination: relativeOrAbsolute(path.join(projectEffectRoot, ...configuredPlan.category, configuredPlan.fileName)),
          gamePath: path.win32.join('Common', 'Effect', ...configuredPlan.category, configuredPlan.fileName),
        }
        : configuredPlan;
      return {
        name: item.name,
        decisions: [...item.decisions].sort(),
        mentions: item.mentions,
        eligible: includedMentions.length > 0,
        migrationStatus,
        projectMatches: projectMatches.map(relativeOrAbsolute),
        associatedTargets,
        existingTargets: [...new Set(existingTargets)].sort(),
        confirmedExistingTargets: [...new Set(confirmedExistingTargets)].sort(),
        externalSources,
        sourceIdentities,
        selectedSourceIdentity: selectedIdentity,
        inspection,
        migrationPlan,
      };
    })
    .sort((left, right) => left.name.localeCompare(right.name, 'zh-CN'));

  return {
    generatedAt: new Date().toISOString(),
    sourceDocuments: [relativeOrAbsolute(candidateRecordPath), relativeOrAbsolute(libraryRecordPath)],
    physicalLibraryRoots,
    supplementalModelSourceRoots: supplementalModelSourceRoots.map(relativeOrAbsolute),
    warcraftBuiltinTextureIndex: {
      installRoot: warcraftBuiltinTextureIndex.installRoot,
      archives: warcraftBuiltinTextureIndex.archives,
      texturePathCount: warcraftBuiltinTextureIndex.byPath.size,
    },
    screenshotTable: {
      headerLine: screenshotTable.headerLine,
      endLine: screenshotTable.endLine,
      markdownLineCount: screenshotTable.markdownLineCount,
      dataRowCount: rows.length,
      headers: screenshotTable.headers,
      resourcePathStats: countBy(rows.map((row) => row.resourceText)),
      conclusionStats: countBy(rows.map((row) => row.conclusion)),
      decisionStats: countBy(rows.map((row) => row.decision)),
    },
    inventory: {
      projectModelCount: projectModelPaths.length,
      importedModelCount: allImportedModelPaths.length,
      physicalModelCount: physicalModelPaths.length,
      supplementalModelCount: supplementalModelPaths.length,
      documentedAbsoluteModelCount: documentedAbsoluteModelPaths.length,
      externalModelCount: externalModelPaths.length,
      uniqueRecordedModelCount: uniqueCandidates.length,
      eligibleCandidateCount: uniqueCandidates.filter((candidate) => candidate.eligible).length,
      migrationStatusStats: countBy(
        uniqueCandidates.filter((candidate) => candidate.eligible).map((candidate) => candidate.migrationStatus),
      ),
      dependencyResolutionStats: countBy(
        uniqueCandidates
          .filter((candidate) => candidate.eligible && candidate.inspection)
          .flatMap((candidate) => candidate.inspection.textures.map((texture) => texture.status)),
      ),
      blockedDependencyModelBreakdown: countBy(
        uniqueCandidates
          .filter((candidate) => candidate.eligible && candidate.migrationStatus === 'blocked-dependency')
          .map((candidate) => {
            const statuses = new Set(candidate.inspection.textures.map((texture) => texture.status));
            if (statuses.has('truly-missing') && statuses.has('ambiguous-dependency')) return 'ambiguous-and-truly-missing';
            if (statuses.has('ambiguous-dependency')) return 'ambiguous-only';
            return 'truly-missing-only';
          }),
      ),
    },
    rows,
    uniqueCandidates,
    parsedTables: [...candidateTables, ...libraryTables].map((table) => ({
      source: table.source,
      headerLine: table.headerLine,
      endLine: table.endLine,
      headers: table.headers,
      rowCount: table.rows.length,
    })),
  };
}

function loadPriorMigrationResults() {
  if (!fs.existsSync(migrationResultPath)) return null;
  try {
    return JSON.parse(readUtf8(migrationResultPath));
  } catch (error) {
    throw new Error(`Cannot read prior migration results: ${error}`);
  }
}

function summarizeSanity(node) {
  const messages = [];
  function visit(current) {
    if (!current || typeof current !== 'object') return;
    if ((current.type === 'error' || current.type === 'severe') && current.message) {
      messages.push({ type: current.type, message: current.message });
    }
    for (const child of current.nodes || []) visit(child);
  }
  visit(node);
  return {
    errors: Number(node.errors || 0),
    severe: Number(node.severe || 0),
    warnings: Number(node.warnings || 0),
    unused: Number(node.unused || 0),
    messages,
  };
}

function findTextureByHash(directory, expectedHash) {
  if (!fs.existsSync(directory)) return null;
  const matches = fs.readdirSync(directory, { withFileTypes: true })
    .filter((entry) => entry.isFile() && /\.(?:blp|tga)$/i.test(entry.name))
    .map((entry) => path.join(directory, entry.name))
    .filter((filePath) => sha256(filePath) === expectedHash)
    .sort();
  return matches[0] || null;
}

function chooseTextureDestination(textureDirectory, sourcePath, expectedHash, modelBaseName) {
  const exactReuse = findTextureByHash(textureDirectory, expectedHash);
  if (exactReuse) return { path: exactReuse, outcome: 'reused-identical' };

  const sourceName = path.basename(sourcePath);
  const sourceExtension = path.extname(sourceName);
  const sourceStem = path.basename(sourceName, sourceExtension);
  const candidates = [
    sourceName,
    `${modelBaseName}_${sourceName}`,
    `${modelBaseName}_${sourceStem}_${expectedHash.slice(0, 8)}${sourceExtension}`,
  ];
  for (const candidateName of candidates) {
    const candidatePath = path.join(textureDirectory, candidateName);
    if (!fs.existsSync(candidatePath)) return { path: candidatePath, outcome: 'copied' };
    if (sha256(candidatePath) === expectedHash) return { path: candidatePath, outcome: 'reused-identical' };
  }
  throw new Error(`Cannot choose a non-conflicting texture name for ${sourcePath}`);
}

function verifyMigratedModel(modelPath, Model, sanityTest) {
  const verified = new Model();
  verified.loadMdx(fs.readFileSync(modelPath));
  const missingTextures = [];
  for (const texture of verified.textures) {
    const texturePath = (texture.path || '').replace(/\//g, '\\');
    if (Number(texture.replaceableId || 0) !== 0 || !texturePath) continue;
    if (isKnownWarcraftBuiltinTexture(texturePath)) continue;
    if (/^imports\\/i.test(texturePath)) {
      missingTextures.push({ path: texturePath, reason: 'contains-imports-prefix' });
      continue;
    }
    const projectTexturePath = path.join(projectImportsRoot, ...texturePath.split('\\'));
    if (!fs.existsSync(projectTexturePath)) missingTextures.push({ path: texturePath, reason: 'not-found-in-project' });
  }
  return {
    parsed: true,
    modelName: verified.name,
    bytes: fs.statSync(modelPath).size,
    sha256: sha256(modelPath),
    sequences: verified.sequences.map((sequence) => sequence.name),
    textures: verified.textures.map((texture, index) => ({
      index,
      path: (texture.path || '').replace(/\//g, '\\'),
      replaceableId: Number(texture.replaceableId || 0),
    })),
    missingTextures,
    sanity: summarizeSanity(sanityTest(verified)),
  };
}

function reconstructExistingMigration(
  sourcePath,
  destination,
  candidateName,
  plan,
  inspection,
  Model,
  sanityTest,
  Sequence,
  Extent,
  FloatAnimation,
) {
  if (!inspection || inspection.status !== 'ready') return null;
  const sourceModel = new Model();
  sourceModel.loadMdx(fs.readFileSync(sourcePath));
  const targetModel = new Model();
  targetModel.loadMdx(fs.readFileSync(destination));
  if (sourceModel.textures.length !== targetModel.textures.length) return null;
  if (candidateName.toLowerCase() !== plan.fileName.toLowerCase()) {
    sourceModel.name = path.basename(plan.fileName, path.extname(plan.fileName));
  }
  const structuralRepairs = applyStructuralRepairs(
    candidateName,
    sourceModel,
    Sequence,
    Extent,
    FloatAnimation,
  );

  const textureResults = [];
  for (const dependency of inspection.textures) {
    const targetTexture = targetModel.textures[dependency.index];
    if (!targetTexture) return null;
    const targetReference = (targetTexture.path || '').replace(/\//g, '\\');
    if (isBuiltinTextureStatus(dependency.status) || dependency.status === 'project-existing') {
      if (targetReference.toLowerCase() !== dependency.path.toLowerCase()) return null;
      textureResults.push({
        index: dependency.index,
        sourceReference: dependency.path,
        outcome: dependency.status,
        gamePath: targetReference,
      });
      continue;
    }
    if (!dependency.sourceIdentity || /^imports\\/i.test(targetReference)) return null;
    const targetTexturePath = path.join(projectImportsRoot, ...targetReference.split('\\'));
    if (!fs.existsSync(targetTexturePath) || sha256(targetTexturePath) !== dependency.sourceIdentity.sha256) return null;
    sourceModel.textures[dependency.index].path = targetReference;
    textureResults.push({
      index: dependency.index,
      sourceReference: dependency.path,
      sourcePath: dependency.sourceIdentity.paths[0],
      sourceSha256: dependency.sourceIdentity.sha256,
      sourceBytes: dependency.sourceIdentity.bytes,
      outcome: 'verified-existing',
      destination: relativeOrAbsolute(targetTexturePath),
      gamePath: targetReference,
      targetSha256: sha256(targetTexturePath),
      targetBytes: fs.statSync(targetTexturePath).size,
    });
  }

  const expectedHash = crypto.createHash('sha256').update(Buffer.from(sourceModel.saveMdx())).digest('hex').toUpperCase();
  const targetHash = sha256(destination);
  if (expectedHash !== targetHash) return null;
  return {
    sourceSanity: summarizeSanity(sanityTest(sourceModel)),
    structuralRepairs,
    textureResults,
    verification: verifyMigratedModel(destination, Model, sanityTest),
  };
}

function copyExtent(source, destination) {
  destination.min.set(source.min);
  destination.max.set(source.max);
  destination.boundsRadius = source.boundsRadius;
}

function addOneFrameSequence(model, Sequence, sequenceName, start) {
  const sequence = new Sequence();
  sequence.name = sequenceName;
  sequence.interval.set([start, start + 1]);
  sequence.nonLooping = sequenceName === 'Death' ? 1 : 0;
  copyExtent(model.extent, sequence.extent);
  model.sequences.push(sequence);
  return { type: 'added-safe-sequence', sequence: sequenceName, interval: [start, start + 1] };
}

function fillGeosetSequenceExtents(model, Extent) {
  let added = 0;
  for (const geoset of model.geosets) {
    while (geoset.sequenceExtents.length < model.sequences.length) {
      const extent = new Extent();
      copyExtent(geoset.extent, extent);
      geoset.sequenceExtents.push(extent);
      added += 1;
    }
  }
  return added;
}

function cloneTrackValue(value) {
  return new value.constructor(value);
}

function collectAnimations(root) {
  const animations = [];
  const visited = new WeakSet();
  const stack = [{ value: root, label: 'Model' }];
  while (stack.length > 0) {
    const { value, label } = stack.pop();
    if (!value || typeof value !== 'object' || ArrayBuffer.isView(value) || visited.has(value)) continue;
    visited.add(value);
    if (Array.isArray(value.animations)) {
      value.animations.forEach((animation, index) => animations.push({ animation, label: `${label}.animations[${index}]` }));
    }
    for (const [key, child] of Object.entries(value)) {
      if (key === 'animations' || !child || typeof child !== 'object' || ArrayBuffer.isView(child)) continue;
      if (Array.isArray(child)) {
        child.forEach((item, index) => stack.push({ value: item, label: `${label}.${key}[${index}]` }));
      } else {
        stack.push({ value: child, label: `${label}.${key}` });
      }
    }
  }
  return animations;
}

function repairAnimationFrameOrder(model) {
  const repairs = [];
  for (const { animation, label } of collectAnimations(model)) {
    if (!Array.isArray(animation.frames) || animation.frames.length < 2) continue;
    const order = animation.frames.map((frame, index) => ({ frame, index }))
      .sort((left, right) => left.frame - right.frame || left.index - right.index);
    if (order.every((entry, index) => entry.index === index)) continue;
    const originalFrames = [...animation.frames];
    animation.frames.splice(0, animation.frames.length, ...order.map((entry) => originalFrames[entry.index]));
    for (const key of ['values', 'inTans', 'outTans']) {
      const values = animation[key];
      if (!Array.isArray(values) || values.length !== order.length) continue;
      const original = [...values];
      values.splice(0, values.length, ...order.map((entry) => original[entry.index]));
    }
    repairs.push({ type: 'sorted-animation-frames', animation: animation.name, owner: label });
  }
  return repairs;
}

function repairAnimationOpeningTracks(model) {
  const repairs = [];
  for (const { animation, label } of collectAnimations(model)) {
    if (!Array.isArray(animation.frames) || animation.frames.length === 0 || animation.globalSequenceId !== -1) continue;
    for (const sequence of model.sequences) {
      const start = sequence.interval[0];
      const end = sequence.interval[1];
      if (animation.frames.includes(start)) continue;
      const firstIndex = animation.frames.findIndex((frame) => frame > start && frame <= end);
      if (firstIndex === -1) continue;
      animation.frames.splice(firstIndex, 0, start);
      animation.values.splice(firstIndex, 0, cloneTrackValue(animation.values[firstIndex]));
      if (animation.interpolationType > 1) {
        animation.inTans.splice(firstIndex, 0, cloneTrackValue(animation.inTans[firstIndex]));
        animation.outTans.splice(firstIndex, 0, cloneTrackValue(animation.outTans[firstIndex]));
      }
      repairs.push({
        type: 'added-opening-track-key',
        owner: label,
        animation: animation.name,
        sequence: sequence.name,
        frame: start,
        copiedFromFrame: animation.frames[firstIndex + 1],
      });
    }
  }
  return repairs;
}

function repairOverlappingSequences(model) {
  const repairs = [];
  const originalOrder = [...model.sequences];
  model.sequences.sort((left, right) => left.interval[0] - right.interval[0] || left.interval[1] - right.interval[1]);
  if (model.sequences.some((sequence, index) => sequence !== originalOrder[index])) {
    repairs.push({ type: 'sorted-sequences-by-interval' });
  }
  for (let index = 1; index < model.sequences.length; index += 1) {
    const previous = model.sequences[index - 1];
    const current = model.sequences[index];
    if (current.interval[0] >= previous.interval[1]) continue;
    const oldEnd = previous.interval[1];
    if (current.interval[0] > previous.interval[0]) {
      previous.interval[1] = current.interval[0];
      repairs.push({
        type: 'trimmed-overlapping-sequence',
        sequence: previous.name,
        fromEnd: oldEnd,
        toEnd: previous.interval[1],
      });
    }
  }
  return repairs;
}

function repairParticleParameters(model) {
  const repairs = [];
  model.particleEmitters2.forEach((emitter, index) => {
    if (emitter.timeMiddle < 0 || emitter.timeMiddle > 1) {
      const previous = emitter.timeMiddle;
      emitter.timeMiddle = Math.max(0, Math.min(1, emitter.timeMiddle));
      repairs.push({ type: 'clamped-particle-time-middle', emitter: index, from: previous, to: emitter.timeMiddle });
    }
    if (emitter.speed === 0 || emitter.latitude === 0) {
      const previousSpeed = emitter.speed;
      const previousLatitude = emitter.latitude;
      if (emitter.speed === 0) emitter.speed = 0.01;
      if (emitter.latitude === 0) emitter.latitude = 0.01;
      repairs.push({
        type: 'set-minimal-xy-quad-motion',
        emitter: index,
        fromSpeed: previousSpeed,
        toSpeed: emitter.speed,
        fromLatitude: previousLatitude,
        toLatitude: emitter.latitude,
      });
    }
  });
  return repairs;
}

function repairJntx491OpeningTracks(model) {
  const stand = model.sequences.find((sequence) => sequence.name.trim().toLowerCase() === 'stand');
  if (!stand) return [];
  const start = stand.interval[0];
  const end = stand.interval[1];
  const repairs = [];
  for (const helper of model.helpers) {
    for (const animation of helper.animations) {
      if (animation.name !== 'KGTR' || animation.globalSequenceId !== -1 || animation.interpolationType === 0) continue;
      if (animation.frames.includes(start)) continue;
      const firstIndex = animation.frames.findIndex((frame) => frame > start && frame <= end);
      if (firstIndex === -1) continue;
      animation.frames.splice(firstIndex, 0, start);
      animation.values.splice(firstIndex, 0, cloneTrackValue(animation.values[firstIndex]));
      if (animation.interpolationType > 1) {
        animation.inTans.splice(firstIndex, 0, cloneTrackValue(animation.inTans[firstIndex]));
        animation.outTans.splice(firstIndex, 0, cloneTrackValue(animation.outTans[firstIndex]));
      }
      repairs.push({
        type: 'added-opening-track-key',
        node: `Helper:${helper.objectId}:${helper.name}`,
        animation: animation.name,
        frame: start,
        copiedFromFrame: animation.frames[firstIndex + 1],
      });
    }
  }
  return repairs;
}

function applyStructuralRepairs(sourceName, model, Sequence, Extent, FloatAnimation) {
  const repairs = [];
  const sourceKey = sourceName.toLowerCase();

  if (!initialMigrationCandidateNames.has(sourceKey)) {
    repairs.push(...repairAnimationFrameOrder(model));
    repairs.push(...repairOverlappingSequences(model));
    repairs.push(...repairParticleParameters(model));
  }

  if (sourceKey === 'tx_cb_anyingcb.mdx') {
    model.particleEmitters2.forEach((emitter, index) => {
      if (emitter.timeMiddle < 0 || emitter.timeMiddle > 1) {
        const previous = emitter.timeMiddle;
        emitter.timeMiddle = Math.max(0, Math.min(1, emitter.timeMiddle));
        repairs.push({ type: 'clamped-particle-time-middle', emitter: index, from: previous, to: emitter.timeMiddle });
      }
    });
  }

  if (sourceKey === 'jntx (491).mdx') repairs.push(...repairJntx491OpeningTracks(model));

  if (sourceKey === 'tx_jn_qusanbo.mdx' || sourceKey === 'tx27.mdx') {
    const firstSequenceStart = model.sequences.length > 0 ? model.sequences[0].interval[0] : 0;
    model.particleEmitters2.forEach((emitter, index) => {
      if (!emitter.squirt || emitter.animations.some((animation) => animation.name === 'KP2E')) return;
      const emission = new FloatAnimation();
      emission.name = 'KP2E';
      emission.interpolationType = 0;
      emission.globalSequenceId = -1;
      emission.frames.push(firstSequenceStart);
      emission.values.push(new Float32Array([Math.max(1, emitter.emissionRate || 1)]));
      emitter.animations.push(emission);
      repairs.push({
        type: 'added-constant-squirt-emission-track',
        emitter: index,
        frame: firstSequenceStart,
        value: emission.values[0][0],
      });
    });
  }

  let nextFrame = model.sequences.reduce((maximum, sequence) => Math.max(maximum, sequence.interval[1]), 0) + 1;
  const sequenceNames = new Set(model.sequences.map((sequence) => sequence.name.trim().toLowerCase()));
  if (!sequenceNames.has('stand')) {
    repairs.push(addOneFrameSequence(model, Sequence, 'Stand', nextFrame));
    nextFrame += 2;
  }
  if (!sequenceNames.has('death')) {
    repairs.push(addOneFrameSequence(model, Sequence, 'Death', nextFrame));
  }
  const addedExtents = fillGeosetSequenceExtents(model, Extent);
  if (addedExtents > 0) repairs.push({ type: 'filled-geoset-sequence-extents', count: addedExtents });
  if (!initialMigrationCandidateNames.has(sourceKey)) repairs.push(...repairAnimationOpeningTracks(model));
  return repairs;
}

function migrateRecordedReadyCandidates(manifest) {
  const modelLibraryPath = findModelLibraryPath();
  const modelLibraryDirectory = path.dirname(modelLibraryPath);
  const Model = require(modelLibraryPath).default;
  const Sequence = require(path.join(modelLibraryDirectory, 'sequence.js')).default;
  const Extent = require(path.join(modelLibraryDirectory, 'extent.js')).default;
  const FloatAnimation = require(path.join(modelLibraryDirectory, 'animations.js')).FloatAnimation;
  const sanityTest = require(path.resolve(path.dirname(modelLibraryPath), '../../utils/mdlx/index.js')).default.sanityTest;
  const prior = loadPriorMigrationResults();
  const priorBySource = new Map((prior && prior.results || []).map((result) => [result.sourceName.toLowerCase(), result]));
  const candidatesByName = new Map(manifest.uniqueCandidates.map((candidate) => [candidate.name.toLowerCase(), candidate]));
  const projectModels = walkFiles(projectEffectRoot, (filePath) => filePath.toLowerCase().endsWith('.mdx'));
  const projectModelsByHash = new Map();
  for (const modelPath of projectModels) {
    const hash = sha256(modelPath);
    if (!projectModelsByHash.has(hash)) projectModelsByHash.set(hash, []);
    projectModelsByHash.get(hash).push(modelPath);
  }

  const results = [];
  for (const [sourceKey, plan] of deterministicMigrationPlans) {
    const candidate = candidatesByName.get(sourceKey);
    if (!candidate) {
      results.push({ sourceName: sourceKey, outcome: 'missing-candidate-record' });
      continue;
    }
    if (plan.outcome === 'ambiguous-purpose') {
      results.push({
        sourceName: candidate.name,
        auditStatus: candidate.migrationStatus,
        outcome: 'ambiguous-purpose',
        reason: plan.reason,
      });
      continue;
    }
    const sourceIdentity = candidate.selectedSourceIdentity;
    if (!sourceIdentity) {
      results.push({ sourceName: candidate.name, auditStatus: candidate.migrationStatus, outcome: 'missing-selected-source' });
      continue;
    }
    const sourcePath = sourceIdentity.paths[0];
    const sourceHash = sourceIdentity.sha256;
    const effectiveInspection = candidate.inspection || inspectModel(sourcePath, Model);
    const exactProjectMatches = projectModelsByHash.get(sourceHash) || [];
    if (exactProjectMatches.length > 0) {
      const verification = verifyMigratedModel(exactProjectMatches[0], Model, sanityTest);
      results.push({
        sourceName: candidate.name,
        sourcePath,
        sourceSha256: sourceHash,
        sourceBytes: sourceIdentity.bytes,
        outcome: 'reused-existing-model',
        gamePath: path.relative(projectImportsRoot, exactProjectMatches[0]).replace(/\//g, '\\'),
        destination: relativeOrAbsolute(exactProjectMatches[0]),
        targetSha256: verification.sha256,
        targetBytes: verification.bytes,
        targetSequences: verification.sequences,
        targetSanity: verification.sanity,
        verification,
      });
      continue;
    }

    const destination = path.join(projectEffectRoot, ...plan.category, plan.fileName);
    const gameDirectory = path.win32.join('Common', 'Effect', ...plan.category);
    const gamePath = path.win32.join(gameDirectory, plan.fileName);
    const priorResult = priorBySource.get(candidate.name.toLowerCase());
    if (fs.existsSync(destination)) {
      const destinationHash = sha256(destination);
      if (priorResult && priorResult.sourceSha256 === sourceHash && priorResult.targetSha256 === destinationHash) {
        const sourceRepairModel = new Model();
        sourceRepairModel.loadMdx(fs.readFileSync(sourcePath));
        if (candidate.name.toLowerCase() !== plan.fileName.toLowerCase()) {
          sourceRepairModel.name = path.basename(plan.fileName, path.extname(plan.fileName));
        }
        const sourceStructuralRepairs = applyStructuralRepairs(
          candidate.name,
          sourceRepairModel,
          Sequence,
          Extent,
          FloatAnimation,
        );
        const repairedModel = new Model();
        repairedModel.loadMdx(fs.readFileSync(destination));
        const structuralRepairs = applyStructuralRepairs(
          candidate.name,
          repairedModel,
          Sequence,
          Extent,
          FloatAnimation,
        );
        const temporaryDestination = `${destination}.migration-${process.pid}.tmp`;
        try {
          fs.writeFileSync(temporaryDestination, Buffer.from(repairedModel.saveMdx()));
          const temporaryVerification = verifyMigratedModel(temporaryDestination, Model, sanityTest);
          if (temporaryVerification.missingTextures.length > 0
            || temporaryVerification.sanity.errors > 0
            || temporaryVerification.sanity.severe > 0) {
            results.push({
            ...priorResult,
            outcome: 'structural-blocked',
            rerunOutcome: 'repair-failed',
            structuralRepairs: sourceStructuralRepairs,
            rerunStructuralRepairs: structuralRepairs,
              verification: temporaryVerification,
            });
            continue;
          }
          fs.copyFileSync(temporaryDestination, destination);
        } finally {
          if (fs.existsSync(temporaryDestination)) fs.rmSync(temporaryDestination);
        }
        const verification = verifyMigratedModel(destination, Model, sanityTest);
        results.push({
          ...priorResult,
          outcome: 'migrated',
          rerunOutcome: structuralRepairs.length > 0 ? 'repaired-prior-target' : 'verified-prior-target',
          structuralRepairs: sourceStructuralRepairs,
          rerunStructuralRepairs: structuralRepairs,
          targetSha256: verification.sha256,
          targetBytes: verification.bytes,
          targetSequences: verification.sequences,
          targetSanity: verification.sanity,
          verification,
        });
      } else {
        const reconstructed = reconstructExistingMigration(
          sourcePath,
          destination,
          candidate.name,
          plan,
          effectiveInspection,
          Model,
          sanityTest,
          Sequence,
          Extent,
          FloatAnimation,
        );
        if (reconstructed) {
          results.push({
            sourceName: candidate.name,
            sourcePath,
            sourceSha256: sourceHash,
            sourceBytes: sourceIdentity.bytes,
            auditStatus: candidate.migrationStatus,
            outcome: 'migrated',
            rerunOutcome: 'reconstructed-prior-target',
            category: plan.category.join('/'),
            destination: relativeOrAbsolute(destination),
            gamePath,
            targetSha256: reconstructed.verification.sha256,
            targetBytes: reconstructed.verification.bytes,
            sourceSequences: effectiveInspection.sequences,
            targetSequences: reconstructed.verification.sequences,
            sourceSanity: reconstructed.sourceSanity,
            targetSanity: reconstructed.verification.sanity,
            structuralRepairs: reconstructed.structuralRepairs,
            textures: reconstructed.textureResults,
            verification: reconstructed.verification,
          });
        } else {
          results.push({
            sourceName: candidate.name,
            sourcePath,
            sourceSha256: sourceHash,
            sourceBytes: sourceIdentity.bytes,
            outcome: 'target-conflict',
            destination: relativeOrAbsolute(destination),
            existingTargetSha256: destinationHash,
          });
        }
      }
      continue;
    }

    if (effectiveInspection.status !== 'ready') {
      results.push({
        sourceName: candidate.name,
        auditStatus: candidate.migrationStatus,
        outcome: 'not-ready-after-deep-audit',
        blockingTextures: effectiveInspection.textures && effectiveInspection.textures.filter((texture) =>
          texture.status === 'ambiguous-dependency' || texture.status === 'truly-missing'),
      });
      continue;
    }

    const model = new Model();
    model.loadMdx(fs.readFileSync(sourcePath));
    const sourceSanity = summarizeSanity(sanityTest(model));
    const modelBaseName = path.basename(plan.fileName, path.extname(plan.fileName));
    if (candidate.name.toLowerCase() !== plan.fileName.toLowerCase()) model.name = modelBaseName;
    const structuralRepairs = applyStructuralRepairs(candidate.name, model, Sequence, Extent, FloatAnimation);
    const textureDirectory = path.join(projectEffectRoot, ...plan.category, 'Texture');
    const textureGameDirectory = path.win32.join(gameDirectory, 'Texture');
    fs.mkdirSync(textureDirectory, { recursive: true });
    const textureResults = [];

    for (const dependency of effectiveInspection.textures) {
      if (isBuiltinTextureStatus(dependency.status) || dependency.status === 'project-existing') {
        textureResults.push({
          index: dependency.index,
          sourceReference: dependency.path,
          outcome: dependency.status,
          gamePath: dependency.path,
        });
        continue;
      }
      if (!dependency.sourceIdentity) throw new Error(`${candidate.name}: unresolved dependency ${dependency.path}`);
      const textureSource = dependency.sourceIdentity.paths[0];
      const textureHash = dependency.sourceIdentity.sha256;
      const selected = chooseTextureDestination(textureDirectory, textureSource, textureHash, modelBaseName);
      if (selected.outcome === 'copied') fs.copyFileSync(textureSource, selected.path);
      if (sha256(selected.path) !== textureHash) throw new Error(`${candidate.name}: texture SHA mismatch for ${selected.path}`);
      const textureGamePath = path.win32.join(textureGameDirectory, path.basename(selected.path));
      model.textures[dependency.index].path = textureGamePath;
      textureResults.push({
        index: dependency.index,
        sourceReference: dependency.path,
        sourcePath: textureSource,
        sourceSha256: textureHash,
        sourceBytes: dependency.sourceIdentity.bytes,
        outcome: selected.outcome,
        destination: relativeOrAbsolute(selected.path),
        gamePath: textureGamePath,
        targetSha256: sha256(selected.path),
        targetBytes: fs.statSync(selected.path).size,
      });
    }

    fs.mkdirSync(path.dirname(destination), { recursive: true });
    const temporaryDestination = `${destination}.migration-${process.pid}.tmp`;
    try {
      fs.writeFileSync(temporaryDestination, Buffer.from(model.saveMdx()));
      const temporaryVerification = verifyMigratedModel(temporaryDestination, Model, sanityTest);
      if (temporaryVerification.missingTextures.length > 0) {
        throw new Error(`${candidate.name}: migrated model has missing textures: ${JSON.stringify(temporaryVerification.missingTextures)}`);
      }
      if (temporaryVerification.sanity.errors > 0 || temporaryVerification.sanity.severe > 0) {
        throw new Error(`${candidate.name}: migrated model failed sanity: ${JSON.stringify(temporaryVerification.sanity)}`);
      }
      fs.renameSync(temporaryDestination, destination);
    } finally {
      if (fs.existsSync(temporaryDestination)) fs.rmSync(temporaryDestination);
    }
    const verification = verifyMigratedModel(destination, Model, sanityTest);
    results.push({
      sourceName: candidate.name,
      sourcePath,
      sourceSha256: sourceHash,
      sourceBytes: sourceIdentity.bytes,
      auditStatus: candidate.migrationStatus,
      outcome: 'migrated',
      category: plan.category.join('/'),
      destination: relativeOrAbsolute(destination),
      gamePath,
      targetSha256: verification.sha256,
      targetBytes: verification.bytes,
      sourceSequences: effectiveInspection.sequences,
      targetSequences: verification.sequences,
      sourceSanity,
      targetSanity: verification.sanity,
      structuralRepairs,
      textures: textureResults,
      verification,
    });
  }

  for (const result of results) {
    result.cohort = deepResolvedCandidateNames.has(result.sourceName.toLowerCase())
      ? 'deep-resolved'
      : initialMigrationCandidateNames.has(result.sourceName.toLowerCase())
        ? 'initial-ready-29'
        : 'mpq-resolved';
  }

  const migrationResults = {
    generatedAt: new Date().toISOString(),
    sourceManifestGeneratedAt: manifest.generatedAt,
    cohortSize: deterministicMigrationPlans.size,
    summary: countBy(results.map((result) => result.outcome)),
    summaryByCohort: {
      initialReady29: countBy(results.filter((result) => result.cohort === 'initial-ready-29').map((result) => result.outcome)),
      deepResolved: countBy(results.filter((result) => result.cohort === 'deep-resolved').map((result) => result.outcome)),
      mpqResolved: countBy(results.filter((result) => result.cohort === 'mpq-resolved').map((result) => result.outcome)),
    },
    textureOutcomeStats: countBy(results.flatMap((result) => (result.textures || []).map((texture) => texture.outcome))),
    results,
  };
  fs.writeFileSync(migrationResultPath, `${JSON.stringify(migrationResults, null, 2)}\n`, 'utf8');
  return migrationResults;
}

function auditReadyCandidateRepairs(manifest) {
  const modelLibraryPath = findModelLibraryPath();
  const modelLibraryDirectory = path.dirname(modelLibraryPath);
  const Model = require(modelLibraryPath).default;
  const Sequence = require(path.join(modelLibraryDirectory, 'sequence.js')).default;
  const Extent = require(path.join(modelLibraryDirectory, 'extent.js')).default;
  const FloatAnimation = require(path.join(modelLibraryDirectory, 'animations.js')).FloatAnimation;
  const sanityTest = require(path.resolve(path.dirname(modelLibraryPath), '../../utils/mdlx/index.js')).default.sanityTest;
  const results = [];
  for (const candidate of manifest.uniqueCandidates.filter((item) => item.eligible && item.migrationStatus === 'ready-to-migrate')) {
    const model = new Model();
    model.loadMdx(fs.readFileSync(candidate.selectedSourceIdentity.paths[0]));
    const before = summarizeSanity(sanityTest(model));
    const structuralRepairs = applyStructuralRepairs(candidate.name, model, Sequence, Extent, FloatAnimation);
    const verified = new Model();
    verified.loadMdx(Buffer.from(model.saveMdx()));
    const after = summarizeSanity(sanityTest(verified));
    results.push({
      sourceName: candidate.name,
      before: { errors: before.errors, severe: before.severe },
      after: { errors: after.errors, severe: after.severe },
      repairCount: structuralRepairs.length,
      remainingMessages: after.messages,
    });
  }
  return {
    candidateCount: results.length,
    beforeErrors: results.reduce((total, result) => total + result.before.errors, 0),
    beforeSevere: results.reduce((total, result) => total + result.before.severe, 0),
    afterErrors: results.reduce((total, result) => total + result.after.errors, 0),
    afterSevere: results.reduce((total, result) => total + result.after.severe, 0),
    repairedCandidateCount: results.filter((result) => result.repairCount > 0).length,
    failures: results.filter((result) => result.after.errors > 0 || result.after.severe > 0),
  };
}

function main() {
  const manifest = buildAuditManifest();
  fs.writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`, 'utf8');
  const shouldMigrate = process.argv.includes('--migrate');
  const shouldAuditRepairs = process.argv.includes('--audit-repairs');
  const migration = shouldMigrate ? migrateRecordedReadyCandidates(manifest) : null;
  const repairAudit = shouldAuditRepairs ? auditReadyCandidateRepairs(manifest) : null;
  process.stdout.write(`${JSON.stringify({
    manifestPath,
    migrationResultPath: shouldMigrate ? migrationResultPath : null,
    screenshotTable: manifest.screenshotTable,
    inventory: manifest.inventory,
    migrationSummary: migration && migration.summary,
    textureOutcomeStats: migration && migration.textureOutcomeStats,
    repairAudit,
  }, null, 2)}\n`);
}

main();
