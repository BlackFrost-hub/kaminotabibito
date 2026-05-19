local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.02．伤害事件状态")
local _____5355_4F4D_51B7_5374_4E2D = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["单位冷却中"]
local _____8BBE_7F6E_5355_4F4D_51B7_5374 = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["设置单位冷却"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_0["创建原生弹幕"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index")
local _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9 = ____require_result_1["创建追踪插值轨迹"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_2["施加扩展控制"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local _____5080_5CA9_6756_5F39_5E55_8868 = {}
local function _____5080_5CA9_6756_547D_4E2D(_____547D_4E2D_5355_4F4D, _____5F39_5E55ID)
    local ctx = _____5080_5CA9_6756_5F39_5E55_8868[_____5F39_5E55ID]
    if ctx == nil then
        return
    end
    __TS__Delete(_____5080_5CA9_6756_5F39_5E55_8868, _____5F39_5E55ID)
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx["来源"], _____547D_4E2D_5355_4F4D, 100, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["强化"])
    _____65BD_52A0_6269_5C55_63A7_5236(ctx["来源"], _____547D_4E2D_5355_4F4D, "stun", {["持续时间"] = 0.5})
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
    local _____51B7_5374_952E = "傀岩杖:" .. tostring(GetHandleId(ctx.target))
    if _____5355_4F4D_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    _____8BBE_7F6E_5355_4F4D_51B7_5374(_____51B7_5374_952E, 5)
    local _____5B9E_4F8B = _____521B_5EFA_539F_751F_5F39_5E55({
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
        ["每单位最大命中次数"] = 1,
        ["on命中"] = _____5080_5CA9_6756_547D_4E2D,
        ["on命中单位"] = _____5080_5CA9_6756_547D_4E2D
    })
    if _____5B9E_4F8B ~= nil and _____5B9E_4F8B["弹幕ID"] ~= nil then
        _____5080_5CA9_6756_5F39_5E55_8868[_____5B9E_4F8B["弹幕ID"]] = {["来源"] = ctx.target, ["目标"] = ctx.attacker}
    end
end
return ____exports
