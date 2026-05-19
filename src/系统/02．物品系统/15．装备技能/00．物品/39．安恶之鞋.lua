--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____968F_673A_5B9E_6570 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["随机实数"]
local ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.02．伤害事件状态")
local _____5355_4F4D_51B7_5374_4E2D = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["单位冷却中"]
local _____8BBE_7F6E_5355_4F4D_51B7_5374 = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["设置单位冷却"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6050_60E7 = ____require_result_0["施加恐惧"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
____exports["处理安恶之鞋造成伤害"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["安恶之鞋"]) then
        return
    end
    if ctx.applied < _____53D6_6700_5927_751F_547D(ctx.target) * 0.05 then
        return
    end
    local _____51B7_5374_952E = "安恶之鞋:" .. tostring(GetHandleId(ctx.attacker))
    if _____5355_4F4D_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    if _____968F_673A_5B9E_6570(0, 1) > 0.5 then
        return
    end
    _____8BBE_7F6E_5355_4F4D_51B7_5374(_____51B7_5374_952E, 10)
    _____65BD_52A0_6050_60E7(ctx.attacker, ctx.target, {["持续时间"] = 1, ["模式"] = "逃离施法者"})
end
return ____exports
