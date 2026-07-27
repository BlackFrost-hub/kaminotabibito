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
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local ____07_FF0E_4E0A_4E0B_6587_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.07．上下文弹幕")
local _____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55 = ____07_FF0E_4E0A_4E0B_6587_5F39_5E55["创建带上下文原生弹幕"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index")
local _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9 = ____require_result_0["创建追踪插值轨迹"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_1["施加扩展控制"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local function _____5080_5CA9_6756_547D_4E2D(event)
    local ctx = event["上下文"]
    local _____547D_4E2D_5355_4F4D = event["命中单位"]
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx["来源"], _____547D_4E2D_5355_4F4D, 100, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["魔法"])
    _____65BD_52A0_6269_5C55_63A7_5236(ctx["来源"], _____547D_4E2D_5355_4F4D, "stun", {["持续时间"] = 0.5, ["效果来源名称"] = "傀岩杖", ["效果来源类型"] = "装备"})
end
____exports["处理傀岩杖受伤"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["傀岩杖"]) then
        return
    end
    if ctx.attacker == nil or ctx.attacker == 0 then
        return
    end
    if ctx.applied < _____53D6_6700_5927_751F_547D(ctx.target) * 0.1 then
        return
    end
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(ctx.target, "傀岩杖", "伤害事件装备")
    if _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(_____51B7_5374_952E, 5, ctx.target, "傀岩杖")
    _____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55({
        ["上下文"] = {["来源"] = ctx.target, ["目标"] = ctx.attacker},
        ["命中后清理"] = true,
        ["on命中"] = _____5080_5CA9_6756_547D_4E2D,
        ["弹幕参数"] = {
            ["所有者"] = ctx.target,
            X = GetUnitX(ctx.target),
            Y = GetUnitY(ctx.target),
            ["方向角"] = GetUnitFacing(ctx.target),
            ["指定目标"] = ctx.attacker,
            ["速度"] = 900,
            ["轨迹采样器"] = _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9(ctx.attacker, 100),
            ["命中半径"] = 100,
            ["生命周期"] = 6,
            ["碰撞消失"] = true,
            ["最大距离"] = 5000,
            ["模型"] = "Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl",
            ["附着特效模型"] = "Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl",
            ["影响目标"] = "全部",
            ["最大总命中次数"] = 1,
            ["每单位最大命中次数"] = 1
        }
    })
end
return ____exports
