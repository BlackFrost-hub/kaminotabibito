/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (duration: number, effect: any) => void;
};
const { YDUserDataSet, YDUserDataClear } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataSet: (tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClear: (tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { 回沙之书累计配置 } = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表") as {
  回沙之书累计配置: { 物品名: string; 累计阈值: number; 法力恢复倍率: number; 特效路径: string; 特效持续时间: number; 冷却时间: number };
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (s: string) => number;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetItemTypeId = jass.GetItemTypeId as (it: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (u: any, state: any, value: number) => void;
const UnitItemInSlot = jass.UnitItemInSlot as (u: any, slot: number) => any;
const CreateTimer = jass.CreateTimer as () => any;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, target: any, point: string) => any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as number;

const 回沙累计值表: Record<number, number | undefined> = {};
const 回沙CD表: Record<number, boolean | undefined> = {};
const 回沙CD计时器表: Record<number, number | undefined> = {};
const 回沙免疫开启计时器表: Record<number, number | undefined> = {};
const 回沙免疫结束计时器表: Record<number, number | undefined> = {};
const 回沙之书ID = stringToFourCC(resolveItemIdByName(回沙之书累计配置.物品名) ?? "");

function 单位拥有装备(this: void, unit: any, itemTypeId: number): boolean {
  if (unit == null || unit === 0 || itemTypeId <= 0) return false;
  for (let slot = 0; slot < 6; slot++) {
    const item = UnitItemInSlot(unit, slot);
    if (item != null && item !== 0 && GetItemTypeId(item) === itemTypeId) return true;
  }
  return false;
}

function 回沙CD结束(this: void): void {
  const timer = GetExpiredTimer();
  const timerId = GetHandleId(timer);
  const hid = 回沙CD计时器表[timerId];
  delete 回沙CD计时器表[timerId];
  DestroyTimer(timer);
  if (hid != null) {
    delete 回沙CD表[hid];
  }
}

function 回沙免疫结束(this: void): void {
  const timer = GetExpiredTimer();
  const timerId = GetHandleId(timer);
  const hid = 回沙免疫结束计时器表[timerId];
  delete 回沙免疫结束计时器表[timerId];
  DestroyTimer(timer);
  if (hid == null) return;

  const unit = hid as any;
  YDUserDataSet("unit", unit, "免疫伤害", "boolean", false);
  YDUserDataClear("unit", unit, "伤害免疫", "boolean");
}

function 回沙免疫开启(this: void): void {
  const timer = GetExpiredTimer();
  const timerId = GetHandleId(timer);
  const hid = 回沙免疫开启计时器表[timerId];
  delete 回沙免疫开启计时器表[timerId];
  DestroyTimer(timer);
  if (hid == null) return;

  const unit = hid as any;
  YDUserDataSet("unit", unit, "免疫伤害", "boolean", true);

  const endTimer = CreateTimer();
  const endTimerId = GetHandleId(endTimer);
  回沙免疫结束计时器表[endTimerId] = unit;
  TimerStart(endTimer, 1.25, false, 回沙免疫结束);
}

export function 处理回沙之书累计(this: void, target: any, _attacker: any, applied: number): void {
  debugLogForce("回沙之书", "进入处理", "target:", target, "applied:", applied);
  if (target == null || target === 0 || !(applied > 0)) {
    debugLogForce("回沙之书", "提前返回: target或applied无效", target, applied);
    return;
  }
  if (!单位拥有装备(target, 回沙之书ID)) {
    debugLogForce("回沙之书", "目标无回沙之书装备", "回沙之书ID:", 回沙之书ID);
    return;
  }

  const hid = GetHandleId(target);
  const gain = applied * 回沙之书累计配置.法力恢复倍率;
  if (!(gain > 0)) return;

  回沙累计值表[hid] = (回沙累计值表[hid] ?? 0) + gain;
  SetUnitState(target, UNIT_STATE_MANA, GetUnitState(target, UNIT_STATE_MANA) + gain);

  if ((回沙累计值表[hid] ?? 0) >= 回沙之书累计配置.累计阈值) {
    回沙累计值表[hid] = 0;
    const eff = AddSpecialEffectTarget(回沙之书累计配置.特效路径, target, "overhead");
    if (eff != null) {
      YDWETimerDestroyEffect(回沙之书累计配置.特效持续时间, eff);
    }
    if (回沙CD表[hid] !== true) {
      回沙CD表[hid] = true;
      const timer = CreateTimer();
      const timerId = GetHandleId(timer);
      回沙CD计时器表[timerId] = hid;
      TimerStart(timer, 回沙之书累计配置.冷却时间, false, 回沙CD结束);
    }

    const immuneTimer = CreateTimer();
    const immuneTimerId = GetHandleId(immuneTimer);
    回沙免疫开启计时器表[immuneTimerId] = target;
    TimerStart(immuneTimer, 0.50, false, 回沙免疫开启);
  }
}

export {};
