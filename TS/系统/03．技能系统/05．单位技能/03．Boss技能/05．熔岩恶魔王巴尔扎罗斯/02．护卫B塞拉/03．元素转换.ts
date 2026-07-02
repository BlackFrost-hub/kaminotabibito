/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 塞拉公共 } from "./00．公共";
const {  巴尔扎罗斯单位技能配置,
  巴尔扎罗斯技能数值配置,
  播放巴尔扎罗斯台词,
  registerManualBuff,
  移除单位指定Buff,
  registerDamageModifier,
  getServerTime,
  SetUnitAnimationByIndex,
  SetUnitTimeScale,
  单位有效,
  取单位ID,
  塞拉形态表,
  零度领域减伤到期Ms表,
} = 塞拉公共;

let 塞拉伤害修正已注册 = false;

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
  SetUnitTimeScale(sera, config.动画速度);
  SetUnitAnimationByIndex(sera, config.动画编号);
  if (播放台词) 播放巴尔扎罗斯台词(context.Boss单位, "元素转换");
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

