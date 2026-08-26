--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC, stringToFourCCSafe
function stringToFourCC(value)
    return stringToFourCCSafe(value)
end
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_1["获取矩形区域"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertySafe = ____require_result_3.getObjectPropertySafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local ____require_result_4 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local ModifyHeroSkillPoints = ____require_result_4.ModifyHeroSkillPoints
local ____require_result_5 = require("lib.扩展函数.BJ函数.07．杂项")
local ForGroupBJ = ____require_result_5.ForGroupBJ
local GetUnitsInRectMatching = ____require_result_5.GetUnitsInRectMatching
local ____require_result_6 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local RectContainsUnit = ____require_result_6.RectContainsUnit
local ____require_result_7 = require("平台扩展API动作")
local _____8BBE_5355_4F4D_5934_50CF_6A21_578B = ____require_result_7["设单位头像模型"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local Player = jass.Player
local CreateTimer = jass.CreateTimer
local DestroyTimer = jass.DestroyTimer
local TimerStart = jass.TimerStart
local CreateTimerDialog = jass.CreateTimerDialog
local DestroyTimerDialog = jass.DestroyTimerDialog
local TimerDialogSetTitle = jass.TimerDialogSetTitle
local TimerDialogDisplay = jass.TimerDialogDisplay
local CreateFogModifierRect = jass.CreateFogModifierRect
local FogModifierStart = jass.FogModifierStart
local DestroyGroup = jass.DestroyGroup
local IsUnitType = jass.IsUnitType
local GetFilterUnit = jass.GetFilterUnit
local GetEnumUnit = jass.GetEnumUnit
local GetTriggerUnit = jass.GetTriggerUnit
local GetTriggerEventId = jass.GetTriggerEventId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitTypeId = jass.GetUnitTypeId
local IssueImmediateOrder = jass.IssueImmediateOrder
local SelectUnit = jass.SelectUnit
local UnitAddAbility = jass.UnitAddAbility
local CreateTrigger = jass.CreateTrigger
local DestroyTrigger = jass.DestroyTrigger
local TriggerRegisterUnitEvent = jass.TriggerRegisterUnitEvent
local TriggerRegisterTimerEventSingle = jass.TriggerRegisterTimerEventSingle
local TriggerAddCondition = jass.TriggerAddCondition
local Condition = jass.Condition
local FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local EVENT_UNIT_SPELL_CHANNEL = jass.EVENT_UNIT_SPELL_CHANNEL
local EVENT_GAME_TIMER_EXPIRED = jass.EVENT_GAME_TIMER_EXPIRED
local YDWE_OBJECT_TYPE_UNIT = 2
local NEUTRAL_PASSIVE_PLAYER_ID = jass.PLAYER_NEUTRAL_PASSIVE
local HERO_SKILL_VIEW_ABILITY_ID = 1097753906
local HERO_SKILL_POINT_SUB = jglobals.bj_MODIFYMETHOD_SUB
local _____7B2C_4E00_6279_82F1_96C4_5C55_793A_914D_7F6E = {{
    ["名称"] = "克劳德",
    ["单位ID"] = "E05V",
    X = -29248.4,
    Y = 27608.3,
    ["朝向"] = 270,
    ["头像"] = "war3mapImported\\YXXX-KLD.mdx"
}, {
    ["名称"] = "坂井悠二",
    ["单位ID"] = "H00M",
    X = -29698.2,
    Y = 27623.9,
    ["朝向"] = 270,
    ["头像"] = "war3mapImported\\YXXX-BJUE.mdx"
}, {
    ["名称"] = "阿劳伦特",
    ["单位ID"] = "H00F",
    X = -28229,
    Y = 28929.2,
    ["朝向"] = 345
}}
local _____7B2C_4E8C_6279_82F1_96C4_5C55_793A_914D_7F6E = {
    {
        ["名称"] = "Saber",
        ["单位ID"] = "H00H",
        X = -29707.4,
        Y = 27257.5,
        ["朝向"] = 0,
        ["头像"] = "war3mapImported\\YYXX-saber.mdx"
    },
    {
        ["名称"] = "逆回十六夜",
        ["单位ID"] = "H00J",
        X = -29532.3,
        Y = 27618.7,
        ["朝向"] = 270,
        ["头像"] = "war3mapImported\\YXXX-NHSLY.mdx"
    },
    {
        ["名称"] = "安斯艾尔",
        ["单位ID"] = "Hart",
        X = -27288.2,
        Y = 28870.6,
        ["朝向"] = 180
    },
    {
        ["名称"] = "藤原妹红",
        ["单位ID"] = "H00R",
        X = -25513.4,
        Y = 29042.4,
        ["朝向"] = 135,
        ["头像"] = "war3mapImported\\YXXX-TYMH.mdx"
    },
    {
        ["名称"] = "佐佐木小次郎",
        ["单位ID"] = "H00S",
        X = -29387.4,
        Y = 27638.1,
        ["朝向"] = 270,
        ["头像"] = "war3mapImported\\YXXX-ZZMXCL.mdx"
    },
    {
        ["名称"] = "欧尔贝克",
        ["单位ID"] = "H012",
        X = -27498.7,
        Y = 29001.8,
        ["朝向"] = 270
    },
    {
        ["名称"] = "蕾米莉亚",
        ["单位ID"] = "E08J",
        X = -26070.4,
        Y = 29275,
        ["朝向"] = 235,
        ["头像"] = "war3mapImported\\YXXX-LMLY.mdx"
    }
}
local _____7B2C_4E09_6279_82F1_96C4_5C55_793A_914D_7F6E = {{
    ["名称"] = "十六夜咲夜",
    ["单位ID"] = "E001",
    X = -25940.2,
    Y = 29242,
    ["朝向"] = 252.1,
    ["头像"] = "war3mapImported\\YXXX-SLYXY.mdx"
}, {
    ["名称"] = "铃仙",
    ["单位ID"] = "E07R",
    X = -25674,
    Y = 29219.7,
    ["朝向"] = 270,
    ["头像"] = "war3mapImported\\YXXX-LX.mdx"
}, {
    ["名称"] = "黑崎一护",
    ["单位ID"] = "E006",
    X = -29109.4,
    Y = 27615,
    ["朝向"] = 270,
    ["头像"] = "war3mapImported\\YXXX-HQYH.mdx"
}}
local _____7B2C_56DB_6279_82F1_96C4_5C55_793A_914D_7F6E = {
    {
        ["名称"] = "鹿目圆香",
        ["单位ID"] = "E004",
        X = -29615.3,
        Y = 26957.7,
        ["朝向"] = 350.5,
        ["头像"] = "war3mapImported\\YXXX-XY.mdx"
    },
    {
        ["名称"] = "八云紫",
        ["单位ID"] = "H00P",
        X = -25811.7,
        Y = 29394.2,
        ["朝向"] = 270,
        ["头像"] = "war3mapImported\\YXXX-BYZ.mdx"
    },
    {
        ["名称"] = "一方通行",
        ["单位ID"] = "H00I",
        X = -29330.4,
        Y = 26855.3,
        ["朝向"] = 90,
        ["头像"] = "war3mapImported\\YXXX-YFTX.mdx"
    },
    {
        ["名称"] = "云端",
        ["单位ID"] = "E03I",
        X = -25618.8,
        Y = 27476.1,
        ["朝向"] = 135
    },
    {
        ["名称"] = "欧菲莉亚",
        ["单位ID"] = "H013",
        X = -29679.9,
        Y = 29203.4,
        ["朝向"] = 0,
        ["头像"] = "war3mapImported\\XX5.mdx"
    },
    {
        ["名称"] = "提米诺斯",
        ["单位ID"] = "H015",
        X = -29311.9,
        Y = 29083.5,
        ["朝向"] = 180,
        ["头像"] = "war3mapImported\\XX2.mdx"
    },
    {
        ["名称"] = "塞拉斯",
        ["单位ID"] = "H014",
        X = -28797.8,
        Y = 28265.8,
        ["朝向"] = 237.8,
        ["头像"] = "war3mapImported\\XX4.mdx"
    }
}
local _____82F1_96C4_9009_62E9_573A_666F_5DF2_521D_59CB_5316 = false
local _____82F1_96C4_9009_62E9_8BA1_65F6_5668 = nil
local _____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3 = nil
local _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 = nil
local function _____521B_5EFA_82F1_96C4_5C55_793A_5355_4F4D(_____914D_7F6E)
    local _____5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(NEUTRAL_PASSIVE_PLAYER_ID),
        stringToFourCC(_____914D_7F6E["单位ID"]),
        _____914D_7F6E.X,
        _____914D_7F6E.Y,
        _____914D_7F6E["朝向"]
    )
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and _____914D_7F6E["头像"] ~= nil then
        _____8BBE_5355_4F4D_5934_50CF_6A21_578B(_____5355_4F4D, _____914D_7F6E["头像"])
    end
    return _____5355_4F4D
end
local function _____521B_5EFA_82F1_96C4_5C55_793A_6279_6B21(_____914D_7F6E_8868)
    do
        local i = 0
        while i < #_____914D_7F6E_8868 do
            _____521B_5EFA_82F1_96C4_5C55_793A_5355_4F4D(_____914D_7F6E_8868[i + 1])
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_9009_62E9_573A_666F_89C6_91CE()
    local _____9009_62E9_533A_57DF = _____83B7_53D6_77E9_5F62_533A_57DF("英雄选择区域")
    if _____9009_62E9_533A_57DF == nil or _____9009_62E9_533A_57DF == 0 then
        return
    end
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < 4 do
            local _____89C6_91CE_4FEE_6B63_5668 = CreateFogModifierRect(
                Player(_____73A9_5BB6ID),
                FOG_OF_WAR_VISIBLE,
                _____9009_62E9_533A_57DF,
                true,
                false
            )
            if _____89C6_91CE_4FEE_6B63_5668 ~= nil and _____89C6_91CE_4FEE_6B63_5668 ~= 0 then
                FogModifierStart(_____89C6_91CE_4FEE_6B63_5668)
            end
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
local function _____662F_82F1_96C4_5C55_793A_5355_4F4D()
    return IsUnitType(
        GetFilterUnit(),
        UNIT_TYPE_HERO
    ) == true
end
local function _____521D_59CB_5316_82F1_96C4_6280_80FD_67E5_770B_5355_4F4D()
    local _____9009_53D6_5355_4F4D = GetEnumUnit()
    if _____9009_53D6_5355_4F4D == nil or _____9009_53D6_5355_4F4D == 0 then
        return
    end
    local _____6A21_578B = getObjectPropertySafe(
        YDWE_OBJECT_TYPE_UNIT,
        GetUnitTypeId(_____9009_53D6_5355_4F4D),
        "file"
    )
    YDUserDataSetSafe(
        "unit",
        _____9009_53D6_5355_4F4D,
        "模型",
        "string",
        _____6A21_578B
    )
    UnitAddAbility(_____9009_53D6_5355_4F4D, HERO_SKILL_VIEW_ABILITY_ID)
    ModifyHeroSkillPoints(_____9009_53D6_5355_4F4D, HERO_SKILL_POINT_SUB, 1)
    if _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 == nil or _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 == 0 then
        return
    end
    TriggerRegisterUnitEvent(_____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1, _____9009_53D6_5355_4F4D, EVENT_UNIT_SPELL_CHANNEL)
end
local function _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1_6761_4EF6()
    if GetTriggerEventId() == EVENT_GAME_TIMER_EXPIRED then
        if _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 ~= nil and _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 ~= 0 then
            DestroyTrigger(_____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1)
            _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 = nil
        end
        return true
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    local _____9009_62E9_533A_57DF = _____83B7_53D6_77E9_5F62_533A_57DF("英雄选择区域")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and GetOwningPlayer(_____89E6_53D1_5355_4F4D) == Player(NEUTRAL_PASSIVE_PLAYER_ID) and _____9009_62E9_533A_57DF ~= nil and _____9009_62E9_533A_57DF ~= 0 and RectContainsUnit(_____9009_62E9_533A_57DF, _____89E6_53D1_5355_4F4D) == true then
        IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
        SelectUnit(_____89E6_53D1_5355_4F4D, false)
    end
    return true
end
local function _____51C6_5907_82F1_96C4_6280_80FD_67E5_770B()
    local _____9009_62E9_533A_57DF = _____83B7_53D6_77E9_5F62_533A_57DF("英雄选择区域")
    if _____9009_62E9_533A_57DF == nil or _____9009_62E9_533A_57DF == 0 then
        return
    end
    local _____82F1_96C4_7EC4 = GetUnitsInRectMatching(
        _____9009_62E9_533A_57DF,
        Condition(_____662F_82F1_96C4_5C55_793A_5355_4F4D)
    )
    if _____82F1_96C4_7EC4 == nil or _____82F1_96C4_7EC4 == 0 then
        return
    end
    _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 = CreateTrigger()
    if _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 == nil or _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1 == 0 then
        DestroyGroup(_____82F1_96C4_7EC4)
        return
    end
    ForGroupBJ(_____82F1_96C4_7EC4, _____521D_59CB_5316_82F1_96C4_6280_80FD_67E5_770B_5355_4F4D)
    TriggerRegisterTimerEventSingle(_____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1, 300)
    TriggerAddCondition(
        _____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1,
        Condition(_____82F1_96C4_6280_80FD_67E5_770B_89E6_53D1_6761_4EF6)
    )
    DestroyGroup(_____82F1_96C4_7EC4)
end
local function _____521B_5EFA_7B2C_4E8C_6279_82F1_96C4_5C55_793A()
    _____521B_5EFA_82F1_96C4_5C55_793A_6279_6B21(_____7B2C_4E8C_6279_82F1_96C4_5C55_793A_914D_7F6E)
end
local function _____521B_5EFA_7B2C_4E09_6279_82F1_96C4_5C55_793A()
    _____521B_5EFA_82F1_96C4_5C55_793A_6279_6B21(_____7B2C_4E09_6279_82F1_96C4_5C55_793A_914D_7F6E)
end
local function _____521B_5EFA_7B2C_56DB_6279_82F1_96C4_5C55_793A()
    _____521B_5EFA_82F1_96C4_5C55_793A_6279_6B21(_____7B2C_56DB_6279_82F1_96C4_5C55_793A_914D_7F6E)
end
local function _____6E05_7406_82F1_96C4_9009_62E9_573A_666F_8BA1_65F6_5668()
    if _____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3 ~= nil and _____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3 ~= 0 then
        TimerDialogDisplay(_____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3, false)
        DestroyTimerDialog(_____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3)
        _____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3 = nil
    end
    if _____82F1_96C4_9009_62E9_8BA1_65F6_5668 ~= nil and _____82F1_96C4_9009_62E9_8BA1_65F6_5668 ~= 0 then
        DestroyTimer(_____82F1_96C4_9009_62E9_8BA1_65F6_5668)
        _____82F1_96C4_9009_62E9_8BA1_65F6_5668 = nil
    end
end
local function _____521D_59CB_5316_82F1_96C4_9009_62E9_573A_666F()
    _____521D_59CB_5316_9009_62E9_573A_666F_89C6_91CE()
    _____82F1_96C4_9009_62E9_8BA1_65F6_5668 = CreateTimer()
    _____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3 = CreateTimerDialog(_____82F1_96C4_9009_62E9_8BA1_65F6_5668)
    if _____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3 ~= nil and _____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3 ~= 0 then
        TimerDialogSetTitle(_____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3, "TRIGSTR_007")
        TimerDialogDisplay(_____82F1_96C4_9009_62E9_8BA1_65F6_5668_7A97_53E3, true)
    end
    TimerStart(_____82F1_96C4_9009_62E9_8BA1_65F6_5668, 180, false, nil)
    _____521B_5EFA_82F1_96C4_5C55_793A_6279_6B21(_____7B2C_4E00_6279_82F1_96C4_5C55_793A_914D_7F6E)
    addDelayedCallback(900, _____521B_5EFA_7B2C_4E8C_6279_82F1_96C4_5C55_793A)
    addDelayedCallback(1650, _____521B_5EFA_7B2C_4E09_6279_82F1_96C4_5C55_793A)
    addDelayedCallback(2400, _____521B_5EFA_7B2C_56DB_6279_82F1_96C4_5C55_793A)
    addDelayedCallback(4900, _____51C6_5907_82F1_96C4_6280_80FD_67E5_770B)
    addDelayedCallback(179900, _____6E05_7406_82F1_96C4_9009_62E9_573A_666F_8BA1_65F6_5668)
end
____exports["初始化世界地图英雄选择场景"] = function()
    if _____82F1_96C4_9009_62E9_573A_666F_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_9009_62E9_573A_666F_5DF2_521D_59CB_5316 = true
    addDelayedCallback(100, _____521D_59CB_5316_82F1_96C4_9009_62E9_573A_666F)
end
____exports["获取英雄选择场景初始化状态"] = function()
    return _____82F1_96C4_9009_62E9_573A_666F_5DF2_521D_59CB_5316
end
return ____exports
