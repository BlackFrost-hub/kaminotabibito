--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____4E34_65F6_53D7_5230_6CBB_7597_7387 = ____07_FF0E_88C5_5907_8F85_52A9["临时受到治疗率"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____53D6_8303_56F4_53CB_65B9 = ____07_FF0E_88C5_5907_8F85_52A9["取范围友方"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____53D6_5F53_524D_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取当前生命"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local ____09_FF0E_88C5_5907_901A_7528_673A_5236 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____09_FF0E_88C5_5907_901A_7528_673A_5236["注册最终伤害触发模板"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local function ____on_653B_57CE_53F7_4EE4_5723_5370_89E6_53D1(event)
    local attacker = event["攻击者"]
    local allies = _____53D6_8303_56F4_53CB_65B9(attacker, 650)
    do
        local i = 0
        while i < #allies do
            local unit = allies[i + 1]
            _____4E34_65F6_53D7_5230_6CBB_7597_7387(unit, 0.16, 6)
            registerManualBuff(
                unit,
                _____5E38_89C4BuffID["攻城号令圣印_攻城号令"],
                6,
                16,
                {sourceName = "攻城号令圣印", iconOverride = "Equipment\\Icon\\Item\\siege_command_signet.blp"}
            )
            if _____53D6_5F53_524D_751F_547D(unit) < _____53D6_6700_5927_751F_547D(unit) * 0.5 then
                _____5F00_59CB_901A_7528_62A4_76FE(
                    attacker,
                    unit,
                    850,
                    5,
                    "攻城号令圣印"
                )
            end
            i = i + 1
        end
    end
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "攻城号令圣印",
    ["装备名"] = _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["攻城号令圣印"],
    ["伤害过滤"] = "技能",
    ["冷却秒数"] = 12,
    ["冷却前缀"] = "第二章后段Boss战利品",
    ["要求双方存活"] = false,
    ["on触发"] = ____on_653B_57CE_53F7_4EE4_5723_5370_89E6_53D1
})
return ____exports
