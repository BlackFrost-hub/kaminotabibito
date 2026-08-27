local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____521B_5EFA_54B2_591C_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建咲夜单位壳"]
local _____5B89_5168_79FB_9664_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["安全移除单位壳"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local _____64AD_653E_54B2_591C_5750_6807_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜坐标音效"]
local _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注册咲夜周期任务"]
local _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["移除咲夜周期任务"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_0["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_0["移除单位暂停"]
local ____require_result_1 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitLifePercentBJ = ____require_result_1.SetUnitLifePercentBJ
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitScale = jass.SetUnitScale
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitVertexColor = jass.SetUnitVertexColor
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local GetOwningPlayer = jass.GetOwningPlayer
local UNIT_TYPE_TAUREN = jass.UNIT_TYPE_TAUREN
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local ____D_89C6_89C9_51BB_7ED3_8BA1_6570 = {}
local function _____83B7_53D6D_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function _____8FDB_5165D_89C6_89C9_51BB_7ED3(unit)
    local id = GetHandleId(unit)
    local count = ____D_89C6_89C9_51BB_7ED3_8BA1_6570[id] or 0
    ____D_89C6_89C9_51BB_7ED3_8BA1_6570[id] = count + 1
    if count > 0 then
        return
    end
    SetUnitTimeScale(unit, 0)
    SetUnitVertexColor(
        unit,
        255,
        255,
        255,
        _____914D_7F6E.D["冻结透明度"]
    )
end
local function _____79BB_5F00D_89C6_89C9_51BB_7ED3(unit)
    local id = GetHandleId(unit)
    local count = ____D_89C6_89C9_51BB_7ED3_8BA1_6570[id] or 0
    if count <= 1 then
        __TS__Delete(____D_89C6_89C9_51BB_7ED3_8BA1_6570, id)
        SetUnitTimeScale(unit, 1)
        SetUnitVertexColor(
            unit,
            255,
            255,
            255,
            255
        )
    else
        ____D_89C6_89C9_51BB_7ED3_8BA1_6570[id] = count - 1
    end
end
local function _____91CA_653ED_51BB_7ED3_5355_4F4D(context, record)
    _____79FB_9664_5355_4F4D_6682_505C(record["单位"], context["来源"])
    _____79BB_5F00D_89C6_89C9_51BB_7ED3(record["单位"])
    __TS__Delete(
        context["记录"],
        GetHandleId(record["单位"])
    )
end
local function _____7ED3_675FD_6280_80FD(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    if context["周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["周期ID"])
    end
    context["周期ID"] = 0
    for key in pairs(context["记录"]) do
        local record = context["记录"][key]
        if record ~= nil then
            _____91CA_653ED_51BB_7ED3_5355_4F4D(context, record)
        end
    end
    if context["枚举组"] ~= nil and context["枚举组"] ~= 0 then
        jass:DestroyGroup(context["枚举组"])
    end
    context["枚举组"] = nil
    _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["世界单位"])
    _____64AD_653E_54B2_591C_5750_6807_97F3_6548("gg_snd_BlinkBirth1", context["中心X"], context["中心Y"])
end
local function _____679A_4E3ED_8303_56F4_5355_4F4D(context)
    local group = context["枚举组"]
    jass:GroupClear(group)
    jass:GroupEnumUnitsInRange(
        group,
        context["中心X"],
        context["中心Y"],
        _____914D_7F6E.D["半径"],
        nil
    )
    local result = {}
    while true do
        do
            local unit = jass:FirstOfGroup(group)
            if unit == nil or unit == 0 then
                break
            end
            jass:GroupRemoveUnit(group, unit)
            if unit == context["施法者"] or unit == context["世界单位"] then
                goto __continue17
            end
            if not _____5355_4F4D_5B58_6D3B(unit) or IsUnitType(unit, UNIT_TYPE_TAUREN) then
                goto __continue17
            end
            result[#result + 1] = unit
        end
        ::__continue17::
    end
    return result
end
local function _____63A8_8FDBD_6280_80FD(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____7ED3_675FD_6280_80FD(context)
        return
    end
    context.Tick = context.Tick + 1
    local inside = {}
    local units = _____679A_4E3ED_8303_56F4_5355_4F4D(context)
    do
        local i = 0
        while i < #units do
            local unit = units[i + 1]
            local id = GetHandleId(unit)
            inside[id] = true
            local record = context["记录"][id]
            if record == nil then
                local mechanical = IsUnitType(unit, UNIT_TYPE_MECHANICAL)
                record = {
                    ["单位"] = unit,
                    ["机械单位"] = mechanical,
                    ["冻结X"] = GetUnitX(unit),
                    ["冻结Y"] = GetUnitY(unit)
                }
                context["记录"][id] = record
                _____6DFB_52A0_5355_4F4D_6682_505C(unit, context["来源"])
                _____8FDB_5165D_89C6_89C9_51BB_7ED3(unit)
            end
            if record["机械单位"] then
                SetUnitX(unit, record["冻结X"])
                SetUnitY(unit, record["冻结Y"])
                if not IsUnitEnemy(
                    unit,
                    GetOwningPlayer(context["施法者"])
                ) then
                    SetUnitLifePercentBJ(unit, 100)
                end
            end
            i = i + 1
        end
    end
    for key in pairs(context["记录"]) do
        local record = context["记录"][key]
        if record ~= nil and inside[GetHandleId(record["单位"])] ~= true then
            _____91CA_653ED_51BB_7ED3_5355_4F4D(context, record)
        end
    end
    if context.Tick >= _____914D_7F6E.D["持续Tick"] then
        _____7ED3_675FD_6280_80FD(context)
    end
end
local function _____91CA_653E_5341_516D_591C_54B2_591CD(_listener, caster)
    local x = GetSpellTargetX()
    local y = GetSpellTargetY()
    local world = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
        caster,
        _____914D_7F6E["单位壳"]["咲夜的世界"],
        x,
        y,
        0
    )
    if world == nil or world == 0 then
        return
    end
    SetUnitScale(world, _____914D_7F6E.D["世界缩放"], _____914D_7F6E.D["世界缩放"], _____914D_7F6E.D["世界缩放"])
    local context = {
        ["施法者"] = caster,
        ["世界单位"] = world,
        ["中心X"] = x,
        ["中心Y"] = y,
        ["来源"] = "十六夜咲夜-D:" .. tostring(GetHandleId(world)),
        Tick = 0,
        ["周期ID"] = 0,
        ["已结束"] = false,
        ["枚举组"] = jass:CreateGroup(),
        ["记录"] = {}
    }
    _____64AD_653E_54B2_591C_5750_6807_97F3_6548("gg_snd_FlameStrikeTargetWaveNonLoop1", x, y)
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_D", caster)
    context["周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.D["周期毫秒"], _____63A8_8FDBD_6280_80FD, context)
end
____exports["注册十六夜咲夜D"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-小夜特制秒表（D）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].D["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6D_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CD,
        ["创建独立技能实例"] = false
    })
end
____exports["注册十六夜咲夜D"]()
return ____exports
