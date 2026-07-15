/** @noSelfInFile */

import { 获取全部瑟兰迪尔上下文, type 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置, 瑟兰迪尔运行时配置 } from "./02．数值与表现配置";
import { 选择瑟兰迪尔执法印记目标, 释放瑟兰迪尔执法印记 } from "./04．执法印记";
import { 释放瑟兰迪尔终末审判 } from "./12．终末审判";
import { 创建战斗技能调度器, type 战斗技能调度器 } from "../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板";
import { 单位有效, 取单位ID } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

let 瑟兰迪尔技能调度器: 战斗技能调度器 | undefined;

function 取瑟兰迪尔上下文键(this: void, context: 瑟兰迪尔运行时上下文): number {
  return 取单位ID(context.Boss单位);
}

function 瑟兰迪尔可调度(this: void, context: 瑟兰迪尔运行时上下文, nowMs: number): boolean {
  return 单位有效(context.Boss单位) && nowMs >= context.普通机制忙碌到Ms;
}

function 终末审判阶段允许(this: void, context: 瑟兰迪尔运行时上下文): boolean {
  return context.阶段 >= 3;
}

export function 注册瑟兰迪尔技能调度(this: void): void {
  if (瑟兰迪尔技能调度器 != null) return;
  const mark = 瑟兰迪尔数值与表现配置.执法印记;
  const finalJudgment = 瑟兰迪尔数值与表现配置.终末审判;
  瑟兰迪尔技能调度器 = 创建战斗技能调度器<瑟兰迪尔运行时上下文>({
    名称: "瑟兰迪尔战斗技能调度",
    间隔毫秒: 瑟兰迪尔运行时配置.推进间隔毫秒,
    取上下文列表: 获取全部瑟兰迪尔上下文,
    取上下文键: 取瑟兰迪尔上下文键,
    可调度: 瑟兰迪尔可调度,
    自动启动: false,
    技能列表: [{
      key: "终末审判",
      冷却毫秒: finalJudgment.周期秒 * 1000,
      首次延迟毫秒: 0,
      忙碌毫秒: (finalJudgment.引导秒 + finalJudgment.爆炸延迟秒) * 1000 + finalJudgment.恢复动作延迟Ms,
      优先级: 100,
      阶段允许: 终末审判阶段允许,
      执行: function 执行瑟兰迪尔终末审判(this: void, context: 瑟兰迪尔运行时上下文): boolean {
        return 释放瑟兰迪尔终末审判(context);
      },
    }, {
      key: "执法印记",
      冷却毫秒: mark.周期秒 * 1000,
      首次延迟毫秒: 0,
      忙碌毫秒: 0,
      优先级: 10,
      选择目标: 选择瑟兰迪尔执法印记目标,
      目标有效: function 瑟兰迪尔执法印记目标有效(this: void, _context: 瑟兰迪尔运行时上下文, target: any): boolean {
        return 单位有效(target);
      },
      执行: function 执行瑟兰迪尔执法印记(this: void, context: 瑟兰迪尔运行时上下文, target: any): boolean {
        return 释放瑟兰迪尔执法印记(context, target);
      },
    }],
  });
  瑟兰迪尔技能调度器.启动();
}
