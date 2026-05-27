local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668["播放主线剧情片段"]
---
-- @noSelfInFile
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitFacingToFaceUnitTimed = ____require_result_0.SetUnitFacingToFaceUnitTimed
local ModifyHeroStat = ____require_result_0.ModifyHeroStat
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local ForGroupBJ = ____require_result_1.ForGroupBJ
local GetPlayersAll = ____require_result_1.GetPlayersAll
local ____require_result_2 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local RectContainsUnit = ____require_result_2.RectContainsUnit
local ____require_result_3 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_3.TriggerRegisterUnitInRangeSimple
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_4.YDUserDataSetSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_4.YDWEAngleBetweenUnitsSafe
local ____require_result_5 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_5["按名字反查物品ID"]
local ____require_result_6 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_6["按名字反查Boss单位ID"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.12．JASS原生别名")
local AddSpecialEffect = ____require_result_8.AddSpecialEffect
local Condition = ____require_result_8.Condition
local CreateFogModifierRect = ____require_result_8.CreateFogModifierRect
local CreateItem = ____require_result_8.CreateItem
local CreateTrigger = ____require_result_8.CreateTrigger
local CreateUnit = ____require_result_8.CreateUnit
local DestroyGroup = ____require_result_8.DestroyGroup
local FirstOfGroup = ____require_result_8.FirstOfGroup
local FogModifierStart = ____require_result_8.FogModifierStart
local FOG_OF_WAR_VISIBLE = ____require_result_8.FOG_OF_WAR_VISIBLE
local GetEnumUnit = ____require_result_8.GetEnumUnit
local GetFilterUnit = ____require_result_8.GetFilterUnit
local GetRandomReal = ____require_result_8.GetRandomReal
local GetTriggerUnit = ____require_result_8.GetTriggerUnit
local GetUnitTypeId = ____require_result_8.GetUnitTypeId
local GetUnitX = ____require_result_8.GetUnitX
local GetUnitY = ____require_result_8.GetUnitY
local GetUnitsInRectMatching = ____require_result_8.GetUnitsInRectMatching
local GroupRemoveUnit = ____require_result_8.GroupRemoveUnit
local IssueImmediateOrder = ____require_result_8.IssueImmediateOrder
local IsUnitInGroup = ____require_result_8.IsUnitInGroup
local Location = ____require_result_8.Location
local PauseUnit = ____require_result_8.PauseUnit
local Player = ____require_result_8.Player
local PLAYER_NEUTRAL_PASSIVE = ____require_result_8.PLAYER_NEUTRAL_PASSIVE
local RemoveLocation = ____require_result_8.RemoveLocation
local RemoveRect = ____require_result_8.RemoveRect
local SetUnitFacing = ____require_result_8.SetUnitFacing
local SetUnitFacingTimed = ____require_result_8.SetUnitFacingTimed
local SetUnitInvulnerable = ____require_result_8.SetUnitInvulnerable
local SetUnitOwner = ____require_result_8.SetUnitOwner
local StopMusic = ____require_result_8.StopMusic
local TriggerAddAction = ____require_result_8.TriggerAddAction
local TriggerRegisterEnterRectSimple = ____require_result_8.TriggerRegisterEnterRectSimple
local ____require_result_9 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____require_result_9["发送剧情任务消息"]
local _____53D1_9001_5267_60C5_5C0F_5730_56FE_4FE1_53F7 = ____require_result_9["发送剧情小地图信号"]
local ____require_result_10 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027 = ____require_result_10["触发单位增加基础全属性"]
local bj_HEROSTAT_STR = jglobals.bj_HEROSTAT_STR
local bj_HEROSTAT_AGI = jglobals.bj_HEROSTAT_AGI
local bj_HEROSTAT_INT = jglobals.bj_HEROSTAT_INT
local bj_MODIFYMETHOD_ADD = jglobals.bj_MODIFYMETHOD_ADD
local bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED
local _____5DF2_521D_59CB_5316_8FDB_5EA601_6838_5FC3 = false
local _____5DF2_89E6_53D1_6751_53E3_653E_884C = false
local _____6751_53E3_653E_884C_73A9_5BB6_9762_5411_89D2_5EA6 = 0
local function _____8BFB_53D6_957F_8001_5355_4F4D()
    return YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
end
local function _____662F_81EA_7136_5B88_62A4_8005()
    local unit = GetFilterUnit()
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == stringToFourCCSafe("etrp")
end
local function ____on_6751_53E3_653E_884C_73A9_5BB6_505C_4E0B_5E76_8F6C_5411()
    local unit = GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    IssueImmediateOrder(unit, "stop")
    SetUnitFacing(unit, _____6751_53E3_653E_884C_73A9_5BB6_9762_5411_89D2_5EA6)
end
local function _____5206_5272_540D_79F0_5217_8868(value)
    if value == nil or value == "" then
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
local function _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE(rectVarName)
    local rectHandle = jglobals[rectVarName]
    if rectHandle == nil or rectHandle == 0 then
        return
    end
    do
        local playerId = 0
        while playerId < 8 do
            do
                local fogModifier = CreateFogModifierRect(
                    Player(playerId),
                    FOG_OF_WAR_VISIBLE,
                    rectHandle,
                    true,
                    false
                )
                if fogModifier == nil or fogModifier == 0 then
                    goto __continue13
                end
                FogModifierStart(fogModifier)
            end
            ::__continue13::
            playerId = playerId + 1
        end
    end
end
local function _____91CD_8BBE_5267_60C5FHD_70B9(x, y)
    local oldLocation = jglobals.udg_FHD
    if oldLocation ~= nil and oldLocation ~= 0 then
        RemoveLocation(oldLocation)
    end
    jglobals.udg_FHD = Location(x, y)
end
local function _____521B_5EFA_968F_673A_91D1_5149_6212_6307()
    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID("金光戒指")
    local itemTypeId = stringToFourCCSafe(rawId)
    if not (itemTypeId > 0) then
        return
    end
    CreateItem(
        itemTypeId,
        -10112.9 + GetRandomReal(-1800, 1800),
        -26327.3 + GetRandomReal(-1800, 1800)
    )
end
____exports["执行村口放行前置"] = function(_____53C2_6570)
    local ____53C2_6570__95E8_7981_77E9_5F62_11 = _____53C2_6570["门禁矩形"]
    if ____53C2_6570__95E8_7981_77E9_5F62_11 == nil then
        ____53C2_6570__95E8_7981_77E9_5F62_11 = ""
    end
    local _____95E8_7981_77E9_5F62 = tostring(____53C2_6570__95E8_7981_77E9_5F62_11)
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____95E8_7981_77E9_5F62 == "" then
        return
    end
    local rectHandle = jglobals[_____95E8_7981_77E9_5F62]
    local _____95E8_536B_7EC4 = GetUnitsInRectMatching(
        rectHandle,
        Condition(_____662F_81EA_7136_5B88_62A4_8005)
    )
    if _____95E8_536B_7EC4 ~= nil and _____95E8_536B_7EC4 ~= 0 then
        local unit = FirstOfGroup(_____95E8_536B_7EC4)
        while unit ~= nil and unit ~= 0 do
            IssueImmediateOrder(unit, "stop")
            SetUnitFacing(unit, 210)
            if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
                _____6751_53E3_653E_884C_73A9_5BB6_9762_5411_89D2_5EA6 = YDWEAngleBetweenUnitsSafe(_____89E6_53D1_5355_4F4D, unit)
                ForGroupBJ(_____73A9_5BB6_82F1_96C4_7EC4, ____on_6751_53E3_653E_884C_73A9_5BB6_505C_4E0B_5E76_8F6C_5411)
            end
            GroupRemoveUnit(_____95E8_536B_7EC4, unit)
            unit = FirstOfGroup(_____95E8_536B_7EC4)
        end
        DestroyGroup(_____95E8_536B_7EC4)
    end
    if rectHandle ~= nil and rectHandle ~= 0 then
        RemoveRect(rectHandle)
    end
end
____exports["执行长老对话前置"] = function(_____53C2_6570)
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    local _____957F_8001_5355_4F4D = _____8BFB_53D6_957F_8001_5355_4F4D()
    local _____81EA_7136_4F20_9001_95E8 = jglobals.gg_unit_n025_0372
    _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE("gg_rct________________QY")
    if _____81EA_7136_4F20_9001_95E8 ~= nil and _____81EA_7136_4F20_9001_95E8 ~= 0 then
        SetUnitOwner(
            _____81EA_7136_4F20_9001_95E8,
            Player(6),
            true
        )
    end
    _____91CD_8BBE_5267_60C5FHD_70B9(-26218.6, -28632.4)
    _____521B_5EFA_968F_673A_91D1_5149_6212_6307()
    StopMusic(false)
    if type(_____53C2_6570["设置剧情进度"]) == "number" then
        YDUserDataSetSafe(
            "string",
            "剧情进度",
            "整数",
            "integer",
            _____53C2_6570["设置剧情进度"]
        )
    end
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and _____53C2_6570["触发单位发布命令"] ~= nil then
        IssueImmediateOrder(
            _____89E6_53D1_5355_4F4D,
            tostring(_____53C2_6570["触发单位发布命令"])
        )
    end
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and _____957F_8001_5355_4F4D ~= nil and _____957F_8001_5355_4F4D ~= 0 then
        SetUnitFacingToFaceUnitTimed(
            _____89E6_53D1_5355_4F4D,
            _____957F_8001_5355_4F4D,
            __TS__Number(_____53C2_6570["触发单位转向耗时"]) or 0
        )
        SetUnitFacingTimed(
            _____957F_8001_5355_4F4D,
            YDWEAngleBetweenUnitsSafe(_____957F_8001_5355_4F4D, _____89E6_53D1_5355_4F4D),
            __TS__Number(_____53C2_6570["长老转向耗时"]) or 0
        )
    end
    if _____957F_8001_5355_4F4D ~= nil and _____957F_8001_5355_4F4D ~= 0 and type(_____53C2_6570["长老归属玩家"]) == "number" then
        SetUnitOwner(
            _____957F_8001_5355_4F4D,
            Player(_____53C2_6570["长老归属玩家"]),
            true
        )
    end
end
____exports["执行长老任务物品生成"] = function(_____53C2_6570)
    local _____957F_8001_5355_4F4D = _____8BFB_53D6_957F_8001_5355_4F4D()
    if _____957F_8001_5355_4F4D == nil or _____957F_8001_5355_4F4D == 0 then
        return
    end
    local ____5206_5272_540D_79F0_5217_8868_13 = _____5206_5272_540D_79F0_5217_8868
    local ____53C2_6570__7269_54C1_540D_5217_8868_12 = _____53C2_6570["物品名列表"]
    if ____53C2_6570__7269_54C1_540D_5217_8868_12 == nil then
        ____53C2_6570__7269_54C1_540D_5217_8868_12 = ""
    end
    local _____7269_54C1_540D_5217_8868 = ____5206_5272_540D_79F0_5217_8868_13(tostring(____53C2_6570__7269_54C1_540D_5217_8868_12))
    do
        local i = 0
        while i < #_____7269_54C1_540D_5217_8868 do
            local itemTypeId = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D_5217_8868[i + 1]))
            if itemTypeId > 0 then
                CreateItem(
                    itemTypeId,
                    GetUnitX(_____957F_8001_5355_4F4D),
                    GetUnitY(_____957F_8001_5355_4F4D)
                )
            end
            i = i + 1
        end
    end
end
____exports["执行长老任务更新"] = function(_____53C2_6570)
    _____53D1_9001_5267_60C5_5C0F_5730_56FE_4FE1_53F7({
        X = __TS__Number(_____53C2_6570["小地图X"]) or 0,
        Y = __TS__Number(_____53C2_6570["小地图Y"]) or 0,
        ["持续时间"] = __TS__Number(_____53C2_6570["小地图持续时间"]) or 0
    })
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_15 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_14 = _____53C2_6570["任务更新提示"]
    if ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_14 == nil then
        ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_14 = ""
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_15({
        ["消息类型"] = bj_QUESTMESSAGE_UPDATED,
        ["文本"] = tostring(____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_14)
    })
end
____exports["执行地精区域显视野"] = function(_____53C2_6570)
    local ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_17 = _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE
    local ____53C2_6570__53EF_89C1_533A_57DF1_16 = _____53C2_6570["可见区域1"]
    if ____53C2_6570__53EF_89C1_533A_57DF1_16 == nil then
        ____53C2_6570__53EF_89C1_533A_57DF1_16 = ""
    end
    ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_17(tostring(____53C2_6570__53EF_89C1_533A_57DF1_16))
    local ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_19 = _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE
    local ____53C2_6570__53EF_89C1_533A_57DF2_18 = _____53C2_6570["可见区域2"]
    if ____53C2_6570__53EF_89C1_533A_57DF2_18 == nil then
        ____53C2_6570__53EF_89C1_533A_57DF2_18 = ""
    end
    ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_19(tostring(____53C2_6570__53EF_89C1_533A_57DF2_18))
end
____exports["执行地精祭祀Boss预备"] = function(_____53C2_6570)
    StopMusic(false)
    local ____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID_21 = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID
    local ____53C2_6570_Boss_540D_20 = _____53C2_6570["Boss名"]
    if ____53C2_6570_Boss_540D_20 == nil then
        ____53C2_6570_Boss_540D_20 = "地精祭祀"
    end
    local bossRawId = ____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID_21(tostring(____53C2_6570_Boss_540D_20)) or _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID("地精祭祀|cffff0000（BossLV12）|r")
    local bossTypeId = stringToFourCCSafe(bossRawId)
    if not (bossTypeId > 0) then
        return
    end
    local bossUnit = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        bossTypeId,
        __TS__Number(_____53C2_6570.X) or -26032.4,
        __TS__Number(_____53C2_6570.Y) or -13789.5,
        __TS__Number(_____53C2_6570["朝向"]) or 270
    )
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss",
        "地精巫师",
        "unit",
        bossUnit
    )
    PauseUnit(bossUnit, _____53C2_6570["预创建后暂停"] == true)
    SetUnitInvulnerable(bossUnit, _____53C2_6570["预创建后无敌"] == true)
end
____exports["执行远古波动奖励"] = function(_____53C2_6570)
    local _____5956_52B1_503C = __TS__Number(_____53C2_6570["力量"]) or __TS__Number(_____53C2_6570["全属性"]) or 3
    local ____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027_23 = _____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027
    local ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_22 = _____53C2_6570["任务消息模板"]
    if ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_22 == nil then
        ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_22 = "{英雄名}受到了远古波动！（|cffff99cc全属性+{value}|r）"
    end
    ____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027_23(
        _____5956_52B1_503C,
        tostring(____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_22)
    )
end
____exports["精灵村长老发布任务剧情动作注册表"] = {
    ["JLC精灵村_村口放行前置"] = ____exports["执行村口放行前置"],
    ["JLC精灵村_长老对话前置"] = ____exports["执行长老对话前置"],
    ["JLC精灵村_长老任务物品生成"] = ____exports["执行长老任务物品生成"],
    ["JLC精灵村_发布地精任务"] = ____exports["执行长老任务更新"],
    ["JLC精灵村_地精区域显视野"] = ____exports["执行地精区域显视野"],
    ["JLC精灵村_创建地精祭祀Boss预备"] = ____exports["执行地精祭祀Boss预备"],
    ["JLC精灵村_远古波动奖励"] = ____exports["执行远古波动奖励"]
}
local function _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    return _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 and IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_7EC4)
end
local function _____5199_5165_5E76_64AD_653E_5267_60C5(_____7247_6BB5ID, _____89E6_53D1_914D_7F6E_540D, _____89E6_53D1_5355_4F4D)
    _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587({["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = _____89E6_53D1_914D_7F6E_540D, ["触发单位"] = _____89E6_53D1_5355_4F4D})
    return _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = _____89E6_53D1_914D_7F6E_540D, ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function _____89E6_53D1_5355_4F4D_5728_6751_53E3_653E_884C_77E9_5F62_5185(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local rect = jglobals.gg_rct______________077
    if rect == nil or rect == 0 then
        return false
    end
    return RectContainsUnit(rect, unit)
end
local function ____on_7CBE_7075_6751_6751_53E3_653E_884C_89E6_53D1()
    if _____5DF2_89E6_53D1_6751_53E3_653E_884C then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(_____89E6_53D1_5355_4F4D) then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() > 0 then
        return
    end
    if not _____89E6_53D1_5355_4F4D_5728_6751_53E3_653E_884C_77E9_5F62_5185(_____89E6_53D1_5355_4F4D) then
        return
    end
    if _____5199_5165_5E76_64AD_653E_5267_60C5("jlc_elven_village_gate_release", "精灵村村口放行核心", _____89E6_53D1_5355_4F4D) then
        _____5DF2_89E6_53D1_6751_53E3_653E_884C = true
    end
end
local function ____on_7CBE_7075_6751_957F_8001_53D1_5E03_4EFB_52A1_89E6_53D1()
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(_____89E6_53D1_5355_4F4D) then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() >= 1 then
        return
    end
    _____5199_5165_5E76_64AD_653E_5267_60C5("jlc_elven_village_elder_quest", "精灵村长老发布任务核心", _____89E6_53D1_5355_4F4D)
end
local function _____6CE8_518C_77E9_5F62_8FDB_5165(_____77E9_5F62_53D8_91CF_540D, action)
    local rect = jglobals[_____77E9_5F62_53D8_91CF_540D]
    if rect == nil or rect == 0 then
        return
    end
    local trigger = CreateTrigger()
    TriggerRegisterEnterRectSimple(trigger, rect)
    TriggerAddAction(trigger, action)
end
local function _____6CE8_518C_5355_4F4D_8303_56F4(unit, range, action)
    if unit == nil or unit == 0 then
        return
    end
    local trigger = CreateTrigger()
    TriggerRegisterUnitInRangeSimple(trigger, range, unit)
    TriggerAddAction(trigger, action)
end
____exports["初始化进度01_精灵村长老发布任务核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA601_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA601_6838_5FC3 = true
    _____6CE8_518C_5355_4F4D_8303_56F4(
        YDUserDataGetSafe("string", "主线NPC", "自然守护者", "unit"),
        500,
        ____on_7CBE_7075_6751_6751_53E3_653E_884C_89E6_53D1
    )
    _____6CE8_518C_5355_4F4D_8303_56F4(
        YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit"),
        800,
        ____on_7CBE_7075_6751_957F_8001_53D1_5E03_4EFB_52A1_89E6_53D1
    )
end
return ____exports
