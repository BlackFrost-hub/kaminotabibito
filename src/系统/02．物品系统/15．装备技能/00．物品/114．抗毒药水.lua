--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_53E5_67C4ID = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取句柄ID"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_5C5E_6027_62A4_76FE = ____require_result_1["开始属性护盾"]
local _____6297_6BD2_836F_6C34ID = _____7269_54C1_4F7F_7528_88C5_5907ID["抗毒药水"]
local _____6297_6BD2_836F_6C34_914D_7F6E = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["抗毒药水"]
local _____51B7_5374_5230_671F_65F6_95F4 = {}
____exports["处理抗毒药水使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____6297_6BD2_836F_6C34ID) then
        return
    end
    local unit = ctx["施法单位"]
    local hid = _____53D6_53E5_67C4ID(unit)
    if hid == 0 then
        return
    end
    local now = getServerTime()
    local cooldownEnd = _____51B7_5374_5230_671F_65F6_95F4[hid] or 0
    if cooldownEnd > now then
        return
    end
    _____51B7_5374_5230_671F_65F6_95F4[hid] = now + _____6297_6BD2_836F_6C34_914D_7F6E["冷却毫秒"]
    _____5F00_59CB_5C5E_6027_62A4_76FE(unit, "毒", {
        ["数值"] = _____6297_6BD2_836F_6C34_914D_7F6E["护盾值"],
        ["持续时间"] = _____6297_6BD2_836F_6C34_914D_7F6E["持续时间"],
        ["来源单位"] = unit,
        ["显示护盾条"] = true,
        ["可驱散"] = false,
        ["标签"] = "物品:抗毒药水"
    })
end
return ____exports
