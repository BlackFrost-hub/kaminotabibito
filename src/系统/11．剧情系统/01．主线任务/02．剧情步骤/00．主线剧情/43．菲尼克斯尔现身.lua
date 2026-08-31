--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["菲尼克斯尔场地配置"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____40_2D50_FF0E_7B2C_4E09_7AE0_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.40-50．第三章电影镜头")
local _____5E94_7528_7B2C_4E09_7AE0_7535_5F71_955C_5934 = ____40_2D50_FF0E_7B2C_4E09_7AE0_7535_5F71_955C_5934["应用第三章电影镜头"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
local ____06_FF0EBoss_6B7B_4EA1_5267_60C5_7D22_5F15 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.06．Boss死亡剧情索引")
local _____5C1D_8BD5_64AD_653EBoss_6B7B_4EA1_4E3B_7EBF_5267_60C5 = ____06_FF0EBoss_6B7B_4EA1_5267_60C5_7D22_5F15["尝试播放Boss死亡主线剧情"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____require_result_0["创建并冻结剧情Boss预置"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_1["暂停并设置无敌安全"]
local ____require_result_2 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_2.IsUnitAliveBJ
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_3.registerOneShotUnitRangeListener
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_4.registerDeathListener
local unregisterDeathListener = ____require_result_4.unregisterDeathListener
local ____require_result_5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_5["是玩家英雄组单位"]
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_6["获取玩家英雄单位组"]
local ____require_result_7 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_7.YDWEAngleBetweenUnitsSafe
local YDUserDataClearSafe = ____require_result_7.YDUserDataClearSafe
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.43A．菲尼克斯尔战后地形装饰")
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970 = ____require_result_9["创建菲尼克斯尔战后地形装饰"]
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
local StarOther_PanCameraToTimedForPlayer = ____require_result_10.StarOther_PanCameraToTimedForPlayer
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local GetOwningPlayer = jass.GetOwningPlayer
local IssueImmediateOrder = jass.IssueImmediateOrder
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
____exports["菲尼克斯尔Boss键"] = "Boss.双重凤凰·菲尼克斯尔"
____exports["菲尼克斯尔待战暂停来源"] = "剧情系统:菲尼克斯尔待战"
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____83F2_5C3C_514B_65AF_5C14Boss_540D = "双重凤凰·菲尼克斯尔"
local _____83F2_5C3C_514B_65AF_5C14_8FDB_5165_8303_56F4 = 1400
local _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF = {X = 15429.9, Y = -4014.9, ["朝向"] = 0}
local _____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001
local _____5DF2_6B63_5F0F_51FB_8D25_83F2_5C3C_514B_65AF_5C14 = false
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit)
end
local function ____on_8FD4_56DE_83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF()
    local unit = GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    SetUnitPosition(unit, _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF.X, _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF.Y)
    SetUnitFacing(unit, _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF["朝向"])
    IssueImmediateOrder(unit, "stop")
    StarOther_PanCameraToTimedForPlayer(
        GetOwningPlayer(unit),
        _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF.X,
        _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF.Y,
        0.1
    )
end
local function _____8FD4_56DE_83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF()
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return
    end
    ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_8FD4_56DE_83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF)
end
local function _____6E05_7406_83F2_5C3C_514B_65AF_5C14_8303_56F4_76D1_542C(_____72B6_6001)
    if _____72B6_6001["取消范围监听"] ~= nil then
        _____72B6_6001["取消范围监听"]()
    end
    _____72B6_6001["取消范围监听"] = nil
end
local function _____521B_5EFA_795E_6BBF_5165_53E3_8868_73B0(_____72B6_6001)
    if _____72B6_6001["已创建神殿入口表现"] then
        return
    end
    _____72B6_6001["已创建神殿入口表现"] = true
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = "Common\\Effect\\Form\\Portal\\FeliceSiegeBluePortal.mdx",
        X = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["Boss初始点"].x,
        Y = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["Boss初始点"].y,
        ["持续秒"] = 8,
        ["缩放"] = 2.2
    })
end
local function _____64AD_653E_83F2_5C3C_514B_65AF_5C14_73B0_8EAB(_____89E6_53D1_5355_4F4D)
    _____5E94_7528_7B2C_4E09_7AE0_7535_5F71_955C_5934(43)
    local ____require_result_11 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_11["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("molten_realm_phoenixel_reveal", {["片段ID"] = "molten_realm_phoenixel_reveal", ["触发配置名"] = "火焰神殿菲尼克斯尔现身", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function ____on_83F2_5C3C_514B_65AF_5C14_8303_56F4_89E6_53D1(_____89E6_53D1_5355_4F4D)
    local _____72B6_6001 = _____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已触发现身"] or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 43 then
        return false
    end
    if not _____5355_4F4D_5B58_6D3B(_____89E6_53D1_5355_4F4D) then
        return false
    end
    _____72B6_6001["已触发现身"] = true
    _____6E05_7406_83F2_5C3C_514B_65AF_5C14_8303_56F4_76D1_542C(_____72B6_6001)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.菲尼克斯尔玩家", _____89E6_53D1_5355_4F4D)
    SetUnitFacing(
        _____72B6_6001["Boss单位"],
        YDWEAngleBetweenUnitsSafe(_____72B6_6001["Boss单位"], _____89E6_53D1_5355_4F4D)
    )
    SetUnitFacing(
        _____89E6_53D1_5355_4F4D,
        YDWEAngleBetweenUnitsSafe(_____89E6_53D1_5355_4F4D, _____72B6_6001["Boss单位"])
    )
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_73B0_8EAB(_____89E6_53D1_5355_4F4D)
    return true
end
local function _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8303_56F4_76D1_542C(_____72B6_6001)
    _____72B6_6001["取消范围监听"] = registerOneShotUnitRangeListener(_____72B6_6001["Boss单位"], _____83F2_5C3C_514B_65AF_5C14_8FDB_5165_8303_56F4, ____on_83F2_5C3C_514B_65AF_5C14_8303_56F4_89E6_53D1, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
end
local function ____on_83F2_5C3C_514B_65AF_5C14_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____72B6_6001 = _____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["Boss单位"] ~= dyingUnit then
        return
    end
    _____5DF2_6B63_5F0F_51FB_8D25_83F2_5C3C_514B_65AF_5C14 = true
    local _____6218_540E_73A9_5BB6 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.菲尼克斯尔玩家")
    if _____6218_540E_73A9_5BB6 ~= nil and _____6218_540E_73A9_5BB6 ~= 0 then
        _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.菲尼克斯尔战后玩家", _____6218_540E_73A9_5BB6)
    end
    _____8FD4_56DE_83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF()
    _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970()
    SetUnitPosition(dyingUnit, _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF.X, _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF.Y)
    SetUnitFacing(dyingUnit, _____83F2_5C3C_514B_65AF_5C14_89E6_53D1_533A_57DF["朝向"])
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("主线NPC.菲尼克斯尔残响", dyingUnit)
    _____6E05_7406_83F2_5C3C_514B_65AF_5C14_8303_56F4_76D1_542C(_____72B6_6001)
    if _____72B6_6001["已注册死亡监听"] then
        unregisterDeathListener(____on_83F2_5C3C_514B_65AF_5C14_6B7B_4EA1)
        _____72B6_6001["已注册死亡监听"] = false
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.菲尼克斯尔")
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.菲尼克斯尔玩家")
    YDUserDataClearSafe("string", "Boss", "双重凤凰·菲尼克斯尔", "unit")
    _____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001 = nil
    _____5C1D_8BD5_64AD_653EBoss_6B7B_4EA1_4E3B_7EBF_5267_60C5(dyingUnit)
end
____exports["获取菲尼克斯尔Boss"] = function()
    local ____temp_14 = _____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001 and _____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001["Boss单位"]
    if ____temp_14 == nil then
        ____temp_14 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.菲尼克斯尔")
    end
    local ____temp_14_15 = ____temp_14
    if ____temp_14_15 == nil then
        ____temp_14_15 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(____exports["菲尼克斯尔Boss键"])
    end
    return ____temp_14_15
end
____exports["是否已正式击败菲尼克斯尔"] = function()
    return _____5DF2_6B63_5F0F_51FB_8D25_83F2_5C3C_514B_65AF_5C14
end
____exports["执行准备菲尼克斯尔现身"] = function()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 43 then
        return
    end
    local _____5F53_524DBoss = ____exports["获取菲尼克斯尔Boss"]()
    if _____5355_4F4D_5B58_6D3B(_____5F53_524DBoss) then
        return
    end
    local _____521D_59CB_70B9 = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["Boss初始点"]
    local bossUnit = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
        ["Boss键"] = ____exports["菲尼克斯尔Boss键"],
        ["Boss名"] = _____83F2_5C3C_514B_65AF_5C14Boss_540D,
        X = _____521D_59CB_70B9.x,
        Y = _____521D_59CB_70B9.y,
        ["朝向"] = 0,
        ["预创建后暂停"] = false,
        ["预创建后无敌"] = false
    })
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        return
    end
    SetUnitOwner(
        bossUnit,
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        true
    )
    SetUnitPosition(bossUnit, _____521D_59CB_70B9.x, _____521D_59CB_70B9.y)
    SetUnitFacing(bossUnit, 0)
    IssueImmediateOrder(bossUnit, "stop")
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(bossUnit, ____exports["菲尼克斯尔待战暂停来源"])
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.菲尼克斯尔", bossUnit)
    _____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001 = {["Boss单位"] = bossUnit, ["已触发现身"] = false, ["已注册死亡监听"] = true, ["已创建神殿入口表现"] = false}
    registerDeathListener(____on_83F2_5C3C_514B_65AF_5C14_6B7B_4EA1)
    _____521B_5EFA_795E_6BBF_5165_53E3_8868_73B0(_____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001)
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8303_56F4_76D1_542C(_____5F53_524D_83F2_5C3C_514B_65AF_5C14_73B0_8EAB_72B6_6001)
end
____exports["执行菲尼克斯尔现身准备动作"] = function()
    ____exports["执行准备菲尼克斯尔现身"]()
end
____exports["菲尼克斯尔现身剧情动作注册表"] = {["第三章_准备菲尼克斯尔现身"] = ____exports["执行菲尼克斯尔现身准备动作"]}
return ____exports
