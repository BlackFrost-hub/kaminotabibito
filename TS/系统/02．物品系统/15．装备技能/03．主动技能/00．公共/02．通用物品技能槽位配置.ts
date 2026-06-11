/** @noSelfInFile */

import { 主动技能装备名称 } from "./00．主动技能装备名";

export type 通用物品技能目标类型 = "无目标" | "单位目标" | "点目标";

export interface 通用物品技能槽位配置项 {
  装备名称: string;
  物编ID: string;
  技能ID: string;
  目标类型: 通用物品技能目标类型;
  命令ID: string;
  冷却间隔组: string;
  冷却时间: number;
  魔法消耗: number;
  施法距离: 0 | 500 | 600 | 700 | 800 | 900 | 1000;
  说明: string;
}

export const 通用物品技能槽位配置表: 通用物品技能槽位配置项[] = [
  {
    装备名称: 主动技能装备名称.瑟兰迪尔的决心,
    物编ID: "I0E4",
    技能ID: "IN00",
    目标类型: "无目标",
    命令ID: "thunderclap",
    冷却间隔组: "IN00",
    冷却时间: 120,
    魔法消耗: 0,
    施法距离: 0,
    说明: "使用：召唤瑟兰迪尔幻影协助战斗30秒，仅精灵城内可用。",
  },
];

export {};
