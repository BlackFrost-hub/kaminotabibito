/** @noSelfInFile */
const jass = require("jass.common");
const japi = require("jass.japi");
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数");
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const GetUnitState = jass.GetUnitState;
const GetUnitStateJapi = japi.GetUnitState;
const UnitDamageTarget = jass.UnitDamageTarget;
const IsUnitType = jass.IsUnitType;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitName = jass.GetUnitName;
const AddSpecialEffect = jass.AddSpecialEffect;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const DestroyEffect = jass.DestroyEffect;
const GetRandomReal = jass.GetRandomReal;
const ConvertUnitState = jass.ConvertUnitState;
const 待销毁特效列表 = [];
let 已注册特效销毁驱动 = false;
function 处理待销毁特效() {
    const 当前时间 = getServerTime();
    for (let i = 待销毁特效列表.length - 1; i >= 0; i--) {
        const 记录 = 待销毁特效列表[i];
        if (当前时间 < 记录.到期时间)
            continue;
        DestroyEffect(记录.句柄);
        待销毁特效列表.splice(i, 1);
    }
}
function 安排特效销毁(effect, 持续秒 = 1) {
    if (effect == null || effect === 0)
        return;
    if (!已注册特效销毁驱动) {
        已注册特效销毁驱动 = true;
        addPeriodicCallback(100, 处理待销毁特效);
    }
    待销毁特效列表.push({
        句柄: effect,
        到期时间: getServerTime() + 持续秒 * 1000,
    });
}
export const 伤害事件攻击类型 = {
    普通: jass.ATTACK_TYPE_NORMAL,
    混乱: jass.ATTACK_TYPE_CHAOS,
};
export const 伤害事件伤害类型 = {
    普通: jass.DAMAGE_TYPE_NORMAL,
    强化: jass.DAMAGE_TYPE_ENHANCED,
    魔法: jass.DAMAGE_TYPE_MAGIC,
    火焰: jass.DAMAGE_TYPE_FIRE,
    冰冷: jass.DAMAGE_TYPE_COLD,
    闪电: jass.DAMAGE_TYPE_LIGHTNING,
    毒素: jass.DAMAGE_TYPE_POISON,
    暗影突袭: jass.DAMAGE_TYPE_SHADOW_STRIKE,
    精神: jass.DAMAGE_TYPE_MIND,
    通用: jass.DAMAGE_TYPE_UNIVERSAL,
};
export const 伤害事件武器类型 = jass.WEAPON_TYPE_WHOKNOWS;
export function 单位有效存活(单位) {
    if (单位 == null || 单位 === 0)
        return false;
    return IsUnitType(单位, jass.UNIT_TYPE_DEAD) !== true;
}
export function 单位持有伤害事件装备(单位, 物品ID) {
    if (单位 == null || 单位 === 0 || 物品ID === 0)
        return false;
    return UnitHasItemOfTypeBJ(单位, 物品ID) === true;
}
export function 取当前生命(单位) {
    return GetUnitState(单位, jass.UNIT_STATE_LIFE);
}
export function 取当前魔法(单位) {
    return GetUnitState(单位, jass.UNIT_STATE_MANA);
}
export function 取最大生命(单位) {
    return GetUnitStateJapi(单位, jass.UNIT_STATE_MAX_LIFE);
}
export function 取最大魔法(单位) {
    return GetUnitStateJapi(单位, jass.UNIT_STATE_MAX_MANA);
}
export function 取单位攻击力(单位) {
    return GetUnitStateJapi(单位, ConvertUnitState(0x15));
}
export function 取单位护甲(单位) {
    return GetUnitStateJapi(单位, ConvertUnitState(0x20));
}
export function 造成伤害事件伤害(来源, 目标, 伤害, 伤害类型) {
    if (!单位有效存活(来源) || !单位有效存活(目标) || !(伤害 > 0))
        return;
    UnitDamageTarget(来源, 目标, 伤害, false, false, 伤害事件攻击类型.普通, 伤害类型, 伤害事件武器类型);
}
export function 执行物品治疗(来源, 目标, 生命值, 特效路径, 魔法值 = 0, 魔法特效路径, 延迟一帧 = false, 使用默认生命特效 = false, 使用默认魔法特效 = false) {
    debugLogForce("执行物品治疗", "source=", 来源 != null && 来源 !== 0 ? GetUnitName(来源) : "nil", "target=", 目标 != null && 目标 !== 0 ? GetUnitName(目标) : "nil", "hp=", 生命值, "mp=", 魔法值, "healFx=", 特效路径 ?? "", "manaFx=", 魔法特效路径 ?? "", "delayOneTick=", 延迟一帧, "useDefaultHealFx=", 使用默认生命特效, "useDefaultManaFx=", 使用默认魔法特效);
    doHeal({
        HealSource: 来源,
        HealTarget: 目标,
        HealAmount: 生命值,
        HealManaAmount: 魔法值,
        ItemHeal: true,
        HealEffect: 使用默认生命特效 || (特效路径 != null && 特效路径 !== ""),
        HealEffectPath: 特效路径,
        UseDefaultHealEffect: 使用默认生命特效,
        ManaEffect: 使用默认魔法特效 || (魔法特效路径 != null && 魔法特效路径 !== ""),
        ManaEffectPath: 魔法特效路径,
        UseDefaultManaEffect: 使用默认魔法特效,
        DelayOneTick: 延迟一帧,
    });
}
export function 播放点特效(模型, x, y, 持续秒 = 1) {
    if (模型 === "")
        return;
    const effect = AddSpecialEffect(模型, x, y);
    安排特效销毁(effect, 持续秒);
}
export function 播放单位特效(单位, 模型, 挂点 = "origin", 持续秒 = 1) {
    if (单位 == null || 单位 === 0 || 模型 === "")
        return;
    const effect = AddSpecialEffectTarget(模型, 单位, 挂点);
    安排特效销毁(effect, 持续秒);
}
export function 取单位X(单位) {
    return GetUnitX(单位);
}
export function 取单位Y(单位) {
    return GetUnitY(单位);
}
export function 取单位名称(单位) {
    return GetUnitName(单位);
}
export function 随机实数(最小值, 最大值) {
    return GetRandomReal(最小值, 最大值);
}
export function 是指定伤害类型(snapshot, 类型) {
    return snapshot != null && snapshot.rawDamageType === 类型;
}
