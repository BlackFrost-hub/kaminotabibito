local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_521B_5EFA_524D, _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_5F15_7206_524D, _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_5F15_7206_540E, _____64AD_653E_88C1_51B3_62A4_76FE_5F15_7206_8868_73B0, _____7ED3_7B97_88C1_51B3_62A4_76FE_5F15_7206, _____83B7_53D6_8303_56F4_654C_519B, _____65BD_52A0_7729_6655, _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548, createTimedUnitEffect, GetUnitX, GetUnitY, IsUnitType, UNIT_TYPE_ANCIENT, UNIT_TYPE_MECHANICAL
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00．配置")
local _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["阿伦劳特单位技能配置"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51FB_9000 = _____51FB_9000_7CFB_7EDF["开始击退"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____07_FF0E_62A4_76FE = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____521B_5EFA_4E3B_52A8_5F15_7206_62A4_76FE = ____07_FF0E_62A4_76FE["创建主动引爆护盾"]
local _____5F15_7206_4E3B_52A8_5F15_7206_62A4_76FE = ____07_FF0E_62A4_76FE["引爆主动引爆护盾"]
local _____62A4_76FE_7C7B_578B = ____07_FF0E_62A4_76FE["护盾类型"]
local _____6E05_7406_4E3B_52A8_5F15_7206_62A4_76FE = ____07_FF0E_62A4_76FE["清理主动引爆护盾"]
function _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_521B_5EFA_524D(controller)
    local config = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E
    _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        controller["护盾目标"],
        config["表现资源"]["裁决护盾特效路径"],
        config["表现资源"]["裁决护盾特效键"],
        config["表现资源"]["裁决护盾特效缩放"],
        config["表现资源"]["裁决护盾特效高度"]
    )
end
function _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_5F15_7206_524D(controller, _remaining)
    _____64AD_653E_88C1_51B3_62A4_76FE_5F15_7206_8868_73B0(controller["施法者"])
end
function _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_5F15_7206_540E(controller, _remaining)
    _____7ED3_7B97_88C1_51B3_62A4_76FE_5F15_7206(controller["施法者"])
end
function _____64AD_653E_88C1_51B3_62A4_76FE_5F15_7206_8868_73B0(unit)
    local config = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E
    createTimedUnitEffect(unit, "origin", config["表现资源"]["裁决护盾引爆特效路径A"], config["表现资源"]["引爆特效持续秒"])
    createTimedUnitEffect(unit, "origin", config["表现资源"]["裁决护盾引爆特效路径B"], config["表现资源"]["引爆特效持续秒"])
end
function _____7ED3_7B97_88C1_51B3_62A4_76FE_5F15_7206(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local config = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    local targets = _____83B7_53D6_8303_56F4_654C_519B(unit, x, y, config["引爆范围"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue28
                end
                if IsUnitType(target, UNIT_TYPE_ANCIENT) or IsUnitType(target, UNIT_TYPE_MECHANICAL) then
                    goto __continue28
                end
                _____65BD_52A0_7729_6655(
                    unit,
                    target,
                    config["引爆眩晕秒"],
                    "阿伦劳特-裁决护盾",
                    "技能"
                )
                _____5F00_59CB_51FB_9000(target, {
                    ["来源单位"] = unit,
                    ["距离"] = config["引爆击退距离"],
                    ["持续时间"] = config["引爆击退持续秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["主单位死亡时中断"] = false
                })
            end
            ::__continue28::
            i = i + 1
        end
    end
end
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____83B7_53D6_8303_56F4_654C_519B = ____require_result_1["获取范围敌军"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
_____65BD_52A0_7729_6655 = ____require_result_2["施加眩晕"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
local _____5F00_59CB_65E0_654C_5E27 = ____require_result_3["开始无敌帧"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_4["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_4["销毁单位坐标跟随特效"]
createTimedUnitEffect = ____require_result_4.createTimedUnitEffect
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local jass = require("jass.common")
local japi = require("jass.japi")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitStateJapi = japi.GetUnitState
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
IsUnitType = jass.IsUnitType
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local _____5149_5F62_6001_5355_4F4DID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["光形态单位ID"])
local _____6697_5F62_6001_5355_4F4DID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["暗形态单位ID"])
local _____4E3B_6280_80FDID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["主技能ID"])
local _____5F15_7206_6280_80FDID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["引爆技能ID"])
local _____5929_5802_547C_5524_5F3A_5316BuffID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["天堂呼唤强化BuffID"])
local _____88C1_51B3_5BA1_5224_5F3A_5316BuffID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["裁决审判强化BuffID"])
local _____963F_4F26_52B3_7279_4E0A_4E0B_6587_8868 = {}
local _____5DF2_6CE8_518C = false
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["获取或创建阿伦劳特上下文"] = function(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 then
        return nil
    end
    local current = _____963F_4F26_52B3_7279_4E0A_4E0B_6587_8868[unitId]
    if current ~= nil then
        return current
    end
    local created = {["单位"] = unit, ["裁决护盾ID"] = 0, ["裁决护盾控制器"] = nil}
    _____963F_4F26_52B3_7279_4E0A_4E0B_6587_8868[unitId] = created
    return created
end
local function _____53D6_963F_4F26_52B3_7279_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    local ____temp_6
    if unitId == 0 then
        ____temp_6 = nil
    else
        ____temp_6 = _____963F_4F26_52B3_7279_4E0A_4E0B_6587_8868[unitId]
    end
    return ____temp_6
end
local function _____5355_4F4D_62E5_6709_539F_751FBuff(unit, buffId)
    if unit == nil or unit == 0 or buffId == 0 then
        return false
    end
    return GetUnitAbilityLevel(unit, buffId) > 0
end
local function _____6E05_7406_88C1_51B3_62A4_76FE_6280_80FD_72B6_6001(unit, shieldId)
    local context = _____53D6_963F_4F26_52B3_7279_4E0A_4E0B_6587(unit)
    if context == nil then
        return
    end
    if shieldId ~= nil and context["裁决护盾ID"] ~= 0 and context["裁决护盾ID"] ~= shieldId then
        return
    end
    local _____63A7_5236_5668 = context["裁决护盾控制器"]
    context["裁决护盾控制器"] = nil
    _____6E05_7406_4E3B_52A8_5F15_7206_62A4_76FE(_____63A7_5236_5668, "技能状态清理")
end
local function _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_6E05_7406(controller, _reason)
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(controller["护盾目标"], _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["表现资源"]["裁决护盾特效键"])
    local context = _____53D6_963F_4F26_52B3_7279_4E0A_4E0B_6587(controller["施法者"])
    if context == nil then
        return
    end
    if context["裁决护盾控制器"] ~= nil and context["裁决护盾控制器"] ~= controller then
        return
    end
    context["裁决护盾ID"] = 0
    context["裁决护盾控制器"] = nil
end
local function _____521B_5EFA_88C1_51B3_62A4_76FE(unit)
    if not _____5355_4F4D_6709_6548(unit) or GetUnitTypeId(unit) ~= _____6697_5F62_6001_5355_4F4DID then
        return false
    end
    local context = ____exports["获取或创建阿伦劳特上下文"](unit)
    if context == nil then
        return false
    end
    local config = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E
    local _____5F3A_5316 = _____5355_4F4D_62E5_6709_539F_751FBuff(unit, _____88C1_51B3_5BA1_5224_5F3A_5316BuffID)
    local _____62A4_76FE_503C = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) * (_____5F3A_5316 and config["裁决护盾强化最大生命比例"] or config["裁决护盾默认最大生命比例"])
    if not (_____62A4_76FE_503C > 0) then
        return false
    end
    local _____63A7_5236_5668 = _____521B_5EFA_4E3B_52A8_5F15_7206_62A4_76FE({
        ["名称"] = "阿伦劳特-裁决护盾",
        ["施法者"] = unit,
        ["护盾目标"] = unit,
        ["主技能ID"] = _____4E3B_6280_80FDID,
        ["引爆技能ID"] = _____5F15_7206_6280_80FDID,
        ["护盾标签"] = config["裁决护盾标签"],
        ["护盾参数"] = {
            ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
            ["数值"] = _____62A4_76FE_503C,
            ["持续时间"] = config["裁决护盾持续秒"],
            ["来源单位"] = unit,
            ["显示护盾条"] = true,
            ["可驱散"] = false
        },
        ["on创建前"] = _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_521B_5EFA_524D,
        ["on清理"] = _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_6E05_7406,
        ["on引爆前"] = _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_5F15_7206_524D,
        ["on引爆后"] = _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_5F15_7206_540E
    })
    if _____63A7_5236_5668 == nil then
        return false
    end
    context["裁决护盾控制器"] = _____63A7_5236_5668
    context["裁决护盾ID"] = _____63A7_5236_5668["护盾ID"]
    return true
end
local function _____5F15_7206_88C1_51B3_62A4_76FE(unit)
    if not _____5355_4F4D_6709_6548(unit) or GetUnitTypeId(unit) ~= _____6697_5F62_6001_5355_4F4DID then
        return
    end
    local context = _____53D6_963F_4F26_52B3_7279_4E0A_4E0B_6587(unit)
    _____5F15_7206_4E3B_52A8_5F15_7206_62A4_76FE(context and context["裁决护盾控制器"])
end
____exports["释放神圣护甲"] = function(unit)
    if not _____5355_4F4D_6709_6548(unit) or GetUnitTypeId(unit) ~= _____5149_5F62_6001_5355_4F4DID then
        return false
    end
    local duration = _____5355_4F4D_62E5_6709_539F_751FBuff(unit, _____5929_5802_547C_5524_5F3A_5316BuffID) and _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["神圣护甲强化持续秒"] or _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["神圣护甲默认持续秒"]
    return _____5F00_59CB_65E0_654C_5E27(unit, duration) > 0
end
____exports["释放裁决护盾"] = function(unit)
    return _____521B_5EFA_88C1_51B3_62A4_76FE(unit)
end
local function _____963F_4F26_52B3_7279_795E_5723_62A4_7532_76D1_542C(_context, unit)
    ____exports["释放神圣护甲"](unit)
end
local function _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_76D1_542C(_context, unit)
    ____exports["释放裁决护盾"](unit)
end
local function _____963F_4F26_52B3_7279_62A4_76FE_5F15_7206_76D1_542C(_context, unit)
    _____5F15_7206_88C1_51B3_62A4_76FE(unit)
end
local function _____963F_4F26_52B3_7279_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local unitTypeId = GetUnitTypeId(dyingUnit)
    if unitTypeId ~= _____5149_5F62_6001_5355_4F4DID and unitTypeId ~= _____6697_5F62_6001_5355_4F4DID then
        return
    end
    _____6E05_7406_88C1_51B3_62A4_76FE_6280_80FD_72B6_6001(dyingUnit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(dyingUnit)
    if unitId ~= 0 then
        __TS__Delete(_____963F_4F26_52B3_7279_4E0A_4E0B_6587_8868, unitId)
    end
end
____exports["注册阿伦劳特神圣护甲与裁决护盾"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "阿伦劳特-神圣护甲",
        ["单位类型ID"] = _____5149_5F62_6001_5355_4F4DID,
        ["技能ID"] = _____4E3B_6280_80FDID,
        ["获取或创建上下文"] = ____exports["获取或创建阿伦劳特上下文"],
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____963F_4F26_52B3_7279_795E_5723_62A4_7532_76D1_542C
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "阿伦劳特-裁决护盾",
        ["单位类型ID"] = _____6697_5F62_6001_5355_4F4DID,
        ["技能ID"] = _____4E3B_6280_80FDID,
        ["获取或创建上下文"] = ____exports["获取或创建阿伦劳特上下文"],
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____963F_4F26_52B3_7279_88C1_51B3_62A4_76FE_76D1_542C
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "阿伦劳特-裁决护盾引爆",
        ["单位类型ID"] = _____6697_5F62_6001_5355_4F4DID,
        ["技能ID"] = _____5F15_7206_6280_80FDID,
        ["获取或创建上下文"] = ____exports["获取或创建阿伦劳特上下文"],
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____963F_4F26_52B3_7279_62A4_76FE_5F15_7206_76D1_542C
    })
    registerDeathListener(_____963F_4F26_52B3_7279_5355_4F4D_6B7B_4EA1)
end
____exports["注册阿伦劳特神圣护甲与裁决护盾"]()
____exports["阿伦劳特神圣护甲与裁决护盾技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "无直接伤害",
    ["神圣护甲"] = "光形态免疫伤害3秒；拥有B018时免疫5秒",
    ["裁决护盾"] = "暗形态获得最大生命值50%的4秒通用护盾；拥有B015时为100%",
    ["引爆效果"] = "400范围内敌方非远古、非机械单位眩晕1秒并击退400码"
}
return ____exports
