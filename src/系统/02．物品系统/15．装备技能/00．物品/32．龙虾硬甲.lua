--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却"]
local jass = require("jass.common")
local GetHeroLevel = jass.GetHeroLevel
____exports["处理龙虾硬甲受伤"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["龙虾硬甲"]) then
        return
    end
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(ctx.target, "龙虾硬甲", "伤害事件装备")
    if _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374(_____51B7_5374_952E, 0.2)
    _____6267_884C_7269_54C1_6CBB_7597(
        ctx.target,
        ctx.target,
        _____53D6_6700_5927_751F_547D(ctx.target) * 0.01 + GetHeroLevel(ctx.target),
        nil
    )
end
return ____exports
