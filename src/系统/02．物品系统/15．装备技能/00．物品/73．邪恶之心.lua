--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____90AA_6076_4E4B_5FC3_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["邪恶之心配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_751F_547D_503C = ____require_result_1["减少生命值"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_2["单位存活"]
local _____53D6_5F53_524D_751F_547D = ____require_result_2["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____require_result_2["取最大生命"]
local jass = require("jass.common")
local KillUnit = jass.KillUnit
local GetOwningPlayer = jass.GetOwningPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local function ____on_90AA_6076_4E4B_5FC3_5468_671F(unit)
    local amount = _____90AA_6076_4E4B_5FC3_914D_7F6E["固定扣血"] + _____53D6_6700_5927_751F_547D(unit) * _____90AA_6076_4E4B_5FC3_914D_7F6E["最大生命扣血比例"]
    _____51CF_5C11_751F_547D_503C(
        unit,
        amount,
        true,
        true,
        nil,
        1
    )
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return
    end
    if _____53D6_6700_5927_751F_547D(unit) < _____90AA_6076_4E4B_5FC3_914D_7F6E["死亡最小最大生命"] or _____53D6_5F53_524D_751F_547D(unit) < _____90AA_6076_4E4B_5FC3_914D_7F6E["死亡最小当前生命"] then
        KillUnit(unit)
        DisplayTimedTextToPlayer(
            GetOwningPlayer(unit),
            0,
            0,
            20,
            _____90AA_6076_4E4B_5FC3_914D_7F6E["死亡提示"]
        )
    end
end
local function _____521D_59CB_5316_90AA_6076_4E4B_5FC3()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["邪恶之心"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["邪恶之心"], ["间隔毫秒"] = _____90AA_6076_4E4B_5FC3_914D_7F6E["间隔毫秒"], ["周期回调"] = ____on_90AA_6076_4E4B_5FC3_5468_671F})
end
_____521D_59CB_5316_90AA_6076_4E4B_5FC3()
return ____exports
