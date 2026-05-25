local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__Number = ____lualib.__TS__Number
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local _____53D1_9001_5267_60C5_5C0F_5730_56FE_4FE1_53F7 = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情小地图信号"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
local _____6CE8_518C_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1_5668 = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["注册剧情Boss范围预置触发器"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____6267_884C_901A_7528_5267_60C5_52A8_4F5C = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["执行通用剧情动作"]
local _____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["触发单位增加基础全属性"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitFacingToFaceUnitTimed = ____require_result_0.SetUnitFacingToFaceUnitTimed
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09－YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local YDUserDataClearSafe = ____require_result_1.YDUserDataClearSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_1.YDWEAngleBetweenUnitsSafe
local ____require_result_2 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataClearTable = ____require_result_2.YDUserDataClearTable
local ____require_result_3 = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local DzDoodadCreate = ____require_result_3.DzDoodadCreate
local ____require_result_4 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_4["按名字反查物品ID"]
local ____require_result_5 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_5["按名字反查Boss单位ID"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影")
local GS_PolarProjectionBJ = ____require_result_7.GS_PolarProjectionBJ
local ____require_result_8 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_8.GetRandomDirectionDeg
local ForGroupBJ = ____require_result_8.ForGroupBJ
local ModifyGateBJ = ____require_result_8.ModifyGateBJ
local ____require_result_9 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local SetStackedSoundBJ = ____require_result_9.SetStackedSoundBJ
local ____require_result_10 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitLifePercentBJ = ____require_result_10.SetUnitLifePercentBJ
local ____require_result_11 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_11.EC_CreateEffect
local ____require_result_12 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动")
local _____542F_52A8Boss_6218_8FD0_884C = ____require_result_12["启动Boss战运行"]
local CreateFogModifierRect = jass.CreateFogModifierRect
local CreateItem = jass.CreateItem
local CreateGroup = jass.CreateGroup
local CreateTimer = jass.CreateTimer
local CreatePermanentCorpseLocBJ = jass.CreatePermanentCorpseLocBJ
local CreateUnit = jass.CreateUnit
local DestroyTimer = jass.DestroyTimer
local FogModifierStart = jass.FogModifierStart
local DestroyGroup = jass.DestroyGroup
local FirstOfGroup = jass.FirstOfGroup
local Condition = jass.Condition
local GetExpiredTimer = jass.GetExpiredTimer
local GetPlayersAll = jass.GetPlayersAll
local GetDyingUnit = jass.GetDyingUnit
local GetKillingUnitBJ = jass.GetKillingUnitBJ
local GetUnitFacing = jass.GetUnitFacing
local GetFilterUnit = jass.GetFilterUnit
local GetUnitLoc = jass.GetUnitLoc
local GetUnitsInRectMatching = jass.GetUnitsInRectMatching
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssuePointOrder = jass.IssuePointOrder
local GetRandomInt = jass.GetRandomInt
local Player = jass.Player
local QuestMessageBJ = jass.QuestMessageBJ
local QuestSetDiscovered = jass.QuestSetDiscovered
local RemoveLocation = jass.RemoveLocation
local RemoveRect = jass.RemoveRect
local GroupRemoveUnit = jass.GroupRemoveUnit
local RemoveUnit = jass.RemoveUnit
local CinematicModeBJ = jass.CinematicModeBJ
local CinematicFilterGenericBJ = jass.CinematicFilterGenericBJ
local ShowDestructable = jass.ShowDestructable
local SetUnitFacing = jass.SetUnitFacing
local SetUnitFacingTimed = jass.SetUnitFacingTimed
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitPosition = jass.SetUnitPosition
local SetUnitOwner = jass.SetUnitOwner
local SetTimeOfDay = jass.SetTimeOfDay
local PauseUnit = jass.PauseUnit
local UnitSuspendDecay = jass.UnitSuspendDecay
local GetEnumUnit = jass.GetEnumUnit
local TimerStart = jass.TimerStart
local FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local bj_GATEOPERATION_OPEN = require("jass.globals").bj_GATEOPERATION_OPEN
local bj_CORPSETYPE_BONE = require("jass.globals").bj_CORPSETYPE_BONE
local bj_QUESTMESSAGE_ITEMACQUIRED = require("jass.globals").bj_QUESTMESSAGE_ITEMACQUIRED
local bj_QUESTMESSAGE_UPDATED = require("jass.globals").bj_QUESTMESSAGE_UPDATED
local _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001X = 0
local _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001Y = 0
local function _____8BFB_53D6_957F_8001_5355_4F4D()
    return YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
end
local function ____on_5730_7CBE_6B7B_4EA1_6F14_51FA_79FB_52A8_82F1_96C4()
    local unit = GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    SetUnitPosition(unit, _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001X, _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001Y)
end
local function _____662F_81EA_7136_5B88_62A4_8005()
    local unit = GetFilterUnit()
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == stringToFourCCSafe("etrp")
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
    local rectHandle = require("jass.globals")[rectVarName]
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
local function _____6267_884C_957F_8001_4EFB_52A1_7269_54C1_751F_6210(_____53C2_6570)
    local _____957F_8001_5355_4F4D = _____8BFB_53D6_957F_8001_5355_4F4D()
    if _____957F_8001_5355_4F4D == nil or _____957F_8001_5355_4F4D == 0 then
        return
    end
    local ____5206_5272_540D_79F0_5217_8868_14 = _____5206_5272_540D_79F0_5217_8868
    local ____53C2_6570__7269_54C1_540D_5217_8868_13 = _____53C2_6570["物品名列表"]
    if ____53C2_6570__7269_54C1_540D_5217_8868_13 == nil then
        ____53C2_6570__7269_54C1_540D_5217_8868_13 = ""
    end
    local _____7269_54C1_540D_5217_8868 = ____5206_5272_540D_79F0_5217_8868_14(tostring(____53C2_6570__7269_54C1_540D_5217_8868_13))
    local x = GetUnitX(_____957F_8001_5355_4F4D)
    local y = GetUnitY(_____957F_8001_5355_4F4D)
    do
        local i = 0
        while i < #_____7269_54C1_540D_5217_8868 do
            do
                local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D_5217_8868[i + 1])
                local itemTypeId = stringToFourCCSafe(rawId)
                if not (itemTypeId > 0) then
                    goto __continue18
                end
                CreateItem(itemTypeId, x, y)
            end
            ::__continue18::
            i = i + 1
        end
    end
end
local function _____6267_884C_957F_8001_4EFB_52A1_66F4_65B0(_____53C2_6570)
    _____53D1_9001_5267_60C5_5C0F_5730_56FE_4FE1_53F7({
        X = __TS__Number(_____53C2_6570["小地图X"]) or 0,
        Y = __TS__Number(_____53C2_6570["小地图Y"]) or 0,
        ["持续时间"] = __TS__Number(_____53C2_6570["小地图持续时间"]) or 0
    })
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_16 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_15 = _____53C2_6570["任务更新提示"]
    if ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_15 == nil then
        ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_15 = ""
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_16({
        ["消息类型"] = bj_QUESTMESSAGE_UPDATED,
        ["文本"] = tostring(____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_15)
    })
end
local function _____6267_884C_5730_7CBE_533A_57DF_663E_89C6_91CE(_____53C2_6570)
    local ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_18 = _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE
    local ____53C2_6570__53EF_89C1_533A_57DF1_17 = _____53C2_6570["可见区域1"]
    if ____53C2_6570__53EF_89C1_533A_57DF1_17 == nil then
        ____53C2_6570__53EF_89C1_533A_57DF1_17 = ""
    end
    ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_18(tostring(____53C2_6570__53EF_89C1_533A_57DF1_17))
    local ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_20 = _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE
    local ____53C2_6570__53EF_89C1_533A_57DF2_19 = _____53C2_6570["可见区域2"]
    if ____53C2_6570__53EF_89C1_533A_57DF2_19 == nil then
        ____53C2_6570__53EF_89C1_533A_57DF2_19 = ""
    end
    ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_20(tostring(____53C2_6570__53EF_89C1_533A_57DF2_19))
end
local function _____6267_884C_5730_7CBE_796D_7940Boss_9884_5907(_____53C2_6570)
    local ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_32 = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E
    local ____53C2_6570_Boss_952E_21 = _____53C2_6570["Boss键"]
    if ____53C2_6570_Boss_952E_21 == nil then
        ____53C2_6570_Boss_952E_21 = ""
    end
    local ____tostring_result_24 = tostring(____53C2_6570_Boss_952E_21)
    local ____53C2_6570_Boss_540D_22 = _____53C2_6570["Boss名"]
    if ____53C2_6570_Boss_540D_22 == nil then
        ____53C2_6570_Boss_540D_22 = ""
    end
    local ____tostring_result_25 = tostring(____53C2_6570_Boss_540D_22)
    local ____temp_26 = __TS__Number(_____53C2_6570.X) or 0
    local ____temp_27 = __TS__Number(_____53C2_6570.Y) or 0
    local ____temp_28 = __TS__Number(_____53C2_6570["朝向"]) or 0
    local ____temp_29 = __TS__Number(_____53C2_6570["注册范围"]) or 0
    local ____temp_30 = _____53C2_6570["预创建后暂停"] == true
    local ____temp_31 = _____53C2_6570["预创建后无敌"] == true
    local ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_23 = _____53C2_6570["范围触发配置名"]
    if ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_23 == nil then
        ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_23 = "地精祭祀范围预置触发"
    end
    ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_32({
        ["Boss键"] = ____tostring_result_24,
        ["Boss名"] = ____tostring_result_25,
        X = ____temp_26,
        Y = ____temp_27,
        ["朝向"] = ____temp_28,
        ["注册范围"] = ____temp_29,
        ["预创建后暂停"] = ____temp_30,
        ["预创建后无敌"] = ____temp_31,
        ["范围触发配置名"] = tostring(____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_23),
        ["范围触发剧情片段ID"] = type(_____53C2_6570["范围触发剧情片段ID"]) == "string" and _____53C2_6570["范围触发剧情片段ID"] or nil
    })
end
local function _____521B_5EFA_6B8B_8840_5730_7CBE_5DEB_5E08()
    local bossRawId = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID("地精祭祀|cffff0000（BossLV12）|r")
    local bossTypeId = stringToFourCCSafe(bossRawId)
    if not (bossTypeId > 0) then
        return nil
    end
    local _____6B8B_8840_5730_7CBE = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        bossTypeId,
        -25996.8,
        -13787.8,
        270
    )
    if _____6B8B_8840_5730_7CBE == nil or _____6B8B_8840_5730_7CBE == 0 then
        return nil
    end
    SetUnitInvulnerable(_____6B8B_8840_5730_7CBE, true)
    SetUnitLifePercentBJ(_____6B8B_8840_5730_7CBE, 10)
    return _____6B8B_8840_5730_7CBE
end
local function _____521B_5EFA_5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_6F14_51FA(_____6B8B_8840_5730_7CBE)
    local _____795E_79D8_4EBA_5355_4F4DID = stringToFourCCSafe("n05H")
    if not (_____795E_79D8_4EBA_5355_4F4DID > 0) then
        return
    end
    local _____795E_79D8_4EBA = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____795E_79D8_4EBA_5355_4F4DID,
        -26467.8,
        -13505.7,
        315
    )
    if _____795E_79D8_4EBA == nil or _____795E_79D8_4EBA == 0 then
        return
    end
    EC_CreateEffect(
        "war3mapImported\\blackhole.mdx",
        GetUnitX(_____795E_79D8_4EBA),
        GetUnitY(_____795E_79D8_4EBA),
        0,
        270,
        3,
        1,
        4
    )
    IssuePointOrder(_____795E_79D8_4EBA, "move", -26296.4, -13702.4)
    if _____6B8B_8840_5730_7CBE ~= nil and _____6B8B_8840_5730_7CBE ~= 0 then
        SetUnitFacing(
            _____795E_79D8_4EBA,
            YDWEAngleBetweenUnitsSafe(_____795E_79D8_4EBA, _____6B8B_8840_5730_7CBE)
        )
        EC_CreateEffect(
            "war3mapImported\\Eraser.mdx",
            GetUnitX(_____6B8B_8840_5730_7CBE),
            GetUnitY(_____6B8B_8840_5730_7CBE),
            0,
            270,
            2.2,
            1,
            2
        )
    end
    EC_CreateEffect(
        "war3mapImported\\blackhole.mdx",
        GetUnitX(_____795E_79D8_4EBA),
        GetUnitY(_____795E_79D8_4EBA),
        0,
        270,
        3,
        1,
        4
    )
    SetUnitFacing(_____795E_79D8_4EBA, 270)
end
local function _____6267_884C_5730_7CBE_796D_7940_6B7B_4EA1_6F14_51FA_524D_7F6E(_____53C2_6570)
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or 4)
    local gate = require("jass.globals").gg_dest_DTg5_9811
    if gate ~= nil and gate ~= 0 then
        ModifyGateBJ(bj_GATEOPERATION_OPEN, gate)
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001X = -26078.9
        _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001Y = -14330.5
        ForGroupBJ(_____73A9_5BB6_82F1_96C4_7EC4, ____on_5730_7CBE_6B7B_4EA1_6F14_51FA_79FB_52A8_82F1_96C4)
    end
    local _____6B8B_8840_5730_7CBE = _____521B_5EFA_6B8B_8840_5730_7CBE_5DEB_5E08()
    local bossUnit = YDUserDataGetSafe("string", "Boss", "地精巫师", "unit")
    YDUserDataClearSafe("string", "Boss", "地精巫师", "unit")
    if bossUnit ~= nil and bossUnit ~= 0 then
        YDUserDataClearTable("unit", bossUnit)
    end
    _____521B_5EFA_5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_6F14_51FA(_____6B8B_8840_5730_7CBE)
end
local function _____6267_884C_6559_6D3EBoss_968F_673A_59FF_6001(_____53C2_6570)
    local roll = GetRandomInt(1, 2)
    local ____temp_35
    if roll == 1 then
        local ____53C2_6570__5251_58EB_59FF_6001Boss_540D_33 = _____53C2_6570["剑士姿态Boss名"]
        if ____53C2_6570__5251_58EB_59FF_6001Boss_540D_33 == nil then
            ____53C2_6570__5251_58EB_59FF_6001Boss_540D_33 = "教派剑士"
        end
        ____temp_35 = tostring(____53C2_6570__5251_58EB_59FF_6001Boss_540D_33)
    else
        local ____53C2_6570__5B66_8005_59FF_6001Boss_540D_34 = _____53C2_6570["学者姿态Boss名"]
        if ____53C2_6570__5B66_8005_59FF_6001Boss_540D_34 == nil then
            ____53C2_6570__5B66_8005_59FF_6001Boss_540D_34 = "教派学者"
        end
        ____temp_35 = tostring(____53C2_6570__5B66_8005_59FF_6001Boss_540D_34)
    end
    local ____boss_540D = ____temp_35
    local ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_37 = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E
    local ____53C2_6570_Boss_952E_36 = _____53C2_6570["Boss键"]
    if ____53C2_6570_Boss_952E_36 == nil then
        ____53C2_6570_Boss_952E_36 = "Boss.蒙面人"
    end
    ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_37({
        ["Boss键"] = tostring(____53C2_6570_Boss_952E_36),
        ["Boss名"] = ____boss_540D,
        X = __TS__Number(_____53C2_6570["出生X"]) or 0,
        Y = __TS__Number(_____53C2_6570["出生Y"]) or 0,
        ["朝向"] = __TS__Number(_____53C2_6570["朝向"]) or 0,
        ["预创建后暂停"] = true,
        ["预创建后无敌"] = true
    })
end
local function _____521B_5EFA_6C99_6F20_98DF_4EBA_9B54_5C38_9AA8_5708(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    local _____6B65_5175_5355_4F4DID = stringToFourCCSafe("hfoo")
    if not (_____6B65_5175_5355_4F4DID > 0) then
        return
    end
    do
        local i = 1
        while i <= 6 do
            local sourceLoc = GetUnitLoc(bossUnit)
            local corpseLoc = GS_PolarProjectionBJ(sourceLoc, 150, 60 * i)
            if corpseLoc ~= nil and corpseLoc ~= 0 then
                CreatePermanentCorpseLocBJ(
                    bj_CORPSETYPE_BONE,
                    _____6B65_5175_5355_4F4DID,
                    Player(PLAYER_NEUTRAL_PASSIVE),
                    corpseLoc,
                    GetRandomDirectionDeg()
                )
                RemoveLocation(corpseLoc)
            end
            i = i + 1
        end
    end
end
local function _____6267_884C_86C7_4EBA_65CF_63A5_53D7_98DF_4EBA_9B54_4EFB_52A1(_____53C2_6570)
    local _____6B21_5143_88C2_7F1D_5355_4F4DID = stringToFourCCSafe("e08L")
    if _____6B21_5143_88C2_7F1D_5355_4F4DID > 0 then
        local _____88C2_7F1D_5355_4F4D = CreateUnit(
            Player(PLAYER_NEUTRAL_PASSIVE),
            _____6B21_5143_88C2_7F1D_5355_4F4DID,
            -20606.8,
            2780.5,
            0
        )
        if _____88C2_7F1D_5355_4F4D ~= nil and _____88C2_7F1D_5355_4F4D ~= 0 then
            YDUserDataSetSafe(
                "string",
                "剧情",
                "沙漠次元裂缝",
                "unit",
                _____88C2_7F1D_5355_4F4D
            )
        end
    end
    local bossRawId = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID("沙漠食人魔")
    local bossTypeId = stringToFourCCSafe(bossRawId)
    if not (bossTypeId > 0) then
        return
    end
    local bossUnit = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        bossTypeId,
        28354.9,
        13678.3,
        270
    )
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss",
        "沙漠食人魔",
        "unit",
        bossUnit
    )
    SetUnitInvulnerable(bossUnit, true)
    PauseUnit(bossUnit, true)
    _____6CE8_518C_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1_5668(
        bossUnit,
        __TS__Number(_____53C2_6570["注册范围"]) or 850,
        "沙漠食人魔Boss启动",
        "jlc_desert_ogre_boss_start",
        "Boss.沙漠食人魔",
        10
    )
    _____521B_5EFA_6C99_6F20_98DF_4EBA_9B54_5C38_9AA8_5708(bossUnit)
end
local function _____6267_884C_957F_8001_5BF9_8BDD_524D_7F6E(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    local _____89E6_53D1_5355_4F4D = _____4E0A_4E0B_6587["触发单位"]
    local _____957F_8001_5355_4F4D = _____8BFB_53D6_957F_8001_5355_4F4D()
    if type(_____53C2_6570["设置剧情进度"]) == "number" then
        _____5199_5165_5267_60C5_8FDB_5EA6(_____53C2_6570["设置剧情进度"])
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
    end
    if _____957F_8001_5355_4F4D ~= nil and _____957F_8001_5355_4F4D ~= 0 then
        if type(_____53C2_6570["长老归属玩家"]) == "number" then
            SetUnitOwner(
                _____957F_8001_5355_4F4D,
                Player(_____53C2_6570["长老归属玩家"]),
                true
            )
        end
        if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
            local angle = YDWEAngleBetweenUnitsSafe(_____957F_8001_5355_4F4D, _____89E6_53D1_5355_4F4D)
            SetUnitFacingTimed(
                _____957F_8001_5355_4F4D,
                angle,
                __TS__Number(_____53C2_6570["长老转向耗时"]) or 0
            )
        end
    end
end
local function _____6267_884C_8FDC_53E4_6CE2_52A8_5956_52B1(_____53C2_6570)
    local _____5956_52B1_503C = __TS__Number(_____53C2_6570["力量"]) or __TS__Number(_____53C2_6570["全属性"]) or 3
    local ____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027_39 = _____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027
    local ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_38 = _____53C2_6570["任务消息模板"]
    if ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_38 == nil then
        ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_38 = "{英雄名}受到了远古波动！（|cffff99cc全属性+{value}|r）"
    end
    ____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027_39(
        _____5956_52B1_503C,
        tostring(____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_38)
    )
end
local function _____79FB_9664_5E76_6E05_7406_8BED_4E49_5355_4F4D_5F15_7528(_____5F15_7528)
    if _____5F15_7528 == "" then
        return
    end
    local unit = YDUserDataGetSafe(
        "string",
        __TS__StringIncludes(_____5F15_7528, ".") and __TS__StringSplit(_____5F15_7528, ".")[1] or "剧情",
        __TS__StringIncludes(_____5F15_7528, ".") and (__TS__StringSplit(_____5F15_7528, ".")[2] or "") or _____5F15_7528,
        "unit"
    )
    if unit ~= nil and unit ~= 0 then
        RemoveUnit(unit)
    end
    local dot = (string.find(_____5F15_7528, ".", nil, true) or 0) - 1
    if dot >= 0 then
        YDUserDataClearTable(
            "string",
            __TS__StringSubstring(_____5F15_7528, 0, dot)
        )
    end
end
local function _____6E05_7406_9017_53F7_5206_9694_8BED_4E49_5355_4F4D(refs)
    if refs == "" then
        return
    end
    local _____5217_8868 = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(refs, ","),
            function(____, item) return __TS__StringTrim(item) end
        ),
        function(____, item) return #item > 0 end
    )
    do
        local i = 0
        while i < #_____5217_8868 do
            _____79FB_9664_5E76_6E05_7406_8BED_4E49_5355_4F4D_5F15_7528(_____5217_8868[i + 1])
            i = i + 1
        end
    end
end
local function _____6267_884C_6C99_6F20_60C5_62A5_5546_4EBA_56DE_6536_591C_5149_7FE1_7FE0(_____53C2_6570)
    local ____53C2_6570__79FB_9664_4E34_65F6_5355_4F4D_40 = _____53C2_6570["移除临时单位"]
    if ____53C2_6570__79FB_9664_4E34_65F6_5355_4F4D_40 == nil then
        ____53C2_6570__79FB_9664_4E34_65F6_5355_4F4D_40 = ""
    end
    local oldGuardRefs = tostring(____53C2_6570__79FB_9664_4E34_65F6_5355_4F4D_40)
    _____6E05_7406_9017_53F7_5206_9694_8BED_4E49_5355_4F4D(oldGuardRefs)
    local riftRawId = stringToFourCCSafe("e06W")
    if riftRawId > 0 then
        local riftA = CreateUnit(
            Player(PLAYER_NEUTRAL_PASSIVE),
            riftRawId,
            -27182.1,
            -25485.2,
            0
        )
        local riftB = CreateUnit(
            Player(PLAYER_NEUTRAL_PASSIVE),
            riftRawId,
            -24123.4,
            -26338.8,
            0
        )
        if riftA ~= nil and riftA ~= 0 then
            YDUserDataSetSafe(
                "string",
                "ZXCS",
                "DW",
                "unit",
                riftA
            )
        end
        if riftB ~= nil and riftB ~= 0 then
            YDUserDataSetSafe(
                "string",
                "ZXCS2",
                "DW",
                "unit",
                riftB
            )
        end
    end
end
local function _____6267_884C_86C7_4EBA_65CF_4EA4_8FD8_98DF_4EBA_9B54_51ED_8BC1(_____53C2_6570)
    local rawId = stringToFourCCSafe("h01D")
    if not (rawId > 0) then
        return
    end
    local _____961F_957F = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        rawId,
        -22935.9,
        3154.3,
        0
    )
    if _____961F_957F == nil or _____961F_957F == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "主线NPC",
        "蛇人族卫队长",
        "unit",
        _____961F_957F
    )
    IssuePointOrder(_____961F_957F, "move", -21023.4, 3259.5)
end
local function _____6267_884C_514B_6797_59C6_5FB7_738B_63A5_89C1(_____53C2_6570)
    local rawId = stringToFourCCSafe("ohun")
    if not (rawId > 0) then
        return
    end
    local _____730E_9B42 = CreateUnit(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        rawId,
        -2823.1,
        -14119.8,
        180
    )
    if _____730E_9B42 == nil or _____730E_9B42 == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "jq",
        "npc",
        "unit",
        _____730E_9B42
    )
end
local function _____6267_884C_7CBE_7075_6751_6559_6D3E_88AD_51FB_9884_7F6E(_____53C2_6570)
    local _____795E_79D8_4EBAID = stringToFourCCSafe("n05H")
    local _____7CBE_7075_62A4_536BID = stringToFourCCSafe("nhef")
    local _____7CBE_7075_5B88_536BID = stringToFourCCSafe("n01H")
    if not (_____795E_79D8_4EBAID > 0) or not (_____7CBE_7075_62A4_536BID > 0) or not (_____7CBE_7075_5B88_536BID > 0) then
        return
    end
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____795E_79D8_4EBAID,
        -26755.1,
        -28618.6,
        0
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_62A4_536BID,
        -25907.1,
        -28413,
        178
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_62A4_536BID,
        -25888.1,
        -28937.1,
        185.47
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_5B88_536BID,
        -26119.9,
        -28926.5,
        123.7
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_5B88_536BID,
        -25965.7,
        -29021.4,
        180
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_5B88_536BID,
        -26065.8,
        -28460.5,
        180
    )
    local _____6811_6728_5750_6807 = {
        {-27676.5, -26406},
        {-27008.7, -26384.5},
        {-26437.1, -27038.1},
        {-27524.2, -27604.2},
        {-27404.8, -28326.7},
        {-26557.1, -28108.3},
        {-24975.3, -28808.4},
        {-25385.3, -27834.4},
        {-23911.9, -29142.2},
        {-22237.8, -28776.7},
        {-22255.9, -28312.7},
        {-24574.1, -27746.7},
        {-23911.9, -29142.2},
        {-23963.1, -27718},
        {-23632, -27698.7},
        {-25487.6, -26993.6},
        {-24839.6, -26980.8},
        {-23963.1, -27718},
        {-24464.3, -26590.1},
        {-23681.3, -26604.5},
        {-23665.1, -27128.5}
    }
    do
        local i = 0
        while i < #_____6811_6728_5750_6807 do
            local point = _____6811_6728_5750_6807[i + 1]
            DzDoodadCreate(
                nil,
                stringToFourCCSafe("YOtf"),
                1,
                point[1],
                point[2],
                0,
                GetRandomDirectionDeg(),
                1
            )
            i = i + 1
        end
    end
end
local function _____6267_884C_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1(_____53C2_6570)
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    UnitSuspendDecay(dyingUnit, true)
    local x = GetUnitX(dyingUnit)
    local y = GetUnitY(dyingUnit)
    local riftRawId = stringToFourCCSafe("e08M")
    local riftUnit = nil
    if riftRawId > 0 then
        riftUnit = CreateUnit(
            Player(PLAYER_NEUTRAL_PASSIVE),
            riftRawId,
            27531.2,
            13562.4,
            0
        )
    end
    local lizardRawId = stringToFourCCSafe("h01I")
    if lizardRawId > 0 and riftUnit ~= nil and riftUnit ~= 0 then
        local angle = YDWEAngleBetweenUnitsSafe(riftUnit, dyingUnit)
        local lizard = CreateUnit(
            Player(PLAYER_NEUTRAL_PASSIVE),
            lizardRawId,
            27531.2,
            13562.4,
            angle
        )
        if lizard ~= nil and lizard ~= 0 then
            IssuePointOrder(
                lizard,
                "move",
                GetUnitX(riftUnit) + 150,
                GetUnitY(riftUnit)
            )
            IssueImmediateOrder(lizard, "holdposition")
        end
    end
    local bossRawId = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID("杀戮食人魔")
    local bossTypeId = stringToFourCCSafe(bossRawId)
    if not (bossTypeId > 0) then
        return
    end
    local bossUnit = CreateUnit(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        bossTypeId,
        x,
        y,
        270
    )
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss",
        "杀戮食人魔",
        "unit",
        bossUnit
    )
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        bossUnit
    )
    PauseUnit(bossUnit, true)
    SetUnitInvulnerable(bossUnit, true)
    _____542F_52A8Boss_6218_8FD0_884C(bossUnit)
end
local function _____6267_884C_8499_9762_4EBA_6B7B_4EA1(_____53C2_6570)
    __TS__Delete(_____53C2_6570, "奖励物品名")
    __TS__Delete(_____53C2_6570, "停止区域音乐")
    __TS__Delete(_____53C2_6570, "恢复环境音乐")
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local dyingTypeId = GetUnitTypeId(dyingUnit)
    if dyingTypeId ~= stringToFourCCSafe("N05N") and dyingTypeId ~= stringToFourCCSafe("N05M") then
        return
    end
    local _____7236_7C7B_8FDB_5EA6 = __TS__Number(_____53C2_6570["设置剧情进度"]) or __TS__Number(_____53C2_6570["目标进度"]) or 18
    _____5199_5165_5267_60C5_8FDB_5EA6(_____7236_7C7B_8FDB_5EA6)
    UnitSuspendDecay(dyingUnit, true)
    local bossUnit = dyingUnit
    YDUserDataClearSafe(
        "string",
        "Boss",
        dyingTypeId == stringToFourCCSafe("N05M") and "教派学者" or "教派剑士",
        "unit"
    )
    YDUserDataClearTable("unit", bossUnit)
    local _____65CF_957F = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
    if _____65CF_957F ~= nil and _____65CF_957F ~= 0 then
        SetUnitPosition(
            _____65CF_957F,
            __TS__Number(_____53C2_6570["族长新位置X"]) or 28775.2,
            __TS__Number(_____53C2_6570["族长新位置Y"]) or -28660.2
        )
    end
end
local function _____6267_884C_6751_53E3_653E_884C_524D_7F6E(_____53C2_6570)
    local ____53C2_6570__95E8_7981_77E9_5F62_41 = _____53C2_6570["门禁矩形"]
    if ____53C2_6570__95E8_7981_77E9_5F62_41 == nil then
        ____53C2_6570__95E8_7981_77E9_5F62_41 = ""
    end
    local _____95E8_7981_77E9_5F62 = tostring(____53C2_6570__95E8_7981_77E9_5F62_41)
    if _____95E8_7981_77E9_5F62 ~= "" then
        local rectHandle = require("jass.globals")[_____95E8_7981_77E9_5F62]
        local _____95E8_536B_7EC4 = GetUnitsInRectMatching(
            rectHandle,
            Condition(_____662F_81EA_7136_5B88_62A4_8005)
        )
        if _____95E8_536B_7EC4 ~= nil and _____95E8_536B_7EC4 ~= 0 then
            local unit = FirstOfGroup(_____95E8_536B_7EC4)
            while unit ~= nil and unit ~= 0 do
                IssueImmediateOrder(unit, "stop")
                GroupRemoveUnit(_____95E8_536B_7EC4, unit)
                unit = FirstOfGroup(_____95E8_536B_7EC4)
            end
            DestroyGroup(_____95E8_536B_7EC4)
        end
        if rectHandle ~= nil and rectHandle ~= 0 then
            RemoveRect(rectHandle)
        end
    end
end
local function _____6267_884C_5730_7CBE_6D1E_7A9F_6F14_51FA_524D_7F6E(_____53C2_6570)
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or 2)
    CinematicModeBJ(
        true,
        GetPlayersAll()
    )
    SetTimeOfDay(0)
    CinematicFilterGenericBJ(
        2,
        1,
        "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
        50,
        50,
        50,
        50,
        0,
        0,
        0,
        0
    )
end
local function _____6267_884C_5730_7CBE_796D_7940Boss_6218_6B63_5F0F_6CE8_518C(_____53C2_6570)
    local ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_45 = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E
    local ____53C2_6570_Boss_952E_42 = _____53C2_6570["Boss键"]
    if ____53C2_6570_Boss_952E_42 == nil then
        ____53C2_6570_Boss_952E_42 = ""
    end
    local ____tostring_result_44 = tostring(____53C2_6570_Boss_952E_42)
    local ____53C2_6570_Boss_540D_43 = _____53C2_6570["Boss名"]
    if ____53C2_6570_Boss_540D_43 == nil then
        ____53C2_6570_Boss_540D_43 = "地精巫师"
    end
    ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_45({
        ["Boss键"] = ____tostring_result_44,
        ["Boss名"] = tostring(____53C2_6570_Boss_540D_43),
        X = __TS__Number(_____53C2_6570.X) or -26032.4,
        Y = __TS__Number(_____53C2_6570.Y) or -13789.5,
        ["朝向"] = __TS__Number(_____53C2_6570["朝向"]) or 270,
        ["注册范围"] = __TS__Number(_____53C2_6570["注册范围"]) or 750,
        ["预创建后暂停"] = true,
        ["预创建后无敌"] = true
    })
end
local function _____6267_884C_51FB_8D25_5730_7CBE_56DE_6751_524D_7F6E(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    local _____89E6_53D1_5355_4F4D = _____4E0A_4E0B_6587["触发单位"]
    local _____957F_8001_5355_4F4D = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
    end
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and _____957F_8001_5355_4F4D ~= nil and _____957F_8001_5355_4F4D ~= 0 then
        SetUnitFacingToFaceUnitTimed(
            _____89E6_53D1_5355_4F4D,
            _____957F_8001_5355_4F4D,
            __TS__Number(_____53C2_6570["触发单位转向耗时"]) or 1
        )
        SetUnitFacingTimed(
            _____957F_8001_5355_4F4D,
            YDWEAngleBetweenUnitsSafe(_____957F_8001_5355_4F4D, _____89E6_53D1_5355_4F4D),
            __TS__Number(_____53C2_6570["长老转向耗时"]) or 1
        )
    end
end
local function _____6267_884C_738B_57CE_95E8_7981_5F00_542F(_____53C2_6570)
    local _____5EF6_8FDF_79D2_6570 = __TS__Number(_____53C2_6570["延迟开门秒"]) or 0
    local ____53C2_6570__5F00_95E8_5BF9_8C61_46 = _____53C2_6570["开门对象"]
    if ____53C2_6570__5F00_95E8_5BF9_8C61_46 == nil then
        ____53C2_6570__5F00_95E8_5BF9_8C61_46 = ""
    end
    local _____5F00_95E8_5BF9_8C61 = tostring(____53C2_6570__5F00_95E8_5BF9_8C61_46)
    local ____53C2_6570__9690_85CF_963B_6321_47 = _____53C2_6570["隐藏阻挡"]
    if ____53C2_6570__9690_85CF_963B_6321_47 == nil then
        ____53C2_6570__9690_85CF_963B_6321_47 = ""
    end
    local _____9690_85CF_963B_6321 = tostring(____53C2_6570__9690_85CF_963B_6321_47)
    local function _____6267_884C_5F00_95E8()
        if _____5F00_95E8_5BF9_8C61 ~= "" then
            local destructable = require("jass.globals")[_____5F00_95E8_5BF9_8C61]
            if destructable ~= nil and destructable ~= 0 then
                ModifyGateBJ(bj_GATEOPERATION_OPEN, destructable)
            end
        end
        if _____9690_85CF_963B_6321 ~= "" then
            local hidden = require("jass.globals")[_____9690_85CF_963B_6321]
            if hidden ~= nil and hidden ~= 0 then
                ShowDestructable(hidden, false)
            end
        end
    end
    if _____5EF6_8FDF_79D2_6570 > 0 then
        local timer = CreateTimer()
        TimerStart(
            timer,
            _____5EF6_8FDF_79D2_6570,
            false,
            function()
                _____6267_884C_5F00_95E8()
                DestroyTimer(GetExpiredTimer())
            end
        )
        return
    end
    _____6267_884C_5F00_95E8()
end
local function _____6267_884C_738B_5BAB_95E8_536B_652F_7EBF_53D1_73B0()
    local ____opt_48 = require("jass.globals").udg_RW
    if ____opt_48 ~= nil then
        ____opt_48 = ____opt_48[8]
    end
    local quest = ____opt_48
    if quest ~= nil and quest ~= 0 then
        QuestSetDiscovered(quest, true)
    end
end
local function _____6267_884C_730E_9B42_8BD5_63A2()
    local npc = YDUserDataGetSafe("string", "jq", "npc", "unit")
    if npc ~= nil and npc ~= 0 then
        SetUnitInvulnerable(npc, false)
        PauseUnit(npc, false)
    end
    YDUserDataClearSafe("string", "jq", "npc", "unit")
end
local function _____6267_884C_6811_9B54_9996_9886_6B7B_4EA1(_____53C2_6570)
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    YDUserDataClearSafe("string", "Boss", "树魔首领", "unit")
    YDUserDataClearTable("unit", dyingUnit)
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or 28)
end
local _____4E3B_7EBF_5267_60C5_52A8_4F5C_6CE8_518C_8868 = {
    ["JLC精灵村_长老对话前置"] = _____6267_884C_957F_8001_5BF9_8BDD_524D_7F6E,
    ["JLC精灵村_长老任务物品生成"] = _____6267_884C_957F_8001_4EFB_52A1_7269_54C1_751F_6210,
    ["JLC精灵村_发布地精任务"] = _____6267_884C_957F_8001_4EFB_52A1_66F4_65B0,
    ["JLC精灵村_地精区域显视野"] = _____6267_884C_5730_7CBE_533A_57DF_663E_89C6_91CE,
    ["JLC精灵村_创建地精祭祀Boss预备"] = _____6267_884C_5730_7CBE_796D_7940Boss_9884_5907,
    ["JLC精灵村_地精祭祀死亡演出前置"] = _____6267_884C_5730_7CBE_796D_7940_6B7B_4EA1_6F14_51FA_524D_7F6E,
    ["JLC精灵村_教派袭击预置"] = _____6267_884C_7CBE_7075_6751_6559_6D3E_88AD_51FB_9884_7F6E,
    ["JLC精灵村_教派Boss随机姿态"] = _____6267_884C_6559_6D3EBoss_968F_673A_59FF_6001,
    ["JLC精灵村_远古波动奖励"] = _____6267_884C_8FDC_53E4_6CE2_52A8_5956_52B1,
    ["JLC沙漠_情报商人回收夜光翡翠"] = _____6267_884C_6C99_6F20_60C5_62A5_5546_4EBA_56DE_6536_591C_5149_7FE1_7FE0,
    ["SRZ蛇人族_交还食人魔凭证"] = _____6267_884C_86C7_4EBA_65CF_4EA4_8FD8_98DF_4EBA_9B54_51ED_8BC1,
    ["SRZ蛇人族_接受食人魔任务"] = _____6267_884C_86C7_4EBA_65CF_63A5_53D7_98DF_4EBA_9B54_4EFB_52A1,
    ["JLC精灵城_克林姆德王接见"] = _____6267_884C_514B_6797_59C6_5FB7_738B_63A5_89C1,
    ["SW01死亡事件_沙漠食人魔一阶段死亡"] = _____6267_884C_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1,
    ["SW01死亡事件_蒙面人死亡"] = _____6267_884C_8499_9762_4EBA_6B7B_4EA1
}
____exports["查找主线剧情动作处理器"] = function(_____52A8_4F5CID)
    return _____4E3B_7EBF_5267_60C5_52A8_4F5C_6CE8_518C_8868[_____52A8_4F5CID]
end
____exports["执行主线剧情动作"] = function(_____52A8_4F5CID, _____53C2_6570)
    local handler = ____exports["查找主线剧情动作处理器"](_____52A8_4F5CID)
    if handler == nil then
        _____6267_884C_901A_7528_5267_60C5_52A8_4F5C(_____53C2_6570)
        return
    end
    handler(_____53C2_6570)
    _____6267_884C_901A_7528_5267_60C5_52A8_4F5C(_____53C2_6570)
end
__TS__ObjectAssign(_____4E3B_7EBF_5267_60C5_52A8_4F5C_6CE8_518C_8868, {
    ["JLC精灵村_村口放行前置"] = _____6267_884C_6751_53E3_653E_884C_524D_7F6E,
    ["JLC精灵村_地精洞窟演出前置"] = _____6267_884C_5730_7CBE_6D1E_7A9F_6F14_51FA_524D_7F6E,
    ["JLC精灵村_地精祭祀Boss战正式注册"] = _____6267_884C_5730_7CBE_796D_7940Boss_6218_6B63_5F0F_6CE8_518C,
    ["JLC精灵村_击败地精回村前置"] = _____6267_884C_51FB_8D25_5730_7CBE_56DE_6751_524D_7F6E,
    ["JLC精灵城_王城门禁开启"] = _____6267_884C_738B_57CE_95E8_7981_5F00_542F,
    ["JLC精灵城_王宫门卫2支线发现"] = _____6267_884C_738B_5BAB_95E8_536B_652F_7EBF_53D1_73B0,
    ["JLC精灵城_猎魂试探"] = _____6267_884C_730E_9B42_8BD5_63A2,
    ["SW01死亡事件_树魔首领死亡"] = _____6267_884C_6811_9B54_9996_9886_6B7B_4EA1
})
return ____exports
