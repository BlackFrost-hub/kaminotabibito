local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local unregisterDamageModifier = ____require_result_0.unregisterDamageModifier
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitAlly = jass.IsUnitAlly
local _____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0 = __TS__Class()
_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.name = "友军范围承伤转移实现"
function _____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.prototype.____constructor(self, _____914D_7F6E)
    self["已停止"] = false
    self["正在转移"] = false
    self["名称"] = _____914D_7F6E["名称"] or "友军范围承伤转移"
    self["配置"] = _____914D_7F6E
    local ____self = self
    self["修正ID"] = registerDamageModifier(
        function(context)
            return ____self["修正"](____self, context)
        end,
        _____914D_7F6E["优先级"] or 35
    )
    if _____914D_7F6E["清理"] ~= nil then
        local ____self_1 = _____914D_7F6E["清理"]
        ____self_1["登记清理"](
            ____self_1,
            self["名称"] .. "-承伤转移",
            function()
                ____self["停止"](____self)
            end
        )
    end
end
_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    unregisterDamageModifier(self["修正ID"])
end
_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.prototype["修正"] = function(self, context)
    local current = context.currentDamage
    if self["已停止"] or self["正在转移"] or not (current > 0) then
        return current
    end
    local ____self__914D_7F6E__6392_9664_771F_5B9E_4F24_5BB3_2 = self["配置"]["排除真实伤害"]
    if ____self__914D_7F6E__6392_9664_771F_5B9E_4F24_5BB3_2 == nil then
        ____self__914D_7F6E__6392_9664_771F_5B9E_4F24_5BB3_2 = true
    end
    if ____self__914D_7F6E__6392_9664_771F_5B9E_4F24_5BB3_2 and context.isTrueDamage == true then
        return current
    end
    local target = context.target
    local attacker = context.attacker
    if target == nil or target == 0 then
        return current
    end
    if self["配置"]["过滤伤害"] ~= nil and not self["配置"]["过滤伤害"]({["受击者"] = target, ["攻击者"] = attacker, ["当前伤害"] = current, ["上下文"] = context}) then
        return current
    end
    local holder = self["寻找承受者"](self, target, attacker, context)
    if holder == nil or holder == 0 then
        return current
    end
    local transfer = current * self["配置"]["转移比例"]
    if not (transfer > 0) then
        return current
    end
    self["正在转移"] = true
    self["配置"]["on转移"]({
        ["受击者"] = target,
        ["攻击者"] = attacker,
        ["承受者"] = holder,
        ["当前伤害"] = current,
        ["转移伤害"] = transfer,
        ["上下文"] = context,
        ["配置"] = self["配置"]
    })
    self["正在转移"] = false
    return current - transfer
end
_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.prototype["寻找承受者"] = function(self, target, attacker, context)
    local owner = GetOwningPlayer(target)
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local radius = self["配置"]["转移半径"]
    local radiusSq = radius * radius
    local candidates = self["配置"]["获取候选单位列表"]({["受击者"] = target, ["攻击者"] = attacker, ["上下文"] = context}) or ({})
    do
        local i = 0
        while i < #candidates do
            do
                local holder = candidates[i + 1]
                if holder == nil or holder == 0 or holder == target then
                    goto __continue17
                end
                if not IsUnitAlly(holder, owner) then
                    goto __continue17
                end
                if self["配置"]["可承受者"] ~= nil and not self["配置"]["可承受者"]({["受击者"] = target, ["攻击者"] = attacker, ["候选单位"] = holder, ["上下文"] = context}) then
                    goto __continue17
                end
                local dx = GetUnitX(holder) - tx
                local dy = GetUnitY(holder) - ty
                if dx * dx + dy * dy <= radiusSq then
                    return holder
                end
            end
            ::__continue17::
            i = i + 1
        end
    end
    return nil
end
____exports["创建友军范围承伤转移"] = function(_____914D_7F6E)
    return __TS__New(_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0, _____914D_7F6E)
end
return ____exports
