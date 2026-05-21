/** @noSelfInFile */
/**
 * 贝塞尔锁定加速度测试
 *
 * 输入 "1013"：
 * - 搜索 gg_unit_Hamg_0002 附近敌人作为锁定终点。
 * - 发射锁定单位二阶贝塞尔 XYZ 弹幕。
 * - 初速 260，飞行 250 码后开始加速度 650。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
import { 创建原生弹幕, 创建锁定单位二阶贝塞尔加速度XYZ轨迹, } from "../01．技能函数/01．弹幕/01．TS原生弹幕/index";
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFacing = jass.GetUnitFacing;
const GetUnitName = jass.GetUnitName;
const GetHandleId = jass.GetHandleId;
const SquareRoot = jass.SquareRoot;
const Cos = jass.Cos;
const Sin = jass.Sin;
const 模块名 = "贝塞尔锁定加速度测试";
const 测试命令 = "1013";
const 搜索半径 = 1000;
function 查找最近敌人(来源单位) {
    const x = GetUnitX(来源单位);
    const y = GetUnitY(来源单位);
    const 候选 = getUnitsInRange(x, y, 搜索半径);
    let 最佳目标 = null;
    let 最佳距离 = 0;
    for (let i = 0; i < 候选.length; i++) {
        const 单位 = 候选[i];
        if (!isUnitEnemy(单位, 来源单位))
            continue;
        const dx = GetUnitX(单位) - x;
        const dy = GetUnitY(单位) - y;
        const 距离 = SquareRoot(dx * dx + dy * dy);
        if (最佳目标 == null || 距离 < 最佳距离) {
            最佳目标 = 单位;
            最佳距离 = 距离;
        }
    }
    return 最佳目标;
}
function 前方X(单位, distance) {
    const angle = GetUnitFacing(单位) * jass.bj_DEGTORAD;
    return GetUnitX(单位) + Cos(angle) * distance;
}
function 前方Y(单位, distance) {
    const angle = GetUnitFacing(单位) * jass.bj_DEGTORAD;
    return GetUnitY(单位) + Sin(angle) * distance;
}
function 锁定贝塞尔_命中(目标单位, 弹幕ID) {
    debugLogForce(模块名, "命中锁定弹幕", "弹幕ID=", 弹幕ID, "目标=", GetUnitName(目标单位), "#", GetHandleId(目标单位));
}
function 锁定贝塞尔_到达(弹幕ID, 原因) {
    debugLogForce(模块名, "到达目标点", "弹幕ID=", 弹幕ID, "原因=", 原因);
}
function 锁定贝塞尔_结束(原因, 弹幕ID) {
    debugLogForce(模块名, "结束", "弹幕ID=", 弹幕ID, "原因=", 原因);
}
function on聊天1013测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    const 目标 = 查找最近敌人(大法师);
    if (目标 == null || 目标 === 0) {
        debugLogForce(模块名, "错误：附近未找到敌人");
        return;
    }
    const startX = 前方X(大法师, 80);
    const startY = 前方Y(大法师, 80);
    const ctrlX = 前方X(大法师, 420);
    const ctrlY = 前方Y(大法师, 420);
    const 实例 = 创建原生弹幕({
        所有者: 大法师,
        X: startX,
        Y: startY,
        方向角: GetUnitFacing(大法师),
        速度: 0,
        生命周期: 8,
        命中半径: 110,
        碰撞消失: true,
        伤害值: 55,
        影响目标: "敌方",
        模型: "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
        轨迹采样器: 创建锁定单位二阶贝塞尔加速度XYZ轨迹(startX, startY, 80, ctrlX, ctrlY, 420, 目标, 80, 260, 650, 250),
        on命中单位: 锁定贝塞尔_命中,
        on到达目标点: 锁定贝塞尔_到达,
        on结束: 锁定贝塞尔_结束,
    });
    debugLogForce(模块名, "已发射锁定加速度贝塞尔弹幕", "弹幕ID=", 实例.弹幕ID, "目标=", GetUnitName(目标), "#", GetHandleId(目标));
}
注册聊天命令监听(测试命令, on聊天1013测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "发射锁定加速度贝塞尔弹幕");
