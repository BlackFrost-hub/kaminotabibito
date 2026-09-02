--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.00．配置")
local _____585E_8389_4E9A_514B_83B1_5C14_6A21_578B_52A8_4F5C_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔模型动作配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_52A8_4F5C_69FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔动作槽配置"]
local jass = require("jass.common")
--- 本封装内部恢复速度专用；对外仍只暴露具名接口。
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____require_result_0["播放限时单位动画"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.18．单位动画守护")
local _____521B_5EFA_5355_4F4D_52A8_753B_5B88_62A4 = ____require_result_1["创建单位动画守护"]
local _____505C_6B62_5355_4F4D_52A8_753B_5B88_62A4 = ____require_result_1["停止单位动画守护"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local function _____53D6_69FD_914D_7F6E(_____69FD_540D)
    return _____585E_8389_4E9A_514B_83B1_5C14_52A8_4F5C_69FD_914D_7F6E[_____69FD_540D]
end
--- 播放一次限时动作段；持续秒 > 0 时到期自动按公共函数恢复待机与速度。返回句柄供篮子登记。
____exports["播放塞莉亚限时动作"] = function(_____82F1_96C4, _____69FD_540D, _____6301_7EED_79D2)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return nil
    end
    local _____69FD = _____53D6_69FD_914D_7F6E(_____69FD_540D)
    if _____69FD["索引"] == nil then
        return nil
    end
    local _____5B9E_9645_6301_7EED = _____6301_7EED_79D2 ~= nil and _____6301_7EED_79D2 > 0 and _____6301_7EED_79D2 or _____69FD["原始时长秒"] / _____69FD["播放速度"]
    return _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = _____82F1_96C4,
        ["动画编号"] = _____69FD["索引"],
        ["动画速度"] = _____69FD["播放速度"],
        ["持续秒"] = _____5B9E_9645_6301_7EED,
        ["恢复动画编号"] = _____585E_8389_4E9A_514B_83B1_5C14_6A21_578B_52A8_4F5C_914D_7F6E["待机索引"]
    })
end
--- 开始循环保持段（守护周期重放）；返回守护句柄，由技能实例负责 停止塞莉亚循环动作。
____exports["开始塞莉亚循环动作"] = function(_____82F1_96C4, _____69FD_540D)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return nil
    end
    local _____69FD = _____53D6_69FD_914D_7F6E(_____69FD_540D)
    if _____69FD["索引"] == nil then
        return nil
    end
    return _____521B_5EFA_5355_4F4D_52A8_753B_5B88_62A4({
        ["单位"] = _____82F1_96C4,
        ["动画编号"] = _____69FD["索引"],
        ["间隔秒"] = _____69FD["原始时长秒"] / _____69FD["播放速度"],
        ["立即播放"] = true,
        ["死亡时清理"] = true,
        ["调试名"] = "塞莉亚-" .. _____69FD_540D
    })
end
--- 停止循环守护并恢复 1.0 动画速度（所有结束路径必须调用）。
____exports["停止塞莉亚循环动作"] = function(_____82F1_96C4, _____5B88_62A4_53E5_67C4)
    if _____5B88_62A4_53E5_67C4 ~= nil then
        _____505C_6B62_5355_4F4D_52A8_753B_5B88_62A4(_____5B88_62A4_53E5_67C4)
    end
    if _____82F1_96C4 ~= nil and _____82F1_96C4 ~= 0 then
        if SetUnitTimeScale ~= nil then
            SetUnitTimeScale(_____82F1_96C4, 1)
        end
        if SetUnitAnimationByIndex ~= nil then
            SetUnitAnimationByIndex(_____82F1_96C4, _____585E_8389_4E9A_514B_83B1_5C14_6A21_578B_52A8_4F5C_914D_7F6E["待机索引"])
        end
    end
end
--- 仅恢复动画速度（无守护句柄时的兜底恢复路径）。
____exports["恢复塞莉亚动画速度"] = function(_____82F1_96C4)
    if _____82F1_96C4 ~= nil and _____82F1_96C4 ~= 0 and SetUnitTimeScale ~= nil then
        SetUnitTimeScale(_____82F1_96C4, 1)
    end
end
return ____exports
