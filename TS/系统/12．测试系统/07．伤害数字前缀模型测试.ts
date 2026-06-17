/** @noSelfInFile */

/**
 * 伤害数字前缀模型测试
 *
 * 聊天命令：
 * - 数字暴击：大法师攻击临时步兵，强制暴击，观察目标头顶“暴击图标 + 伤害数字”。
 * - 数字闪避：临时步兵攻击大法师，强制闪避，观察大法师头顶闪避图标。
 * - 数字未命中：大法师攻击临时步兵，强制未命中，观察大法师头顶未命中图标。
 */

const jass = require("jass.common") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  createDelayedCall: (this: void, delaySec: number, callback: (this: void) => void) => any;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, face: number) => any;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any,
) => boolean;
const Player = jass.Player as (id: number) => any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

const 模块名 = "伤害数字前缀模型测试";
const 命令暴击 = "数字暴击";
const 命令闪避 = "数字闪避";
const 命令未命中 = "数字未命中";
const 临时单位类型 = stringToFourCCSafe("hfoo");
const 测试伤害 = 100;
const 临时单位生命 = 1000;
const 清理延迟 = 1.2;

let 待清理单位: any = null;
let 待重置大法师: any = null;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 取测试大法师(this: void): any {
  const unit = globals.gg_unit_Hamg_0002;
  return 单位有效(unit) ? unit : null;
}

function 设置单位实数(this: void, unit: any, attr: string, value: number): void {
  if (!单位有效(unit)) return;
  YDUserDataSetSafe("unit", unit, attr, "real", value);
}

function 设置玩家实数(this: void, unit: any, attr: string, value: number): void {
  if (!单位有效(unit)) return;
  const owner = GetOwningPlayer(unit);
  if (!单位有效(owner)) return;
  YDUserDataSetSafe("player", owner, attr, "real", value);
}

function 重置测试属性(this: void, archmage: any, target: any): void {
  设置玩家实数(archmage, "命中率", 0);
  设置玩家实数(archmage, "闪避率", 0);
  设置玩家实数(archmage, "暴击率", 0);
  设置玩家实数(archmage, "暴击伤害", 0);
  设置单位实数(archmage, "闪避率", 0);

  if (单位有效(target)) {
    设置单位实数(target, "闪避率", 0);
    设置单位实数(target, "被暴击率", 0);
    设置单位实数(target, "被暴击伤害", 0);
  }
}

function 创建临时单位(this: void, nearUnit: any, offsetX: number): any {
  const unit = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 临时单位类型, GetUnitX(nearUnit) + offsetX, GetUnitY(nearUnit), 270);
  if (!单位有效(unit)) return null;
  SetUnitState(unit, UNIT_STATE_MAX_LIFE, 临时单位生命);
  SetUnitState(unit, UNIT_STATE_LIFE, 临时单位生命);
  待清理单位 = unit;
  createDelayedCall(清理延迟, 清理临时单位);
  return unit;
}

function 清理临时单位(this: void): void {
  if (单位有效(待重置大法师)) {
    重置测试属性(待重置大法师, null);
    待重置大法师 = null;
  }
  if (!单位有效(待清理单位)) return;
  RemoveUnit(待清理单位);
  待清理单位 = null;
}

function 执行暴击测试(this: void, archmage: any): void {
  const target = 创建临时单位(archmage, 250);
  if (!单位有效(target)) {
    debugLogForce(模块名, "创建暴击测试目标失败");
    return;
  }

  待重置大法师 = archmage;
  重置测试属性(archmage, target);
  设置玩家实数(archmage, "暴击率", 1);
  设置玩家实数(archmage, "暴击伤害", 0);
  debugLogForce(模块名, "执行", 命令暴击, "观察临时目标头顶暴击图标和伤害数字");
  UnitDamageTarget(archmage, target, 测试伤害, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function 执行闪避测试(this: void, archmage: any): void {
  const attacker = 创建临时单位(archmage, 250);
  if (!单位有效(attacker)) {
    debugLogForce(模块名, "创建闪避测试攻击者失败");
    return;
  }

  待重置大法师 = archmage;
  重置测试属性(archmage, attacker);
  设置单位实数(archmage, "闪避率", 1);
  debugLogForce(模块名, "执行", 命令闪避, "观察大法师头顶闪避图标");
  UnitDamageTarget(attacker, archmage, 测试伤害, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function 执行未命中测试(this: void, archmage: any): void {
  const target = 创建临时单位(archmage, 250);
  if (!单位有效(target)) {
    debugLogForce(模块名, "创建未命中测试目标失败");
    return;
  }

  待重置大法师 = archmage;
  重置测试属性(archmage, target);
  设置玩家实数(archmage, "命中率", -1);
  debugLogForce(模块名, "执行", 命令未命中, "观察大法师头顶未命中图标");
  UnitDamageTarget(archmage, target, 测试伤害, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function on聊天命令(this: void, _player: any, command: string): void {
  const archmage = 取测试大法师();
  if (!单位有效(archmage)) {
    debugLogForce(模块名, "找不到 gg_unit_Hamg_0002");
    return;
  }

  if (command === 命令暴击) {
    执行暴击测试(archmage);
    return;
  }
  if (command === 命令闪避) {
    执行闪避测试(archmage);
    return;
  }
  if (command === 命令未命中) {
    执行未命中测试(archmage);
  }
}

function 初始化(this: void): void {
  注册聊天命令监听(命令暴击, on聊天命令);
  注册聊天命令监听(命令闪避, on聊天命令);
  注册聊天命令监听(命令未命中, on聊天命令);
  debugLogForce(模块名, "已注册命令", 命令暴击, 命令闪避, 命令未命中);
}

初始化();

export {};
