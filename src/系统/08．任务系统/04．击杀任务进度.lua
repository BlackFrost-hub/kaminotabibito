local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local _____4EFB_52A1_914D_7F6E_5217_8868 = ____02_FF0E_4EFB_52A1_914D_7F6E_8868["任务配置列表"]
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local _____89E6_53D1_4EFB_52A1UI_5237_65B0 = ____02_FF0E_4EFB_52A1_7BA1_7406_5668["触发任务UI刷新"]
---
-- @noSelfInFile
local jass = require("jass.common")
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerController = jass.GetPlayerController
local GetPlayerId = jass.GetPlayerId
local GetUnitTypeId = jass.GetUnitTypeId
local Player = jass.Player
local MAP_CONTROL_USER = jass.MAP_CONTROL_USER
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local fourCCToStringSafe = ____require_result_1.fourCCToStringSafe
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_2.UnitHasItemOfTypeBJ
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_3.getRegisteredPlayerHero
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6 = ____require_result_4["发送头像提示给玩家"]
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____require_result_5["广播提示玩家槽数"]
local _____5E7F_64AD_63D0_793A_5587_53ED_5934_50CF = ____require_result_5["广播提示喇叭头像"]
local _____5DF2_521D_59CB_5316 = false
local function _____662F_51FB_6740_4EFB_52A1_914D_7F6E(_____914D_7F6E)
    return (_____914D_7F6E["类型"] == "击杀" or _____914D_7F6E["类型"] == "目标击杀") and _____914D_7F6E["目标单位"] ~= nil and _____914D_7F6E["目标单位"] ~= ""
end
local function _____76EE_6807_5355_4F4D_5339_914D(_____76EE_6807_5355_4F4D_5217_8868, _____6B7B_4EA1_5355_4F4D_4EE3_7801)
    local _____5355_4F4D_4EE3_7801_5217_8868 = __TS__StringSplit(_____76EE_6807_5355_4F4D_5217_8868, "|")
    do
        local i = 0
        while i < #_____5355_4F4D_4EE3_7801_5217_8868 do
            if __TS__StringTrim(_____5355_4F4D_4EE3_7801_5217_8868[i + 1]) == _____6B7B_4EA1_5355_4F4D_4EE3_7801 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____73A9_5BB6_82F1_96C4_6EE1_8DB3_51FB_6740_643A_5E26_6761_4EF6(_____73A9_5BB6, _____643A_5E26_7269_54C1_5217_8868)
    if not _____643A_5E26_7269_54C1_5217_8868 or _____643A_5E26_7269_54C1_5217_8868 == "" then
        return true
    end
    local _____82F1_96C4 = getRegisteredPlayerHero(_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____7269_54C1_4EE3_7801_5217_8868 = __TS__StringSplit(_____643A_5E26_7269_54C1_5217_8868, "|")
    do
        local i = 0
        while i < #_____7269_54C1_4EE3_7801_5217_8868 do
            local _____7269_54C1_7C7B_578BID = stringToFourCCSafe(__TS__StringTrim(_____7269_54C1_4EE3_7801_5217_8868[i + 1]))
            if _____7269_54C1_7C7B_578BID ~= 0 and UnitHasItemOfTypeBJ(_____82F1_96C4, _____7269_54C1_7C7B_578BID) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____67E5_627E_4EFB_52A1_914D_7F6E(_____4EFB_52A1ID)
    do
        local i = 0
        while i < #_____4EFB_52A1_914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____4EFB_52A1_914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["任务ID"] ~= nil and tostring(_____914D_7F6E["任务ID"]) == _____4EFB_52A1ID then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
local function _____5956_52B1_9762_5411_6240_6709_73A9_5BB6(_____5956_52B1)
    if not _____5956_52B1 or _____5956_52B1 == "" then
        return true
    end
    if (string.find(_____5956_52B1, "所有玩家", nil, true) or 0) - 1 >= 0 or (string.find(_____5956_52B1, "all", nil, true) or 0) - 1 >= 0 then
        return true
    end
    return (string.find(_____5956_52B1, "完成任务的玩家", nil, true) or 0) - 1 < 0 and (string.find(_____5956_52B1, "Player", nil, true) or 0) - 1 < 0
end
local function _____6784_5EFA_51FB_6740_8FDB_5EA6_64AD_62A5(_____914D_7F6E, _____5F53_524D_6570_91CF, _____9700_6C42_6570_91CF)
    local _____8FDB_5EA6_6A21_677F = _____914D_7F6E["进度文本"] or ((_____914D_7F6E["名称"] or "击杀目标") .. "N/") .. tostring(_____9700_6C42_6570_91CF)
    local _____6807_8BB0_4F4D_7F6E = (string.find(_____8FDB_5EA6_6A21_677F, "N/", nil, true) or 0) - 1
    if _____6807_8BB0_4F4D_7F6E >= 0 then
        return (("|cffffff00『任务进度』：|r" .. __TS__StringSubstring(_____8FDB_5EA6_6A21_677F, 0, _____6807_8BB0_4F4D_7F6E)) .. ("|cffffcc00" .. tostring(_____5F53_524D_6570_91CF)) .. "|r/") .. __TS__StringSubstring(_____8FDB_5EA6_6A21_677F, _____6807_8BB0_4F4D_7F6E + 2)
    end
    return ((((("|cffffff00『任务进度』：|r" .. _____8FDB_5EA6_6A21_677F) .. " |cffffcc00") .. tostring(_____5F53_524D_6570_91CF)) .. "/") .. tostring(_____9700_6C42_6570_91CF)) .. "|r"
end
local function _____64AD_62A5_51FB_6740_4EFB_52A1_8FDB_5EA6(_____73A9_5BB6ID, _____914D_7F6E, _____5F53_524D_6570_91CF, _____9700_6C42_6570_91CF)
    if _____9700_6C42_6570_91CF <= 1 then
        return
    end
    local _____6587_672C = _____6784_5EFA_51FB_6740_8FDB_5EA6_64AD_62A5(_____914D_7F6E, _____5F53_524D_6570_91CF, _____9700_6C42_6570_91CF)
    if not _____5956_52B1_9762_5411_6240_6709_73A9_5BB6(_____914D_7F6E["奖励"]) then
        _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
            Player(_____73A9_5BB6ID),
            _____5E7F_64AD_63D0_793A_5587_53ED_5934_50CF,
            _____6587_672C
        )
        return
    end
    do
        local _____76EE_6807_73A9_5BB6ID = 0
        while _____76EE_6807_73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
                Player(_____76EE_6807_73A9_5BB6ID),
                _____5E7F_64AD_63D0_793A_5587_53ED_5934_50CF,
                _____6587_672C
            )
            _____76EE_6807_73A9_5BB6ID = _____76EE_6807_73A9_5BB6ID + 1
        end
    end
end
local function _____589E_52A0_51FB_6740_4EFB_52A1_8FDB_5EA6(_____73A9_5BB6ID, _____4EFB_52A1, _____914D_7F6E, _____6B7B_4EA1_5355_4F4D_4EE3_7801)
    if not _____914D_7F6E["目标单位"] or not _____76EE_6807_5355_4F4D_5339_914D(_____914D_7F6E["目标单位"], _____6B7B_4EA1_5355_4F4D_4EE3_7801) then
        return
    end
    local _____76EE_6807 = _____4EFB_52A1.objectives[1]
    if _____914D_7F6E["目标单位分别击杀"] == true then
        _____76EE_6807 = nil
        local _____76EE_6807ID = "kill_" .. _____6B7B_4EA1_5355_4F4D_4EE3_7801
        do
            local i = 0
            while i < #_____4EFB_52A1.objectives do
                if _____4EFB_52A1.objectives[i + 1] ~= nil and _____4EFB_52A1.objectives[i + 1].id == _____76EE_6807ID then
                    _____76EE_6807 = _____4EFB_52A1.objectives[i + 1]
                    break
                end
                i = i + 1
            end
        end
    end
    if not _____76EE_6807 or _____76EE_6807.current >= _____76EE_6807.required then
        return
    end
    local _____65B0_8FDB_5EA6 = _____76EE_6807.current + 1
    if questDB:updateObjective(_____73A9_5BB6ID, _____4EFB_52A1.id, _____76EE_6807.id, _____65B0_8FDB_5EA6) then
        _____89E6_53D1_4EFB_52A1UI_5237_65B0(_____73A9_5BB6ID, _____4EFB_52A1.id)
        local _____603B_8FDB_5EA6 = 0
        local _____603B_9700_6C42 = 0
        do
            local i = 0
            while i < #_____4EFB_52A1.objectives do
                do
                    local _____5F53_524D_76EE_6807 = _____4EFB_52A1.objectives[i + 1]
                    if not _____5F53_524D_76EE_6807 then
                        goto __continue36
                    end
                    _____603B_8FDB_5EA6 = _____603B_8FDB_5EA6 + (_____5F53_524D_76EE_6807.id == _____76EE_6807.id and _____65B0_8FDB_5EA6 or _____5F53_524D_76EE_6807.current)
                    _____603B_9700_6C42 = _____603B_9700_6C42 + _____5F53_524D_76EE_6807.required
                end
                ::__continue36::
                i = i + 1
            end
        end
        _____64AD_62A5_51FB_6740_4EFB_52A1_8FDB_5EA6(_____73A9_5BB6ID, _____914D_7F6E, _____603B_8FDB_5EA6, _____603B_9700_6C42)
    end
end
local function ____on_4EFB_52A1_76EE_6807_5355_4F4D_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, _____51FB_6740_5355_4F4D)
    if not _____6B7B_4EA1_5355_4F4D or not _____51FB_6740_5355_4F4D then
        return
    end
    local _____51FB_6740_73A9_5BB6 = GetOwningPlayer(_____51FB_6740_5355_4F4D)
    if not _____51FB_6740_73A9_5BB6 or GetPlayerController(_____51FB_6740_73A9_5BB6) ~= MAP_CONTROL_USER then
        return
    end
    local _____73A9_5BB6ID = GetPlayerId(_____51FB_6740_73A9_5BB6)
    local _____6B7B_4EA1_5355_4F4D_4EE3_7801 = fourCCToStringSafe(GetUnitTypeId(_____6B7B_4EA1_5355_4F4D))
    local _____8FDB_884C_4E2D_4EFB_52A1 = questDB:getPlayerActiveQuests(_____73A9_5BB6ID)
    do
        local i = 0
        while i < #_____8FDB_884C_4E2D_4EFB_52A1 do
            do
                local _____4EFB_52A1 = _____8FDB_884C_4E2D_4EFB_52A1[i + 1]
                if not _____4EFB_52A1 or _____4EFB_52A1.status ~= QuestStatus.IN_PROGRESS then
                    goto __continue42
                end
                local _____914D_7F6E = _____67E5_627E_4EFB_52A1_914D_7F6E(_____4EFB_52A1.id)
                if not _____914D_7F6E or not _____662F_51FB_6740_4EFB_52A1_914D_7F6E(_____914D_7F6E) then
                    goto __continue42
                end
                if not _____73A9_5BB6_82F1_96C4_6EE1_8DB3_51FB_6740_643A_5E26_6761_4EF6(_____51FB_6740_73A9_5BB6, _____914D_7F6E["击杀携带物品"]) then
                    goto __continue42
                end
                _____589E_52A0_51FB_6740_4EFB_52A1_8FDB_5EA6(_____73A9_5BB6ID, _____4EFB_52A1, _____914D_7F6E, _____6B7B_4EA1_5355_4F4D_4EE3_7801)
            end
            ::__continue42::
            i = i + 1
        end
    end
end
____exports["初始化击杀任务进度"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerDeathListener(____on_4EFB_52A1_76EE_6807_5355_4F4D_6B7B_4EA1)
end
return ____exports
