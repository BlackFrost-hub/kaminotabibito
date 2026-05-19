--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.02．伤害事件状态")
local _____5355_4F4D_51B7_5374_4E2D = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["单位冷却中"]
local _____8BBE_7F6E_5355_4F4D_51B7_5374 = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["设置单位冷却"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
____exports["处理瑞冥戒指造成伤害"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["瑞冥戒指"]) then
        return
    end
    local _____51B7_5374_952E = "瑞冥戒指:" .. tostring(GetHandleId(ctx.attacker))
    if _____5355_4F4D_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    _____8BBE_7F6E_5355_4F4D_51B7_5374(_____51B7_5374_952E, 6)
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx.attacker, ctx.target, 2000, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["火焰"])
end
return ____exports
