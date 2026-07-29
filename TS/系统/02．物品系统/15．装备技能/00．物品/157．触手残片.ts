/** @noSelfInFile */

const { 恢复生命魔法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  恢复生命魔法: (this: void, source: any, target: any, hp: number, mp?: number, 默认魔法特效?: boolean) => void;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { onAnyUnitItemStacked } = require("lib.扩展函数.物品相关函数.物品叠加函数") as {
  onAnyUnitItemStacked: (
    this: void,
    callback: (this: void, 单位: any, 合并后物品: any, 被叠加物品: any, 叠加前次数: number, 新增次数: number, 叠加后次数: number) => void
  ) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const SetItemCharges = jass.SetItemCharges as (item: any, charges: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const 触手残片配置 = {
  物品名: "|cFF800000触手残片|r",
  触发最低已有次数: 2,
  每次拾取治疗已损生命比例: 0.2,
  最大次数: 5,
} as const;

const 触手残片物品类型ID = stringToFourCCSafe(按名字反查物品ID(触手残片配置.物品名));

function on触手残片叠加(this: void, 单位: any, 合并后物品: any, 被叠加物品: any, 叠加前次数: number, 新增次数: number, 叠加后次数: number): void {
  if (触手残片物品类型ID === 0) return;
  if (单位 == null || 单位 === 0) return;
  if (合并后物品 == null || 合并后物品 === 0) return;
  if (被叠加物品 == null || 被叠加物品 === 0) return;
  if (GetItemTypeId(合并后物品) !== 触手残片物品类型ID) return;
  if (GetItemTypeId(被叠加物品) !== 触手残片物品类型ID) return;

  if (叠加后次数 > 触手残片配置.最大次数) {
    SetItemCharges(合并后物品, 触手残片配置.最大次数);
  }

  if (新增次数 !== 1) return;
  if (叠加前次数 < 触手残片配置.触发最低已有次数) return;

  const 已损生命 = GetUnitStateJapi(单位, UNIT_STATE_MAX_LIFE) - GetUnitState(单位, UNIT_STATE_LIFE);
  if (已损生命 <= 0) return;

  恢复生命魔法(单位, 单位, 已损生命 * 触手残片配置.每次拾取治疗已损生命比例);
}

function 初始化触手残片(this: void): void {
  if (触手残片物品类型ID === 0) return;
  onAnyUnitItemStacked(on触手残片叠加);
}

初始化触手残片();

export {};
