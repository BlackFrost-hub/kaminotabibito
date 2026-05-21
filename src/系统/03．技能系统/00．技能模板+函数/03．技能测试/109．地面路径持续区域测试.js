/** @noSelfInFile */
/**
 * 地面路径持续区域测试
 *
 * 输入"1009"后，以 `gg_unit_Hamg_0002` 当前面向为方向，
 * 在前方 800 码、半径 100 的路径上逐段铺设火焰特效，
 * 但伤害统一按前方 800、半径 200 的整体矩形区域持续结算 10 秒。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFacing = jass.GetUnitFacing;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 创建火焰路径持续区域 } from "../00．技能模板/index";
const 模块名 = "地面路径持续区域测试";
const 测试命令 = "1009";
const 路径长度 = 800;
const 路径半径 = 100;
const 整体伤害半径 = 200;
const 路径持续时间 = 10;
const 周期伤害 = 30;
const 检测间隔 = 1.0;
const 铺设间隔 = 0.05;
const 段间距 = 100;
function 地面路径持续区域测试_单段创建(段序号, X, Y) {
    debugLogForce(模块名, "已铺设火焰段：序号=", 段序号, " 坐标=(", X, ",", Y, ")");
}
function 地面路径持续区域测试_全部铺设完成(实例ID) {
    debugLogForce(模块名, "火焰路径铺设完成：实例ID=", 实例ID);
}
function 地面路径持续区域测试_销毁(实例ID) {
    debugLogForce(模块名, "火焰路径已销毁：实例ID=", 实例ID);
}
function on聊天1009测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    const 起点X = GetUnitX(大法师);
    const 起点Y = GetUnitY(大法师);
    const 方向角 = GetUnitFacing(大法师);
    const 实例 = 创建火焰路径持续区域({
        起点X,
        起点Y,
        方向角,
        路径长度,
        路径半径,
        区域持续时间: 路径持续时间,
        伤害模式: "整体矩形",
        段间距,
        铺设间隔,
        检测间隔,
        周期伤害,
        整体伤害长度: 路径长度,
        整体伤害半径,
        影响目标: "敌方",
        所有者: 大法师,
        显示提示圈: false,
        on单段创建: 地面路径持续区域测试_单段创建,
        on全部铺设完成: 地面路径持续区域测试_全部铺设完成,
        on销毁: 地面路径持续区域测试_销毁,
    });
    debugLogForce(模块名, "已启动火焰路径测试：实例ID=", 实例.实例ID, " 起点=(", 起点X, ",", 起点Y, ") 方向角=", 方向角, " 长度=", 路径长度, " 火焰半径=", 路径半径, " 整体伤害半径=", 整体伤害半径, " 持续时间=", 路径持续时间, " 周期伤害=", 周期伤害);
}
注册聊天命令监听(测试命令, on聊天1009测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "触发火焰路径持续区域");
