--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local _____662F_6307_5B9A_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["是指定伤害类型"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.index")
local _____662F_5426_666E_901A_654C_4EBA = ____require_result_0["是否普通敌人"]
local jass = require("jass.common")
local GetUnitLevel = jass.GetUnitLevel
____exports["处理沙漠蜥蜴之魂受伤"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["沙漠蜥蜴之魂"]) then
        return
    end
    local _____500D_7387 = _____662F_6307_5B9A_4F24_5BB3_7C7B_578B(ctx.snapshot, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["暗影突袭"]) and 0.4 or 0.2
    _____6267_884C_7269_54C1_6CBB_7597(ctx.target, ctx.target, ctx.applied * _____500D_7387, nil)
end
--- 威压效果：对等级低于25的普通敌人额外造成20%暗属性魔法伤害
____exports["处理沙漠蜥蜴之魂造成伤害"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["沙漠蜥蜴之魂"]) then
        return
    end
    local _____7B49_7EA7 = GetUnitLevel(ctx.target)
    if _____7B49_7EA7 >= 25 then
        return
    end
    if not _____662F_5426_666E_901A_654C_4EBA(ctx.target) then
        return
    end
    local _____989D_5916_4F24_5BB3 = ctx.applied * 0.2
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx.attacker, ctx.target, _____989D_5916_4F24_5BB3, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["暗影突袭"])
end
return ____exports
