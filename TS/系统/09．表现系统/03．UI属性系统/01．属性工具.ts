/** @noSelfInFile */
/**
 * UI属性系统 - 属性读取、格式化与派生值更新
 */

const jass = require("jass.common") as any;

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

function isTexturePath(path: string): boolean {
  if (path === "") return false;
  const lower = path.toLowerCase();
  return lower.endsWith(".blp") || lower.endsWith(".dds") || lower.endsWith(".tga");
}

export function isPlayingPlayer(player: any): boolean {
  if (player == null) return false;
  return jass.GetPlayerSlotState(player) === jass.PLAYER_SLOT_STATE_PLAYING;
}

export function getDisplayPlayers(): any[] {
  const players: any[] = [];
  for (let i = 0; i < MAX_DISPLAY_PLAYERS; i++) {
    const player = jass.Player(i);
    if (!isPlayingPlayer(player)) continue;
    players.push(player);
  }
  return players;
}

/**
 * 从玩家级 YDUserData 中读取当前登记的英雄。
 * 这套 UI 直接依赖"玩家 -> 英雄"映射，而不是自行遍历单位组兜底。
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
 * 同步 JASS 原稿依赖的实时派生值。
 * 这里保留 0x25 / 0x51 的攻速算法，并把结果写回玩家属性表，供 UI 文本直接读取。
 */
export function updatePlayerRealtimeStats(player: any): void {
  const hero = getPlayerHero(player);
  if (hero == null) return;

  const intervalState = jass.ConvertUnitState(0x25);
  const speedState = jass.ConvertUnitState(0x51);
  const attackBaseInterval = jass.GetUnitState(hero, intervalState);
  const attackSpeedScale = jass.GetUnitState(hero, speedState);
  const attackInterval = attackSpeedScale > 0 ? attackBaseInterval / attackSpeedScale : 0;
  const attacksPerSecond = attackInterval > 0 ? 1 / attackInterval : 0;
  const moveSpeed = jass.GetUnitMoveSpeed(hero);

  YDUserDataSet("player", player, "每秒攻速", "real", attacksPerSecond);
  YDUserDataSet("player", player, "移动速度", "real", moveSpeed);
}

export function getHeroIcon(hero: any): string {
  if (hero == null) return EMPTY_ICON;
  const typeId = jass.GetUnitTypeId(hero);
  if (typeId == null || typeId === 0) return EMPTY_ICON;

  // 这里读取的是"单位类型"物编，不是单位实例。
  // 源 JASS 使用 Art；若当前物编返回的不是贴图路径，则回退到单位图标字段。
  const art = getObjectProperty(ObjectType.UNIT, typeId, "Art");
  if (isTexturePath(art)) return art;

  const icon = getObjectProperty(ObjectType.UNIT, typeId, "uico");
  if (isTexturePath(icon)) return icon;

  return EMPTY_ICON;
}

export function formatInteger(value: number): string {
  return Math.floor(Math.max(0, value) + 0.5).toString();
}

export function formatPercent(value: number): string {
  return Math.floor(value * 100 + 0.5).toString() + "%";
}

export function formatRate(value: number): string {
  return (Math.floor(value * 100 + 0.5) / 100).toString();
}

function dualLine(leftColor: string, leftLabel: string, leftValue: string, rightColor: string, rightLabel: string, rightValue: string): string {
  if (rightLabel === "") return `${leftColor}${leftLabel}${leftValue}|r`;
  return `${leftColor}${leftLabel}${leftValue}|r ${rightColor}${rightLabel}${rightValue}|r`;
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
 */
export function buildDetailTexts(player: any): string[] {
  updatePlayerRealtimeStats(player);

  return [
    // 伤害与抗性
    dualLine("|cff993300", "物理伤害：", pctPlus100(player, "物理伤害"), "|cff993300", "物理抗性：", pctMinus100(player, "物理抗性")),
    dualLine("|cff00ccff", "魔法伤害：", pctPlus100(player, "魔法伤害"), "|cff00ccff", "魔抗：", pctMinus100(player, "魔抗")),
    dualLine("|cffff6800", "技能伤害：", pctPlus100(player, "技能伤害"), "|cffff6800", "技能抗性：", pctMinus100(player, "技能抗性")),
    dualLine("|cffff6600", "强化伤害：", pctPlus100(player, "强化伤害"), "|cff333333", "召唤物伤害：", pctPlus100(player, "召唤物伤害")),
    dualLine("|cff333333", "召唤物抗性：", pctMinus100(player, "召唤物抗性"), "|cffff0000", "普攻伤害：", pctPlus100(player, "普攻伤害")),
    dualLine("|cffff0000", "普攻抗性：", pctMinus100(player, "普攻抗性"), "|cffff0000", "魔法普攻：", pctPlus100(player, "魔法普攻伤害")),
    // 元素属性
    dualLine("|cffff0000", "火属性：", `${pctPlus100(player, "火属性伤害")}/${pctPlus100(player, "火属性抗性")}`, "|cff00ffff", "水属性：", `${pctPlus100(player, "水属性伤害")}/${pctPlus100(player, "水属性抗性")}`),
    dualLine("|cffccffff", "雷属性：", `${pctPlus100(player, "雷属性伤害")}/${pctPlus100(player, "雷属性抗性")}`, "|cff99cc00", "木属性：", `${pctPlus100(player, "木属性伤害")}/${pctPlus100(player, "木属性抗性")}`),
    dualLine("|cffffff00", "光属性：", `${pctPlus100(player, "光属性伤害")}/${pctPlus100(player, "光属性抗性")}`, "|cff993366", "暗属性：", `${pctPlus100(player, "暗属性伤害")}/${pctPlus100(player, "暗属性抗性")}`),
    dualLine("|cffcccccc", "金属性：", `${pctPlus100(player, "金属性伤害")}/${pctPlus100(player, "金属性抗性")}`, "", "", ""),
    // 穿透与暴击
    dualLine("|cff993300", "护甲穿透：", pct(player, "护甲穿透"), "|cff00ccff", "魔法穿透：", pct(player, "魔法穿透")),
    dualLine("|cffff0000", "暴击率：", pct(player, "暴击率"), "|cffff0000", "暴击伤害：", formatPercent((150 + getPlayerAttr(player, "暴击伤害") * 100) / 100)),
    dualLine("|cffff8080", "被暴击率：-", pct(player, "被暴击率"), "|cffff8080", "被暴击伤害：-", pct(player, "被暴击伤害")),
    // 命中与闪避
    dualLine("|cffff8080", "命中率：", pct(player, "命中率"), "|cffff8080", "闪避率：", pct(player, "闪避率")),
    dualLine("|cff99ccff", "眩晕抗性：", pct(player, "眩晕抗性"), "|cffff8080", "重伤：", pct(player, "重伤")),
    // 冷却与减伤
    dualLine("|cffff8080", "冷却缩减：", pct(player, "冷却缩减"), "|cff99ccff", "伤害减少：", number(player, "伤害减少")),
    dualLine("|cff99ccff", "伤害减少%：", pct(player, "伤害减少%"), "|cff99ccff", "受到技伤减少：", number(player, "受到技伤减少")),
    dualLine("|cff99ccff", "受到物伤减少：", number(player, "受到物伤减少"), "", "", ""),
    // 攻速移速
    dualLine("|cff99ccff", "攻速：", formatRate(getPlayerAttr(player, "每秒攻速")) + "次/秒", "|cff99ccff", "移速：", number(player, "移动速度")),
    // 吸血
    dualLine("|cffff0000", "普攻吸血：", pct(player, "普攻伤害吸血"), "|cffff0000", "魔法吸血：", pct(player, "魔法伤害吸血")),
    dualLine("|cffff0000", "伤害吸血：", pct(player, "伤害吸血"), "", "", ""),
    // 生命恢复
    dualLine("|cffccffcc", "生命恢复：", number(player, "生命恢复") + "/秒", "|cffccffcc", "生命恢复%：", pct(player, "生命恢复%")),
    dualLine("|cffccffcc", "总生命恢复：", number(player, "总生命恢复") + "/秒", "|cffccffcc", "恢复效率：", pct(player, "生命恢复效率")),
    // 魔法恢复
    dualLine("|cffccffff", "魔法恢复：", number(player, "魔法恢复") + "/秒", "|cffccffff", "魔法恢复%：", pct(player, "魔法恢复%")),
    dualLine("|cffccffff", "总魔法恢复：", number(player, "总魔法恢复") + "/秒", "|cffccffff", "魔法消耗减少：", pct(player, "魔法消耗")),
    // 治疗效率
    dualLine("|cffffcc99", "技能治疗率：", pct(player, "技能治疗率"), "|cffffcc99", "受到治疗率：", pct(player, "受到的治疗率")),
    // 特殊属性
    dualLine("|cffff00ff", "伤害%：", pct(player, "伤害%"), "|cffff00ff", "最终伤害%：", pct(player, "最终伤害%")),
    dualLine("|cffff00ff", "经验获取率：", pct(player, "经验获取率"), "|cff99cc00", "蝼蚁专精：", pct(player, "蝼蚁专精")),
  ];
}

