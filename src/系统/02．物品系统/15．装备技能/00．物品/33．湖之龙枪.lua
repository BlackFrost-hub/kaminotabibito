--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.02．伤害事件状态")
local _____6DFB_52A0_5468_671F_6548_679C = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["添加周期效果"]
local _____6CE8_518C_5468_671F_6548_679C_5904_7406 = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["注册周期效果处理"]
local _____53D6_5F53_524D_6BEB_79D2 = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["取当前毫秒"]
local _____5DF2_6CE8_518C = false
local function _____6E56_4E4B_9F99_67AA_5468_671F(_____8BB0_5F55)
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(_____8BB0_5F55["来源"], _____8BB0_5F55["目标"], _____8BB0_5F55["数值"], _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["冰冷"])
end
local function _____786E_4FDD_6CE8_518C()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5468_671F_6548_679C_5904_7406("湖之龙枪", _____6E56_4E4B_9F99_67AA_5468_671F)
end
____exports["处理湖之龙枪造成伤害"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["湖之龙枪"]) then
        return
    end
    if ctx.snapshot ~= nil and ctx.snapshot.rawDamageType == _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["冰冷"] then
        return
    end
    _____786E_4FDD_6CE8_518C()
    local _____5F53_524D = _____53D6_5F53_524D_6BEB_79D2()
    _____6DFB_52A0_5468_671F_6548_679C({
        ["类型"] = "湖之龙枪",
        ["来源"] = ctx.attacker,
        ["目标"] = ctx.target,
        ["数值"] = ctx.applied * 0.02,
        ["结束时间"] = _____5F53_524D + 5000,
        ["下次时间"] = _____5F53_524D + 1000,
        ["间隔毫秒"] = 1000
    })
end
return ____exports
