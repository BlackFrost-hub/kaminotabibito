local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local _____6062_590D_73A9_5BB6_82F1_96C4_63A7_5236, _____91CA_653E_5355_4F4D_6682_505C_6765_6E90_5168_90E8, DestroyGroup, FirstOfGroup, GroupRemoveUnit, _____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID, _____73A9_5BB6_82F1_96C4_6682_505C_7EC4, _____6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1_73A9_5BB6_6682_505C_6765_6E90
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
function _____6062_590D_73A9_5BB6_82F1_96C4_63A7_5236()
    _____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID = 0
    if _____73A9_5BB6_82F1_96C4_6682_505C_7EC4 == nil or _____73A9_5BB6_82F1_96C4_6682_505C_7EC4 == 0 then
        return
    end
    while true do
        local unit = FirstOfGroup(_____73A9_5BB6_82F1_96C4_6682_505C_7EC4)
        if unit == nil or unit == 0 then
            break
        end
        GroupRemoveUnit(_____73A9_5BB6_82F1_96C4_6682_505C_7EC4, unit)
        _____91CA_653E_5355_4F4D_6682_505C_6765_6E90_5168_90E8(unit, _____6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1_73A9_5BB6_6682_505C_6765_6E90)
    end
    DestroyGroup(_____73A9_5BB6_82F1_96C4_6682_505C_7EC4)
    _____73A9_5BB6_82F1_96C4_6682_505C_7EC4 = nil
end
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
_____91CA_653E_5355_4F4D_6682_505C_6765_6E90_5168_90E8 = ____require_result_1["释放单位暂停来源全部"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_2["暂停并设置无敌安全"]
local _____6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_5F85_6218_6682_505C_6765_6E90 = "剧情系统:沙漠食人魔二阶段待战"
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_3.YDWEAngleBetweenUnitsSafe
local ____require_result_4 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_4["按名字反查Boss单位ID"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local ____require_result_6 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_6["按结算键执行Boss死亡结算"]
local ____require_result_7 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.04．死亡事件桥接")
local _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005 = ____require_result_7["消费保留剧情Boss死亡击杀者"]
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_8["创建单位并登记排泄安全"]
local ____require_result_9 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_9["立即移除单位并取消排泄登记"]
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedUnitForPlayer = ____require_result_10.StarOther_PanCameraToTimedUnitForPlayer
local ____require_result_11 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundBJ = ____require_result_11.PlaySoundBJ
local ____require_result_12 = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时")
local _____5378_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4 = ____require_result_12["卸载区域背景音乐句柄"]
local ____require_result_13 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_13.GetPlayersAll
local ____require_result_14 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_14.QuestMessageBJ
local ____require_result_15 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____require_result_15["注册剧情片段清理"]
local ____require_result_16 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_16["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_16["读取剧情运行时单位"]
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_16["清理剧情运行时单位"]
local ____require_result_17 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_17.addDelayedCallback
local removeDelayedCallback = ____require_result_17.removeDelayedCallback
local addPeriodicCallback = ____require_result_17.addPeriodicCallback
local removePeriodicCallback = ____require_result_17.removePeriodicCallback
local ____require_result_18 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_18["创建点特效"]
do
    local ____11_FF0E_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.11．沙漠食人魔一阶段死亡")
    ____exports["沙漠食人魔一阶段死亡剧情片段"] = ____11_FF0E_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1["沙漠食人魔一阶段死亡剧情片段"]
end
local GetDyingUnit = jass.GetDyingUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssuePointOrder = jass.IssuePointOrder
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local IssueTargetOrder = jass.IssueTargetOrder
local UnitSuspendDecay = jass.UnitSuspendDecay
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitName = jass.GetUnitName
local CreateGroup = jass.CreateGroup
DestroyGroup = jass.DestroyGroup
local GroupAddUnit = jass.GroupAddUnit
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
FirstOfGroup = jass.FirstOfGroup
GroupRemoveUnit = jass.GroupRemoveUnit
local IsUnitInGroup = jass.IsUnitInGroup
local RemoveUnit = jass.RemoveUnit
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54 = nil
local _____5F85_5F00_6218_76EE_6807_5355_4F4D = nil
local _____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D = nil
_____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID = 0
_____73A9_5BB6_82F1_96C4_6682_505C_7EC4 = nil
_____6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1_73A9_5BB6_6682_505C_6765_6E90 = "剧情系统:沙漠食人魔一阶段死亡现场"
local _____4E8C_9636_6BB5_663E_73B0_5468_671FID = 0
local _____4E8C_9636_6BB5_663E_73B0_6B21_6570 = 0
local _____4E00_9636_6BB5_6B7B_4EA1X = 0
local _____4E00_9636_6BB5_6B7B_4EA1Y = 0
local _____88C2_9699_8FD0_884C_65F6_952E = "剧情运行时.沙漠食人魔裂隙"
local _____8725_8734_4EBA_8FD0_884C_65F6_952E = "主线NPC.裂隙蜥蜴人"
local function _____6E05_7406_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6F14_51FA()
    if _____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID ~= 0 then
        removeDelayedCallback(_____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID)
        _____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID = 0
    end
    if _____4E8C_9636_6BB5_663E_73B0_5468_671FID ~= 0 then
        removePeriodicCallback(_____4E8C_9636_6BB5_663E_73B0_5468_671FID)
        _____4E8C_9636_6BB5_663E_73B0_5468_671FID = 0
    end
    _____6062_590D_73A9_5BB6_82F1_96C4_63A7_5236()
    local _____88C2_9699 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____88C2_9699_8FD0_884C_65F6_952E)
    if _____88C2_9699 ~= nil and _____88C2_9699 ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____88C2_9699)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____88C2_9699_8FD0_884C_65F6_952E)
    local _____8725_8734_4EBA = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8725_8734_4EBA_8FD0_884C_65F6_952E)
    if _____8725_8734_4EBA ~= nil and _____8725_8734_4EBA ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____8725_8734_4EBA)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8725_8734_4EBA_8FD0_884C_65F6_952E)
    if _____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D ~= nil and _____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D ~= 0 then
        UnitSuspendDecay(_____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D, false)
        RemoveUnit(_____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D)
        _____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D = nil
    end
end
local function _____6682_505C_6B7B_4EA1_70B9_9644_8FD1_73A9_5BB6_82F1_96C4_5E76_770B_5411_88C2_9699(_____88C2_9699, x, y)
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 or _____88C2_9699 == nil or _____88C2_9699 == 0 then
        return
    end
    _____6062_590D_73A9_5BB6_82F1_96C4_63A7_5236()
    _____73A9_5BB6_82F1_96C4_6682_505C_7EC4 = CreateGroup()
    local _____8303_56F4_5355_4F4D_7EC4 = CreateGroup()
    GroupEnumUnitsInRange(
        _____8303_56F4_5355_4F4D_7EC4,
        x,
        y,
        3000,
        nil
    )
    while true do
        do
            local unit = FirstOfGroup(_____8303_56F4_5355_4F4D_7EC4)
            if unit == nil or unit == 0 then
                break
            end
            GroupRemoveUnit(_____8303_56F4_5355_4F4D_7EC4, unit)
            if not IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_7EC4) then
                goto __continue10
            end
            _____6DFB_52A0_5355_4F4D_6682_505C(unit, _____6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1_73A9_5BB6_6682_505C_6765_6E90)
            GroupAddUnit(_____73A9_5BB6_82F1_96C4_6682_505C_7EC4, unit)
            SetUnitFacing(
                unit,
                YDWEAngleBetweenUnitsSafe(unit, _____88C2_9699)
            )
            StarOther_PanCameraToTimedUnitForPlayer(
                GetOwningPlayer(unit),
                _____88C2_9699,
                0.75
            )
        end
        ::__continue10::
    end
    DestroyGroup(_____8303_56F4_5355_4F4D_7EC4)
end
____exports["执行沙漠食人魔一阶段死亡前置"] = function(_____53C2_6570)
    local _____4E0A_4E0B_6587_89E6_53D1_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    local _____4E8B_4EF6_6B7B_4EA1_5355_4F4D = GetDyingUnit()
    local ____temp_19
    if _____4E8B_4EF6_6B7B_4EA1_5355_4F4D ~= nil and _____4E8B_4EF6_6B7B_4EA1_5355_4F4D ~= 0 then
        ____temp_19 = _____4E8B_4EF6_6B7B_4EA1_5355_4F4D
    else
        ____temp_19 = _____4E0A_4E0B_6587_89E6_53D1_5355_4F4D
    end
    local dyingUnit = ____temp_19
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local killingUnit = _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005(dyingUnit)
    _____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D = dyingUnit
    local ____temp_20
    if killingUnit ~= nil and killingUnit ~= 0 then
        ____temp_20 = killingUnit
    else
        ____temp_20 = nil
    end
    _____5F85_5F00_6218_76EE_6807_5355_4F4D = ____temp_20
    if _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= nil then
        local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
        _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587(__TS__ObjectAssign({}, _____4E0A_4E0B_6587, {["触发单位"] = _____5F85_5F00_6218_76EE_6807_5355_4F4D}))
    end
    UnitSuspendDecay(dyingUnit, true)
    _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97("沙漠食人魔", dyingUnit, _____5F85_5F00_6218_76EE_6807_5355_4F4D)
    _____4E00_9636_6BB5_6B7B_4EA1X = GetUnitX(dyingUnit)
    _____4E00_9636_6BB5_6B7B_4EA1Y = GetUnitY(dyingUnit)
    local _____80DC_5229_97F3_6548 = jglobals.gg_snd_shengliBgm
    local _____6218_6597_533A_57DF = _____83B7_53D6_77E9_5F62_533A_57DF("沙漠区域.Boss战区域")
    _____5378_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4(_____80DC_5229_97F3_6548, _____6218_6597_533A_57DF)
    local riftTypeId = stringToFourCCSafe("e08M")
    local riftUnit = nil
    if riftTypeId > 0 then
        riftUnit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            Player(PLAYER_NEUTRAL_PASSIVE),
            riftTypeId,
            27531.2,
            13562.4,
            0
        )
        _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____88C2_9699_8FD0_884C_65F6_952E, riftUnit)
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
            X = 27531.2,
            Y = 13562.4,
            ["面向角度"] = 270,
            ["缩放"] = 2,
            ["动画速度"] = 1,
            ["持续秒"] = 1.5
        })
    end
    _____6682_505C_6B7B_4EA1_70B9_9644_8FD1_73A9_5BB6_82F1_96C4_5E76_770B_5411_88C2_9699(riftUnit, _____4E00_9636_6BB5_6B7B_4EA1X, _____4E00_9636_6BB5_6B7B_4EA1Y)
    if _____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID ~= 0 then
        removeDelayedCallback(_____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID)
    end
    _____73A9_5BB6_82F1_96C4_5EF6_8FDF_6062_590DID = addDelayedCallback(1250, _____6062_590D_73A9_5BB6_82F1_96C4_63A7_5236)
end
____exports["执行沙漠食人魔裂隙来客入场"] = function()
    local riftUnit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____88C2_9699_8FD0_884C_65F6_952E)
    if riftUnit == nil or riftUnit == 0 then
        return
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = "war3mapImported\\blackhole.mdx",
        X = GetUnitX(riftUnit),
        Y = GetUnitY(riftUnit),
        ["面向角度"] = 270,
        ["缩放"] = 2,
        ["动画速度"] = 1,
        ["持续秒"] = 1.5
    })
    local lizardTypeId = stringToFourCCSafe("h01I")
    if lizardTypeId > 0 then
        local angle = math.atan(
            _____4E00_9636_6BB5_6B7B_4EA1Y - GetUnitY(riftUnit),
            _____4E00_9636_6BB5_6B7B_4EA1X - GetUnitX(riftUnit)
        ) * 180 / math.pi
        local lizardUnit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            Player(PLAYER_NEUTRAL_PASSIVE),
            lizardTypeId,
            27531.2,
            13562.4,
            angle
        )
        if lizardUnit ~= nil and lizardUnit ~= 0 then
            _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8725_8734_4EBA_8FD0_884C_65F6_952E, lizardUnit)
            local radians = angle * math.pi / 180
            IssuePointOrder(
                lizardUnit,
                "move",
                GetUnitX(riftUnit) + math.cos(radians) * 150,
                GetUnitY(riftUnit) + math.sin(radians) * 150
            )
        end
    end
end
____exports["执行沙漠食人魔裂隙来客对峙"] = function()
    local lizardUnit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8725_8734_4EBA_8FD0_884C_65F6_952E)
    if lizardUnit == nil or lizardUnit == 0 then
        return
    end
    IssueImmediateOrder(lizardUnit, "holdposition")
    if _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= nil and _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= 0 then
        SetUnitFacing(
            lizardUnit,
            YDWEAngleBetweenUnitsSafe(lizardUnit, _____5F85_5F00_6218_76EE_6807_5355_4F4D)
        )
    end
end
local function ____on_6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_663E_73B0_8109_51B2()
    if _____4E8C_9636_6BB5_663E_73B0_6B21_6570 >= 12 then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = "war3mapImported\\blood2022720203813.mdl",
            X = _____4E00_9636_6BB5_6B7B_4EA1X,
            Y = _____4E00_9636_6BB5_6B7B_4EA1Y,
            ["面向角度"] = 270,
            ["缩放"] = 2.5,
            ["动画速度"] = 1,
            ["持续秒"] = 1.5
        })
        if _____4E8C_9636_6BB5_663E_73B0_5468_671FID ~= 0 then
            removePeriodicCallback(_____4E8C_9636_6BB5_663E_73B0_5468_671FID)
        end
        _____4E8C_9636_6BB5_663E_73B0_5468_671FID = 0
        return
    end
    _____4E8C_9636_6BB5_663E_73B0_6B21_6570 = _____4E8C_9636_6BB5_663E_73B0_6B21_6570 + 1
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = "war3mapImported\\desecrate.mdl",
        X = _____4E00_9636_6BB5_6B7B_4EA1X,
        Y = _____4E00_9636_6BB5_6B7B_4EA1Y,
        ["面向角度"] = 270,
        ["缩放"] = 2,
        ["动画速度"] = 1,
        ["持续秒"] = 1.5
    })
end
____exports["执行沙漠食人魔裂隙来客施法"] = function()
    local lizardUnit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8725_8734_4EBA_8FD0_884C_65F6_952E)
    local riftUnit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____88C2_9699_8FD0_884C_65F6_952E)
    if lizardUnit ~= nil and lizardUnit ~= 0 then
        if riftUnit ~= nil and riftUnit ~= 0 then
            SetUnitFacing(
                lizardUnit,
                YDWEAngleBetweenUnitsSafe(lizardUnit, riftUnit)
            )
        end
        jass.SetUnitAnimationByIndex(lizardUnit, 11)
    end
    if _____4E8C_9636_6BB5_663E_73B0_5468_671FID ~= 0 then
        removePeriodicCallback(_____4E8C_9636_6BB5_663E_73B0_5468_671FID)
    end
    _____4E8C_9636_6BB5_663E_73B0_6B21_6570 = 0
    _____4E8C_9636_6BB5_663E_73B0_5468_671FID = addPeriodicCallback(400, ____on_6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_663E_73B0_8109_51B2)
end
local function _____5B8C_6210_6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_663E_73B0_8109_51B2()
    if _____4E8C_9636_6BB5_663E_73B0_5468_671FID == 0 then
        return
    end
    removePeriodicCallback(_____4E8C_9636_6BB5_663E_73B0_5468_671FID)
    _____4E8C_9636_6BB5_663E_73B0_5468_671FID = 0
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = "war3mapImported\\blood2022720203813.mdl",
        X = _____4E00_9636_6BB5_6B7B_4EA1X,
        Y = _____4E00_9636_6BB5_6B7B_4EA1Y,
        ["面向角度"] = 270,
        ["缩放"] = 2.5,
        ["动画速度"] = 1,
        ["持续秒"] = 1.5
    })
end
____exports["执行杀戮食人魔显现"] = function(_____53C2_6570)
    _____5B8C_6210_6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_663E_73B0_8109_51B2()
    local ____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID_22 = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID
    local ____53C2_6570__4E8C_9636_6BB5Boss_540D_21 = _____53C2_6570["二阶段Boss名"]
    if ____53C2_6570__4E8C_9636_6BB5Boss_540D_21 == nil then
        ____53C2_6570__4E8C_9636_6BB5Boss_540D_21 = "杀戮食人魔"
    end
    local bossRawId = ____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID_22(tostring(____53C2_6570__4E8C_9636_6BB5Boss_540D_21))
    local bossTypeId = stringToFourCCSafe(bossRawId)
    if not (bossTypeId > 0) then
        return
    end
    local bossUnit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        bossTypeId,
        _____4E00_9636_6BB5_6B7B_4EA1X,
        _____4E00_9636_6BB5_6B7B_4EA1Y,
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
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(bossUnit, _____6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_5F85_6218_6682_505C_6765_6E90)
    jass.SetUnitAnimationByIndex(bossUnit, 11)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = "war3mapImported\\desecrate.mdl",
        X = _____4E00_9636_6BB5_6B7B_4EA1X,
        Y = _____4E00_9636_6BB5_6B7B_4EA1Y,
        ["面向角度"] = 270,
        ["缩放"] = 4,
        ["动画速度"] = 1,
        ["持续秒"] = 1.5
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
        X = _____4E00_9636_6BB5_6B7B_4EA1X,
        Y = _____4E00_9636_6BB5_6B7B_4EA1Y,
        ["面向角度"] = 270,
        ["缩放"] = 2,
        ["动画速度"] = 1,
        ["持续秒"] = 1.5
    })
    QuestMessageBJ(
        GetPlayersAll(),
        jglobals.bj_QUESTMESSAGE_WARNING,
        "？？：" .. GetUnitName(bossUnit)
    )
    local _____663E_73B0_97F3_6548 = jglobals.gg_snd_GWSY07
    if _____663E_73B0_97F3_6548 ~= nil and _____663E_73B0_97F3_6548 ~= 0 then
        PlaySoundBJ(_____663E_73B0_97F3_6548)
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        local _____4E34_65F6_7EC4 = CreateGroup()
        GroupEnumUnitsInRange(
            _____4E34_65F6_7EC4,
            _____4E00_9636_6BB5_6B7B_4EA1X,
            _____4E00_9636_6BB5_6B7B_4EA1Y,
            99999,
            nil
        )
        while true do
            local unit = FirstOfGroup(_____4E34_65F6_7EC4)
            if unit == nil or unit == 0 then
                break
            end
            GroupRemoveUnit(_____4E34_65F6_7EC4, unit)
            if IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_7EC4) then
                _____91CA_653E_5355_4F4D_6682_505C_6765_6E90_5168_90E8(unit, _____6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1_73A9_5BB6_6682_505C_6765_6E90)
                StarOther_PanCameraToTimedUnitForPlayer(
                    GetOwningPlayer(unit),
                    bossUnit,
                    0.5
                )
            end
        end
        DestroyGroup(_____4E34_65F6_7EC4)
    end
    _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54 = bossUnit
end
____exports["执行沙漠食人魔二阶段演出收束"] = function()
    local ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_23 = _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54
    if ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_23 == nil then
        ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_23 = YDUserDataGetSafe("string", "Boss", "杀戮食人魔", "unit")
    end
    local bossUnit = ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_23
    _____6062_590D_73A9_5BB6_82F1_96C4_63A7_5236()
    local _____8725_8734_4EBA = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8725_8734_4EBA_8FD0_884C_65F6_952E)
    if _____8725_8734_4EBA ~= nil and _____8725_8734_4EBA ~= 0 and _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= nil and _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= 0 then
        SetUnitFacing(
            _____8725_8734_4EBA,
            YDWEAngleBetweenUnitsSafe(_____8725_8734_4EBA, _____5F85_5F00_6218_76EE_6807_5355_4F4D)
        )
    end
    if _____8725_8734_4EBA ~= nil and _____8725_8734_4EBA ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____8725_8734_4EBA)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8725_8734_4EBA_8FD0_884C_65F6_952E)
    local _____88C2_9699 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____88C2_9699_8FD0_884C_65F6_952E)
    if _____88C2_9699 ~= nil and _____88C2_9699 ~= 0 then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = "war3mapImported\\blackhole.mdx",
            X = GetUnitX(_____88C2_9699),
            Y = GetUnitY(_____88C2_9699),
            ["面向角度"] = 270,
            ["缩放"] = 2,
            ["动画速度"] = 1,
            ["持续秒"] = 1.5
        })
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____88C2_9699)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____88C2_9699_8FD0_884C_65F6_952E)
    if bossUnit ~= nil and bossUnit ~= 0 then
        local _____53F0_8BCD_97F3_6548 = jglobals.gg_snd_GWSY04
        if _____53F0_8BCD_97F3_6548 ~= nil and _____53F0_8BCD_97F3_6548 ~= 0 then
            PlaySoundBJ(_____53F0_8BCD_97F3_6548)
        end
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl",
            X = GetUnitX(bossUnit),
            Y = GetUnitY(bossUnit),
            ["面向角度"] = 270,
            ["缩放"] = 2,
            ["动画速度"] = 1,
            ["持续秒"] = 1.5
        })
    end
end
____exports["执行沙漠食人魔二阶段开战"] = function()
    local ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_24 = _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54
    if ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_24 == nil then
        ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_24 = YDUserDataGetSafe("string", "Boss", "杀戮食人魔", "unit")
    end
    local bossUnit = ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_24
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    if _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= nil and _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= 0 then
        IssueTargetOrder(bossUnit, "attack", _____5F85_5F00_6218_76EE_6807_5355_4F4D)
    end
    _____6E05_7406_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6F14_51FA()
    _____542F_52A8_5267_60C5Boss_6218(bossUnit, {["触发单位"] = _____5F85_5F00_6218_76EE_6807_5355_4F4D, ["暂停来源"] = _____6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_5F85_6218_6682_505C_6765_6E90})
    _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54 = nil
    _____5F85_5F00_6218_76EE_6807_5355_4F4D = nil
end
____exports["沙漠食人魔一阶段死亡剧情动作注册表"] = {
    ["SW01死亡事件_沙漠食人魔一阶段死亡前置"] = ____exports["执行沙漠食人魔一阶段死亡前置"],
    ["SW01死亡事件_裂隙来客入场"] = ____exports["执行沙漠食人魔裂隙来客入场"],
    ["SW01死亡事件_裂隙来客对峙"] = ____exports["执行沙漠食人魔裂隙来客对峙"],
    ["SW01死亡事件_裂隙来客施法"] = ____exports["执行沙漠食人魔裂隙来客施法"],
    ["SW01死亡事件_杀戮食人魔显现"] = ____exports["执行杀戮食人魔显现"],
    ["SW01死亡事件_沙漠食人魔二阶段演出收束"] = ____exports["执行沙漠食人魔二阶段演出收束"],
    ["SW01死亡事件_沙漠食人魔二阶段开战"] = ____exports["执行沙漠食人魔二阶段开战"]
}
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406("jlc_desert_ogre_first_death", _____6E05_7406_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6F14_51FA)
return ____exports
