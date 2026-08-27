/** @noSelfInFile */

import { 朱雀院红叶技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { registerPlayerHeroListener } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
};
const { 动态修改单位技能数据 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据") as {
  动态修改单位技能数据: (this: void, unit: any, configs: readonly any[]) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const 英雄单位类型ID = jass.FourCC(朱雀院红叶技能配置.单位类型ID) as number;

const 技能显示 = [
  { 技能ID: 朱雀院红叶技能配置.Q.技能ID, 名称: 朱雀院红叶技能配置.Q.名称, 图标: 朱雀院红叶技能配置.Q.图标, 说明: "突进斩击命中施加破绽并开启回身斩窗口；刀势/剑痕/秘传强化联动。", 快捷键: "Q" },
  { 技能ID: 朱雀院红叶技能配置.W.技能ID, 名称: 朱雀院红叶技能配置.W.名称, 图标: 朱雀院红叶技能配置.W.图标, 说明: "展开正面招架窗口：成功化解攻击并反击来源并获得刀势，失败释放基础前斩。", 快捷键: "W" },
  { 技能ID: 朱雀院红叶技能配置.E.技能ID, 名称: 朱雀院红叶技能配置.E.名称, 图标: 朱雀院红叶技能配置.E.图标, 说明: "朝目标方向连续施展三段斩击并留下剑痕；强化可额外留下第二条剑痕。", 快捷键: "E" },
  { 技能ID: 朱雀院红叶技能配置.R.技能ID, 名称: 朱雀院红叶技能配置.R.名称, 图标: 朱雀院红叶技能配置.R.图标, 说明: "蓄势后沿窄直线释放终式；消费刀势与剑痕追加回响，秘传强化提高主斩。", 快捷键: "R" },
  { 技能ID: 朱雀院红叶技能配置.D.技能ID, 名称: 朱雀院红叶技能配置.D.名称, 图标: 朱雀院红叶技能配置.D.图标, 说明: "进入秘传状态获得三次强化机会；破绽斩可少量延长持续时间。", 快捷键: "D" },
] as const;

function 初始化朱雀院红叶技能显示(this: void, _player: any, hero: any): void {
  if (hero == null || hero === 0) return;
  if (GetUnitTypeId(hero) !== 英雄单位类型ID) return;
  动态修改单位技能数据(hero, 技能显示);
}

registerPlayerHeroListener(初始化朱雀院红叶技能显示);

export {};
