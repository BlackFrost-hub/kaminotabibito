/**
 * 通用函数 - 移动速度突破便捷入口
 *
 * 说明：
 * - 这里只做技能侧便捷转导出，不迁移底层实现。
 * - 底层来源：
 *   `TS/lib/扩展函数/Star扩展函数/Star扩展库/05．移动速度突破系统.ts`
 */

export {
  SOS_SetUnitSpeed,
  SOS_SetUnitSpeedTemp,
  SOS_GetUnitSpeed,
  SOS_UnSetUnitSpeed,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/05．移动速度突破系统";

import {
  SOS_SetUnitSpeed,
  SOS_SetUnitSpeedTemp,
  SOS_GetUnitSpeed,
  SOS_UnSetUnitSpeed,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/05．移动速度突破系统";

export const 设置单位突破移速 = SOS_SetUnitSpeed;
export const 设置单位临时突破移速 = SOS_SetUnitSpeedTemp;
export const 获取单位突破移速 = SOS_GetUnitSpeed;
export const 取消单位突破移速 = SOS_UnSetUnitSpeed;

