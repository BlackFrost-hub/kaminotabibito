--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["播放单位特效"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____require_result_0 = require("lib.扩展函数.物品相关函数.物品累伤次数函数")
local _____5355_4F4D_7269_54C1_7D2F_4F24_6B21_6570 = ____require_result_0["单位物品累伤次数"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_1.getEnemyUnitsInRange
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_2["施加扩展控制"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
____exports["处理异雷法袍受伤"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["异雷法袍"]) then
        return
    end
    local _____8FBE_5230 = _____5355_4F4D_7269_54C1_7D2F_4F24_6B21_6570(
        ctx.target,
        "异雷法袍",
        1,
        1,
        30,
        {["达到阈值后重置"] = true}
    )
    if not _____8FBE_5230 then
        return
    end
    local x = GetUnitX(ctx.target)
    local y = GetUnitY(ctx.target)
    local _____654C_4EBA = getEnemyUnitsInRange(ctx.target, x, y, 500)
    do
        local i = 0
        while i < #_____654C_4EBA do
            local _____76EE_6807 = _____654C_4EBA[i + 1]
            _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx.target, _____76EE_6807, 1000, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["闪电"])
            _____65BD_52A0_6269_5C55_63A7_5236(ctx.target, _____76EE_6807, "stun", {["持续时间"] = 1})
            _____64AD_653E_5355_4F4D_7279_6548(_____76EE_6807, "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl", "origin")
            i = i + 1
        end
    end
end
return ____exports
