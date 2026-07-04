--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.03．最终伤害触发模板")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____require_result_0["注册最终伤害触发模板"]
local _____51C0_6C34_56DE_54CD_51B7_5374_79D2_6570 = 18
local _____51C0_6C34_56DE_54CD_6062_590D_6BD4_4F8B = 0.05
local _____51C0_6C34_56DE_54CD_7279_6548 = "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl"
local function ____on_7EAF_51C0_6C34_6E90_540A_5760_6700_7EC8_4F24_5BB3(event)
    if not _____5355_4F4D_6709_6548_5B58_6D3B(event["目标"]) then
        return
    end
    _____6267_884C_7269_54C1_6CBB_7597(
        event["目标"],
        event["目标"],
        _____53D6_6700_5927_751F_547D(event["目标"]) * _____51C0_6C34_56DE_54CD_6062_590D_6BD4_4F8B,
        _____51C0_6C34_56DE_54CD_7279_6548,
        0,
        nil,
        true
    )
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "纯净水源吊坠",
    ["装备名"] = "纯净水源吊坠",
    ["持有者"] = "受击者",
    ["要求双方存活"] = false,
    ["冷却秒数"] = _____51C0_6C34_56DE_54CD_51B7_5374_79D2_6570,
    ["冷却标签"] = "纯净水源吊坠:净水回响",
    ["冷却前缀"] = "米亚战利品",
    ["on触发"] = ____on_7EAF_51C0_6C34_6E90_540A_5760_6700_7EC8_4F24_5BB3
})
return ____exports
