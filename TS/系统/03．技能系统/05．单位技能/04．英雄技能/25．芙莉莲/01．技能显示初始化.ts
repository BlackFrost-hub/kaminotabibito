/** @noSelfInFile */

import { 芙莉莲技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { registerPlayerHeroListener } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
};
const { 动态修改单位技能数据 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据") as {
  动态修改单位技能数据: (this: void, unit: any, configs: readonly any[]) => void;
};
const 英雄单位类型ID = jass.FourCC(芙莉莲技能配置.单位类型ID) as number;
const 占位图标 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp";
const 技能显示 = [
  { 技能ID: 芙莉莲技能配置.Q.技能ID, 名称: 芙莉莲技能配置.Q.名称, 图标: 占位图标, 说明: "沿目标方向发射基础贯穿魔法并读取攻击解析。", 快捷键: "Q" },
  { 技能ID: 芙莉莲技能配置.W.技能ID, 名称: 芙莉莲技能配置.W.名称, 图标: 占位图标, 说明: "展开正面魔力护壁并记录防御解析。", 快捷键: "W" },
  { 技能ID: 芙莉莲技能配置.E.技能ID, 名称: 芙莉莲技能配置.E.名称, 图标: 占位图标, 说明: "升空观察目标区域并建立位置解析。", 快捷键: "E" },
  { 技能ID: 芙莉莲技能配置.R.技能ID, 名称: 芙莉莲技能配置.R.名称, 图标: 占位图标, 说明: "蓄力后发射窄幅贯穿魔法炮，按解析快照追加分支。", 快捷键: "R" },
  { 技能ID: 芙莉莲技能配置.D.技能ID, 名称: 芙莉莲技能配置.D.名称, 图标: 占位图标, 说明: "在目标区域创造花田并产生战斗化区域效果。", 快捷键: "D" },
] as const;

function 初始化芙莉莲技能显示(this: void, _player: any, hero: any): void {
  if (hero == null || hero === 0 || jass.GetUnitTypeId(hero) !== 英雄单位类型ID) return;
  动态修改单位技能数据(hero, 技能显示);
}

registerPlayerHeroListener(初始化芙莉莲技能显示);

export {};
