/** @noSelfInFile */

import { 获取全部米亚上下文, type 米亚运行时上下文 } from "./03．运行时上下文";
import { 米亚技能数值配置, 米亚运行时配置 } from "./02．数值与表现配置";
import { 触发米亚灵猫分身 } from "./07．灵猫分身";
import { 释放米亚污染脉冲 } from "./09．污染脉冲";
import { 释放米亚污水柱爆发 } from "./10．污水柱爆发";
import { 释放米亚腐化转移 } from "./11．腐化转移";
import { 释放米亚全场腐化黏液 } from "./13．腐化黏液涂层";
import { 触发米亚终极污染 } from "./14．终极污染";
import { 创建战斗技能调度器, type 战斗技能调度器 } from "../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板";
import { 单位有效, 取单位ID } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

let 米亚技能调度器: 战斗技能调度器 | undefined;

function 取米亚上下文键(this: void, context: 米亚运行时上下文): number {
  return 取单位ID(context.Boss单位);
}

function 米亚可调度(this: void, context: 米亚运行时上下文): boolean {
  return 单位有效(context.Boss单位) && !context.终极污染引导中;
}

function 到达生命阈值(this: void, context: 米亚运行时上下文, threshold: number): boolean {
  const maxLife = GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE);
  return maxLife > 0 && GetUnitState(context.Boss单位, UNIT_STATE_LIFE) / maxLife <= threshold;
}

function 是P1(this: void, context: 米亚运行时上下文): boolean { return context.阶段 === 1; }
function 是P2(this: void, context: 米亚运行时上下文): boolean { return context.阶段 === 2; }
function 是P3(this: void, context: 米亚运行时上下文): boolean { return context.阶段 === 3; }

export function 注册米亚技能调度(this: void): void {
  if (米亚技能调度器 != null) return;
  const clone = 米亚技能数值配置.灵猫分身;
  const pulse = 米亚技能数值配置.污染脉冲;
  const geyser = 米亚技能数值配置.污水柱爆发;
  const transfer = 米亚技能数值配置.腐化转移;
  const slime = 米亚技能数值配置.腐化黏液涂层;
  const ultimate = 米亚技能数值配置.终极污染;

  米亚技能调度器 = 创建战斗技能调度器<米亚运行时上下文>({
    名称: "米亚战斗技能调度",
    间隔毫秒: 米亚运行时配置.推进间隔毫秒,
    取上下文列表: 获取全部米亚上下文,
    取上下文键: 取米亚上下文键,
    可调度: 米亚可调度,
    自动启动: false,
    技能列表: [{
      key: "终极污染30",
      冷却毫秒: 3600000,
      首次延迟毫秒: 0,
      忙碌毫秒: ultimate.引导秒 * 1000,
      优先级: 300,
      阶段允许: 是P3,
      可释放: function 米亚终极污染30可释放(this: void, context: 米亚运行时上下文): boolean {
        return !context.已触发终极污染30 && 到达生命阈值(context, ultimate.触发生命比例[0]);
      },
      执行: function 执行米亚终极污染30(this: void, context: 米亚运行时上下文): boolean {
        return 触发米亚终极污染(context, 0);
      },
    }, {
      key: "终极污染15",
      冷却毫秒: 3600000,
      首次延迟毫秒: 0,
      忙碌毫秒: ultimate.引导秒 * 1000,
      优先级: 290,
      阶段允许: 是P3,
      可释放: function 米亚终极污染15可释放(this: void, context: 米亚运行时上下文): boolean {
        return !context.已触发终极污染15 && 到达生命阈值(context, ultimate.触发生命比例[1]);
      },
      执行: function 执行米亚终极污染15(this: void, context: 米亚运行时上下文): boolean {
        return 触发米亚终极污染(context, 1);
      },
    }, {
      key: "灵猫分身第一阈值",
      冷却毫秒: 3600000,
      首次延迟毫秒: 0,
      忙碌毫秒: 米亚运行时配置.推进间隔毫秒,
      优先级: 200,
      阶段允许: 是P1,
      可释放: function 米亚灵猫分身第一阈值可释放(this: void, context: 米亚运行时上下文): boolean {
        return !context.已触发分身80 && 到达生命阈值(context, clone.触发生命比例[0]);
      },
      执行: function 执行米亚灵猫分身第一阈值(this: void, context: 米亚运行时上下文): boolean {
        if (!触发米亚灵猫分身(context)) return false;
        context.已触发分身80 = true;
        return true;
      },
    }, {
      key: "灵猫分身第二阈值",
      冷却毫秒: 3600000,
      首次延迟毫秒: 0,
      忙碌毫秒: 米亚运行时配置.推进间隔毫秒,
      优先级: 190,
      阶段允许: 是P1,
      可释放: function 米亚灵猫分身第二阈值可释放(this: void, context: 米亚运行时上下文): boolean {
        return !context.已触发分身50 && 到达生命阈值(context, clone.触发生命比例[1]);
      },
      执行: function 执行米亚灵猫分身第二阈值(this: void, context: 米亚运行时上下文): boolean {
        if (!触发米亚灵猫分身(context)) return false;
        context.已触发分身50 = true;
        return true;
      },
    }, {
      key: "污染脉冲",
      冷却毫秒: pulse.轮次间隔Ms,
      首次延迟毫秒: 0,
      忙碌毫秒: 1000,
      优先级: 30,
      阶段允许: 是P2,
      执行: function 执行米亚污染脉冲(this: void, context: 米亚运行时上下文): boolean {
        return 释放米亚污染脉冲(context);
      },
    }, {
      key: "腐化转移",
      冷却毫秒: transfer.冷却Ms,
      首次延迟毫秒: 0,
      忙碌毫秒: transfer.预警秒 * 1000 + transfer.恢复动作延迟Ms,
      优先级: 20,
      阶段允许: 是P2,
      可释放: function 米亚腐化转移可释放(this: void, context: 米亚运行时上下文): boolean {
        return (context.腐化转移污染平台ID ?? "") === "";
      },
      执行: function 执行米亚腐化转移(this: void, context: 米亚运行时上下文, _target: any, nowMs: number): boolean {
        return 释放米亚腐化转移(context, nowMs);
      },
    }, {
      key: "污水柱爆发",
      冷却毫秒: geyser.冷却Ms,
      首次延迟毫秒: 0,
      忙碌毫秒: 1000,
      优先级: 10,
      阶段允许: 是P2,
      执行: function 执行米亚污水柱爆发(this: void, context: 米亚运行时上下文): boolean {
        return 释放米亚污水柱爆发(context);
      },
    }, {
      key: "全场腐化黏液",
      冷却毫秒: slime.全场甩黏液间隔Ms,
      首次延迟毫秒: 0,
      忙碌毫秒: 500,
      优先级: 10,
      阶段允许: 是P3,
      执行: function 执行米亚全场腐化黏液(this: void, context: 米亚运行时上下文): boolean {
        return 释放米亚全场腐化黏液(context);
      },
    }],
  });
  米亚技能调度器.启动();
}
