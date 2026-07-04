local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_1["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____require_result_1["取装备冷却键"]
local _____88C5_5907_51B7_5374_5C31_7EEA = ____require_result_1["装备冷却就绪"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____require_result_1["进入装备冷却"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.09．装备战斗判断")
local _____53D6_6700_5927_751F_547D = ____require_result_2["取最大生命"]
local _____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0 = __TS__Class()
_____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0.name = "伤害修正阈值实现"
function _____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0.prototype.____constructor(self, _____914D_7F6E)
    self["已停止"] = false
    self["名称"] = _____914D_7F6E["名称"] or _____914D_7F6E["装备名"]
    self["配置"] = _____914D_7F6E
    local ____self = self
    self["修正ID"] = registerDamageModifier(
        function(context)
            return ____self["修正"](____self, context)
        end,
        _____914D_7F6E["优先级"] or 30
    )
end
_____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    unregisterDamageModifier(self["修正ID"])
end
_____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0.prototype["修正"] = function(self, context)
    local current = context.currentDamage
    if self["已停止"] or not (current > 0) then
        return current
    end
    local holder = self["取持有者"](self, context)
    if holder == nil or holder == 0 then
        return current
    end
    if not _____5355_4F4D_6301_6709_88C5_5907(holder, self["配置"]["装备名"]) then
        return current
    end
    local threshold = self["计算阈值"](self, holder)
    if threshold > 0 and current < threshold then
        return current
    end
    local event = {
        ["单位"] = holder,
        ["受击者"] = context.target,
        ["攻击者"] = context.attacker,
        ["当前伤害"] = current,
        ["阈值"] = threshold,
        ["上下文"] = context,
        ["配置"] = self["配置"]
    }
    if self["配置"]["过滤伤害"] ~= nil and not self["配置"]["过滤伤害"](event) then
        return current
    end
    if not self["冷却通过并记录"](self, holder) then
        return current
    end
    if self["配置"]["on触发"] ~= nil then
        self["配置"]["on触发"](event)
    end
    if self["配置"]["计算伤害"] ~= nil then
        return self["配置"]["计算伤害"](event)
    end
    return current * (self["配置"]["伤害倍率"] or 1)
end
_____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0.prototype["取持有者"] = function(self, context)
    local ____temp_3
    if (self["配置"]["持有者"] or "受击者") == "攻击者" then
        ____temp_3 = context.attacker
    else
        ____temp_3 = context.target
    end
    return ____temp_3
end
_____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0.prototype["计算阈值"] = function(self, unit)
    local threshold = self["配置"]["固定阈值"] or 0
    local ratio = self["配置"]["最大生命比例阈值"] or 0
    if ratio > 0 then
        local hpThreshold = _____53D6_6700_5927_751F_547D(unit) * ratio
        if threshold <= 0 or hpThreshold < threshold then
            threshold = hpThreshold
        end
    end
    return threshold
end
_____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0.prototype["冷却通过并记录"] = function(self, unit)
    local cd = self["配置"]["冷却秒数"] or 0
    if not (cd > 0) then
        return true
    end
    local tag = self["配置"]["冷却标签"] or self["配置"]["名称"] or self["配置"]["装备名"]
    local key = _____53D6_88C5_5907_51B7_5374_952E(unit, tag, self["配置"]["冷却前缀"] or "装备伤害修正阈值")
    if not _____88C5_5907_51B7_5374_5C31_7EEA(key) then
        return false
    end
    _____8FDB_5165_88C5_5907_51B7_5374(key, cd)
    return true
end
____exports["创建伤害修正阈值触发"] = function(_____914D_7F6E)
    return __TS__New(_____4F24_5BB3_4FEE_6B63_9608_503C_5B9E_73B0, _____914D_7F6E)
end
return ____exports
