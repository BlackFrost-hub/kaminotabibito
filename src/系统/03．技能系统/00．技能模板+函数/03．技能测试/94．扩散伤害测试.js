/** @noSelfInFile */
/**
 * 扩散伤害测试
 *
 * 输入"1002"后，gg_unit_Hamg_0002 对 gg_unit_hfoo_0021 造成扩散伤害。
 * 这是临时测试文件，后续不用时可直接移除。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 扩散伤害 } from "../01．技能函数/08．扩散伤害/index";
const 模块名 = "扩散伤害测试";
const 测试命令 = "1002";
function on聊天1002测试() {
    const 来源单位 = g.gg_unit_Hamg_0002;
    const 主目标 = g.gg_unit_hfoo_0021;
    if (来源单位 == null || 来源单位 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    if (主目标 == null || 主目标 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_hfoo_0021");
        return;
    }
    扩散伤害({
        来源单位,
        主目标,
        伤害值: 60,
        扩散半径: 300,
        扩散百分比: 0.5,
    });
    debugLogForce(模块名, "已执行扩散伤害，主目标全额500，半径300内敌方扩散250");
}
注册聊天命令监听(测试命令, on聊天1002测试);
