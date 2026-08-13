local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
---
-- @noSelfInFile
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local ____require_result_1 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitFacingToFaceUnitTimed = ____require_result_1.SetUnitFacingToFaceUnitTimed
local ModifyHeroStat = ____require_result_1.ModifyHeroStat
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
local ForGroupBJ = ____require_result_2.ForGroupBJ
local GetPlayersAll = ____require_result_2.GetPlayersAll
local ____require_result_3 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local RectContainsUnit = ____require_result_3.RectContainsUnit
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_4.registerOneShotUnitRangeListener
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_5.YDWEAngleBetweenUnitsSafe
local ____require_result_6 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_6["按名字反查物品ID"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local ____require_result_8 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_8["是玩家英雄组单位"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.12．JASS原生别名")
local AddSpecialEffect = ____require_result_9.AddSpecialEffect
local Condition = ____require_result_9.Condition
local CreateFogModifierRect = ____require_result_9.CreateFogModifierRect
local CreateItem = ____require_result_9.CreateItem
local DestroyGroup = ____require_result_9.DestroyGroup
local FirstOfGroup = ____require_result_9.FirstOfGroup
local FogModifierStart = ____require_result_9.FogModifierStart
local FOG_OF_WAR_VISIBLE = ____require_result_9.FOG_OF_WAR_VISIBLE
local GetEnumUnit = ____require_result_9.GetEnumUnit
local GetFilterUnit = ____require_result_9.GetFilterUnit
local GetRandomReal = ____require_result_9.GetRandomReal
local GetUnitTypeId = ____require_result_9.GetUnitTypeId
local GetUnitX = ____require_result_9.GetUnitX
local GetUnitY = ____require_result_9.GetUnitY
local GetUnitsInRectMatching = ____require_result_9.GetUnitsInRectMatching
local GroupRemoveUnit = ____require_result_9.GroupRemoveUnit
local IssueImmediateOrder = ____require_result_9.IssueImmediateOrder
local Player = ____require_result_9.Player
local RemoveRect = ____require_result_9.RemoveRect
local SetUnitFacing = ____require_result_9.SetUnitFacing
local SetUnitFacingTimed = ____require_result_9.SetUnitFacingTimed
local SetUnitOwner = ____require_result_9.SetUnitOwner
local StopMusic = ____require_result_9.StopMusic
local ____require_result_10 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027 = ____require_result_10["触发单位增加基础全属性"]
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5_5B9E_73B0
local function _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, _____4E0A_4E0B_6587)
    if _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5_5B9E_73B0 == nil then
        local _____64AD_653E_5668_6A21_5757 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
        _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5_5B9E_73B0 = _____64AD_653E_5668_6A21_5757["播放主线剧情片段"]
    end
    return _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5_5B9E_73B0(_____7247_6BB5ID, _____4E0A_4E0B_6587)
end
local bj_HEROSTAT_STR = jglobals.bj_HEROSTAT_STR
local bj_HEROSTAT_AGI = jglobals.bj_HEROSTAT_AGI
local bj_HEROSTAT_INT = jglobals.bj_HEROSTAT_INT
local bj_MODIFYMETHOD_ADD = jglobals.bj_MODIFYMETHOD_ADD
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
    local rectHandle = _____83B7_53D6_77E9_5F62_533A_57DF(rectVarName)
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
                    goto __continue15
                end
                FogModifierStart(fogModifier)
            end
            ::__continue15::
            playerId = playerId + 1
        end
    end
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
    local rectHandle = _____83B7_53D6_77E9_5F62_533A_57DF(_____95E8_7981_77E9_5F62)
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
    _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE("精灵村")
    if _____81EA_7136_4F20_9001_95E8 ~= nil and _____81EA_7136_4F20_9001_95E8 ~= 0 then
        SetUnitOwner(
            _____81EA_7136_4F20_9001_95E8,
            Player(6),
            true
        )
    end
    _____521B_5EFA_968F_673A_91D1_5149_6212_6307()
    StopMusic(false)
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
____exports["执行地精区域显视野"] = function(_____53C2_6570)
    local ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_15 = _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE
    local ____53C2_6570__53EF_89C1_533A_57DF1_14 = _____53C2_6570["可见区域1"]
    if ____53C2_6570__53EF_89C1_533A_57DF1_14 == nil then
        ____53C2_6570__53EF_89C1_533A_57DF1_14 = ""
    end
    ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_15(tostring(____53C2_6570__53EF_89C1_533A_57DF1_14))
    local ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_17 = _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE
    local ____53C2_6570__53EF_89C1_533A_57DF2_16 = _____53C2_6570["可见区域2"]
    if ____53C2_6570__53EF_89C1_533A_57DF2_16 == nil then
        ____53C2_6570__53EF_89C1_533A_57DF2_16 = ""
    end
    ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_17(tostring(____53C2_6570__53EF_89C1_533A_57DF2_16))
end
____exports["执行地精祭祀Boss预备"] = function(_____53C2_6570)
    local ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_31 = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E
    local ____53C2_6570_Boss_952E_18 = _____53C2_6570["Boss键"]
    if ____53C2_6570_Boss_952E_18 == nil then
        ____53C2_6570_Boss_952E_18 = "Boss.地精巫师"
    end
    local ____tostring_result_22 = tostring(____53C2_6570_Boss_952E_18)
    local ____53C2_6570_Boss_540D_19 = _____53C2_6570["Boss名"]
    if ____53C2_6570_Boss_540D_19 == nil then
        ____53C2_6570_Boss_540D_19 = "地精祭祀|cffff0000（BossLV12）|r"
    end
    local ____tostring_result_23 = tostring(____53C2_6570_Boss_540D_19)
    local ____temp_24 = __TS__Number(_____53C2_6570.X) or -26032.4
    local ____temp_25 = __TS__Number(_____53C2_6570.Y) or -13789.5
    local ____temp_26 = __TS__Number(_____53C2_6570["朝向"]) or 270
    local ____temp_27 = __TS__Number(_____53C2_6570["注册范围"]) or 0
    local ____temp_28 = _____53C2_6570["预创建后暂停"] == true
    local ____temp_29 = _____53C2_6570["预创建后无敌"] == true
    local ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_20 = _____53C2_6570["范围触发配置名"]
    if ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_20 == nil then
        ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_20 = ""
    end
    local ____temp_30 = tostring(____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_20) or nil
    local ____53C2_6570__8303_56F4_89E6_53D1_5267_60C5_7247_6BB5ID_21 = _____53C2_6570["范围触发剧情片段ID"]
    if ____53C2_6570__8303_56F4_89E6_53D1_5267_60C5_7247_6BB5ID_21 == nil then
        ____53C2_6570__8303_56F4_89E6_53D1_5267_60C5_7247_6BB5ID_21 = ""
    end
    ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_31({
        ["Boss键"] = ____tostring_result_22,
        ["Boss名"] = ____tostring_result_23,
        X = ____temp_24,
        Y = ____temp_25,
        ["朝向"] = ____temp_26,
        ["注册范围"] = ____temp_27,
        ["预创建后暂停"] = ____temp_28,
        ["预创建后无敌"] = ____temp_29,
        ["范围触发配置名"] = ____temp_30,
        ["范围触发剧情片段ID"] = tostring(____53C2_6570__8303_56F4_89E6_53D1_5267_60C5_7247_6BB5ID_21) or nil,
        ["需要剧情进度"] = __TS__Number(_____53C2_6570["触发进度"]) or nil
    })
end
____exports["执行远古波动奖励"] = function(_____53C2_6570)
    local _____5956_52B1_503C = __TS__Number(_____53C2_6570["力量"]) or __TS__Number(_____53C2_6570["全属性"]) or 3
    local ____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027_33 = _____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027
    local ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_32 = _____53C2_6570["任务消息模板"]
    if ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_32 == nil then
        ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_32 = "{英雄名}受到了远古波动！（|cffff99cc全属性+{value}|r）"
    end
    ____89E6_53D1_5355_4F4D_589E_52A0_57FA_7840_5168_5C5E_6027_33(
        _____5956_52B1_503C,
        tostring(____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_32)
    )
end
____exports["精灵村长老发布任务剧情动作注册表"] = {
    ["JLC精灵村_村口放行前置"] = ____exports["执行村口放行前置"],
    ["JLC精灵村_长老对话前置"] = ____exports["执行长老对话前置"],
    ["JLC精灵村_长老任务物品生成"] = ____exports["执行长老任务物品生成"],
    ["JLC精灵村_地精区域显视野"] = ____exports["执行地精区域显视野"],
    ["JLC精灵村_创建地精祭祀Boss预备"] = ____exports["执行地精祭祀Boss预备"],
    ["JLC精灵村_远古波动奖励"] = ____exports["执行远古波动奖励"]
}
local function _____5199_5165_5E76_64AD_653E_5267_60C5(_____7247_6BB5ID, _____89E6_53D1_914D_7F6E_540D, _____89E6_53D1_5355_4F4D)
    return _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = _____89E6_53D1_914D_7F6E_540D, ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function _____89E6_53D1_5355_4F4D_5728_6751_53E3_653E_884C_77E9_5F62_5185(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local rect = _____83B7_53D6_77E9_5F62_533A_57DF("精灵村.门禁区域")
    if rect == nil or rect == 0 then
        return false
    end
    return RectContainsUnit(rect, unit)
end
local function ____on_7CBE_7075_6751_6751_53E3_653E_884C_89E6_53D1(_____89E6_53D1_5355_4F4D)
    if _____5DF2_89E6_53D1_6751_53E3_653E_884C then
        return true
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() > 0 then
        return true
    end
    if not _____89E6_53D1_5355_4F4D_5728_6751_53E3_653E_884C_77E9_5F62_5185(_____89E6_53D1_5355_4F4D) then
        return false
    end
    if _____5199_5165_5E76_64AD_653E_5267_60C5("jlc_elven_village_gate_release", "精灵村村口放行核心", _____89E6_53D1_5355_4F4D) then
        _____5DF2_89E6_53D1_6751_53E3_653E_884C = true
        return true
    end
    return false
end
local function ____on_7CBE_7075_6751_957F_8001_53D1_5E03_4EFB_52A1_89E6_53D1(_____89E6_53D1_5355_4F4D)
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() >= 1 then
        return true
    end
    return _____5199_5165_5E76_64AD_653E_5267_60C5("jlc_elven_village_elder_quest", "精灵村长老发布任务核心", _____89E6_53D1_5355_4F4D)
end
____exports["初始化进度01_精灵村长老发布任务核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA601_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA601_6838_5FC3 = true
    registerOneShotUnitRangeListener(
        YDUserDataGetSafe("string", "主线NPC", "自然守护者", "unit"),
        500,
        ____on_7CBE_7075_6751_6751_53E3_653E_884C_89E6_53D1,
        _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D
    )
    registerOneShotUnitRangeListener(
        YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit"),
        800,
        ____on_7CBE_7075_6751_957F_8001_53D1_5E03_4EFB_52A1_89E6_53D1,
        _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D
    )
end
return ____exports
