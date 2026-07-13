/**
 * AI自动使用技能系统入口
 *
 * 当前目录先补齐 AI 配置层骨架，运行时主动施法与受击反应后续按规划接入。
 */

export * from "./00．AI配置";
export * from "./03．Boss战启动桥接";
export * from "./01．受击反应施法";
export * from "./02．Boss主动扫描施法";

/**
 * 入口初始化：先接入受击反应与 Boss 战启动桥接，再接主动扫描驱动。
 */
export function init(this: void): void {
  const 受击反应模块 = require("./01．受击反应施法") as {
    init受击反应施法?: (this: void) => void;
  };
  const Boss战启动桥接模块 = require("./03．Boss战启动桥接") as {
    注册Boss战启动Stes桥接?: (this: void) => void;
  };
  const Boss主动扫描模块 = require("./02．Boss主动扫描施法") as {
    init?: (this: void) => void;
  };

  受击反应模块.init受击反应施法?.();
  Boss战启动桥接模块.注册Boss战启动Stes桥接?.();
  Boss主动扫描模块.init?.();
}

export {};
