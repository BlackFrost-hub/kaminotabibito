/** @noSelfInFile */
/**
 * 提示特效测试
 *
 * 输入"1003"后，在 gg_unit_Hamg_0002 脚下创建红色圆形提示圈。
 * 这是临时测试文件，后续不用时可直接移除。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 创建薄圆形提示圈 } from "../02．通用函数/09．提示特效";
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const 模块名 = "提示特效测试";
const 测试命令 = "1003";
function on聊天1003测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    const x = GetUnitX(大法师);
    const y = GetUnitY(大法师);
    创建薄圆形提示圈(x, y, 300, 2.0);
    debugLogForce(模块名, "已创建红色圆形提示圈 x=", x, "y=", y, "半径=300");
}
注册聊天命令监听(测试命令, on聊天1003测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "在大法师脚下创建红色圆形提示圈");
