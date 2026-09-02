/** @noSelfInFile */

export * from "./00．配置";
import "./01．技能显示初始化";
import "./02．公共状态与冰晶";
import { 注册爱蜜莉雅表现 } from "./10．表现接入";

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

debugLogForce("爱蜜莉雅-index", "模块加载");
注册爱蜜莉雅表现();

export {};
