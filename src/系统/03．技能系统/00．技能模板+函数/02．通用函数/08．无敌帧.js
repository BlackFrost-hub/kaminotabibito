/** @noSelfInFile */
/**
 * 通用函数 - 无敌帧
 *
 * 说明：
 * - 使用 `SetUnitInvulnerable` 直接控制单位无敌。
 * - 支持多个来源重叠：每次施加都会创建独立实例，直到最后一个实例结束才取消无敌。
 * - 这不是简单“秒数相加”，也不是“只取最高一次覆盖”，而是按来源独立计时。
 */
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器");
const jass = require("jass.common");
const SetUnitInvulnerable = jass.SetUnitInvulnerable;
const GetHandleId = jass.GetHandleId;
const GetUnitTypeId = jass.GetUnitTypeId;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const DestroyEffect = jass.DestroyEffect;
const DEFAULT_INVULNERABLE_EFFECT = "Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl";
let 下一个无敌ID = 1;
const 活跃无敌实例 = [];
const 单位无敌层数 = {};
const 单位无敌特效 = {};
let 无敌Tick已启动 = false;
function 获取单位当前无敌层数(单位句柄ID) {
    return 单位无敌层数[单位句柄ID] ?? 0;
}
function 设置单位当前无敌层数(单位句柄ID, 层数) {
    if (层数 <= 0) {
        delete 单位无敌层数[单位句柄ID];
        return;
    }
    单位无敌层数[单位句柄ID] = 层数;
}
function 单位仍可操作(单位) {
    return 单位 != null && GetUnitTypeId(单位) !== 0;
}
function 创建单位无敌特效(单位, 单位句柄ID) {
    if (!单位仍可操作(单位))
        return;
    if (单位无敌特效[单位句柄ID] != null)
        return;
    单位无敌特效[单位句柄ID] = AddSpecialEffectTarget(DEFAULT_INVULNERABLE_EFFECT, 单位, "origin");
}
function 销毁单位无敌特效(单位句柄ID) {
    const effect = 单位无敌特效[单位句柄ID];
    if (effect == null)
        return;
    DestroyEffect(effect);
    delete 单位无敌特效[单位句柄ID];
}
function 确保无敌Tick启动() {
    if (无敌Tick已启动)
        return;
    无敌Tick已启动 = true;
    onTick10ms(无敌Tick);
}
function 尝试关闭无敌Tick() {
    if (活跃无敌实例.length > 0 || !无敌Tick已启动)
        return;
    无敌Tick已启动 = false;
    offTick10ms(无敌Tick);
}
function 移除无敌实例(index) {
    const 实例 = 活跃无敌实例[index];
    const 当前层数 = 获取单位当前无敌层数(实例.单位句柄ID);
    const 剩余层数 = 当前层数 - 1;
    设置单位当前无敌层数(实例.单位句柄ID, 剩余层数);
    if (剩余层数 <= 0 && 单位仍可操作(实例.单位)) {
        SetUnitInvulnerable(实例.单位, false);
        销毁单位无敌特效(实例.单位句柄ID);
    }
    if (剩余层数 <= 0 && !单位仍可操作(实例.单位)) {
        销毁单位无敌特效(实例.单位句柄ID);
    }
    活跃无敌实例.splice(index, 1);
}
function 无敌Tick() {
    for (let i = 活跃无敌实例.length - 1; i >= 0; i--) {
        const 实例 = 活跃无敌实例[i];
        if (!实例.激活) {
            移除无敌实例(i);
            continue;
        }
        if (!单位仍可操作(实例.单位)) {
            实例.激活 = false;
            移除无敌实例(i);
            continue;
        }
        实例.剩余秒数 -= 0.01;
        if (实例.剩余秒数 <= 0) {
            实例.激活 = false;
            移除无敌实例(i);
        }
    }
    尝试关闭无敌Tick();
}
export function 开始无敌帧(单位, 持续时间) {
    if (单位 == null || 持续时间 <= 0)
        return 0;
    const 单位句柄ID = GetHandleId(单位);
    const 新实例 = {
        id: 下一个无敌ID++,
        单位,
        单位句柄ID,
        剩余秒数: 持续时间,
        激活: true,
    };
    活跃无敌实例.push(新实例);
    设置单位当前无敌层数(单位句柄ID, 获取单位当前无敌层数(单位句柄ID) + 1);
    if (单位仍可操作(单位)) {
        SetUnitInvulnerable(单位, true);
        创建单位无敌特效(单位, 单位句柄ID);
    }
    确保无敌Tick启动();
    return 新实例.id;
}
export function 取消无敌帧(无敌ID) {
    for (let i = 活跃无敌实例.length - 1; i >= 0; i--) {
        const 实例 = 活跃无敌实例[i];
        if (实例.id !== 无敌ID)
            continue;
        实例.激活 = false;
        移除无敌实例(i);
        尝试关闭无敌Tick();
        return true;
    }
    return false;
}
export function 取消单位所有无敌帧(单位) {
    if (单位 == null)
        return false;
    const 单位句柄ID = GetHandleId(单位);
    let 已取消 = false;
    for (let i = 活跃无敌实例.length - 1; i >= 0; i--) {
        const 实例 = 活跃无敌实例[i];
        if (实例.单位句柄ID !== 单位句柄ID)
            continue;
        实例.激活 = false;
        移除无敌实例(i);
        已取消 = true;
    }
    尝试关闭无敌Tick();
    return 已取消;
}
export function 单位是否处于无敌帧中(单位) {
    if (单位 == null)
        return false;
    return 获取单位当前无敌层数(GetHandleId(单位)) > 0;
}
export function 获取单位无敌帧层数(单位) {
    if (单位 == null)
        return 0;
    return 获取单位当前无敌层数(GetHandleId(单位));
}
