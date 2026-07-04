/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 取范围敌人, 造成装备伤害, 播放点特效, 取单位X, 取单位Y, 取攻击力, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { 创建窗口承伤次数触发器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.10．窗口承伤次数触发") as {
  创建窗口承伤次数触发器: (this: void, 参数: any) => any;
};

function on克林姆德风纹法杖触发(this: void, event: any): void {
  const target = event.单位;
  const attacker = event.攻击者;
  播放点特效(装备小特效.小风爆, 取单位X(target), 取单位Y(target), 0.9);
  const enemies = 取范围敌人(attacker, target, 260);
  for (let i = 0; i < enemies.length; i++) {
    造成装备伤害(attacker, enemies[i], 取攻击力(attacker) * 0.4, 装备伤害类型.风);
  }
}

function 过滤克林姆德风纹法杖伤害(this: void, event: any): boolean {
  return 是技能伤害(event.伤害快照)
    && 单位持有第二章后段Boss战利品(event.攻击者, 第二章后段Boss战利品装备名.克林姆德风纹法杖);
}

创建窗口承伤次数触发器({
  名称: "克林姆德风纹法杖",
  窗口秒: 6,
  次数阈值: 3,
  内置CD秒: 6,
  过滤伤害: 过滤克林姆德风纹法杖伤害,
  on触发: on克林姆德风纹法杖触发,
});

export {};
