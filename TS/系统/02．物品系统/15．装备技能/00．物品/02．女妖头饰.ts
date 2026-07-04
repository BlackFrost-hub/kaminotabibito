/** @noSelfInFile */
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
const { 创建暗影突袭追踪 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.01．暗影突袭") as {
  创建暗影突袭追踪: (this: void, source: any, target: any, 参数?: any) => void;
};
const { 延后一帧执行伤害派生效果 } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  延后一帧执行伤害派生效果: (this: void, callback: () => void) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    HealManaAmount?: number;
    ItemHeal: boolean;
    HealEffect: boolean;
    HealEffectPath?: string;
    ManaEffect?: boolean;
    ManaEffectPath?: string;
    ManaShowText?: boolean;
  }) => number;
};
const { 女妖头饰累计配置 } = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表") as {
  女妖头饰累计配置: { 物品名: string; 累计阈值: number };
};
const { 女妖头饰强化累计配置 } = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表") as {
  女妖头饰强化累计配置: { 物品名: string; 命中次数阈值: number; 触发单位类型: string };
};

const jass = require("jass.common") as any;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (u: any, state: any, value: number) => void;
const GetItemCharges = jass.GetItemCharges as (it: any) => number;
const SetItemCharges = jass.SetItemCharges as (it: any, charges: number) => void;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const 女妖头饰ID = stringToFourCCSafe(resolveItemIdByName(女妖头饰累计配置.物品名));
const 女妖头饰强化ID = stringToFourCCSafe(resolveItemIdByName(女妖头饰强化累计配置.物品名));

export function 处理女妖头饰累计(this: void, target: any, attacker: any, applied: number): void {
  if (target == null || target === 0 || attacker == null || attacker === 0 || !(applied > 0)) {
    return;
  }
  const 女妖头饰物品 = 获取单位指定装备(target, 女妖头饰ID);
  const 女妖头饰强化物品 = resolveItemIdByName(女妖头饰强化累计配置.物品名) != null
    ? 获取单位指定装备(target, 女妖头饰强化ID)
    : null;
  const 有女妖头饰 = 女妖头饰物品 != null;
  const 有女妖头饰强化 = 女妖头饰强化物品 != null;
  if (!有女妖头饰 && !有女妖头饰强化) return;

  if (有女妖头饰 || 有女妖头饰强化) {
    const 到达阈值 = 单位物品累伤次数(target, 女妖头饰累计配置.物品名, applied, 1, 女妖头饰累计配置.累计阈值, {
      是否在CD中: false,
      达到阈值后重置: true,
    });
    if (到达阈值) {
      延后一帧执行伤害派生效果(() => {
        创建暗影突袭追踪(target, attacker, {
          减益: { duration: 2.0, damagePerSecond: 500 },
        });
      });
      if (有女妖头饰强化 && 女妖头饰强化物品 != null) {
        const 当前次数 = GetItemCharges(女妖头饰强化物品);
        const 下次次数 = 当前次数 + 1;
        const 达到次数阈值 = 下次次数 >= 女妖头饰强化累计配置.命中次数阈值;
        const 写回次数 = 达到次数阈值 ? 1 : 下次次数;
        SetItemCharges(女妖头饰强化物品, 写回次数);
        if (达到次数阈值) {
          doHeal({
            HealSource: target,
            HealTarget: target,
            HealAmount: 1000,
            HealManaAmount: 1000,
            ItemHeal: true,
            HealEffect: true,
            ManaEffect: true,
          });
        }
      }
    }
  }
}

export {};
