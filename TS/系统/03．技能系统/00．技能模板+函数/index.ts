/**
 * 技能模板+函数 - 统一导出入口
 */

export * from "./00．技能模板/index";
export * from "./01．技能函数/index";
export * from "./02．通用函数/index";
export * from "./04．机制组件/index";

const { 测试系统总开关 } = require("系统.12．测试系统.00．测试系统开关") as {
  测试系统总开关: boolean;
};
const { 设置聊天命令注册权限 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  设置聊天命令注册权限: (this: void, 权限: ((this: void, player: any) => boolean) | undefined) => void;
};
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};

/** 通用技能模板测试默认关闭；Boss 等其他测试仍由总开关控制。 */
const 技能模板测试启用 = false;

if (测试系统总开关 && 技能模板测试启用) {
  设置聊天命令注册权限(是允许测试玩家);
  require("系统.03．技能系统.00．技能模板+函数.03．技能测试.index");
  设置聊天命令注册权限(undefined);
}
