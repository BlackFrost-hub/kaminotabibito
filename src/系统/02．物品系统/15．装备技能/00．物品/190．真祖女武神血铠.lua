--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8840_6676
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____05_FF0E_4E8B_4EF6_53E0_5C42_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.05．事件叠层状态")
local _____521B_5EFA_4E8B_4EF6_53E0_5C42_72B6_6001 = ____05_FF0E_4E8B_4EF6_53E0_5C42_72B6_6001["创建事件叠层状态"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["施加临时属性效果"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local _____8840_5BB4_6B66_88C5_89E6_53D1_751F_547D_6BD4_4F8B = 0.35
local _____8840_6676_83B7_5F97_7279_6548_7F29_653E = 0.066
local function _____8FC7_6EE4_8840_6676_4F24_5BB3(e)
    local ____5355_4F4D_6301_6709_88C5_5907_result_2 = _____5355_4F4D_6301_6709_88C5_5907(e["单位"], _____56DBBoss_6218_5229_54C1_88C5_5907_540D["真祖女武神血铠"])
    if ____5355_4F4D_6301_6709_88C5_5907_result_2 then
        local ____e__4F24_5BB3_503C_1 = e["伤害值"]
        if ____e__4F24_5BB3_503C_1 == nil then
            ____e__4F24_5BB3_503C_1 = 0
        end
        ____5355_4F4D_6301_6709_88C5_5907_result_2 = ____e__4F24_5BB3_503C_1 >= _____53D6_6700_5927_751F_547D(e["单位"]) * 0.06
    end
    local ____5355_4F4D_6301_6709_88C5_5907_result_2_5 = ____5355_4F4D_6301_6709_88C5_5907_result_2
    if ____5355_4F4D_6301_6709_88C5_5907_result_2_5 then
        local ____opt_3 = e["伤害快照"]
        if ____opt_3 ~= nil then
            ____opt_3 = ____opt_3.isDotDamage
        end
        ____5355_4F4D_6301_6709_88C5_5907_result_2_5 = ____opt_3 ~= true
    end
    local ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8 = ____5355_4F4D_6301_6709_88C5_5907_result_2_5
    if ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8 then
        local ____opt_6 = e["伤害快照"]
        if ____opt_6 ~= nil then
            ____opt_6 = ____opt_6.isReflectedDamage
        end
        ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8 = ____opt_6 ~= true
    end
    local ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8_11 = ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8
    if ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8_11 then
        local ____opt_9 = e["伤害快照"]
        if ____opt_9 ~= nil then
            ____opt_9 = ____opt_9.isDamageTransfer
        end
        ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8_11 = ____opt_9 ~= true
    end
    local ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8_11_14 = ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8_11
    if ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8_11_14 then
        local ____opt_12 = e["伤害快照"]
        if ____opt_12 ~= nil then
            ____opt_12 = ____opt_12.isEquipmentSkillDamage
        end
        ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8_11_14 = ____opt_12 ~= true
    end
    return ____5355_4F4D_6301_6709_88C5_5907_result_2_5_8_11_14
end
local function _____540C_6B65_8840_6676Buff(unit, layers)
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["真祖女武神血铠_血晶"],
        12,
        0,
        {sourceUnit = unit, effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["真祖女武神血铠"], effectSourceType = "装备", stack = layers}
    )
end
local function ____on_8840_6676_5C42_6570_53D8_5316(event)
    if event["新层数"] <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(event["单位"], _____5E38_89C4BuffID["真祖女武神血铠_血晶"])
    end
end
local function _____89E6_53D1_8840_5BB4_6B66_88C5(unit)
    local layers = _____8840_6676["消耗全部"](_____8840_6676, unit, "血宴武装")
    if layers <= 0 then
        return
    end
    _____5F00_59CB_901A_7528_62A4_76FE(
        unit,
        unit,
        _____53D6_6700_5927_751F_547D(unit) * (0.05 + layers * 0.04),
        6,
        "血宴武装"
    )
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, 6000, {{["类型"] = "攻速", ["数值"] = layers * 0.18}})
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["血晶重构"],
        unit,
        "origin",
        1.5,
        0.32
    )
end
local function _____8840_5BB4_6B66_88C5_6709_53EF_6D88_8017_8840_6676(event)
    return _____8840_6676["取层数"](_____8840_6676, event["持有者"]) > 0
end
local function ____on_8840_5BB4_6B66_88C5_89E6_53D1(event)
    _____89E6_53D1_8840_5BB4_6B66_88C5(event["持有者"])
end
local function ____on_8840_6676_83B7_5F97(e, newLayers)
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["血晶球壳"],
        e["单位"],
        "origin",
        1,
        _____8840_6676_83B7_5F97_7279_6548_7F29_653E
    )
    _____540C_6B65_8840_6676Buff(e["单位"], newLayers)
end
_____8840_6676 = _____521B_5EFA_4E8B_4EF6_53E0_5C42_72B6_6001({
    ["状态ID"] = "真祖女武神血铠-血晶",
    ["最大层数"] = 3,
    ["触发来源"] = "受到伤害",
    ["内置CD秒"] = 2,
    ["持续模式"] = "刷新持续时间",
    ["层持续秒"] = 12,
    ["on层数变化"] = ____on_8840_6676_5C42_6570_53D8_5316,
    ["过滤事件"] = _____8FC7_6EE4_8840_6676_4F24_5BB3,
    ["on事件触发"] = ____on_8840_6676_83B7_5F97
})
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "真祖女武神血铠-血宴武装",
    ["装备名"] = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["真祖女武神血铠"],
    ["持有者"] = "受击者",
    ["要求双方存活"] = false,
    ["受击后生命比例上限"] = _____8840_5BB4_6B66_88C5_89E6_53D1_751F_547D_6BD4_4F8B,
    ["自定义过滤"] = _____8840_5BB4_6B66_88C5_6709_53EF_6D88_8017_8840_6676,
    ["on触发"] = ____on_8840_5BB4_6B66_88C5_89E6_53D1
})
return ____exports
