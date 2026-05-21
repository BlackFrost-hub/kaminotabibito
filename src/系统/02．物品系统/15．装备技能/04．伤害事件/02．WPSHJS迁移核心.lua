--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.01．属性读取")
local isDamageReduceDisabled = ____require_result_0.isDamageReduceDisabled
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____require_result_1["伤害事件伤害类型"]
local _____8840_6D74_4E4B_6BCD_7684_7B2C_4E8C_6761_53F3_817F = require("系统.02．物品系统.15．装备技能.00．物品.117．血浴之母的第二条右腿")
local _____8840_6D74_4E4B_6BCD_7684_7B2C_4E8C_6761_5DE6_817F = require("系统.02．物品系统.15．装备技能.00．物品.118．血浴之母的第二条左腿")
local _____9632_5FA1_8718_86DB_9879_94FE = require("系统.02．物品系统.15．装备技能.00．物品.119．防御蜘蛛项链")
local _____7194_5CA9_6076_9B54_7FBD_7FFC = require("系统.02．物品系统.15．装备技能.00．物品.120．熔岩恶魔羽翼")
local _____7CBE_81F4_6C99_65A7 = require("系统.02．物品系统.15．装备技能.00．物品.121．精致沙斧")
local _____7194_5CA9_6076_9B54_738B_7FFC = require("系统.02．物品系统.15．装备技能.00．物品.122．熔岩恶魔王翼")
local _____7CBE_81F4_6728_76FE = require("系统.02．物品系统.15．装备技能.00．物品.123．精致木盾")
local _____5730_72F1_706B_62A4_80A9 = require("系统.02．物品系统.15．装备技能.00．物品.124．地狱火护肩")
local _____6076_8363_80F8_7532 = require("系统.02．物品系统.15．装备技能.00．物品.125．恶荣胸甲")
local _____72F1_9B54_77ED_5315 = require("系统.02．物品系统.15．装备技能.00．物品.126．狱魔短匕")
local function ____WPSHJS_524D_7F6E_6761_4EF6_901A_8FC7__4F24_5BB3_4FEE_6B63(context)
    if context == nil or context.target == nil or context.target == 0 then
        return false
    end
    if not (context.currentDamage >= 1) then
        return false
    end
    if context.rawDamageType == _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["精神"] then
        return false
    end
    if isDamageReduceDisabled(context.target) then
        return false
    end
    return true
end
local function ____WPSHJS_524D_7F6E_6761_4EF6_901A_8FC7__6700_7EC8_4F24_5BB3(ctx)
    if ctx == nil or ctx.target == nil or ctx.target == 0 or ctx.snapshot == nil then
        return false
    end
    if not (ctx.applied >= 1) then
        return false
    end
    if ctx.snapshot.rawDamageType == _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["精神"] then
        return false
    end
    if isDamageReduceDisabled(ctx.target) then
        return false
    end
    return true
end
local function _____9650_5236_4F24_5BB3_4E0D_4E3A_8D1F_6570(value)
    if value <= 0 then
        return 0
    end
    return value
end
____exports["处理WPSHJS伤害修正"] = function(context, _____521D_59CB_4F24_5BB3)
    if not ____WPSHJS_524D_7F6E_6761_4EF6_901A_8FC7__4F24_5BB3_4FEE_6B63(context) then
        return _____521D_59CB_4F24_5BB3 or context.currentDamage
    end
    local _____5F53_524D_4F24_5BB3 = _____521D_59CB_4F24_5BB3 or context.currentDamage
    _____5F53_524D_4F24_5BB3 = _____8840_6D74_4E4B_6BCD_7684_7B2C_4E8C_6761_53F3_817F["处理血浴之母的第二条右腿伤害修正"](context, _____5F53_524D_4F24_5BB3)
    _____5F53_524D_4F24_5BB3 = _____8840_6D74_4E4B_6BCD_7684_7B2C_4E8C_6761_5DE6_817F["处理血浴之母的第二条左腿伤害修正"](context, _____5F53_524D_4F24_5BB3)
    _____5F53_524D_4F24_5BB3 = _____9632_5FA1_8718_86DB_9879_94FE["处理防御蜘蛛项链伤害修正"](context, _____5F53_524D_4F24_5BB3)
    _____5F53_524D_4F24_5BB3 = _____7194_5CA9_6076_9B54_7FBD_7FFC["处理熔岩恶魔羽翼伤害修正"](context, _____5F53_524D_4F24_5BB3)
    _____5F53_524D_4F24_5BB3 = _____7CBE_81F4_6C99_65A7["处理精致沙斧伤害修正"](context, _____5F53_524D_4F24_5BB3)
    _____5F53_524D_4F24_5BB3 = _____7194_5CA9_6076_9B54_738B_7FFC["处理熔岩恶魔王翼伤害修正"](context, _____5F53_524D_4F24_5BB3)
    _____5F53_524D_4F24_5BB3 = _____7CBE_81F4_6728_76FE["处理精致木盾伤害修正"](context, _____5F53_524D_4F24_5BB3)
    _____5F53_524D_4F24_5BB3 = _____5730_72F1_706B_62A4_80A9["处理地狱火护肩伤害修正"](context, _____5F53_524D_4F24_5BB3)
    _____5F53_524D_4F24_5BB3 = _____6076_8363_80F8_7532["处理恶荣胸甲伤害修正"](context, _____5F53_524D_4F24_5BB3)
    return _____9650_5236_4F24_5BB3_4E0D_4E3A_8D1F_6570(_____5F53_524D_4F24_5BB3)
end
____exports["处理WPSHJS最终伤害"] = function(ctx)
    if not ____WPSHJS_524D_7F6E_6761_4EF6_901A_8FC7__6700_7EC8_4F24_5BB3(ctx) then
        return
    end
    _____5730_72F1_706B_62A4_80A9["处理地狱火护肩最终伤害"](ctx)
    _____72F1_9B54_77ED_5315["处理狱魔短匕最终伤害"](ctx)
end
return ____exports
