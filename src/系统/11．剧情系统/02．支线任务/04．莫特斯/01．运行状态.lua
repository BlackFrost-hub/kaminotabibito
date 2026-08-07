--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF = require("系统.11．剧情系统.02．支线任务.04．莫特斯.00．常量")
local _____83AB_7279_65AF_53EF_6E38_73A9_73A9_5BB6_6700_5927ID = ____00_FF0E_5E38_91CF["莫特斯可游玩玩家最大ID"]
local _____83AB_7279_65AF_6A21_5757_540D = ____00_FF0E_5E38_91CF["莫特斯模块名"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_0["是玩家英雄组单位"]
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 = ____require_result_1["广播提示滑入毫秒"]
local _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2 = ____require_result_1["广播提示淡出毫秒"]
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_2.ModifyGateBJ
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetWidgetLife = jass.GetWidgetLife
local IsUnitType = jass.IsUnitType
____exports["莫特斯运行状态"] = {
    ["永久入口已初始化"] = false,
    ["永久入口区域"] = nil,
    ["永久入口触发器"] = nil,
    ["首次入口演出已开始"] = false,
    ["首次入口演出已完成"] = false,
    ["当前入口英雄"] = nil,
    ["当前洞窟守卫"] = nil,
    ["当前暂停小怪"] = {},
    ["莫特斯单位"] = nil,
    ["莫特斯范围触发器"] = nil,
    ["取消莫特斯范围监听"] = nil,
    ["莫特斯对白已触发"] = false,
    ["莫特斯战斗已启动"] = false,
    ["洞窟区域背景音乐已移除"] = false,
    ["莫特斯已经死亡"] = false,
    ["莫特斯死亡监听已注册"] = false
}
____exports["句柄有效"] = function(_____53E5_67C4)
    return _____53E5_67C4 ~= nil and _____53E5_67C4 ~= 0
end
____exports["单位存活"] = function(_____5355_4F4D)
    return ____exports["句柄有效"](_____5355_4F4D) and GetWidgetLife(_____5355_4F4D) > 0.405 and IsUnitType(_____5355_4F4D, jass.UNIT_TYPE_DEAD) ~= true
end
____exports["是莫特斯副本玩家英雄"] = function(_____5355_4F4D)
    if not ____exports["单位存活"](_____5355_4F4D) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____5355_4F4D) then
        return false
    end
    local _____73A9_5BB6ID = GetPlayerId(GetOwningPlayer(_____5355_4F4D))
    return _____73A9_5BB6ID >= 0 and _____73A9_5BB6ID <= _____83AB_7279_65AF_53EF_6E38_73A9_73A9_5BB6_6700_5927ID
end
____exports["取广播完整播放毫秒"] = function(_____505C_7559_6BEB_79D2)
    return _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 + _____505C_7559_6BEB_79D2 + _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2
end
local function _____4FEE_6539_83AB_7279_65AF_6D1E_7A9F_95E8(_____64CD_4F5C, _____64CD_4F5C_540D)
    local _____6D1E_7A9F_95E8 = jglobals.gg_dest_DTg7_5609
    if not ____exports["句柄有效"](_____6D1E_7A9F_95E8) then
        debugLogForce(
            _____83AB_7279_65AF_6A21_5757_540D,
            "洞窟门句柄缺失",
            "name=gg_dest_DTg7_5609",
            "operation=",
            _____64CD_4F5C_540D
        )
        return false
    end
    ModifyGateBJ(_____64CD_4F5C, _____6D1E_7A9F_95E8)
    return true
end
____exports["打开莫特斯洞窟门"] = function()
    return _____4FEE_6539_83AB_7279_65AF_6D1E_7A9F_95E8(jglobals.bj_GATEOPERATION_OPEN, "打开")
end
____exports["关闭莫特斯洞窟门"] = function()
    return _____4FEE_6539_83AB_7279_65AF_6D1E_7A9F_95E8(jglobals.bj_GATEOPERATION_CLOSE, "关闭")
end
return ____exports
