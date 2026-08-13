--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53E5_67C4_6709_6548, ____on_8FD4_56DE_5DF4_5C14_624E_7F57_65AF_89E6_53D1_533A_57DF, _____8FD4_56DE_5DF4_5C14_624E_7F57_65AF_89E6_53D1_533A_57DF, _____6E05_7406_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001, _____5DF4_5C14_624E_7F57_65AF_6218_540E_5141_8BB8_8FDB_5165, _____5B8C_6210_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001, _____521B_5EFA_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_95E8, _____6E05_7406_5DF4_5C14_624E_7F57_65AF_8303_56F4_76D1_542C, _____64AD_653E_5DF4_5C14_624E_7F57_65AF_6218_540E_627F_63A5, ____on_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1, YDUserDataClearSafe, unregisterDeathListener, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4, _____521B_5EFA_70B9_7279_6548, _____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001, _____8BFB_53D6_5267_60C5_4F20_9001_914D_7F6E, StarOther_PanCameraToTimedForPlayer, _____6309_6B65_957F_8C03_6574_73A9_5BB6_955C_5934_9AD8_5EA6, _____542F_7528_7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_524D_5BFC_533A_57DF_80CC_666F_97F3_4E50, DestroyEffect, ForGroup, GetEnumUnit, GetOwningPlayer, SetUnitFacing, SetUnitPosition, IssueImmediateOrder, _____6218_540E_8FD4_56DE_4F4D_7F6E, _____5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_914D_7F6EID, _____6218_540E_4F20_9001_95E8_6A21_578B, _____5F53_524D_5DF4_5C14_624E_7F57_65AF_524D_5BFC_72B6_6001, _____5DF2_6CE8_518C_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1_76D1_542C, _____5F53_524D_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_72B6_6001
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____40_2D50_FF0E_7B2C_4E09_7AE0_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.40-50．第三章电影镜头")
local _____5E94_7528_7B2C_4E09_7AE0_7535_5F71_955C_5934 = ____40_2D50_FF0E_7B2C_4E09_7AE0_7535_5F71_955C_5934["应用第三章电影镜头"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____8FDB_5165_4E3B_7EBF_8282_70B9 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["进入主线节点"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
local ____43_FF0E_83F2_5C3C_514B_65AF_5C14_73B0_8EAB = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.43．菲尼克斯尔现身")
local _____6267_884C_51C6_5907_83F2_5C3C_514B_65AF_5C14_73B0_8EAB = ____43_FF0E_83F2_5C3C_514B_65AF_5C14_73B0_8EAB["执行准备菲尼克斯尔现身"]
function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
function ____on_8FD4_56DE_5DF4_5C14_624E_7F57_65AF_89E6_53D1_533A_57DF()
    local unit = GetEnumUnit()
    if not _____53E5_67C4_6709_6548(unit) then
        return
    end
    SetUnitPosition(unit, _____6218_540E_8FD4_56DE_4F4D_7F6E.X, _____6218_540E_8FD4_56DE_4F4D_7F6E.Y)
    SetUnitFacing(unit, _____6218_540E_8FD4_56DE_4F4D_7F6E["朝向"])
    IssueImmediateOrder(unit, "stop")
    StarOther_PanCameraToTimedForPlayer(
        GetOwningPlayer(unit),
        _____6218_540E_8FD4_56DE_4F4D_7F6E.X,
        _____6218_540E_8FD4_56DE_4F4D_7F6E.Y,
        0.1
    )
end
function _____8FD4_56DE_5DF4_5C14_624E_7F57_65AF_89E6_53D1_533A_57DF()
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if not _____53E5_67C4_6709_6548(_____73A9_5BB6_82F1_96C4_7EC4) then
        return
    end
    ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_8FD4_56DE_5DF4_5C14_624E_7F57_65AF_89E6_53D1_533A_57DF)
end
function _____6E05_7406_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001(_____72B6_6001)
    if _____72B6_6001["取消剧情传送注册"] ~= nil then
        _____72B6_6001["取消剧情传送注册"]()
    end
    if _____53E5_67C4_6709_6548(_____72B6_6001["传送门特效"]) then
        DestroyEffect(_____72B6_6001["传送门特效"])
    end
    _____72B6_6001["取消剧情传送注册"] = nil
    _____72B6_6001["传送门特效"] = nil
end
function _____5DF4_5C14_624E_7F57_65AF_6218_540E_5141_8BB8_8FDB_5165(unit)
    return _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit)
end
function _____5B8C_6210_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001(_____89E6_53D1_5355_4F4D)
    local _____72B6_6001 = _____5F53_524D_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已传送"] then
        return
    end
    _____72B6_6001["已传送"] = true
    _____6E05_7406_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001(_____72B6_6001)
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        _____6309_6B65_957F_8C03_6574_73A9_5BB6_955C_5934_9AD8_5EA6(
            GetOwningPlayer(_____89E6_53D1_5355_4F4D),
            6
        )
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巴尔扎罗斯玩家")
    _____5F53_524D_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_72B6_6001 = nil
end
function _____521B_5EFA_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_95E8()
    local _____4F20_9001_914D_7F6E = _____8BFB_53D6_5267_60C5_4F20_9001_914D_7F6E(_____5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_914D_7F6EID)
    if _____4F20_9001_914D_7F6E == nil then
        return
    end
    local _____72B6_6001 = _____5F53_524D_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_72B6_6001 or ({["已传送"] = false})
    _____5F53_524D_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_72B6_6001 = _____72B6_6001
    if _____72B6_6001["已传送"] then
        return
    end
    if not _____53E5_67C4_6709_6548(_____72B6_6001["传送门特效"]) then
        _____72B6_6001["传送门特效"] = _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____6218_540E_4F20_9001_95E8_6A21_578B,
            X = _____4F20_9001_914D_7F6E["入口中心X"],
            Y = _____4F20_9001_914D_7F6E["入口中心Y"],
            ["Z轴角度"] = 270,
            ["缩放"] = 1
        })
    end
    if _____72B6_6001["取消剧情传送注册"] ~= nil then
        return
    end
    _____72B6_6001["取消剧情传送注册"] = _____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001(_____5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_914D_7F6EID, {["读取玩家英雄组"] = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4, ["允许进入单位"] = _____5DF4_5C14_624E_7F57_65AF_6218_540E_5141_8BB8_8FDB_5165, ["完成"] = _____5B8C_6210_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001})
end
function _____6E05_7406_5DF4_5C14_624E_7F57_65AF_8303_56F4_76D1_542C(_____72B6_6001)
    if _____72B6_6001["取消范围监听"] ~= nil then
        _____72B6_6001["取消范围监听"]()
    end
    _____72B6_6001["取消范围监听"] = nil
end
function _____64AD_653E_5DF4_5C14_624E_7F57_65AF_6218_540E_627F_63A5(_____89E6_53D1_5355_4F4D)
    local ____require_result_16 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_16["播放主线剧情片段"]
    return _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("molten_realm_balzaroth_aftermath", {["片段ID"] = "molten_realm_balzaroth_aftermath", ["触发配置名"] = "巴尔扎罗斯死亡后的火焰神殿承接", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
function ____on_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____72B6_6001 = _____5F53_524D_5DF4_5C14_624E_7F57_65AF_524D_5BFC_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["Boss单位"] ~= dyingUnit then
        return
    end
    local _____73A9_5BB6_5355_4F4D = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巴尔扎罗斯玩家")
    _____6E05_7406_5DF4_5C14_624E_7F57_65AF_8303_56F4_76D1_542C(_____72B6_6001)
    if _____5DF2_6CE8_518C_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1_76D1_542C then
        unregisterDeathListener(____on_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1)
        _____5DF2_6CE8_518C_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1_76D1_542C = false
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巴尔扎罗斯")
    YDUserDataClearSafe("string", "Boss", "熔岩恶魔王", "unit")
    _____5F53_524D_5DF4_5C14_624E_7F57_65AF_524D_5BFC_72B6_6001 = nil
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 42 then
        return
    end
    _____8FD4_56DE_5DF4_5C14_624E_7F57_65AF_89E6_53D1_533A_57DF()
    _____8FDB_5165_4E3B_7EBF_8282_70B9(43)
    _____542F_7528_7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_524D_5BFC_533A_57DF_80CC_666F_97F3_4E50()
    if not _____64AD_653E_5DF4_5C14_624E_7F57_65AF_6218_540E_627F_63A5(_____73A9_5BB6_5355_4F4D) then
        _____521B_5EFA_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_95E8()
        _____6267_884C_51C6_5907_83F2_5C3C_514B_65AF_5C14_73B0_8EAB()
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataClearSafe = ____require_result_0.YDUserDataClearSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_0.YDWEAngleBetweenUnitsSafe
local ____require_result_1 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____require_result_1["创建并冻结剧情Boss预置"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_2["暂停并设置无敌安全"]
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_3.IsUnitAliveBJ
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_4.registerOneShotUnitRangeListener
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
unregisterDeathListener = ____require_result_5.unregisterDeathListener
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
_____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_6["是玩家英雄组单位"]
local ____require_result_7 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
_____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_7["获取玩家英雄单位组"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("系统.07．地形系统.03．区域传送")
_____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001 = ____require_result_9["注册剧情配置传送"]
_____8BFB_53D6_5267_60C5_4F20_9001_914D_7F6E = ____require_result_9["读取剧情传送配置"]
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
StarOther_PanCameraToTimedForPlayer = ____require_result_10.StarOther_PanCameraToTimedForPlayer
local ____require_result_11 = require("系统.09．表现系统.14．镜头高度控制.index")
_____6309_6B65_957F_8C03_6574_73A9_5BB6_955C_5934_9AD8_5EA6 = ____require_result_11["按步长调整玩家镜头高度"]
local ____require_result_12 = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐")
_____542F_7528_7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_524D_5BFC_533A_57DF_80CC_666F_97F3_4E50 = ____require_result_12["启用第三章亚伦柯斯前导区域背景音乐"]
DestroyEffect = jass.DestroyEffect
ForGroup = jass.ForGroup
GetEnumUnit = jass.GetEnumUnit
GetOwningPlayer = jass.GetOwningPlayer
local Player = jass.Player
SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
SetUnitPosition = jass.SetUnitPosition
local ShowUnit = jass.ShowUnit
IssueImmediateOrder = jass.IssueImmediateOrder
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local ____Boss_952E = "Boss.熔岩恶魔王"
local ____Boss_540D = "熔岩恶魔王·巴尔扎罗斯"
local ____Boss_5F85_6218_6682_505C_6765_6E90 = "剧情系统:巴尔扎罗斯待战"
local ____Boss_4F4D_7F6E = {X = 28640, Y = -3734.5, ["朝向"] = 270}
_____6218_540E_8FD4_56DE_4F4D_7F6E = {X = 28263.5, Y = 1946.2, ["朝向"] = 270}
local ____Boss_8FDB_5165_8303_56F4 = 1600
_____5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_914D_7F6EID = "jlc_balzaroth_aftermath"
_____6218_540E_4F20_9001_95E8_6A21_578B = "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl"
local _____4E0B_4E00_4EE3_5DF4_5C14_624E_7F57_65AF_524D_5BFC_4E16_4EE3 = 0
_____5DF2_6CE8_518C_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1_76D1_542C = false
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit)
end
local function _____64AD_653E_5DF4_5C14_624E_7F57_65AF_524D_5BFC(_____89E6_53D1_5355_4F4D)
    _____5E94_7528_7B2C_4E09_7AE0_7535_5F71_955C_5934(42)
    local ____require_result_13 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_13["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("molten_realm_balzaroth_intro", {["片段ID"] = "molten_realm_balzaroth_intro", ["触发配置名"] = "巴尔扎罗斯旧熔炉门入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function ____on_5DF4_5C14_624E_7F57_65AF_8303_56F4_89E6_53D1(_____89E6_53D1_5355_4F4D)
    local _____72B6_6001 = _____5F53_524D_5DF4_5C14_624E_7F57_65AF_524D_5BFC_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已触发前导"] or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 42 then
        return false
    end
    if not _____5355_4F4D_5B58_6D3B(_____89E6_53D1_5355_4F4D) then
        return false
    end
    _____72B6_6001["已触发前导"] = true
    _____6E05_7406_5DF4_5C14_624E_7F57_65AF_8303_56F4_76D1_542C(_____72B6_6001)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巴尔扎罗斯玩家", _____89E6_53D1_5355_4F4D)
    SetUnitFacing(
        _____72B6_6001["Boss单位"],
        YDWEAngleBetweenUnitsSafe(_____72B6_6001["Boss单位"], _____89E6_53D1_5355_4F4D)
    )
    SetUnitFacing(
        _____89E6_53D1_5355_4F4D,
        YDWEAngleBetweenUnitsSafe(_____89E6_53D1_5355_4F4D, _____72B6_6001["Boss单位"])
    )
    _____64AD_653E_5DF4_5C14_624E_7F57_65AF_524D_5BFC(_____89E6_53D1_5355_4F4D)
    return true
end
local function _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_8303_56F4_76D1_542C(_____72B6_6001)
    _____72B6_6001["取消范围监听"] = registerOneShotUnitRangeListener(_____72B6_6001["Boss单位"], ____Boss_8FDB_5165_8303_56F4, ____on_5DF4_5C14_624E_7F57_65AF_8303_56F4_89E6_53D1, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
end
local function _____51C6_5907_5DF4_5C14_624E_7F57_65AFBoss()
    local bossUnit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(____Boss_952E)
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        bossUnit = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
            ["Boss键"] = ____Boss_952E,
            ["Boss名"] = ____Boss_540D,
            X = ____Boss_4F4D_7F6E.X,
            Y = ____Boss_4F4D_7F6E.Y,
            ["朝向"] = ____Boss_4F4D_7F6E["朝向"],
            ["预创建后暂停"] = false,
            ["预创建后无敌"] = false
        })
    end
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        return nil
    end
    ShowUnit(bossUnit, true)
    SetUnitOwner(
        bossUnit,
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        true
    )
    SetUnitPosition(bossUnit, ____Boss_4F4D_7F6E.X, ____Boss_4F4D_7F6E.Y)
    SetUnitFacing(bossUnit, ____Boss_4F4D_7F6E["朝向"])
    IssueImmediateOrder(bossUnit, "stop")
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(bossUnit, ____Boss_5F85_6218_6682_505C_6765_6E90)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巴尔扎罗斯", bossUnit)
    return bossUnit
end
____exports["执行准备巴尔扎罗斯前导"] = function()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 42 then
        return
    end
    if _____5F53_524D_5DF4_5C14_624E_7F57_65AF_524D_5BFC_72B6_6001 ~= nil and _____5355_4F4D_5B58_6D3B(_____5F53_524D_5DF4_5C14_624E_7F57_65AF_524D_5BFC_72B6_6001["Boss单位"]) then
        return
    end
    local bossUnit = _____51C6_5907_5DF4_5C14_624E_7F57_65AFBoss()
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    _____4E0B_4E00_4EE3_5DF4_5C14_624E_7F57_65AF_524D_5BFC_4E16_4EE3 = _____4E0B_4E00_4EE3_5DF4_5C14_624E_7F57_65AF_524D_5BFC_4E16_4EE3 + 1
    _____5F53_524D_5DF4_5C14_624E_7F57_65AF_524D_5BFC_72B6_6001 = {["世代"] = _____4E0B_4E00_4EE3_5DF4_5C14_624E_7F57_65AF_524D_5BFC_4E16_4EE3, ["Boss单位"] = bossUnit, ["已触发前导"] = false}
    if not _____5DF2_6CE8_518C_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1_76D1_542C then
        registerDeathListener(____on_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1)
        _____5DF2_6CE8_518C_5DF4_5C14_624E_7F57_65AF_6B7B_4EA1_76D1_542C = true
    end
    _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_8303_56F4_76D1_542C(_____5F53_524D_5DF4_5C14_624E_7F57_65AF_524D_5BFC_72B6_6001)
end
____exports["执行启动巴尔扎罗斯Boss战"] = function(______53C2_6570)
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_14 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巴尔扎罗斯")
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_14 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_14 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(____Boss_952E)
    end
    local bossUnit = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_14
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        return
    end
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_15 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巴尔扎罗斯玩家")
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_15 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_15 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    end
    local _____73A9_5BB6_5355_4F4D = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_15
    _____542F_52A8_5267_60C5Boss_6218(bossUnit, {["触发单位"] = _____73A9_5BB6_5355_4F4D, ["暂停来源"] = ____Boss_5F85_6218_6682_505C_6765_6E90})
end
local function _____6267_884C_51C6_5907_5DF4_5C14_624E_7F57_65AF_524D_5BFC_52A8_4F5C(______53C2_6570)
    ____exports["执行准备巴尔扎罗斯前导"]()
end
____exports["执行开启巴尔扎罗斯战后传送门"] = function(______53C2_6570)
    _____521B_5EFA_5DF4_5C14_624E_7F57_65AF_6218_540E_4F20_9001_95E8()
end
____exports["巴尔扎罗斯前导剧情动作注册表"] = {["第三章_准备巴尔扎罗斯前导"] = _____6267_884C_51C6_5907_5DF4_5C14_624E_7F57_65AF_524D_5BFC_52A8_4F5C, ["第三章_启动巴尔扎罗斯Boss战"] = ____exports["执行启动巴尔扎罗斯Boss战"], ["第三章_开启巴尔扎罗斯战后传送门"] = ____exports["执行开启巴尔扎罗斯战后传送门"]}
return ____exports
