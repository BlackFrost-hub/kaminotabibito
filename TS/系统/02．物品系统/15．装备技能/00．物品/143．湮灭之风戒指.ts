/** @noSelfInFile */

import { 造成装备伤害, 播放点特效, 取单位X, 取单位Y, 取攻击力, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";

const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, 来源单位: any, 目标单位: any, 类型: string, 参数: {
    持续时间: number;
    效果来源名称?: string;
    效果来源类型?: "装备" | "技能";
  }) => number;
};

function on湮灭之风戒指触发(this: void, event: any): void {
  const target = event.目标;
  const attacker = event.攻击者;
  播放点特效(装备小特效.小风爆, 取单位X(target), 取单位Y(target), 0.8);
  造成装备伤害(attacker, target, 取攻击力(attacker) * 0.3, 装备伤害类型.风, false, undefined, { 伤害形态: "单体" });
  施加扩展控制(attacker, target, "silence", { 持续时间: 1.5, 效果来源名称: "湮灭之风戒指", 效果来源类型: "装备" });
}

注册最终伤害触发模板({
  名称: "湮灭之风戒指",
  装备名: 第二章后段Boss战利品装备名.湮灭之风戒指,
  伤害过滤: "技能",
  冷却秒数: 11,
  冷却前缀: "第二章后段Boss战利品",
  要求双方存活: false,
  on触发: on湮灭之风戒指触发,
});

export {};
