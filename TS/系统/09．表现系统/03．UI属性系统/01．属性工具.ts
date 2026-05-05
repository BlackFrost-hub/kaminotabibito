/** @noSelfInFile */
/**
 * UI属性系统 - 属性读取、格式化与派生值更新
 *
 * 属性读取统一走当前TS正式字段名，优先对齐 TS/系统/02．物品系统/11．装备系统.ts
 * 数据源：玩家->英雄、造成伤害/承受伤害/治疗量 等YDUserData
 *
 * 依赖：
 * - lib.扩展函数.YDWE函数.index
 * - lib.扩展函数.Star扩展函数.Star扩展库.index
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { round, max } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  round: (this: void, value: number) => number;
  max: (this: void, a: number, b: number) => number;
};

const 玩家常量 = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("../../00．核心系统/00．玩家系统/00．常量");

const { MAX_DISPLAY_PLAYERS } = require("系统.09．表现系统.03．UI属性系统.00．常量定义") as {
  MAX_DISPLAY_PLAYERS: number;
};
const { YDUserDataGet, YDUserDataSet, getObjectProperty, ObjectType } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  getObjectProperty: (objectType: number, objectId: string | number, property: string) => string;
  ObjectType: { UNIT: number };
};

const EMPTY_ICON = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp";
const DAMAGE_ATTRS = ["造成伤害", "承受伤害", "治疗量"] as const;

function maxNum3(a: number, b: number, c: number): number {
  return max(max(a, b), c);
}

function isTexturePath(path: string): boolean {
  if (path === "") return false;
  const lower = path.toLowerCase();
  return lower.endsWith(".blp") || lower.endsWith(".dds") || lower.endsWith(".tga");
}

export function isPlayingPlayer(player: any): boolean {
  if (player == null) return false;
  return jass.GetPlayerSlotState(player) === jass.PLAYER_SLOT_STATE_PLAYING;
}

export function isHumanPlayer(player: any): boolean {
  if (player == null) return false;
  // 检查是否为电脑玩家 (MAP_CONTROL_COMPUTER = 2)
  return jass.GetPlayerController(player) !== jass.MAP_CONTROL_COMPUTER;
}

export function getDisplayPlayers(): any[] {
  const players: any[] = [];
  for (let i = 0; i < MAX_DISPLAY_PLAYERS; i++) {
    const player = jass.Player(i);
    if (!isPlayingPlayer(player)) continue;
    // 跳过电脑玩家
    if (!isHumanPlayer(player)) continue;
    players.push(player);
  }
  return players;
}

/**
 * 从玩家级 YDUserData 中读取当前登记的英雄。
 * 英雄来源由“玩家英雄获取桥接”模块注册：
 * 系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接
 */
export function getPlayerHero(player: any): any {
  if (player == null) return null;
  return YDUserDataGet("player", player, 玩家常量.YD_ATTR_PLAYER_HERO_UNIT, "unit");
}

export function getPlayerAttr(player: any, attrName: string): number {
  if (player == null || attrName === "") return 0;
  const value = YDUserDataGet("player", player, attrName, "real");
  return typeof value === "number" ? value : 0;
}

export function getDamageValues(player: any): number[] {
  const values: number[] = [];
  for (let i = 0; i < DAMAGE_ATTRS.length; i++) {
    values.push(getPlayerAttr(player, DAMAGE_ATTRS[i]));
  }
  return values;
}

/**
 * 从英雄单位状态计算「每秒攻速」「移动速度」并写回玩家级 YDUserData。
 * 与 `JASS/jass复制粘贴/属性查看.j` 的展示数据源一致：表由同步逻辑维护，UI 刷新前回写这两列便于全图读表一致。
 * 注意：仅 Tab 显隐伤害面板、头像悬浮显隐属性框走本机 Frame（见面板里 DzFrameSetScriptByCode 异步位）。
 */
export function updatePlayerRealtimeStats(player: any): void {
  const hero = getPlayerHero(player);
  if (hero == null) return;

  const intervalState = jass.ConvertUnitState(0x25);
  const speedState = jass.ConvertUnitState(0x51);
  const baseInterval = japi.GetUnitState(hero, intervalState);
  const speedScale = japi.GetUnitState(hero, speedState);
  const oldAps = getPlayerAttr(player, "每秒攻速");
  const oldMoveSpeed = getPlayerAttr(player, "移动速度");

  const attackIntervalSafe = baseInterval > 0 && speedScale > 0 ? baseInterval / speedScale : 0;
  const computedApsSafe = attackIntervalSafe > 0 ? 1 / attackIntervalSafe : 0;
  const attacksPerSecond = computedApsSafe > 0 ? computedApsSafe : oldAps;
  const rawMoveSpeed = jass.GetUnitMoveSpeed(hero);
  const moveSpeed = rawMoveSpeed > 0 ? rawMoveSpeed : oldMoveSpeed;

  // 全客户端周期回写 YD：须与浮点无关的确定性，否则 SaveReal 微差易 desync/掉线
  const apsQuant = round(attacksPerSecond * 10000) / 10000;
  const moveQuant = round(moveSpeed * 100) / 100;
  if (apsQuant > 0) {
    YDUserDataSet("player", player, "每秒攻速", "real", apsQuant);
  }
  if (moveQuant > 0) {
    YDUserDataSet("player", player, "移动速度", "real", moveQuant);
  }
}

/**
 * 英雄头像贴图路径（物编 Art / uico）。
 * 与 `属性查看.j` 一致：**仅在创建 Dz 头像时调用一次**；周期定时器只刷文字，不重复 `DzFrameSetTexture` 头像。
 */
export function getHeroIcon(hero: any): string {
  if (hero == null) return EMPTY_ICON;
  const typeId = jass.GetUnitTypeId(hero);
  if (typeId == null || typeId === 0) return EMPTY_ICON;

  const art = getObjectProperty(ObjectType.UNIT, typeId, "Art");
  if (isTexturePath(art)) return art;

  const icon = getObjectProperty(ObjectType.UNIT, typeId, "uico");
  if (isTexturePath(icon)) return icon;

  return EMPTY_ICON;
}

export function formatInteger(value: number): string {
  return round(max(0, value)).toString();
}

export function formatPercent(value: number): string {
  return round(value * 100).toString() + "%";
}

export function formatRate(value: number): string {
  return (round(value * 100) / 100).toString();
}

function dualLine(leftColor: string, leftLabel: string, leftValue: string, rightColor: string, rightLabel: string, rightValue: string): string {
  if (rightLabel === "") return `${leftColor}${leftLabel}${leftValue}|r`;
  return `${leftColor}${leftLabel}${leftValue}|r ${rightColor}${rightLabel}${rightValue}|r`;
}

function singleLine(color: string, label: string, value: string): string {
  return `${color}${label}${value}|r`;
}

/**
 * 将三列属性合并成五列布局（左列、分隔符、中列、分隔符、右列）
 * 每列布局：第1行分隔线、第2行标题、第3行分隔线，从第4行开始显示竖线分隔符
 */
function linesToColumns(left: string[], mid: string[], right: string[]): string[] {
  const maxRows = maxNum3(left.length, mid.length, right.length);
  const result: string[] = [];

  for (let i = 0; i < maxRows; i++) {
    // 左列
    result.push(left[i] || "");
    // 分隔符1（第1-3行不显示，从第4行开始）
    result.push(i >= 3 ? "|" : "");
    // 中列
    result.push(mid[i] || "");
    // 分隔符2（第1-3行不显示，从第4行开始）
    result.push(i >= 3 ? "|" : "");
    // 右列
    result.push(right[i] || "");
  }

  return result;
}

function pctPlus100(player: any, attr: string): string {
  return formatPercent((100 + getPlayerAttr(player, attr) * 100) / 100);
}

function pctMinus100(player: any, attr: string): string {
  return formatPercent((100 - getPlayerAttr(player, attr) * 100) / 100);
}

function pct(player: any, attr: string): string {
  return formatPercent(getPlayerAttr(player, attr));
}

function number(player: any, attr: string): string {
  return formatInteger(getPlayerAttr(player, attr));
}

/**
 * 按 `属性查看.j` 的展示顺序拼出属性框每一行文本。
 * 这里统一改为读取当前 TS 正式属性名，不再兼容旧 JASS 字段名。
 * 与装备系统属性对齐
 *
 * ============================================================
 * 三列布局对齐规则（重要！后续开发者请务必遵守）
 * ============================================================
 *
 * 【布局结构】
 * - 左列：基础属性（英雄核心属性）
 * - 中列：常规属性（战斗相关属性）
 * - 右列：特殊属性（元素和吸血属性）
 *
 * 【行对齐规则】
 * 同一行上的三列属性应该具有关联性，便于玩家对照查看：
 *
 * 第3-4行：攻速移速 / 物理伤害抗性 / 光属性伤害抗性
 * 第5-6行：生命法力% / 魔法伤害抗性 / 暗属性伤害抗性
 * 第7-8行：生命恢复组 / 技能伤害抗性 / 木属性伤害抗性
 * 第9-10行：生命恢复组 / 普攻伤害抗性 / 火属性伤害抗性
 * 第11-12行：魔法恢复组 / 穿透属性 / 雷属性伤害抗性
 * 第13-14行：【暴击组】暴击率/暴击伤害 ↔ 被暴击率/被暴击伤害 / 水属性伤害抗性
 * 第15-16行：【命中组】命中率/闪避率 ↔ 伤害%/伤害减少% / 金属性伤害抗性
 * 第17-18行：【重伤组】重伤/恢复效率 ↔ 强化伤害/最终伤害 / 召唤物伤害抗性
 * 第19-20行：治疗相关 / 冷却缩减/经验获取率 / 吸血属性
 * 第21行：预留 / 预留 / 伤害吸血
 *
 * 【关键对齐组】
 * 1. 暴击组（第13-14行）：
 *    - 左列：暴击率、暴击伤害（进攻方）
 *    - 中列：被暴击率、被暴击伤害（防守方）
 *    - 右列：水属性伤害、水属性抗性
 *
 * 2. 命中组（第15-16行）：
 *    - 左列：命中率、闪避率（攻防对）
 *    - 中列：伤害%、伤害减少%（攻防对）
 *    - 右列：金属性伤害、金属性抗性
 *
 * 3. 重伤组（第17-18行）：
 *    - 左列：重伤、恢复效率（攻防对）
 *    - 中列：强化伤害、最终伤害（伤害加成组）
 *    - 右列：召唤物伤害、召唤物抗性
 *
 * 4. 伤害/抗性对（各自行内）：
 *    - 物理伤害 ↔ 物理抗性（第3-4行，橙色）
 *    - 魔法伤害 ↔ 魔抗（第5-6行，蓝色）
 *    - 技能伤害 ↔ 技能抗性（第7-8行，绿色）
 *    - 普攻伤害 ↔ 普攻抗性（第9-10行，灰色）
 *    - 所有元素属性伤害 ↔ 抗性（第3-18行，右列）
 *
 * 【颜色统一规则】
 * - 物理系：橙色 |cffc47f4f
 * - 魔法系：蓝色 |cff67d8ff
 * - 技能系：绿色 |cff7bff7b
 * - 普攻系：灰色 |cffb5b5b5
 * - 暴击系：红色 |cffff4b4b
 *
 * 【修改注意事项】
 * - 新增属性时，确保三列总行数一致
 * - 调整属性位置时，保持关联属性在同一行
 * - 修改后务必运行 npm run build 验证
 * ============================================================
 */
export function buildDetailTexts(player: any): string[] {
  updatePlayerRealtimeStats(player);

  // ============================================================
  // 左列：基础属性 (22行：3行标题+19行属性)
  // 包含：速度、生命/法力、恢复、暴击、命中闪避、治疗相关
  // ============================================================
  const leftColumn = [
    // --- 标题区（第0-2行）---
    "|cff000000────────|r",
    singleLine("|cffd8b26a", "【基础属性】", ""),
    "|cff000000────────|r",
    // --- 速度属性（第3-4行）---
    singleLine("|cff8ebfff", "攻速：", formatRate(getPlayerAttr(player, "每秒攻速")) + "次/秒"),
    singleLine("|cff8ebfff", "移速：", number(player, "移动速度")),
    // --- 生命/法力百分比（第5-6行）---
    singleLine("|cffc0ff82", "生命值%：", pct(player, "生命值%")),
    singleLine("|cff8fdfff", "法力值%：", pct(player, "法力值%")),
    // --- 生命恢复组（第7-9行）---
    singleLine("|cff96ff9d", "生命恢复：", number(player, "生命恢复") + "/秒"),
    singleLine("|cff96ff9d", "生命恢复%：", pct(player, "生命恢复%")),
    singleLine("|cff96ff9d", "总生命恢复：", number(player, "总生命恢复") + "/秒"),
    // --- 魔法恢复组（第10-12行）---
    singleLine("|cff8fdfff", "魔法恢复：", number(player, "魔法恢复") + "/秒"),
    singleLine("|cff8fdfff", "魔法恢复%：", pct(player, "魔法恢复%")),
    singleLine("|cff8fdfff", "总魔法恢复：", number(player, "总魔法恢复") + "/秒"),
    // --- 【暴击组】进攻方（第13-14行）与中列被暴击组对齐 ---
    singleLine("|cffff6d5b", "暴击率：", pct(player, "暴击率")),
    singleLine("|cffff4b4b", "暴击伤害：", formatPercent((150 + getPlayerAttr(player, "暴击伤害") * 100) / 100)),
    // --- 【命中组】进攻方（第15-16行）与中列闪避组对齐 ---
    singleLine("|cffffa7af", "命中率：", pct(player, "命中率")),
    singleLine("|cffd4c7ff", "闪避率：", pct(player, "闪避率")),
    // --- 【重伤组】进攻方（第17-18行）与中列恢复效率对齐 ---
    singleLine("|cffff967d", "重伤：", pct(player, "重伤")),
    singleLine("|cff96ff9d", "恢复效率：", pct(player, "生命恢复效率")),
    // --- 治疗相关（第19-20行）---
    singleLine("|cffffcc99", "技能治疗率：", pct(player, "技能治疗率")),
    singleLine("|cffffcc99", "受到治疗率：", pct(player, "受到的治疗率")),
  ];

  // ============================================================
  // 中列：常规属性 (22行：3行标题+19行属性)
  // 包含：物理/魔法/技能/普攻伤害抗性、穿透、暴击防守方、伤害加成
  // ============================================================
  const midColumn = [
    // --- 标题区（第0-2行）---
    "|cff000000────────|r",
    singleLine("|cffff9d5c", "【常规属性】", ""),
    "|cff000000────────|r",
    // --- 物理伤害/抗性（第3-4行）橙色系 ---
    singleLine("|cffc47f4f", "物理伤害：", pctPlus100(player, "物理伤害")),
    singleLine("|cffc47f4f", "物理抗性：", pctMinus100(player, "物理抗性")),
    // --- 魔法伤害/抗性（第5-6行）蓝色系 ---
    singleLine("|cff67d8ff", "魔法伤害：", pctPlus100(player, "魔法伤害")),
    singleLine("|cff67d8ff", "魔抗：", pctMinus100(player, "魔抗")),
    // --- 技能伤害/抗性（第7-8行）绿色系 ---
    singleLine("|cff7bff7b", "技能伤害：", pctPlus100(player, "技能伤害")),
    singleLine("|cff7bff7b", "技能抗性：", pctMinus100(player, "技能抗性")),
    // --- 普攻伤害/抗性（第9-10行）灰色系 ---
    singleLine("|cffb5b5b5", "普攻伤害：", pctPlus100(player, "普攻伤害")),
    singleLine("|cffb5b5b5", "普攻抗性：", pctMinus100(player, "普攻抗性")),
    // --- 穿透属性（第11-12行）---
    singleLine("|cffffca7e", "护甲穿透：", pct(player, "护甲穿透")),
    singleLine("|cff77ddff", "魔法穿透：", pct(player, "魔法穿透")),
    // --- 【暴击组】防守方（第13-14行）与左列暴击组对齐，红色系 ---
    singleLine("|cffff4b4b", "被暴击率：", pct(player, "被暴击率")),
    singleLine("|cffff4b4b", "被暴击伤害：", pct(player, "被暴击伤害")),
    // --- 【伤害组】加成/减少（第15-16行）与右列金属性对齐 ---
    singleLine("|cffff00ff", "伤害%：", pct(player, "伤害%")),
    singleLine("|cffd0d9e1", "伤害减少%：", pct(player, "伤害减少%")),
    // --- 强化/最终伤害（第17-18行）---
    singleLine("|cffff8b57", "强化伤害：", pctPlus100(player, "强化伤害")),
    singleLine("|cffff00ff", "最终伤害：", pct(player, "最终伤害%")),
    // --- 冷却/经验（第19-20行）---
    singleLine("|cff99ccff", "冷却缩减：", pct(player, "冷却缩减")),
    singleLine("|cffff00ff", "经验获取率：", pct(player, "经验获取率")),
  ];

  // ============================================================
  // 右列：特殊属性 (22行：3行标题+19行属性)
  // 包含：八元素伤害抗性、召唤物、三种吸血
  // 元素属性按 光→暗→木→火→雷→水→金→召唤物 顺序排列
  // ============================================================
  const rightColumn = [
    // --- 标题区（第0-2行）---
    "|cff000000────────|r",
    singleLine("|cff8fd9ff", "【特殊属性】", ""),
    "|cff000000────────|r",
    // --- 光属性（第3-4行）---
    singleLine("|cffffeb7c", "光属性伤害：", pctPlus100(player, "光属性伤害")),
    singleLine("|cffffeb7c", "光属性抗性：", pctMinus100(player, "光属性抗性")),
    // --- 暗属性（第5-6行）---
    singleLine("|cff9e7bff", "暗属性伤害：", pctPlus100(player, "暗属性伤害")),
    singleLine("|cff9e7bff", "暗属性抗性：", pctMinus100(player, "暗属性抗性")),
    // --- 木属性（第7-8行）---
    singleLine("|cff7bff7b", "木属性伤害：", pctPlus100(player, "木属性伤害")),
    singleLine("|cff7bff7b", "木属性抗性：", pctMinus100(player, "木属性抗性")),
    // --- 火属性（第9-10行）---
    singleLine("|cffff7b7b", "火属性伤害：", pctPlus100(player, "火属性伤害")),
    singleLine("|cffff7b7b", "火属性抗性：", pctMinus100(player, "火属性抗性")),
    // --- 雷属性（第11-12行）---
    singleLine("|cffffeb3b", "雷属性伤害：", pctPlus100(player, "雷属性伤害")),
    singleLine("|cffffeb3b", "雷属性抗性：", pctMinus100(player, "雷属性抗性")),
    // --- 水属性（第13-14行）与暴击组同行 ---
    singleLine("|cff7bebff", "水属性伤害：", pctPlus100(player, "水属性伤害")),
    singleLine("|cff7bebff", "水属性抗性：", pctMinus100(player, "水属性抗性")),
    // --- 金属性（第15-16行）---
    singleLine("|cffffd700", "金属性伤害：", pctPlus100(player, "金属性伤害")),
    singleLine("|cffffd700", "金属性抗性：", pctMinus100(player, "金属性抗性")),
    // --- 召唤物（第17-18行）---
    singleLine("|cffff7c7c", "召唤物伤害：", pctPlus100(player, "召唤物伤害")),
    singleLine("|cffff7c7c", "召唤物抗性：", pctMinus100(player, "召唤物抗性")),
    // --- 吸血属性（第19-21行）---
    singleLine("|cffff7c7c", "普攻吸血：", pct(player, "普攻伤害吸血")),
    singleLine("|cffff7c7c", "魔法吸血：", pct(player, "魔法伤害吸血")),
    singleLine("|cffff7c7c", "伤害吸血：", pct(player, "伤害吸血")),
  ];

  return linesToColumns(leftColumn, midColumn, rightColumn);
}
