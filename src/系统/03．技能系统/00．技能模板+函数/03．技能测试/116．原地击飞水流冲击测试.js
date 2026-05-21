/** @noSelfInFile */
/**
 * 原地击飞水流冲击测试
 *
 * 输入 "1016"：
 * - 在 gg_unit_Hamg_0002 脚下持续创建娜迦死亡特效。
 * - 将大法师原地顶飞，Z 高度在 200-250 间随机抖动。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 开始原地击飞 } from "../01．技能函数/03．跳跃·击飞/index";
const 模块名 = "原地击飞水流冲击测试";
const 测试命令 = "1016";
const 娜迦死亡特效 = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl";
function 原地击飞_结束(单位, 原因, 击飞ID) {
    debugLogForce(模块名, "结束", "原因=", 原因, "击飞ID=", 击飞ID);
}
function on聊天1016测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    const 击飞ID = 开始原地击飞(大法师, {
        持续时间: 3.0,
        最小高度: 200,
        最大高度: 250,
        冲击波模型: 娜迦死亡特效,
        持续特效模型: 娜迦死亡特效,
        持续特效间隔: 0.08,
        结束回调: 原地击飞_结束,
    });
    debugLogForce(模块名, "开始", "击飞ID=", 击飞ID, "特效=", 娜迦死亡特效);
}
注册聊天命令监听(测试命令, on聊天1016测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "开始原地击飞水流冲击测试");
