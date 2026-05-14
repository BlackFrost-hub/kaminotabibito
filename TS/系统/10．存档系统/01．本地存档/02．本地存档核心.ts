/** @noSelfInFile */
/**
 * 本地存档核心
 *
 * 这里只管理“玩家本机配置”的读写，不直接接入具体业务系统。
 * 业务层后续只需要读写字段枚举，例如动态技能文本、仇恨文字、热键 VK 码。
 */

const jass = require("jass.common") as any;

const PreloadSL = require("系统.10．存档系统.01．本地存档.00．PreloadSL本地存档") as {
  PreloadSL接口是否存在: (this: void) => boolean;
  PreloadSL接口来源描述: (this: void) => string;
  PreloadSL设置整数: (this: void, player: any, index: number, value: number) => boolean;
  PreloadSL读取整数: (this: void, player: any, index: number) => number;
  PreloadSL保存: (this: void, player: any, dir: string, file: string, fieldCount: number) => boolean;
  PreloadSL加载: (this: void, player: any, dir: string, file: string, fieldCount: number) => boolean;
  PreloadSL获取存档路径: (this: void, dir: string, file: string) => string;
  PreloadSL保存文本: (this: void, player: any, dir: string, file: string, payload: string) => boolean;
  PreloadSL加载文本: (this: void, player: any, dir: string, file: string) => string;
};
const 常量 = require("系统.10．存档系统.01．本地存档.01．常量定义") as {
  本地存档目录: string;
  本地存档文件: string;
  本地存档字段数量: number;
  本地存档字段: Record<string, number>;
  本地存档默认值: Record<number, number>;
};
const GetPlayerId = jass.GetPlayerId as (player: any) => number;

const 玩家数量上限 = 12;
const 本地存档已加载表: Record<number, boolean | undefined> = {};
const 本地存档值表: Record<number, number | undefined> = {};
const 按键名到码表: Record<string, number | undefined> = {
  A: 65, B: 66, C: 67, D: 68, E: 69, F: 70, G: 71, H: 72, I: 73, J: 74,
  K: 75, L: 76, M: 77, N: 78, O: 79, P: 80, Q: 81, R: 82, S: 83, T: 84,
  U: 85, V: 86, W: 87, X: 88, Y: 89, Z: 90,
};
const 按键码到名表: Record<number, string | undefined> = {
  65: "A", 66: "B", 67: "C", 68: "D", 69: "E", 70: "F", 71: "G", 72: "H", 73: "I", 74: "J",
  75: "K", 76: "L", 77: "M", 78: "N", 79: "O", 80: "P", 81: "Q", 82: "R", 83: "S", 84: "T",
  85: "U", 86: "V", 87: "W", 88: "X", 89: "Y", 90: "Z",
};

function 构建状态键(this: void, playerId: number, field: number): number {
  return playerId * 1000 + field;
}

function 获取玩家编号(this: void, player: any): number {
  return GetPlayerId(player);
}

function 获取默认值(this: void, field: number, fallback: number): number {
  const value = 常量.本地存档默认值[field];
  return value == null ? fallback : value;
}

function 写入内存值(this: void, playerId: number, field: number, value: number): void {
  本地存档值表[构建状态键(playerId, field)] = value;
}

function 读取内存值(this: void, playerId: number, field: number, fallback: number): number {
  const value = 本地存档值表[构建状态键(playerId, field)];
  return value == null ? fallback : value;
}

function 写入默认值到内存(this: void, playerId: number): void {
  for (let field = 1; field <= 常量.本地存档字段数量; field++) {
    写入内存值(playerId, field, 获取默认值(field, 0));
  }
}

function 写入Preload字段(this: void, player: any, playerId: number): void {
  for (let field = 1; field <= 常量.本地存档字段数量; field++) {
    const value = 读取内存值(playerId, field, 获取默认值(field, 0));
    PreloadSL.PreloadSL设置整数(player, field, value);
  }
}

function 读取Preload字段到内存(this: void, player: any, playerId: number): void {
  for (let field = 1; field <= 常量.本地存档字段数量; field++) {
    const fallback = 获取默认值(field, 0);
    const value = PreloadSL.PreloadSL读取整数(player, field);
    写入内存值(playerId, field, value == null ? fallback : value);
  }
}

function 布尔转文本(this: void, value: number): string {
  return value !== 0 ? "true" : "false";
}

function 文本转布尔整数(this: void, text: string, fallback: number): number {
  const normalized = text.trim().toLowerCase();
  if (normalized === "true" || normalized === "1" || normalized === "on" || normalized === "yes" || normalized === "开") return 1;
  if (normalized === "false" || normalized === "flase" || normalized === "0" || normalized === "off" || normalized === "no" || normalized === "关") return 0;
  return fallback;
}

function 按键码转文本(this: void, keyCode: number): string {
  const keyName = 按键码到名表[keyCode];
  return keyName == null ? tostring(keyCode) : keyName;
}

function 文本转按键码(this: void, text: string, fallback: number): number {
  const normalized = text.trim().toUpperCase();
  const mapped = 按键名到码表[normalized];
  if (mapped != null) return mapped;

  const value = parseInt(normalized, 10);
  if (isNaN(value)) return fallback;
  return value;
}

function 构建可读配置载荷(this: void, playerId: number): string {
  const 字段 = 常量.本地存档字段;
  const 动态技能 = 读取内存值(playerId, 字段.动态技能文本开关, 获取默认值(字段.动态技能文本开关, 1));
  const 仇恨开关 = 读取内存值(playerId, 字段.仇恨漂浮文字开关, 获取默认值(字段.仇恨漂浮文字开关, 1));
  const 冷却显示 = 读取内存值(playerId, 字段.QWERD冷却显示开关, 获取默认值(字段.QWERD冷却显示开关, 1));
  const 蓝耗显示 = 读取内存值(playerId, 字段.QWERD蓝耗显示开关, 获取默认值(字段.QWERD蓝耗显示开关, 1));
  const 仇恨键 = 读取内存值(playerId, 字段.仇恨面板热键, 获取默认值(字段.仇恨面板热键, 86));
  const 手册键 = 读取内存值(playerId, 字段.游戏说明手册热键, 获取默认值(字段.游戏说明手册热键, 75));
  const 显示键 = 读取内存值(playerId, 字段.QWERD显示面板热键, 获取默认值(字段.QWERD显示面板热键, 74));

  return "chouhen=" + 布尔转文本(仇恨开关)
    + ";dongtai=" + 布尔转文本(动态技能)
    + ";lengque=" + 布尔转文本(冷却显示)
    + ";lanhao=" + 布尔转文本(蓝耗显示)
    + ";chouhenjian=" + 按键码转文本(仇恨键)
    + ";shoucejian=" + 按键码转文本(手册键)
    + ";xianshijian=" + 按键码转文本(显示键);
}

function 文本包含(this: void, text: string, pattern: string): boolean {
  return text.indexOf(pattern) >= 0;
}

function 应用可读配置项(this: void, playerId: number, key: string, value: string): void {
  const 字段 = 常量.本地存档字段;
  if (key === "chouhen" || key === "hateText" || key === "仇恨开关" || key === "仇恨文字") {
    const fallback = 获取默认值(字段.仇恨漂浮文字开关, 1);
    写入内存值(playerId, 字段.仇恨漂浮文字开关, 文本转布尔整数(value, fallback));
    return;
  }
  if (key === "dongtai" || key === "dynamicSkill" || key === "动态技能") {
    const fallback = 获取默认值(字段.动态技能文本开关, 1);
    写入内存值(playerId, 字段.动态技能文本开关, 文本转布尔整数(value, fallback));
    return;
  }
  if (key === "lengque" || key === "cooldown" || key === "冷却显示") {
    const fallback = 获取默认值(字段.QWERD冷却显示开关, 1);
    写入内存值(playerId, 字段.QWERD冷却显示开关, 文本转布尔整数(value, fallback));
    return;
  }
  if (key === "lanhao" || key === "manaCost" || key === "蓝耗显示") {
    const fallback = 获取默认值(字段.QWERD蓝耗显示开关, 1);
    写入内存值(playerId, 字段.QWERD蓝耗显示开关, 文本转布尔整数(value, fallback));
    return;
  }
  if (key === "chouhenjian" || key === "hateKey" || key === "仇恨键") {
    const fallback = 获取默认值(字段.仇恨面板热键, 86);
    写入内存值(playerId, 字段.仇恨面板热键, 文本转按键码(value, fallback));
    return;
  }
  if (key === "shoucejian" || key === "manualKey" || key === "手册键") {
    const fallback = 获取默认值(字段.游戏说明手册热键, 75);
    写入内存值(playerId, 字段.游戏说明手册热键, 文本转按键码(value, fallback));
    return;
  }
  if (key === "xianshijian" || key === "displayKey" || key === "显示键") {
    const fallback = 获取默认值(字段.QWERD显示面板热键, 74);
    写入内存值(playerId, 字段.QWERD显示面板热键, 文本转按键码(value, fallback));
  }
}

function 解析可读配置载荷(this: void, playerId: number, payload: string): boolean {
  if (!文本包含(payload, "=")) return false;

  const entries = payload.split(";");
  for (let i = 0; i < entries.length; i++) {
    const entry = entries[i];
    const eqIndex = entry.indexOf("=");
    if (eqIndex <= 0) continue;

    const key = entry.substring(0, eqIndex).trim();
    const value = entry.substring(eqIndex + 1).trim();
    应用可读配置项(playerId, key, value);
  }
  return true;
}

function 解析旧整数载荷(this: void, player: any, playerId: number): void {
  读取Preload字段到内存(player, playerId);
}

export function 本地存档接口可用(this: void): boolean {
  return PreloadSL.PreloadSL接口是否存在();
}

export function 获取本地存档接口来源(this: void): string {
  return PreloadSL.PreloadSL接口来源描述();
}

export function 获取本地存档路径(this: void): string {
  return PreloadSL.PreloadSL获取存档路径(常量.本地存档目录, 常量.本地存档文件);
}

export function 加载玩家本地存档(this: void, player: any): boolean {
  if (!本地存档接口可用()) return false;

  const playerId = 获取玩家编号(player);
  写入默认值到内存(playerId);

  const payload = PreloadSL.PreloadSL加载文本(player, 常量.本地存档目录, 常量.本地存档文件);
  const ok = payload != null && payload !== "";
  if (ok) {
    if (!解析可读配置载荷(playerId, payload)) {
      解析旧整数载荷(player, playerId);
    }
  }
  本地存档已加载表[playerId] = true;
  return ok;
}

export function 保存玩家本地存档(this: void, player: any): boolean {
  if (!本地存档接口可用()) return false;

  const playerId = 获取玩家编号(player);
  if (本地存档已加载表[playerId] !== true) {
    写入默认值到内存(playerId);
    本地存档已加载表[playerId] = true;
  }

  写入内存值(playerId, 常量.本地存档字段.版本号, 获取默认值(常量.本地存档字段.版本号, 1));
  const payload = 构建可读配置载荷(playerId);
  const saveOk = PreloadSL.PreloadSL保存文本(player, 常量.本地存档目录, 常量.本地存档文件, payload);
  return saveOk;
}

export function 读取本地存档整数(this: void, player: any, field: number, fallback?: number): number {
  const playerId = 获取玩家编号(player);
  const defaultValue = fallback == null ? 获取默认值(field, 0) : fallback;
  return 读取内存值(playerId, field, defaultValue);
}

export function 设置本地存档整数(this: void, player: any, field: number, value: number, autoSave?: boolean): boolean {
  const playerId = 获取玩家编号(player);
  写入内存值(playerId, field, value);
  if (autoSave === true) return 保存玩家本地存档(player);
  return true;
}

export function 读取本地存档布尔(this: void, player: any, field: number, fallback?: boolean): boolean {
  const fallbackValue = fallback === true ? 1 : 0;
  return 读取本地存档整数(player, field, fallbackValue) !== 0;
}

export function 设置本地存档布尔(this: void, player: any, field: number, enabled: boolean, autoSave?: boolean): boolean {
  return 设置本地存档整数(player, field, enabled ? 1 : 0, autoSave);
}

export function 重置玩家本地存档(this: void, player: any, autoSave?: boolean): boolean {
  const playerId = 获取玩家编号(player);
  写入默认值到内存(playerId);
  本地存档已加载表[playerId] = true;
  if (autoSave === true) return 保存玩家本地存档(player);
  return true;
}

export function 初始化本地存档内存默认值(this: void): void {
  for (let playerId = 0; playerId < 玩家数量上限; playerId++) {
    写入默认值到内存(playerId);
  }
}
