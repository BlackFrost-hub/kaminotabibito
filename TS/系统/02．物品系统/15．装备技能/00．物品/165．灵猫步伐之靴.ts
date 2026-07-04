/** @noSelfInFile */

import { 单位有效存活, 播放单位特效 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const { 注册最终伤害触发模板 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.11．最终伤害触发模板") as {
  注册最终伤害触发模板: (this: void, 配置: any) => any;
};
const { 施加移速提升Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.04．移速提升") as {
  施加移速提升Buff: (this: void, 来源单位: any, 目标单位: any, 参数: any) => boolean;
};

const 灵猫跃步冷却秒数 = 10;
const 灵猫跃步移速比例 = 0.3;
const 灵猫跃步持续秒数 = 2;
const 灵猫跃步特效 = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl";

function on灵猫步伐之靴最终伤害(this: void, event: any): void {
  const target = event.目标;
  if (!单位有效存活(target)) return;
  施加移速提升Buff(target, target, {
    BuffID: 常规BuffID.灵猫步伐之靴_灵猫跃步,
    持续时间: 灵猫跃步持续秒数,
    基础移速百分比: 灵猫跃步移速比例,
    图标路径: "Equipment\\Icon\\Shoes\\spirit_cat_steps_boots.blp",
  });
  播放单位特效(target, 灵猫跃步特效, "origin", 1);
}

注册最终伤害触发模板({
  名称: "灵猫步伐之靴",
  装备名: "灵猫步伐之靴",
  持有者: "受击者",
  要求双方存活: false,
  冷却秒数: 灵猫跃步冷却秒数,
  冷却标签: "灵猫步伐之靴:灵猫跃步",
  冷却前缀: "米亚战利品",
  on触发: on灵猫步伐之靴最终伤害,
});

export {};
