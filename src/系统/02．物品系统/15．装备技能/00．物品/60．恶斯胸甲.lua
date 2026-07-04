--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_5F53_524D_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取当前生命"]
local _____8BBE_7F6E_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["设置生命"]
local _____9020_6210_706B_7130_4F24_5BB3 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["造成火焰伤害"]
local ____09_FF0E_88C5_5907_901A_7528_673A_5236 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C = ____09_FF0E_88C5_5907_901A_7528_673A_5236["创建单位时限数值"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____5EF6_8FDF_6267_884C = ____20_FF0E_7269_54C1_8F85_52A9["延迟执行"]
local _____6076_65AF_80F8_7532_7A97_53E3 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C("恶斯胸甲窗口")
local function _____6267_884C_6076_65AF_80F8_7532_540E_7EED_4F24_5BB3(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
    _____9020_6210_706B_7130_4F24_5BB3(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
end
____exports["处理恶斯胸甲使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["恶斯胸甲"]) then
        return
    end
    local unit = ctx["施法单位"]
    local currentLife = _____53D6_5F53_524D_751F_547D(unit)
    local cost = currentLife * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["当前生命消耗比例"]
    if cost < _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["最低消耗"] then
        cost = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["最低消耗"]
    end
    if cost > currentLife - 1 then
        cost = currentLife - 1
    end
    if cost > 0 then
        _____8BBE_7F6E_751F_547D(unit, currentLife - cost)
    end
    _____6076_65AF_80F8_7532_7A97_53E3["写入"](unit, cost, _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["持续毫秒"] / 1000)
end
____exports["处理恶斯胸甲伤害修正"] = function(context)
    local attacker = context.attacker
    local cost = _____6076_65AF_80F8_7532_7A97_53E3["读取"](attacker)
    if cost == nil then
        return context.currentDamage
    end
    if not (context.currentDamage > _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["触发伤害阈值"]) then
        return context.currentDamage
    end
    _____6076_65AF_80F8_7532_7A97_53E3["清空"](attacker)
    local target = context.target
    local damage = cost * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["后续伤害倍率"]
    _____5EF6_8FDF_6267_884C(
        0,
        function()
            _____6267_884C_6076_65AF_80F8_7532_540E_7EED_4F24_5BB3(attacker, target, damage)
        end
    )
    return context.currentDamage * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["伤害提升倍率"]
end
return ____exports
