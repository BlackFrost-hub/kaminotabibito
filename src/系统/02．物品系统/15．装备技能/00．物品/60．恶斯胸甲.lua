--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_5F53_524D_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取当前生命"]
local ____16_FF0E_5355_4F4D_65F6_9650_6570_503C = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.16．单位时限数值")
local _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C = ____16_FF0E_5355_4F4D_65F6_9650_6570_503C["创建单位时限数值"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____00_FF0EBuff_7CFB_7EDF["移除单位指定Buff"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_751F_547D_503C = ____require_result_0["减少生命值"]
local ____require_result_1 = require("系统.04．伤害系统.07．持续伤害系统")
local _____5F00_59CB_6301_7EED_4F24_5BB3 = ____require_result_1["开始持续伤害"]
local jass = require("jass.common")
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local _____6076_65AF_80F8_7532_7A97_53E3 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C("恶斯胸甲窗口")
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
    local paidLife = cost > 0 and -_____51CF_5C11_751F_547D_503C(
        unit,
        cost,
        true,
        false,
        nil,
        1
    ) or 0
    if not (paidLife > 0) then
        return
    end
    _____6076_65AF_80F8_7532_7A97_53E3["写入"](unit, paidLife, _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["持续毫秒"] / 1000)
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["恶斯胸甲_祭血攻击"],
        _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["持续毫秒"] / 1000,
        _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["触发伤害阈值"],
        {sourceName = "恶斯胸甲", effectValue2 = paidLife * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["后续伤害倍率"]}
    )
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
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(attacker, _____5E38_89C4BuffID["恶斯胸甲_祭血攻击"])
    local target = context.target
    local damage = cost * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["后续伤害倍率"]
    registerManualBuff(
        target,
        _____5E38_89C4BuffID["恶斯胸甲_祭血灼烧"],
        _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["持续毫秒"] / 1000,
        damage,
        {sourceName = "恶斯胸甲"}
    )
    _____5F00_59CB_6301_7EED_4F24_5BB3({
        ["来源"] = attacker,
        ["目标"] = target,
        ["总伤害"] = damage,
        ["持续秒数"] = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["持续毫秒"] / 1000,
        ["间隔秒数"] = 1,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        ranged = true,
        ["选项"] = {["来源类型"] = "装备持续伤害", ["装备技能类型"] = "装备持续伤害", ["伤害形态"] = "单体", ["标签"] = "恶斯胸甲"}
    })
    return context.currentDamage * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["伤害提升倍率"]
end
return ____exports
