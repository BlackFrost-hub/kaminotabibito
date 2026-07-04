/** @noSelfInFile */

import { 取当前生命, 取最大生命, 恢复生命魔法, 短暂无敌, 播放单位特效, 第二章后段Boss战利品装备名, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 创建伤害修正阈值触发 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/13．伤害修正阈值触发";

function 灵心之碎片致死过滤(this: void, event: any): boolean {
  return 取当前生命(event.单位) - event.当前伤害 <= 1;
}

function on灵心之碎片触发(this: void, event: any): void {
  const target = event.单位;
  短暂无敌(target, 1);
  恢复生命魔法(target, target, 取最大生命(target) * 0.1);
  播放单位特效(装备小特效.护盾闪光, target, "origin", 1);
}

function 计算灵心之碎片保命伤害(this: void, event: any): number {
  const life = 取当前生命(event.单位);
  return life > 1 ? life - 1 : 0;
}

创建伤害修正阈值触发({
  名称: "灵心之碎片",
  装备名: 第二章后段Boss战利品装备名.灵心之碎片,
  冷却秒数: 120,
  冷却前缀: "第二章后段Boss战利品",
  优先级: 5,
  过滤伤害: 灵心之碎片致死过滤,
  on触发: on灵心之碎片触发,
  计算伤害: 计算灵心之碎片保命伤害,
});

export {};
