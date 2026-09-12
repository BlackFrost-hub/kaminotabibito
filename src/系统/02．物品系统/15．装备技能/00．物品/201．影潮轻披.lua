--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____88C5_5907_5C0F_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["装备小特效"]
local _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["祖地秘境战利品装备名"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.04．伤害系统.05．闪避系统.01．闪避核心")
local registerDodgeAppliedFinalDamageListener = ____require_result_0.registerDodgeAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.04．移速提升")
local _____65BD_52A0_79FB_901F_63D0_5347Buff = ____require_result_2["施加移速提升Buff"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____5F71_6F6E_79FB_901F_6BD4_4F8B = 0.2
local _____5F71_6F6E_6301_7EED_79D2 = 1.5
local _____5F71_6F6E_5185_7F6E_51B7_5374_6BEB_79D2 = 1000
local _____5F71_6F6E_4E0B_6B21_53EF_7528 = {}
local _____5F71_6F6E_62AB_98CE_56FE_6807 = "ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Clothes\\BTNShadowTideCloak.blp"
local function ____on_5F71_6F6E_95EA_907F(_source, target, _damage)
    if target == nil or target == 0 then
        return
    end
    if not _____5355_4F4D_6301_6709_88C5_5907(target, _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["影潮轻披"]) then
        return
    end
    local id = GetHandleId(target) or 0
    if id ~= 0 then
        local now = getServerTime()
        if (_____5F71_6F6E_4E0B_6B21_53EF_7528[id] or 0) > now then
            return
        end
        _____5F71_6F6E_4E0B_6B21_53EF_7528[id] = now + _____5F71_6F6E_5185_7F6E_51B7_5374_6BEB_79D2
    end
    _____65BD_52A0_79FB_901F_63D0_5347Buff(target, target, {
        BuffID = _____5E38_89C4BuffID["影潮轻披_影潮"],
        ["持续时间"] = _____5F71_6F6E_6301_7EED_79D2,
        ["基础移速百分比"] = _____5F71_6F6E_79FB_901F_6BD4_4F8B,
        ["图标路径"] = _____5F71_6F6E_62AB_98CE_56FE_6807,
        ["效果来源名称"] = _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["影潮轻披"],
        ["效果来源类型"] = "装备"
    })
    _____64AD_653E_5355_4F4D_7279_6548(
        _____88C5_5907_5C0F_7279_6548["小风爆"],
        target,
        "origin",
        1,
        0.5
    )
end
registerDodgeAppliedFinalDamageListener(____on_5F71_6F6E_95EA_907F)
return ____exports
