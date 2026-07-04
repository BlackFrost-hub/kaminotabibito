/** @noSelfInFile */

import { 单位有效存活, 取最大生命, 执行物品治疗 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { 注册最终伤害触发模板 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.03．最终伤害触发模板") as {
  注册最终伤害触发模板: (this: void, 配置: any) => any;
};

const 净水回响冷却秒数 = 18;
const 净水回响恢复比例 = 0.05;
const 净水回响特效 = "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl";

function on纯净水源吊坠最终伤害(this: void, event: any): void {
  if (!单位有效存活(event.目标)) return;
  执行物品治疗(event.目标, event.目标, 取最大生命(event.目标) * 净水回响恢复比例, 净水回响特效, 0, undefined, true);
}

注册最终伤害触发模板({
  名称: "纯净水源吊坠",
  装备名: "纯净水源吊坠",
  持有者: "受击者",
  要求双方存活: false,
  冷却秒数: 净水回响冷却秒数,
  冷却标签: "纯净水源吊坠:净水回响",
  冷却前缀: "米亚战利品",
  on触发: on纯净水源吊坠最终伤害,
});

export {};
