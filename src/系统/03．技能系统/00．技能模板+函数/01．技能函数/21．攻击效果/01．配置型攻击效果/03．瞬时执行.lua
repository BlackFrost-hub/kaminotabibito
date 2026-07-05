--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4F24_5BB3_8BA1_7B97 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.02．伤害计算")
local _____8BA1_7B97_914D_7F6E_578B_653B_51FB_6548_679C_4F24_5BB3 = ____02_FF0E_4F24_5BB3_8BA1_7B97["计算配置型攻击效果伤害"]
local ____01_FF0E_57FA_7840_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.01．基础工具")
local _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3 = ____01_FF0E_57FA_7840_5DE5_5177["配置型攻击效果造成伤害"]
local _____914D_7F6E_578B_653B_51FB_6548_679C_51CF_5C11_751F_547D_9B54_6CD5 = ____01_FF0E_57FA_7840_5DE5_5177["配置型攻击效果减少生命魔法"]
local _____914D_7F6E_578B_653B_51FB_6548_679C_6CBB_7597_751F_547D_9B54_6CD5 = ____01_FF0E_57FA_7840_5DE5_5177["配置型攻击效果治疗生命魔法"]
local _____914D_7F6E_578B_5355_4F4D_662F_7CBE_82F1_76EE_6807 = ____01_FF0E_57FA_7840_5DE5_5177["配置型单位是精英目标"]
local _____914D_7F6E_578B_53D6_5F53_524D_751F_547D = ____01_FF0E_57FA_7840_5DE5_5177["配置型取当前生命"]
local _____914D_7F6E_578B_53D6_6700_5927_751F_547D = ____01_FF0E_57FA_7840_5DE5_5177["配置型取最大生命"]
local _____914D_7F6E_578B_53D6_6700_5927_9B54_6CD5 = ____01_FF0E_57FA_7840_5DE5_5177["配置型取最大魔法"]
local _____914D_7F6E_578B_83B7_53D6_654C_65B9_8303_56F4_5355_4F4D = ____01_FF0E_57FA_7840_5DE5_5177["配置型获取敌方范围单位"]
local _____914D_7F6E_578B_65BD_52A0_51FB_98DE = ____01_FF0E_57FA_7840_5DE5_5177["配置型施加击飞"]
local _____914D_7F6E_578B_65BD_52A0_7729_6655 = ____01_FF0E_57FA_7840_5DE5_5177["配置型施加眩晕"]
local function _____53D6_4F24_5BB3_6982_7387(_____914D_7F6E, ctx)
    if _____914D_7F6E["伤害概率计算"] ~= nil then
        return _____914D_7F6E["伤害概率计算"](ctx)
    end
    if _____914D_7F6E["伤害概率"] ~= nil then
        return _____914D_7F6E["伤害概率"]
    end
    return 1
end
local function _____53D6_6CBB_7597_6982_7387(_____914D_7F6E, ctx)
    if _____914D_7F6E["治疗概率计算"] ~= nil then
        return _____914D_7F6E["治疗概率计算"](ctx)
    end
    if _____914D_7F6E["治疗概率"] ~= nil then
        return _____914D_7F6E["治疗概率"]
    end
    return _____53D6_4F24_5BB3_6982_7387(_____914D_7F6E, ctx)
end
____exports["执行配置型单体伤害"] = function(_____914D_7F6E, ctx)
    local amount = _____8BA1_7B97_914D_7F6E_578B_653B_51FB_6548_679C_4F24_5BB3(_____914D_7F6E, ctx)
    _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(
        ctx.source,
        ctx.target,
        amount,
        _____914D_7F6E["伤害类型"],
        {["伤害形态"] = "单体"}
    )
end
____exports["执行配置型额外伤害"] = function(_____914D_7F6E, ctx, _____6982_7387_901A_8FC7)
    local damageChance = _____53D6_4F24_5BB3_6982_7387(_____914D_7F6E, ctx)
    local healChance = _____53D6_6CBB_7597_6982_7387(_____914D_7F6E, ctx)
    local _____8D44_6E90_5077_53D6_540C_65F6_9020_6210_4F24_5BB3 = _____914D_7F6E["固定伤害"] ~= nil or _____914D_7F6E["攻击系数"] ~= nil or _____914D_7F6E["力量系数"] ~= nil or _____914D_7F6E["生命系数"] ~= nil or _____914D_7F6E["生命系数计算"] ~= nil
    if (_____914D_7F6E["效果类型"] ~= "资源偷取" or _____8D44_6E90_5077_53D6_540C_65F6_9020_6210_4F24_5BB3) and damageChance > 0 then
        local amount = _____8BA1_7B97_914D_7F6E_578B_653B_51FB_6548_679C_4F24_5BB3(_____914D_7F6E, ctx)
        if amount > 0 and _____6982_7387_901A_8FC7(damageChance, ctx.source) then
            _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(
                ctx.source,
                ctx.target,
                amount,
                _____914D_7F6E["伤害类型"],
                {["伤害形态"] = "单体"}
            )
        end
    end
    if ((_____914D_7F6E["治疗生命"] or 0) > 0 or (_____914D_7F6E["恢复魔法"] or 0) > 0) and healChance > 0 then
        if _____6982_7387_901A_8FC7(healChance, ctx.source) then
            _____914D_7F6E_578B_653B_51FB_6548_679C_6CBB_7597_751F_547D_9B54_6CD5(ctx.source, ctx.source, _____914D_7F6E["治疗生命"] or 0, _____914D_7F6E["恢复魔法"] or 0)
        end
    end
    if (_____914D_7F6E["抽取生命比例"] or 0) > 0 or (_____914D_7F6E["抽取魔法比例"] or 0) > 0 then
        local life = _____914D_7F6E_578B_53D6_6700_5927_751F_547D(ctx.target) * (_____914D_7F6E["抽取生命比例"] or 0)
        local mana = _____914D_7F6E_578B_53D6_6700_5927_9B54_6CD5(ctx.target) * (_____914D_7F6E["抽取魔法比例"] or 0)
        _____914D_7F6E_578B_653B_51FB_6548_679C_51CF_5C11_751F_547D_9B54_6CD5(ctx.target, life, mana)
        _____914D_7F6E_578B_653B_51FB_6548_679C_6CBB_7597_751F_547D_9B54_6CD5(ctx.source, ctx.source, life, mana)
    end
    if _____914D_7F6E["效果类型"] == "资源偷取" and (_____914D_7F6E["伤害倍率"] or 0) > 0 then
        local steal = ctx.applied * (_____914D_7F6E["伤害倍率"] or 0)
        _____914D_7F6E_578B_653B_51FB_6548_679C_51CF_5C11_751F_547D_9B54_6CD5(ctx.target, 0, steal)
        _____914D_7F6E_578B_653B_51FB_6548_679C_6CBB_7597_751F_547D_9B54_6CD5(ctx.source, ctx.source, steal, 0)
    end
end
____exports["执行配置型范围伤害"] = function(_____914D_7F6E, ctx)
    local radius = _____914D_7F6E["范围"] or 0
    if not (radius > 0) then
        return
    end
    local list = _____914D_7F6E_578B_83B7_53D6_654C_65B9_8303_56F4_5355_4F4D(ctx.source, ctx.target, radius, _____914D_7F6E["范围包含主目标"] == true)
    local amount = _____8BA1_7B97_914D_7F6E_578B_653B_51FB_6548_679C_4F24_5BB3(_____914D_7F6E, ctx)
    local spreadCount = 0
    do
        local i = 0
        while i < #list do
            _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(
                ctx.source,
                list[i + 1],
                amount,
                _____914D_7F6E["伤害类型"],
                {["伤害形态"] = "AOE"}
            )
            spreadCount = spreadCount + 1
            i = i + 1
        end
    end
    if spreadCount > 0 and (_____914D_7F6E["扩散成功主目标伤害倍率"] or 0) > 0 then
        _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(
            ctx.source,
            ctx.target,
            ctx.applied * (_____914D_7F6E["扩散成功主目标伤害倍率"] or 0),
            _____914D_7F6E["伤害类型"],
            {["伤害形态"] = "单体"}
        )
    end
end
____exports["执行配置型低血斩杀"] = function(_____914D_7F6E, ctx)
    local maxLife = _____914D_7F6E_578B_53D6_6700_5927_751F_547D(ctx.target)
    if not (maxLife > 0) then
        return
    end
    local line = _____914D_7F6E_578B_5355_4F4D_662F_7CBE_82F1_76EE_6807(ctx.target) and (_____914D_7F6E["精英斩杀线"] or _____914D_7F6E["普通斩杀线"] or 0) or (_____914D_7F6E["普通斩杀线"] or 0)
    if not (line > 0) then
        return
    end
    if _____914D_7F6E_578B_53D6_5F53_524D_751F_547D(ctx.target) / maxLife > line then
        return
    end
    _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(
        ctx.source,
        ctx.target,
        maxLife,
        _____914D_7F6E["伤害类型"],
        {["伤害形态"] = "单体"}
    )
end
____exports["执行配置型范围击飞"] = function(_____914D_7F6E, ctx)
    local radius = _____914D_7F6E["范围"] or 0
    local list = _____914D_7F6E_578B_83B7_53D6_654C_65B9_8303_56F4_5355_4F4D(ctx.source, ctx.target, radius, true)
    local amount = _____8BA1_7B97_914D_7F6E_578B_653B_51FB_6548_679C_4F24_5BB3(_____914D_7F6E, ctx)
    do
        local i = 0
        while i < #list do
            local unit = list[i + 1]
            _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(
                ctx.source,
                unit,
                amount,
                _____914D_7F6E["伤害类型"],
                {["伤害形态"] = "AOE"}
            )
            _____914D_7F6E_578B_65BD_52A0_51FB_98DE(ctx.source, unit, _____914D_7F6E["持续时间"] or 1.5)
            _____914D_7F6E_578B_65BD_52A0_7729_6655(ctx.source, unit, _____914D_7F6E["持续时间"] or 1.5)
            i = i + 1
        end
    end
end
return ____exports
