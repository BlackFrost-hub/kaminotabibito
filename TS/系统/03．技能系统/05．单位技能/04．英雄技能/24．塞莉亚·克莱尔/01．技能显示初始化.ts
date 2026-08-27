/** @noSelfInFile */

import { 塞莉亚克莱尔技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { registerPlayerHeroListener } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
};
const { 动态修改单位技能数据 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据") as {
  动态修改单位技能数据: (this: void, unit: any, configs: readonly any[]) => void;
};
const 英雄单位类型ID = jass.FourCC(塞莉亚克莱尔技能配置.单位类型ID) as number;
const 占位图标 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp";
const 技能显示 = [
  { 技能ID: 塞莉亚克莱尔技能配置.Q.技能ID, 名称: 塞莉亚克莱尔技能配置.Q.名称, 图标: 占位图标, 说明: "发射棱晶魔弹并建立可连接的演算节点。", 快捷键: "Q" },
  { 技能ID: 塞莉亚克莱尔技能配置.W.技能ID, 名称: 塞莉亚克莱尔技能配置.W.名称, 图标: 占位图标, 说明: "展开解析结界，吸收伤害并建立保护节点。", 快捷键: "W" },
  { 技能ID: 塞莉亚克莱尔技能配置.E.技能ID, 名称: 塞莉亚克莱尔技能配置.E.名称, 图标: 占位图标, 说明: "在目标点建立锚定术式与控制节点。", 快捷键: "E" },
  { 技能ID: 塞莉亚克莱尔技能配置.R.技能ID, 名称: 塞莉亚克莱尔技能配置.R.名称, 图标: 占位图标, 说明: "蓄力锁定节点和连接快照，展开高阶闭锁术式。", 快捷键: "R" },
  { 技能ID: 塞莉亚克莱尔技能配置.D.技能ID, 名称: 塞莉亚克莱尔技能配置.D.名称, 图标: 占位图标, 说明: "选择并移动一个演算节点，重排公式连接。", 快捷键: "D" },
] as const;

function 初始化塞莉亚克莱尔技能显示(this: void, _player: any, hero: any): void {
  if (hero == null || hero === 0 || jass.GetUnitTypeId(hero) !== 英雄单位类型ID) return;
  动态修改单位技能数据(hero, 技能显示);
}

registerPlayerHeroListener(初始化塞莉亚克莱尔技能显示);

export {};
