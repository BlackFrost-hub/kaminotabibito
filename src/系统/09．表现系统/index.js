/** @noSelfInFile */
/**
 * 表现系统 - main 初始化入口
 *
 * main 只依赖 init。这里不做 export * 聚合，避免加载期把 UI 工具、
 * 对话框、仇恨面板、广播提示、手册等模块卷进同一条导出链。
 */
const 原生UI = require("系统.09．表现系统.00．初始化UI");
const UI属性系统 = require("系统.09．表现系统.03．UI属性系统.03．系统入口");
const 广播提示消息系统 = require("系统.09．表现系统.06．广播提示消息.index");
const 游戏说明手册 = require("系统.09．表现系统.07．游戏说明手册.index");
let 表现系统已初始化 = false;
export function init() {
    if (表现系统已初始化)
        return;
    表现系统已初始化 = true;
    if (typeof 原生UI.initNativeUI === "function") {
        原生UI.initNativeUI();
    }
    UI属性系统.initUiAttributeSystem();
    require("系统.09．表现系统.02．对话框系统.index");
    广播提示消息系统.初始化广播提示消息系统();
    游戏说明手册.init();
}
