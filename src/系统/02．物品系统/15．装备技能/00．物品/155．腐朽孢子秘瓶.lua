--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_8303_56F4_654C_4EBA = ____07_FF0E_88C5_5907_8F85_52A9["取范围敌人"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____53D6_653B_51FB_529B = ____07_FF0E_88C5_5907_8F85_52A9["取攻击力"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local function ____on_8150_673D_5B62_5B50_79D8_74F6_89E6_53D1(event)
    local target = event["目标"]
    local attacker = event["攻击者"]
    local enemies = _____53D6_8303_56F4_654C_4EBA(attacker, target, 300)
    do
        local i = 0
        while i < #enemies do
            _____9020_6210_88C5_5907_4F24_5BB3(
                attacker,
                enemies[i + 1],
                _____53D6_653B_51FB_529B(attacker) * 0.25,
                _____88C5_5907_4F24_5BB3_7C7B_578B["暗影"]
            )
            i = i + 1
        end
    end
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "腐朽孢子秘瓶",
    ["装备名"] = _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["腐朽孢子秘瓶"],
    ["伤害过滤"] = "技能",
    ["概率"] = 0.12,
    ["冷却秒数"] = 4,
    ["冷却前缀"] = "第二章后段Boss战利品",
    ["要求双方存活"] = false,
    ["on触发"] = ____on_8150_673D_5B62_5B50_79D8_74F6_89E6_53D1
})
return ____exports
