/** @noSelfInFile */
/**
 * JASS随机数测试
 *
 * 输入 1038：
 * - 连续打印 10 次 GetRandomInt(1, 100)
 * - 连续打印 10 次 GetRandomReal(0, 1)
 *
 * 目的：排查是不是引擎随机数本身被固定。
 */
const jass = require("jass.common");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const GetRandomInt = jass.GetRandomInt;
const GetRandomReal = jass.GetRandomReal;
const 模块名 = "JASS随机数测试";
const 测试命令 = "1038";
function on聊天1038测试() {
    const 整数结果 = [];
    const 实数结果 = [];
    for (let i = 0; i < 10; i++) {
        整数结果.push(GetRandomInt(1, 100).toString());
    }
    for (let i = 0; i < 10; i++) {
        实数结果.push(GetRandomReal(0, 1).toString());
    }
    debugLogForce(模块名, "GetRandomInt(1,100) x10 =", 整数结果.join(","));
    debugLogForce(模块名, "GetRandomReal(0,1) x10 =", 实数结果.join(","));
}
注册聊天命令监听(测试命令, on聊天1038测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "打印JASS随机数序列");
export {};
