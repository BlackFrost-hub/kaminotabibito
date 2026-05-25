local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringReplace = ____lualib.__TS__StringReplace
local ____exports = {}
local _____8BFB_53D6_5168_5C40_53E5_67C4, _____5207_6362_533A_57DF_97F3_4E50_8868_8FBE_5F0F, jglobals, SetStackedSoundBJ
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____5207_6362_5267_60C5_5927_95E8 = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["切换剧情大门"]
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local _____53D1_9001_5267_60C5_5C0F_5730_56FE_4FE1_53F7 = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情小地图信号"]
function _____8BFB_53D6_5168_5C40_53E5_67C4(_____53D8_91CF_540D)
    if _____53D8_91CF_540D == "" then
        return nil
    end
    local ____jglobals______53D8_91CF_540D_13 = jglobals[_____53D8_91CF_540D]
    if ____jglobals______53D8_91CF_540D_13 == nil then
        ____jglobals______53D8_91CF_540D_13 = nil
    end
    return ____jglobals______53D8_91CF_540D_13
end
function _____5207_6362_533A_57DF_97F3_4E50_8868_8FBE_5F0F(expr, add)
    local at = (string.find(expr, "@", nil, true) or 0) - 1
    if at < 0 then
        return
    end
    local soundVarName = __TS__StringTrim(__TS__StringSubstring(expr, 0, at))
    local rectVarName = __TS__StringTrim(__TS__StringSubstring(expr, at + 1))
    local soundHandle = _____8BFB_53D6_5168_5C40_53E5_67C4(soundVarName)
    local rectHandle = _____8BFB_53D6_5168_5C40_53E5_67C4(rectVarName)
    if soundHandle == nil or soundHandle == 0 or rectHandle == nil or rectHandle == 0 then
        return
    end
    SetStackedSoundBJ(add, soundHandle, rectHandle)
end
---
-- @noSelfInFile
local jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AdjustPlayerStateBJ = ____require_result_2.AdjustPlayerStateBJ
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_3.ModifyGateBJ
local ForGroupBJ = ____require_result_3.ForGroupBJ
local ____require_result_4 = require("lib.扩展函数.BJ函数.04．矩形与区域")
SetStackedSoundBJ = ____require_result_4.SetStackedSoundBJ
local ____require_result_5 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local ModifyHeroStat = ____require_result_5.ModifyHeroStat
local ____require_result_6 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_6["按名字反查物品ID"]
local ____require_result_7 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_7["按名字反查Boss单位ID"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local ____require_result_9 = require("系统.08．任务系统.01．任务数据")
local questDB = ____require_result_9.questDB
local QuestType = ____require_result_9.QuestType
local QuestStatus = ____require_result_9.QuestStatus
local ____require_result_10 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____require_result_10.questManager
local ____require_result_11 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____require_result_11["创建并冻结剧情Boss预置"]
local ____require_result_12 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动")
local _____542F_52A8Boss_6218_8FD0_884C = ____require_result_12["启动Boss战运行"]
local AddSpecialEffect = jass.AddSpecialEffect
local AddItemToStockBJ = jass.AddItemToStockBJ
local CreateFogModifierRect = jass.CreateFogModifierRect
local CreateItem = jass.CreateItem
local CreateTimer = jass.CreateTimer
local CreateUnit = jass.CreateUnit
local DisplayCineFilter = jass.DisplayCineFilter
local FogModifierStart = jass.FogModifierStart
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local GetEnumUnit = jass.GetEnumUnit
local GetPlayersAll = jass.GetPlayersAll
local GetItemOfTypeFromUnitBJ = jass.GetItemOfTypeFromUnitBJ
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitName = jass.GetUnitName
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local IssueImmediateOrder = jass.IssueImmediateOrder
local PauseUnit = jass.PauseUnit
local Player = jass.Player
local QuestMessageBJ = jass.QuestMessageBJ
local RemoveDestructable = jass.RemoveDestructable
local RemoveItem = jass.RemoveItem
local SetTimeOfDay = jass.SetTimeOfDay
local SetUnitFacing = jass.SetUnitFacing
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
local UnitAddItem = jass.UnitAddItem
local UnitHasItemOfTypeBJ = jass.UnitHasItemOfTypeBJ
local ShowDestructable = jass.ShowDestructable
local FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE
local bj_GATEOPERATION_CLOSE = jglobals.bj_GATEOPERATION_CLOSE
local bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN
local bj_HEROSTAT_AGI = jglobals.bj_HEROSTAT_AGI
local bj_HEROSTAT_INT = jglobals.bj_HEROSTAT_INT
local bj_HEROSTAT_STR = jglobals.bj_HEROSTAT_STR
local bj_MODIFYMETHOD_ADD = jglobals.bj_MODIFYMETHOD_ADD
local bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED
local bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED
local bj_QUESTMESSAGE_HINT = jglobals.bj_QUESTMESSAGE_HINT
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
local _____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID = "main_story_runtime"
local _____5F53_524D_73A9_5BB6_82F1_96C4_63A7_5236_6682_505C = false
local _____5F53_524D_73A9_5BB6_82F1_96C4_65E0_654C = false
local _____5DF2_521B_5EFA_89C6_91CE_4FEE_6574_5668 = {}
local _____5EF6_8FDF_6267_884C_7F13_5B58 = {}
local function ____on_5EF6_8FDF_6267_884C_5230_65F6()
    local timer = GetExpiredTimer()
    if timer == nil or timer == 0 then
        return
    end
    local key = GetHandleId(timer)
    local _____8BB0_5F55 = _____5EF6_8FDF_6267_884C_7F13_5B58[key]
    __TS__Delete(_____5EF6_8FDF_6267_884C_7F13_5B58, key)
    safeDestroyTimer(nil, timer)
    if _____8BB0_5F55 == nil then
        return
    end
    if _____8BB0_5F55["类型"] == "消息" and _____8BB0_5F55["文本"] then
        QuestMessageBJ(
            GetPlayersAll(),
            _____8BB0_5F55["消息类型"] or bj_QUESTMESSAGE_HINT,
            _____8BB0_5F55["文本"]
        )
        return
    end
    if _____8BB0_5F55["类型"] == "开门" then
        if _____8BB0_5F55["开门对象"] then
            local destructable = _____8BFB_53D6_5168_5C40_53E5_67C4(_____8BB0_5F55["开门对象"])
            if destructable ~= nil and destructable ~= 0 then
                _____5207_6362_5267_60C5_5927_95E8({["可破坏物全局名"] = _____8BB0_5F55["开门对象"], ["开关"] = "打开"})
            end
        end
        if _____8BB0_5F55["隐藏阻挡"] then
            local hidden = _____8BFB_53D6_5168_5C40_53E5_67C4(_____8BB0_5F55["隐藏阻挡"])
            if hidden ~= nil and hidden ~= 0 then
                ShowDestructable(hidden, false)
            end
        end
    end
end
local function _____5B89_6392_5EF6_8FDF_6267_884C(_____79D2_6570, _____8BB0_5F55)
    if not (_____79D2_6570 > 0) then
        if _____8BB0_5F55["类型"] == "消息" and _____8BB0_5F55["文本"] then
            QuestMessageBJ(
                GetPlayersAll(),
                _____8BB0_5F55["消息类型"] or bj_QUESTMESSAGE_HINT,
                _____8BB0_5F55["文本"]
            )
        else
            ____on_5EF6_8FDF_6267_884C_5230_65F6()
        end
        return
    end
    local timer = CreateTimer()
    _____5EF6_8FDF_6267_884C_7F13_5B58[GetHandleId(timer)] = _____8BB0_5F55
    safeTimerStart(
        nil,
        timer,
        _____79D2_6570,
        false,
        ____on_5EF6_8FDF_6267_884C_5230_65F6
    )
end
local function _____53D6_53C2_6570_6587_672C(_____53C2_6570, key)
    local value = _____53C2_6570[key]
    if type(value) == "string" then
        return value
    end
    if type(value) == "number" or type(value) == "boolean" then
        return tostring(value)
    end
    return ""
end
local function _____53D6_53C2_6570_6570_5B57(_____53C2_6570, key)
    local value = _____53C2_6570[key]
    if type(value) == "number" then
        return value
    end
    if type(value) == "string" then
        return __TS__Number(value) or 0
    end
    return 0
end
local function _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, key)
    return _____53C2_6570[key] == true
end
local function _____5206_5272_540D_79F0_5217_8868(value)
    if value == "" then
        return {}
    end
    return __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(value, ","),
            function(____, item) return __TS__StringTrim(item) end
        ),
        function(____, item) return #item > 0 end
    )
end
local function _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____5F15_7528)
    if _____5F15_7528 == "" then
        return nil
    end
    local splitIndex = (string.find(_____5F15_7528, ".", nil, true) or 0) - 1
    if splitIndex >= 0 then
        local tableName = __TS__StringSubstring(_____5F15_7528, 0, splitIndex)
        local keyName = __TS__StringSubstring(_____5F15_7528, splitIndex + 1)
        if tableName ~= "" and keyName ~= "" then
            return YDUserDataGetSafe("string", tableName, keyName, "unit")
        end
    end
    local _____5019_9009_8868_540D_5217_8868 = {
        "主线NPC",
        "ZX",
        "Boss",
        "Boss战",
        "jq"
    }
    do
        local i = 0
        while i < #_____5019_9009_8868_540D_5217_8868 do
            local unit = YDUserDataGetSafe("string", _____5019_9009_8868_540D_5217_8868[i + 1], _____5F15_7528, "unit")
            if unit ~= nil and unit ~= 0 then
                return unit
            end
            i = i + 1
        end
    end
    local _____5168_5C40_53E5_67C4 = _____8BFB_53D6_5168_5C40_53E5_67C4(_____5F15_7528)
    if _____5168_5C40_53E5_67C4 ~= nil and _____5168_5C40_53E5_67C4 ~= 0 then
        return _____5168_5C40_53E5_67C4
    end
    return nil
end
local function _____8BFB_53D6_89E6_53D1_5355_4F4D()
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    return _____4E0A_4E0B_6587["触发单位"]
end
local function _____4ECE_5355_4F4D_79FB_9664_6307_5B9A_7269_54C1(unit, _____7269_54C1_540D)
    if unit == nil or unit == 0 or _____7269_54C1_540D == "" then
        return false
    end
    local itemTypeId = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D))
    if not (itemTypeId > 0) then
        return false
    end
    if not UnitHasItemOfTypeBJ(unit, itemTypeId) then
        return false
    end
    local item = GetItemOfTypeFromUnitBJ(unit, itemTypeId)
    if item == nil or item == 0 then
        return false
    end
    RemoveItem(item)
    return true
end
local function ____on_8BBE_7F6E_679A_4E3E_82F1_96C4_6682_505C_65E0_654C()
    local unit = GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    PauseUnit(unit, _____5F53_524D_73A9_5BB6_82F1_96C4_63A7_5236_6682_505C)
    SetUnitInvulnerable(unit, _____5F53_524D_73A9_5BB6_82F1_96C4_65E0_654C)
end
local function _____5411_5546_5E97_6DFB_52A0_7269_54C1(unit, _____7269_54C1_540D_5217_8868)
    if unit == nil or unit == 0 or _____7269_54C1_540D_5217_8868 == "" then
        return
    end
    local items = _____5206_5272_540D_79F0_5217_8868(_____7269_54C1_540D_5217_8868)
    do
        local i = 0
        while i < #items do
            do
                local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(items[i + 1])
                local itemTypeId = stringToFourCCSafe(rawId)
                if not (itemTypeId > 0) then
                    goto __continue47
                end
                AddItemToStockBJ(itemTypeId, unit, 1, 1)
            end
            ::__continue47::
            i = i + 1
        end
    end
end
local function _____8C03_6574_5168_90E8_73A9_5BB6_91D1_5E01(delta)
    do
        local playerId = 0
        while playerId < 8 do
            AdjustPlayerStateBJ(
                delta,
                Player(playerId),
                PLAYER_STATE_RESOURCE_GOLD
            )
            playerId = playerId + 1
        end
    end
end
____exports["设置玩家英雄组控制状态"] = function(_____6682_505C, _____65E0_654C)
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return
    end
    _____5F53_524D_73A9_5BB6_82F1_96C4_63A7_5236_6682_505C = _____6682_505C
    _____5F53_524D_73A9_5BB6_82F1_96C4_65E0_654C = _____65E0_654C
    ForGroupBJ(_____73A9_5BB6_82F1_96C4_7EC4, ____on_8BBE_7F6E_679A_4E3E_82F1_96C4_6682_505C_65E0_654C)
end
____exports["设置触发单位控制状态"] = function(_____6682_505C, _____65E0_654C)
    local unit = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if unit == nil or unit == 0 then
        return
    end
    PauseUnit(unit, _____6682_505C)
    SetUnitInvulnerable(unit, _____65E0_654C)
end
____exports["给全部玩家添加区域视野"] = function(rectVarName)
    local rectHandle = _____8BFB_53D6_5168_5C40_53E5_67C4(rectVarName)
    if rectHandle == nil or rectHandle == 0 then
        return
    end
    do
        local playerId = 0
        while playerId < 8 do
            do
                local key = (rectVarName .. "#") .. tostring(playerId)
                if _____5DF2_521B_5EFA_89C6_91CE_4FEE_6574_5668[key] then
                    goto __continue59
                end
                local fogModifier = CreateFogModifierRect(
                    Player(playerId),
                    FOG_OF_WAR_VISIBLE,
                    rectHandle,
                    true,
                    false
                )
                if fogModifier == nil or fogModifier == 0 then
                    goto __continue59
                end
                FogModifierStart(fogModifier)
                _____5DF2_521B_5EFA_89C6_91CE_4FEE_6574_5668[key] = true
            end
            ::__continue59::
            playerId = playerId + 1
        end
    end
end
____exports["给全部玩家添加多个区域视野"] = function(rectVarNames)
    local _____5217_8868 = _____5206_5272_540D_79F0_5217_8868(rectVarNames)
    do
        local i = 0
        while i < #_____5217_8868 do
            ____exports["给全部玩家添加区域视野"](_____5217_8868[i + 1])
            i = i + 1
        end
    end
end
____exports["更新主线任务UI"] = function(_____4EFB_52A1_63CF_8FF0, _____63D0_793A_6587_672C)
    if not questDB:getQuest(_____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID) then
        questDB:registerQuest({
            id = _____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID,
            type = QuestType.MAIN,
            title = "主线任务",
            description = "剧情进行中",
            objectives = {{
                id = "stage",
                description = "推进主线剧情",
                current = 0,
                required = 1,
                completed = false
            }},
            rewards = {},
            status = QuestStatus.UNDISCOVERED,
            icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
            createdAt = os.time(),
            updatedAt = os.time()
        })
        questDB:acceptQuest(0, _____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID)
    end
    local ____opt_16 = questDB.globalData
    if ____opt_16 ~= nil then
        ____opt_16 = ____opt_16.quests
    end
    local ____opt_result_18
    if ____opt_16 ~= nil then
        ____opt_result_18 = ____opt_16:get(_____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID)
    end
    local _____4EFB_52A1 = ____opt_result_18
    if _____4EFB_52A1 ~= nil and _____4EFB_52A1_63CF_8FF0 ~= "" then
        _____4EFB_52A1.description = _____4EFB_52A1_63CF_8FF0
        _____4EFB_52A1.updatedAt = os.time()
    end
    local _____5237_65B0_51FD_6570 = questManager.triggerUIRefresh
    if type(_____5237_65B0_51FD_6570) == "function" then
        _____5237_65B0_51FD_6570:call(questManager, 0, _____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID)
    end
    if _____63D0_793A_6587_672C ~= "" then
        QuestMessageBJ(
            GetPlayersAll(),
            bj_QUESTMESSAGE_UPDATED,
            _____63D0_793A_6587_672C
        )
    end
end
____exports["按名字创建物品到单位位置"] = function(_____7269_54C1_540D, unit)
    if unit == nil or unit == 0 then
        return nil
    end
    local itemTypeId = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D))
    if not (itemTypeId > 0) then
        return nil
    end
    return CreateItem(
        itemTypeId,
        GetUnitX(unit),
        GetUnitY(unit)
    )
end
____exports["按名字给触发单位物品"] = function(_____7269_54C1_540D)
    local unit = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if unit == nil or unit == 0 then
        return
    end
    local itemTypeId = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D))
    if not (itemTypeId > 0) then
        return
    end
    local item = CreateItem(itemTypeId, 0, 0)
    if item == nil or item == 0 then
        return
    end
    UnitAddItem(unit, item)
end
____exports["触发单位增加基础全属性"] = function(value, _____63D0_793A_6A21_677F)
    local unit = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if unit == nil or unit == 0 then
        return
    end
    ModifyHeroStat(bj_HEROSTAT_STR, unit, bj_MODIFYMETHOD_ADD, value)
    ModifyHeroStat(bj_HEROSTAT_AGI, unit, bj_MODIFYMETHOD_ADD, value)
    ModifyHeroStat(bj_HEROSTAT_INT, unit, bj_MODIFYMETHOD_ADD, value)
    local message = __TS__StringReplace(
        __TS__StringReplace(
            _____63D0_793A_6A21_677F,
            "{英雄名}",
            GetUnitName(unit)
        ),
        "{value}",
        tostring(value)
    )
    _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F({["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED, ["文本"] = message})
end
____exports["执行通用剧情动作"] = function(_____53C2_6570)
    local _____8BBE_7F6E_8FDB_5EA6 = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "设置剧情进度") or _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "目标进度")
    if _____8BBE_7F6E_8FDB_5EA6 > 0 then
        _____5199_5165_5267_60C5_8FDB_5EA6(_____8BBE_7F6E_8FDB_5EA6)
    end
    if _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "开启电影模式") then
        local ____require_result_19 = require("lib.扩展函数.BJ函数.05A．电影函数")
        local CinematicModeBJ = ____require_result_19.CinematicModeBJ
        CinematicModeBJ(
            true,
            GetPlayersAll()
        )
    end
    if _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "关闭电影模式") then
        local ____require_result_20 = require("lib.扩展函数.BJ函数.05A．电影函数")
        local CinematicModeBJ = ____require_result_20.CinematicModeBJ
        CinematicModeBJ(
            false,
            GetPlayersAll()
        )
    end
    if _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "玩家英雄组暂停") or _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "玩家英雄组无敌") then
        ____exports["设置玩家英雄组控制状态"](true, true)
    end
    if _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "玩家英雄组恢复控制") or _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "玩家英雄组取消无敌") then
        ____exports["设置玩家英雄组控制状态"](false, false)
    end
    if _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "触发单位恢复控制") or _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "触发单位取消无敌") then
        ____exports["设置触发单位控制状态"](false, false)
    end
    if _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "关闭电影滤镜") then
        DisplayCineFilter(false)
    end
    if _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "时间设为午夜") then
        SetTimeOfDay(0)
    end
    local _____4EFB_52A1_63CF_8FF0 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "任务描述")
    local _____4EFB_52A1_63D0_793A = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "任务更新提示") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "任务更新")
    if _____4EFB_52A1_63CF_8FF0 ~= "" or _____4EFB_52A1_63D0_793A ~= "" then
        ____exports["更新主线任务UI"](_____4EFB_52A1_63CF_8FF0, _____4EFB_52A1_63D0_793A)
    end
    local _____5C0F_5730_56FEX = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "小地图X") or _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "小地图坐标X")
    local _____5C0F_5730_56FEY = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "小地图Y") or _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "小地图坐标Y")
    if _____5C0F_5730_56FEX ~= 0 or _____5C0F_5730_56FEY ~= 0 then
        _____53D1_9001_5267_60C5_5C0F_5730_56FE_4FE1_53F7({
            X = _____5C0F_5730_56FEX,
            Y = _____5C0F_5730_56FEY,
            ["持续时间"] = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "小地图持续时间") or 20
        })
    end
    local _____89C6_91CE_77E9_5F62 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "视野矩形") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "可见区域") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "解锁视野")
    if _____89C6_91CE_77E9_5F62 ~= "" then
        ____exports["给全部玩家添加多个区域视野"](_____89C6_91CE_77E9_5F62)
    end
    local _____53EF_89C1_533A_57DF1 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "可见区域1")
    local _____53EF_89C1_533A_57DF2 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "可见区域2")
    if _____53EF_89C1_533A_57DF1 ~= "" then
        ____exports["给全部玩家添加区域视野"](_____53EF_89C1_533A_57DF1)
    end
    if _____53EF_89C1_533A_57DF2 ~= "" then
        ____exports["给全部玩家添加区域视野"](_____53EF_89C1_533A_57DF2)
    end
    local ____NPC_5F15_7528 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "NPC") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "长老单位")
    local ____temp_21
    if ____NPC_5F15_7528 ~= "" then
        ____temp_21 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(____NPC_5F15_7528)
    else
        ____temp_21 = nil
    end
    local npcUnit = ____temp_21
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if npcUnit ~= nil and npcUnit ~= 0 then
        if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
            if _____53D6_53C2_6570_6587_672C(_____53C2_6570, "NPC转向目标") ~= "" or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "NPC转向触发单位") ~= "" then
                SetUnitFacing(
                    npcUnit,
                    GetUnitFacing(_____89E6_53D1_5355_4F4D)
                )
            end
            if _____53D6_53C2_6570_6587_672C(_____53C2_6570, "触发单位转向目标") ~= "" or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "触发单位转向耗时") ~= "" then
                SetUnitFacing(
                    _____89E6_53D1_5355_4F4D,
                    GetUnitFacing(npcUnit)
                )
            end
        end
        local _____5546_5E97_7269_54C1 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "商店新增物品")
        if _____5546_5E97_7269_54C1 ~= "" then
            _____5411_5546_5E97_6DFB_52A0_7269_54C1(npcUnit, _____5546_5E97_7269_54C1)
        end
        if _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "将NPC设为玩家控制") then
            SetUnitOwner(
                npcUnit,
                Player(6),
                true
            )
        end
    end
    local _____9700_8981_7269_54C1 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "需要物品") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "需要物品名")
    if _____9700_8981_7269_54C1 ~= "" then
        if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
            return
        end
        if not _____4ECE_5355_4F4D_79FB_9664_6307_5B9A_7269_54C1(_____89E6_53D1_5355_4F4D, _____9700_8981_7269_54C1) then
            return
        end
    end
    local _____5F00_95E8_5BF9_8C61 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "开门对象")
    if _____5F00_95E8_5BF9_8C61 ~= "" then
        local destructable = _____8BFB_53D6_5168_5C40_53E5_67C4(_____5F00_95E8_5BF9_8C61)
        if destructable ~= nil and destructable ~= 0 then
            ModifyGateBJ(bj_GATEOPERATION_OPEN, destructable)
        end
    end
    local _____9690_85CF_963B_6321 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "隐藏阻挡")
    if _____9690_85CF_963B_6321 ~= "" then
        local destructable = _____8BFB_53D6_5168_5C40_53E5_67C4(_____9690_85CF_963B_6321)
        if destructable ~= nil and destructable ~= 0 then
            ShowDestructable(destructable, false)
        end
    end
    local _____53EF_7834_574F_7269_5168_5C40_540D = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "可破坏物全局名")
    if _____53EF_7834_574F_7269_5168_5C40_540D ~= "" then
        _____5207_6362_5267_60C5_5927_95E8({
            ["可破坏物全局名"] = _____53EF_7834_574F_7269_5168_5C40_540D,
            ["开关"] = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "开关") == "关闭" and "关闭" or "打开"
        })
    end
    local _____7834_574F_7269 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "破坏物") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "移除阻挡")
    if _____7834_574F_7269 ~= "" then
        local destructable = _____8BFB_53D6_5168_5C40_53E5_67C4(_____7834_574F_7269)
        if destructable ~= nil and destructable ~= 0 then
            RemoveDestructable(destructable)
        end
    end
    local _____7269_54C1_540D = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "物品名") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "掉落物品名") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "奖励物品名")
    if _____7269_54C1_540D ~= "" then
        ____exports["按名字给触发单位物品"](_____7269_54C1_540D)
    end
    local _____6263_9664_91D1_5E01 = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "扣除金币")
    if _____6263_9664_91D1_5E01 ~= 0 and _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        AdjustPlayerStateBJ(
            -_____6263_9664_91D1_5E01,
            GetOwningPlayer(_____89E6_53D1_5355_4F4D),
            PLAYER_STATE_RESOURCE_GOLD
        )
    end
    local _____53D1_653E_91D1_5E01 = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "发放金币")
    if _____53D1_653E_91D1_5E01 ~= 0 then
        _____8C03_6574_5168_90E8_73A9_5BB6_91D1_5E01(_____53D1_653E_91D1_5E01)
    end
    local _____5EF6_8FDF_79D2_6570 = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "延迟秒数") or _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "延迟开门秒")
    local _____5EF6_8FDF_63D0_793A = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "延迟提示") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "延迟消息")
    if _____5EF6_8FDF_63D0_793A ~= "" then
        _____5B89_6392_5EF6_8FDF_6267_884C(_____5EF6_8FDF_79D2_6570, {["类型"] = "消息", ["文本"] = _____5EF6_8FDF_63D0_793A, ["消息类型"] = bj_QUESTMESSAGE_HINT})
    end
    if _____5F00_95E8_5BF9_8C61 ~= "" and _____5EF6_8FDF_79D2_6570 > 0 then
        _____5B89_6392_5EF6_8FDF_6267_884C(_____5EF6_8FDF_79D2_6570, {["类型"] = "开门", ["开门对象"] = _____5F00_95E8_5BF9_8C61, ["隐藏阻挡"] = _____9690_85CF_963B_6321})
    end
    local ____Boss_952E = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss键")
    local ____Boss_540D = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss名")
    local _____9700_8981_9884_521B_5EFABoss = ____Boss_540D ~= "" and (_____53D6_53C2_6570_6570_5B57(_____53C2_6570, "注册范围") > 0 or _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "预创建后暂停") or _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "预创建后无敌") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "范围触发剧情片段ID") ~= "")
    if _____9700_8981_9884_521B_5EFABoss then
        _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
            ["Boss键"] = ____Boss_952E,
            ["Boss名"] = ____Boss_540D,
            X = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "X"),
            Y = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "Y"),
            ["朝向"] = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "朝向"),
            ["注册范围"] = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "注册范围"),
            ["预创建后暂停"] = _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "预创建后暂停"),
            ["预创建后无敌"] = _____53D6_53C2_6570_5E03_5C14(_____53C2_6570, "预创建后无敌"),
            ["范围触发配置名"] = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "范围触发配置名"),
            ["范围触发剧情片段ID"] = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "范围触发剧情片段ID") or nil,
            ["需要剧情进度"] = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "触发进度") or nil
        })
    end
    local _____9700_8981_542F_52A8Boss = (____Boss_952E ~= "" or ____Boss_540D ~= "") and (_____53D6_53C2_6570_6587_672C(_____53C2_6570, "注册Boss技能事件") ~= "" or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战绑定单位字段") ~= "" or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战战斗音乐") ~= "" or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战胜利音乐") ~= "" or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战地点字段") ~= "" or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战地点") ~= "")
    if _____9700_8981_542F_52A8Boss then
        local bossUnit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(____Boss_952E ~= "" and ____Boss_952E or "Boss." .. ____Boss_540D)
        if bossUnit ~= nil and bossUnit ~= 0 then
            YDUserDataSetSafe(
                "string",
                "Boss战",
                "绑定单位",
                "unit",
                bossUnit
            )
            if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
                YDUserDataSetSafe(
                    "string",
                    "Boss战",
                    "触发玩家",
                    "unit",
                    _____89E6_53D1_5355_4F4D
                )
            end
            local _____6218_6597_97F3_4E50_53D8_91CF_540D = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战战斗音乐")
            if _____6218_6597_97F3_4E50_53D8_91CF_540D ~= "" then
                local _____97F3_9891_53E5_67C4 = _____8BFB_53D6_5168_5C40_53E5_67C4(_____6218_6597_97F3_4E50_53D8_91CF_540D)
                if _____97F3_9891_53E5_67C4 ~= nil and _____97F3_9891_53E5_67C4 ~= 0 then
                    YDUserDataSetSafe(
                        "string",
                        "Boss战",
                        "战斗音乐",
                        "sound",
                        _____97F3_9891_53E5_67C4
                    )
                end
            end
            local _____80DC_5229_97F3_4E50_53D8_91CF_540D = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战胜利音乐")
            if _____80DC_5229_97F3_4E50_53D8_91CF_540D ~= "" then
                local _____97F3_9891_53E5_67C4 = _____8BFB_53D6_5168_5C40_53E5_67C4(_____80DC_5229_97F3_4E50_53D8_91CF_540D)
                if _____97F3_9891_53E5_67C4 ~= nil and _____97F3_9891_53E5_67C4 ~= 0 then
                    YDUserDataSetSafe(
                        "string",
                        "Boss战",
                        "胜利音乐",
                        "sound",
                        _____97F3_9891_53E5_67C4
                    )
                end
            end
            local _____5730_70B9_53D8_91CF_540D = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战地点字段") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "Boss战地点")
            if _____5730_70B9_53D8_91CF_540D ~= "" then
                local rectHandle = _____8BFB_53D6_5168_5C40_53E5_67C4(_____5730_70B9_53D8_91CF_540D)
                if rectHandle ~= nil and rectHandle ~= 0 then
                    YDUserDataSetSafe(
                        "string",
                        "Boss战",
                        "地点",
                        "rect",
                        rectHandle
                    )
                end
            end
            _____542F_52A8Boss_6218_8FD0_884C(bossUnit)
        end
    end
    local _____6A21_578B_8DEF_5F84 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "模型路径")
    if _____6A21_578B_8DEF_5F84 ~= "" then
        local x = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "X") or (_____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and GetUnitX(_____89E6_53D1_5355_4F4D) or 0)
        local y = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "Y") or (_____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and GetUnitY(_____89E6_53D1_5355_4F4D) or 0)
        AddSpecialEffect(_____6A21_578B_8DEF_5F84, x, y)
    end
    local _____89E6_53D1_5355_4F4D_547D_4EE4 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "触发单位发布命令")
    if _____89E6_53D1_5355_4F4D_547D_4EE4 ~= "" then
        if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
            IssueImmediateOrder(_____89E6_53D1_5355_4F4D, _____89E6_53D1_5355_4F4D_547D_4EE4)
        end
    end
    local _____89E6_53D1_5355_4F4DX = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "触发单位X")
    local _____89E6_53D1_5355_4F4DY = _____53D6_53C2_6570_6570_5B57(_____53C2_6570, "触发单位Y")
    if (_____89E6_53D1_5355_4F4DX ~= 0 or _____89E6_53D1_5355_4F4DY ~= 0) and _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        SetUnitPosition(_____89E6_53D1_5355_4F4D, _____89E6_53D1_5355_4F4DX, _____89E6_53D1_5355_4F4DY)
    end
    local _____505C_6B62_533A_57DF_97F3_4E50 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "停止区域音乐") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "关闭区域音乐")
    if _____505C_6B62_533A_57DF_97F3_4E50 ~= "" then
        _____5207_6362_533A_57DF_97F3_4E50_8868_8FBE_5F0F(_____505C_6B62_533A_57DF_97F3_4E50, false)
    end
    local _____5F00_59CB_533A_57DF_97F3_4E50 = _____53D6_53C2_6570_6587_672C(_____53C2_6570, "开始音乐") or _____53D6_53C2_6570_6587_672C(_____53C2_6570, "开启区域音乐")
    if _____5F00_59CB_533A_57DF_97F3_4E50 ~= "" then
        _____5207_6362_533A_57DF_97F3_4E50_8868_8FBE_5F0F(_____5F00_59CB_533A_57DF_97F3_4E50, true)
    end
end
return ____exports
