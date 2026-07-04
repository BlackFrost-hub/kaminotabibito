--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local _____663E_793A_5355_4F4D_88C5_5907_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["显示单位装备冷却"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.纯跳链系统")
local _____5F00_59CB_7EAF_8DF3_94FE = ____require_result_0["开始纯跳链"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____require_result_1["装备触发概率通过"]
____exports["处理闪电权杖造成伤害"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["闪电权杖"]) then
        return
    end
    if ctx.snapshot == nil or ctx.snapshot.isMagicDamage ~= true then
        return
    end
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(ctx.attacker, "雷锤权杖", "伤害事件装备")
    if _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    if not _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(0.8, ctx.attacker) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(_____51B7_5374_952E, 2, ctx.attacker, "闪电权杖")
    _____663E_793A_5355_4F4D_88C5_5907_51B7_5374(ctx.attacker, "魔力雷锤", _____51B7_5374_952E)
    _____5F00_59CB_7EAF_8DF3_94FE({
        ["起始目标"] = ctx.target,
        ["来源单位"] = ctx.attacker,
        ["模式"] = "伤害",
        ["影响目标"] = "敌方",
        ["最大跳数"] = 5,
        ["每跳最大距离"] = 600,
        ["初始数值"] = 400,
        ["每跳衰减系数"] = 1,
        ["闪电效果代码"] = "CLPB",
        ["闪电持续时间"] = 1
    })
end
return ____exports
