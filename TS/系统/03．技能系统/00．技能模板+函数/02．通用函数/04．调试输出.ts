/**
 * 通用函数 - 调试输出便捷入口
 *
 * 说明：
 * - 这里只做技能侧便捷转导出，不迁移底层实现。
 * - 底层来源：
 *   `TS/lib/扩展函数/自定义扩展函数/03．调试输出.ts`
 */

export {
  setDebug,
  isDebug,
  debugLog,
  debugLogForce,
} from "../../../../lib/扩展函数/自定义扩展函数/03．调试输出";

import {
  setDebug,
  isDebug,
  debugLog,
  debugLogForce,
} from "../../../../lib/扩展函数/自定义扩展函数/03．调试输出";

export const 设置技能调试开关 = setDebug;
export const 技能调试是否开启 = isDebug;
export const 技能调试输出 = debugLog;
export const 技能强制调试输出 = debugLogForce;

