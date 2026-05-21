/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const japi = require("jass.japi");
const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围");
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { getObjectPropertyRealSafe, ObjectType } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const { 施加持续恢复生命魔法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．持续恢复生命魔法");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitState = jass.GetUnitState;
const GetUnitTypeId = jass.GetUnitTypeId;
const GetUnitLevel = jass.GetUnitLevel;
const IsUnitRace = jass.IsUnitRace;
const IsHeroUnitId = jass.IsHeroUnitId;
const KillUnit = jass.KillUnit;
const UnitDamageTarget = jass.UnitDamageTarget;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const RACE_DEMON = jass.RACE_DEMON;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const EXSetEffectSize = japi.EXSetEffectSize;
import { 汭冥血杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 汭冥血杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为汭冥血杖(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 汭冥血杖物品ID;
}
function 目标可献祭(目标单位, 等级上限) {
    if (目标单位 == null || 目标单位 === 0)
        return false;
    if (IsUnitRace(目标单位, RACE_DEMON))
        return false;
    if (IsHeroUnitId(GetUnitTypeId(目标单位)))
        return false;
    return GetUnitLevel(目标单位) <= 等级上限;
}
function 施加汭冥血杖恢复(施法单位, 生命恢复值, 魔法恢复值) {
    施加持续恢复生命魔法(施法单位, 施法单位, {
        BuffID: 汭冥血杖配置.BuffID,
        图标路径: 汭冥血杖配置.图标路径,
        特效路径: 汭冥血杖配置.恢复特效路径,
        特效挂点: 汭冥血杖配置.恢复特效挂点,
        特效键: 汭冥血杖配置.恢复特效键,
        持续时间: 汭冥血杖配置.恢复持续时间,
        间隔: 汭冥血杖配置.恢复间隔,
        每跳生命恢复: 生命恢复值,
        每跳魔法恢复: 魔法恢复值,
    });
}
export function 执行汭冥血杖献祭(上下文, 是否强化) {
    debugLogForce("19．汭冥血杖", "进入", "执行汭冥血杖献祭");
    const 施法单位 = 上下文.施法单位;
    const 目标单位 = 上下文.目标单位;
    if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0)
        return;
    const 等级上限 = 是否强化 ? 汭冥血杖配置.强化等级上限 : 汭冥血杖配置.普通等级上限;
    if (!目标可献祭(目标单位, 等级上限))
        return;
    const 目标最大生命 = GetUnitState(目标单位, UNIT_STATE_MAX_LIFE);
    const 生命恢复值 = 目标最大生命 * (是否强化 ? 汭冥血杖配置.强化生命恢复比例 : 汭冥血杖配置.普通生命恢复比例);
    const 魔法恢复值 = 是否强化 ? GetUnitState(施法单位, UNIT_STATE_MAX_MANA) * 汭冥血杖配置.强化魔法恢复比例 : 0;
    const 目标X = GetUnitX(目标单位);
    const 目标Y = GetUnitY(目标单位);
    const 特效 = createUnitEffect(目标单位, 汭冥血杖配置.特效挂点, 汭冥血杖配置.特效路径, 汭冥血杖配置.特效持续时间, "汭冥血杖");
    if (特效 != null && 特效 !== 0) {
        EXSetEffectSize(特效, getObjectPropertyRealSafe(ObjectType.UNIT, GetUnitTypeId(目标单位), "modelScale"));
    }
    const 敌人列表 = 获取坐标范围敌人(施法单位, 目标X, 目标Y, 汭冥血杖配置.作用范围);
    for (let i = 0; i < 敌人列表.length; i++) {
        const 敌人 = 敌人列表[i];
        if (!单位是否有效且敌对(敌人, 施法单位))
            continue;
        UnitDamageTarget(施法单位, 敌人, 目标最大生命 * 汭冥血杖配置.伤害生命系数, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
    }
    KillUnit(目标单位);
    施加汭冥血杖恢复(施法单位, 生命恢复值, 魔法恢复值);
}
export function 处理汭冥血杖使用(上下文) {
    debugLogForce("19．汭冥血杖", "进入", "处理汭冥血杖使用");
    if (!是否为汭冥血杖(上下文.物品))
        return;
    执行汭冥血杖献祭(上下文, false);
}
