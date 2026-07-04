--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____09_FF0E_88C5_5907_901A_7528_673A_5236 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____6DFB_52A0_5355_76EE_6807_5468_671F_6548_679C = ____09_FF0E_88C5_5907_901A_7528_673A_5236["添加单目标周期效果"]
local function _____6E56_4E4B_9F99_67AA_5468_671F(event)
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(event["来源"], event["目标"], event["数值"], _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["冰冷"])
end
____exports["处理湖之龙枪造成伤害"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["湖之龙枪"]) then
        return
    end
    if ctx.snapshot ~= nil and ctx.snapshot.rawDamageType == _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["冰冷"] then
        return
    end
    _____6DFB_52A0_5355_76EE_6807_5468_671F_6548_679C({
        ["名称"] = "湖之龙枪",
        ["来源"] = ctx.attacker,
        ["目标"] = ctx.target,
        ["数值"] = ctx.applied * 0.02,
        ["持续毫秒"] = 5000,
        ["间隔毫秒"] = 1000,
        ["on周期"] = _____6E56_4E4B_9F99_67AA_5468_671F
    })
end
return ____exports
