/** @noSelfInFile */
/**
 * 使者魔轮被动调试测试
 *
 * 输入 "143"：直接给大法师注册魔法吸收护盾并执行低蓝门槛测试
 * 输入 "145"：直接给大法师注册后再移除护盾，测试回收
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 开始魔法吸收护盾, 移除单位魔法吸收护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.24．魔法吸收护盾.01．魔法吸收护盾") as {
  开始魔法吸收护盾: (this: void, 参数: {
    单位: any;
    持续时间?: number;
    伤害吸收比例?: number;
    每点魔法吸收伤害: number;
    最低魔法百分比?: number;
    最低魔法固定值?: number;
    仅非物理伤害?: boolean;
    是否有特效?: boolean;
    特效路径?: string;
    特效挂点?: string;
    显示文本?: boolean;
    标签?: string;
  }) => number;
  移除单位魔法吸收护盾: (this: void, 单位: any, 标签: string) => void;
};

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitStateJapi = japi.SetUnitState as (unit: any, state: any, value: number) => void;
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
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;

const 模块名 = "使者魔轮被动测试";
const 测试命令低蓝 = "143";
const 测试命令丢弃 = "145";
const 测试标签 = "测试:使者魔轮被动";

const 低蓝测试伤害 = 100;

function 获取测试单位(this: void): any {
  return g.gg_unit_Hamg_0002 ?? (globalThis as any).bj_lastCreatedUnit;
}

function 取门槛(this: void, unit: any): number {
  const maxMana = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA);
  return maxMana * 0.1 + 500;
}

function 打印单位状态(this: void, 前缀: string, unit: any): void {
  const currentLife = GetUnitState(unit, UNIT_STATE_LIFE);
  const currentMana = GetUnitState(unit, UNIT_STATE_MANA);
  const maxMana = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA);
  const threshold = 取门槛(unit);
  debugLogForce(
    模块名,
    前缀,
    "life=",
    currentLife,
    "mana=",
    currentMana,
    "maxMana=",
    maxMana,
    "threshold=",
    threshold,
  );
}

function 设置测试魔法(this: void, unit: any, maxMana: number, currentMana: number): void {
  SetUnitStateJapi(unit, UNIT_STATE_MAX_MANA, maxMana);
  SetUnitState(unit, UNIT_STATE_MANA, currentMana);
  debugLogForce(模块名, "已设置魔法", "maxMana=", maxMana, "currentMana=", currentMana);
  打印单位状态("设置后", unit);
}

function 造成魔法伤害(this: void, source: any, target: any, amount: number, 标题: string): void {
  debugLogForce(模块名, 标题, "准备施加魔法伤害", "amount=", amount);
  打印单位状态("施加前", target);
  UnitDamageTarget(source, target, amount, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
  addDelayedCallback(100, function on伤害后打印(): void {
    打印单位状态("施加后", target);
  });
}

function 注册测试护盾(this: void, unit: any): void {
  移除单位魔法吸收护盾(unit, 测试标签);
  const id = 开始魔法吸收护盾({
    单位: unit,
    持续时间: 0,
    伤害吸收比例: 0.2,
    每点魔法吸收伤害: 2.2,
    最低魔法百分比: 0.1,
    最低魔法固定值: 500,
    仅非物理伤害: true,
    是否有特效: true,
    特效路径: "war3mapImported\\Energy Shield.mdl",
    特效挂点: "origin",
    显示文本: true,
    标签: 测试标签,
  });
  debugLogForce(模块名, "已直接注册测试护盾", "id=", id, "标签=", 测试标签);
}

function 测试低蓝(this: void): void {
  const unit = 获取测试单位();
  if (unit == null || unit === 0) {
    debugLogForce(模块名, "未找到测试单位");
    return;
  }
  注册测试护盾(unit);
  设置测试魔法(unit, 1000, 540);
  debugLogForce(模块名, "低蓝测试说明", "阈值=600", "当前蓝=540", "预期：不触发魔法吸收");
  addDelayedCallback(150, function on低蓝伤害(): void {
    造成魔法伤害(unit, unit, 低蓝测试伤害, "低蓝测试");
  });
}

function 测试丢弃(this: void): void {
  const unit = 获取测试单位();
  if (unit == null || unit === 0) {
    debugLogForce(模块名, "未找到测试单位");
    return;
  }
  注册测试护盾(unit);
  设置测试魔法(unit, 1000, 800);
  debugLogForce(模块名, "移除测试说明", "先注册护盾，再移除护盾，预期移除后不再吸收");

  addDelayedCallback(150, function on移除前打印(): void {
    打印单位状态("移除前", unit);
    移除单位魔法吸收护盾(unit, 测试标签);
    debugLogForce(模块名, "已移除测试护盾", "标签=", 测试标签);

    addDelayedCallback(150, function on移除后伤害(): void {
      打印单位状态("移除后伤害前", unit);
      造成魔法伤害(unit, unit, 低蓝测试伤害, "移除后伤害");
    });
  });
}

function on聊天命令回调(this: void, _player: any, command: string): void {
  if (command === 测试命令低蓝) {
    测试低蓝();
    return;
  }
  if (command === 测试命令丢弃) {
    测试丢弃();
    return;
  }
  debugLogForce(模块名, "未知命令", command);
}

function 初始化测试(this: void): void {
  注册聊天命令监听(测试命令低蓝, on聊天命令回调);
  注册聊天命令监听(测试命令丢弃, on聊天命令回调);
  debugLogForce(
    模块名,
    "已注册测试命令",
    测试命令低蓝,
    测试命令丢弃,
    "测试方式=直接注册魔法吸收护盾",
    "预期阈值公式=最大魔法*10%+500",
    "低蓝=540",
  );
}

初始化测试();

export {};
