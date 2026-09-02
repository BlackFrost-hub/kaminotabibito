--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local SetUnitTimeScale = jass.SetUnitTimeScale
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____require_result_0["播放限时单位动画"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.18．单位动画守护")
local _____521B_5EFA_5355_4F4D_52A8_753B_5B88_62A4 = ____require_result_1["创建单位动画守护"]
local _____505C_6B62_5355_4F4D_52A8_753B_5B88_62A4 = ____require_result_1["停止单位动画守护"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
--- 限时阶段动作：统一恢复 stand 与 1.0 动画速度，避免技能文件直接操作动画状态。
____exports["播放伊蕾娜阶段动作"] = function(_____5355_4F4D, _____52A8_4F5C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____52A8_4F5C == nil then
        return nil
    end
    debugLogForce(
        "伊蕾娜-动作表现",
        "动作",
        "阶段播放",
        "动作名",
        _____52A8_4F5C["名称"]
    )
    return _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = _____5355_4F4D,
        ["动画编号"] = _____52A8_4F5C["索引"],
        ["动画速度"] = _____52A8_4F5C["播放速度"],
        ["持续秒"] = _____52A8_4F5C["持续秒"] > 0 and _____52A8_4F5C["持续秒"] or _____52A8_4F5C["原始时长秒"],
        ["恢复动画名"] = "stand",
        ["恢复动画速度"] = 1
    })
end
--- 循环阶段动作：用于扫帚飞行，调用方必须把返回句柄登记进技能实例清理篮子。
____exports["开始伊蕾娜循环动作"] = function(_____5355_4F4D, _____52A8_4F5C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____52A8_4F5C == nil then
        return nil
    end
    debugLogForce(
        "伊蕾娜-动作表现",
        "动作",
        "循环开始",
        "动作名",
        _____52A8_4F5C["名称"]
    )
    SetUnitTimeScale(_____5355_4F4D, _____52A8_4F5C["播放速度"])
    return _____521B_5EFA_5355_4F4D_52A8_753B_5B88_62A4({
        ["单位"] = _____5355_4F4D,
        ["动画编号"] = _____52A8_4F5C["索引"],
        ["间隔秒"] = _____52A8_4F5C["原始时长秒"],
        ["立即播放"] = true,
        ["死亡时清理"] = true,
        ["调试名"] = "伊蕾娜-" .. _____52A8_4F5C["名称"]
    })
end
____exports["停止伊蕾娜循环动作"] = function(_____53E5_67C4)
    debugLogForce("伊蕾娜-动作表现", "动作", "循环停止")
    if _____53E5_67C4 ~= nil and _____53E5_67C4["单位"] ~= nil and _____53E5_67C4["单位"] ~= 0 then
        SetUnitTimeScale(_____53E5_67C4["单位"], 1)
    end
    _____505C_6B62_5355_4F4D_52A8_753B_5B88_62A4(_____53E5_67C4)
end
return ____exports
