--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____83B7_53D6_8303_56F4_53CB_519B = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围友军"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____4E34_65F6_8C03_6574_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["临时调整攻击"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____56DE_9000_961F_5217 = {}
local function _____56DE_9000_7CBE_7075_53F7_89D2_52A0_6210()
    local item = table.remove(_____56DE_9000_961F_5217, 1)
    if item == nil then
        return
    end
    _____4E34_65F6_8C03_6574_653B_51FB(item["单位"], -item["攻击"])
end
____exports["处理精灵号角使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["精灵号角"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["号角"]
    local unit = ctx["施法单位"]
    local count = #_____83B7_53D6_8303_56F4_53CB_519B(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        cfg["半径"]
    )
    if count <= 0 then
        return
    end
    local attack = cfg["精灵号角每单位攻击"] * count
    _____4E34_65F6_8C03_6574_653B_51FB(unit, attack)
    _____56DE_9000_961F_5217[#_____56DE_9000_961F_5217 + 1] = {["单位"] = unit, ["攻击"] = attack}
    addDelayedCallback(cfg["持续毫秒"], _____56DE_9000_7CBE_7075_53F7_89D2_52A0_6210)
end
return ____exports
