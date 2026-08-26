/** @noSelfInFile */

import { 爱蜜莉雅技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { registerPlayerHeroListener } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
};
const { 动态修改单位技能数据 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据") as {
  动态修改单位技能数据: (this: void, unit: any, configs: readonly any[]) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const 英雄单位类型ID = jass.FourCC("E00C") as number;

const 显示配置 = [
  { 技能ID: 爱蜜莉雅技能配置.Q.技能ID, 名称: 爱蜜莉雅技能配置.Q.名称, 图标: 爱蜜莉雅技能配置.Q.图标, 说明: "发射冰之矢；可与场上的冰晶节点产生联动。", 快捷键: "Q" },
  { 技能ID: 爱蜜莉雅技能配置.W.技能ID, 名称: 爱蜜莉雅技能配置.W.名称, 图标: 爱蜜莉雅技能配置.W.图标, 说明: "在目标地点展开冰花与寒气区域，并保留后续冰片选择。", 快捷键: "W" },
  { 技能ID: 爱蜜莉雅技能配置.E.技能ID, 名称: 爱蜜莉雅技能配置.E.名称, 图标: 爱蜜莉雅技能配置.E.图标, 说明: "获得冰晶护身并向目标方向调整位置，结束时处理冰爆。", 快捷键: "E" },
  { 技能ID: 爱蜜莉雅技能配置.R.技能ID, 名称: 爱蜜莉雅技能配置.R.名称, 图标: 爱蜜莉雅技能配置.R.图标, 说明: "展开永冻之庭，读取冰晶并进行冻结结算。", 快捷键: "R" },
  { 技能ID: 爱蜜莉雅技能配置.D.技能ID, 名称: 爱蜜莉雅技能配置.D.名称, 图标: 爱蜜莉雅技能配置.D.图标, 说明: "召唤帕克协战，获得有限次数的技能强化机会。", 快捷键: "D" },
] as const;

function 初始化爱蜜莉雅技能显示(this: void, _player: any, hero: any): void {
  if (hero == null || hero === 0) return;
  if (GetUnitTypeId(hero) !== 英雄单位类型ID) return;
  动态修改单位技能数据(hero, 显示配置);
}

registerPlayerHeroListener(初始化爱蜜莉雅技能显示);

export {};
