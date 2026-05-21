/** @noSelfInFile */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 开始无敌帧 } from "../02．通用函数/index";
const 模块名 = "无敌帧测试";
const 测试命令 = "112";
const 测试持续时间 = 3.0;
function 执行无敌帧测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
        return;
    }
    开始无敌帧(大法师, 测试持续时间);
    debugLogForce(模块名, "已对 gg_unit_Hamg_0002 施加无敌", "持续秒数=", 测试持续时间);
}
function on聊天112测试() {
    执行无敌帧测试();
}
注册聊天命令监听(测试命令, on聊天112测试);
debugLogForce(模块名, "已注册聊天测试", "输入", 测试命令, "对 gg_unit_Hamg_0002 施加 3 秒无敌");
