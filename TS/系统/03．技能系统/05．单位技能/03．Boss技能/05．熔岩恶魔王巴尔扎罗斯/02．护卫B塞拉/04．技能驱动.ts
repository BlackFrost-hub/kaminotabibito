/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 释放冰焰双星 } from "./01．冰焰双星";
import { 释放绝对零度领域 } from "./02．绝对零度领域";
import { 切换塞拉形态, 确保塞拉伤害修正 } from "./03．元素转换";
import { 塞拉公共 } from "./00．公共";
const {  巴尔扎罗斯技能数值配置,
  addPeriodicCallback,
  getServerTime,
  GetUnitX,
  GetUnitY,
  单位有效,
  取单位ID,
  点距离平方,
  取塞拉形态,
  取塞拉技能目标,
  塞拉冰焰双星下次Ms表,
  塞拉绝对零度下次Ms表,
  塞拉元素转换下次Ms表,
  塞拉忙碌到Ms表,
  塞拉形态表,
  绝对零度领域状态表,
} = 塞拉公共;

function 尝试释放塞拉技能(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const sera = context.塞拉;
  if (!单位有效(context.Boss单位) || !单位有效(sera)) return;
  const id = 取单位ID(sera);
  const now = getServerTime();
  if (now < (塞拉忙碌到Ms表[id] ?? 0)) return;
  if (now >= (塞拉元素转换下次Ms表[id] ?? 0)) {
    const next = 取塞拉形态(context) === "火焰" ? "冰霜" : "火焰";
    塞拉元素转换下次Ms表[id] = now + 巴尔扎罗斯技能数值配置.元素转换.周期秒 * 1000;
    切换塞拉形态(context, next, true);
    return;
  }

  const target = 取塞拉技能目标(context);
  if (!单位有效(target)) return;
  const iceFire = 巴尔扎罗斯技能数值配置.冰焰双星;
  const zero = 巴尔扎罗斯技能数值配置.绝对零度领域;
  const distanceSq = 点距离平方(GetUnitX(sera), GetUnitY(sera), GetUnitX(target), GetUnitY(target));
  if (now >= (塞拉冰焰双星下次Ms表[id] ?? 0) && distanceSq <= iceFire.施法距离 * iceFire.施法距离) {
    塞拉冰焰双星下次Ms表[id] = now + iceFire.冷却秒 * 1000;
    塞拉忙碌到Ms表[id] = now + iceFire.施法硬直秒 * 1000;
    释放冰焰双星(context, target);
    return;
  }
  if (now >= (塞拉绝对零度下次Ms表[id] ?? 0)) {
    塞拉绝对零度下次Ms表[id] = now + zero.冷却秒 * 1000;
    塞拉忙碌到Ms表[id] = now + zero.施法硬直秒 * 1000;
    释放绝对零度领域(context, target);
  }
}

export function 初始化巴尔扎罗斯塞拉技能(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.塞拉技能已初始化) return;
  context.塞拉技能已初始化 = true;
  确保塞拉伤害修正();
  if (单位有效(context.塞拉)) {
    const id = 取单位ID(context.塞拉);
    切换塞拉形态(context, "火焰", false);
    塞拉元素转换下次Ms表[id] = getServerTime() + 巴尔扎罗斯技能数值配置.元素转换.周期秒 * 1000;
    context.清理.登记清理("巴尔扎罗斯-塞拉技能状态", function 巴尔扎罗斯塞拉技能状态清理(this: void): void {
      delete 塞拉冰焰双星下次Ms表[id];
      delete 塞拉绝对零度下次Ms表[id];
      delete 塞拉元素转换下次Ms表[id];
      delete 塞拉忙碌到Ms表[id];
      delete 塞拉形态表[id];
      delete 绝对零度领域状态表[id];
    });
  }
  const tickId = addPeriodicCallback(500, function 巴尔扎罗斯塞拉技能Tick(this: void): void {
    尝试释放塞拉技能(context);
  });
  context.清理.登记周期回调("巴尔扎罗斯-塞拉技能驱动", tickId);
}

export function 注册巴尔扎罗斯护卫塞拉(this: void): void {
  确保塞拉伤害修正();
}
