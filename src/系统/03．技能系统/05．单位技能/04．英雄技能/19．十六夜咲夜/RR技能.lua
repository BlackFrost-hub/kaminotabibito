local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____521B_5EFA_54B2_591C_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建咲夜单位壳"]
local _____5B89_5168_79FB_9664_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["安全移除单位壳"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____83B7_53D6_54B2_591C_73B0_5B58_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["获取咲夜现存飞刀"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local _____64AD_653E_54B2_591C_5750_6807_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜坐标音效"]
local _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注册咲夜周期任务"]
local _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["移除咲夜周期任务"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_2["技能_设置技能冷却时间"]
local ____RR_5019_9009_8868 = {}
local _____54B2_591C_4E16_754C_8BA1_6570 = {}
local ____RR_5355_4F4D_5168_5C40_72B6_6001_8868 = {}
local ____RR_98DE_5200_5168_5C40_72B6_6001_8868 = {}
local ____RR_5019_9009_81EA_589E_5E8F_53F7 = 0
local _____653B_51FB_95F4_9694_72B6_6001 = jass.ConvertUnitState(37)
local GetUnitStateJapi = japi.GetUnitState
local SetUnitStateJapi = japi.SetUnitState
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜")
local _____5341_516D_591C_54B2_591CBuffID = ____require_result_4["十六夜咲夜BuffID"]
____exports["十六夜咲夜处于咲夜世界"] = function(caster)
    return caster ~= nil and caster ~= 0 and (_____54B2_591C_4E16_754C_8BA1_6570[jass.GetHandleId(caster)] or 0) > 0
end
local function _____83B7_53D6RR_4E00_6BB5_4E0A_4E0B_6587(_caster)
    return {["二段"] = false}
end
local function _____83B7_53D6RR_4E8C_6BB5_4E0A_4E0B_6587(_caster)
    return {["二段"] = true}
end
local function ____RR_5355_4F4D_5728_533A_57DF(context, unit)
    local dx = jass.GetUnitX(unit) - context.X
    local dy = jass.GetUnitY(unit) - context.Y
    return dx * dx + dy * dy <= 800 * 800
end
local function ____RR_5237_65B0_5355_4F4D_5168_5C40_72B6_6001(state)
    if state["完美计数"] > 0 then
        jass.SetUnitTimeScale(state["单位"], 0)
        return
    end
    if state["缓速计数"] > 0 then
        jass.SetUnitMoveSpeed(state["单位"], state["原移动速度"] * 0.5)
        if state["原攻击间隔"] > 0 then
            SetUnitStateJapi(state["单位"], _____653B_51FB_95F4_9694_72B6_6001, state["原攻击间隔"] * 2)
        end
        jass.SetUnitTimeScale(state["单位"], 0.5)
        return
    end
    jass.SetUnitMoveSpeed(state["单位"], state["原移动速度"])
    if state["原攻击间隔"] > 0 then
        SetUnitStateJapi(state["单位"], _____653B_51FB_95F4_9694_72B6_6001, state["原攻击间隔"])
    end
    jass.SetUnitTimeScale(state["单位"], 1)
end
local function ____RR_8FDB_5165_5355_4F4D(context, unit)
    local id = jass.GetHandleId(unit)
    if context["单位记录"][id] ~= nil then
        return
    end
    local record = {["单位"] = unit}
    context["单位记录"][id] = record
    local global = ____RR_5355_4F4D_5168_5C40_72B6_6001_8868[id]
    if global == nil then
        global = {
            ["单位"] = unit,
            ["原移动速度"] = jass.GetUnitMoveSpeed(unit),
            ["原攻击间隔"] = GetUnitStateJapi(unit, _____653B_51FB_95F4_9694_72B6_6001),
            ["缓速计数"] = 0,
            ["完美计数"] = 0
        }
        ____RR_5355_4F4D_5168_5C40_72B6_6001_8868[id] = global
    end
    if context["完美空间"] then
        global["完美计数"] = global["完美计数"] + 1
        _____6DFB_52A0_5355_4F4D_6682_505C(unit, context["来源"])
        registerManualBuff(
            unit,
            _____5341_516D_591C_54B2_591CBuffID["完美空间时间停止"],
            5.2,
            0,
            {sourceUnit = context["施法者"]}
        )
    else
        global["缓速计数"] = global["缓速计数"] + 1
        registerManualBuff(
            unit,
            _____5341_516D_591C_54B2_591CBuffID["个人空间时间缓速"],
            5.2,
            0,
            {sourceUnit = context["施法者"]}
        )
    end
    ____RR_5237_65B0_5355_4F4D_5168_5C40_72B6_6001(global)
end
local function ____RR_79BB_5F00_5355_4F4D(context, record)
    local id = jass.GetHandleId(record["单位"])
    local global = ____RR_5355_4F4D_5168_5C40_72B6_6001_8868[id]
    if context["完美空间"] then
        _____79FB_9664_5355_4F4D_6682_505C(record["单位"], context["来源"])
        if global ~= nil then
            global["完美计数"] = math.max(0, global["完美计数"] - 1)
        end
    elseif global ~= nil then
        global["缓速计数"] = math.max(0, global["缓速计数"] - 1)
    end
    if global ~= nil then
        ____RR_5237_65B0_5355_4F4D_5168_5C40_72B6_6001(global)
        if global["完美计数"] <= 0 then
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["单位"], _____5341_516D_591C_54B2_591CBuffID["完美空间时间停止"])
        end
        if global["缓速计数"] <= 0 then
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["单位"], _____5341_516D_591C_54B2_591CBuffID["个人空间时间缓速"])
        end
        if global["完美计数"] <= 0 and global["缓速计数"] <= 0 then
            __TS__Delete(____RR_5355_4F4D_5168_5C40_72B6_6001_8868, id)
        end
    end
    __TS__Delete(context["单位记录"], id)
end
local function ____RR_8FDB_5165_98DE_5200(context, knife)
    local id = jass.GetHandleId(knife["单位"])
    if context["飞刀记录"][id] ~= nil then
        return
    end
    local record = {["控制器"] = knife}
    context["飞刀记录"][id] = record
    local global = ____RR_98DE_5200_5168_5C40_72B6_6001_8868[id]
    if global == nil then
        global = {
            ["控制器"] = knife,
            ["原速度"] = knife["取每Tick位移"](),
            ["缓速计数"] = 0,
            ["完美计数"] = 0
        }
        ____RR_98DE_5200_5168_5C40_72B6_6001_8868[id] = global
    end
    if context["完美空间"] then
        global["完美计数"] = global["完美计数"] + 1
        _____6DFB_52A0_5355_4F4D_6682_505C(knife["单位"], context["来源"])
    else
        global["缓速计数"] = global["缓速计数"] + 1
        knife["设置每Tick位移"](global["原速度"] * 0.4)
    end
end
local function ____RR_79BB_5F00_98DE_5200(context, record)
    local id = jass.GetHandleId(record["控制器"]["单位"])
    local global = ____RR_98DE_5200_5168_5C40_72B6_6001_8868[id]
    if context["完美空间"] then
        _____79FB_9664_5355_4F4D_6682_505C(record["控制器"]["单位"], context["来源"])
        if global ~= nil then
            global["完美计数"] = math.max(0, global["完美计数"] - 1)
        end
    elseif global ~= nil then
        global["缓速计数"] = math.max(0, global["缓速计数"] - 1)
    end
    if global ~= nil then
        if global["缓速计数"] > 0 then
            record["控制器"]["设置每Tick位移"](global["原速度"] * 0.4)
        else
            record["控制器"]["设置每Tick位移"](global["原速度"])
        end
        if global["完美计数"] <= 0 and global["缓速计数"] <= 0 then
            __TS__Delete(____RR_98DE_5200_5168_5C40_72B6_6001_8868, id)
        end
    end
    __TS__Delete(context["飞刀记录"], id)
end
local function _____7ED3_675FRR_533A_57DF(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    if context["周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["周期ID"])
    end
    for key in pairs(context["单位记录"]) do
        local record = context["单位记录"][key]
        if record ~= nil then
            ____RR_79BB_5F00_5355_4F4D(context, record)
        end
    end
    for key in pairs(context["飞刀记录"]) do
        local record = context["飞刀记录"][key]
        if record ~= nil then
            ____RR_79BB_5F00_98DE_5200(context, record)
        end
    end
    if context["完美空间"] then
        local id = jass.GetHandleId(context["施法者"])
        local count = _____54B2_591C_4E16_754C_8BA1_6570[id] or 0
        if count <= 1 then
            __TS__Delete(_____54B2_591C_4E16_754C_8BA1_6570, id)
        else
            _____54B2_591C_4E16_754C_8BA1_6570[id] = count - 1
        end
        if count <= 1 then
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____5341_516D_591C_54B2_591CBuffID["咲夜的世界"])
        end
    end
    if context["枚举组"] ~= nil and context["枚举组"] ~= 0 then
        jass.DestroyGroup(context["枚举组"])
    end
    _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["世界单位"])
    _____64AD_653E_54B2_591C_5750_6807_97F3_6548("gg_snd_BlinkBirth1", context.X, context.Y)
end
local function _____63A8_8FDBRR_533A_57DF(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    context.Tick = context.Tick + 1
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) or context.Tick >= 50 then
        _____7ED3_675FRR_533A_57DF(context)
        return
    end
    local inside = {}
    jass.GroupClear(context["枚举组"])
    jass.GroupEnumUnitsInRange(
        context["枚举组"],
        context.X,
        context.Y,
        800,
        nil
    )
    while true do
        do
            local unit = jass.FirstOfGroup(context["枚举组"])
            if unit == nil or unit == 0 then
                break
            end
            jass.GroupRemoveUnit(context["枚举组"], unit)
            if unit == context["施法者"] or unit == context["世界单位"] or not _____5355_4F4D_5B58_6D3B(unit) or jass.IsUnitType(unit, jass.UNIT_TYPE_TAUREN) then
                goto __continue54
            end
            inside[jass.GetHandleId(unit)] = true
            ____RR_8FDB_5165_5355_4F4D(context, unit)
        end
        ::__continue54::
    end
    for key in pairs(context["单位记录"]) do
        local record = context["单位记录"][key]
        if record ~= nil and inside[jass.GetHandleId(record["单位"])] ~= true then
            ____RR_79BB_5F00_5355_4F4D(context, record)
        end
    end
    local knives = _____83B7_53D6_54B2_591C_73B0_5B58_98DE_5200(context["施法者"], context.X, context.Y, 800)
    local knifeInside = {}
    do
        local i = 0
        while i < #knives do
            knifeInside[jass.GetHandleId(knives[i + 1]["单位"])] = true
            ____RR_8FDB_5165_98DE_5200(context, knives[i + 1])
            i = i + 1
        end
    end
    for key in pairs(context["飞刀记录"]) do
        local record = context["飞刀记录"][key]
        if record ~= nil and knifeInside[jass.GetHandleId(record["控制器"]["单位"])] ~= true then
            ____RR_79BB_5F00_98DE_5200(context, record)
        end
    end
end
local function _____542F_52A8RR_533A_57DF(caster, perfect, sequence)
    local x = jass.GetUnitX(caster)
    local y = jass.GetUnitY(caster)
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
    if not perfect then
        jass.SetUnitVertexColor(
            world,
            255,
            255,
            125,
            255
        )
    else
        local id = jass.GetHandleId(caster)
        _____54B2_591C_4E16_754C_8BA1_6570[id] = (_____54B2_591C_4E16_754C_8BA1_6570[id] or 0) + 1
        registerManualBuff(
            caster,
            _____5341_516D_591C_54B2_591CBuffID["咲夜的世界"],
            5.2,
            0,
            {sourceUnit = caster}
        )
    end
    local context = {
        ["施法者"] = caster,
        ["世界单位"] = world,
        X = x,
        Y = y,
        ["来源"] = "十六夜咲夜-RR:" .. tostring(sequence),
        ["完美空间"] = perfect,
        Tick = 0,
        ["周期ID"] = 0,
        ["单位记录"] = {},
        ["飞刀记录"] = {},
        ["枚举组"] = jass.CreateGroup(),
        ["已结束"] = false
    }
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RR", caster)
    _____64AD_653E_54B2_591C_5750_6807_97F3_6548(perfect and "gg_snd_PossessionMissileHit1" or "gg_snd_FlameStrikeTargetWaveNonLoop1", x, y)
    _____63A8_8FDBRR_533A_57DF(context)
    context["周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(100, _____63A8_8FDBRR_533A_57DF, context)
end
local function _____7ED3_7B97RR_5019_9009(variable)
    local candidate = variable
    if candidate == nil then
        return
    end
    local id = jass.GetHandleId(candidate["施法者"])
    if ____RR_5019_9009_8868[id] ~= candidate then
        return
    end
    __TS__Delete(____RR_5019_9009_8868, id)
    local owner = jass.GetOwningPlayer(candidate["施法者"])
    jass.UnitRemoveAbility(candidate["施法者"], _____914D_7F6E["技能"].RR["二段容器类型ID"])
    jass.SetPlayerAbilityAvailable(owner, _____914D_7F6E["技能"].RR["二段容器类型ID"], false)
    if not candidate["完美空间"] then
        jass.SetPlayerAbilityAvailable(owner, _____914D_7F6E["技能"].RR["类型ID"], true)
    end
    if _____5355_4F4D_5B58_6D3B(candidate["施法者"]) then
        _____542F_52A8RR_533A_57DF(candidate["施法者"], candidate["完美空间"], candidate["序号"])
    end
end
local function _____91CA_653ERR(listener, caster)
    local id = jass.GetHandleId(caster)
    if listener["二段"] then
        local candidate = ____RR_5019_9009_8868[id]
        if candidate ~= nil then
            candidate["完美空间"] = true
            jass.SetPlayerAbilityAvailable(
                jass.GetOwningPlayer(caster),
                _____914D_7F6E["技能"].RR["二段容器类型ID"],
                false
            )
            _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, _____914D_7F6E["技能"].RR["类型ID"], _____914D_7F6E.RR["双击冷却秒"], _____914D_7F6E.RR["双击冷却秒"])
        end
        return
    end
    local owner = jass.GetOwningPlayer(caster)
    jass.UnitAddAbility(caster, _____914D_7F6E["技能"].RR["二段容器类型ID"])
    jass.SetPlayerAbilityAvailable(owner, _____914D_7F6E["技能"].RR["类型ID"], false)
    jass.SetPlayerAbilityAvailable(owner, _____914D_7F6E["技能"].RR["二段容器类型ID"], true)
    ____RR_5019_9009_81EA_589E_5E8F_53F7 = ____RR_5019_9009_81EA_589E_5E8F_53F7 + 1
    local candidate = {["施法者"] = caster, ["序号"] = ____RR_5019_9009_81EA_589E_5E8F_53F7, ["完美空间"] = false}
    ____RR_5019_9009_8868[id] = candidate
    addDelayedCallback(_____914D_7F6E.RR["双击窗口毫秒"], _____7ED3_7B97RR_5019_9009, candidate)
end
____exports["注册十六夜咲夜RR"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-个人空间（RR）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RR["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RR_4E00_6BB5_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653ERR,
        ["创建独立技能实例"] = false
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-完美空间（RR二段）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RR["二段类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RR_4E8C_6BB5_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653ERR,
        ["创建独立技能实例"] = false
    })
end
____exports["注册十六夜咲夜RR"]()
return ____exports
