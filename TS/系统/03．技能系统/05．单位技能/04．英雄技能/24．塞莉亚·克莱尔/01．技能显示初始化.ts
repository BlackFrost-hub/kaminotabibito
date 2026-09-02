/** @noSelfInFile */

import { 塞莉亚克莱尔技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { registerPlayerHeroListener } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
};
const { 动态修改单位技能数据 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据") as {
  动态修改单位技能数据: (this: void, unit: any, configs: readonly any[]) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const 英雄单位类型ID = stringToFourCCSafe(塞莉亚克莱尔技能配置.单位类型ID) as number;
const 技能显示 = [
  { 技能ID: 塞莉亚克莱尔技能配置.Q.技能ID, 名称: 塞莉亚克莱尔技能配置.Q.名称, 图标: 塞莉亚克莱尔技能配置.Q.图标, 说明: 塞莉亚克莱尔技能配置.Q.说明, 快捷键: "Q" },
  { 技能ID: 塞莉亚克莱尔技能配置.W.技能ID, 名称: 塞莉亚克莱尔技能配置.W.名称, 图标: 塞莉亚克莱尔技能配置.W.图标, 说明: 塞莉亚克莱尔技能配置.W.说明, 快捷键: "W" },
  { 技能ID: 塞莉亚克莱尔技能配置.E.技能ID, 名称: 塞莉亚克莱尔技能配置.E.名称, 图标: 塞莉亚克莱尔技能配置.E.图标, 说明: 塞莉亚克莱尔技能配置.E.说明, 快捷键: "E" },
  { 技能ID: 塞莉亚克莱尔技能配置.R.技能ID, 名称: 塞莉亚克莱尔技能配置.R.名称, 图标: 塞莉亚克莱尔技能配置.R.图标, 说明: 塞莉亚克莱尔技能配置.R.说明, 快捷键: "R" },
  { 技能ID: 塞莉亚克莱尔技能配置.D.技能ID, 名称: 塞莉亚克莱尔技能配置.D.名称, 图标: 塞莉亚克莱尔技能配置.D.图标, 说明: 塞莉亚克莱尔技能配置.D.说明, 快捷键: "D" },
] as const;

function 初始化塞莉亚克莱尔技能显示(this: void, _player: any, hero: any): void {
  if (hero == null || hero === 0 || jass.GetUnitTypeId(hero) !== 英雄单位类型ID) return;
  动态修改单位技能数据(hero, 技能显示);
}

registerPlayerHeroListener(初始化塞莉亚克莱尔技能显示);

export {};
