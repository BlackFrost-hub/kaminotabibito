/** @noSelfInFile */
/**
 * 重伤系统 装备测试
 *
 * 输入 "1023"：给玩家1英雄设置50%装备重伤，攻击任何敌人即可触发重伤buff
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const { 获取单位重伤 } = require("系统.04．伤害系统.03．重伤系统.index");
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统");
const { YDUserDataSetSafe, YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const GetOwningPlayer = jass.GetOwningPlayer;
const WOUND_BUFF_ID = "C021";
const 模块名 = "重伤装备测试";
const 测试命令 = "1023";
function 写入YD用户数据(tableType, tableKey, attr, valueType, value) {
    YDUserDataSetSafe(tableType, tableKey, attr, valueType, value);
}
function 读取YD用户数据(tableType, tableKey, attr, valueType) {
    return YDUserDataGetSafe(tableType, tableKey, attr, valueType);
}
function on聊天测试() {
    debugLogForce(模块名, "===== 重伤装备测试 =====");
    const 英雄 = g.gg_unit_Hamg_0002;
    if (英雄 == null || 英雄 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    debugLogForce(模块名, "英雄handle：", 英雄);
    // 设置装备重伤50%（英雄走玩家）
    const owner = GetOwningPlayer(英雄);
    debugLogForce(模块名, "英雄owner：", owner);
    写入YD用户数据("player", owner, "重伤", "real", 0.5);
    debugLogForce(模块名, "已设置英雄装备重伤：", 读取YD用户数据("player", owner, "重伤", "real"));
    debugLogForce(模块名, "===== 请攻击任意敌人 =====");
    debugLogForce(模块名, "攻击后敌人会获得重伤buff");
    debugLogForce(模块名, "tooltip应显示'治疗效果降低50%'");
}
注册聊天命令监听(测试命令, on聊天测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令);
export {};
