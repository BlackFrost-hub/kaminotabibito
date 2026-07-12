/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 释放格鲁姆重锤 } from "./01．熔岩重锤";
import { 释放格鲁姆火径 } from "./02．熔岩火径";
import { 格鲁姆公共 } from "./00．公共";
const {  巴尔扎罗斯技能数值配置,
  addPeriodicCallback,
  getServerTime,
  GetUnitX,
  GetUnitY,
  单位有效,
  取单位ID,
  取目标单位,
  点到单位距离平方,
  格鲁姆重锤下次Ms表,
  格鲁姆火径下次Ms表,
} = 格鲁姆公共;

function 尝试释放格鲁姆技能(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const grum = context.格鲁姆;
  if (!单位有效(context.Boss单位) || !单位有效(grum)) return;
  const target = 取目标单位(context);
  if (!单位有效(target)) return;
  const id = 取单位ID(grum);
  const now = getServerTime();
  const hammer = 巴尔扎罗斯技能数值配置.熔岩重锤;
  const firePath = 巴尔扎罗斯技能数值配置.熔岩火径;
  if (now >= (格鲁姆重锤下次Ms表[id] ?? 0) && 点到单位距离平方(target, GetUnitX(grum), GetUnitY(grum)) <= hammer.施法距离 * hammer.施法距离) {
    格鲁姆重锤下次Ms表[id] = now + hammer.冷却秒 * 1000;
    释放格鲁姆重锤(context, target);
    return;
  }
  if (now >= (格鲁姆火径下次Ms表[id] ?? 0)) {
    格鲁姆火径下次Ms表[id] = now + firePath.冷却秒 * 1000;
    释放格鲁姆火径(context, target);
  }
}

export function 初始化巴尔扎罗斯格鲁姆技能(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.格鲁姆技能已初始化) return;
  context.格鲁姆技能已初始化 = true;
  const tickId = addPeriodicCallback(500, function 巴尔扎罗斯格鲁姆技能Tick(this: void): void {
    尝试释放格鲁姆技能(context);
  });
  context.清理.登记周期回调("巴尔扎罗斯-格鲁姆技能驱动", tickId);
}

export function 注册巴尔扎罗斯护卫格鲁姆(this: void): void {
  // 格鲁姆技能由 Boss 运行时上下文初始化，不走物编主动技能壳。
}
