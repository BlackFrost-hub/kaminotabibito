local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5F15_7206_76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3, _____51C6_5907_85E4_539F_59B9_7EA2W_5F15_7206_76EE_6807_4F24_5BB3, _____85E4_539F_59B9_7EA2W_62A4_76FE_521B_5EFA_524D, _____85E4_539F_59B9_7EA2W_62A4_76FE_5F15_7206_524D, _____83B7_53D6_8303_56F4_654C_519B, createUnitEffect, createTimedEffect, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, GetUnitX, GetUnitY, IsUnitType, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS, UNIT_TYPE_ANCIENT, UNIT_TYPE_STRUCTURE, _____5F15_7206_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00．配置")
local _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["藤原妹红单位技能配置"]
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
function _____5F15_7206_76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3(target)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_STRUCTURE) then
        return false
    end
    return true
end
function _____51C6_5907_85E4_539F_59B9_7EA2W_5F15_7206_76EE_6807_4F24_5BB3(target, _index)
    return _____5F15_7206_76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3(target) and ({}) or nil
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
        GetUnitX(caster),
        GetUnitY(caster),
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
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____5F15_7206_6280_80FDID,
        ["每目标处理器"] = _____51C6_5907_85E4_539F_59B9_7EA2W_5F15_7206_76EE_6807_4F24_5BB3
    })
end
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____83B7_53D6_8303_56F4_654C_519B = ____require_result_1["获取范围敌军"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createUnitEffect = ____require_result_2.createUnitEffect
local destroyUnitEffect = ____require_result_2.destroyUnitEffect
createTimedEffect = ____require_result_2.createTimedEffect
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local removePeriodicCallback = ____require_result_3.removePeriodicCallback
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_4["造成批量AOE技能伤害"]
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
IsUnitType = jass.IsUnitType
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____4E3B_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["主技能ID"])
_____5F15_7206_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["引爆技能ID"])
local _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868 = {}
local _____85E4_539F_59B9_7EA2W_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
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
    local ____temp_6
    if unitId == 0 then
        ____temp_6 = nil
    else
        ____temp_6 = _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868[unitId]
    end
    return ____temp_6
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
local function _____5468_671F_76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3(target)
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
local function _____51C6_5907_85E4_539F_59B9_7EA2W_5468_671F_76EE_6807_4F24_5BB3(target, _index)
    return _____5468_671F_76EE_6807_5141_8BB8_85E4_539F_59B9_7EA2W_4F24_5BB3(target) and ({}) or nil
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
        ["on引爆前"] = _____85E4_539F_59B9_7EA2W_62A4_76FE_5F15_7206_524D
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
    for key in pairs(_____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868) do
        do
            local context = _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868[__TS__Number(key)]
            if context == nil then
                goto __continue47
            end
            if context["施法者"] ~= dyingUnit and context["护盾目标"] ~= dyingUnit then
                goto __continue47
            end
            local caster = context["施法者"]
            _____6E05_7406_85E4_539F_59B9_7EA2W_72B6_6001(caster, context["护盾ID"])
            if caster == dyingUnit then
                __TS__Delete(
                    _____85E4_539F_59B9_7EA2W_4E0A_4E0B_6587_8868,
                    __TS__Number(key)
                )
            end
        end
        ::__continue47::
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
