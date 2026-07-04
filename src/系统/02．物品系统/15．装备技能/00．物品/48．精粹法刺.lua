--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取单位攻击力"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____07_FF0E_4E0A_4E0B_6587_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.07．上下文弹幕")
local _____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55 = ____07_FF0E_4E0A_4E0B_6587_5F39_5E55["创建带上下文原生弹幕"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index")
local _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9 = ____require_result_0["创建追踪插值轨迹"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local function _____7CBE_7CB9_6CD5_523A_547D_4E2D(event)
    local ctx = event["上下文"]
    local _____547D_4E2D_5355_4F4D = event["命中单位"]
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx["来源"], _____547D_4E2D_5355_4F4D, ctx["伤害"], _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["精神"])
end
____exports["处理精粹法刺魔法触发"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["精粹法刺"]) then
        return
    end
    if ctx.snapshot == nil or ctx.snapshot.isNormalAttack == true or ctx.snapshot.isEnhancedDamage == true then
        return
    end
    local _____4F24_5BB3 = _____53D6_5355_4F4D_653B_51FB_529B(ctx.attacker) * 0.1 + 200
    _____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55({
        ["上下文"] = {["来源"] = ctx.attacker, ["目标"] = ctx.target, ["伤害"] = _____4F24_5BB3},
        ["命中后清理"] = true,
        ["on命中"] = _____7CBE_7CB9_6CD5_523A_547D_4E2D,
        ["弹幕参数"] = {
            ["所有者"] = ctx.attacker,
            X = GetUnitX(ctx.attacker),
            Y = GetUnitY(ctx.attacker),
            ["方向角"] = GetUnitFacing(ctx.attacker),
            ["指定目标"] = ctx.target,
            ["速度"] = 1200,
            ["轨迹采样器"] = _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9(ctx.target, 100),
            ["命中半径"] = 100,
            ["生命周期"] = 6,
            ["碰撞消失"] = true,
            ["最大距离"] = 5000,
            ["模型"] = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl",
            ["附着特效模型"] = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl",
            ["影响目标"] = "全部",
            ["最大总命中次数"] = 1,
            ["每单位最大命中次数"] = 1
        }
    })
end
return ____exports
