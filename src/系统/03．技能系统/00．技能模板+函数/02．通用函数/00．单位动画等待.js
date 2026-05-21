/** @noSelfInFile */
/**
 * 单位动画等待通用函数。
 * 用途：播放单位动画、延迟播放单位动画、等待指定秒数后执行下一步。
 * 也可用于纯技能阶段延迟，不依赖单位动画。
 */
const jass = require("jass.common");
const { EXSetUnitFacing } = require("lib.扩展函数.YDWE函数.00．YDWE函数");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
const 动画等待上下文表 = {};
function 重置单位待机动画(单位) {
    if (单位 == null || 单位 === 0)
        return;
    jass.SetUnitAnimation(单位, "stand");
}
function 播放上下文动画(ctx) {
    if (ctx.单位 == null || ctx.单位 === 0)
        return;
    if (typeof ctx.动画序号 === "number") {
        jass.SetUnitAnimationByIndex(ctx.单位, ctx.动画序号);
        return;
    }
    if (typeof ctx.动画名 === "string" && ctx.动画名 !== "") {
        jass.SetUnitAnimation(ctx.单位, ctx.动画名);
        return;
    }
    重置单位待机动画(ctx.单位);
}
function on单位动画等待到期() {
    const t = jass.GetExpiredTimer();
    if (!t)
        return;
    const hid = jass.GetHandleId(t);
    const ctx = 动画等待上下文表[hid];
    delete 动画等待上下文表[hid];
    safeDestroyTimer(t);
    if (!ctx)
        return;
    播放上下文动画(ctx);
    if (ctx.恢复待机 === true && ctx.单位 != null && ctx.单位 !== 0) {
        jass.SetUnitAnimationByIndex(ctx.单位, 0);
    }
    if (typeof ctx.下一步 === "function") {
        ctx.下一步();
    }
}
function 创建动画等待计时器(ctx, 等待秒数) {
    const t = jass.CreateTimer();
    if (!t)
        return null;
    动画等待上下文表[jass.GetHandleId(t)] = ctx;
    safeTimerStart(t, 等待秒数, false, on单位动画等待到期);
    return t;
}
export function 播放单位动画并等待(单位, 动画序号, 等待秒数, 下一步) {
    if (单位 == null || 单位 === 0)
        return null;
    if (等待秒数 < 0)
        等待秒数 = 0;
    jass.SetUnitAnimationByIndex(单位, 动画序号);
    return 创建动画等待计时器({ 单位, 下一步 }, 等待秒数);
}
export function 播放单位动作并等待(单位, 动画名, 等待秒数, 下一步) {
    if (单位 == null || 单位 === 0)
        return null;
    if (!动画名 || 动画名 === "")
        return null;
    if (等待秒数 < 0)
        等待秒数 = 0;
    jass.SetUnitAnimation(单位, 动画名);
    return 创建动画等待计时器({ 单位, 下一步 }, 等待秒数);
}
export function 播放单位动画并等待后恢复待机(单位, 动画序号, 等待秒数, 下一步) {
    if (单位 == null || 单位 === 0)
        return null;
    if (等待秒数 < 0)
        等待秒数 = 0;
    jass.SetUnitAnimationByIndex(单位, 动画序号);
    return 创建动画等待计时器({
        单位,
        恢复待机: true,
        下一步,
    }, 等待秒数);
}
export function 延迟播放单位动画(单位, 动画序号, 延迟秒数, 下一步) {
    if (单位 == null || 单位 === 0)
        return null;
    if (延迟秒数 < 0)
        延迟秒数 = 0;
    return 创建动画等待计时器({
        单位,
        动画序号,
        下一步,
    }, 延迟秒数);
}
export function 延迟播放单位动作(单位, 动画名, 延迟秒数, 下一步) {
    if (单位 == null || 单位 === 0)
        return null;
    if (!动画名 || 动画名 === "")
        return null;
    if (延迟秒数 < 0)
        延迟秒数 = 0;
    return 创建动画等待计时器({
        单位,
        动画名,
        下一步,
    }, 延迟秒数);
}
export function 零秒后播放单位动画(单位, 动画序号, 下一步) {
    return 延迟播放单位动画(单位, 动画序号, 0.0, 下一步);
}
export function 零秒后播放单位动作(单位, 动画名, 下一步) {
    return 延迟播放单位动作(单位, 动画名, 0.0, 下一步);
}
export function 零秒后重置单位动画(单位, 下一步) {
    if (单位 == null || 单位 === 0)
        return null;
    return 创建动画等待计时器({
        单位,
        下一步,
    }, 0.0);
}
/**
 * 立即设置单位朝向。
 *
 * 说明：
 * - 技能层统一传角度制，与 `GetUnitFacing` / `SetUnitFacing` 保持一致。
 * - 内部会同步调用 `EXSetUnitFacing`，用弧度制立即修正朝向。
 */
export function 立即设置单位朝向(单位, 朝向角度) {
    if (单位 == null || 单位 === 0)
        return;
    jass.SetUnitFacing(单位, 朝向角度);
    EXSetUnitFacing(单位, 朝向角度 * jass.bj_DEGTORAD);
}
export function 技能延迟执行(延迟秒数, 下一步) {
    if (延迟秒数 < 0)
        延迟秒数 = 0;
    return 创建动画等待计时器({
        下一步,
    }, 延迟秒数);
}
