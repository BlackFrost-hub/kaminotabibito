/** @noSelfInFile */
/**
 * 诅咒命中率测试
 *
 * 输入 "1020"：
 * - 先把玩家1与大法师的“命中率”都清成 0（即默认 100%）
 * - 再对 gg_unit_Hamg_0002 施加 3 秒诅咒
 * - 立即/到期后分别打印单位命中率属性值与“显示命中率”
 *
 * 说明：
 * - YDUserData 的“命中率”是相对 100% 的偏移量
 * - 0   = 100%
 * - 0.2 = 120%
 * - -0.33 = 67%
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const { SFB_setCurse } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统");
const YDUserDataGet = YDUserDataGetSafe;
const YDUserDataSet = YDUserDataSetSafe;
const GetOwningPlayer = jass.GetOwningPlayer;
const GetPlayerId = jass.GetPlayerId;
const CreateTimer = jass.CreateTimer;
const DestroyTimer = jass.DestroyTimer;
const TimerStart = jass.TimerStart;
const GetExpiredTimer = jass.GetExpiredTimer;
const GetHandleId = jass.GetHandleId;
const 模块名 = "诅咒命中率测试";
const 测试命令 = "1020";
const ATTR_命中率 = "命中率";
const BUFF_持续时间 = 3.0;
const 到期检查上下文 = {};
function 归一化实数(value) {
    if (value == null || value === false || value === "")
        return 0;
    const n = typeof value === "number" ? value : Number(value);
    return n !== n ? 0 : n;
}
function 读取单位命中率偏移(unit) {
    if (unit == null || unit === 0)
        return 0;
    return 归一化实数(YDUserDataGet("unit", unit, ATTR_命中率, "real"));
}
function 读取玩家命中率偏移(player) {
    if (player == null || player === 0)
        return 0;
    return 归一化实数(YDUserDataGet("player", player, ATTR_命中率, "real"));
}
function 读取有效命中率偏移(unit) {
    if (unit == null || unit === 0)
        return 0;
    const unitValue = 读取单位命中率偏移(unit);
    if (unitValue !== 0)
        return unitValue;
    return 读取玩家命中率偏移(GetOwningPlayer(unit));
}
function 命中率偏移转显示文本(value) {
    return ((1 + value) * 100).toFixed(0) + "%";
}
function 是否走玩家命中率(unit) {
    const owner = GetOwningPlayer(unit);
    if (owner == null || owner === 0)
        return false;
    const playerId = GetPlayerId(owner);
    return playerId >= 0 && playerId <= 3;
}
function 打印命中率状态(stage, unit) {
    const owner = GetOwningPlayer(unit);
    const unitOffset = 读取单位命中率偏移(unit);
    const playerOffset = 读取玩家命中率偏移(owner);
    const effectiveOffset = 读取有效命中率偏移(unit);
    const mode = 是否走玩家命中率(unit) ? "玩家" : "单位";
    debugLogForce(模块名, stage, "诅咒目标层=", mode, "单位偏移=", unitOffset, "玩家偏移=", playerOffset, "有效偏移=", effectiveOffset, "显示命中率=", 命中率偏移转显示文本(effectiveOffset));
}
function on诅咒到期检查() {
    const timer = GetExpiredTimer();
    const timerId = GetHandleId(timer);
    const target = 到期检查上下文[timerId];
    if (target != null && target !== 0) {
        打印命中率状态("诅咒到期后", target);
    }
    delete 到期检查上下文[timerId];
    DestroyTimer(timer);
}
function 安排到期检查(unit, timeout) {
    const timer = CreateTimer();
    const timerId = GetHandleId(timer);
    到期检查上下文[timerId] = unit;
    TimerStart(timer, timeout, false, on诅咒到期检查);
}
function on聊天测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    const owner = GetOwningPlayer(大法师);
    YDUserDataSet("player", owner, ATTR_命中率, "real", 0);
    YDUserDataSet("unit", 大法师, ATTR_命中率, "real", 0);
    打印命中率状态("施加前", 大法师);
    SFB_setCurse(大法师, 大法师, BUFF_持续时间);
    打印命中率状态("诅咒施加后", 大法师);
    安排到期检查(大法师, BUFF_持续时间 + 0.10);
    debugLogForce(模块名, "已施加3秒诅咒，预期：100% -> 67% -> 100%");
}
注册聊天命令监听(测试命令, on聊天测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "测试自定义诅咒命中率");
export {};
