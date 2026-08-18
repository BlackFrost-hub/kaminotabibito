--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00．配置")
local _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["藤原妹红单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_0.YDWESetUnitAbilityStateSafe
local ____require_result_1 = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算")
local getCooldownReduction = ____require_result_1.getCooldownReduction
local applyCooldownCap = ____require_result_1.applyCooldownCap
local calcActualCooldown = ____require_result_1.calcActualCooldown
local stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____7B26_5361_5F00_5173_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡开关技能ID"])
local _____7B26_5361_5173_95ED_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡关闭技能ID"])
local _____7B26_5361_5F00_5173_51B7_5374_79D2 = 12
local GetOwningPlayer = jass.GetOwningPlayer
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local function _____8BBE_7F6E_6280_80FD_663E_793A(unit, skillIds, available)
    local owner = GetOwningPlayer(unit)
    do
        local i = 0
        while i < #skillIds do
            local abilityId = stringToFourCCSafe(skillIds[i + 1])
            SetPlayerAbilityAvailable(owner, abilityId, available)
            i = i + 1
        end
    end
end
local function _____5F00_542F_7B26_5361_6A21_5F0F(_context, caster)
    _____8BBE_7F6E_6280_80FD_663E_793A(caster, _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通模式技能ID列表"], false)
    _____8BBE_7F6E_6280_80FD_663E_793A(caster, _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡模式技能ID列表"], true)
    UnitAddAbility(caster, _____7B26_5361_5173_95ED_6280_80FDID)
    UnitRemoveAbility(caster, _____7B26_5361_5F00_5173_6280_80FDID)
end
____exports["关闭藤原妹红符卡模式"] = function(caster, _____65BD_653E_7B26_5361_540E_8FDB_5165_51B7_5374)
    if _____65BD_653E_7B26_5361_540E_8FDB_5165_51B7_5374 == nil then
        _____65BD_653E_7B26_5361_540E_8FDB_5165_51B7_5374 = false
    end
    if caster == nil or caster == 0 then
        return
    end
    _____8BBE_7F6E_6280_80FD_663E_793A(caster, _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡模式技能ID列表"], false)
    _____8BBE_7F6E_6280_80FD_663E_793A(caster, _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通模式技能ID列表"], true)
    UnitAddAbility(caster, _____7B26_5361_5F00_5173_6280_80FDID)
    UnitRemoveAbility(caster, _____7B26_5361_5173_95ED_6280_80FDID)
    if _____65BD_653E_7B26_5361_540E_8FDB_5165_51B7_5374 then
        local reduction = getCooldownReduction(caster)
        local cappedReduction = applyCooldownCap(reduction, _____7B26_5361_5F00_5173_6280_80FDID, 0)
        local actualCooldown = calcActualCooldown(_____7B26_5361_5F00_5173_51B7_5374_79D2, cappedReduction)
        YDWESetUnitAbilityStateSafe(caster, _____7B26_5361_5F00_5173_6280_80FDID, 1, actualCooldown)
    end
end
local function _____5173_95ED_7B26_5361_6A21_5F0F_6280_80FD_76D1_542C(_context, caster)
    ____exports["关闭藤原妹红符卡模式"](caster, false)
end
local function _____83B7_53D6_85E4_539F_59B9_7EA2_6280_80FD_4E0A_4E0B_6587(unit)
    return unit
end
____exports["注册藤原妹红符卡模式"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-开启符卡",
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7B26_5361_5F00_5173_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_85E4_539F_59B9_7EA2_6280_80FD_4E0A_4E0B_6587,
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____5F00_542F_7B26_5361_6A21_5F0F
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-关闭符卡",
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7B26_5361_5173_95ED_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_85E4_539F_59B9_7EA2_6280_80FD_4E0A_4E0B_6587,
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____5173_95ED_7B26_5361_6A21_5F0F_6280_80FD_76D1_542C
    })
end
____exports["注册藤原妹红符卡模式"]()
____exports["藤原妹红E技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["开启技能"] = "A0GG",
    ["关闭技能"] = "A0GF",
    ["模式切换"] = "全局同步切换技能可用性，符卡施放后自动恢复普通模式"
}
return ____exports
