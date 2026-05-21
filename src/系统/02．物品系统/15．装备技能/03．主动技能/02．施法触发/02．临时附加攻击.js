/** @noSelfInFile */
const jass = require("jass.common");
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS");
const CreateTimer = jass.CreateTimer;
const GetExpiredTimer = jass.GetExpiredTimer;
const GetHandleId = jass.GetHandleId;
const DestroyTimer = jass.DestroyTimer;
const TimerStart = jass.TimerStart;
const 临时附加攻击计时器表 = {};
function 绝对值(数值) {
    return 数值 >= 0 ? 数值 : -数值;
}
function 调整单位附加攻击(单位, 数值) {
    if (单位 == null || 单位 === 0)
        return;
    if (数值 === 0)
        return;
    SGSS_SetState(单位, 1, 数值);
}
function on临时附加攻击结束() {
    const 计时器 = GetExpiredTimer();
    if (计时器 == null || 计时器 === 0)
        return;
    const 计时器ID = GetHandleId(计时器);
    const 实例 = 临时附加攻击计时器表[计时器ID];
    delete 临时附加攻击计时器表[计时器ID];
    DestroyTimer(计时器);
    if (实例 == null)
        return;
    调整单位附加攻击(实例.单位, -绝对值(实例.数值));
}
export function 施加临时附加攻击(单位, 数值, 持续时间) {
    if (单位 == null || 单位 === 0)
        return;
    if (数值 === 0 || !(持续时间 > 0))
        return;
    调整单位附加攻击(单位, 数值);
    const 计时器 = CreateTimer();
    const 计时器ID = GetHandleId(计时器);
    临时附加攻击计时器表[计时器ID] = {
        单位,
        数值,
    };
    TimerStart(计时器, 持续时间, false, on临时附加攻击结束);
}
