/** @noSelfInFile */

import {
  单位有效存活,
  攻击者类型满足,
  距离满足限制,
  取攻击力,
  攻击效果造成伤害,
  获取敌方范围单位,
} from "../08．攻击效果/00．公共/01．攻击效果工具";
import { 读取玩家暴击伤害, 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";

const 装备名 = "狂暴熔刃";
const 触发概率 = 0.1;
const 冷却秒数 = 2;
const 最大攻击距离 = 200;
const 攻速增加 = 300;
const 持续毫秒 = 2000;
const 范围 = 500;
const 攻击力倍率 = 2;

function 计算暴击伤害(this: void, attacker: any): number {
  return 取攻击力(attacker) * 攻击力倍率 * (1 + 读取玩家暴击伤害(attacker));
}

function 施加狂暴熔刃攻速(this: void, attacker: any): void {
  施加临时属性效果(attacker, 持续毫秒, [{ 类型: "攻速", 数值: 攻速增加 }]);
}

注册最终伤害触发模板({
  名称: "狂暴熔刃",
  装备名,
  持有者: "攻击者",
  伤害过滤: "纯普攻",
  概率: 触发概率,
  冷却秒数,
  自定义过滤: function 狂暴熔刃触发过滤(this: void, event): boolean {
    const snapshot = event.伤害快照;
    if (snapshot == null || snapshot.isTrueDamage === true) return false;
    if (!攻击者类型满足(event.攻击者, "近战")) return false;
    return 距离满足限制(event.攻击者, event.目标, undefined, 最大攻击距离);
  },
  on触发: function on狂暴熔刃最终伤害(this: void, event): void {
    施加狂暴熔刃攻速(event.攻击者);
    const damage = 计算暴击伤害(event.攻击者);
    const enemies = 获取敌方范围单位(event.攻击者, event.目标, 范围, true);
    for (let i = 0; i < enemies.length; i++) {
      攻击效果造成伤害(event.攻击者, enemies[i], damage, "物理", { 伤害形态: "AOE" });
    }
  },
});

export {};
