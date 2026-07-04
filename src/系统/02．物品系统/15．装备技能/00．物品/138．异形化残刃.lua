--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有第二章后段Boss战利品"]
local _____662F_6280_80FD_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["是技能伤害"]
local _____53D6_5355_4F4DID = ____07_FF0E_88C5_5907_8F85_52A9["取单位ID"]
local _____6263_9664_5F53_524D_751F_547D_6BD4_4F8B = ____07_FF0E_88C5_5907_8F85_52A9["扣除当前生命比例"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local _____5F02_5F62_5316_80FD_91CF_8868 = {}
local function ____on_5F02_5F62_5316_6B8B_5203_4F24_5BB3_4FEE_6B63(context)
    local result = context.currentDamage
    local attacker = context.attacker
    if not (result > 0) or not _____662F_6280_80FD_4F24_5BB3(context) then
        return result
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(attacker, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["异形化残刃"]) then
        return result
    end
    local id = _____53D6_5355_4F4DID(attacker)
    if id == 0 then
        return result
    end
    local next = (_____5F02_5F62_5316_80FD_91CF_8868[id] or 0) + 1
    if next < 5 then
        _____5F02_5F62_5316_80FD_91CF_8868[id] = next
        return result
    end
    _____5F02_5F62_5316_80FD_91CF_8868[id] = 0
    _____6263_9664_5F53_524D_751F_547D_6BD4_4F8B(attacker, 0.05)
    _____64AD_653E_5355_4F4D_7279_6548("Common\\Effect\\Element\\Dark\\ShadowHitBurst.mdx", context.target, "origin", 0.8)
    return result * 1.3
end
registerDamageModifier(____on_5F02_5F62_5316_6B8B_5203_4F24_5BB3_4FEE_6B63, 29)
return ____exports
