--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0E_4E8B_4EF6_53E0_5C42_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.05．事件叠层状态")
local _____521B_5EFA_4E8B_4EF6_53E0_5C42_72B6_6001 = ____05_FF0E_4E8B_4EF6_53E0_5C42_72B6_6001["创建事件叠层状态"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["施加临时属性效果"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____53D6_5F53_524D_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local _____8840_6676
_____8840_6676 = _____521B_5EFA_4E8B_4EF6_53E0_5C42_72B6_6001({
    ["状态ID"] = "真祖女武神血铠-血晶",
    ["最大层数"] = 3,
    ["触发来源"] = "受到伤害",
    ["内置CD秒"] = 2,
    ["持续模式"] = "刷新持续时间",
    ["层持续秒"] = 12,
    ["过滤事件"] = function(e)
        local ____temp_2 = _____5355_4F4D_6301_6709_88C5_5907(e["单位"], _____56DBBoss_6218_5229_54C1_88C5_5907_540D["真祖女武神血铠"]) and (e["伤害值"] or 0) >= _____53D6_6700_5927_751F_547D(e["单位"]) * 0.06
        if ____temp_2 then
            local ____opt_0 = e["伤害快照"]
            if ____opt_0 ~= nil then
                ____opt_0 = ____opt_0.isDotDamage
            end
            ____temp_2 = ____opt_0 ~= true
        end
        local ____temp_2_5 = ____temp_2
        if ____temp_2_5 then
            local ____opt_3 = e["伤害快照"]
            if ____opt_3 ~= nil then
                ____opt_3 = ____opt_3.isReflectedDamage
            end
            ____temp_2_5 = ____opt_3 ~= true
        end
        local ____temp_2_5_8 = ____temp_2_5
        if ____temp_2_5_8 then
            local ____opt_6 = e["伤害快照"]
            if ____opt_6 ~= nil then
                ____opt_6 = ____opt_6.isDamageTransfer
            end
            ____temp_2_5_8 = ____opt_6 ~= true
        end
        local ____temp_2_5_8_11 = ____temp_2_5_8
        if ____temp_2_5_8_11 then
            local ____opt_9 = e["伤害快照"]
            if ____opt_9 ~= nil then
                ____opt_9 = ____opt_9.isEquipmentSkillDamage
            end
            ____temp_2_5_8_11 = ____opt_9 ~= true
        end
        return ____temp_2_5_8_11
    end,
    ["on事件触发"] = function(e, newLayers)
        _____64AD_653E_5355_4F4D_7279_6548(
            _____56DBBoss_88C5_5907_7279_6548["血晶球壳"],
            e["单位"],
            "origin",
            1,
            0.22
        )
        if _____53D6_5F53_524D_751F_547D(e["单位"]) / _____53D6_6700_5927_751F_547D(e["单位"]) > 0.35 then
            return
        end
        local layers = _____8840_6676["消耗全部"](_____8840_6676, e["单位"], "血宴武装")
        if layers <= 0 then
            return
        end
        _____5F00_59CB_901A_7528_62A4_76FE(
            e["单位"],
            e["单位"],
            _____53D6_6700_5927_751F_547D(e["单位"]) * (0.05 + layers * 0.04),
            6,
            "血宴武装"
        )
        _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(e["单位"], 6000, {{["类型"] = "攻速", ["数值"] = layers * 0.18}})
        _____64AD_653E_5355_4F4D_7279_6548(
            _____56DBBoss_88C5_5907_7279_6548["血晶重构"],
            e["单位"],
            "origin",
            1.5,
            0.32
        )
    end
})
return ____exports
