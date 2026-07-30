/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 塞拉公共 } from "./00．公共";
import { 巴尔扎罗斯音效配置 } from "../02．数值与表现配置";
import { 播放Boss坐标音效 } from "../../../00．公共/00．Boss音效播放";
import { 播放限时单位动画 } from "../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待";
const {  巴尔扎罗斯单位技能配置,
  巴尔扎罗斯技能数值配置,
  播放塞拉台词,
  registerManualBuff,
  移除单位指定Buff,
  registerDamageModifier,
  getServerTime,
  GetUnitX,
  GetUnitY,
  单位有效,
  取单位ID,
  塞拉形态表,
  零度领域减伤到期Ms表,
} = 塞拉公共;

const japi = require("jass.japi") as any;
const DzSetUnitMissileModel = japi.DzSetUnitMissileModel as ((unit: any, model: string) => void) | undefined;
const DzSetUnitMissileArc = japi.DzSetUnitMissileArc as ((unit: any, arc: number) => void) | undefined;
const DzSetUnitMissileSpeed = japi.DzSetUnitMissileSpeed as ((unit: any, speed: number) => void) | undefined;

let 塞拉伤害修正已注册 = false;
const 塞拉形态弹道模型JAPI临时禁用 = false;
const 塞拉形态弹道弧度JAPI临时禁用 = false;
const 塞拉形态弹道速度JAPI临时禁用 = false;

function 应用塞拉形态弹道(this: void, sera: any, next: "火焰" | "冰霜"): void {
  const config = 巴尔扎罗斯单位技能配置.护卫.塞拉;
  const model = next === "火焰" ? config.火焰普攻弹道模型 : config.默认普攻弹道模型;
  if (!塞拉形态弹道模型JAPI临时禁用 && DzSetUnitMissileModel != null) DzSetUnitMissileModel(sera, model);
  if (!塞拉形态弹道弧度JAPI临时禁用 && DzSetUnitMissileArc != null) DzSetUnitMissileArc(sera, config.普攻弹道弧度);
  if (!塞拉形态弹道速度JAPI临时禁用 && DzSetUnitMissileSpeed != null) DzSetUnitMissileSpeed(sera, config.普攻弹道速度);
}

export function 切换塞拉形态(this: void, context: 巴尔扎罗斯运行时上下文, next: "火焰" | "冰霜", 播放台词: boolean): void {
  const sera = context.塞拉;
  if (!单位有效(sera)) return;
  const config = 巴尔扎罗斯技能数值配置.元素转换;
  const seraId = 取单位ID(sera);
  context.塞拉当前形态 = next;
  塞拉形态表[seraId] = next;
  移除单位指定Buff(sera, next === "火焰" ? 巴尔扎罗斯单位技能配置.BuffID.塞拉冰霜形态 : 巴尔扎罗斯单位技能配置.BuffID.塞拉火焰形态);
  registerManualBuff(
    sera,
    next === "火焰" ? 巴尔扎罗斯单位技能配置.BuffID.塞拉火焰形态 : 巴尔扎罗斯单位技能配置.BuffID.塞拉冰霜形态,
    config.周期秒 + config.Buff持续补偿秒,
    1,
    { sourceName: 巴尔扎罗斯单位技能配置.护卫.塞拉.名称 },
  );
  应用塞拉形态弹道(sera, next);
  播放限时单位动画({
    单位: sera,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    持续秒: config.动画播放秒,
    恢复动画编号: config.恢复动画编号,
  });
  播放Boss坐标音效(next === "火焰" ? 巴尔扎罗斯音效配置.塞拉.冰转火 : 巴尔扎罗斯音效配置.塞拉.火转冰, GetUnitX(sera), GetUnitY(sera), 巴尔扎罗斯音效配置.默认裁断距离);
  if (播放台词) 播放塞拉台词(sera, next === "火焰" ? "元素转换火焰" : "元素转换冰霜");
}

function 塞拉伤害修正(this: void, context: any): number {
  const now = getServerTime();
  const attackerId = 取单位ID(context.attacker);
  if (attackerId !== 0) {
    const until = 零度领域减伤到期Ms表[attackerId] ?? 0;
    if (until > 0 && now <= until) {
      return context.currentDamage * (1 - 巴尔扎罗斯技能数值配置.绝对零度领域.造成伤害降低比例);
    }
    if (until > 0 && now > until) delete 零度领域减伤到期Ms表[attackerId];
  }

  const targetId = 取单位ID(context.target);
  const form = targetId !== 0 ? 塞拉形态表[targetId] : undefined;
  if (form === "火焰" && context.isWaterDamage === true) {
    return context.currentDamage * (1 + 巴尔扎罗斯技能数值配置.元素转换.受到克制伤害提高);
  }
  if (form === "冰霜" && context.isFireDamage === true) {
    return context.currentDamage * (1 + 巴尔扎罗斯技能数值配置.元素转换.受到克制伤害提高);
  }
  return context.currentDamage;
}

export function 确保塞拉伤害修正(this: void): void {
  if (塞拉伤害修正已注册) return;
  塞拉伤害修正已注册 = true;
  registerDamageModifier(塞拉伤害修正, 65);
}
