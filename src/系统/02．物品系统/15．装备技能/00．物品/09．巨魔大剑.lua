local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5DE8_9B54_5927_5251_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["巨魔大剑物品ID"]
local ____00_FF0E_65BD_6CD5_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.02．施法触发.00．施法触发配置")
local _____5DE8_9B54_5927_5251_914D_7F6E = ____00_FF0E_65BD_6CD5_89E6_53D1_914D_7F6E["巨魔大剑配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local createDelayedCall = ____require_result_1.createDelayedCall
local cancelDelayedCall = ____require_result_1.cancelDelayedCall
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_2.createTimedEffect
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_3.registerAppliedFinalDamageListener
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.08．扩散伤害.扩散伤害")
local _____6269_6563_4F24_5BB3 = ____require_result_4["扩散伤害"]
local ____require_result_5 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_5.UnitHasItemOfTypeBJ
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertyIntegerSafe = ____require_result_6.getObjectPropertyIntegerSafe
local ____require_result_7 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local ObjectType = ____require_result_7.ObjectType
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668 = __TS__New(Map)
local _____5DF2_6CE8_518C_5DE8_9B54_5927_5251_9996_4F24_76D1_542C = false
local function _____5355_4F4D_6301_6709_5DE8_9B54_5927_5251(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____5DE8_9B54_5927_5251_7269_54C1ID <= 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(_____5355_4F4D, _____5DE8_9B54_5927_5251_7269_54C1ID) == true
end
local function _____5DE8_9B54_5927_5251_6761_4EF6_6210_7ACB(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if not IsUnitType(_____65BD_6CD5_5355_4F4D, UNIT_TYPE_HERO) then
        return false
    end
    if not _____5355_4F4D_6301_6709_5DE8_9B54_5927_5251(_____65BD_6CD5_5355_4F4D) then
        return false
    end
    local DataB1 = getObjectPropertyIntegerSafe(ObjectType.ABILITY, _____6280_80FDID, "DataB1")
    return DataB1 == 1 or DataB1 == 3
end
local function _____83B7_53D6_5DE8_9B54_5927_5251_7A97_53E3_952E(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D)
end
local function _____6E05_7406_5DE8_9B54_5927_5251_7A97_53E3(_____5355_4F4D, _____53D6_6D88_8BA1_65F6_5668)
    if _____53D6_6D88_8BA1_65F6_5668 == nil then
        _____53D6_6D88_8BA1_65F6_5668 = true
    end
    local _____952E = _____83B7_53D6_5DE8_9B54_5927_5251_7A97_53E3_952E(_____5355_4F4D)
    if _____952E <= 0 then
        return
    end
    local _____53E5_67C4 = _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:get(_____952E)
    if _____53D6_6D88_8BA1_65F6_5668 and _____53E5_67C4 ~= nil then
        cancelDelayedCall(_____53E5_67C4)
    end
    _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:delete(_____952E)
end
local function _____6253_5F00_5DE8_9B54_5927_5251_7A97_53E3(_____5355_4F4D)
    local _____952E = _____83B7_53D6_5DE8_9B54_5927_5251_7A97_53E3_952E(_____5355_4F4D)
    if _____952E <= 0 then
        return
    end
    _____6E05_7406_5DE8_9B54_5927_5251_7A97_53E3(_____5355_4F4D, true)
    local _____53E5_67C4 = nil
    _____53E5_67C4 = createDelayedCall(
        _____5DE8_9B54_5927_5251_914D_7F6E["持续时间"],
        function()
            if _____53E5_67C4 == nil then
                return
            end
            if _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:get(_____952E) == _____53E5_67C4 then
                _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:delete(_____952E)
                debugLogForce("10．巨魔大剑", "窗口结束")
            end
        end
    )
    _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:set(_____952E, _____53E5_67C4)
end
local function _____83B7_53D6_6269_6563_4F24_5BB3_7C7B_578B(snapshot)
    local _____9ED8_8BA4_653B_51FB_7C7B_578B = jass.ATTACK_TYPE_NORMAL
    local _____9ED8_8BA4_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_NORMAL
    if snapshot == nil then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = _____9ED8_8BA4_4F24_5BB3_7C7B_578B, ["武器类型"] = nil}
    end
    if snapshot.isTrueDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_MIND, ["武器类型"] = nil}
    end
    if snapshot.isEnhancedDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_ENHANCED, ["武器类型"] = nil}
    end
    if snapshot.isFireDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_FIRE, ["武器类型"] = nil}
    end
    if snapshot.isThunderDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_LIGHTNING, ["武器类型"] = nil}
    end
    if snapshot.isLightDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_DIVINE, ["武器类型"] = nil}
    end
    if snapshot.isDarkDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_SHADOW_STRIKE, ["武器类型"] = nil}
    end
    if snapshot.isWoodDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_PLANT, ["武器类型"] = nil}
    end
    if snapshot.isWaterDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_COLD, ["武器类型"] = nil}
    end
    if snapshot.isMetalDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_POISON, ["武器类型"] = nil}
    end
    if snapshot.isSkillAttack == true or snapshot.isSkillDamage == true or snapshot.isMagicDamage == true then
        return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC, ["武器类型"] = nil}
    end
    return {["攻击类型"] = _____9ED8_8BA4_653B_51FB_7C7B_578B, ["伤害类型"] = _____9ED8_8BA4_4F24_5BB3_7C7B_578B, ["武器类型"] = nil}
end
local function _____5904_7406_5DE8_9B54_5927_5251_9996_4F24(target, attacker, applied, snapshot)
    if target == nil or attacker == nil or not (applied > 0) then
        return
    end
    if not _____5355_4F4D_6301_6709_5DE8_9B54_5927_5251(attacker) then
        return
    end
    local _____952E = _____83B7_53D6_5DE8_9B54_5927_5251_7A97_53E3_952E(attacker)
    if _____952E <= 0 then
        return
    end
    local _____53E5_67C4 = _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:get(_____952E)
    if _____53E5_67C4 == nil then
        return
    end
    _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:delete(_____952E)
    cancelDelayedCall(_____53E5_67C4)
    local x = GetUnitX(target)
    local y = GetUnitY(target)
    debugLogForce(
        "10．巨魔大剑",
        "首伤触发",
        "source=",
        attacker,
        "target=",
        target,
        "applied=",
        applied
    )
    createTimedEffect(
        _____5DE8_9B54_5927_5251_914D_7F6E["扩散特效路径"],
        x,
        y,
        0,
        _____5DE8_9B54_5927_5251_914D_7F6E["扩散特效持续时间"]
    )
    local _____7C7B_578B = _____83B7_53D6_6269_6563_4F24_5BB3_7C7B_578B(snapshot)
    _____6269_6563_4F24_5BB3({
        ["来源单位"] = attacker,
        ["主目标"] = target,
        ["伤害值"] = applied,
        ["扩散半径"] = _____5DE8_9B54_5927_5251_914D_7F6E["扩散半径"],
        ["扩散百分比"] = _____5DE8_9B54_5927_5251_914D_7F6E["扩散百分比"],
        ["是否包含主目标"] = false,
        ["攻击类型"] = _____7C7B_578B["攻击类型"],
        ["伤害类型"] = _____7C7B_578B["伤害类型"],
        ["武器类型"] = _____7C7B_578B["武器类型"]
    })
end
local function _____521D_59CB_5316_5DE8_9B54_5927_5251_9996_4F24_76D1_542C()
    if _____5DF2_6CE8_518C_5DE8_9B54_5927_5251_9996_4F24_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_5DE8_9B54_5927_5251_9996_4F24_76D1_542C = true
    registerAppliedFinalDamageListener(_____5904_7406_5DE8_9B54_5927_5251_9996_4F24)
end
____exports["处理巨魔大剑施法"] = function(_____65BD_6CD5_5355_4F4D, _____6280_80FDID, _____76EE_6807_5355_4F4D)
    debugLogForce("10．巨魔大剑", "进入", "处理巨魔大剑施法")
    _____521D_59CB_5316_5DE8_9B54_5927_5251_9996_4F24_76D1_542C()
    if not _____5DE8_9B54_5927_5251_6761_4EF6_6210_7ACB(_____65BD_6CD5_5355_4F4D, _____6280_80FDID) then
        return
    end
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    _____6253_5F00_5DE8_9B54_5927_5251_7A97_53E3(_____65BD_6CD5_5355_4F4D)
end
_____521D_59CB_5316_5DE8_9B54_5927_5251_9996_4F24_76D1_542C()
return ____exports
