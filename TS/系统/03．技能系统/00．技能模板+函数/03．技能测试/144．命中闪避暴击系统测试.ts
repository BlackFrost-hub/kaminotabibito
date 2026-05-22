/** @noSelfInFile */
/**
 * 命中 / 闪避 / 暴击系统测试
 *
 * 当前只保留一个场景：
 * 敌人攻击大法师，2 秒内造成 20 次 10 点魔法伤害，测试 10% 闪避。
 */

const jass = require("jass.common") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const { 是玩家英雄组单位 } = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, face: number) => any;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
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
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 模块名 = "命中闪避暴击测试";
const 测试命令 = "暴击测试";
const 敌人类型 = stringToFourCCSafe("hfoo");
const 单次伤害 = 10;
const 总次数 = 20;
const 间隔毫秒 = 100;
const 大法师闪避率 = 0.1;

let 当前来源: any = null;
let 当前目标: any = null;
let 当前次数 = 0;
let 当前计时器ID = 0;
let 当前总伤害 = 0;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 取地图大法师(this: void): any {
  return globals.gg_unit_Hamg_0002 ?? null;
}

function 取测试目标(this: void, whichPlayer: any): any {
  const 注册英雄 = getRegisteredPlayerHero(whichPlayer);
  if (单位有效(注册英雄)) return 注册英雄;

  const 地图大法师 = 取地图大法师();
  if (单位有效(地图大法师) && 是玩家英雄组单位(地图大法师)) return 地图大法师;
  return null;
}

function 清理来源(this: void): void {
  if (!单位有效(当前来源)) return;
  RemoveUnit(当前来源);
  当前来源 = null;
}

function 停止测试(this: void): void {
  if (当前计时器ID !== 0) {
    removePeriodicCallback(当前计时器ID);
    当前计时器ID = 0;
  }
  清理来源();
  当前目标 = null;
  当前次数 = 0;
  当前总伤害 = 0;
}

function 创建敌人(this: void, target: any): any {
  清理来源();
  const enemy = CreateUnit(Player(jass.PLAYER_NEUTRAL_AGGRESSIVE), 敌人类型, GetUnitX(target) + 250, GetUnitY(target), 270);
  if (!单位有效(enemy)) return null;
  当前来源 = enemy;
  return enemy;
}

function 设置目标满血(this: void, target: any): void {
  const 最大生命 = GetUnitState(target, UNIT_STATE_MAX_LIFE);
  SetUnitState(target, UNIT_STATE_LIFE, 最大生命);
  debugLogForce(模块名, "已设置满血", "life=", 最大生命);
}

function 设置大法师闪避(this: void, target: any): void {
  YDUserDataSetSafe("unit", target, "闪避率", "real", 大法师闪避率);
  debugLogForce(模块名, "已设置闪避率", `${Math.floor(大法师闪避率 * 100)}%`);
}

function on最终伤害(this: void, target: any, attacker: any, applied: number, _snapshot: any): void {
  if (target !== 当前目标 || attacker !== 当前来源) return;
  当前总伤害 = 当前总伤害 + applied;
  debugLogForce(模块名, "本次最终伤害", applied, "累计总伤害", 当前总伤害);
}

function 开始测试(this: void, whichPlayer: any): void {
  停止测试();

  const target = 取测试目标(whichPlayer);
  if (!单位有效(target)) {
    debugLogForce(模块名, "未找到测试目标", "player=", whichPlayer);
    return;
  }
  if (!是玩家英雄组单位(target)) {
    debugLogForce(模块名, "测试中止", "原因=目标不在玩家英雄单位组", "target=", target);
    return;
  }

  const enemy = 创建敌人(target);
  if (!单位有效(enemy)) {
    debugLogForce(模块名, "创建敌人失败");
    return;
  }

  当前目标 = target;
  当前次数 = 0;
  当前总伤害 = 0;
  设置目标满血(target);
  设置大法师闪避(target);
  debugLogForce(
    模块名,
    "开始测试",
    "player=",
    whichPlayer,
    "registeredHero=",
    getRegisteredPlayerHero(whichPlayer),
    "target=",
    target,
    "玩家英雄组单位=",
    是玩家英雄组单位(target),
    "enemy=",
    enemy,
    "单次伤害=",
    单次伤害,
    "总次数=",
    总次数,
  );
  当前计时器ID = addPeriodicCallback(间隔毫秒, on测试Tick);
}

function on测试Tick(this: void): void {
  if (!单位有效(当前来源) || !单位有效(当前目标)) {
    debugLogForce(模块名, "测试中断", "原因=来源或目标失效");
    停止测试();
    return;
  }

  当前次数 = 当前次数 + 1;
  debugLogForce(模块名, "tick=", 当前次数, "of", 总次数, "amount=", 单次伤害);
  UnitDamageTarget(
    当前来源,
    当前目标,
    单次伤害,
    false,
    false,
    ATTACK_TYPE_CHAOS,
    DAMAGE_TYPE_MAGIC,
    WEAPON_TYPE_WHOKNOWS,
  );

  if (当前次数 >= 总次数) {
    debugLogForce(模块名, "测试结束", "总伤害=", 当前总伤害);
    停止测试();
  }
}

function on聊天回调(this: void, player: any, command: string): void {
  if (command !== 测试命令) return;
  开始测试(player);
}

function 初始化(this: void): void {
  注册聊天命令监听(测试命令, on聊天回调);
  registerAppliedFinalDamageListener(on最终伤害);
  debugLogForce(模块名, "已注册测试命令", 测试命令, "内容=敌人打大法师，2秒内20次10点魔法伤害");
}

初始化();

export {};
