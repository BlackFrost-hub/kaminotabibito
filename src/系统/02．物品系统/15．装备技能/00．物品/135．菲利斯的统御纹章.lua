--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____4E34_65F6_73A9_5BB6_5C5E_6027 = ____07_FF0E_88C5_5907_8F85_52A9["临时玩家属性"]
local _____53D6_8303_56F4_53CB_65B9 = ____07_FF0E_88C5_5907_8F85_52A9["取范围友方"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local _____88C5_5907_5C0F_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["装备小特效"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local function ____on_83F2_5229_65AF_7684_7EDF_5FA1_7EB9_7AE0_89E6_53D1(event)
    local attacker = event["攻击者"]
    local allies = _____53D6_8303_56F4_53CB_65B9(attacker, 650)
    do
        local i = 0
        while i < #allies do
            _____4E34_65F6_73A9_5BB6_5C5E_6027(allies[i + 1], "魔法伤害", 0.1, 6)
            registerManualBuff(
                allies[i + 1],
                _____5E38_89C4BuffID["菲利斯的统御纹章_统御号令"],
                6,
                10,
                {sourceUnit = attacker, effectSourceName = "菲利斯的统御纹章", effectSourceType = "装备", iconOverride = "Equipment\\Icon\\Item\\phyllis_command_emblem.blp"}
            )
            _____64AD_653E_5355_4F4D_7279_6548(_____88C5_5907_5C0F_7279_6548["护盾闪光"], allies[i + 1], "origin", 0.8)
            i = i + 1
        end
    end
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "菲利斯的统御纹章",
    ["装备名"] = _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["菲利斯的统御纹章"],
    ["伤害过滤"] = "技能",
    ["冷却秒数"] = 10,
    ["冷却前缀"] = "第二章后段Boss战利品",
    ["要求双方存活"] = false,
    ["on触发"] = ____on_83F2_5229_65AF_7684_7EDF_5FA1_7EB9_7AE0_89E6_53D1
})
return ____exports
