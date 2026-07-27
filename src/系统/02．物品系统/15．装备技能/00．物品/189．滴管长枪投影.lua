--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0E_540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.05．同目标普攻计数触发")
local _____521B_5EFA_540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5668 = ____05_FF0E_540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1["创建同目标普攻计数触发器"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____53D6_653B_51FB_529B = ____07_FF0E_88C5_5907_8F85_52A9["取攻击力"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____6062_590D_751F_547D_9B54_6CD5 = ____07_FF0E_88C5_5907_8F85_52A9["恢复生命魔法"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local function _____6EF4_7BA1_6C72_8840_8FC7_6EE4(e)
    return _____5355_4F4D_6301_6709_88C5_5907(e.source, _____56DBBoss_6218_5229_54C1_88C5_5907_540D["滴管长枪投影"])
end
local function ____on_6EF4_7BA1_6C72_8840_89E6_53D1(e)
    local damage = _____53D6_653B_51FB_529B(e.source) * 0.8 + 220
    local healByDamage = damage * 0.25
    local healCap = _____53D6_6700_5927_751F_547D(e.source) * 0.06
    _____9020_6210_88C5_5907_4F24_5BB3(
        e.source,
        e.target,
        damage,
        _____88C5_5907_4F24_5BB3_7C7B_578B["物理"],
        false,
        nil,
        {["装备技能类型"] = "普攻强化", ["标签"] = "滴管汲血", ["伤害形态"] = "单体"}
    )
    _____6062_590D_751F_547D_9B54_6CD5(e.source, e.source, healByDamage < healCap and healByDamage or healCap)
    registerManualBuff(
        e.target,
        _____5E38_89C4BuffID["滴管长枪投影_鲜血枯竭"],
        8,
        0,
        {sourceUnit = e.source, effectSourceName = "滴管长枪投影", effectSourceType = "装备"}
    )
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["血滴"],
        e.target,
        "overhead",
        8,
        0.2
    )
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["血色冲击"],
        e.target,
        "origin",
        1,
        0.25
    )
end
_____521B_5EFA_540C_76EE_6807_666E_653B_8BA1_6570_89E6_53D1_5668({
    ["名称"] = "滴管长枪投影-滴管汲血",
    ["窗口秒"] = 5,
    ["次数阈值"] = 3,
    ["内置CD秒"] = 8,
    ["冷却作用域"] = "攻击者目标",
    ["仅纯普攻"] = true,
    ["过滤"] = _____6EF4_7BA1_6C72_8840_8FC7_6EE4,
    ["on触发"] = ____on_6EF4_7BA1_6C72_8840_89E6_53D1
})
return ____exports
