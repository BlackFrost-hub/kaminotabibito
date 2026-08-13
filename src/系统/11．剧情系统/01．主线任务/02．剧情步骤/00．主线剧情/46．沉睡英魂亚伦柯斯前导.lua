--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____6E05_7406_4E9A_4F26_67EF_65AF_8303_56F4_76D1_542C, _____6E05_7406_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001, _____6E05_7406_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001, _____8BFB_53D6_4E9A_4F26_67EF_65AF_6218_540E_73A9_5BB6_82F1_96C4_7EC4, _____4E9A_4F26_67EF_65AF_6218_540E_5141_8BB8_8FDB_5165, _____64AD_653E_5C01_5370_6838_5FC3_62B5_8FBE_5BF9_767D, _____5B8C_6210_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001, _____521B_5EFA_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_95E8, ____on_4E9A_4F26_67EF_65AF_6B7B_4EA1, _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168, IsUnitAliveBJ, unregisterDeathListener, _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, _____521B_5EFA_70B9_7279_6548, _____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001, _____8BFB_53D6_5267_60C5_4F20_9001_914D_7F6E, _____6309_6B65_957F_8C03_6574_73A9_5BB6_955C_5934_9AD8_5EA6, _____6E05_7406_83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970, GetOwningPlayer, DestroyEffect, _____4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_914D_7F6EID, _____4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_6A21_578B, _____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001, _____5F53_524D_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_72B6_6001, _____5DF2_64AD_653E_5C01_5370_6838_5FC3_62B5_8FBE_5BF9_767D
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____40_2D50_FF0E_7B2C_4E09_7AE0_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.40-50．第三章电影镜头")
local _____5E94_7528_7B2C_4E09_7AE0_7535_5F71_955C_5934 = ____40_2D50_FF0E_7B2C_4E09_7AE0_7535_5F71_955C_5934["应用第三章电影镜头"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____8FDB_5165_4E3B_7EBF_8282_70B9 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["进入主线节点"]
local ____48_FF0E_5C01_5370_6838_5FC3_573A_666F = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.48．封印核心场景")
local _____5F00_59CB_76D1_542C_5C01_5370_6838_5FC3_5165_53E3 = ____48_FF0E_5C01_5370_6838_5FC3_573A_666F["开始监听封印核心入口"]
local ____50_FF0E_5F02_754C_9690_85CF_6311_6218_5165_53E3 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.50．异界隐藏挑战入口")
local _____521B_5EFA_5B89_5179_9690_85CF_6311_6218 = ____50_FF0E_5F02_754C_9690_85CF_6311_6218_5165_53E3["创建安兹隐藏挑战"]
function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit)
end
function _____6E05_7406_4E9A_4F26_67EF_65AF_8303_56F4_76D1_542C(_____72B6_6001)
    local _____53D6_6D88_8303_56F4_76D1_542C = _____72B6_6001["取消范围监听"]
    if _____53D6_6D88_8303_56F4_76D1_542C ~= nil then
        _____53D6_6D88_8303_56F4_76D1_542C(nil)
    end
    _____72B6_6001["取消范围监听"] = nil
end
function _____6E05_7406_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001(_____72B6_6001)
    _____6E05_7406_4E9A_4F26_67EF_65AF_8303_56F4_76D1_542C(_____72B6_6001)
    if _____72B6_6001["已注册死亡监听"] then
        unregisterDeathListener(____on_4E9A_4F26_67EF_65AF_6B7B_4EA1)
        _____72B6_6001["已注册死亡监听"] = false
    end
    _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____72B6_6001["Boss单位"], ____exports["亚伦柯斯待战暂停来源"])
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.亚伦柯斯")
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.亚伦柯斯玩家")
    if _____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001 == _____72B6_6001 then
        _____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001 = nil
    end
end
function _____6E05_7406_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001()
    local _____72B6_6001 = _____5F53_524D_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_72B6_6001
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["取消传送注册"] ~= nil then
        _____72B6_6001["取消传送注册"]()
    end
    if _____72B6_6001["传送门特效"] ~= nil and _____72B6_6001["传送门特效"] ~= 0 then
        DestroyEffect(_____72B6_6001["传送门特效"])
    end
    _____72B6_6001["取消传送注册"] = nil
    _____72B6_6001["传送门特效"] = nil
    _____5F53_524D_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_72B6_6001 = nil
end
function _____8BFB_53D6_4E9A_4F26_67EF_65AF_6218_540E_73A9_5BB6_82F1_96C4_7EC4()
    return _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
end
function _____4E9A_4F26_67EF_65AF_6218_540E_5141_8BB8_8FDB_5165(unit)
    return _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit)
end
function _____64AD_653E_5C01_5370_6838_5FC3_62B5_8FBE_5BF9_767D(_____89E6_53D1_5355_4F4D)
    if _____5DF2_64AD_653E_5C01_5370_6838_5FC3_62B5_8FBE_5BF9_767D then
        return
    end
    local _____73A9_5BB6_5355_4F4D = _____89E6_53D1_5355_4F4D
    if not _____5355_4F4D_5B58_6D3B(_____73A9_5BB6_5355_4F4D) then
        return
    end
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.封印核心抵达玩家", _____73A9_5BB6_5355_4F4D)
    local ____require_result_11 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_11["播放主线剧情片段"]
    local _____5DF2_64AD_653E = _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("molten_realm_seal_core_arrival", {["片段ID"] = "molten_realm_seal_core_arrival", ["触发配置名"] = "亚伦柯斯战后传送落点", ["触发单位"] = _____73A9_5BB6_5355_4F4D})
    if _____5DF2_64AD_653E then
        _____5DF2_64AD_653E_5C01_5370_6838_5FC3_62B5_8FBE_5BF9_767D = true
    else
        _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.封印核心抵达玩家")
    end
end
function _____5B8C_6210_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001(_____89E6_53D1_5355_4F4D)
    local _____72B6_6001 = _____5F53_524D_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已传送"] then
        return
    end
    _____72B6_6001["已传送"] = true
    _____6E05_7406_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001()
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        _____6309_6B65_957F_8C03_6574_73A9_5BB6_955C_5934_9AD8_5EA6(
            GetOwningPlayer(_____89E6_53D1_5355_4F4D),
            -6
        )
    end
    _____5F00_59CB_76D1_542C_5C01_5370_6838_5FC3_5165_53E3()
    _____64AD_653E_5C01_5370_6838_5FC3_62B5_8FBE_5BF9_767D(_____89E6_53D1_5355_4F4D)
end
function _____521B_5EFA_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_95E8()
    local _____4F20_9001_914D_7F6E = _____8BFB_53D6_5267_60C5_4F20_9001_914D_7F6E(_____4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_914D_7F6EID)
    if _____4F20_9001_914D_7F6E == nil then
        return
    end
    local _____72B6_6001 = _____5F53_524D_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_72B6_6001 or ({["已传送"] = false})
    _____5F53_524D_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_72B6_6001 = _____72B6_6001
    if _____72B6_6001["已传送"] then
        return
    end
    if _____72B6_6001["传送门特效"] == nil or _____72B6_6001["传送门特效"] == 0 then
        _____72B6_6001["传送门特效"] = _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_6A21_578B,
            X = _____4F20_9001_914D_7F6E["入口中心X"],
            Y = _____4F20_9001_914D_7F6E["入口中心Y"],
            Z = 0,
            ["缩放"] = 1
        })
    end
    if _____72B6_6001["取消传送注册"] ~= nil then
        return
    end
    _____72B6_6001["取消传送注册"] = _____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001(_____4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_914D_7F6EID, {["读取玩家英雄组"] = _____8BFB_53D6_4E9A_4F26_67EF_65AF_6218_540E_73A9_5BB6_82F1_96C4_7EC4, ["允许进入单位"] = _____4E9A_4F26_67EF_65AF_6218_540E_5141_8BB8_8FDB_5165, ["完成"] = _____5B8C_6210_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001})
end
function ____on_4E9A_4F26_67EF_65AF_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____72B6_6001 = _____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["Boss单位"] ~= dyingUnit then
        return
    end
    _____6E05_7406_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001(_____72B6_6001)
    _____6E05_7406_83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970()
    _____8FDB_5165_4E3B_7EBF_8282_70B9(48)
    _____521B_5EFA_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_95E8()
    _____521B_5EFA_5B89_5179_9690_85CF_6311_6218()
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_0["暂停并设置无敌安全"]
_____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_0["解除暂停并取消无敌安全"]
local ____require_result_1 = require("lib.扩展函数.BJ函数.02．单位与英雄")
IsUnitAliveBJ = ____require_result_1.IsUnitAliveBJ
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_2.registerOneShotUnitRangeListener
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
unregisterDeathListener = ____require_result_3.unregisterDeathListener
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
_____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_4["获取玩家英雄单位组"]
_____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_4["是玩家英雄组单位"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local ____require_result_6 = require("系统.07．地形系统.03．区域传送")
_____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001 = ____require_result_6["注册剧情配置传送"]
_____8BFB_53D6_5267_60C5_4F20_9001_914D_7F6E = ____require_result_6["读取剧情传送配置"]
local ____require_result_7 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_7.YDWEAngleBetweenUnitsSafe
local ____require_result_8 = require("系统.07．地形系统.06．可破坏物数据.02．亚伦柯斯与安兹乌尔恭封锁墙")
local _____7F13_5B58_5E76_79FB_9664_4E9A_4F26_67EF_65AF_5B89_5179_5C01_9501_5899 = ____require_result_8["缓存并移除亚伦柯斯安兹封锁墙"]
local _____91CD_5EFA_4E9A_4F26_67EF_65AF_5B89_5179_5C01_9501_5899 = ____require_result_8["重建亚伦柯斯安兹封锁墙"]
local ____require_result_9 = require("系统.09．表现系统.14．镜头高度控制.index")
_____6309_6B65_957F_8C03_6574_73A9_5BB6_955C_5934_9AD8_5EA6 = ____require_result_9["按步长调整玩家镜头高度"]
local ____require_result_10 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.43A．菲尼克斯尔战后地形装饰")
_____6E05_7406_83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970 = ____require_result_10["清理菲尼克斯尔战后地形装饰"]
GetOwningPlayer = jass.GetOwningPlayer
local IssueImmediateOrder = jass.IssueImmediateOrder
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
DestroyEffect = jass.DestroyEffect
____exports["亚伦柯斯Boss键"] = "Boss.沉睡英魂·亚伦柯斯"
____exports["亚伦柯斯待战暂停来源"] = "剧情系统:亚伦柯斯待战"
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____4E9A_4F26_67EF_65AFBoss_540D = "沉睡英魂·亚伦柯斯"
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_9884_7F6E = {X = 8322.9, Y = -14452.7, ["朝向"] = 270}
local _____4E9A_4F26_67EF_65AF_8FDB_5165_8303_56F4 = 1400
_____4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_914D_7F6EID = "jlc_aronkos_aftermath"
_____4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_6A21_578B = "Common\\Effect\\Form\\Portal\\RicketSecretRoomShift.mdx"
_____5DF2_64AD_653E_5C01_5370_6838_5FC3_62B5_8FBE_5BF9_767D = false
local function _____64AD_653E_4E9A_4F26_67EF_65AF_524D_5BFC(_____89E6_53D1_5355_4F4D)
    _____5E94_7528_7B2C_4E09_7AE0_7535_5F71_955C_5934(46)
    local ____require_result_12 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_12["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("molten_realm_aronkos_intro", {["片段ID"] = "molten_realm_aronkos_intro", ["触发配置名"] = "沉睡英魂亚伦柯斯前导范围入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function ____on_4E9A_4F26_67EF_65AF_8303_56F4_89E6_53D1(_____89E6_53D1_5355_4F4D)
    local _____72B6_6001 = _____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已触发对白"] then
        return false
    end
    local _____5F53_524D_8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    if _____5F53_524D_8FDB_5EA6 ~= 45 and _____5F53_524D_8FDB_5EA6 ~= 46 then
        return false
    end
    if not _____5355_4F4D_5B58_6D3B(_____89E6_53D1_5355_4F4D) then
        return false
    end
    _____72B6_6001["已触发对白"] = true
    _____6E05_7406_4E9A_4F26_67EF_65AF_8303_56F4_76D1_542C(_____72B6_6001)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.亚伦柯斯玩家", _____89E6_53D1_5355_4F4D)
    SetUnitFacing(
        _____72B6_6001["Boss单位"],
        YDWEAngleBetweenUnitsSafe(_____72B6_6001["Boss单位"], _____89E6_53D1_5355_4F4D)
    )
    SetUnitFacing(
        _____89E6_53D1_5355_4F4D,
        YDWEAngleBetweenUnitsSafe(_____89E6_53D1_5355_4F4D, _____72B6_6001["Boss单位"])
    )
    _____8FDB_5165_4E3B_7EBF_8282_70B9(46)
    _____64AD_653E_4E9A_4F26_67EF_65AF_524D_5BFC(_____89E6_53D1_5355_4F4D)
    _____91CD_5EFA_4E9A_4F26_67EF_65AF_5B89_5179_5C01_9501_5899(_____72B6_6001["Boss单位"])
    return true
end
local function _____6CE8_518C_4E9A_4F26_67EF_65AF_8303_56F4_76D1_542C(_____72B6_6001)
    _____72B6_6001["取消范围监听"] = registerOneShotUnitRangeListener(_____72B6_6001["Boss单位"], _____4E9A_4F26_67EF_65AF_8FDB_5165_8303_56F4, ____on_4E9A_4F26_67EF_65AF_8303_56F4_89E6_53D1, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
end
local function _____786E_4FDD_4E9A_4F26_67EF_65AF_5F85_6218_5355_4F4D()
    local bossUnit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(____exports["亚伦柯斯Boss键"])
    local _____590D_7528_5DF2_6709_5355_4F4D = true
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        _____590D_7528_5DF2_6709_5355_4F4D = false
        bossUnit = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
            ["Boss键"] = ____exports["亚伦柯斯Boss键"],
            ["Boss名"] = _____4E9A_4F26_67EF_65AFBoss_540D,
            X = _____4E9A_4F26_67EF_65AF_6B63_5F0F_9884_7F6E.X,
            Y = _____4E9A_4F26_67EF_65AF_6B63_5F0F_9884_7F6E.Y,
            ["朝向"] = _____4E9A_4F26_67EF_65AF_6B63_5F0F_9884_7F6E["朝向"],
            ["预创建后暂停"] = true,
            ["预创建后无敌"] = true
        })
    end
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        return nil
    end
    SetUnitOwner(
        bossUnit,
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        true
    )
    SetUnitPosition(bossUnit, _____4E9A_4F26_67EF_65AF_6B63_5F0F_9884_7F6E.X, _____4E9A_4F26_67EF_65AF_6B63_5F0F_9884_7F6E.Y)
    SetUnitFacing(bossUnit, _____4E9A_4F26_67EF_65AF_6B63_5F0F_9884_7F6E["朝向"])
    IssueImmediateOrder(bossUnit, "stop")
    if _____590D_7528_5DF2_6709_5355_4F4D then
        _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(bossUnit, ____exports["亚伦柯斯待战暂停来源"])
    end
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.亚伦柯斯", bossUnit)
    return bossUnit
end
____exports["执行准备亚伦柯斯前导"] = function()
    local _____5F53_524D_8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    if _____5F53_524D_8FDB_5EA6 ~= 45 and _____5F53_524D_8FDB_5EA6 ~= 46 then
        return
    end
    _____7F13_5B58_5E76_79FB_9664_4E9A_4F26_67EF_65AF_5B89_5179_5C01_9501_5899()
    if _____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001 ~= nil and _____5355_4F4D_5B58_6D3B(_____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001["Boss单位"]) then
        return
    end
    if _____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001 ~= nil then
        _____6E05_7406_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001(_____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001)
    end
    local bossUnit = _____786E_4FDD_4E9A_4F26_67EF_65AF_5F85_6218_5355_4F4D()
    if not _____5355_4F4D_5B58_6D3B(bossUnit) then
        return
    end
    _____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001 = {["Boss单位"] = bossUnit, ["已触发对白"] = false, ["已注册死亡监听"] = true}
    registerDeathListener(____on_4E9A_4F26_67EF_65AF_6B7B_4EA1)
    _____6CE8_518C_4E9A_4F26_67EF_65AF_8303_56F4_76D1_542C(_____5F53_524D_4E9A_4F26_67EF_65AF_524D_5BFC_72B6_6001)
end
____exports["执行准备亚伦柯斯前导动作"] = function(______53C2_6570)
    ____exports["执行准备亚伦柯斯前导"]()
end
____exports["执行开启亚伦柯斯战后传送门"] = function(______53C2_6570)
    _____521B_5EFA_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001_95E8()
end
____exports["执行清理亚伦柯斯战后传送门"] = function(______53C2_6570)
    _____6E05_7406_4E9A_4F26_67EF_65AF_6218_540E_4F20_9001()
end
____exports["执行清理封印核心抵达对白玩家"] = function(______53C2_6570)
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.封印核心抵达玩家")
end
____exports["沉睡英魂亚伦柯斯前导剧情动作注册表"] = {["第三章_准备亚伦柯斯前导"] = ____exports["执行准备亚伦柯斯前导动作"], ["第三章_开启亚伦柯斯战后传送门"] = ____exports["执行开启亚伦柯斯战后传送门"], ["第三章_清理亚伦柯斯战后传送门"] = ____exports["执行清理亚伦柯斯战后传送门"], ["第三章_清理封印核心抵达对白玩家"] = ____exports["执行清理封印核心抵达对白玩家"]}
return ____exports
