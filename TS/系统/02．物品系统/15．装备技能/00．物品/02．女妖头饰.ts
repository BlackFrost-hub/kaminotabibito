/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { 施加暗影突袭减益 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.01．暗影突袭") as {
  施加暗影突袭减益: (this: void, source: any, target: any, 参数?: any) => void;
};
const { 发起治疗波跳链 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.治疗波跳链") as {
  发起治疗波跳链: (this: void, 参数: {
    起始目标: any;
    来源单位?: any;
    最大跳数: number;
    初始治疗量: number;
    影响目标?: "敌方" | "友方" | "全部";
    每跳最大距离?: number;
    每跳衰减系数?: number;
    允许重复治疗?: boolean;
    跳跃间隔?: number;
    治疗特效路径?: string;
    闪电效果代码?: string;
    每跳回调?: (this: void, 单位: any, 治疗量: number, 当前跳数: number) => void;
    结束回调?: (this: void, 已完成的跳数: number) => void;
  }) => any;
};
const { 女妖头饰累计配置 } = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表") as {
  女妖头饰累计配置: { 物品名: string; 累计阈值: number };
};
const { 女妖头饰强化累计配置 } = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表") as {
  女妖头饰强化累计配置: { 物品名: string; 命中次数阈值: number; 触发单位类型: string };
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetItemTypeId = jass.GetItemTypeId as (it: any) => number;
const UnitItemInSlot = jass.UnitItemInSlot as (u: any, slot: number) => any;
const stringToFourCC = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换").stringToFourCC as (s: string) => number;

const 女妖头饰ID = stringToFourCC(resolveItemIdByName(女妖头饰累计配置.物品名) ?? "");
const 女妖头饰累计表: Record<number, number | undefined> = {};
const 女妖头饰强化ID = stringToFourCC(resolveItemIdByName(女妖头饰强化累计配置.物品名) ?? "");
const 女妖头饰强化命中表: Record<number, number | undefined> = {};

function 单位拥有装备(this: void, unit: any, itemTypeId: number): boolean {
  if (unit == null || unit === 0 || itemTypeId <= 0) return false;
  for (let slot = 0; slot < 6; slot++) {
    const item = UnitItemInSlot(unit, slot);
    if (item != null && item !== 0 && GetItemTypeId(item) === itemTypeId) return true;
  }
  return false;
}

export function 处理女妖头饰累计(this: void, target: any, attacker: any, applied: number): void {
  debugLogForce("女妖头饰", "进入处理", "target:", target, "attacker:", attacker, "applied:", applied);
  if (target == null || target === 0 || attacker == null || attacker === 0 || !(applied > 0)) {
    debugLogForce("女妖头饰", "提前返回: 参数无效");
    return;
  }
  const 有女妖头饰 = 单位拥有装备(target, 女妖头饰ID);
  const 有女妖头饰强化 = resolveItemIdByName(女妖头饰强化累计配置.物品名) != null
    ? 单位拥有装备(target, stringToFourCC(resolveItemIdByName(女妖头饰强化累计配置.物品名) ?? ""))
    : false;
  debugLogForce("女妖头饰", "有女妖头饰:", 有女妖头饰, "有强化:", 有女妖头饰强化, "女妖头饰ID:", 女妖头饰ID);
  if (!有女妖头饰 && !有女妖头饰强化) return;

  const hid = GetHandleId(target);
  if (有女妖头饰) {
    女妖头饰累计表[hid] = (女妖头饰累计表[hid] ?? 0) + applied;
    if ((女妖头饰累计表[hid] ?? 0) >= 女妖头饰累计配置.累计阈值) {
      女妖头饰累计表[hid] = 0;
      发起治疗波跳链({
        起始目标: target,
        来源单位: attacker,
        影响目标: "敌方",
        最大跳数: 7,
        初始治疗量: 1,
        每跳最大距离: 600,
        每跳衰减系数: 0,
        允许重复治疗: false,
        跳跃间隔: 0.05,
        每跳回调: function (this: void, 单位: any): void {
          施加暗影突袭减益(attacker, 单位, { duration: 2.0, damagePerSecond: 500 });
        },
      });
    }
  }
  if (有女妖头饰强化) {
    女妖头饰强化命中表[hid] = (女妖头饰强化命中表[hid] ?? 0) + 1;
    if ((女妖头饰强化命中表[hid] ?? 0) >= 女妖头饰强化累计配置.命中次数阈值) {
      女妖头饰强化命中表[hid] = 0;
      发起治疗波跳链({
        起始目标: target,
        来源单位: target,
        影响目标: "敌方",
        最大跳数: 7,
        初始治疗量: 1,
        每跳最大距离: 600,
        每跳衰减系数: 0,
        允许重复治疗: false,
        跳跃间隔: 0.05,
        每跳回调: function (this: void, 单位: any): void {
          施加暗影突袭减益(target, 单位, { duration: 2.0, damagePerSecond: 500 });
        },
      });
    }
  }
}

export {};
