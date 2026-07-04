/** @noSelfInFile */

import { 取装备冷却键, 装备冷却中, 进入装备冷却, 延迟执行单位动作 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

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
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, target: any, point: string) => any;

const 回沙之书ID = stringToFourCCSafe(resolveItemIdByName(回沙之书累计配置.物品名));

function 执行回沙之书无敌帧(this: void, target: any): void {
  开始无敌帧(target, 1.25);
}

export function 处理回沙之书累计(this: void, target: any, _attacker: any, applied: number): void {
  if (target == null || target === 0 || !(applied > 0)) {
    return;
  }
  const item = 获取单位指定装备(target, 回沙之书ID);
  if (item == null) {
    return;
  }

  const 冷却键 = 取装备冷却键(target, "回沙之书", "累计伤害装备");
  const 达到阈值 = 单位物品累伤次数(target, 回沙之书累计配置.物品名, applied, 1, 回沙之书累计配置.累计阈值, {
    是否在CD中: 装备冷却中(冷却键),
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
    if (装备冷却中(冷却键)) {
      return;
    }
    const eff = AddSpecialEffectTarget(回沙之书累计配置.特效路径, target, "overhead");
    if (eff != null) {
      YDWETimerDestroyEffectSafe(回沙之书累计配置.特效持续时间, eff);
    }
    进入装备冷却(冷却键, 回沙之书累计配置.冷却时间);
    延迟执行单位动作(target, 500, 执行回沙之书无敌帧);
  }
}

export {};
