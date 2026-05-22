/**
 * AI自动使用技能系统入口
 *
 * 当前目录先补齐 AI 配置层骨架，运行时自动施法逻辑后续再按规划文档接入。
 */

export * from "./00．常量定义";
export * from "./01．AI配置类型";
export * from "./02．AI配置工具";
export * from "./03．BossAI配置表";
export * from "./04．杂鱼AI配置表";
export * from "./05．精英AI配置表";
export * from "./06．英雄AI配置表";
export * from "./07．异界BossAI配置表";
export * from "./08．全部AI配置索引";
export * from "./09．Boss战启动桥接/index";

/**
 * 保留给技能系统总入口调用的占位初始化函数。
 * 运行时自动施法系统正式接入后，再在这里挂真实初始化。
 */
export function init(this: void): void {
  const 受击反应施法模块 = require("系统.03．技能系统.06．AI自动使用技能.01．受击反应施法.index") as {
    init受击反应施法?: (this: void) => void;
  };
  const Boss战启动桥接模块 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.index") as {
    注册Boss战启动Stes桥接?: (this: void) => void;
  };
  受击反应施法模块.init受击反应施法?.();
  Boss战启动桥接模块.注册Boss战启动Stes桥接?.();
}

export {};
