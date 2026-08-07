/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按任务ID创建NPC, 按任务ID查找已创建NPC } = require("系统.08．任务系统.00．配置表.04．NPC生成器") as {
  按任务ID创建NPC: (this: void, 任务ID: number) => any;
  按任务ID查找已创建NPC: (this: void, 任务ID: number) => any;
};

import { 被驱逐的水怪入口配置 } from "./00．入口配置";

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const 水龙蛇单位类型ID = stringToFourCCSafe(被驱逐的水怪入口配置.前置Boss单位ID);

let 已注册水龙蛇死亡入口 = false;

function on水龙蛇死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (GetUnitTypeId(dyingUnit) !== 水龙蛇单位类型ID) return;
  if (按任务ID查找已创建NPC(被驱逐的水怪入口配置.任务ID) != null) return;
  按任务ID创建NPC(被驱逐的水怪入口配置.任务ID);
}

export function 注册水龙蛇死亡后出现沃利尔斯(this: void): void {
  if (已注册水龙蛇死亡入口) return;
  已注册水龙蛇死亡入口 = true;
  registerDeathListener(on水龙蛇死亡);
}
