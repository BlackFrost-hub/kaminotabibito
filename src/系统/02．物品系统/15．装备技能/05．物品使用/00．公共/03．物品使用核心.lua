--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.13．物品技能事件中心")
local _____6CE8_518C_7269_54C1_6280_80FD_4E8B_4EF6_76D1_542C = ____require_result_0["注册物品技能事件监听"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_2.registerAppliedFinalDamageListener
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_3.registerDamageModifier
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
local _____76D7_8D3C_795E_7B26_9B54_6297 = require("系统.02．物品系统.15．装备技能.00．物品.70．盗贼神符魔抗")
local _____706B_628A = require("系统.02．物品系统.15．装备技能.00．物品.71．火把")
local _____5DF2_521D_59CB_5316 = false
local function ____on_7269_54C1_4F7F_7528_94FE_8DEF(ctx)
    _____72F1_5996_9B54_76FE["处理狱妖魔盾使用"](ctx)
    _____5546_4EBA_4E4B_4E66["处理商人之书使用"](ctx)
    _____72C2_66B4_6811_679D["处理狂暴树枝使用"](ctx)
    _____9996_9886_53F7_89D2["处理首领号角使用"](ctx)
    _____7CBE_7075_53F7_89D2["处理精灵号角使用"](ctx)
    _____5B88_536B_5927_5251["处理守卫大剑使用"](ctx)
    _____65AF_5C14_80FD_91CF_4E4B_5FC3["处理斯尔能量之心使用"](ctx)
    _____7194_5CA9_5730_72F1_4E4B_6572_949F["处理熔岩地狱之敲钟使用"](ctx)
    _____9634_6697_4E4B_6572_949F["处理阴暗之敲钟使用"](ctx)
    _____5730_72F1_706B_5361_724C_653B_51FB["处理地狱火卡牌攻击使用"](ctx)
    _____7130_6DF7_80FD_91CF_4F53["处理焰混能量体使用"](ctx)
    _____6076_65AF_80F8_7532["处理恶斯胸甲使用"](ctx)
    _____4EA1_7075_9B54_978B["处理亡灵魔鞋使用"](ctx)
    _____6076_9B54_94C3_94DB["处理恶魔铃铛使用"](ctx)
    _____9B54_53E4_6218_5203["处理魔古战刃使用"](ctx)
    _____5973_5996_9B54_7532["处理女妖魔甲使用"](ctx)
    _____7194_7075_5B9D_77F3_4E4B_6212["处理熔灵宝石之戒使用"](ctx)
    _____6D74_8840_836F_5242["处理浴血药剂使用"](ctx)
    _____6D74_9B54_836F_5242["处理浴魔药剂使用"](ctx)
    _____6D74_7075_836F_5242["处理浴灵药剂使用"](ctx)
    _____55DC_72F1_6076_5251["处理嗜狱恶剑使用"](ctx)
    _____76D7_8D3C_795E_7B26_9B54_6297["处理盗贼神符魔抗使用"](ctx)
    _____706B_628A["处理火把使用"](ctx)
end
local function ____on_7269_54C1_4F7F_7528_6B7B_4EA1_4E8B_4EF6(dyingUnit, killingUnit)
    _____65AF_5C14_80FD_91CF_4E4B_5FC3["处理斯尔能量之心击杀"](dyingUnit, killingUnit)
end
local function ____on_7269_54C1_4F7F_7528_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    _____7130_6DF7_80FD_91CF_4F53["处理焰混能量体伤害"](target, attacker, applied, snapshot)
    _____9B54_53E4_6218_5203["处理魔古战刃伤害"](target, attacker, applied, snapshot)
end
local function ____on_7269_54C1_4F7F_7528_4F24_5BB3_4FEE_6B63(context)
    return _____6076_65AF_80F8_7532["处理恶斯胸甲伤害修正"](context)
end
____exports["初始化装备物品使用链"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____72F1_5996_9B54_76FE["初始化狱妖魔盾持有充能"]()
    _____6CE8_518C_7269_54C1_6280_80FD_4E8B_4EF6_76D1_542C(____on_7269_54C1_4F7F_7528_94FE_8DEF)
    registerDeathListener(____on_7269_54C1_4F7F_7528_6B7B_4EA1_4E8B_4EF6)
    registerAppliedFinalDamageListener(____on_7269_54C1_4F7F_7528_6700_7EC8_4F24_5BB3)
    registerDamageModifier(____on_7269_54C1_4F7F_7528_4F24_5BB3_4FEE_6B63, 30)
end
____exports["初始化装备物品使用链"]()
return ____exports
