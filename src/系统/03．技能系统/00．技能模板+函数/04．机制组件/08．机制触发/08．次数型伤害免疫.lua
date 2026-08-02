local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local getServerTime = ____require_result_1.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local R2I = jass.R2I
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____89C4_6574_6B21_6570(_____6B21_6570)
    if _____6B21_6570 == nil or _____6B21_6570 ~= _____6B21_6570 or _____6B21_6570 <= 0 then
        return 0
    end
    return R2I(_____6B21_6570)
end
local function _____7C7B_578B_5339_914D(_____7C7B_578B, context)
    if _____7C7B_578B == "任意伤害" then
        return true
    end
    if _____7C7B_578B == "物理伤害" then
        return context.isPhysicalDamage == true
    end
    if _____7C7B_578B == "魔法伤害" then
        return context.isMagicDamage == true
    end
    if _____7C7B_578B == "真实伤害" then
        return context.isTrueDamage == true
    end
    if _____7C7B_578B == "普攻伤害" then
        return context.isNormalAttack == true
    end
    if _____7C7B_578B == "纯普攻伤害" then
        return context.isNormalAttack == true and context.isSkillAttack ~= true and context.isSkillDamage ~= true
    end
    if _____7C7B_578B == "远程伤害" then
        return context.isRangedAttack == true
    end
    if _____7C7B_578B == "近战伤害" then
        return context.isNormalAttack == true and context.isRangedAttack ~= true
    end
    if _____7C7B_578B == "技能伤害" then
        return context.isSkillDamage == true or context.isSkillAttack == true
    end
    if _____7C7B_578B == "强化伤害" then
        return context.isEnhancedDamage == true
    end
    if _____7C7B_578B == "单体技能伤害" then
        return context.isSingleTargetSkillDamage == true
    end
    if _____7C7B_578B == "AOE技能伤害" then
        return context.isAoeSkillDamage == true
    end
    if _____7C7B_578B == "装备技能伤害" then
        return context.isEquipmentSkillDamage == true
    end
    if _____7C7B_578B == "非装备技能伤害" then
        return context.isNonEquipmentSkillDamage == true
    end
    if _____7C7B_578B == "金属性伤害" then
        return context.isMetalDamage == true
    end
    if _____7C7B_578B == "木属性伤害" then
        return context.isWoodDamage == true
    end
    if _____7C7B_578B == "水属性伤害" then
        return context.isWaterDamage == true
    end
    if _____7C7B_578B == "火属性伤害" then
        return context.isFireDamage == true
    end
    if _____7C7B_578B == "雷属性伤害" then
        return context.isThunderDamage == true
    end
    if _____7C7B_578B == "光属性伤害" then
        return context.isLightDamage == true
    end
    return context.isDarkDamage == true
end
local function _____4EFB_4E00_7C7B_578B_5339_914D(_____7C7B_578B_914D_7F6E, context)
    if _____7C7B_578B_914D_7F6E == nil then
        return true
    end
    if type(_____7C7B_578B_914D_7F6E) == "string" then
        return _____7C7B_578B_5339_914D(_____7C7B_578B_914D_7F6E, context)
    end
    do
        local i = 0
        while i < #_____7C7B_578B_914D_7F6E do
            if _____7C7B_578B_5339_914D(_____7C7B_578B_914D_7F6E[i + 1], context) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____8BA1_7B97_6700_4F4E_4F24_5BB3(_____53C2_6570)
    local _____95E8_69DB = _____53C2_6570["最低伤害"] or 0
    local _____6700_5927_751F_547D_6BD4_4F8B = _____53C2_6570["最低伤害占最大生命比例"] or 0
    if _____6700_5927_751F_547D_6BD4_4F8B > 0 and _____53C2_6570["单位"] ~= nil and _____53C2_6570["单位"] ~= 0 then
        local _____6BD4_4F8B_95E8_69DB = GetUnitStateJapi(_____53C2_6570["单位"], UNIT_STATE_MAX_LIFE) * _____6700_5927_751F_547D_6BD4_4F8B
        if _____6BD4_4F8B_95E8_69DB > _____95E8_69DB then
            _____95E8_69DB = _____6BD4_4F8B_95E8_69DB
        end
    end
    return _____95E8_69DB
end
local _____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0 = __TS__Class()
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.name = "次数型伤害免疫实现"
function _____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["修正器ID"] = 0
    self["到期回调ID"] = 0
    self["到期时间Ms"] = 0
    self["剩余次数"] = 0
    self["无限"] = false
    self["永久生效"] = false
    self["已结束"] = false
    self["正在处理伤害"] = false
    self["参数"] = _____53C2_6570
    self["名称"] = _____53C2_6570["名称"] or "次数型伤害免疫"
    self["无限"] = _____53C2_6570["无限次数"] == true
    self["剩余次数"] = _____89C4_6574_6B21_6570(_____53C2_6570["免疫次数"] or 1)
    self["永久生效"] = _____53C2_6570["永久"] == true or not (_____53C2_6570["持续秒"] ~= nil and _____53C2_6570["持续秒"] > 0)
    local ____self = self
    self["修正器ID"] = registerDamageModifier(
        function(context)
            return ____self["处理伤害"](____self, context)
        end,
        _____53C2_6570["修正优先级"] or 140
    )
    if not self["永久生效"] then
        self["刷新持续时间"](self, _____53C2_6570["持续秒"] or 0)
    end
    if not self["无限"] and self["剩余次数"] <= 0 then
        self["结束"](self, "次数耗尽")
    end
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["是否生效"] = function(self)
    return not self["已结束"]
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["是否无限次数"] = function(self)
    return self["无限"]
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["是否永久"] = function(self)
    return self["永久生效"]
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["读取剩余次数"] = function(self)
    return self["无限"] and -1 or self["剩余次数"]
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["读取剩余毫秒"] = function(self)
    if self["已结束"] then
        return 0
    end
    if self["永久生效"] then
        return -1
    end
    local _____5269_4F59 = self["到期时间Ms"] - getServerTime()
    return _____5269_4F59 > 0 and _____5269_4F59 or 0
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["增加次数"] = function(self, _____6B21_6570)
    if _____6B21_6570 == nil then
        _____6B21_6570 = 1
    end
    if self["已结束"] or self["无限"] then
        return self["读取剩余次数"](self)
    end
    return self["设置次数"](
        self,
        self["剩余次数"] + _____89C4_6574_6B21_6570(_____6B21_6570)
    )
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["设置次数"] = function(self, _____6B21_6570)
    if self["已结束"] then
        return 0
    end
    local _____539F_6B21_6570 = self["读取剩余次数"](self)
    self["无限"] = false
    self["剩余次数"] = _____89C4_6574_6B21_6570(_____6B21_6570)
    if self["参数"]["on次数变化"] ~= nil and _____539F_6B21_6570 ~= self["剩余次数"] then
        self["参数"]["on次数变化"](self["参数"]["单位"], self["剩余次数"], _____539F_6B21_6570)
    end
    if self["剩余次数"] <= 0 then
        self["结束"](self, "次数耗尽")
    end
    return self["剩余次数"]
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["设为无限次数"] = function(self)
    if self["已结束"] or self["无限"] then
        return
    end
    local _____539F_6B21_6570 = self["剩余次数"]
    self["无限"] = true
    if self["参数"]["on次数变化"] ~= nil then
        self["参数"]["on次数变化"](self["参数"]["单位"], -1, _____539F_6B21_6570)
    end
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["刷新持续时间"] = function(self, _____6301_7EED_79D2)
    if self["已结束"] or not (_____6301_7EED_79D2 > 0) then
        return
    end
    self["清除到期回调"](self)
    self["永久生效"] = false
    self["到期时间Ms"] = getServerTime() + _____6301_7EED_79D2 * 1000
    local ____self = self
    self["到期回调ID"] = addDelayedCallback(
        _____6301_7EED_79D2 * 1000,
        function()
            ____self["到期回调ID"] = 0
            ____self["到期时间Ms"] = 0
            ____self["结束"](____self, "到期")
        end
    )
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["设为永久"] = function(self)
    if self["已结束"] then
        return
    end
    self["清除到期回调"](self)
    self["永久生效"] = true
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["取消"] = function(self, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动移除"
    end
    self["结束"](self, _____539F_56E0)
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["处理伤害"] = function(self, context)
    local current = context.currentDamage
    if self["已结束"] or context.target ~= self["参数"]["单位"] or not (current > 0) then
        return current
    end
    if not _____4EFB_4E00_7C7B_578B_5339_914D(self["参数"]["免疫类型"], context) then
        return current
    end
    if self["参数"]["过滤伤害"] ~= nil and not self["参数"]["过滤伤害"](context) then
        return current
    end
    local ____temp_2
    if self["参数"]["取门槛判定伤害"] == nil then
        ____temp_2 = current
    else
        ____temp_2 = self["参数"]["取门槛判定伤害"](context)
    end
    local _____5224_5B9A_4F24_5BB3 = ____temp_2
    if not (_____5224_5B9A_4F24_5BB3 >= _____8BA1_7B97_6700_4F4E_4F24_5BB3(self["参数"])) then
        return current
    end
    self["正在处理伤害"] = true
    local _____6B21_6570_8017_5C3D = false
    if not self["无限"] then
        local _____539F_6B21_6570 = self["剩余次数"]
        self["剩余次数"] = _____89C4_6574_6B21_6570(self["剩余次数"] - 1)
        _____6B21_6570_8017_5C3D = self["剩余次数"] <= 0
        if self["参数"]["on次数变化"] ~= nil and _____539F_6B21_6570 ~= self["剩余次数"] then
            self["参数"]["on次数变化"](self["参数"]["单位"], self["剩余次数"], _____539F_6B21_6570)
        end
    end
    local event = {
        ["单位"] = self["参数"]["单位"],
        ["攻击者"] = context.attacker,
        ["被免疫伤害"] = current,
        ["剩余次数"] = self["读取剩余次数"](self),
        ["上下文"] = context,
        ["控制器"] = self
    }
    if self["参数"]["on抵挡"] ~= nil then
        self["参数"]["on抵挡"](event)
    end
    if _____6B21_6570_8017_5C3D then
        self["结束"](self, "次数耗尽")
    end
    self["正在处理伤害"] = false
    return 0
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["结束"] = function(self, _____539F_56E0)
    if self["已结束"] then
        return
    end
    self["已结束"] = true
    self["清除到期回调"](self)
    if self["正在处理伤害"] then
        local ____self = self
        addDelayedCallback(
            0,
            function()
                ____self["注销修正器"](____self)
            end
        )
    else
        self["注销修正器"](self)
    end
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"](self["参数"]["单位"], _____539F_56E0)
    end
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["清除到期回调"] = function(self)
    if self["到期回调ID"] ~= 0 then
        removeDelayedCallback(self["到期回调ID"])
        self["到期回调ID"] = 0
    end
    self["到期时间Ms"] = 0
end
_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0.prototype["注销修正器"] = function(self)
    if self["修正器ID"] == 0 then
        return
    end
    unregisterDamageModifier(self["修正器ID"])
    self["修正器ID"] = 0
end
____exports["创建次数型伤害免疫"] = function(_____53C2_6570)
    local _____63A7_5236_5668 = __TS__New(_____6B21_6570_578B_4F24_5BB3_514D_75AB_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_3 = _____53C2_6570["清理"]
        ____self_3["登记清理"](
            ____self_3,
            _____63A7_5236_5668["名称"] .. "-清理",
            function()
                _____63A7_5236_5668["取消"](_____63A7_5236_5668, "清理")
            end
        )
    end
    return _____63A7_5236_5668
end
return ____exports
