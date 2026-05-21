/** @noSelfInFile */
/**
 * TS 原生弹幕 - 共享常量与 JASS/JAPI 别名
 */
const jass = require("jass.common");
const japi = require("jass.japi");
export const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
export const CreateUnit = jass.CreateUnit;
export const DestroyEffect = jass.DestroyEffect;
export const GetHandleId = jass.GetHandleId;
export const GetOwningPlayer = jass.GetOwningPlayer;
export const GetRandomReal = jass.GetRandomReal;
export const GetUnitFacing = jass.GetUnitFacing;
export const GetUnitFlyHeight = jass.GetUnitFlyHeight;
export const GetUnitState = jass.GetUnitState;
export const GetUnitX = jass.GetUnitX;
export const GetUnitY = jass.GetUnitY;
export const IsTerrainPathable = jass.IsTerrainPathable;
export const IsUnitPaused = jass.IsUnitPaused;
export const KillUnit = jass.KillUnit;
export const Player = jass.Player;
export const RemoveUnit = jass.RemoveUnit;
export const SetUnitFacing = jass.SetUnitFacing;
export const SetUnitFlyHeight = jass.SetUnitFlyHeight;
export const SetUnitPathing = jass.SetUnitPathing;
export const SetUnitPosition = jass.SetUnitPosition;
export const SetUnitScale = jass.SetUnitScale;
export const SetUnitX = jass.SetUnitX;
export const SetUnitY = jass.SetUnitY;
export const SquareRoot = jass.SquareRoot;
export const UnitAddAbility = jass.UnitAddAbility;
export const UnitRemoveAbility = jass.UnitRemoveAbility;
export const UnitAddType = jass.UnitAddType;
export const UnitRemoveType = jass.UnitRemoveType;
export const UnitDamageTarget = jass.UnitDamageTarget;
export const Atan2 = jass.Atan2;
export const CosBJ = require("lib.扩展函数.BJ函数.12．数学函数").CosBJ;
export const SinBJ = require("lib.扩展函数.BJ函数.12．数学函数").SinBJ;
export const EXSetUnitFacing = japi.EXSetUnitFacing;
export const DzSetUnitModel = japi.DzSetUnitModel;
export const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
export const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
export const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
export const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
export const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT;
export const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL;
export const UNIT_TYPE_TAUREN = jass.UNIT_TYPE_TAUREN;
export const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY;
export const bj_RADTODEG = jass.bj_RADTODEG ?? 57.29577951308232;
export const 蝗虫技能ID = 0x416c6f63; // 'Aloc'
export const 默认弹幕单位类型 = 1700880737; // 'eaaa'，objediting/units.lua 中的 TS 原生弹幕马甲
export const 弹幕Tick间隔 = 0.01;
export function 取句柄ID(handle) {
    return handle != null && handle !== 0 ? (GetHandleId(handle) || 0) : 0;
}
export function 标准化角度(角度) {
    let 结果 = 角度;
    while (结果 < 0)
        结果 += 360;
    while (结果 >= 360)
        结果 -= 360;
    return 结果;
}
export function 取坐标朝向角(fromX, fromY, toX, toY) {
    return Atan2(toY - fromY, toX - fromX) * bj_RADTODEG;
}
export function 角度差(from, to) {
    let diff = 标准化角度(to - from);
    if (diff > 180)
        diff -= 360;
    return diff;
}
export function 限制范围(value, min, max) {
    if (value < min)
        return min;
    if (value > max)
        return max;
    return value;
}
export function 计算距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return SquareRoot(dx * dx + dy * dy);
}
