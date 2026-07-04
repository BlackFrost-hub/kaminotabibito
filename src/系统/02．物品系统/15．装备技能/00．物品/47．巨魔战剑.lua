--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却"]
local _____5DE8_9B54_6218_5251_5168_5C40_51B7_5374_952E = "伤害事件装备:巨魔战剑全局"
____exports["处理巨魔战剑强化触发"] = function(ctx)
    if ctx.snapshot == nil or ctx.snapshot.isEnhancedDamage ~= true then
        return
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["巨魔战剑"]) then
        return
    end
    if _____88C5_5907_51B7_5374_4E2D(_____5DE8_9B54_6218_5251_5168_5C40_51B7_5374_952E) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374(_____5DE8_9B54_6218_5251_5168_5C40_51B7_5374_952E, 3)
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(
        ctx.attacker,
        ctx.target,
        _____53D6_6700_5927_751F_547D(ctx.target) * 0.07,
        _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["强化"]
    )
end
return ____exports
