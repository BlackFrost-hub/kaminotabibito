local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____64AD_653E_4E3B_7EBF_5267_60C5, _____6E05_7406_706B_5C71_8BD5_70BC_8303_56F4_76D1_542C, ____on_64AD_653E_706B_7075_6838_5FC3_4EA4_4ED8, ____on_7194_5CA9_6076_9B54_6B7B_4EA1, jglobals, ModifyGateBJ, YDUserDataClearSafe, IsUnitAliveBJ, unregisterDeathListener, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, addDelayedCallback, IssueImmediateOrder, SetUnitPosition, _____706B_7075_6838_5FC3_4EA4_4ED8_70B9C, _____4E0B_4E00_4EE3_706B_5C71_8BD5_70BC_4E16_4EE3, _____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001, _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____40_2D50_FF0E_7B2C_4E09_7AE0_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.40-50．第三章电影镜头")
local _____5E94_7528_7B2C_4E09_7AE0_7535_5F71_955C_5934 = ____40_2D50_FF0E_7B2C_4E09_7AE0_7535_5F71_955C_5934["应用第三章电影镜头"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["发布主线节点目标"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
local ____42_FF0E_5DF4_5C14_624E_7F57_65AF_524D_5BFC = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.42．巴尔扎罗斯前导")
local _____6267_884C_51C6_5907_5DF4_5C14_624E_7F57_65AF_524D_5BFC = ____42_FF0E_5DF4_5C14_624E_7F57_65AF_524D_5BFC["执行准备巴尔扎罗斯前导"]
function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit)
end
function _____64AD_653E_4E3B_7EBF_5267_60C5(_____7247_6BB5ID, _____89E6_53D1_5355_4F4D, _____89E6_53D1_914D_7F6E_540D)
    local ____require_result_10 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_10["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = _____89E6_53D1_914D_7F6E_540D, ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
function _____6E05_7406_706B_5C71_8BD5_70BC_8303_56F4_76D1_542C(_____72B6_6001)
    if _____72B6_6001["取消范围监听"] ~= nil then
        _____72B6_6001["取消范围监听"](_____72B6_6001)
    end
    _____72B6_6001["取消范围监听"] = nil
end
function ____on_64AD_653E_706B_7075_6838_5FC3_4EA4_4ED8(_____9884_671F_4E16_4EE3)
    if __TS__Number(_____9884_671F_4E16_4EE3) ~= _____4E0B_4E00_4EE3_706B_5C71_8BD5_70BC_4E16_4EE3 then
        return
    end
    local _____73A9_5BB6_5355_4F4D = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.火山试炼玩家")
    if _____5355_4F4D_5B58_6D3B(_____73A9_5BB6_5355_4F4D) then
        _____64AD_653E_4E3B_7EBF_5267_60C5("molten_realm_fire_core_handover", _____73A9_5BB6_5355_4F4D, "熔岩恶魔死亡后火灵核心交付")
    end
end
function ____on_7194_5CA9_6076_9B54_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____72B6_6001 = _____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["Boss单位"] ~= dyingUnit then
        return
    end
    ModifyGateBJ(jglobals.bj_GATEOPERATION_OPEN, jglobals.gg_dest_ATg3_10381)
    ModifyGateBJ(jglobals.bj_GATEOPERATION_OPEN, jglobals.gg_dest_B00J_10382)
    _____6E05_7406_706B_5C71_8BD5_70BC_8303_56F4_76D1_542C(_____72B6_6001)
    if _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C then
        unregisterDeathListener(____on_7194_5CA9_6076_9B54_6B7B_4EA1)
        _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = false
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.熔岩恶魔")
    YDUserDataClearSafe("string", "Boss", "熔岩恶魔", "unit")
    local _____73A9_5BB6_5355_4F4D = _____72B6_6001["玩家单位"]
    _____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001 = nil
    if _____5355_4F4D_5B58_6D3B(_____73A9_5BB6_5355_4F4D) and _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____73A9_5BB6_5355_4F4D) then
        _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.火山试炼玩家", _____73A9_5BB6_5355_4F4D)
        SetUnitPosition(_____73A9_5BB6_5355_4F4D, _____706B_7075_6838_5FC3_4EA4_4ED8_70B9C.X, _____706B_7075_6838_5FC3_4EA4_4ED8_70B9C.Y)
        IssueImmediateOrder(_____73A9_5BB6_5355_4F4D, "stop")
        addDelayedCallback(500, ____on_64AD_653E_706B_7075_6838_5FC3_4EA4_4ED8, _____4E0B_4E00_4EE3_706B_5C71_8BD5_70BC_4E16_4EE3)
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
ModifyGateBJ = ____require_result_0.ModifyGateBJ
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
YDUserDataClearSafe = ____require_result_1.YDUserDataClearSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_1.YDWEAngleBetweenUnitsSafe
local ____require_result_2 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____require_result_2["创建并冻结剧情Boss预置"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_3["暂停并设置无敌安全"]
local ____require_result_4 = require("lib.扩展函数.BJ函数.02．单位与英雄")
IsUnitAliveBJ = ____require_result_4.IsUnitAliveBJ
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_5.registerOneShotUnitRangeListener
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
unregisterDeathListener = ____require_result_6.unregisterDeathListener
local ____require_result_7 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
_____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_7["是玩家英雄组单位"]
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_8.addDelayedCallback
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_9["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_9["移除单位暂停"]
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local FirstOfGroup = jass.FirstOfGroup
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local GroupRemoveUnit = jass.GroupRemoveUnit
IssueImmediateOrder = jass.IssueImmediateOrder
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
SetUnitPosition = jass.SetUnitPosition
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local ____Boss_952E = "Boss.熔岩恶魔"
local ____Boss_540D = "熔岩恶魔"
local BossA = {X = 19616.6, Y = -6856.6, ["朝向"] = 270}
local _____73A9_5BB6B = {X = 19918.3, Y = -8256}
_____706B_7075_6838_5FC3_4EA4_4ED8_70B9C = {X = 19266.9, Y = -7532.9}
local _____706B_5C71_8BD5_70BC_89E6_53D1_8303_56F4 = 1200
local _____706B_5C71_8BD5_70BC_5C0F_602A_6682_505C_8303_56F4 = 1200
local _____706B_5C71_8BD5_70BC_5C0F_602A_6682_505C_6765_6E90 = "剧情系统:熔岩恶魔试炼对白"
local ____Boss_5F85_6218_6682_505C_6765_6E90 = "剧情系统:熔岩恶魔待战"
local _____5355_4F4D_7C7B_578B_82F1_96C4 = jass.UNIT_TYPE_HERO
_____4E0B_4E00_4EE3_706B_5C71_8BD5_70BC_4E16_4EE3 = 0
_____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = false
local function _____6062_590D_706B_5C71_8BD5_70BC_8303_56F4_5C0F_602A(_____72B6_6001)
    do
        local i = 0
        while i < #_____72B6_6001["暂停小怪列表"] do
            _____79FB_9664_5355_4F4D_6682_505C(_____72B6_6001["暂停小怪列表"][i + 1], _____706B_5C71_8BD5_70BC_5C0F_602A_6682_505C_6765_6E90)
            i = i + 1
        end
    end
    _____72B6_6001["暂停小怪列表"] = {}
end
local function _____6682_505C_706B_5C71_8BD5_70BC_8303_56F4_5C0F_602A(_____72B6_6001, _____73A9_5BB6_5355_4F4D)
    _____6062_590D_706B_5C71_8BD5_70BC_8303_56F4_5C0F_602A(_____72B6_6001)
    local group = CreateGroup()
    if group == nil or group == 0 then
        return
    end
    GroupEnumUnitsInRange(
        group,
        GetUnitX(_____73A9_5BB6_5355_4F4D),
        GetUnitY(_____73A9_5BB6_5355_4F4D),
        _____706B_5C71_8BD5_70BC_5C0F_602A_6682_505C_8303_56F4,
        nil
    )
    local _____73A9_5BB6 = GetOwningPlayer(_____73A9_5BB6_5355_4F4D)
    while true do
        do
            local unit = FirstOfGroup(group)
            if unit == nil or unit == 0 then
                break
            end
            GroupRemoveUnit(group, unit)
            if not _____5355_4F4D_5B58_6D3B(unit) or unit == _____72B6_6001["Boss单位"] or _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) or IsUnitType(unit, _____5355_4F4D_7C7B_578B_82F1_96C4) or not IsUnitEnemy(unit, _____73A9_5BB6) then
                goto __continue11
            end
            if _____6DFB_52A0_5355_4F4D_6682_505C(unit, _____706B_5C71_8BD5_70BC_5C0F_602A_6682_505C_6765_6E90) then
                local ____72B6_6001__6682_505C_5C0F_602A_5217_8868_11 = _____72B6_6001["暂停小怪列表"]
                ____72B6_6001__6682_505C_5C0F_602A_5217_8868_11[#____72B6_6001__6682_505C_5C0F_602A_5217_8868_11 + 1] = unit
            end
        end
        ::__continue11::
    end
    DestroyGroup(group)
end
local function ____on_706B_5C71_8BD5_70BC_8303_56F4_89E6_53D1(_____89E6_53D1_5355_4F4D)
    local _____72B6_6001 = _____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已进入战斗"] or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 41 then
        return false
    end
    if not _____5355_4F4D_5B58_6D3B(_____89E6_53D1_5355_4F4D) then
        return false
    end
    _____72B6_6001["已进入战斗"] = true
    _____72B6_6001["玩家单位"] = _____89E6_53D1_5355_4F4D
    _____6E05_7406_706B_5C71_8BD5_70BC_8303_56F4_76D1_542C(_____72B6_6001)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.火山试炼玩家", _____89E6_53D1_5355_4F4D)
    SetUnitPosition(_____89E6_53D1_5355_4F4D, _____73A9_5BB6B.X, _____73A9_5BB6B.Y)
    SetUnitFacing(
        _____72B6_6001["Boss单位"],
        YDWEAngleBetweenUnitsSafe(_____72B6_6001["Boss单位"], _____89E6_53D1_5355_4F4D)
    )
    SetUnitFacing(
        _____89E6_53D1_5355_4F4D,
        YDWEAngleBetweenUnitsSafe(_____89E6_53D1_5355_4F4D, _____72B6_6001["Boss单位"])
    )
    _____6682_505C_706B_5C71_8BD5_70BC_8303_56F4_5C0F_602A(_____72B6_6001, _____89E6_53D1_5355_4F4D)
    _____5E94_7528_7B2C_4E09_7AE0_7535_5F71_955C_5934(41)
    _____64AD_653E_4E3B_7EBF_5267_60C5("molten_realm_fire_trial", _____89E6_53D1_5355_4F4D, "熔岩恶魔试炼范围")
    return true
end
local function _____6CE8_518C_706B_5C71_8BD5_70BC_8303_56F4_76D1_542C(_____72B6_6001)
    _____72B6_6001["取消范围监听"] = registerOneShotUnitRangeListener(_____72B6_6001["Boss单位"], _____706B_5C71_8BD5_70BC_89E6_53D1_8303_56F4, ____on_706B_5C71_8BD5_70BC_8303_56F4_89E6_53D1, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
end
local function _____51C6_5907_706B_5C71_8BD5_70BCBoss()
    local bossUnit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(____Boss_952E)
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        bossUnit = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
            ["Boss键"] = ____Boss_952E,
            ["Boss名"] = ____Boss_540D,
            X = BossA.X,
            Y = BossA.Y,
            ["朝向"] = BossA["朝向"],
            ["预创建后暂停"] = false,
            ["预创建后无敌"] = false
        })
    end
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        return nil
    end
    YDUserDataSetSafe(
        "string",
        "Boss",
        "熔岩恶魔",
        "unit",
        bossUnit
    )
    SetUnitOwner(
        bossUnit,
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        true
    )
    SetUnitPosition(bossUnit, BossA.X, BossA.Y)
    SetUnitFacing(bossUnit, BossA["朝向"])
    IssueImmediateOrder(bossUnit, "stop")
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(bossUnit, ____Boss_5F85_6218_6682_505C_6765_6E90)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.熔岩恶魔", bossUnit)
    return bossUnit
end
____exports["执行准备火山之灵试炼"] = function()
    local _____8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    if _____8FDB_5EA6 ~= 40 and _____8FDB_5EA6 ~= 41 then
        return
    end
    if _____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001 ~= nil and _____5355_4F4D_5B58_6D3B(_____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001["Boss单位"]) then
        return
    end
    local bossUnit = _____51C6_5907_706B_5C71_8BD5_70BCBoss()
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    _____4E0B_4E00_4EE3_706B_5C71_8BD5_70BC_4E16_4EE3 = _____4E0B_4E00_4EE3_706B_5C71_8BD5_70BC_4E16_4EE3 + 1
    _____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001 = {["世代"] = _____4E0B_4E00_4EE3_706B_5C71_8BD5_70BC_4E16_4EE3, ["Boss单位"] = bossUnit, ["暂停小怪列表"] = {}, ["已进入战斗"] = false}
    if not _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C then
        registerDeathListener(____on_7194_5CA9_6076_9B54_6B7B_4EA1)
        _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = true
    end
    _____6CE8_518C_706B_5C71_8BD5_70BC_8303_56F4_76D1_542C(_____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001)
end
____exports["执行清理火灵核心交付"] = function(______53C2_6570)
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.火山试炼玩家")
end
____exports["执行完成火灵核心交付"] = function(______53C2_6570)
    _____5199_5165_5267_60C5_8FDB_5EA6(42)
    _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807(42)
    _____6267_884C_51C6_5907_5DF4_5C14_624E_7F57_65AF_524D_5BFC()
end
____exports["执行启动火山之灵试炼"] = function(______53C2_6570)
    local _____72B6_6001 = _____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001
    if _____72B6_6001 ~= nil then
        _____6062_590D_706B_5C71_8BD5_70BC_8303_56F4_5C0F_602A(_____72B6_6001)
    end
    local ____temp_14 = _____72B6_6001 and _____72B6_6001["Boss单位"]
    if ____temp_14 == nil then
        ____temp_14 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(____Boss_952E)
    end
    local bossUnit = ____temp_14
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        return
    end
    local ____542F_52A8_5267_60C5Boss_6218_18 = _____542F_52A8_5267_60C5Boss_6218
    local ____temp_17 = _____72B6_6001 and _____72B6_6001["玩家单位"]
    if ____temp_17 == nil then
        ____temp_17 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    end
    ____542F_52A8_5267_60C5Boss_6218_18(bossUnit, {["触发单位"] = ____temp_17, ["暂停来源"] = ____Boss_5F85_6218_6682_505C_6765_6E90})
end
____exports["执行恢复火山之灵试炼小怪"] = function(______53C2_6570)
    local _____72B6_6001 = _____5F53_524D_706B_5C71_8BD5_70BC_72B6_6001
    if _____72B6_6001 ~= nil then
        _____6062_590D_706B_5C71_8BD5_70BC_8303_56F4_5C0F_602A(_____72B6_6001)
    end
end
____exports["熔岩恶魔试炼剧情动作注册表"] = {
    ["第三章_准备火山之灵试炼"] = ____exports["执行准备火山之灵试炼"],
    ["第三章_恢复火山之灵试炼小怪"] = ____exports["执行恢复火山之灵试炼小怪"],
    ["第三章_启动火山之灵试炼"] = ____exports["执行启动火山之灵试炼"],
    ["第三章_完成火灵核心交付"] = ____exports["执行完成火灵核心交付"],
    ["第三章_清理火灵核心交付"] = ____exports["执行清理火灵核心交付"]
}
return ____exports
