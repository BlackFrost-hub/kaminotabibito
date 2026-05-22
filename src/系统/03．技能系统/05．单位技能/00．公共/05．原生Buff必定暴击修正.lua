--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____5355_4F4D_62E5_6709_539F_751FBuff = ____require_result_0["单位拥有原生Buff"]
local _____8F6C_56DB_4F4DID = ____require_result_0["转四位ID"]
local _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_7387_4FEE_6B63 = ____require_result_0["注册指定单位暴击率修正"]
local ____require_result_1 = require("系统.04．伤害系统.06．暴击系统.01．暴击核心")
local registerCritRateModifier = ____require_result_1.registerCritRateModifier
local _____5F3A_5236_66B4_51FBBuffID = _____8F6C_56DB_4F4DID("B00U")
____exports["注册目标带原生Buff时必定暴击"] = function(unitTypeId, buffId)
    local function _____5FC5_5B9A_66B4_51FB_4FEE_6B63(context)
        if _____5355_4F4D_62E5_6709_539F_751FBuff(context.target, buffId) then
            return 1
        end
        return context["暴击率"]
    end
    _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_7387_4FEE_6B63(unitTypeId, _____5FC5_5B9A_66B4_51FB_4FEE_6B63)
end
____exports["注册攻击者带原生Buff时必定暴击"] = function(buffId)
    local function _____5FC5_5B9A_66B4_51FB_4FEE_6B63(context)
        if _____5355_4F4D_62E5_6709_539F_751FBuff(context.attacker, buffId) then
            return 1
        end
        return context["暴击率"]
    end
    registerCritRateModifier(_____5FC5_5B9A_66B4_51FB_4FEE_6B63)
end
____exports["init原生Buff必定暴击修正"] = function()
    ____exports["注册攻击者带原生Buff时必定暴击"](_____5F3A_5236_66B4_51FBBuffID)
end
____exports["init原生Buff必定暴击修正"]()
return ____exports
