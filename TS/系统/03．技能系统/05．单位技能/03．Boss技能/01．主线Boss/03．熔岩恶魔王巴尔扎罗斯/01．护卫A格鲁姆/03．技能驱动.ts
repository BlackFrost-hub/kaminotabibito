/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 释放格鲁姆重锤 } from "./01．熔岩重锤";
import { 释放格鲁姆火径 } from "./02．熔岩火径";
import { 初始化巴尔扎罗斯炙热奉献 } from "./03．炙热奉献";
import { 格鲁姆公共 } from "./00．公共";
import { 创建战斗技能调度器 } from "../../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板";

const {
  巴尔扎罗斯技能数值配置,
  GetUnitX,
  GetUnitY,
  单位有效,
  取单位ID,
  取目标单位,
  点到单位距离平方,
} = 格鲁姆公共;

function 格鲁姆可调度(this: void, context: 巴尔扎罗斯运行时上下文): boolean {
  return 单位有效(context.Boss单位) && 单位有效(context.格鲁姆);
}

function 取格鲁姆上下文键(this: void, context: 巴尔扎罗斯运行时上下文): number {
  return 取单位ID(context.格鲁姆);
}

function 选择格鲁姆目标(this: void, context: 巴尔扎罗斯运行时上下文): any {
  return 取目标单位(context);
}

function 格鲁姆重锤目标有效(this: void, context: 巴尔扎罗斯运行时上下文, target: any): boolean {
  const grum = context.格鲁姆;
  if (!单位有效(grum) || !单位有效(target)) return false;
  const hammer = 巴尔扎罗斯技能数值配置.熔岩重锤;
  return 点到单位距离平方(target, GetUnitX(grum), GetUnitY(grum)) <= hammer.施法距离 * hammer.施法距离;
}

export function 初始化巴尔扎罗斯格鲁姆技能(this: void, context: 巴尔扎罗斯运行时上下文): void {
  初始化巴尔扎罗斯炙热奉献(context);
  if (context.格鲁姆技能已初始化) return;
  context.格鲁姆技能已初始化 = true;
  const hammer = 巴尔扎罗斯技能数值配置.熔岩重锤;
  const firePath = 巴尔扎罗斯技能数值配置.熔岩火径;
  创建战斗技能调度器<巴尔扎罗斯运行时上下文>({
    名称: "巴尔扎罗斯-格鲁姆技能调度",
    清理: context.清理,
    间隔毫秒: 500,
    取上下文列表: function 取格鲁姆上下文列表(this: void): 巴尔扎罗斯运行时上下文[] { return [context]; },
    取上下文键: 取格鲁姆上下文键,
    可调度: 格鲁姆可调度,
    技能列表: [{
      key: "熔岩重锤",
      冷却毫秒: hammer.冷却秒 * 1000,
      首次延迟毫秒: 0,
      优先级: 20,
      选择目标: 选择格鲁姆目标,
      目标有效: 格鲁姆重锤目标有效,
      执行: function 执行格鲁姆重锤(this: void, skillContext: 巴尔扎罗斯运行时上下文, target: any): boolean {
        释放格鲁姆重锤(skillContext, target);
        return true;
      },
    }, {
      key: "熔岩火径",
      冷却毫秒: firePath.冷却秒 * 1000,
      首次延迟毫秒: 0,
      优先级: 10,
      选择目标: 选择格鲁姆目标,
      目标有效: function 格鲁姆火径目标有效(this: void, _context: 巴尔扎罗斯运行时上下文, target: any): boolean { return 单位有效(target); },
      执行: function 执行格鲁姆火径(this: void, skillContext: 巴尔扎罗斯运行时上下文, target: any): boolean {
        释放格鲁姆火径(skillContext, target);
        return true;
      },
    }],
  });
}
