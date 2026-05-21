/** @noSelfInFile */
/**
 * 暗影突袭追踪测试
 *
 * 输入 "1042"
 * - 直接调用 创建暗影突袭追踪
 * - source: gg_unit_Hamg_0002
 * - target: gg_unit_ogru_0019
 */
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const { 创建暗影突袭追踪 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.01．暗影突袭");
const 模块名 = "暗影突袭追踪测试";
const 测试命令 = "1042";
function 执行1042暗影突袭追踪测试() {
    const source = g.gg_unit_Hamg_0002;
    const target = g.gg_unit_ogru_0019;
    if (source == null || source === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    if (target == null || target === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_ogru_0019");
        return;
    }
    debugLogForce(模块名, "直接调用 创建暗影突袭追踪", "source:", source, "target:", target);
    创建暗影突袭追踪(source, target, {
        减益: { duration: 2.0, damagePerSecond: 500 },
    });
}
function on聊天1042() {
    执行1042暗影突袭追踪测试();
}
注册聊天命令监听(测试命令, on聊天1042);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "直接测试暗影突袭追踪封装");
export {};
