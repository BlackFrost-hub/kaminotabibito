--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_57FA_7840_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.01．基础工具")
local _____914D_7F6E_578B_53D6_653B_51FB_529B = ____01_FF0E_57FA_7840_5DE5_5177["配置型取攻击力"]
local _____914D_7F6E_578B_53D6_529B_91CF = ____01_FF0E_57FA_7840_5DE5_5177["配置型取力量"]
local _____914D_7F6E_578B_53D6_6700_5927_751F_547D = ____01_FF0E_57FA_7840_5DE5_5177["配置型取最大生命"]
____exports["计算配置型攻击效果伤害"] = function(_____914D_7F6E, ctx)
    local fixedDamage = ctx.snapshot ~= nil and ctx.snapshot.isSkillAttack == true and _____914D_7F6E["攻击效果固定伤害"] ~= nil and _____914D_7F6E["攻击效果固定伤害"] or (ctx.snapshot ~= nil and ctx.snapshot.isNormalAttack == true and _____914D_7F6E["普攻固定伤害"] ~= nil and _____914D_7F6E["普攻固定伤害"] or (_____914D_7F6E["固定伤害"] or 0))
    local amount = fixedDamage
    if _____914D_7F6E["攻击系数"] ~= nil then
        amount = amount + _____914D_7F6E_578B_53D6_653B_51FB_529B(ctx.source) * _____914D_7F6E["攻击系数"]
    end
    if _____914D_7F6E["力量系数"] ~= nil then
        amount = amount + _____914D_7F6E_578B_53D6_529B_91CF(ctx.source) * _____914D_7F6E["力量系数"]
    end
    local lifeFactor = _____914D_7F6E["生命系数计算"] ~= nil and _____914D_7F6E["生命系数计算"](ctx) or _____914D_7F6E["生命系数"]
    if lifeFactor ~= nil then
        amount = amount + _____914D_7F6E_578B_53D6_6700_5927_751F_547D(ctx.target) * lifeFactor
    end
    if _____914D_7F6E["伤害倍率"] ~= nil then
        amount = amount + ctx.applied * _____914D_7F6E["伤害倍率"]
    end
    return amount
end
return ____exports
