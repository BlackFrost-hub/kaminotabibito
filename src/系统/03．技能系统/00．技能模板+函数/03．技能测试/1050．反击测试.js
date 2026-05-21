/** @noSelfInFile */
/**
 * 反击系统测试
 *
 * 输入 1050：给大法师注册反击效果，所有伤害他的敌人被反击30点伤害
 * 输入 1059：清理反击效果
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 注册反击, 移除反击, 反击类型, 反击伤害类型, } from "../01．技能函数/13．反击/index";
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index");
function 获取大法师() {
    return require("jass.globals").gg_unit_Hamg_0002;
}
function on聊天1050命令() {
    const 大法师 = 获取大法师();
    if (!大法师) {
        debugLogForce("反击测试", "未找到大法师");
        return;
    }
    注册反击({
        反击来源: 大法师,
        反击类型: 反击类型.任意伤害,
        伤害计算方式: 反击伤害类型.固定值,
        伤害值: 30,
        距离条件: {},
        冷却时间: 0,
        是否AOE: false,
        只反击来源: true,
    });
    debugLogForce("反击测试", "大法师已获得反击能力，任何伤害他的敌人将被反击30点伤害");
}
function on聊天1059命令() {
    const 大法师 = 获取大法师();
    if (大法师) {
        移除反击(大法师);
    }
    debugLogForce("反击测试", "已移除大法师反击效果");
}
注册聊天命令监听("1050", on聊天1050命令);
注册聊天命令监听("1059", on聊天1059命令);
debugLogForce("反击测试", "已注册命令: 1050-注册反击, 1059-清理");
