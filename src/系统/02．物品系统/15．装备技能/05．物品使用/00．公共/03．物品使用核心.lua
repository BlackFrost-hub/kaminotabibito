--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____745F_5170_8FEA_5C14_7684_51B3_5FC3_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["瑟兰迪尔的决心物品ID"]
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.13．物品技能事件中心")
local _____6CE8_518C_7269_54C1_6280_80FD_4E8B_4EF6_76D1_542C = ____require_result_0["注册物品技能事件监听"]
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local jass = require("jass.common")
local IsUnitType = jass.IsUnitType
local GetItemTypeId = jass.GetItemTypeId
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local _____72F1_5996_9B54_76FE = require("系统.02．物品系统.15．装备技能.00．物品.49．狱妖魔盾")
local _____5546_4EBA_4E4B_4E66 = require("系统.02．物品系统.15．装备技能.00．物品.50．商人之书")
local _____72C2_66B4_6811_679D = require("系统.02．物品系统.15．装备技能.00．物品.51．狂暴树枝")
local _____9996_9886_53F7_89D2 = require("系统.02．物品系统.15．装备技能.00．物品.52．首领号角")
local _____7CBE_7075_53F7_89D2 = require("系统.02．物品系统.15．装备技能.00．物品.53．精灵号角")
local _____5B88_536B_5927_5251 = require("系统.02．物品系统.15．装备技能.00．物品.54．守卫大剑")
local _____65AF_5C14_80FD_91CF_4E4B_5FC3 = require("系统.02．物品系统.15．装备技能.00．物品.55．斯尔能量之心")
local _____7194_5CA9_5730_72F1_4E4B_6572_949F = require("系统.02．物品系统.15．装备技能.00．物品.56．熔岩地狱之敲钟")
local _____9634_6697_4E4B_6572_949F = require("系统.02．物品系统.15．装备技能.00．物品.57．阴暗之敲钟")
local _____5730_72F1_706B_5361_724C_653B_51FB = require("系统.02．物品系统.15．装备技能.00．物品.58．地狱火卡牌攻击")
local _____7130_6DF7_80FD_91CF_4F53 = require("系统.02．物品系统.15．装备技能.00．物品.59．焰混能量体")
local _____6076_65AF_80F8_7532 = require("系统.02．物品系统.15．装备技能.00．物品.60．恶斯胸甲")
local _____4EA1_7075_9B54_978B = require("系统.02．物品系统.15．装备技能.00．物品.61．亡灵魔鞋")
local _____6076_9B54_94C3_94DB = require("系统.02．物品系统.15．装备技能.00．物品.62．恶魔铃铛")
local _____9B54_53E4_6218_5203 = require("系统.02．物品系统.15．装备技能.00．物品.63．魔古战刃")
local _____5973_5996_9B54_7532 = require("系统.02．物品系统.15．装备技能.00．物品.64．女妖魔甲")
local _____7194_7075_5B9D_77F3_4E4B_6212 = require("系统.02．物品系统.15．装备技能.00．物品.65．熔灵宝石之戒")
local _____6D74_8840_836F_5242 = require("系统.02．物品系统.15．装备技能.00．物品.66．浴血药剂")
local _____6D74_9B54_836F_5242 = require("系统.02．物品系统.15．装备技能.00．物品.67．浴魔药剂")
local _____6D74_7075_836F_5242 = require("系统.02．物品系统.15．装备技能.00．物品.68．浴灵药剂")
local _____55DC_72F1_6076_5251 = require("系统.02．物品系统.15．装备技能.00．物品.69．嗜狱恶剑")
local _____706B_628A = require("系统.02．物品系统.15．装备技能.00．物品.71．火把")
local _____6297_6BD2_836F_6C34 = require("系统.02．物品系统.15．装备技能.00．物品.114．抗毒药水")
local _____745F_5170_8FEA_5C14_7684_51B3_5FC3 = require("系统.02．物品系统.15．装备技能.00．物品.162．瑟兰迪尔的决心")
local _____5F71_9AA8_62AB_98CE = require("系统.02．物品系统.15．装备技能.00．物品.131．影骨披风")
local _____9634_5F71_9677_9631_88C5_7F6E = require("系统.02．物品系统.15．装备技能.00．物品.134．阴影陷阱装置")
local _____8D85_4F4D_9B54_6CD5_6B8B_7AE0_5929_7A7A_5760_843D = require("系统.02．物品系统.15．装备技能.00．物品.186．超位魔法残章天空坠落")
local _____9ED1_7FFC_5B88_62A4_91CD_76FE = require("系统.02．物品系统.15．装备技能.00．物品.188．黑翼守护重盾")
local _____6DF1_4E95_6D3B_6C34_56CA = require("系统.02．物品系统.15．装备技能.00．物品.192．深井活水囊")
local _____5DF2_521D_59CB_5316 = false
local function _____7269_54C1_4F7F_7528_5355_4F4D_662F_82F1_96C4(ctx)
    local unit = ctx["施法单位"]
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true
end
local function ____on_7269_54C1_4F7F_7528_94FE_8DEF(ctx)
    if not _____7269_54C1_4F7F_7528_5355_4F4D_662F_82F1_96C4(ctx) then
        return
    end
    if ctx["物品"] == nil or ctx["物品"] == 0 then
        return
    end
    local _____7269_54C1_7C7B_578BID = GetItemTypeId(ctx["物品"])
    repeat
        local ____switch6 = _____7269_54C1_7C7B_578BID
        local ____cond6 = ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["狱妖魔盾"]
        if ____cond6 then
            _____72F1_5996_9B54_76FE["处理狱妖魔盾使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["商人之书"]
        if ____cond6 then
            _____5546_4EBA_4E4B_4E66["处理商人之书使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["狂暴树枝"]
        if ____cond6 then
            _____72C2_66B4_6811_679D["处理狂暴树枝使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["首领号角"]
        if ____cond6 then
            _____9996_9886_53F7_89D2["处理首领号角使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["精灵号角"]
        if ____cond6 then
            _____7CBE_7075_53F7_89D2["处理精灵号角使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["守卫大剑"]
        if ____cond6 then
            _____5B88_536B_5927_5251["处理守卫大剑使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"]
        if ____cond6 then
            _____65AF_5C14_80FD_91CF_4E4B_5FC3["处理斯尔能量之心使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["熔岩地狱之敲钟"]
        if ____cond6 then
            _____7194_5CA9_5730_72F1_4E4B_6572_949F["处理熔岩地狱之敲钟使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["阴暗之敲钟"]
        if ____cond6 then
            _____9634_6697_4E4B_6572_949F["处理阴暗之敲钟使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["地狱火卡牌攻击"]
        if ____cond6 then
            _____5730_72F1_706B_5361_724C_653B_51FB["处理地狱火卡牌攻击使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["焰混能量体"]
        if ____cond6 then
            _____7130_6DF7_80FD_91CF_4F53["处理焰混能量体使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["恶斯胸甲"]
        if ____cond6 then
            _____6076_65AF_80F8_7532["处理恶斯胸甲使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["亡灵魔鞋"]
        if ____cond6 then
            _____4EA1_7075_9B54_978B["处理亡灵魔鞋使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["恶魔铃铛"]
        if ____cond6 then
            _____6076_9B54_94C3_94DB["处理恶魔铃铛使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["魔古战刃"]
        if ____cond6 then
            _____9B54_53E4_6218_5203["处理魔古战刃使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["女妖魔甲"]
        if ____cond6 then
            _____5973_5996_9B54_7532["处理女妖魔甲使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["熔灵宝石之戒"]
        if ____cond6 then
            _____7194_7075_5B9D_77F3_4E4B_6212["处理熔灵宝石之戒使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["浴血药剂"]
        if ____cond6 then
            _____6D74_8840_836F_5242["处理浴血药剂使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["浴魔药剂"]
        if ____cond6 then
            _____6D74_9B54_836F_5242["处理浴魔药剂使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["浴灵药剂"]
        if ____cond6 then
            _____6D74_7075_836F_5242["处理浴灵药剂使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["嗜狱恶剑"]
        if ____cond6 then
            _____55DC_72F1_6076_5251["处理嗜狱恶剑使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["火把"]
        if ____cond6 then
            _____706B_628A["处理火把使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["抗毒药水"]
        if ____cond6 then
            _____6297_6BD2_836F_6C34["处理抗毒药水使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____745F_5170_8FEA_5C14_7684_51B3_5FC3_7269_54C1ID
        if ____cond6 then
            _____745F_5170_8FEA_5C14_7684_51B3_5FC3["处理瑟兰迪尔的决心使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["影骨披风"]
        if ____cond6 then
            _____5F71_9AA8_62AB_98CE["处理影骨披风使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["阴影陷阱装置"]
        if ____cond6 then
            _____9634_5F71_9677_9631_88C5_7F6E["处理阴影陷阱装置使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["超位魔法残章天空坠落"]
        if ____cond6 then
            _____8D85_4F4D_9B54_6CD5_6B8B_7AE0_5929_7A7A_5760_843D["处理超位魔法残章天空坠落使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["黑翼守护重盾"]
        if ____cond6 then
            _____9ED1_7FFC_5B88_62A4_91CD_76FE["处理黑翼守护重盾使用"](ctx)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == _____7269_54C1_4F7F_7528_88C5_5907ID["深井活水囊"]
        if ____cond6 then
            _____6DF1_4E95_6D3B_6C34_56CA["处理深井活水囊使用"](ctx)
            break
        end
    until true
end
local function ____on_7269_54C1_4F7F_7528_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied >= 1) then
        return
    end
    if snapshot ~= nil and snapshot.isTrueDamage == true then
        return
    end
    _____7130_6DF7_80FD_91CF_4F53["处理焰混能量体伤害"](target, attacker, applied, snapshot)
    _____9B54_53E4_6218_5203["处理魔古战刃伤害"](target, attacker, applied, snapshot)
end
local function ____on_7269_54C1_4F7F_7528_4F24_5BB3_4FEE_6B63(context)
    if not (context.currentDamage >= 1) then
        return context.currentDamage
    end
    if context.isTrueDamage == true then
        return context.currentDamage
    end
    local result = _____6076_65AF_80F8_7532["处理恶斯胸甲伤害修正"](context)
    context.currentDamage = result
    result = _____5973_5996_9B54_7532["处理女妖魔甲伤害修正"](context)
    context.currentDamage = result
    result = _____65AF_5C14_80FD_91CF_4E4B_5FC3["处理斯尔能量之心伤害修正"](context)
    return result
end
____exports["初始化装备物品使用链"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____72F1_5996_9B54_76FE["初始化狱妖魔盾持有充能"]()
    _____7130_6DF7_80FD_91CF_4F53["初始化焰混能量体被动"]()
    _____6CE8_518C_7269_54C1_6280_80FD_4E8B_4EF6_76D1_542C(____on_7269_54C1_4F7F_7528_94FE_8DEF)
    registerAppliedFinalDamageListener(____on_7269_54C1_4F7F_7528_6700_7EC8_4F24_5BB3)
    registerDamageModifier(____on_7269_54C1_4F7F_7528_4F24_5BB3_4FEE_6B63, 30)
end
____exports["初始化装备物品使用链"]()
return ____exports
