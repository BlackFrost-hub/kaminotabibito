/**
 * 通用函数 - 控制与 Buff 便捷入口
 *
 * 说明：
 * - 这里只做技能侧便捷转导出，不迁移底层实现。
 * - 底层来源：
 *   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统.ts`
 *   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统.ts`
 */

export {
  GS_Suspend,
  GS_IsUnitSuspending,
  GS_LoadSuspend,
  GS_UnitSuspend,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统";

export {
  SFB_Init,
  SFB_setBuff,
  SFB_setSlow,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统";

import {
  GS_Suspend,
  GS_IsUnitSuspending,
  GS_LoadSuspend,
  GS_UnitSuspend,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统";

import {
  SFB_Init,
  SFB_setBuff,
  SFB_setSlow,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统";

export const 开始硬直 = GS_Suspend;
export const 单位是否硬直中 = GS_IsUnitSuspending;
export const 获取单位硬直剩余时间 = GS_LoadSuspend;
export const 调整单位硬直时间 = GS_UnitSuspend;

export const 初始化快速Buff系统 = SFB_Init;
export const 施加快速控制Buff = SFB_setBuff;
export const 施加快速减速Buff = SFB_setSlow;

