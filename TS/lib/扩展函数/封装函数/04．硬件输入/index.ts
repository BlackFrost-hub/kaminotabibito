/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * DZ/JAPI 硬件函数封装（键盘/鼠标/窗口/UI Frame）
 *
 * 目标：
 * - 只依赖运行时注入的 Dz* / EX*（平台本地/联机环境）
 * - 调用前做存在性检查，缺失时静默降级
 * - 避开 TSTL 坑：禁止对 jass API 用可选链调用；禁止把 jass.xxx 赋给局部变量再调用
 */

// ========== 子模块导出 ==========
export * from "./01．常量定义";
export * from "./02．内部工具";
export * from "./03．鼠标函数";
export * from "./04．键盘函数";
export * from "./05．滚轮函数";
export * from "./06．窗口函数";
export * from "./07．Frame函数";
export * from "./08．同步硬件输入中心";

// 测试按键模块会自动初始化
