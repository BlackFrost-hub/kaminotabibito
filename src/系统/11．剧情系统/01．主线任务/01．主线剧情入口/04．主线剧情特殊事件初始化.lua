--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0E_4E3B_7EBF_5267_60C5_4E8B_4EF6_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.05．主线剧情事件配置表")
local _____4E3B_7EBF_5267_60C5_6280_80FD_901A_9053_4E8B_4EF6_914D_7F6E_8868 = ____05_FF0E_4E3B_7EBF_5267_60C5_4E8B_4EF6_914D_7F6E_8868["主线剧情技能通道事件配置表"]
local ____14_FF0E_86C7_4EBA_65CF_536B_961F_957F_8BD5_70BC = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.14．蛇人族卫队长试炼")
local _____86C7_4EBA_65CF_536B_961F_957F_8840_7EBF_627F_63A5_914D_7F6E = ____14_FF0E_86C7_4EBA_65CF_536B_961F_957F_8BD5_70BC["蛇人族卫队长血线承接配置"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["发布主线节点目标"]
local ____07_FF0E_5267_60C5_6280_80FD_4E8B_4EF6_8F85_52A9 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.07．剧情技能事件辅助")
local _____5904_7406_6280_80FD_63A8_8FDB_4E3B_7EBF_5267_60C5 = ____07_FF0E_5267_60C5_6280_80FD_4E8B_4EF6_8F85_52A9["处理技能推进主线剧情"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_0["添加单位暂停"]
local _____5267_60C5_7279_6B8A_4E8B_4EF6_6682_505C_6765_6E90 = "剧情系统:特殊事件"
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellChannelListener = ____require_result_1.registerSpellChannelListener
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_2.registerAppliedFinalDamageListener
local ____require_result_3 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local YDWESetEventDamage = ____require_result_3.YDWESetEventDamage
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
local removePeriodicCallback = ____require_result_4.removePeriodicCallback
local getServerTime = ____require_result_4.getServerTime
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataClearSafe = ____require_result_5.YDUserDataClearSafe
local YDUserDataClearTableSafe = ____require_result_5.YDUserDataClearTableSafe
local ____require_result_6 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local SetStackedSoundBJ = ____require_result_6.SetStackedSoundBJ
local ____require_result_7 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_7.GetPlayersAll
local ____require_result_8 = require("lib.扩展函数.BJ函数.05A．电影函数")
local TransmissionFromUnitWithNameBJ = ____require_result_8.TransmissionFromUnitWithNameBJ
local ____require_result_9 = require("lib.扩展函数.BJ函数.06．任务消息")
local CreateQuestBJ = ____require_result_9.CreateQuestBJ
local GetLastCreatedQuestBJ = ____require_result_9.GetLastCreatedQuestBJ
local QuestMessageBJ = ____require_result_9.QuestMessageBJ
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_10.stringToFourCCSafe
local GetUnitName = jass.GetUnitName
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local IsUnitInRangeXY = jass.IsUnitInRangeXY
local Player = jass.Player
local RemoveUnit = jass.RemoveUnit
local SetUnitFacing = jass.SetUnitFacing
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
local SetUnitState = jass.SetUnitState
local ShowUnit = jass.ShowUnit
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local bj_QUESTMESSAGE_ALWAYSHINT = jglobals.bj_QUESTMESSAGE_ALWAYSHINT
local bj_QUESTTYPE_OPT_UNDISCOVERED = jglobals.bj_QUESTTYPE_OPT_UNDISCOVERED
local bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET
local _____5DF2_521D_59CB_5316_4E3B_7EBF_5267_60C5_7279_6B8A_4E8B_4EF6 = false
local _____5EF6_8FDF_663E_793A_4EFB_52A1 = {}
local _____5EF6_8FDF_663E_793A_626B_63CFID = 0
local function _____83B7_53D6_5168_5C40_53E5_67C4(_____53D8_91CF_540D)
    return jglobals[_____53D8_91CF_540D]
end
local function _____8BFB_53D6_653B_51FB_8005_540D(attacker)
    if attacker == nil or attacker == 0 then
        return "玩家"
    end
    local name = GetUnitName(attacker)
    return name and #name > 0 and name or "玩家"
end
local function _____5267_60C5_8FDB_5EA6_6EE1_8DB3_6280_80FD_914D_7F6E(_____914D_7F6E)
    local _____5F53_524D_5267_60C5_8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    if _____914D_7F6E["需要剧情进度"] ~= nil and _____5F53_524D_5267_60C5_8FDB_5EA6 ~= _____914D_7F6E["需要剧情进度"] then
        return false
    end
    if _____914D_7F6E["最低剧情进度"] ~= nil and _____5F53_524D_5267_60C5_8FDB_5EA6 < _____914D_7F6E["最低剧情进度"] then
        return false
    end
    if _____914D_7F6E["最高剧情进度"] ~= nil and _____5F53_524D_5267_60C5_8FDB_5EA6 > _____914D_7F6E["最高剧情进度"] then
        return false
    end
    return true
end
local function _____6267_884C_533A_57DF_97F3_4E50_5207_6362(_____914D_7F6E)
    if _____914D_7F6E["区域音乐切换"] == nil then
        return
    end
    do
        local i = 0
        while i < #_____914D_7F6E["区域音乐切换"] do
            do
                local _____6761_76EE = _____914D_7F6E["区域音乐切换"][i + 1]
                local _____58F0_97F3_53E5_67C4 = _____83B7_53D6_5168_5C40_53E5_67C4(_____6761_76EE["声音变量名"])
                local _____77E9_5F62_53E5_67C4 = _____83B7_53D6_5168_5C40_53E5_67C4(_____6761_76EE["矩形变量名"])
                if _____58F0_97F3_53E5_67C4 == nil or _____77E9_5F62_53E5_67C4 == nil then
                    goto __continue12
                end
                SetStackedSoundBJ(_____6761_76EE["添加"], _____58F0_97F3_53E5_67C4, _____77E9_5F62_53E5_67C4)
            end
            ::__continue12::
            i = i + 1
        end
    end
end
local function _____6267_884C_652F_7EBF_4EFB_52A1_53D1_73B0(_____914D_7F6E)
    local _____652F_7EBF_4EFB_52A1_6570_7EC4 = jglobals.udg_RW
    if _____652F_7EBF_4EFB_52A1_6570_7EC4 == nil then
        return
    end
    if _____652F_7EBF_4EFB_52A1_6570_7EC4[_____914D_7F6E["任务数组索引"]] ~= nil and _____652F_7EBF_4EFB_52A1_6570_7EC4[_____914D_7F6E["任务数组索引"]] ~= 0 then
        return
    end
    CreateQuestBJ(bj_QUESTTYPE_OPT_UNDISCOVERED, _____914D_7F6E["任务名"], _____914D_7F6E["任务描述"] or "", _____914D_7F6E["图标路径"])
    _____652F_7EBF_4EFB_52A1_6570_7EC4[_____914D_7F6E["任务数组索引"]] = GetLastCreatedQuestBJ()
end
local function _____64AD_653E_6700_7EC8_4F24_5BB3_5BF9_767D_5217_8868(_____914D_7F6E, attacker)
    local _____653B_51FB_8005_540D = _____8BFB_53D6_653B_51FB_8005_540D(attacker)
    do
        local i = 0
        while i < #_____914D_7F6E["对白列表"] do
            local _____5BF9_767D = _____914D_7F6E["对白列表"][i + 1]
            local _____8BF4_8BDD_8005 = _____5BF9_767D["使用攻击者名"] == true and _____653B_51FB_8005_540D or _____5BF9_767D["说话者"]
            TransmissionFromUnitWithNameBJ(
                GetPlayersAll(),
                nil,
                _____8BF4_8BDD_8005,
                nil,
                _____5BF9_767D["文本"],
                bj_TIMETYPE_SET,
                _____5BF9_767D["持续时间"],
                true
            )
            i = i + 1
        end
    end
end
local function _____6267_884C_4E3B_7EBF_5267_60C5_5EF6_8FDF_663E_793A(_____914D_7F6E)
    if _____914D_7F6E == nil or _____914D_7F6E["延迟显示"] == nil then
        return
    end
    local _____5355_4F4D = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____914D_7F6E["延迟显示"]["语义单位名"])
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    ShowUnit(_____5355_4F4D, true)
    SetUnitPosition(_____5355_4F4D, _____914D_7F6E["延迟显示"].X, _____914D_7F6E["延迟显示"].Y)
    SetUnitFacing(_____5355_4F4D, _____914D_7F6E["延迟显示"]["朝向"])
    if _____914D_7F6E["支线任务发现"] ~= nil then
        QuestMessageBJ(
            GetPlayersAll(),
            bj_QUESTMESSAGE_ALWAYSHINT,
            _____914D_7F6E["支线任务发现"]["发现提示"]
        )
    end
end
local function ____on_4E3B_7EBF_5267_60C5_5EF6_8FDF_663E_793A_626B_63CF()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____5EF6_8FDF_663E_793A_4EFB_52A1 do
            do
                local task = _____5EF6_8FDF_663E_793A_4EFB_52A1[i + 1]
                if now >= task.dueTime then
                    _____6267_884C_4E3B_7EBF_5267_60C5_5EF6_8FDF_663E_793A(task["配置"])
                    goto __continue26
                end
                _____5EF6_8FDF_663E_793A_4EFB_52A1[writeIndex + 1] = task
                writeIndex = writeIndex + 1
            end
            ::__continue26::
            i = i + 1
        end
    end
    do
        local i = #_____5EF6_8FDF_663E_793A_4EFB_52A1 - 1
        while i >= writeIndex do
            table.remove(_____5EF6_8FDF_663E_793A_4EFB_52A1)
            i = i - 1
        end
    end
    if #_____5EF6_8FDF_663E_793A_4EFB_52A1 == 0 and _____5EF6_8FDF_663E_793A_626B_63CFID ~= 0 then
        removePeriodicCallback(_____5EF6_8FDF_663E_793A_626B_63CFID)
        _____5EF6_8FDF_663E_793A_626B_63CFID = 0
    end
end
local function _____542F_52A8_5EF6_8FDF_663E_793A(_____914D_7F6E)
    if _____914D_7F6E["延迟显示"] == nil then
        return
    end
    _____5EF6_8FDF_663E_793A_4EFB_52A1[#_____5EF6_8FDF_663E_793A_4EFB_52A1 + 1] = {
        dueTime = getServerTime() + _____914D_7F6E["延迟显示"]["延迟秒数"] * 1000,
        ["配置"] = _____914D_7F6E
    }
    if _____5EF6_8FDF_663E_793A_626B_63CFID == 0 then
        _____5EF6_8FDF_663E_793A_626B_63CFID = addPeriodicCallback(10, ____on_4E3B_7EBF_5267_60C5_5EF6_8FDF_663E_793A_626B_63CF)
    end
end
local function _____547D_4E2D_6280_80FD_901A_9053_4E8B_4EF6_914D_7F6E(_____914D_7F6E, castingUnit, spellAbilityId)
    if castingUnit == nil or castingUnit == 0 then
        return false
    end
    if spellAbilityId ~= stringToFourCCSafe(_____914D_7F6E["技能ID"]) then
        return false
    end
    if not _____5267_60C5_8FDB_5EA6_6EE1_8DB3_6280_80FD_914D_7F6E(_____914D_7F6E) then
        return false
    end
    return IsUnitInRangeXY(castingUnit, _____914D_7F6E["检测X"], _____914D_7F6E["检测Y"], _____914D_7F6E["检测半径"]) == true
end
local function _____547D_4E2D_6700_7EC8_4F24_5BB3_4E8B_4EF6_914D_7F6E(_____914D_7F6E, target, applied)
    if target == nil or target == 0 then
        return false
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= _____914D_7F6E["需要剧情进度"] then
        return false
    end
    if GetUnitTypeId(target) ~= stringToFourCCSafe(_____914D_7F6E["单位ID"]) then
        return false
    end
    local currentLife = GetUnitState(target, UNIT_STATE_LIFE)
    local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    if not (currentLife > 0) or not (maxLife > 0) then
        return false
    end
    local afterHitLife = currentLife - applied
    return applied >= currentLife or afterHitLife <= maxLife * _____914D_7F6E["血线阈值比例"]
end
local function _____6267_884C_6280_80FD_63A8_8FDB_5267_60C5(_____914D_7F6E, castingUnit)
    _____5904_7406_6280_80FD_63A8_8FDB_4E3B_7EBF_5267_60C5({["片段ID"] = _____914D_7F6E["剧情片段ID"], ["触发配置名"] = _____914D_7F6E["配置名"], ["触发单位"] = castingUnit})
end
local function _____6267_884C_6700_7EC8_4F24_5BB3_63A8_8FDB_5267_60C5(_____914D_7F6E, target, attacker)
    local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    YDWESetEventDamage(0)
    _____5199_5165_5267_60C5_8FDB_5EA6(_____914D_7F6E["目标剧情进度"])
    SetUnitState(target, UNIT_STATE_LIFE, maxLife * _____914D_7F6E["保底生命比例"])
    if _____914D_7F6E["目标单位无敌"] == true then
        SetUnitInvulnerable(target, true)
    end
    if _____914D_7F6E["切换所属玩家ID"] ~= nil then
        SetUnitOwner(
            target,
            Player(_____914D_7F6E["切换所属玩家ID"]),
            true
        )
    end
    if _____914D_7F6E["暂停目标单位"] == true then
        _____6DFB_52A0_5355_4F4D_6682_505C(target, _____5267_60C5_7279_6B8A_4E8B_4EF6_6682_505C_6765_6E90)
    end
    _____6267_884C_533A_57DF_97F3_4E50_5207_6362(_____914D_7F6E)
    _____64AD_653E_6700_7EC8_4F24_5BB3_5BF9_767D_5217_8868(_____914D_7F6E, attacker)
    if _____914D_7F6E["移除目标单位"] == true then
        RemoveUnit(target)
    end
    if _____914D_7F6E["清理Boss语义键"] ~= nil and _____914D_7F6E["清理Boss语义键"] ~= "" then
        YDUserDataClearSafe("string", "Boss", _____914D_7F6E["清理Boss语义键"], "unit")
    end
    if _____914D_7F6E["清理目标YD表"] == true then
        YDUserDataClearTableSafe("unit", target)
    end
    _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807(_____914D_7F6E["目标剧情进度"])
    if _____914D_7F6E["支线任务发现"] ~= nil then
        _____6267_884C_652F_7EBF_4EFB_52A1_53D1_73B0(_____914D_7F6E["支线任务发现"])
    end
    _____542F_52A8_5EF6_8FDF_663E_793A(_____914D_7F6E)
end
local function ____on_4E3B_7EBF_6280_80FD_901A_9053_63A8_8FDB(castingUnit, spellAbilityId)
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_6280_80FD_901A_9053_4E8B_4EF6_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_6280_80FD_901A_9053_4E8B_4EF6_914D_7F6E_8868[i + 1]
                if not _____547D_4E2D_6280_80FD_901A_9053_4E8B_4EF6_914D_7F6E(_____914D_7F6E, castingUnit, spellAbilityId) then
                    goto __continue54
                end
                _____6267_884C_6280_80FD_63A8_8FDB_5267_60C5(_____914D_7F6E, castingUnit)
                return
            end
            ::__continue54::
            i = i + 1
        end
    end
end
local function ____on_4E3B_7EBF_6700_7EC8_4F24_5BB3_63A8_8FDB(target, attacker, applied)
    local _____914D_7F6E = _____86C7_4EBA_65CF_536B_961F_957F_8840_7EBF_627F_63A5_914D_7F6E
    if not _____547D_4E2D_6700_7EC8_4F24_5BB3_4E8B_4EF6_914D_7F6E(_____914D_7F6E, target, applied) then
        return
    end
    _____6267_884C_6700_7EC8_4F24_5BB3_63A8_8FDB_5267_60C5(_____914D_7F6E, target, attacker)
end
____exports["初始化主线剧情特殊事件"] = function()
    if _____5DF2_521D_59CB_5316_4E3B_7EBF_5267_60C5_7279_6B8A_4E8B_4EF6 then
        return
    end
    _____5DF2_521D_59CB_5316_4E3B_7EBF_5267_60C5_7279_6B8A_4E8B_4EF6 = true
    registerAppliedFinalDamageListener(____on_4E3B_7EBF_6700_7EC8_4F24_5BB3_63A8_8FDB)
    registerSpellChannelListener(____on_4E3B_7EBF_6280_80FD_901A_9053_63A8_8FDB)
end
return ____exports
