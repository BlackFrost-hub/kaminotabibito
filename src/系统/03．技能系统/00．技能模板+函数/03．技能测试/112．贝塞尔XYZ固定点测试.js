/** @noSelfInFile */
/**
 * 贝塞尔 XYZ 固定点测试
 *
 * 输入 "1012"：
 * - 从 gg_unit_Hamg_0002 前方发射固定终点二阶贝塞尔抛物线弹幕。
 * - 测试 Z 高度采样、到达目标点回调、结束回调。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 创建二阶贝塞尔加速度抛物线轨迹, 创建原生弹幕, } from "../01．技能函数/01．弹幕/01．TS原生弹幕/index";
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFacing = jass.GetUnitFacing;
const Cos = jass.Cos;
const Sin = jass.Sin;
const 模块名 = "贝塞尔XYZ固定点测试";
const 测试命令 = "1012";
function 投影X(x, angle, distance) {
    return x + Cos(angle * jass.bj_DEGTORAD) * distance;
}
function 投影Y(y, angle, distance) {
    return y + Sin(angle * jass.bj_DEGTORAD) * distance;
}
function 固定点贝塞尔_到达(弹幕ID, 原因) {
    debugLogForce(模块名, "到达目标点", "弹幕ID=", 弹幕ID, "原因=", 原因);
}
function 固定点贝塞尔_结束(原因, 弹幕ID) {
    debugLogForce(模块名, "结束", "弹幕ID=", 弹幕ID, "原因=", 原因);
}
function on聊天1012测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    const face = GetUnitFacing(大法师);
    const startX = 投影X(GetUnitX(大法师), face, 80);
    const startY = 投影Y(GetUnitY(大法师), face, 80);
    const endX = 投影X(GetUnitX(大法师), face, 900);
    const endY = 投影Y(GetUnitY(大法师), face, 900);
    const controlX = 投影X(GetUnitX(大法师), face + 35, 520);
    const controlY = 投影Y(GetUnitY(大法师), face + 35, 520);
    const 实例 = 创建原生弹幕({
        所有者: 大法师,
        X: startX,
        Y: startY,
        方向角: face,
        速度: 0,
        生命周期: 6,
        命中半径: 96,
        伤害值: 25,
        影响目标: "敌方",
        模型: "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
        轨迹采样器: 创建二阶贝塞尔加速度抛物线轨迹(startX, startY, 60, controlX, controlY, endX, endY, 60, 360, 400),
        on到达目标点: 固定点贝塞尔_到达,
        on结束: 固定点贝塞尔_结束,
    });
    debugLogForce(模块名, "已发射固定点贝塞尔XYZ弹幕", "弹幕ID=", 实例.弹幕ID, "终点=(", endX, ",", endY, ")");
}
注册聊天命令监听(测试命令, on聊天1012测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "发射固定点贝塞尔XYZ弹幕");
