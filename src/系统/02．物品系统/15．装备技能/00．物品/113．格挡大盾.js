/** @noSelfInFile */
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查");
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版");
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调");
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
const { 是否在前方 } = require("lib.扩展函数.Star扩展函数.Star扩展库.11．方位判断函数");
const jass = require("jass.common");
const japi = require("jass.japi");
const UnitItemInSlot = jass.UnitItemInSlot;
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const IsUnitType = jass.IsUnitType;
const UnitDamageTarget = jass.UnitDamageTarget;
const ConvertUnitState = jass.ConvertUnitState;
const UNIT_TYPE_MELEE_ATTACKER = jass.UNIT_TYPE_MELEE_ATTACKER;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH;
const GetUnitStateJapi = japi.GetUnitState;
const 格挡大盾物品ID = stringToFourCCSafe(resolveItemIdByName("格挡大盾"));
const 格挡大盾近战范围 = 200;
const 格挡大盾近战范围平方 = 格挡大盾近战范围 * 格挡大盾近战范围;
const 格挡大盾普通前方减伤 = 0.15;
const 格挡大盾近战前方减伤 = 0.30;
const 格挡大盾盾击护甲系数 = 1.40;
const 单位护甲状态 = ConvertUnitState(0x20);
let 已初始化格挡大盾 = false;
function 单位持有格挡大盾(unit) {
    if (unit == null || unit === 0 || 格挡大盾物品ID === 0)
        return false;
    for (let i = 0; i < 6; i++) {
        const item = UnitItemInSlot(unit, i);
        if (item != null && item !== 0 && GetItemTypeId(item) === 格挡大盾物品ID)
            return true;
    }
    return false;
}
function 取单位距离平方(unitA, unitB) {
    const dx = GetUnitX(unitA) - GetUnitX(unitB);
    const dy = GetUnitY(unitA) - GetUnitY(unitB);
    return dx * dx + dy * dy;
}
function 是否近战普攻(source, target, snapshot) {
    if (source == null || source === 0 || target == null || target === 0)
        return false;
    if (snapshot == null || snapshot.isNormalAttack !== true)
        return false;
    if (IsUnitType(source, UNIT_TYPE_MELEE_ATTACKER) !== true)
        return false;
    return 取单位距离平方(source, target) <= 格挡大盾近战范围平方;
}
function 取单位护甲(unit) {
    if (unit == null || unit === 0)
        return 0;
    return GetUnitStateJapi(unit, 单位护甲状态);
}
function on格挡大盾伤害修正(context) {
    if (!(context.currentDamage >= 1))
        return context.currentDamage;
    if (context.isTrueDamage === true)
        return context.currentDamage;
    const target = context.target;
    const attacker = context.attacker;
    if (target == null || target === 0 || attacker == null || attacker === 0)
        return context.currentDamage;
    if (!单位持有格挡大盾(target))
        return context.currentDamage;
    if (!是否在前方(target, attacker))
        return context.currentDamage;
    const 减伤比例 = 是否近战普攻(attacker, target, context) ? 格挡大盾近战前方减伤 : 格挡大盾普通前方减伤;
    return context.currentDamage * (1 - 减伤比例);
}
function on格挡大盾盾击(target, attacker, applied, snapshot) {
    if (target == null || target === 0 || attacker == null || attacker === 0)
        return;
    if (!(applied >= 1))
        return;
    if (snapshot != null && snapshot.isTrueDamage === true)
        return;
    if (!单位持有格挡大盾(attacker))
        return;
    if (!是否近战普攻(attacker, target, snapshot))
        return;
    const 伤害值 = 取单位护甲(attacker) * 格挡大盾盾击护甲系数;
    if (!(伤害值 > 0))
        return;
    UnitDamageTarget(attacker, target, 伤害值, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_METAL_HEAVY_BASH);
}
export function 初始化格挡大盾() {
    if (已初始化格挡大盾 || 格挡大盾物品ID === 0)
        return;
    已初始化格挡大盾 = true;
    registerDamageModifier(on格挡大盾伤害修正, 35);
    registerAppliedFinalDamageListener(on格挡大盾盾击);
}
初始化格挡大盾();
