--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_62A4_76FE_5B9E_4F8B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.02．护盾实例")
local _____83B7_53D6_5355_4F4D_62A4_76FE_5B9E_4F8B_5217_8868 = ____02_FF0E_62A4_76FE_5B9E_4F8B["获取单位护盾实例列表"]
local _____5220_9664_62A4_76FE_5B9E_4F8B = ____02_FF0E_62A4_76FE_5B9E_4F8B["删除护盾实例"]
local _____53D6_53E5_67C4ID = ____02_FF0E_62A4_76FE_5B9E_4F8B["取句柄ID"]
local ____03_FF0E_62A4_76FE_4F18_5148_7EA7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.03．护盾优先级")
local _____83B7_53D6_53EF_5339_914D_62A4_76FE_5217_8868 = ____03_FF0E_62A4_76FE_4F18_5148_7EA7["获取可匹配护盾列表"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local RMin = jass.RMin
local RMax = jass.RMax
local shieldModifierRegistered = false
--- 用护盾吸收伤害
-- 
-- @param 目标 受伤单位
-- @param 伤害值 待结算伤害
-- @param 是物理伤害 是否物理伤害
-- @param 是魔法伤害 是否魔法伤害
-- @param 攻击者 攻击者（可选，用于破碎回调）
-- @returns 吸收结果
____exports["吸收伤害"] = function(_____76EE_6807, _____4F24_5BB3_503C, _____662F_7269_7406_4F24_5BB3, _____662F_9B54_6CD5_4F24_5BB3, _____653B_51FB_8005)
    local _____7ED3_679C = {["剩余伤害"] = _____4F24_5BB3_503C, ["总吸收量"] = 0, ["破碎护盾"] = {}}
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____76EE_6807)
    if _____5355_4F4DID == 0 then
        return _____7ED3_679C
    end
    local _____5168_90E8_62A4_76FE = _____83B7_53D6_5355_4F4D_62A4_76FE_5B9E_4F8B_5217_8868(_____5355_4F4DID)
    if #_____5168_90E8_62A4_76FE == 0 then
        return _____7ED3_679C
    end
    local _____53EF_7528_62A4_76FE = _____83B7_53D6_53EF_5339_914D_62A4_76FE_5217_8868(_____5168_90E8_62A4_76FE, _____662F_7269_7406_4F24_5BB3, _____662F_9B54_6CD5_4F24_5BB3)
    for ____, _____62A4_76FE in ipairs(_____53EF_7528_62A4_76FE) do
        if _____7ED3_679C["剩余伤害"] <= 0 then
            break
        end
        local _____5438_6536_91CF = RMin(_____62A4_76FE["当前值"], _____7ED3_679C["剩余伤害"])
        _____62A4_76FE["当前值"] = _____62A4_76FE["当前值"] - _____5438_6536_91CF
        _____7ED3_679C["剩余伤害"] = _____7ED3_679C["剩余伤害"] - _____5438_6536_91CF
        _____7ED3_679C["总吸收量"] = _____7ED3_679C["总吸收量"] + _____5438_6536_91CF
        if _____62A4_76FE["当前值"] <= 0 then
            local ____7ED3_679C__7834_788E_62A4_76FE_1 = _____7ED3_679C["破碎护盾"]
            ____7ED3_679C__7834_788E_62A4_76FE_1[#____7ED3_679C__7834_788E_62A4_76FE_1 + 1] = _____62A4_76FE
            _____5220_9664_62A4_76FE_5B9E_4F8B(_____62A4_76FE.id)
            if type(_____62A4_76FE["破碎回调"]) == "function" then
                _____62A4_76FE["破碎回调"](_____76EE_6807, _____62A4_76FE.id, _____5438_6536_91CF)
            end
            if type(_____62A4_76FE["结束回调"]) == "function" then
                _____62A4_76FE["结束回调"](_____76EE_6807, _____62A4_76FE.id, "破碎")
            end
        end
    end
    return _____7ED3_679C
end
--- 注册护盾吸收到伤害系统
-- 
-- 在主计算流程的 YDWESetEventDamage 之前调用
____exports["注册护盾吸收钩子"] = function()
    if shieldModifierRegistered then
        return
    end
    shieldModifierRegistered = true
    registerDamageModifier(
        nil,
        function(context)
            return ____exports["吸收伤害"](
                context.target,
                context.currentDamage,
                context.isPhysicalDamage,
                context.isMagicDamage,
                context.attacker
            )["剩余伤害"]
        end,
        100
    )
end
return ____exports
