/** @noSelfInFile */
/**
 * 嘲讽 测试
 *
 * 输入 "1019"：
 * - 先给玩家1写入 50% 眩晕抗性
 * - 再让大法师周围1000码内的第一个敌人，对大法师施加5秒单体嘲讽
 * - 用于测试嘲讽是否正确吃到玩家级控制抗性
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const 嘲讽系统 = require("../01．技能函数/16．扩展控制/index");
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { YDUserDataSet } = require("lib.扩展函数.YDWE函数.index");
const Player = jass.Player;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const 模块名 = "嘲讽测试";
const 测试命令 = "1019";
function 施加单体嘲讽(sourceUnit, targetUnit, options) {
    return 嘲讽系统["施加嘲讽"](sourceUnit, targetUnit, options);
}
function on聊天测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    const x = GetUnitX(大法师);
    const y = GetUnitY(大法师);
    YDUserDataSet("player", Player(0), "眩晕抗性", "real", 0.3);
    const 敌人列表 = getEnemyUnitsInRange(大法师, x, y, 1000);
    const 第一个敌人 = 敌人列表[0];
    if (第一个敌人 == null || 第一个敌人 === 0) {
        debugLogForce(模块名, "错误：大法师周围1000码内没有敌人，无法测试单体嘲讽");
        return;
    }
    const 结果 = 施加单体嘲讽(第一个敌人, 大法师, {
        持续时间: 5,
        反伤倍率: 1.0,
    });
    debugLogForce(模块名, "已给玩家1写入50%眩晕抗性");
    debugLogForce(模块名, "单体嘲讽 结果=", 结果, "来源=", 第一个敌人, "目标=gg_unit_Hamg_0002");
    debugLogForce(模块名, "提示：理论持续时间应缩短到2.5秒，来源为周围第一个敌人");
}
注册聊天命令监听(测试命令, on聊天测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "给玩家1加50%控制抗性，再让周围第一个敌人嘲讽大法师");
export {};
