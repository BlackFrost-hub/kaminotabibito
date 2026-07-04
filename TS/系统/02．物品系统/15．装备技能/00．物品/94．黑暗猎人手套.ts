/** @noSelfInFile */

import {
  攻击者类型满足,
  距离满足限制,
  取攻击力,
  攻击效果造成伤害,
} from "../08．攻击效果/00．公共/01．攻击效果工具";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";

const { SFB_setCurse } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setCurse: (this: void, sourceUnit: any, u: any, time: number) => void;
};

const 装备名 = "|cffcc99ff黑暗猎人手套|r";
const 触发概率 = 0.15;
const 冷却秒数 = 8;
const 最大攻击距离 = 200;
const 攻击力系数 = 2;
const 诅咒持续秒 = 1.5;

注册最终伤害触发模板({
  名称: "黑暗猎人手套",
  装备名,
  持有者: "攻击者",
  伤害过滤: "纯普攻",
  概率: 触发概率,
  冷却秒数,
  自定义过滤: function 黑暗猎人手套触发过滤(this: void, event): boolean {
    const snapshot = event.伤害快照;
    if (snapshot == null || snapshot.isTrueDamage === true) return false;
    if (!攻击者类型满足(event.攻击者, "近战")) return false;
    return 距离满足限制(event.攻击者, event.目标, undefined, 最大攻击距离);
  },
  on触发: function on黑暗猎人手套最终伤害(this: void, event): void {
    SFB_setCurse(event.攻击者, event.目标, 诅咒持续秒);
    攻击效果造成伤害(event.攻击者, event.目标, 取攻击力(event.攻击者) * 攻击力系数, "暗影");
  },
});

export {};
