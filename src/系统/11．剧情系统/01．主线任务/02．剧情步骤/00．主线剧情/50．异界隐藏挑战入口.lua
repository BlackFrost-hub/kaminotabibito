--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local registerSyncHardwareKey = ____require_result_1.registerSyncHardwareKey
local ____require_result_2 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____require_result_2.KEY
local KEY_STATE = ____require_result_2.KEY_STATE
local ____require_result_3 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_3["广播单位提示"]
local ____require_result_4 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_4.IsUnitAliveBJ
local ____require_result_5 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_5.GetPlayersAll
local ____require_result_6 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_6.QuestMessageBJ
local ____require_result_7 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_7["是玩家英雄组单位"]
local AddSpecialEffect = jass.AddSpecialEffect
local CreateGroup = jass.CreateGroup
local DestroyEffect = jass.DestroyEffect
local DestroyGroup = jass.DestroyGroup
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local FirstOfGroup = jass.FirstOfGroup
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local GroupRemoveUnit = jass.GroupRemoveUnit
local _____9690_85CF_6311_6218_51FA_73B0_5EF6_8FDF_6BEB_79D2 = 30000
local _____9690_85CF_6311_6218_786E_8BA4_8303_56F4 = 300
local _____9690_85CF_6311_6218_53CC_51FB_7A97_53E3_6BEB_79D2 = 1200
local _____9690_85CF_6311_6218_72B6_6001_8868 = {}
local _____73A9_5BB6_4E0A_6B21_786E_8BA4_65F6_95F4_8868 = {}
local _____590F_63D0_96C5_51FA_73B0_5DF2_5B89_6392 = false
local _____5B89_5179_4E4C_5C14_606D_51FA_73B0_5DF2_5B89_6392 = false
local _____590F_63D0_96C5_9690_85CF_6311_6218_914D_7F6E = {
    ["类型"] = "夏提雅",
    ["Boss键"] = "Boss.夏提雅",
    ["Boss名"] = "夏提雅·布拉德弗伦",
    X = 27966.2,
    Y = -3680.7,
    ["朝向"] = 315,
    ["登场对白"] = "呵呵……能击败那头恶魔，看来你们并非无聊之辈。若还有余力，就来陪我尽兴一场吧。",
    ["玩家回应"] = "既然阁下亲自邀战，我们接受。",
    ["Boss回应"] = "很好。让我看看，你们究竟能让我愉悦到什么程度。",
    ["特效路径"] = {"Common\\Effect\\Form\\Illusion\\ShalltearRoseMirrorRim.mdx", "Common\\Effect\\Form\\Aura\\ShalltearBloodMirrorField.mdx"}
}
local _____5B89_5179_4E4C_5C14_606D_9690_85CF_6311_6218_914D_7F6E = {
    ["类型"] = "安兹乌尔恭",
    ["Boss键"] = "Boss.安兹乌尔恭",
    ["Boss名"] = "安兹·乌尔·恭",
    X = 9336.8,
    Y = -13891.9,
    ["朝向"] = 225,
    ["登场对白"] = "诸位已经证明了自己的力量。我对你们的战斗方式产生了兴趣。若愿意，就在此接受我的试炼。",
    ["玩家回应"] = "既然阁下以挑战者的身份出现，我们奉陪。",
    ["Boss回应"] = "很好。无需保留，让我看看你们能够抵达何种境界。",
    ["特效路径"] = {"Common\\Effect\\Form\\Illusion\\AinzBlackGoldPortalFrame.mdx", "Common\\Effect\\Form\\Rotate\\AinzBlackGoldPortalCore.mdx", "Common\\Effect\\Form\\Rotate\\AinzBlackGoldPortalVortex.mdx"}
}
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit)
end
local function _____8BFB_53D6_9690_85CF_6311_6218_914D_7F6E(_____7C7B_578B)
    return _____7C7B_578B == "夏提雅" and _____590F_63D0_96C5_9690_85CF_6311_6218_914D_7F6E or _____5B89_5179_4E4C_5C14_606D_9690_85CF_6311_6218_914D_7F6E
end
local function _____6E05_7406_6311_6218_5165_53E3_7279_6548(_____72B6_6001)
    do
        local i = 0
        while i < #_____72B6_6001["特效列表"] do
            local effect = _____72B6_6001["特效列表"][i + 1]
            if effect ~= nil and effect ~= 0 then
                DestroyEffect(effect)
            end
            i = i + 1
        end
    end
    _____72B6_6001["特效列表"] = {}
end
local function _____67E5_627E_73A9_5BB6_9644_8FD1_82F1_96C4(_____72B6_6001, _____73A9_5BB6)
    if not _____5355_4F4D_5B58_6D3B(_____72B6_6001["Boss单位"]) or _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return nil
    end
    local group = CreateGroup()
    if group == nil or group == 0 then
        return nil
    end
    GroupEnumUnitsInRange(
        group,
        GetUnitX(_____72B6_6001["Boss单位"]),
        GetUnitY(_____72B6_6001["Boss单位"]),
        _____9690_85CF_6311_6218_786E_8BA4_8303_56F4,
        nil
    )
    local result = nil
    while true do
        local unit = FirstOfGroup(group)
        if unit == nil or unit == 0 then
            break
        end
        GroupRemoveUnit(group, unit)
        if GetOwningPlayer(unit) == _____73A9_5BB6 and _____5355_4F4D_5B58_6D3B(unit) and _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
            result = unit
            break
        end
    end
    DestroyGroup(group)
    return result
end
local function _____67E5_627E_53EF_786E_8BA4_6311_6218(_____73A9_5BB6)
    do
        local i = 0
        while i < #_____9690_85CF_6311_6218_72B6_6001_8868 do
            do
                local _____72B6_6001 = _____9690_85CF_6311_6218_72B6_6001_8868[i + 1]
                if _____72B6_6001["已开始"] then
                    goto __continue16
                end
                local _____82F1_96C4 = _____67E5_627E_73A9_5BB6_9644_8FD1_82F1_96C4(_____72B6_6001, _____73A9_5BB6)
                if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    return {["状态"] = _____72B6_6001, ["英雄"] = _____82F1_96C4}
                end
            end
            ::__continue16::
            i = i + 1
        end
    end
    return nil
end
local function ____on_542F_52A8_9690_85CF_6311_6218_6218_6597(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or not _____5355_4F4D_5B58_6D3B(_____53C2_6570["状态"]["Boss单位"]) then
        return
    end
    _____542F_52A8_5267_60C5Boss_6218(_____53C2_6570["状态"]["Boss单位"], {["触发单位"] = _____53C2_6570["触发英雄"]})
end
local function ____on_64AD_653E_9690_85CF_6311_6218Boss_56DE_5E94(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or not _____5355_4F4D_5B58_6D3B(_____53C2_6570["状态"]["Boss单位"]) then
        return
    end
    local _____914D_7F6E = _____8BFB_53D6_9690_85CF_6311_6218_914D_7F6E(_____53C2_6570["状态"]["类型"])
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____53C2_6570["状态"]["Boss单位"], _____914D_7F6E["Boss回应"], 3600)
end
local function _____5F00_59CB_9690_85CF_6311_6218(_____72B6_6001, _____89E6_53D1_82F1_96C4)
    if _____72B6_6001["已开始"] or not _____5355_4F4D_5B58_6D3B(_____72B6_6001["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(_____89E6_53D1_82F1_96C4) then
        return
    end
    _____72B6_6001["已开始"] = true
    _____6E05_7406_6311_6218_5165_53E3_7279_6548(_____72B6_6001)
    local _____914D_7F6E = _____8BFB_53D6_9690_85CF_6311_6218_914D_7F6E(_____72B6_6001["类型"])
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____89E6_53D1_82F1_96C4, _____914D_7F6E["玩家回应"], 3300)
    local _____53C2_6570 = {["状态"] = _____72B6_6001, ["触发英雄"] = _____89E6_53D1_82F1_96C4}
    addDelayedCallback(3500, ____on_64AD_653E_9690_85CF_6311_6218Boss_56DE_5E94, _____53C2_6570)
    addDelayedCallback(7300, ____on_542F_52A8_9690_85CF_6311_6218_6218_6597, _____53C2_6570)
end
local function ____on_540C_6B65Y_952E_6309_4E0B(event)
    local _____73A9_5BB6 = event.player
    local _____53EF_786E_8BA4_6311_6218 = _____67E5_627E_53EF_786E_8BA4_6311_6218(_____73A9_5BB6)
    if _____53EF_786E_8BA4_6311_6218 == nil then
        return
    end
    local _____73A9_5BB6ID = GetPlayerId(_____73A9_5BB6)
    local _____5F53_524D_65F6_95F4 = getServerTime()
    local _____4E0A_6B21_786E_8BA4_65F6_95F4 = _____73A9_5BB6_4E0A_6B21_786E_8BA4_65F6_95F4_8868[_____73A9_5BB6ID]
    if _____4E0A_6B21_786E_8BA4_65F6_95F4 == nil or _____5F53_524D_65F6_95F4 - _____4E0A_6B21_786E_8BA4_65F6_95F4 > _____9690_85CF_6311_6218_53CC_51FB_7A97_53E3_6BEB_79D2 then
        _____73A9_5BB6_4E0A_6B21_786E_8BA4_65F6_95F4_8868[_____73A9_5BB6ID] = _____5F53_524D_65F6_95F4
        DisplayTimedTextToPlayer(
            _____73A9_5BB6,
            0,
            0,
            2.2,
            "|cffffcc00『隐藏挑战』：|r再次按下 |cffffcc00Y|r 接受挑战。"
        )
        return
    end
    _____73A9_5BB6_4E0A_6B21_786E_8BA4_65F6_95F4_8868[_____73A9_5BB6ID] = nil
    _____5F00_59CB_9690_85CF_6311_6218(_____53EF_786E_8BA4_6311_6218["状态"], _____53EF_786E_8BA4_6311_6218["英雄"])
end
local function _____521B_5EFA_9690_85CF_6311_6218_5165_53E3(_____914D_7F6E)
    do
        local i = 0
        while i < #_____9690_85CF_6311_6218_72B6_6001_8868 do
            if _____9690_85CF_6311_6218_72B6_6001_8868[i + 1]["类型"] == _____914D_7F6E["类型"] then
                return
            end
            i = i + 1
        end
    end
    local bossUnit = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
        ["Boss键"] = _____914D_7F6E["Boss键"],
        ["Boss名"] = _____914D_7F6E["Boss名"],
        X = _____914D_7F6E.X,
        Y = _____914D_7F6E.Y,
        ["朝向"] = _____914D_7F6E["朝向"],
        ["预创建后暂停"] = true,
        ["预创建后无敌"] = true
    })
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        return
    end
    local _____7279_6548_5217_8868 = {}
    do
        local i = 0
        while i < #_____914D_7F6E["特效路径"] do
            local effect = AddSpecialEffect(_____914D_7F6E["特效路径"][i + 1], _____914D_7F6E.X, _____914D_7F6E.Y)
            if effect ~= nil and effect ~= 0 then
                _____7279_6548_5217_8868[#_____7279_6548_5217_8868 + 1] = effect
            end
            i = i + 1
        end
    end
    _____9690_85CF_6311_6218_72B6_6001_8868[#_____9690_85CF_6311_6218_72B6_6001_8868 + 1] = {["类型"] = _____914D_7F6E["类型"], ["Boss单位"] = bossUnit, ["特效列表"] = _____7279_6548_5217_8868, ["已开始"] = false}
    _____5E7F_64AD_5355_4F4D_63D0_793A(bossUnit, _____914D_7F6E["登场对白"], 6200)
    QuestMessageBJ(
        GetPlayersAll(),
        jglobals.bj_QUESTMESSAGE_ALWAYSHINT,
        ("|cffffcc00『隐藏挑战』：|r" .. _____914D_7F6E["Boss名"]) .. "正在等待回应。任意玩家英雄靠近其 300 码，在 1.2 秒内连续按下两次 Y 接受挑战。"
    )
end
local function ____on_5EF6_8FDF_521B_5EFA_590F_63D0_96C5()
    _____521B_5EFA_9690_85CF_6311_6218_5165_53E3(_____590F_63D0_96C5_9690_85CF_6311_6218_914D_7F6E)
end
local function ____on_5EF6_8FDF_521B_5EFA_5B89_5179_4E4C_5C14_606D()
    _____521B_5EFA_9690_85CF_6311_6218_5165_53E3(_____5B89_5179_4E4C_5C14_606D_9690_85CF_6311_6218_914D_7F6E)
end
____exports["创建夏提雅隐藏挑战"] = function()
    if _____590F_63D0_96C5_51FA_73B0_5DF2_5B89_6392 then
        return
    end
    _____590F_63D0_96C5_51FA_73B0_5DF2_5B89_6392 = true
    addDelayedCallback(_____9690_85CF_6311_6218_51FA_73B0_5EF6_8FDF_6BEB_79D2, ____on_5EF6_8FDF_521B_5EFA_590F_63D0_96C5)
end
____exports["创建安兹隐藏挑战"] = function()
    if _____5B89_5179_4E4C_5C14_606D_51FA_73B0_5DF2_5B89_6392 then
        return
    end
    _____5B89_5179_4E4C_5C14_606D_51FA_73B0_5DF2_5B89_6392 = true
    addDelayedCallback(_____9690_85CF_6311_6218_51FA_73B0_5EF6_8FDF_6BEB_79D2, ____on_5EF6_8FDF_521B_5EFA_5B89_5179_4E4C_5C14_606D)
end
____exports["执行创建夏提雅隐藏挑战动作"] = function()
    ____exports["创建夏提雅隐藏挑战"]()
end
____exports["异界隐藏挑战入口剧情动作注册表"] = {["第三章_创建夏提雅隐藏挑战"] = ____exports["执行创建夏提雅隐藏挑战动作"]}
registerSyncHardwareKey(KEY.Y, KEY_STATE.DOWN, ____on_540C_6B65Y_952E_6309_4E0B)
return ____exports
