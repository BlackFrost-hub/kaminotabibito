/** @noSelfInFile */

const jass = require("jass.common") as any;
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 开始无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧") as {
  开始无敌帧: (this: void, unit: any, duration: number) => number;
};
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { 单位物品累伤次数, 获取单位指定装备 } = require("lib.扩展函数.物品相关函数.物品累伤次数函数") as {
  单位物品累伤次数: (this: void, unit: any, 装备名: string, 受到伤害: number, 比例?: number, 阈值?: number, 选项?: {
    是否在CD中?: boolean;
    达到阈值后重置?: boolean;
  }) => boolean;
  获取单位指定装备: (this: void, unit: any, itemTypeId: number) => any | null;
};
const { 回沙之书累计配置 } = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表") as {
  回沙之书累计配置: { 物品名: string; 累计阈值: number; 法力恢复倍率: number; 特效路径: string; 特效持续时间: number; 冷却时间: number };
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    HealManaAmount?: number;
    ItemHeal: boolean;
    HealEffect: boolean;
    ManaEffect?: boolean;
    ManaShowText?: boolean;
  }) => number;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const CreateTimer = jass.CreateTimer as () => any;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, target: any, point: string) => any;

const 回沙CD表: Record<number, boolean | undefined> = {};
const 回沙CD计时器表: Record<number, number | undefined> = {};
const 回沙免疫开启计时器表: Record<number, number | undefined> = {};
const 回沙之书ID = stringToFourCCSafe(resolveItemIdByName(回沙之书累计配置.物品名));

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

function 回沙免疫开启(this: void): void {
  const timer = GetExpiredTimer();
  const timerId = GetHandleId(timer);
  const hid = 回沙免疫开启计时器表[timerId];
  delete 回沙免疫开启计时器表[timerId];
  DestroyTimer(timer);
  if (hid == null) return;

  const unit = hid as any;
  // 旧免伤方案先停用，改为直接走无敌帧。
  // YDUserDataSet("unit", unit, "免疫伤害", "boolean", true);
  // const endTimer = CreateTimer();
  // const endTimerId = GetHandleId(endTimer);
  // 回沙免疫结束计时器表[endTimerId] = unit;
  // TimerStart(endTimer, 1.25, false, 回沙免疫结束);
  开始无敌帧(unit, 1.25);
}

export function 处理回沙之书累计(this: void, target: any, _attacker: any, applied: number): void {
  if (target == null || target === 0 || !(applied > 0)) {
    return;
  }
  const item = 获取单位指定装备(target, 回沙之书ID);
  if (item == null) {
    return;
  }

  const 达到阈值 = 单位物品累伤次数(target, 回沙之书累计配置.物品名, applied, 1, 回沙之书累计配置.累计阈值, {
    是否在CD中: 回沙CD表[GetHandleId(target)] === true,
    达到阈值后重置: true,
  });
  const gain = applied * 回沙之书累计配置.法力恢复倍率;
  if (gain > 0) {
    doHeal({
      HealSource: target,
      HealTarget: target,
      HealAmount: 0,
      HealManaAmount: gain,
      ItemHeal: true,
      HealEffect: false,
      ManaEffect: true,
      ManaShowText: true,
    });
  }

  if (达到阈值) {
    const hid = GetHandleId(target);
    if (回沙CD表[hid]) {
      return;
    }
    const eff = AddSpecialEffectTarget(回沙之书累计配置.特效路径, target, "overhead");
    if (eff != null) {
      YDWETimerDestroyEffectSafe(回沙之书累计配置.特效持续时间, eff);
    }
    if (!回沙CD表[hid]) {
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
