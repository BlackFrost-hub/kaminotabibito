/** @noSelfInFile */
/**
 * 隐身 + 破隐一击 测试
 *
 * 输入 "1018"：对大法师施加隐身5秒
 * - 普攻敌人时破隐，附加额外伤害（倍率1.5 + 固定200）
 * - 释放技能时破隐（无额外伤害）
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 施加隐身, 移除隐身, 单位是否隐身中 } from "../01．技能函数/15．隐身/index";
const 模块名 = "隐身破隐测试";
const 测试命令 = "1018";
function on聊天测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    if (单位是否隐身中(大法师)) {
        debugLogForce(模块名, "大法师已隐身中，先移除");
        移除隐身(大法师);
    }
    const 结果 = 施加隐身(大法师, {
        持续时间: 5,
        破隐固定额外伤害: 200,
        破隐伤害倍率: 1.5,
    });
    debugLogForce(模块名, "施加隐身结果=", 结果, "隐身中=", 单位是否隐身中(大法师));
    debugLogForce(模块名, "提示：普攻敌人会破隐附加额外伤害，释放技能也会破隐");
}
注册聊天命令监听(测试命令, on聊天测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "对大法师施加隐身");
