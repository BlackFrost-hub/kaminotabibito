local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3, _____51C6_5907_85E4_539F_59B9_7EA2W_5F15_7206_76EE_6807_4F24_5BB3, _____85E4_539F_59B9_7EA2W_62A4_76FE_521B_5EFA_524D, _____85E4_539F_59B9_7EA2W_62A4_76FE_5F15_7206_524D, _____85E4_539F_59B9_7EA2W_62A4_76FE_5F15_7206_540E, _____83B7_53D6_8303_56F4_654C_519B, createUnitEffect, createTimedEffect, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, GetUnitX, GetUnitY, IsUnitType, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS, UNIT_TYPE_ANCIENT, UNIT_TYPE_MECHANICAL, UNIT_TYPE_STRUCTURE, _____5F15_7206_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00．配置")
local _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["藤原妹红单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00A．表现工具")
local _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放藤原妹红单位音效"]
local _____64AD_653E_85E4_539F_59B9_7EA2_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放藤原妹红配置动作"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红点特效"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红单位特效"]
local ____04_FF0EE_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.04．E技能")
local _____5173_95ED_85E4_539F_59B9_7EA2_7B26_5361_6A21_5F0F = ____04_FF0EE_6280_80FD["关闭藤原妹红符卡模式"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____07_FF0E_62A4_76FE = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____4E3B_52A8_5F15_7206_62A4_76FE_4ECD_6709_6548 = ____07_FF0E_62A4_76FE["主动引爆护盾仍有效"]
local _____521B_5EFA_4E3B_52A8_5F15_7206_62A4_76FE = ____07_FF0E_62A4_76FE["创建主动引爆护盾"]
local _____5F15_7206_4E3B_52A8_5F15_7206_62A4_76FE = ____07_FF0E_62A4_76FE["引爆主动引爆护盾"]
local _____62A4_76FE_7C7B_578B = ____07_FF0E_62A4_76FE["护盾类型"]
local _____6E05_7406_4E3B_52A8_5F15_7206_62A4_76FE = ____07_FF0E_62A4_76FE["清理主动引爆护盾"]
function _____76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3(target)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_MECHANICAL) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_STRUCTURE) then
        return false
    end
    return true
end
function _____51C6_5907_85E4_539F_59B9_7EA2W_5F15_7206_76EE_6807_4F24_5BB3(target, _index)
    return _____76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3(target) and ({}) or nil
end
function _____85E4_539F_59B9_7EA2W_62A4_76FE_521B_5EFA_524D(controller)
    createUnitEffect(
        controller["护盾目标"],
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["表现资源"]["护盾特效挂点"],
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["表现资源"]["护盾特效路径"],
        nil,
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["表现资源"]["护盾特效键"]
    )
end
function _____85E4_539F_59B9_7EA2W_62A4_76FE_5F15_7206_524D(controller, damage)
    local caster = controller["施法者"]
    local target = controller["护盾目标"]
    createTimedEffect(
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["表现资源"]["引爆特效路径"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["表现资源"]["引爆特效持续秒"]
    )
    local targets = _____83B7_53D6_8303_56F4_654C_519B(
        caster,
        GetUnitX(target),
        GetUnitY(target),
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["引爆范围"]
    )
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害"] = damage,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____5F15_7206_6280_80FDID,
        ["每目标处理器"] = _____51C6_5907_85E4_539F_59B9_7EA2W_5F15_7206_76EE_6807_4F24_5BB3
    })
end
function _____85E4_539F_59B9_7EA2W_62A4_76FE_5F15_7206_540E(controller, _damage)
    _____6E05_7406_4E3B_52A8_5F15_7206_62A4_76FE(controller, "主动引爆")
end
require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.05．R技能")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____83B7_53D6_8303_56F4_654C_519B = ____require_result_1["获取范围敌军"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createUnitEffect = ____require_result_2.createUnitEffect
local destroyUnitEffect = ____require_result_2.destroyUnitEffect
createTimedEffect = ____require_result_2.createTimedEffect
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local removePeriodicCallback = ____require_result_3.removePeriodicCallback
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.进度条特效")
local _____521B_5EFA_8FDB_5EA6_6761_7279_6548 = ____require_result_4["创建进度条特效"]
local _____9500_6BC1_8FDB_5EA6_6761_7279_6548 = ____require_result_4["销毁进度条特效"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_5["开始击退"]
local _____505C_6B62_4F4D_79FB = ____require_result_5["停止位移"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_6["施加眩晕"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_7["开始硬直"]
local ____require_result_8 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_8["造成批量AOE技能伤害"]
local ____require_result_9 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_9["造成单体技能伤害"]
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_10.registerDeathListener
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitTimeScale = jass.SetUnitTimeScale
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitAlly = jass.IsUnitAlly
IsUnitType = jass.IsUnitType
local Cos = jass.Cos
local Sin = jass.Sin
local BJ_DEGTORAD = jass.bj_DEGTORAD or 0.017453292519943295
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local ____require_result_11 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____require_result_11["两点角度"]
local _____8DDD_79BBXY = ____require_result_11["距离XY"]
local _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____4E3B_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["主技能ID"])
_____5F15_7206_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["引爆技能ID"])
local _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868 = {}
local _____85E4_539F_59B9_7EA2W_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local _____7B26_5361W_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡W技能ID"])
local _____85E4_539F_59B9_7EA2_7B26_5361W_4E0A_4E0B_6587_8868 = {}
local _____85E4_539F_59B9_7EA2_7B26_5361W_4F4D_79FB_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["获取或创建藤原妹红W上下文"] = function(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 then
        return nil
    end
    local current = _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868[unitId]
    if current ~= nil then
        return current
    end
    local created = {
        ["施法者"] = unit,
        ["护盾目标"] = nil,
        ["护盾ID"] = 0,
        ["周期回调ID"] = 0,
        ["周期伤害"] = 0,
        ["护盾控制器"] = nil
    }
    _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868[unitId] = created
    return created
end
local function _____83B7_53D6_85E4_539F_59B9_7EA2W_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    local ____temp_12
    if unitId == 0 then
        ____temp_12 = nil
    else
        ____temp_12 = _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868[unitId]
    end
    return ____temp_12
end
local function _____6E05_7406_85E4_539F_59B9_7EA2W_72B6_6001(unit, shieldId)
    local context = _____83B7_53D6_85E4_539F_59B9_7EA2W_4E0A_4E0B_6587(unit)
    if context == nil then
        return
    end
    if shieldId ~= nil and context["护盾ID"] ~= 0 and context["护盾ID"] ~= shieldId then
        return
    end
    local _____63A7_5236_5668 = context["护盾控制器"]
    context["护盾控制器"] = nil
    _____6E05_7406_4E3B_52A8_5F15_7206_62A4_76FE(_____63A7_5236_5668, "技能状态清理")
end
local function _____85E4_539F_59B9_7EA2W_62A4_76FE_6E05_7406(_controller, _reason)
    local context = _____83B7_53D6_85E4_539F_59B9_7EA2W_4E0A_4E0B_6587(_controller["施法者"])
    destroyUnitEffect(_controller["护盾目标"], _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["表现资源"]["护盾特效键"])
    if context == nil then
        return
    end
    if context["护盾控制器"] ~= nil and context["护盾控制器"] ~= _controller then
        return
    end
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    context["护盾目标"] = nil
    context["护盾ID"] = 0
    context["周期伤害"] = 0
    context["护盾控制器"] = nil
end
local function _____51C6_5907_85E4_539F_59B9_7EA2W_5468_671F_76EE_6807_4F24_5BB3(target, _index)
    return _____76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3(target) and ({}) or nil
end
local function _____9020_6210_85E4_539F_59B9_7EA2W_5468_671F_4F24_5BB3(context)
    local caster = context["施法者"]
    local target = context["护盾目标"]
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local targets = _____83B7_53D6_8303_56F4_654C_519B(
        caster,
        GetUnitX(target),
        GetUnitY(target),
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["周期伤害半径"]
    )
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害"] = context["周期伤害"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____4E3B_6280_80FDID,
        ["每目标处理器"] = _____51C6_5907_85E4_539F_59B9_7EA2W_5468_671F_76EE_6807_4F24_5BB3
    })
end
local function _____85E4_539F_59B9_7EA2W_5468_671FTick(variable)
    local context = variable
    if context == nil or context["护盾ID"] == 0 then
        return
    end
    if not _____5355_4F4D_6709_6548(context["施法者"]) or not _____5355_4F4D_6709_6548(context["护盾目标"]) then
        _____6E05_7406_85E4_539F_59B9_7EA2W_72B6_6001(context["施法者"], context["护盾ID"])
        return
    end
    if not _____4E3B_52A8_5F15_7206_62A4_76FE_4ECD_6709_6548(context["护盾控制器"]) then
        _____6E05_7406_85E4_539F_59B9_7EA2W_72B6_6001(context["施法者"], context["护盾ID"])
        return
    end
    _____9020_6210_85E4_539F_59B9_7EA2W_5468_671F_4F24_5BB3(context)
end
local function _____521B_5EFA_85E4_539F_59B9_7EA2W_62A4_76FE(context, caster)
    if not _____5355_4F4D_6709_6548(caster) or GetUnitTypeId(caster) ~= _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID then
        return false
    end
    if context["护盾ID"] ~= 0 then
        return false
    end
    local target = GetSpellTargetUnit()
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local owner = GetOwningPlayer(caster)
    if target ~= caster and not IsUnitAlly(target, owner) then
        return false
    end
    if not _____76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3(target) and target ~= caster then
        return false
    end
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    local shieldValue = attack * _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["护盾值攻击力倍率"]
    local periodicDamage = attack * _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["周期伤害攻击力倍率"]
    if not (shieldValue > 0) or not (periodicDamage > 0) then
        return false
    end
    context["施法者"] = caster
    context["护盾目标"] = target
    context["周期伤害"] = periodicDamage
    local _____63A7_5236_5668 = _____521B_5EFA_4E3B_52A8_5F15_7206_62A4_76FE({
        ["名称"] = "藤原妹红-火焰护盾",
        ["施法者"] = caster,
        ["护盾目标"] = target,
        ["主技能ID"] = _____4E3B_6280_80FDID,
        ["引爆技能ID"] = _____5F15_7206_6280_80FDID,
        ["护盾标签"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["护盾标签"],
        ["护盾参数"] = {
            ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
            ["数值"] = shieldValue,
            ["持续时间"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["护盾持续秒"],
            ["来源单位"] = caster,
            ["显示护盾条"] = true,
            ["可驱散"] = false
        },
        ["on创建前"] = _____85E4_539F_59B9_7EA2W_62A4_76FE_521B_5EFA_524D,
        ["on清理"] = _____85E4_539F_59B9_7EA2W_62A4_76FE_6E05_7406,
        ["on引爆前"] = _____85E4_539F_59B9_7EA2W_62A4_76FE_5F15_7206_524D,
        ["on引爆后"] = _____85E4_539F_59B9_7EA2W_62A4_76FE_5F15_7206_540E
    })
    if _____63A7_5236_5668 == nil then
        context["护盾目标"] = nil
        context["周期伤害"] = 0
        return false
    end
    context["护盾控制器"] = _____63A7_5236_5668
    context["护盾ID"] = _____63A7_5236_5668["护盾ID"]
    context["周期回调ID"] = addPeriodicCallback(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["周期伤害间隔毫秒"], _____85E4_539F_59B9_7EA2W_5468_671FTick, context)
    return true
end
local function _____53D6_85E4_539F_59B9_7EA2_7B26_5361W_4E0A_4E0B_6587(caster)
    return _____85E4_539F_59B9_7EA2_7B26_5361W_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(caster)]
end
local function _____6E05_7406_85E4_539F_59B9_7EA2_7B26_5361W(context)
    if not context["活跃"] then
        return
    end
    context["活跃"] = false
    if context["进度条特效"] ~= nil then
        _____9500_6BC1_8FDB_5EA6_6761_7279_6548(context["进度条特效"])
        context["进度条特效"] = nil
    end
    if context["推进回调ID"] ~= 0 then
        removePeriodicCallback(context["推进回调ID"])
        context["推进回调ID"] = 0
    end
    do
        local i = 0
        while i < #context["位移ID列表"] do
            local displacementId = context["位移ID列表"][i + 1]
            __TS__Delete(_____85E4_539F_59B9_7EA2_7B26_5361W_4F4D_79FB_8868, displacementId)
            if displacementId ~= 0 then
                _____505C_6B62_4F4D_79FB(displacementId, "中断")
            end
            i = i + 1
        end
    end
    __TS__ArraySetLength(context["位移ID列表"], 0)
    SetUnitTimeScale(context["施法者"], _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["动作恢复速度"])
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if _____85E4_539F_59B9_7EA2_7B26_5361W_4E0A_4E0B_6587_8868[casterId] == context then
        __TS__Delete(_____85E4_539F_59B9_7EA2_7B26_5361W_4E0A_4E0B_6587_8868, casterId)
    end
end
local function _____85E4_539F_59B9_7EA2_7B26_5361W_63A8_8FDBTick(variable)
    local context = variable
    if context == nil or not context["活跃"] then
        return
    end
    if not _____5355_4F4D_6709_6548(context["施法者"]) or not _____5355_4F4D_6709_6548(context["目标"]) then
        _____6E05_7406_85E4_539F_59B9_7EA2_7B26_5361W(context)
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡W"]
    context["推进计时秒"] = context["推进计时秒"] + cfg["推进表现间隔毫秒"] * 0.001
    context["推进总计时秒"] = context["推进总计时秒"] + cfg["推进表现间隔毫秒"] * 0.001
    if context["推进计时秒"] >= cfg["推进表现时间增量秒"] then
        context["推进计时秒"] = context["推进计时秒"] - cfg["推进表现时间增量秒"]
        local targetX = GetUnitX(context["目标"])
        local targetY = GetUnitY(context["目标"])
        local effectX = targetX + Cos(context["方向角"] * BJ_DEGTORAD) * cfg["击退距离"]
        local effectY = targetY + Sin(context["方向角"] * BJ_DEGTORAD) * cfg["击退距离"]
        do
            local i = 0
            while i < #cfg["命中特效"] do
                _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["命中特效"][i + 1], effectX, effectY, context["方向角"])
                i = i + 1
            end
        end
    end
    if context["推进总计时秒"] < cfg["击退持续秒"] then
        return
    end
    removePeriodicCallback(context["推进回调ID"])
    context["推进回调ID"] = 0
    if context["剩余位移数"] == 0 then
        _____6E05_7406_85E4_539F_59B9_7EA2_7B26_5361W(context)
    end
end
local function _____85E4_539F_59B9_7EA2_7B26_5361W_76EE_6807_4F4D_79FB_7ED3_675F(target, reason, displacementId)
    local context = _____85E4_539F_59B9_7EA2_7B26_5361W_4F4D_79FB_8868[displacementId]
    if context == nil then
        return
    end
    __TS__Delete(_____85E4_539F_59B9_7EA2_7B26_5361W_4F4D_79FB_8868, displacementId)
    do
        local i = 0
        while i < #context["位移ID列表"] do
            do
                if context["位移ID列表"][i + 1] ~= displacementId then
                    goto __continue59
                end
                __TS__ArraySplice(context["位移ID列表"], i, 1)
                break
            end
            ::__continue59::
            i = i + 1
        end
    end
    if context["活跃"] and reason == "撞墙" and _____5355_4F4D_6709_6548(target) then
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = context["施法者"],
            ["目标"] = target,
            ["伤害"] = context["伤害"] * 0.5,
            ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
            attack = false,
            ranged = false,
            attackType = ATTACK_TYPE_NORMAL,
            ["来源类型"] = "单位技能",
            ["技能ID"] = _____7B26_5361W_6280_80FDID,
            ["技能实例ID"] = context["技能实例ID"],
            ["标签"] = "藤原妹红-符卡W-撞地形追加伤害"
        })
    end
    if context["活跃"] and (reason == "撞墙" or reason == "完成") and _____5355_4F4D_6709_6548(target) then
        local _____6536_5C3E_7279_6548 = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡W"]["收尾特效"]
        _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(
            _____6536_5C3E_7279_6548,
            GetUnitX(target),
            GetUnitY(target)
        )
    end
    context["剩余位移数"] = context["剩余位移数"] - 1
    if context["活跃"] and context["剩余位移数"] <= 0 and context["推进回调ID"] == 0 then
        _____6E05_7406_85E4_539F_59B9_7EA2_7B26_5361W(context)
    end
end
local function _____7B26_5361W_76EE_6807_5141_8BB8_547D_4E2D(caster, target)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_STRUCTURE) then
        return false
    end
    return IsUnitEnemy(
        target,
        GetOwningPlayer(caster)
    )
end
local function _____7ED3_7B97_85E4_539F_59B9_7EA2_7B26_5361W(context)
    if not context["活跃"] or not _____5355_4F4D_6709_6548(context["施法者"]) or not _____5355_4F4D_6709_6548(context["目标"]) then
        _____6E05_7406_85E4_539F_59B9_7EA2_7B26_5361W(context)
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡W"]
    local caster = context["施法者"]
    local target = context["目标"]
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local nearTargetX = targetX - Cos(context["方向角"] * BJ_DEGTORAD) * cfg["贴近目标距离"]
    local nearTargetY = targetY - Sin(context["方向角"] * BJ_DEGTORAD) * cfg["贴近目标距离"]
    SetUnitX(caster, nearTargetX)
    SetUnitY(caster, nearTargetY)
    local casterTargetDistance = _____8DDD_79BBXY(
        GetUnitX(caster),
        GetUnitY(caster),
        targetX,
        targetY
    )
    if casterTargetDistance >= 250 then
        _____6E05_7406_85E4_539F_59B9_7EA2_7B26_5361W(context)
        return
    end
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(caster, cfg["结算音效键"])
    _____64AD_653E_85E4_539F_59B9_7EA2_914D_7F6E_52A8_4F5C(caster, cfg["命中动作编号"], cfg["命中动作速度"])
    local targets = _____83B7_53D6_8303_56F4_654C_519B(
        caster,
        GetUnitX(caster),
        GetUnitY(caster),
        cfg["搜索范围"]
    )
    do
        local i = 0
        while i < #targets do
            do
                local hitTarget = targets[i + 1]
                if not _____7B26_5361W_76EE_6807_5141_8BB8_547D_4E2D(caster, hitTarget) then
                    goto __continue72
                end
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = caster,
                    ["目标"] = hitTarget,
                    ["伤害"] = context["伤害"],
                    ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = _____7B26_5361W_6280_80FDID,
                    ["技能实例ID"] = context["技能实例ID"],
                    ["标签"] = "藤原妹红-符卡W-初次命中"
                })
                _____65BD_52A0_7729_6655(
                    caster,
                    hitTarget,
                    cfg["控制秒"],
                    "藤原妹红-符卡W",
                    "技能"
                )
                local displacementId = _____5F00_59CB_51FB_9000(hitTarget, {
                    ["角度"] = context["方向角"],
                    ["距离"] = cfg["击退距离"],
                    ["持续时间"] = cfg["击退持续秒"],
                    ["检查地形"] = true,
                    ["禁用碰撞"] = true,
                    ["主单位"] = caster,
                    ["主单位死亡时中断"] = true,
                    ["结束回调"] = _____85E4_539F_59B9_7EA2_7B26_5361W_76EE_6807_4F4D_79FB_7ED3_675F
                })
                if displacementId > 0 then
                    context["剩余位移数"] = context["剩余位移数"] + 1
                    local ____context__4F4D_79FBID_5217_8868_13 = context["位移ID列表"]
                    ____context__4F4D_79FBID_5217_8868_13[#____context__4F4D_79FBID_5217_8868_13 + 1] = displacementId
                    _____85E4_539F_59B9_7EA2_7B26_5361W_4F4D_79FB_8868[displacementId] = context
                end
            end
            ::__continue72::
            i = i + 1
        end
    end
    context["推进回调ID"] = addPeriodicCallback(cfg["推进表现间隔毫秒"], _____85E4_539F_59B9_7EA2_7B26_5361W_63A8_8FDBTick, context)
end
local function _____91CA_653E_85E4_539F_59B9_7EA2_7B26_5361W(_context, caster, skillInstanceId)
    local target = GetSpellTargetUnit()
    local casterValid = _____5355_4F4D_6709_6548(caster)
    local targetValid = _____5355_4F4D_6709_6548(target)
    if not casterValid or not targetValid then
        return
    end
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(caster)
    local oldContext = _____85E4_539F_59B9_7EA2_7B26_5361W_4E0A_4E0B_6587_8868[casterId]
    if oldContext ~= nil then
        _____6E05_7406_85E4_539F_59B9_7EA2_7B26_5361W(oldContext)
    end
    _____5173_95ED_85E4_539F_59B9_7EA2_7B26_5361_6A21_5F0F(caster, true)
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡W"]
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548(target, {["模型路径"] = cfg["目标预警特效"], ["持续秒"] = cfg["命中延迟秒"]}, "origin")
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        GetUnitX(target),
        GetUnitY(target)
    )
    SetUnitFacing(caster, _____65B9_5411_89D2)
    SetUnitFacing(target, _____65B9_5411_89D2 + 180)
    _____5F00_59CB_786C_76F4(caster, cfg["硬直秒"])
    _____64AD_653E_85E4_539F_59B9_7EA2_914D_7F6E_52A8_4F5C(caster, cfg["动作编号"], cfg["动作速度"])
    local progressEffect = _____521B_5EFA_8FDB_5EA6_6761_7279_6548(caster, {["高度偏移"] = cfg["进度条高度偏移"], ["动画速度"] = cfg["进度条动画速度"]})
    local context = {
        ["施法者"] = caster,
        ["目标"] = target,
        ["方向角"] = _____65B9_5411_89D2,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * cfg["伤害攻击力倍率"],
        ["技能实例ID"] = skillInstanceId,
        ["进度条特效"] = progressEffect,
        ["推进回调ID"] = 0,
        ["推进计时秒"] = 0,
        ["推进总计时秒"] = 0,
        ["剩余位移数"] = 0,
        ["位移ID列表"] = {},
        ["活跃"] = true
    }
    _____85E4_539F_59B9_7EA2_7B26_5361W_4E0A_4E0B_6587_8868[casterId] = context
    addDelayedCallback(cfg["命中延迟秒"] * 1000, _____7ED3_7B97_85E4_539F_59B9_7EA2_7B26_5361W, context)
end
local function _____5F15_7206_85E4_539F_59B9_7EA2W_62A4_76FE(context, caster)
    if not _____5355_4F4D_6709_6548(caster) then
        return
    end
    _____5F15_7206_4E3B_52A8_5F15_7206_62A4_76FE(context["护盾控制器"])
end
local function _____85E4_539F_59B9_7EA2W_4E3B_6280_80FD_76D1_542C(_context, caster)
    local context = _____83B7_53D6_85E4_539F_59B9_7EA2W_4E0A_4E0B_6587(caster)
    if context ~= nil then
        _____521B_5EFA_85E4_539F_59B9_7EA2W_62A4_76FE(context, caster)
    end
end
local function _____85E4_539F_59B9_7EA2W_5F15_7206_76D1_542C(_context, caster)
    local context = _____83B7_53D6_85E4_539F_59B9_7EA2W_4E0A_4E0B_6587(caster)
    if context ~= nil then
        _____5F15_7206_85E4_539F_59B9_7EA2W_62A4_76FE(context, caster)
    end
end
local function _____85E4_539F_59B9_7EA2W_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local cardContext = _____53D6_85E4_539F_59B9_7EA2_7B26_5361W_4E0A_4E0B_6587(dyingUnit)
    if cardContext ~= nil then
        _____6E05_7406_85E4_539F_59B9_7EA2_7B26_5361W(cardContext)
    end
    for key in pairs(_____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868) do
        do
            local context = _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868[__TS__Number(key)]
            if context == nil then
                goto __continue86
            end
            if context["施法者"] ~= dyingUnit and context["护盾目标"] ~= dyingUnit then
                goto __continue86
            end
            local caster = context["施法者"]
            _____6E05_7406_85E4_539F_59B9_7EA2W_72B6_6001(caster, context["护盾ID"])
            __TS__Delete(
                _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868,
                __TS__Number(key)
            )
        end
        ::__continue86::
    end
end
____exports["注册藤原妹红W技能"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-火焰护盾",
        ["单位类型ID"] = _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____4E3B_6280_80FDID,
        ["获取或创建上下文"] = ____exports["获取或创建藤原妹红W上下文"],
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____85E4_539F_59B9_7EA2W_4E3B_6280_80FD_76D1_542C
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-火焰护盾引爆",
        ["单位类型ID"] = _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5F15_7206_6280_80FDID,
        ["获取或创建上下文"] = ____exports["获取或创建藤原妹红W上下文"],
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____85E4_539F_59B9_7EA2W_5F15_7206_76D1_542C
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-符卡W",
        ["单位类型ID"] = _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7B26_5361W_6280_80FDID,
        ["获取或创建上下文"] = ____exports["获取或创建藤原妹红W上下文"],
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 4,
        ["释放技能"] = _____91CA_653E_85E4_539F_59B9_7EA2_7B26_5361W
    })
    if not _____85E4_539F_59B9_7EA2W_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____85E4_539F_59B9_7EA2W_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(_____85E4_539F_59B9_7EA2W_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册藤原妹红W技能"]()
____exports["藤原妹红W技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["伤害形态"] = "火属性AOE技能伤害",
    ["护盾值"] = "施法者攻击力×4",
    ["周期伤害"] = "每0.5秒，施法者攻击力×0.4，半径350码",
    ["引爆伤害"] = "剩余护盾值100%，半径600码"
}
return ____exports
