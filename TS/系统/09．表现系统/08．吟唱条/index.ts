/**
 * 吟唱条系统 - 统一导出
 */

export * from "./00．常量定义";
export * from "./01．类型";
export * from "./02．UI创建";
export { 启动吟唱条, 关闭吟唱条 as 关闭吟唱条核心, 获取吟唱条状态 } from "./03．吟唱条核心";
export * from "./04．数字格式化";
export * from "./05．吟唱条STES桥接";
export { 显示吟唱条, 关闭吟唱条 } from "./06．对外接口";

import "./05．吟唱条STES桥接";