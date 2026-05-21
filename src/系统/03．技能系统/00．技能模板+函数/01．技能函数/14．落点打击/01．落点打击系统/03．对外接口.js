/** @noSelfInFile */
/**
 * 落点打击系统 - 定时器管理、实例生命周期与对外接口
 */
import { CreateTimer, GetExpiredTimer, GetHandleId, 落点打击实例表, 落点打击定时器上下文表, 推进下一个落点打击ID, } from "./00．共享";
import { 创建落点列表 } from "./01．落点生成";
import { 结算单次落点伤害, 创建落点提示特效 } from "./02．特效与伤害";
const { safeTimerStart, safeDestroyTimer, } = require("系统.00．核心系统.07．联机安全工具");
const { 创建命中规则状态 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则");
function 结束落点打击实例(实例ID) {
    const 实例 = 落点打击实例表[实例ID];
    if (实例 == null) {
        return;
    }
    delete 落点打击实例表[实例ID];
    实例.参数.on全部完成?.(实例ID);
}
function on落点打击定时器到时() {
    const t = GetExpiredTimer();
    if (!t) {
        return;
    }
    const 定时器ID = GetHandleId(t);
    const 上下文 = 落点打击定时器上下文表[定时器ID];
    delete 落点打击定时器上下文表[定时器ID];
    safeDestroyTimer(t);
    if (上下文 == null) {
        return;
    }
    const 实例 = 落点打击实例表[上下文.实例ID];
    if (实例 == null) {
        return;
    }
    结算单次落点伤害(实例, 上下文.落点序号);
    实例.剩余落点数 -= 1;
    if (实例.剩余落点数 <= 0) {
        结束落点打击实例(实例.id);
    }
}
function 启动单个落点计时器(实例ID, 落点序号, 延迟) {
    const t = CreateTimer();
    if (!t) {
        return;
    }
    落点打击定时器上下文表[GetHandleId(t)] = {
        实例ID,
        落点序号,
    };
    safeTimerStart(t, 延迟, false, on落点打击定时器到时);
}
export function 创建落点打击(参数) {
    if (参数.伤害半径 <= 0) {
        return 0;
    }
    const 落点列表 = 创建落点列表(参数);
    if (落点列表.length <= 0) {
        return 0;
    }
    const 实例ID = 推进下一个落点打击ID();
    const 实例 = {
        id: 实例ID,
        参数,
        落点列表,
        剩余落点数: 落点列表.length,
        命中规则状态: 创建命中规则状态({
            每单位最大命中次数: 参数.每单位最大命中次数,
        }),
    };
    落点打击实例表[实例ID] = 实例;
    let i = 0;
    while (i < 落点列表.length) {
        const 落点 = 落点列表[i];
        创建落点提示特效(参数, 落点);
        启动单个落点计时器(实例ID, i, 落点.触发延迟 > 0 ? 落点.触发延迟 : 0);
        i += 1;
    }
    return 实例ID;
}
