--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____83B7_53D6_8303_56F4_654C_4EBA = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围敌人"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____53D6_5355_4F4D_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位攻击"]
local _____5355_4F4D_662F_82F1_96C4 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位是英雄"]
local _____4E34_65F6_8C03_6574_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["临时调整攻击"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6050_60E7 = ____require_result_1["施加恐惧"]
local _____56DE_9000_961F_5217 = {}
local function _____56DE_9000_6076_9B54_94C3_94DB_964D_653B()
    local item = table.remove(_____56DE_9000_961F_5217, 1)
    if item == nil then
        return
    end
    _____4E34_65F6_8C03_6574_653B_51FB(item["单位"], item["攻击"])
end
____exports["处理恶魔铃铛使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["恶魔铃铛"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶魔铃铛"]
    local unit = ctx["施法单位"]
    local enemies = _____83B7_53D6_8303_56F4_654C_4EBA(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        cfg["半径"]
    )
    for ____, enemy in ipairs(enemies) do
        local fearTime = _____5355_4F4D_662F_82F1_96C4(enemy) and cfg["恐惧英雄"] or cfg["恐惧普通"]
        _____65BD_52A0_6050_60E7(unit, enemy, {["持续时间"] = fearTime, ["模式"] = "逃离施法者"})
        local attack = _____53D6_5355_4F4D_653B_51FB(enemy) * cfg["攻击降低比例"]
        _____4E34_65F6_8C03_6574_653B_51FB(enemy, -attack)
        _____56DE_9000_961F_5217[#_____56DE_9000_961F_5217 + 1] = {["单位"] = enemy, ["攻击"] = attack}
        addDelayedCallback(cfg["持续毫秒"], _____56DE_9000_6076_9B54_94C3_94DB_964D_653B)
    end
end
return ____exports
