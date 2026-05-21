/** @noSelfInFile */
const jass = require("jass.common");
const g = require("jass.globals");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const 模块名 = "装备死亡事件测试";
const 测试命令 = "1039";
const 测试装备名列表 = [
    "小颅盾（唯一）",
    "斯尔能量之心",
    "德鲁伊指引灯笼（魔猎）",
    "德鲁伊指引灯笼（智识）",
];
function 创建并给予装备(单位, 装备名) {
    const 物品ID = 按名字反查物品ID(装备名);
    if (物品ID == null || 物品ID === "") {
        debugLogForce(模块名, "未找到装备", 装备名);
        return;
    }
    const x = jass.GetUnitX(单位);
    const y = jass.GetUnitY(单位);
    const item = jass.CreateItem(stringToFourCC(物品ID), x, y);
    if (item == null || item === 0) {
        debugLogForce(模块名, "创建物品失败", 装备名, 物品ID);
        return;
    }
    jass.UnitAddItem(单位, item);
}
function on聊天1039测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
        return;
    }
    for (const 装备名 of 测试装备名列表) {
        创建并给予装备(大法师, 装备名);
    }
    debugLogForce(模块名, "已给予大法师死亡事件测试装备");
}
注册聊天命令监听(测试命令, on聊天1039测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "给予大法师死亡事件装备");
export {};
