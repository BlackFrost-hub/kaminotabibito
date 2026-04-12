/**
 * 扩展函数 - 统一导出和初始化入口
 */

// ========== 子模块导出 ==========
export * from "./封装函数/index";

// ========== 初始化 ==========
// 加载所有子系统（子系统内部会自行注册全局桥接）
require("lib.扩展函数.封装函数.05．泄露审计.index");
require("lib.扩展函数.封装函数.01．通用工具.index");
require("lib.扩展函数.封装函数.02．音效系统.index");
require("lib.扩展函数.封装函数.03．漂浮文字.index");
require("lib.扩展函数.封装函数.04．硬件输入.index");
require("lib.扩展函数.封装函数.06．伤害函数.index");
require("lib.扩展函数.封装函数.07．镜头函数.index");
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
}
