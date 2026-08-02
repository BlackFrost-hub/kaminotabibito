local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["执行非伤害生命移除"]
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
    self["已启用"] = true
    self["正在转移"] = false
    self["名称"] = _____914D_7F6E["名称"] or "友军范围承伤转移"
    self["配置"] = _____914D_7F6E
    self["已启用"] = _____914D_7F6E["初始启用"] ~= false
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
_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.prototype["是否生效"] = function(self)
    return not self["已停止"] and self["已启用"]
end
_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.prototype["设置启用"] = function(self, _____542F_7528)
    if self["已停止"] then
        return
    end
    self["已启用"] = _____542F_7528
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
    if not self["是否生效"](self) or self["正在转移"] or context.isDamageTransfer == true or not (current > 0) then
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
    local ratio = self["配置"]["获取转移比例"] ~= nil and self["配置"]["获取转移比例"]({
        ["受击者"] = target,
        ["攻击者"] = attacker,
        ["承受者"] = holder,
        ["当前伤害"] = current,
        ["上下文"] = context
    }) or (self["配置"]["转移比例"] or 0)
    if not (ratio > 0) then
        return current
    end
    if ratio > 1 then
        ratio = 1
    end
    local plannedTransfer = current * ratio
    if not (plannedTransfer > 0) then
        return current
    end
    local request = {
        ["受击者"] = target,
        ["攻击者"] = attacker,
        ["承受者"] = holder,
        ["当前伤害"] = current,
        ["计划转移伤害"] = plannedTransfer,
        ["上下文"] = context,
        ["配置"] = self["配置"]
    }
    self["正在转移"] = true
    local transferred = self["提交转移"](self, request)
    self["正在转移"] = false
    if transferred < 0 then
        transferred = -transferred
    end
    if transferred > plannedTransfer then
        transferred = plannedTransfer
    end
    if not (transferred > 0) then
        return current
    end
    local event = __TS__ObjectAssign({}, request, {["转移伤害"] = transferred})
    if self["配置"]["on转移"] ~= nil then
        self["配置"]["on转移"](event)
    end
    return current - transferred
end
_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.prototype["提交转移"] = function(self, request)
    if self["配置"]["提交转移"] ~= nil then
        return self["配置"]["提交转移"](request)
    end
    local minimumLife = self["配置"]["获取最低生命"] ~= nil and self["配置"]["获取最低生命"](request) or (self["配置"]["最低生命"] or 1)
    return _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
        ["目标"] = request["承受者"],
        ["数值"] = request["计划转移伤害"],
        ["最低生命"] = minimumLife,
        ["显示文字"] = self["配置"]["显示文字"] ~= false,
        ["显示特效"] = self["配置"]["显示特效"] == true,
        ["特效路径"] = self["配置"]["特效路径"]
    })
end
_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0.prototype["寻找承受者"] = function(self, target, attacker, context)
    local owner = GetOwningPlayer(target)
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local radius = self["配置"]["转移半径"]
    local radiusSq = radius ~= nil and radius >= 0 and radius * radius or -1
    local candidates = self["配置"]["获取候选单位列表"]({["受击者"] = target, ["攻击者"] = attacker, ["上下文"] = context}) or ({})
    do
        local i = 0
        while i < #candidates do
            do
                local holder = candidates[i + 1]
                if holder == nil or holder == 0 or holder == target then
                    goto __continue28
                end
                if not IsUnitAlly(holder, owner) then
                    goto __continue28
                end
                if self["配置"]["可承受者"] ~= nil and not self["配置"]["可承受者"]({["受击者"] = target, ["攻击者"] = attacker, ["候选单位"] = holder, ["上下文"] = context}) then
                    goto __continue28
                end
                if radiusSq < 0 then
                    return holder
                end
                local dx = GetUnitX(holder) - tx
                local dy = GetUnitY(holder) - ty
                if dx * dx + dy * dy <= radiusSq then
                    return holder
                end
            end
            ::__continue28::
            i = i + 1
        end
    end
    return nil
end
____exports["创建友军范围承伤转移"] = function(_____914D_7F6E)
    return __TS__New(_____53CB_519B_8303_56F4_627F_4F24_8F6C_79FB_5B9E_73B0, _____914D_7F6E)
end
return ____exports
