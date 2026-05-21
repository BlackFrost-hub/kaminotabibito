/** @noSelfInFile */
const jass = require("jass.common");
const japi = require("jass.japi");
const { UnitHasItemOfTypeBJ, GetItemOfTypeFromUnitBJ } = require("lib.扩展函数.物品相关函数.物品判断函数");
const { getUnitsInRange, getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS");
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能");
const { SFB_setBuff, SFB_setSlow } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff");
const { 清除单位负面Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff");
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统");
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const GetItemTypeId = jass.GetItemTypeId;
const GetHandleId = jass.GetHandleId;
const GetOwningPlayer = jass.GetOwningPlayer;
const GetPlayerId = jass.GetPlayerId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitState = jass.GetUnitState;
const SetUnitState = jass.SetUnitState;
const IsUnitType = jass.IsUnitType;
const IsUnitAlly = jass.IsUnitAlly;
const UnitDamageTarget = jass.UnitDamageTarget;
const GetHeroStr = jass.GetHeroStr;
const GetHeroAgi = jass.GetHeroAgi;
const GetHeroInt = jass.GetHeroInt;
const AddHeroXP = jass.AddHeroXP;
const ModifyHeroStat = jass.ModifyHeroStat;
const AddSpecialEffect = jass.AddSpecialEffect;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const DestroyEffect = jass.DestroyEffect;
const IsPointBlighted = jass.IsPointBlighted;
const SetItemCharges = jass.SetItemCharges;
const GetItemCharges = jass.GetItemCharges;
const CreateUnit = jass.CreateUnit;
const UnitApplyTimedLife = jass.UnitApplyTimedLife;
const SetUnitScale = jass.SetUnitScale;
const SetUnitInvulnerable = jass.SetUnitInvulnerable;
const SetUnitFacing = jass.SetUnitFacing;
const IssueTargetOrder = jass.IssueTargetOrder;
const CreateGroup = jass.CreateGroup;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange;
const FirstOfGroup = jass.FirstOfGroup;
const GroupRemoveUnit = jass.GroupRemoveUnit;
const DestroyGroup = jass.DestroyGroup;
const GetUnitFlyHeight = jass.GetUnitFlyHeight;
const ConvertUnitState = jass.ConvertUnitState;
const SquareRoot = jass.SquareRoot;
const Atan2 = jass.Atan2;
const Cos = jass.Cos;
const Sin = jass.Sin;
const bj_RADTODEG = jass.bj_RADTODEG;
const bj_DEGTORAD = jass.bj_DEGTORAD;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const bj_HEROSTAT_INT = jass.bj_HEROSTAT_INT;
const bj_MODIFYMETHOD_ADD = jass.bj_MODIFYMETHOD_ADD;
const GetUnitStateJapi = japi.GetUnitState;
const DzSetUnitModel = japi.DzSetUnitModel;
const stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe;
const 火把单位类型ID = stringToFourCCSafe("e00D");
const 限时生命BuffID = stringToFourCCSafe("BHwe");
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
export function 是否为使用物品(物品, 物品类型ID) {
    if (物品 == null || 物品 === 0 || 物品类型ID === 0)
        return false;
    return GetItemTypeId(物品) === 物品类型ID;
}
export function 单位持有物品(单位, 物品类型ID) {
    if (单位 == null || 单位 === 0 || 物品类型ID === 0)
        return false;
    return UnitHasItemOfTypeBJ(单位, 物品类型ID) === true;
}
export function 获取单位指定物品(单位, 物品类型ID) {
    return GetItemOfTypeFromUnitBJ(单位, 物品类型ID);
}
export function 取句柄ID(h) {
    if (h == null || h === 0)
        return 0;
    return GetHandleId(h);
}
export function 单位存活(单位) {
    if (单位 == null || 单位 === 0)
        return false;
    return IsUnitType(单位, UNIT_TYPE_DEAD) !== true && GetUnitState(单位, UNIT_STATE_LIFE) > 0.405;
}
export function 单位是英雄(单位) {
    return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_HERO) === true;
}
export function 单位可作为敌人目标(单位) {
    if (!单位存活(单位))
        return false;
    if (IsUnitType(单位, UNIT_TYPE_MECHANICAL))
        return false;
    if (IsUnitType(单位, UNIT_TYPE_ANCIENT))
        return false;
    return true;
}
export function 获取范围敌人(来源, x, y, 半径) {
    return getEnemyUnitsInRange(来源, x, y, 半径);
}
export function 获取范围友军(来源, x, y, 半径) {
    const all = getUnitsInRange(x, y, 半径);
    const result = [];
    const owner = GetOwningPlayer(来源);
    for (const unit of all) {
        if (unit != null && unit !== 0 && IsUnitAlly(unit, owner)) {
            result.push(unit);
        }
    }
    return result;
}
export function 获取范围尸体(x, y, 半径) {
    const group = CreateGroup();
    GroupEnumUnitsInRange(group, x, y, 半径, null);
    const result = [];
    let unit = FirstOfGroup(group);
    while (unit != null && unit !== 0) {
        if (IsUnitType(unit, UNIT_TYPE_DEAD) === true &&
            IsUnitType(unit, UNIT_TYPE_MECHANICAL) !== true &&
            IsUnitType(unit, UNIT_TYPE_ANCIENT) !== true &&
            GetUnitFlyHeight(unit) <= 999999) {
            result.push(unit);
        }
        GroupRemoveUnit(group, unit);
        unit = FirstOfGroup(group);
    }
    DestroyGroup(group);
    return result;
}
export function 取单位X(单位) {
    return GetUnitX(单位);
}
export function 取单位Y(单位) {
    return GetUnitY(单位);
}
export function 取当前生命(单位) {
    return GetUnitState(单位, UNIT_STATE_LIFE);
}
export function 取当前魔法(单位) {
    return GetUnitState(单位, UNIT_STATE_MANA);
}
export function 取最大生命(单位) {
    return GetUnitStateJapi(单位, UNIT_STATE_MAX_LIFE);
}
export function 取最大魔法(单位) {
    return GetUnitStateJapi(单位, UNIT_STATE_MAX_MANA);
}
export function 取单位攻击(单位) {
    return GetUnitStateJapi(单位, ConvertUnitState(0x15));
}
export function 计算两点距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return SquareRoot(dx * dx + dy * dy);
}
export function 计算两点角度(x1, y1, x2, y2) {
    return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG;
}
export function 限制目标点距离(起点X, 起点Y, 目标X, 目标Y, 最大距离) {
    const angle = 计算两点角度(起点X, 起点Y, 目标X, 目标Y);
    const distance = 计算两点距离(起点X, 起点Y, 目标X, 目标Y);
    if (distance <= 最大距离) {
        return { x: 目标X, y: 目标Y, angle };
    }
    const rad = angle * bj_DEGTORAD;
    return {
        x: 起点X + Cos(rad) * 最大距离,
        y: 起点Y + Sin(rad) * 最大距离,
        angle,
    };
}
export function 设置生命(单位, 数值) {
    SetUnitState(单位, UNIT_STATE_LIFE, 数值);
}
export function 设置魔法(单位, 数值) {
    SetUnitState(单位, UNIT_STATE_MANA, 数值);
}
export function 调整生命(单位, 数值) {
    SetUnitState(单位, UNIT_STATE_LIFE, GetUnitState(单位, UNIT_STATE_LIFE) + 数值);
}
export function 调整魔法(单位, 数值) {
    SetUnitState(单位, UNIT_STATE_MANA, GetUnitState(单位, UNIT_STATE_MANA) + 数值);
}
export function 造成强化伤害(来源, 目标, 伤害) {
    if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0))
        return;
    UnitDamageTarget(来源, 目标, 伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS);
}
export function 造成火焰伤害(来源, 目标, 伤害) {
    if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0))
        return;
    UnitDamageTarget(来源, 目标, 伤害, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS);
}
export function 造成暗影伤害(来源, 目标, 伤害) {
    if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0))
        return;
    UnitDamageTarget(来源, 目标, 伤害, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS);
}
export function 造成普通伤害(来源, 目标, 伤害) {
    if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0))
        return;
    UnitDamageTarget(来源, 目标, 伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}
export function 造成精神自伤(单位, 伤害) {
    if (!单位存活(单位) || !(伤害 > 0))
        return;
    UnitDamageTarget(单位, 单位, 伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS);
}
export function 执行治疗(来源, 目标, 生命, 魔法 = 0) {
    if (目标 == null || 目标 === 0)
        return;
    doHeal({
        HealSource: 来源,
        HealTarget: 目标,
        HealAmount: 生命,
        HealManaAmount: 魔法,
        ItemHeal: true,
        HealEffect: false,
        UseDefaultHealEffect: false,
        HealEffectPath: undefined,
        ManaEffect: false,
        UseDefaultManaEffect: false,
        ManaEffectPath: undefined,
    });
}
export function 播放点特效(模型, x, y, 持续秒 = 1) {
    if (模型 === "")
        return;
    const effect = AddSpecialEffect(模型, x, y);
    安排特效销毁(effect, 持续秒);
}
export function 播放单位特效(模型, 单位, 挂点 = "origin", 持续秒 = 1) {
    if (单位 == null || 单位 === 0 || 模型 === "")
        return;
    const effect = AddSpecialEffectTarget(模型, 单位, 挂点);
    安排特效销毁(effect, 持续秒);
}
export function 施加眩晕(来源, 目标, 持续时间) {
    SFB_setBuff(来源, 目标, 0, 持续时间);
}
export function 施加减速(来源, 目标, 降低比例, 持续时间) {
    SFB_setSlow(来源, 目标, 降低比例, 降低比例, 持续时间);
}
export function 清除负面Buff(单位) {
    return 清除单位负面Buff(单位, false);
}
export function 临时调整攻击(单位, 数值) {
    SGSS_SetState(单位, 1, 数值);
}
export function 临时调整护甲(单位, 数值) {
    SGSS_SetState(单位, 2, 数值);
}
export function 临时调整攻速(单位, 数值) {
    SGSS_SetState(单位, 10, 数值);
}
export function 调整玩家属性(单位, 属性名, 增量) {
    if (单位 == null || 单位 === 0)
        return;
    const owner = GetOwningPlayer(单位);
    const oldValue = Number(YDUserDataGetSafe("player", owner, 属性名, "real")) || 0;
    YDUserDataSetSafe("player", owner, 属性名, "real", oldValue + 增量);
}
export function 调整单位属性(单位, 属性名, 增量) {
    if (单位 == null || 单位 === 0)
        return;
    const oldValue = Number(YDUserDataGetSafe("unit", 单位, 属性名, "real")) || 0;
    YDUserDataSetSafe("unit", 单位, 属性名, "real", oldValue + 增量);
}
export function 读取玩家属性(单位, 属性名) {
    if (单位 == null || 单位 === 0)
        return 0;
    return Number(YDUserDataGetSafe("player", GetOwningPlayer(单位), 属性名, "real")) || 0;
}
export function 读取单位属性(单位, 属性名) {
    if (单位 == null || 单位 === 0)
        return 0;
    return Number(YDUserDataGetSafe("unit", 单位, 属性名, "real")) || 0;
}
export function 英雄主属性是智力(英雄) {
    if (!单位是英雄(英雄))
        return false;
    const intValue = GetHeroInt(英雄, false);
    return intValue > GetHeroStr(英雄, false) && intValue > GetHeroAgi(英雄, false);
}
export function 增加英雄经验与智力(英雄, 次数, 每次经验, 智力) {
    for (let i = 0; i < 次数; i++) {
        AddHeroXP(英雄, 每次经验, true);
    }
    ModifyHeroStat(bj_HEROSTAT_INT, 英雄, bj_MODIFYMETHOD_ADD, 智力);
}
export function 获取物品次数(单位, 物品类型ID) {
    const item = 获取单位指定物品(单位, 物品类型ID);
    if (item == null || item === 0)
        return 0;
    return GetItemCharges(item);
}
export function 设置物品次数(单位, 物品类型ID, 次数) {
    const item = 获取单位指定物品(单位, 物品类型ID);
    if (item == null || item === 0)
        return;
    SetItemCharges(item, 次数);
}
export function 增加物品次数(单位, 物品类型ID, 次数, 最大值) {
    const current = 获取物品次数(单位, 物品类型ID);
    let next = current + 次数;
    if (next > 最大值)
        next = 最大值;
    设置物品次数(单位, 物品类型ID, next);
}
export function 单位所在点是荒芜(单位) {
    return IsPointBlighted(GetUnitX(单位), GetUnitY(单位)) === true;
}
export function 击退远离来源(来源, 目标, 距离, 持续时间) {
    if (!单位存活(目标))
        return;
    开始击退(目标, {
        来源单位: 来源,
        距离,
        持续时间,
        检查地形: true,
        暂停单位: false,
        禁用碰撞: true,
    });
}
export function 拉向来源(来源, 目标, 距离, 持续时间) {
    const tx = GetUnitX(目标);
    const ty = GetUnitY(目标);
    const sx = GetUnitX(来源);
    const sy = GetUnitY(来源);
    开始击退(目标, {
        来源X: tx * 2 - sx,
        来源Y: ty * 2 - sy,
        距离,
        持续时间,
        检查地形: true,
        暂停单位: false,
        禁用碰撞: true,
    });
}
export function 命令攻击来源(目标, 来源) {
    IssueTargetOrder(目标, "attack", 来源);
}
export function 取玩家ID(单位) {
    if (单位 == null || 单位 === 0)
        return -1;
    return GetPlayerId(GetOwningPlayer(单位));
}
export function 创建火把单位(来源, x, y, face, 模型, 持续时间) {
    if (火把单位类型ID === 0)
        return;
    const unit = CreateUnit(GetOwningPlayer(来源), 火把单位类型ID, x, y, face);
    if (unit == null || unit === 0)
        return;
    DzSetUnitModel(unit, 模型);
    SetUnitScale(unit, 1, 1, 1);
    SetUnitInvulnerable(unit, true);
    SetUnitFacing(来源, face);
    UnitApplyTimedLife(unit, 限时生命BuffID, 持续时间);
}
