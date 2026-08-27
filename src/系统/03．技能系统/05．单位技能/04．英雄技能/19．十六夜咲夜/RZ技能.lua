local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____4E24_70B9_89D2_5EA6 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local registerSyncHardwareKey = ____require_result_1.registerSyncHardwareKey
local ____require_result_2 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____require_result_2.KEY
local KEY_STATE = ____require_result_2.KEY_STATE
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_3["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_3["移除单位暂停"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____require_result_4["执行战斗自身传送到坐标"]
local ____RZ_6D3B_52A8_8868 = {}
local ____RZ_5E8F_53F7 = 0
local function _____83B7_53D6RZ_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function ____RZ_89E3_9664_51BB_7ED3(context)
    do
        local i = 0
        while i < #context["冻结单位"] do
            _____79FB_9664_5355_4F4D_6682_505C(context["冻结单位"][i + 1], context["来源"])
            i = i + 1
        end
    end
    context["冻结单位"] = {}
end
local function ____RZ_5173_95ED_8F93_5165(variable)
    local context = variable
    if context == nil then
        return
    end
    context["输入开放"] = false
    local playerId = jass:GetPlayerId(jass:GetOwningPlayer(context["施法者"]))
    if ____RZ_6D3B_52A8_8868[playerId] == context then
        __TS__Delete(____RZ_6D3B_52A8_8868, playerId)
    end
end
local function ____RZ_7B2C_4E00_9636_6BB5(variable)
    local context = variable
    if context == nil or context["已结束"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    local targetFacing = jass:GetUnitFacing(context["目标"])
    local landingX = _____6781_5750_6807X(
        jass:GetUnitX(context["目标"]),
        _____914D_7F6E.RZ["目标偏移"],
        targetFacing + 75
    )
    local landingY = _____6781_5750_6807Y(
        jass:GetUnitY(context["目标"]),
        _____914D_7F6E.RZ["目标偏移"],
        targetFacing + 75
    )
    _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(context["施法者"], landingX, landingY)
    local facing = _____4E24_70B9_89D2_5EA6(
        landingX,
        landingY,
        jass:GetUnitX(context["目标"]),
        jass:GetUnitY(context["目标"])
    )
    jass:SetUnitFacing(context["施法者"], context["保持原位"] and facing or targetFacing)
    jass:SetUnitAnimation(context["施法者"], context["保持原位"] and "attack" or "spell")
end
local function ____RZ_4EA4_6362_7ED3_7B97(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    context["已结束"] = true
    ____RZ_89E3_9664_51BB_7ED3(context)
    if _____5355_4F4D_5B58_6D3B(context["目标"]) then
        jass:SetUnitX(context["目标"], context["原X"])
        jass:SetUnitY(context["目标"], context["原Y"])
    end
    if not context["保持原位"] and _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(context["施法者"], context["原X"], context["原Y"])
    end
    _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["来源"])
    jass:SetUnitTimeScale(context["施法者"], 1)
    jass:SetUnitAnimation(context["施法者"], "stand")
end
local function ____onRZ_540C_6B65Z_952E(event)
    if event.player == nil or event.player == 0 then
        return
    end
    local context = ____RZ_6D3B_52A8_8868[jass:GetPlayerId(event.player)]
    if context ~= nil and context["输入开放"] and not context["已结束"] and jass:GetOwningPlayer(context["施法者"]) == event.player then
        context["保持原位"] = true
    end
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRZ(_listener, caster)
    local target = jass:GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    ____RZ_5E8F_53F7 = ____RZ_5E8F_53F7 + 1
    local context = {
        ["施法者"] = caster,
        ["目标"] = target,
        ["序号"] = ____RZ_5E8F_53F7,
        ["来源"] = "十六夜咲夜-RZ:" .. tostring(____RZ_5E8F_53F7),
        ["原X"] = jass:GetUnitX(caster),
        ["原Y"] = jass:GetUnitY(caster),
        ["保持原位"] = false,
        ["输入开放"] = true,
        ["已结束"] = false,
        ["冻结单位"] = {}
    }
    local group = jass:CreateGroup()
    jass:GroupEnumUnitsInRange(
        group,
        jass:GetUnitX(target),
        jass:GetUnitY(target),
        _____914D_7F6E.RZ["时停半径"],
        nil
    )
    while true do
        do
            local unit = jass:FirstOfGroup(group)
            if unit == nil or unit == 0 then
                break
            end
            jass:GroupRemoveUnit(group, unit)
            if unit == caster or not _____5355_4F4D_5B58_6D3B(unit) or jass:IsUnitType(unit, jass.UNIT_TYPE_TAUREN) then
                goto __continue20
            end
            _____6DFB_52A0_5355_4F4D_6682_505C(unit, context["来源"])
            local ____context__51BB_7ED3_5355_4F4D_5 = context["冻结单位"]
            ____context__51BB_7ED3_5355_4F4D_5[#____context__51BB_7ED3_5355_4F4D_5 + 1] = unit
        end
        ::__continue20::
    end
    jass:DestroyGroup(group)
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["来源"])
    jass:SetUnitAnimation(caster, "spell")
    ____RZ_6D3B_52A8_8868[jass:GetPlayerId(jass:GetOwningPlayer(caster))] = context
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_ManaShieldCaster1", caster)
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RZ", caster)
    addDelayedCallback(_____914D_7F6E.RZ["第一阶段秒"] * 1000, ____RZ_7B2C_4E00_9636_6BB5, context)
    addDelayedCallback(_____914D_7F6E.RZ["交换结算秒"] * 1000, ____RZ_4EA4_6362_7ED3_7B97, context)
    addDelayedCallback(_____914D_7F6E.RZ["输入窗口秒"] * 1000, ____RZ_5173_95ED_8F93_5165, context)
end
____exports["注册十六夜咲夜RZ"] = function()
    registerSyncHardwareKey(KEY.Z, KEY_STATE.DOWN, ____onRZ_540C_6B65Z_952E)
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-调换魔法（RZ）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RZ["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RZ_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRZ,
        ["创建独立技能实例"] = false
    })
end
____exports["注册十六夜咲夜RZ"]()
return ____exports
