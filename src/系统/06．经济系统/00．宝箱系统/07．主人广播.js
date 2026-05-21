/** @noSelfInFile */
const jass = require("jass.common");
const { 广播提示玩家槽数, 广播提示喇叭头像 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义");
const { 发送头像提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index");
const { 取单位类型Art头像 } = require("系统.09．表现系统.06．广播提示消息.01．头像读取");
const Player = jass.Player;
const GetUnitTypeId = jass.GetUnitTypeId;
export function 广播单位类型提示(单位类型ID, 文本, 持续时间) {
    if (!单位类型ID || !文本)
        return;
    const Art头像路径 = 取单位类型Art头像(单位类型ID);
    const 头像路径 = Art头像路径 !== "" ? Art头像路径 : 广播提示喇叭头像;
    for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
        发送头像提示给玩家(Player(玩家ID), 头像路径, 文本, 持续时间);
    }
}
export function 广播宝箱主人提示(主人单位, 文本, 持续时间) {
    if (!主人单位)
        return;
    广播单位类型提示(GetUnitTypeId(主人单位), 文本, 持续时间);
}
export { 广播单位类型提示 as broadcastUnitTypeHint, 广播宝箱主人提示 as broadcastChestOwnerHint, };
