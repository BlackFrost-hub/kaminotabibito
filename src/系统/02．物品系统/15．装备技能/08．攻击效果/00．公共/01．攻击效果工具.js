/** @noSelfInFile */
import { 攻击效果跳过配置表 } from "./03．攻击效果跳过配置表";
const jass = require("jass.common");
const japi = require("jass.japi");
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查");
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版");
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const { 快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.03．快速Buff");
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统");
const { 开始原地击飞 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.02．原地击飞系统");
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能");
const { 减少生命值, 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值");
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS");
const { 是否精英单位 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.06．精英单位判断");
const { 获取单位英雄武器类型 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.07．武器类型");
const { YDWEIsEventDamageType, YDWEIsEventAttackType } = require("lib.扩展函数.封装函数.06．伤害函数.index");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitState = jass.GetUnitState;
const GetUnitStateJapi = japi.GetUnitState;
const ConvertUnitState = jass.ConvertUnitState;
const IsUnitType = jass.IsUnitType;
const GetUnitTypeId = jass.GetUnitTypeId;
const GetHeroStr = jass.GetHeroStr;
const UnitDamageTarget = jass.UnitDamageTarget;
const AddSpecialEffect = jass.AddSpecialEffect;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const DestroyEffect = jass.DestroyEffect;
const GetRandomReal = jass.GetRandomReal;
const EXSetEffectSize = japi.EXSetEffectSize;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO;
const UNIT_TYPE_MELEE_ATTACKER = jass.UNIT_TYPE_MELEE_ATTACKER;
const UNIT_TYPE_RANGED_ATTACKER = jass.UNIT_TYPE_RANGED_ATTACKER;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE;
const DAMAGE_TYPE_DIVINE = (jass.DAMAGE_TYPE_DIVINE ?? jass.DAMAGE_TYPE_UNIVERSAL);
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED;
const DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const 装备ID缓存 = {};
const 跳过单位ID缓存 = {};
function 获取跳过单位ID(unitId) {
    const cached = 跳过单位ID缓存[unitId];
    if (cached != null)
        return cached;
    const id = stringToFourCCSafe(unitId);
    跳过单位ID缓存[unitId] = id;
    return id;
}
function 伤害快照是神圣伤害(snapshot) {
    if (snapshot != null && snapshot.rawDamageType != null) {
        return snapshot.rawDamageType === DAMAGE_TYPE_DIVINE;
    }
    return YDWEIsEventDamageType(DAMAGE_TYPE_DIVINE) === true;
}
function 伤害快照是普通攻击类型(snapshot) {
    if (snapshot != null && snapshot.rawAttackType != null) {
        return snapshot.rawAttackType === ATTACK_TYPE_NORMAL;
    }
    return YDWEIsEventAttackType(ATTACK_TYPE_NORMAL) === true;
}
/**
 * 按装备名反查物品 FourCC（数字）
 * 注意：按名字反查物品ID 返回的是 string raw id（如"I021"），
 * 需要经 stringToFourCCSafe 转为数字才能传给 UnitHasItemOfTypeBJ。
 */
export function 获取攻击效果装备ID(装备名) {
    const cached = 装备ID缓存[装备名];
    if (cached != null)
        return cached;
    const rawId = 按名字反查物品ID(装备名);
    const id = typeof rawId === "string" ? stringToFourCCSafe(rawId) : 0;
    装备ID缓存[装备名] = id;
    return id;
}
export function 单位持有攻击效果装备(unit, 装备名) {
    if (unit == null || unit === 0)
        return false;
    const id = 获取攻击效果装备ID(装备名);
    if (id === 0)
        return false;
    return UnitHasItemOfTypeBJ(unit, id) === true;
}
export function 是否攻击效果全局跳过(source, snapshot) {
    if (source == null || source === 0)
        return false;
    const sourceTypeId = GetUnitTypeId(source);
    for (let i = 0; i < 攻击效果跳过配置表.length; i++) {
        const 配置 = 攻击效果跳过配置表[i];
        if (配置 == null)
            continue;
        if (配置.来源单位ID != null) {
            const unitTypeId = 获取跳过单位ID(配置.来源单位ID);
            if (unitTypeId === 0 || sourceTypeId !== unitTypeId)
                continue;
        }
        if (配置.需要普通攻击类型 === true && !伤害快照是普通攻击类型(snapshot))
            continue;
        if (配置.需要神圣伤害 === true && !伤害快照是神圣伤害(snapshot))
            continue;
        return true;
    }
    return false;
}
export function 单位有效存活(unit) {
    if (unit == null || unit === 0)
        return false;
    return IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}
export function 单位是英雄(unit) {
    if (!单位有效存活(unit))
        return false;
    return IsUnitType(unit, UNIT_TYPE_HERO) === true;
}
export function 攻击者类型满足(unit, type) {
    if (type == null)
        return true;
    if (!单位有效存活(unit))
        return false;
    if (type === "近战")
        return IsUnitType(unit, UNIT_TYPE_MELEE_ATTACKER) === true;
    if (type === "远程")
        return IsUnitType(unit, UNIT_TYPE_RANGED_ATTACKER) === true;
    return true;
}
export function 单位武器类型满足(unit, type) {
    if (type == null || type === "")
        return true;
    if (!单位是英雄(unit))
        return false;
    return 获取单位英雄武器类型(unit) === type;
}
export function 单位是精英目标(unit) {
    if (!单位有效存活(unit))
        return false;
    return 是否精英单位(unit) === true;
}
export function 取单位X(unit) {
    return GetUnitX(unit);
}
export function 取单位Y(unit) {
    return GetUnitY(unit);
}
export function 取当前生命(unit) {
    return GetUnitState(unit, UNIT_STATE_LIFE);
}
export function 取最大生命(unit) {
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE);
}
export function 取最大魔法(unit) {
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA);
}
export function 取攻击力(unit) {
    return GetUnitStateJapi(unit, ConvertUnitState(0x15));
}
export function 取力量(unit) {
    if (!单位是英雄(unit))
        return 0;
    return GetHeroStr(unit, true);
}
export function 单位距离平方(a, b) {
    const dx = 取单位X(a) - 取单位X(b);
    const dy = 取单位Y(a) - 取单位Y(b);
    return dx * dx + dy * dy;
}
export function 距离满足限制(source, target, minDistance, maxDistance) {
    if (minDistance == null && maxDistance == null)
        return true;
    const dist2 = 单位距离平方(source, target);
    if (minDistance != null && dist2 < minDistance * minDistance)
        return false;
    if (maxDistance != null && dist2 > maxDistance * maxDistance)
        return false;
    return true;
}
export function 命中概率通过(probability) {
    if (probability == null || probability >= 1)
        return true;
    if (probability <= 0)
        return false;
    return GetRandomReal(0, 1) <= probability;
}
export function 解析攻击效果伤害类型(类型) {
    if (类型 === "火焰")
        return DAMAGE_TYPE_FIRE;
    if (类型 === "毒素")
        return DAMAGE_TYPE_POISON;
    if (类型 === "暗影")
        return DAMAGE_TYPE_SHADOW_STRIKE;
    if (类型 === "神圣")
        return DAMAGE_TYPE_DIVINE;
    if (类型 === "强化")
        return DAMAGE_TYPE_ENHANCED;
    if (类型 === "通用")
        return DAMAGE_TYPE_UNIVERSAL;
    return DAMAGE_TYPE_NORMAL;
}
export function 攻击效果造成伤害(source, target, amount, 类型) {
    if (!单位有效存活(source) || !单位有效存活(target) || !(amount > 0))
        return;
    UnitDamageTarget(source, target, amount, false, false, ATTACK_TYPE_NORMAL, 解析攻击效果伤害类型(类型), WEAPON_TYPE_WHOKNOWS);
}
export function 攻击效果治疗生命魔法(source, target, lifeAmount, manaAmount = 0) {
    if (!单位有效存活(target))
        return;
    if (!(lifeAmount > 0) && !(manaAmount > 0))
        return;
    doHeal({
        HealSource: source,
        HealTarget: target,
        HealAmount: lifeAmount > 0 ? lifeAmount : 0,
        HealManaAmount: manaAmount > 0 ? manaAmount : 0,
        ItemHeal: true,
        HealEffect: lifeAmount > 0,
        ManaEffect: manaAmount > 0,
        ManaShowText: manaAmount > 0,
    });
}
export function 攻击效果减少生命魔法(target, lifeAmount, manaAmount) {
    if (!单位有效存活(target))
        return;
    if (lifeAmount > 0)
        减少生命值(target, lifeAmount, true, true, undefined, 1);
    if (manaAmount > 0)
        减少魔法值(target, manaAmount, true, true);
}
export function 获取敌方范围单位(source, center, radius, includeCenter = false) {
    if (!单位有效存活(source) || !单位有效存活(center) || !(radius > 0))
        return [];
    const list = getUnitsInRange(取单位X(center), 取单位Y(center), radius);
    const result = [];
    for (let i = 0; i < list.length; i++) {
        const unit = list[i];
        if (!单位有效存活(unit))
            continue;
        if (!includeCenter && unit === center)
            continue;
        if (isUnitEnemy(unit, source) !== true)
            continue;
        result.push(unit);
    }
    return result;
}
export function 播放目标特效(target, model, attach = "origin") {
    if (!单位有效存活(target) || model === "")
        return;
    const effect = AddSpecialEffectTarget(model, target, attach);
    if (effect != null && effect !== 0)
        DestroyEffect(effect);
}
export function 播放单位坐标特效(target, model, scale) {
    if (!单位有效存活(target) || model === "")
        return;
    const effect = AddSpecialEffect(model, GetUnitX(target), GetUnitY(target));
    if (effect == null || effect === 0)
        return;
    if (scale != null && scale > 0) {
        EXSetEffectSize(effect, scale);
    }
    DestroyEffect(effect);
}
export function 施加攻击效果减速(source, target, amount, duration) {
    if (!(amount > 0) || !(duration > 0))
        return;
    快速减速Buff(source, target, amount, amount, duration);
}
export function 施加攻击效果眩晕(source, target, duration) {
    if (!(duration > 0))
        return;
    施加扩展控制(source, target, "stun", { 持续时间: duration });
}
export function 施加攻击效果击飞(source, target, duration) {
    if (!(duration > 0))
        return;
    开始原地击飞(target, {
        持续时间: duration,
        主单位: source,
        主单位死亡时中断: true,
        暂停单位: true,
        中断已有跳跃: true,
    });
}
export function 临时修改攻速(unit, value) {
    if (!单位有效存活(unit) || value === 0)
        return;
    SGSS_SetState(unit, 10, value);
}
export function 临时修改护甲(unit, value) {
    if (!单位有效存活(unit) || value === 0)
        return;
    SGSS_SetState(unit, 2, value);
}
