/**
 * 扩展函数 - 统一导出和初始化入口
 */

// ========== 初始化 ==========
// 加载所有子系统（子系统内部会自行注册全局桥接）
require("lib.扩展函数.BJ函数.index");
require("lib.扩展函数.YDWE函数.index");
require("lib.扩展函数.KK扩展API.index");
require("lib.扩展函数.Star扩展函数.index");
require("lib.扩展函数.物品相关函数.index");
require("lib.扩展函数.自定义扩展函数.index");

/**
 * 初始化扩展函数
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[扩展函数] 初始化完成");
  }
}
