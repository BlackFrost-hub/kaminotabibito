--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____796D_7940_9762_5177_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["祭祀面具配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_1["减少魔法值"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_2["单位存活"]
local _____53D6_5F53_524D_9B54_6CD5 = ____require_result_2["取当前魔法"]
local _____53D6_6700_5927_9B54_6CD5 = ____require_result_2["取最大魔法"]
local jass = require("jass.common")
local KillUnit = jass.KillUnit
local GetOwningPlayer = jass.GetOwningPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local function ____on_796D_7940_9762_5177_5468_671F(unit)
    local amount = _____796D_7940_9762_5177_914D_7F6E["固定扣蓝"] + _____53D6_6700_5927_9B54_6CD5(unit) * _____796D_7940_9762_5177_914D_7F6E["最大魔法扣蓝比例"]
    _____51CF_5C11_9B54_6CD5_503C(unit, amount, true, false)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return
    end
    if _____53D6_6700_5927_9B54_6CD5(unit) < _____796D_7940_9762_5177_914D_7F6E["死亡最小最大魔法"] or _____53D6_5F53_524D_9B54_6CD5(unit) < _____796D_7940_9762_5177_914D_7F6E["死亡最小当前魔法"] then
        KillUnit(unit)
        DisplayTimedTextToPlayer(
            GetOwningPlayer(unit),
            0,
            0,
            20,
            _____796D_7940_9762_5177_914D_7F6E["死亡提示"]
        )
    end
end
local function _____521D_59CB_5316_796D_7940_9762_5177()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["祭祀面具"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["祭祀面具"], ["间隔毫秒"] = _____796D_7940_9762_5177_914D_7F6E["间隔毫秒"], ["周期回调"] = ____on_796D_7940_9762_5177_5468_671F})
end
_____521D_59CB_5316_796D_7940_9762_5177()
return ____exports
