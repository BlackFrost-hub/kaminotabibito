/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { addPeriodicCallback, removePeriodicCallback, addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const jass = require("jass.common");
const japi = require("jass.japi");
const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围");
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const DestroyEffect = jass.DestroyEffect;
const EXSetEffectSize = japi.EXSetEffectSize;
import { 使者魔炉物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者魔炉配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
const 命中率字段 = "命中率";
function 是否为使者魔炉(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 使者魔炉物品ID;
}
function 调整命中率(单位, 变化值) {
    if (单位 == null || 单位 === 0)
        return;
    const 已存值 = YDUserDataGet("unit", 单位, 命中率字段, "real");
    const 当前值 = 已存值 == null ? 0 : 已存值;
    YDUserDataSet("unit", 单位, 命中率字段, "real", 当前值 + 变化值);
}
function on使者魔炉特效放大(上下文) {
    上下文.次数 += 1;
    if (上下文.次数 >= 使者魔炉配置.特效放大次数) {
        removePeriodicCallback(上下文.timerID);
        return;
    }
    EXSetEffectSize(上下文.特效, 使者魔炉配置.特效放大基值 + 上下文.次数);
}
function 启动特效放大(特效) {
    const 上下文 = { 特效, 次数: 0, timerID: 0 };
    上下文.timerID = addPeriodicCallback(使者魔炉配置.特效放大周期 * 1000, () => on使者魔炉特效放大(上下文));
}
function 启动命中恢复(特效, 目标列表) {
    addDelayedCallback(使者魔炉配置.恢复延迟 * 1000, function () {
        for (let i = 0; i < 目标列表.length; i++) {
            调整命中率(目标列表[i], 使者魔炉配置.命中率削减);
        }
        if (特效 != null && 特效 !== 0) {
            DestroyEffect(特效);
        }
    });
}
export function 处理使者魔炉使用(上下文) {
    debugLogForce("18．使者魔炉", "进入", "处理使者魔炉使用");
    if (!是否为使者魔炉(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    const 目标单位 = 上下文.目标单位;
    if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0)
        return;
    const 特效 = AddSpecialEffectTarget(使者魔炉配置.特效路径, 目标单位, 使者魔炉配置.特效挂点);
    if (特效 != null && 特效 !== 0) {
        启动特效放大(特效);
    }
    const 命中目标列表 = [];
    const 敌人列表 = 获取坐标范围敌人(施法单位, GetUnitX(目标单位), GetUnitY(目标单位), 使者魔炉配置.作用范围);
    for (let i = 0; i < 敌人列表.length; i++) {
        const 敌人 = 敌人列表[i];
        if (!单位是否有效且敌对(敌人, 施法单位))
            continue;
        调整命中率(敌人, -使者魔炉配置.命中率削减);
        命中目标列表.push(敌人);
    }
    启动命中恢复(特效, 命中目标列表);
}
