/** @noSelfInFile */
const jass = require("jass.common");
const g = require("jass.globals");
const Player = jass.Player;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitName = jass.GetUnitName;
const GetHandleId = jass.GetHandleId;
const CreateTimer = jass.CreateTimer;
const DestroyTimer = jass.DestroyTimer;
const GetExpiredTimer = jass.GetExpiredTimer;
const TimerStart = jass.TimerStart;
const R2SW = jass.R2SW;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer;
const { SFB_施加通用Buff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const 启用测试 = false;
function 调试输出(message, duration = 5) {
    debugLogForce("快速Buff测试", message);
    for (let pi = 0; pi < 4; pi++) {
        DisplayTimedTextToPlayer(Player(pi), 0, 0, duration, "[快速Buff测试] " + message);
    }
}
function 测试_眩晕目标() {
    const 目标单位 = g.gg_unit_Hamg_0002;
    if (目标单位 == null || 目标单位 === 0) {
        调试输出("错误: gg_unit_Hamg_0002 不存在！请检查地图中是否有该预置单位。", 10);
        return;
    }
    const 单位名 = GetUnitName(目标单位);
    const hid = GetHandleId(目标单位);
    const x = GetUnitX(目标单位);
    const y = GetUnitY(目标单位);
    调试输出("目标单位: " + 单位名 + " (handleId=" + hid + ", x=" + R2SW(x, 0, 1) + ", y=" + R2SW(y, 0, 1) + ")");
    调试输出("正在施加眩晕Buff (id=0, 持续3秒)...");
    SFB_施加通用Buff(目标单位, 目标单位, 0, 3.0);
    调试输出("眩晕Buff已施加！请观察单位是否被眩晕。");
}
function 启动快速Buff测试() {
    const t = GetExpiredTimer();
    if (t != null)
        DestroyTimer(t);
    调试输出("=== 快速Buff系统测试开始 ===");
    调试输出("正在对 gg_unit_Hamg_0002 施加眩晕...");
    测试_眩晕目标();
}
if (启用测试) {
    const 启动计时器 = CreateTimer();
    TimerStart(启动计时器, 1.0, false, 启动快速Buff测试);
}
export {};
