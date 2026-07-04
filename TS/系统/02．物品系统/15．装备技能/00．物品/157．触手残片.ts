/** @noSelfInFile */

const { onTryPickupItem } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.18．尝试拾取物品中心") as {
  onTryPickupItem: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { 恢复生命魔法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  恢复生命魔法: (this: void, source: any, target: any, hp: number, mp?: number, 默认魔法特效?: boolean) => void;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};

const jass = require("jass.common") as any;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetItemCharges = jass.GetItemCharges as (item: any) => number;
const SetItemCharges = jass.SetItemCharges as (item: any, charges: number) => void;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const 触手残片配置 = {
  物品名: "|cFF800000触手残片|r",
  触发最低已有次数: 2,
  每次拾取治疗已损生命比例: 0.2,
  最大次数: 5,
} as const;

type 待处理触手残片拾取 = {
  单位: any;
  拾取前已有次数: number;
  拾取次数: number;
};

const 触手残片物品类型ID = stringToFourCCSafe(按名字反查物品ID(触手残片配置.物品名));
const 待处理触手残片拾取列表: 待处理触手残片拾取[] = [];
let 已安排触手残片拾取处理 = false;

function 查找单位触手残片(this: void, 单位: any): any {
  if (单位 == null || 单位 === 0 || 触手残片物品类型ID === 0) return null;
  for (let 槽位 = 0; 槽位 < 6; 槽位++) {
    const 物品 = UnitItemInSlot(单位, 槽位);
    if (物品 != null && 物品 !== 0 && GetItemTypeId(物品) === 触手残片物品类型ID) {
      return 物品;
    }
  }
  return null;
}

function 处理单个触手残片拾取(this: void, 单位: any, 拾取前已有次数: number, 拾取次数: number): void {
  const 触手残片 = 查找单位触手残片(单位);
  if (触手残片 == null || 触手残片 === 0) return;

  const 当前次数 = GetItemCharges(触手残片);
  const 已实际拾取到残片 = 当前次数 > 拾取前已有次数;
  if (当前次数 > 触手残片配置.最大次数) {
    SetItemCharges(触手残片, 触手残片配置.最大次数);
  }

  if (!已实际拾取到残片) return;
  if (拾取次数 !== 1) return;
  if (拾取前已有次数 < 触手残片配置.触发最低已有次数) return;

  const 已损生命 = GetUnitState(单位, UNIT_STATE_MAX_LIFE) - GetUnitState(单位, UNIT_STATE_LIFE);
  if (已损生命 <= 0) return;

  恢复生命魔法(单位, 单位, 已损生命 * 触手残片配置.每次拾取治疗已损生命比例);
}

function 处理待处理触手残片拾取(this: void): void {
  已安排触手残片拾取处理 = false;
  while (待处理触手残片拾取列表.length > 0) {
    const 上下文 = 待处理触手残片拾取列表.shift();
    if (上下文 == null) continue;
    处理单个触手残片拾取(上下文.单位, 上下文.拾取前已有次数, 上下文.拾取次数);
  }
}

function on触手残片尝试拾取(this: void, 单位: any, 物品: any): void {
  if (触手残片物品类型ID === 0) return;
  if (物品 == null || 物品 === 0) return;
  if (GetItemTypeId(物品) !== 触手残片物品类型ID) return;

  const 已持有触手残片 = 查找单位触手残片(单位);
  const 拾取前已有次数 = 已持有触手残片 != null && 已持有触手残片 !== 0 ? GetItemCharges(已持有触手残片) : 0;

  待处理触手残片拾取列表.push({
    单位,
    拾取前已有次数,
    拾取次数: GetItemCharges(物品),
  });
  if (已安排触手残片拾取处理) return;
  已安排触手残片拾取处理 = true;
  addDelayedCallback(10, 处理待处理触手残片拾取);
}

function 初始化触手残片(this: void): void {
  if (触手残片物品类型ID === 0) return;
  onTryPickupItem(on触手残片尝试拾取);
}

初始化触手残片();

export {};
