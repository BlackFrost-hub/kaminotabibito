--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local _____53D6_53E5_67C4ID = ____01_FF0E_5171_4EAB["取句柄ID"]
local ____02_FF0E_6CE8_518C_8868 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.02．注册表")
local _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B = ____02_FF0E_6CE8_518C_8868["获取原生弹幕实例"]
local _____5355_4F4D_5230_539F_751F_5F39_5E55ID = ____02_FF0E_6CE8_518C_8868["单位到原生弹幕ID"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.04．驱动.index")
local _____7ED3_675F_539F_751F_5F39_5E55_5B9E_4F8B = ____index["结束原生弹幕实例"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local _____5DF2_6CE8_518C_5F39_5E55_6B7B_4EA1_76D1_542C = false
local function ____on_5F39_5E55_5355_4F4D_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, _____51FB_6740_8005)
    local _____5F39_5E55ID = _____5355_4F4D_5230_539F_751F_5F39_5E55ID[_____53D6_53E5_67C4ID(_____6B7B_4EA1_5355_4F4D)] or 0
    if _____5F39_5E55ID <= 0 then
        return
    end
    local _____5B9E_4F8B = _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B(_____5F39_5E55ID)
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["已结束"] then
        return
    end
    local _____56DE_8C03 = _____5B9E_4F8B["参数"]["on被击落"]
    if _____56DE_8C03 ~= nil then
        local ____51FB_6740_8005_1 = _____51FB_6740_8005
        if ____51FB_6740_8005_1 == nil then
            ____51FB_6740_8005_1 = nil
        end
        _____56DE_8C03(____51FB_6740_8005_1, _____5F39_5E55ID)
    end
    _____7ED3_675F_539F_751F_5F39_5E55_5B9E_4F8B(_____5B9E_4F8B, "单位死亡")
end
____exports["确保弹幕死亡事件监听"] = function()
    if _____5DF2_6CE8_518C_5F39_5E55_6B7B_4EA1_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_5F39_5E55_6B7B_4EA1_76D1_542C = true
    registerDeathListener(____on_5F39_5E55_5355_4F4D_6B7B_4EA1)
end
return ____exports
