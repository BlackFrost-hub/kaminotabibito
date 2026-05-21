/** @noSelfInFile */
/**
 * 扩展控制测试
 *
 * 输入 "1024"：
 * - 让大法师周围1000码内的第一个敌人，对大法师施加5秒魅惑
 * - 验证大法师会失去控制并贴身跟随敌人
 *
 * 输入 "1025"：
 * - 让大法师周围1000码内的第一个敌人，对大法师施加5秒恐惧（逃离施法者）
 * - 验证大法师会持续逃离敌人
 *
 * 输入 "1026"：
 * - 让大法师周围1000码内的第一个敌人，对大法师施加5秒恐惧（随机乱跑）
 * - 验证大法师会持续随机移动
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const 扩展控制系统 = require("../01．技能函数/16．扩展控制/index");
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const 模块名 = "扩展控制测试";
const 魅惑命令 = "1024";
const 恐惧逃离命令 = "1025";
const 恐惧随机命令 = "1026";
function 施加单体魅惑(来源单位, 目标单位, 参数) {
    return 扩展控制系统["施加魅惑"](来源单位, 目标单位, 参数);
}
function 施加单体恐惧(来源单位, 目标单位, 参数) {
    return 扩展控制系统["施加恐惧"](来源单位, 目标单位, 参数);
}
function 获取测试目标() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return null;
    }
    const x = GetUnitX(大法师);
    const y = GetUnitY(大法师);
    const 敌人列表 = getEnemyUnitsInRange(大法师, x, y, 1000);
    const 第一个敌人 = 敌人列表[0];
    if (第一个敌人 == null || 第一个敌人 === 0) {
        debugLogForce(模块名, "错误：大法师周围1000码内没有敌人");
        return null;
    }
    return { 大法师, 敌人: 第一个敌人 };
}
function on魅惑测试() {
    const 上下文 = 获取测试目标();
    if (上下文 == null)
        return;
    const 结果 = 施加单体魅惑(上下文.敌人, 上下文.大法师, {
        持续时间: 5,
        跟随半径: 140,
    });
    debugLogForce(模块名, "魅惑结果=", 结果, "来源=", 上下文.敌人, "目标=gg_unit_Hamg_0002");
}
function on恐惧逃离测试() {
    const 上下文 = 获取测试目标();
    if (上下文 == null)
        return;
    const 结果 = 施加单体恐惧(上下文.敌人, 上下文.大法师, {
        持续时间: 5,
        模式: "逃离施法者",
        逃离距离: 550,
    });
    debugLogForce(模块名, "恐惧逃离结果=", 结果, "来源=", 上下文.敌人, "目标=gg_unit_Hamg_0002");
}
function on恐惧随机测试() {
    const 上下文 = 获取测试目标();
    if (上下文 == null)
        return;
    const 结果 = 施加单体恐惧(上下文.敌人, 上下文.大法师, {
        持续时间: 5,
        模式: "随机乱跑",
        随机半径: 450,
    });
    debugLogForce(模块名, "恐惧随机结果=", 结果, "来源=", 上下文.敌人, "目标=gg_unit_Hamg_0002");
}
注册聊天命令监听(魅惑命令, on魅惑测试);
注册聊天命令监听(恐惧逃离命令, on恐惧逃离测试);
注册聊天命令监听(恐惧随机命令, on恐惧随机测试);
debugLogForce(模块名, "已注册测试：输入", 魅惑命令, "让周围第一个敌人魅惑大法师");
debugLogForce(模块名, "已注册测试：输入", 恐惧逃离命令, "让周围第一个敌人恐惧大法师-逃离施法者");
debugLogForce(模块名, "已注册测试：输入", 恐惧随机命令, "让周围第一个敌人恐惧大法师-随机乱跑");
export {};
