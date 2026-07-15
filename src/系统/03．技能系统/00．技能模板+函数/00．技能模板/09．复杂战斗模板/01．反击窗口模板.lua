local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具")
local _____5355_4F4D_662F_5426_5728_6765_6E90_6B63_9762_6247_533A = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["单位是否在来源正面扇区"]
local _____5355_4F4D_662F_5426_5728_6765_6E90_80CC_540E_6247_533A = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["单位是否在来源背后扇区"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local _____53CD_51FB_7A97_53E3_6A21_677F_5B9E_73B0 = __TS__Class()
_____53CD_51FB_7A97_53E3_6A21_677F_5B9E_73B0.name = "反击窗口模板实现"
function _____53CD_51FB_7A97_53E3_6A21_677F_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["修正ID"] = 0
    self["到期ID"] = 0
    self["已结束"] = false
    self["参数"] = _____53C2_6570
    local ____self = self
    self["修正ID"] = registerDamageModifier(
        function(context)
            return ____self["处理伤害"](____self, context)
        end,
        _____53C2_6570["修正优先级"] or 40
    )
    self["到期ID"] = addDelayedCallback(
        _____53C2_6570["持续秒"] * 1000,
        function()
            ____self["取消"](____self, "到期")
        end
    )
end
_____53CD_51FB_7A97_53E3_6A21_677F_5B9E_73B0.prototype["取消"] = function(self, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动取消"
    end
    if self["已结束"] then
        return
    end
    self["已结束"] = true
    if self["修正ID"] ~= 0 then
        unregisterDamageModifier(self["修正ID"])
        self["修正ID"] = 0
    end
    if self["到期ID"] ~= 0 then
        removeDelayedCallback(self["到期ID"])
        self["到期ID"] = 0
    end
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"](_____539F_56E0)
    end
end
_____53CD_51FB_7A97_53E3_6A21_677F_5B9E_73B0.prototype["处理伤害"] = function(self, context)
    if self["已结束"] or context.target ~= self["参数"]["单位"] then
        return context.currentDamage
    end
    if self["参数"]["仅普攻"] == true and context.isNormalAttack ~= true then
        return context.currentDamage
    end
    if self["参数"]["仅技能伤害"] == true and context.isSkillDamage ~= true and context.isSkillAttack ~= true then
        return context.currentDamage
    end
    if self["参数"]["触发条件"] ~= nil and not self["参数"]["触发条件"](context) then
        return context.currentDamage
    end
    local result = context.currentDamage
    if self["参数"]["背后破招角度"] ~= nil and _____5355_4F4D_662F_5426_5728_6765_6E90_80CC_540E_6247_533A(self["参数"]["单位"], context.attacker, self["参数"]["背后破招角度"]) then
        result = result * (self["参数"]["背后受伤倍率"] or 1)
        if self["参数"]["on破招"] ~= nil then
            self["参数"]["on破招"](context, result)
        end
        self["取消"](self, "破招")
        return result
    end
    if self["参数"]["正面减伤角度"] ~= nil and _____5355_4F4D_662F_5426_5728_6765_6E90_6B63_9762_6247_533A(self["参数"]["单位"], context.attacker, self["参数"]["正面减伤角度"]) then
        result = result * (self["参数"]["正面伤害倍率"] or 1)
        if self["参数"]["on反击"] ~= nil then
            self["参数"]["on反击"](context, result)
        end
        return result
    end
    return result
end
____exports["创建反击窗口模板"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____53CD_51FB_7A97_53E3_6A21_677F_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["取消"](_____5B9E_4F8B, "手动取消")
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
