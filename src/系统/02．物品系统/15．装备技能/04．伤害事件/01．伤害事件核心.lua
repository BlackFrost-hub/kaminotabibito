--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local _____662F_6307_5B9A_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["是指定伤害类型"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前生命"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.02．易伤")
local _____65BD_52A0_6613_4F24 = ____require_result_3["施加易伤"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_5["创建单位并登记排泄安全"]
local _____8C7A_72FC_76AE_7532 = require("系统.02．物品系统.15．装备技能.00．物品.27．豺狼皮甲")
local _____7075_77F3 = require("系统.02．物品系统.15．装备技能.00．物品.28．灵石")
local _____5080_5CA9_6756 = require("系统.02．物品系统.15．装备技能.00．物品.29．傀岩杖")
local _____6C99_6F20_8725_8734_4E4B_9B42 = require("系统.02．物品系统.15．装备技能.00．物品.30．沙漠蜥蜴之魂")
local _____6E56_4E4B_888D = require("系统.02．物品系统.15．装备技能.00．物品.31．湖之袍")
local _____9F99_867E_786C_7532 = require("系统.02．物品系统.15．装备技能.00．物品.32．龙虾硬甲")
local _____6E56_4E4B_9F99_67AA = require("系统.02．物品系统.15．装备技能.00．物品.33．湖之龙枪")
local _____94F6_9B54_624B_5957 = require("系统.02．物品系统.15．装备技能.00．物品.34．银魔手套")
local _____5F02_96F7_6CD5_888D = require("系统.02．物品系统.15．装备技能.00．物品.35．异雷法袍")
local _____6BD2_56CA_9053_5177 = require("系统.02．物品系统.15．装备技能.00．物品.36．毒囊道具")
local _____5730_72F1_706B_5361_724C_9B54_6CD5 = require("系统.02．物品系统.15．装备技能.00．物品.37．地狱火卡牌魔法")
local _____7194_7075_5927_5251 = require("系统.02．物品系统.15．装备技能.00．物品.38．熔灵大剑")
local _____5B89_6076_4E4B_978B = require("系统.02．物品系统.15．装备技能.00．物品.39．安恶之鞋")
local _____7075_5893_4E4B_6212 = require("系统.02．物品系统.15．装备技能.00．物品.40．灵墓之戒")
local _____745E_51A5_6212_6307 = require("系统.02．物品系统.15．装备技能.00．物品.41．瑞冥戒指")
local _____53F2_8BD7_8FDC_53E4_9B54_5203 = require("系统.02．物品系统.15．装备技能.00．物品.42．史诗远古魔刃伤害")
local _____9B54_529B_96F7_9524 = require("系统.02．物品系统.15．装备技能.00．物品.43．魔力雷锤")
local _____95EA_7535_6743_6756 = require("系统.02．物品系统.15．装备技能.00．物品.44．闪电权杖")
local _____65AF_5C14_6CD5_888D = require("系统.02．物品系统.15．装备技能.00．物品.45．斯尔法袍")
local _____950B_5229_5DE8_9B54_722A = require("系统.02．物品系统.15．装备技能.00．物品.46．锋利巨魔爪")
local _____5DE8_9B54_6218_5251 = require("系统.02．物品系统.15．装备技能.00．物品.47．巨魔战剑")
local _____7CBE_7CB9_6CD5_523A = require("系统.02．物品系统.15．装备技能.00．物品.48．精粹法刺")
local _____55DC_72F1_6076_5251 = require("系统.02．物品系统.15．装备技能.00．物品.69．嗜狱恶剑")
local _____7CBE_6C99_6218_65A7 = require("系统.02．物品系统.15．装备技能.00．物品.83．精沙战斧")
local _____6708_5149_9501_94FE_62A4_8155 = require("系统.02．物品系统.15．装备技能.00．物品.133．月光锁链护腕")
local _____5BA1_5224_4E4B_950B_957F_5251 = require("系统.02．物品系统.15．装备技能.00．物品.134．审判之锋长剑")
local ____WPSHJS_8FC1_79FB_6838_5FC3 = require("系统.02．物品系统.15．装备技能.04．伤害事件.02．WPSHJS迁移核心")
local ____B00H_6307_6325BuffID = stringToFourCCSafe("B00H")
local ____B00V_6697_9ED1_4FB5_8680BuffID = stringToFourCCSafe("B00V")
local _____6697_9ED1_4FB5_8680_590D_6D3B_5355_4F4DID = stringToFourCCSafe("e00D")
local _____6697_9ED1_4FB5_8680_590D_6D3B_6280_80FDID = stringToFourCCSafe("A0AB")
local _____5DF2_521D_59CB_5316 = false
local _____6697_9ED1_4FB5_8680_590D_6D3B_961F_5217 = {}
local jass = require("jass.common")
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local UnitAddAbility = jass.UnitAddAbility
local IssueImmediateOrder = jass.IssueImmediateOrder
local function _____5355_4F4D_62E5_6709Buff(unit, buffId)
    if unit == nil or unit == 0 then
        return false
    end
    if not (buffId > 0) then
        return false
    end
    return GetUnitAbilityLevel(unit, buffId) > 0
end
local function _____5904_7406_6307_6325_6613_4F24(ctx)
    if ____B00H_6307_6325BuffID == 0 then
        return
    end
    if ctx.attacker == nil or ctx.attacker == 0 or ctx.target == nil or ctx.target == 0 then
        return
    end
    if not _____5355_4F4D_62E5_6709Buff(ctx.attacker, ____B00H_6307_6325BuffID) then
        return
    end
    _____65BD_52A0_6613_4F24(ctx.attacker, ctx.target, {["持续时间"] = 5, ["伤害增加百分比"] = 0.15})
end
local function _____6267_884C_6697_9ED1_4FB5_8680_590D_6D3B()
    while #_____6697_9ED1_4FB5_8680_590D_6D3B_961F_5217 > 0 do
        do
            local _____8BB0_5F55 = table.remove(_____6697_9ED1_4FB5_8680_590D_6D3B_961F_5217, 1)
            if _____8BB0_5F55 == nil or _____8BB0_5F55["来源"] == nil or _____8BB0_5F55["目标"] == nil then
                goto __continue10
            end
            if _____6697_9ED1_4FB5_8680_590D_6D3B_5355_4F4DID == 0 or _____6697_9ED1_4FB5_8680_590D_6D3B_6280_80FDID == 0 then
                goto __continue10
            end
            local _____9A6C_7532 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                GetOwningPlayer(_____8BB0_5F55["来源"]),
                _____6697_9ED1_4FB5_8680_590D_6D3B_5355_4F4DID,
                GetUnitX(_____8BB0_5F55["目标"]),
                GetUnitY(_____8BB0_5F55["目标"]),
                0
            )
            if _____9A6C_7532 == nil or _____9A6C_7532 == 0 then
                goto __continue10
            end
            UnitAddAbility(_____9A6C_7532, _____6697_9ED1_4FB5_8680_590D_6D3B_6280_80FDID)
            IssueImmediateOrder(_____9A6C_7532, "animatedead")
        end
        ::__continue10::
    end
end
local function _____5B89_6392_6697_9ED1_4FB5_8680_590D_6D3B(_____6765_6E90, _____76EE_6807)
    _____6697_9ED1_4FB5_8680_590D_6D3B_961F_5217[#_____6697_9ED1_4FB5_8680_590D_6D3B_961F_5217 + 1] = {["来源"] = _____6765_6E90, ["目标"] = _____76EE_6807}
    addDelayedCallback(1200, _____6267_884C_6697_9ED1_4FB5_8680_590D_6D3B)
end
local function _____5904_7406_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied >= 1) then
        return
    end
    if _____662F_6307_5B9A_4F24_5BB3_7C7B_578B(snapshot, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["精神"]) then
        return
    end
    local ctx = {target = target, attacker = attacker, applied = applied, snapshot = snapshot}
    _____8C7A_72FC_76AE_7532["处理豺狼皮甲受伤"](ctx)
    _____7075_77F3["处理灵石受伤"](ctx)
    _____5080_5CA9_6756["处理傀岩杖受伤"](ctx)
    _____6C99_6F20_8725_8734_4E4B_9B42["处理沙漠蜥蜴之魂受伤"](ctx)
    _____6E56_4E4B_888D["处理湖之袍受伤"](ctx)
    _____9F99_867E_786C_7532["处理龙虾硬甲受伤"](ctx)
    _____5F02_96F7_6CD5_888D["处理异雷法袍受伤"](ctx)
    _____6E56_4E4B_9F99_67AA["处理湖之龙枪造成伤害"](ctx)
    _____94F6_9B54_624B_5957["处理银魔手套造成伤害"](ctx)
    _____6BD2_56CA_9053_5177["处理毒囊道具造成伤害"](ctx)
    _____5730_72F1_706B_5361_724C_9B54_6CD5["处理地狱火卡牌魔法造成伤害"](ctx)
    _____7194_7075_5927_5251["处理熔灵大剑造成伤害"](ctx)
    _____5B89_6076_4E4B_978B["处理安恶之鞋造成伤害"](ctx)
    _____7075_5893_4E4B_6212["处理灵墓之戒造成伤害"](ctx)
    _____745E_51A5_6212_6307["处理瑞冥戒指造成伤害"](ctx)
    _____53F2_8BD7_8FDC_53E4_9B54_5203["处理史诗远古魔刃伤害触发"](ctx)
    _____9B54_529B_96F7_9524["处理魔力雷锤造成伤害"](ctx)
    _____95EA_7535_6743_6756["处理闪电权杖造成伤害"](ctx)
    _____950B_5229_5DE8_9B54_722A["处理锋利巨魔爪物理触发"](ctx)
    _____5DE8_9B54_6218_5251["处理巨魔战剑强化触发"](ctx)
    _____7CBE_7CB9_6CD5_523A["处理精粹法刺魔法触发"](ctx)
    _____5BA1_5224_4E4B_950B_957F_5251["处理审判之锋长剑伤害触发"](ctx)
    _____6C99_6F20_8725_8734_4E4B_9B42["处理沙漠蜥蜴之魂造成伤害"](ctx)
    local ____opt_6 = _____55DC_72F1_6076_5251["处理嗜狱恶剑造成伤害"]
    if ____opt_6 ~= nil then
        ____opt_6(ctx)
    end
    ____WPSHJS_8FC1_79FB_6838_5FC3["处理WPSHJS最终伤害"](ctx)
    _____5904_7406_6307_6325_6613_4F24(ctx)
end
local function _____4F24_5BB3_4E8B_4EF6_4FEE_6B63(context)
    if not (context.currentDamage >= 1) then
        return context.currentDamage
    end
    if context.isTrueDamage == true then
        return context.currentDamage
    end
    local _____7ED3_679C = _____65AF_5C14_6CD5_888D["处理斯尔法袍伤害修正"](context)
    local ____opt_8 = _____55DC_72F1_6076_5251["处理嗜狱恶剑伤害修正"]
    _____7ED3_679C = ____opt_8 and ____opt_8(context) or _____7ED3_679C
    local ____opt_10 = _____7CBE_6C99_6218_65A7["处理精沙战斧伤害修正"]
    _____7ED3_679C = ____opt_10 and ____opt_10(context) or _____7ED3_679C
    context.currentDamage = _____7ED3_679C
    _____7ED3_679C = _____6708_5149_9501_94FE_62A4_8155["处理月光锁链护腕伤害修正"](context)
    _____7ED3_679C = ____WPSHJS_8FC1_79FB_6838_5FC3["处理WPSHJS伤害修正"](context, _____7ED3_679C)
    if ____B00V_6697_9ED1_4FB5_8680BuffID ~= 0 and context.target ~= nil and _____5355_4F4D_62E5_6709Buff(context.target, ____B00V_6697_9ED1_4FB5_8680BuffID) then
        if context.currentDamage >= _____7ED3_679C and _____7ED3_679C >= _____53D6_5F53_524D_751F_547D(context.target) then
            _____5B89_6392_6697_9ED1_4FB5_8680_590D_6D3B(context.attacker, context.target)
        end
    end
    return _____7ED3_679C
end
____exports["init装备伤害事件"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerAppliedFinalDamageListener(_____5904_7406_6700_7EC8_4F24_5BB3)
    registerDamageModifier(_____4F24_5BB3_4E8B_4EF6_4FEE_6B63, 40)
end
____exports["init装备伤害事件"]()
return ____exports
