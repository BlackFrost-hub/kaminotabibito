/** @noSelfInFile */

const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 注册数值Buff范围光环 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.02．数值Buff范围光环") as {
  注册数值Buff范围光环: (this: void, params: {
    状态ID: string;
    物品类型ID: number;
    间隔毫秒: number;
    半径: number;
    目标类型: "友军含自己" | "友军不含自己" | "敌人";
    排除无敌?: boolean;
    数值效果列表: any[];
    Buff?: any;
  }) => void;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 常规BuffID } = require("系统.05．Buff系统.03．Buff表.00．Buff登记") as {
  常规BuffID: { 精灵执法披风_秩序领域: string };
};
const jass = require("jass.common") as any;
const GetUnitName = jass.GetUnitName as (unit: any) => string;

const 精灵执法披风配置 = {
  物品名: "精灵执法披风",
  范围: 300,
  周期毫秒: 500,
  攻速降低: -0.15,
  攻速属性ID: 10,
  BuffID: 常规BuffID.精灵执法披风_秩序领域,
  Buff持续时间: 1,
} as const;

const 精灵执法披风物品ID = stringToFourCCSafe(resolveItemIdByName(精灵执法披风配置.物品名));

let 已初始化精灵执法披风 = false;

function 计算精灵执法披风攻速(this: void, _target: any, 层数: number): number {
  return 精灵执法披风配置.攻速降低 * 层数;
}

function 应用精灵执法披风攻速差值(this: void, target: any, delta: number): void {
  SGSS_SetState(target, 精灵执法披风配置.攻速属性ID, delta);
}

function 取精灵执法披风Buff附加(this: void, _target: any, _层数: number, holder: any): any {
  const sourceName = holder == null || holder === 0
    ? "精灵执法披风"
    : "『精灵执法披风』「" + GetUnitName(holder) + "」";
  return { sourceName };
}

export function 初始化精灵执法披风效果(this: void): void {
  if (已初始化精灵执法披风) return;
  已初始化精灵执法披风 = true;
  if (精灵执法披风物品ID === 0) return;
  注册数值Buff范围光环({
    状态ID: "精灵执法披风影响",
    物品类型ID: 精灵执法披风物品ID,
    间隔毫秒: 精灵执法披风配置.周期毫秒,
    半径: 精灵执法披风配置.范围,
    目标类型: "敌人",
    数值效果列表: [
      { key: "攻速", 计算总值: 计算精灵执法披风攻速, 应用差值: 应用精灵执法披风攻速差值 },
    ],
    Buff: {
      BuffID: 精灵执法披风配置.BuffID,
      持续秒: 精灵执法披风配置.Buff持续时间,
      取显示值: function 取精灵执法披风Buff显示值(this: void): number {
        return 15;
      },
      取附加参数: 取精灵执法披风Buff附加,
    },
  });
}

初始化精灵执法披风效果();

export {};
