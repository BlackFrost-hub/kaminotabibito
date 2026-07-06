local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____5355_4F4D_6301_6709_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位持有物品"]
local _____53D6_5F53_524D_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取当前生命"]
local _____53D6_5F53_524D_9B54_6CD5 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取当前魔法"]
local _____53D6_6700_5927_9B54_6CD5 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取最大魔法"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____53D8_66F4_8D44_6E90_503C = ____require_result_1["变更资源值"]
local GetHandleId = jass.GetHandleId
local _____5973_5996_9B54_7532_5F85_7ED3_7B97_8868 = {}
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____538B_4F4E_5973_5996_9B54_7532_8D44_6E90(unit)
    local lifeReduce = _____53D6_5F53_524D_751F_547D(unit) - 1
    if lifeReduce > 0 then
        _____53D8_66F4_8D44_6E90_503C(
            unit,
            -lifeReduce,
            "life",
            true,
            false,
            nil,
            1
        )
    end
    local manaReduce = _____53D6_5F53_524D_9B54_6CD5(unit) - 1
    if manaReduce > 0 then
        _____53D8_66F4_8D44_6E90_503C(
            unit,
            -manaReduce,
            "mana",
            true,
            false,
            nil,
            1
        )
    end
end
local function ____on_5973_5996_9B54_7532_4E3B_52A8_7ED3_675F()
    local now = getServerTime()
    for key in pairs(_____5973_5996_9B54_7532_5F85_7ED3_7B97_8868) do
        do
            local id = __TS__Number(key) or 0
            local state = _____5973_5996_9B54_7532_5F85_7ED3_7B97_8868[id]
            if state == nil or now < state["到期时间"] then
                goto __continue8
            end
            __TS__Delete(_____5973_5996_9B54_7532_5F85_7ED3_7B97_8868, id)
            _____538B_4F4E_5973_5996_9B54_7532_8D44_6E90(state["单位"])
        end
        ::__continue8::
    end
end
____exports["处理女妖魔甲使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["女妖魔甲"]) then
        return
    end
    local unit = ctx["施法单位"]
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["女妖魔甲"]
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, cfg["持续毫秒"], {{["类型"] = "玩家属性", ["属性名"] = "魔法伤害", ["数值"] = cfg["魔法伤害提升"]}})
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["女妖魔甲_完全免疫"],
        cfg["持续毫秒"] / 1000,
        cfg["魔法伤害提升"] * 100,
        {sourceName = "女妖魔甲"}
    )
    local unitId = _____53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    _____5973_5996_9B54_7532_5F85_7ED3_7B97_8868[unitId] = {
        ["单位"] = unit,
        ["到期时间"] = getServerTime() + cfg["持续毫秒"]
    }
    addDelayedCallback(cfg["持续毫秒"], ____on_5973_5996_9B54_7532_4E3B_52A8_7ED3_675F)
end
____exports["处理女妖魔甲伤害修正"] = function(context)
    local target = context.target
    if target == nil or target == 0 then
        return context.currentDamage
    end
    if not _____5355_4F4D_6301_6709_7269_54C1(target, _____7269_54C1_4F7F_7528_88C5_5907ID["女妖魔甲"]) then
        return context.currentDamage
    end
    local maxMana = _____53D6_6700_5927_9B54_6CD5(target)
    if not (maxMana > 0) then
        return context.currentDamage
    end
    local threshold = maxMana * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["女妖魔甲"]["免疫最大魔法比例"]
    return context.currentDamage < threshold and 0 or context.currentDamage
end
return ____exports
