/** @noSelfInFile */
/**
 * 单位倒计时系统测试
 *
 * 输入 1029：普通倒计时
 * 输入 1030：强化2倒计时
 * 输入 1031：暂停倒计时测试
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const { 启动单位倒计时 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.17．单位倒计时.04．对外接口");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const PauseUnit = jass.PauseUnit;
const 模块名 = "单位倒计时测试";
const 普通倒计时命令 = "1029";
const 强化倒计时命令 = "1030";
const 暂停倒计时命令 = "1031";
let 暂停测试单位 = null;
function 获取测试单位() {
    return g.gg_unit_Hamg_0002 ?? globalThis.bj_lastCreatedUnit;
}
function 启动普通倒计时测试() {
    const unit = 获取测试单位();
    if (unit == null || unit === 0) {
        debugLogForce(模块名, "普通测试失败：找不到测试单位");
        return;
    }
    const id = 启动单位倒计时({
        单位: unit,
        持续时间: 3.0,
        X: GetUnitX(unit),
        Y: GetUnitY(unit),
        到期效果ID: 0,
    });
    debugLogForce(模块名, "普通倒计时启动", "id=", id, "unit=", unit);
}
function 启动强化倒计时测试() {
    const unit = 获取测试单位();
    if (unit == null || unit === 0) {
        debugLogForce(模块名, "强化测试失败：找不到测试单位");
        return;
    }
    const id = 启动单位倒计时({
        单位: unit,
        持续时间: 3.0,
        X: GetUnitX(unit),
        Y: GetUnitY(unit),
        到期效果ID: 2,
        强化持续时间: 8.0,
        强化生命值: 300,
        强化模型: "",
        强化单位类型: "hfoo",
    });
    debugLogForce(模块名, "强化2倒计时启动", "id=", id, "unit=", unit);
}
function on恢复暂停测试单位() {
    if (暂停测试单位 == null || 暂停测试单位 === 0)
        return;
    PauseUnit(暂停测试单位, false);
    debugLogForce(模块名, "暂停测试单位已恢复");
    暂停测试单位 = null;
}
function 启动暂停倒计时测试() {
    const unit = 获取测试单位();
    if (unit == null || unit === 0) {
        debugLogForce(模块名, "暂停测试失败：找不到测试单位");
        return;
    }
    暂停测试单位 = unit;
    PauseUnit(unit, true);
    const id = 启动单位倒计时({
        单位: unit,
        持续时间: 2.0,
        X: GetUnitX(unit),
        Y: GetUnitY(unit),
        到期效果ID: 0,
    });
    addDelayedCallback(2000, on恢复暂停测试单位);
    debugLogForce(模块名, "暂停倒计时启动：单位暂停2秒，倒计时应暂停推进", "id=", id);
}
function on普通倒计时聊天命令() {
    启动普通倒计时测试();
}
function on强化倒计时聊天命令() {
    启动强化倒计时测试();
}
function on暂停倒计时聊天命令() {
    启动暂停倒计时测试();
}
注册聊天命令监听(普通倒计时命令, on普通倒计时聊天命令);
注册聊天命令监听(强化倒计时命令, on强化倒计时聊天命令);
注册聊天命令监听(暂停倒计时命令, on暂停倒计时聊天命令);
debugLogForce(模块名, "已注册：1029普通倒计时，1030强化2倒计时，1031暂停倒计时");
export {};
