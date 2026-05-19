--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_5355_4F4D_62A4_7532 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取单位护甲"]
local _____968F_673A_5B9E_6570 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["随机实数"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
____exports["处理史诗远古魔刃伤害触发"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["史诗远古魔刃"]) then
        return
    end
    if ctx.snapshot ~= nil and ctx.snapshot.isEnhancedDamage == true then
        return
    end
    local _____66B4_51FB = ctx.snapshot ~= nil and ctx.snapshot.isNormalAttack == true and _____968F_673A_5B9E_6570(0, 1) <= 0.5
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(
        ctx.attacker,
        ctx.target,
        _____53D6_5355_4F4D_62A4_7532(ctx.target) * (_____66B4_51FB and 1.5 or 1),
        _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["强化"]
    )
end
return ____exports
