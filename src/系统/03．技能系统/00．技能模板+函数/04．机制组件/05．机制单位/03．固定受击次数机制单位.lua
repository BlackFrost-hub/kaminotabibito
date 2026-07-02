local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local _____56FA_5B9A_53D7_51FB_6B21_6570_5355_4F4D_8868 = {}
local _____56FA_5B9A_53D7_51FB_6B21_6570_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____89C4_6574_6B21_6570(_____6B21_6570)
    if _____6B21_6570 == nil or _____6B21_6570 ~= _____6B21_6570 or _____6B21_6570 < 0 then
        return 0
    end
    return math.floor(_____6B21_6570)
end
local function _____56FA_5B9A_53D7_51FB_6B21_6570_4F24_5BB3_4FEE_6B63(context)
    local id = _____53D6_5355_4F4DID(context.target)
    if id == 0 then
        return context.currentDamage
    end
    local _____8BB0_5F55 = _____56FA_5B9A_53D7_51FB_6B21_6570_5355_4F4D_8868[id]
    if _____8BB0_5F55 == nil then
        return context.currentDamage
    end
    if context.currentDamage <= 0 then
        return context.currentDamage
    end
    if _____8BB0_5F55["参数"]["过滤伤害"] ~= nil and not _____8BB0_5F55["参数"]["过滤伤害"](context) then
        return context.currentDamage
    end
    local _____6263_9664_6B21_6570 = _____89C4_6574_6B21_6570(_____8BB0_5F55["参数"]["每次伤害扣除次数"] or 1)
    if _____6263_9664_6B21_6570 <= 0 then
        return 0
    end
    local ____self_2 = _____8BB0_5F55["实例"]
    local ____self_2__8BBE_7F6E_5269_4F59_6B21_6570_3 = ____self_2["设置剩余次数"]
    local ____self_1 = _____8BB0_5F55["实例"]
    ____self_2__8BBE_7F6E_5269_4F59_6B21_6570_3(
        ____self_2,
        ____self_1["读取剩余次数"](____self_1) - _____6263_9664_6B21_6570
    )
    local ____self_4 = _____8BB0_5F55["实例"]
    local _____5269_4F59_6B21_6570 = ____self_4["读取剩余次数"](____self_4)
    if _____8BB0_5F55["参数"]["on受击"] ~= nil then
        _____8BB0_5F55["参数"]["on受击"](_____8BB0_5F55["实例"]["单位"], _____5269_4F59_6B21_6570, context)
    end
    if _____5269_4F59_6B21_6570 <= 0 then
        __TS__Delete(_____56FA_5B9A_53D7_51FB_6B21_6570_5355_4F4D_8868, id)
        if _____8BB0_5F55["参数"]["on击破"] ~= nil then
            _____8BB0_5F55["参数"]["on击破"](_____8BB0_5F55["实例"]["单位"], context)
        end
        local ____self_5 = _____8BB0_5F55["实例"]
        ____self_5["销毁"](____self_5)
    end
    return 0
end
local function _____786E_4FDD_56FA_5B9A_53D7_51FB_6B21_6570_4F24_5BB3_4FEE_6B63()
    if _____56FA_5B9A_53D7_51FB_6B21_6570_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C then
        return
    end
    _____56FA_5B9A_53D7_51FB_6B21_6570_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = true
    registerDamageModifier(_____56FA_5B9A_53D7_51FB_6B21_6570_4F24_5BB3_4FEE_6B63, 120)
end
local _____56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D_5B9E_4F8B_5B9E_73B0 = __TS__Class()
_____56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D_5B9E_4F8B_5B9E_73B0.name = "固定受击次数机制单位实例实现"
function _____56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D_5B9E_4F8B_5B9E_73B0.prototype.____constructor(self, _____57FA_7840_5B9E_4F8B, _____5269_4F59_6B21_6570)
    self["已销毁"] = false
    self["基础实例"] = _____57FA_7840_5B9E_4F8B
    self["单位"] = _____57FA_7840_5B9E_4F8B["单位"]
    self.ID = _____57FA_7840_5B9E_4F8B.ID
    self["剩余次数"] = _____5269_4F59_6B21_6570
end
_____56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D_5B9E_4F8B_5B9E_73B0.prototype["是否存活"] = function(self)
    return not self["已销毁"] and self["剩余次数"] > 0 and self["基础实例"]["是否存活"]()
end
_____56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D_5B9E_4F8B_5B9E_73B0.prototype["读取剩余次数"] = function(self)
    return self["剩余次数"]
end
_____56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D_5B9E_4F8B_5B9E_73B0.prototype["设置剩余次数"] = function(self, _____6B21_6570)
    self["剩余次数"] = _____89C4_6574_6B21_6570(_____6B21_6570)
end
_____56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D_5B9E_4F8B_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    __TS__Delete(_____56FA_5B9A_53D7_51FB_6B21_6570_5355_4F4D_8868, self.ID)
    self["基础实例"]["销毁"]()
end
____exports["创建固定受击次数机制单位"] = function(_____53C2_6570)
    _____786E_4FDD_56FA_5B9A_53D7_51FB_6B21_6570_4F24_5BB3_4FEE_6B63()
    local _____57FA_7840_5B9E_4F8B = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D(__TS__ObjectAssign({}, _____53C2_6570, {["最大生命"] = _____53C2_6570["最大生命"] or 999999, ["生命值受小怪倍率"] = false}))
    if _____57FA_7840_5B9E_4F8B == nil then
        return nil
    end
    local _____5B9E_4F8B = __TS__New(
        _____56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D_5B9E_4F8B_5B9E_73B0,
        _____57FA_7840_5B9E_4F8B,
        _____89C4_6574_6B21_6570(_____53C2_6570["受击次数"])
    )
    _____56FA_5B9A_53D7_51FB_6B21_6570_5355_4F4D_8868[_____5B9E_4F8B.ID] = {["实例"] = _____5B9E_4F8B, ["参数"] = _____53C2_6570}
    return _____5B9E_4F8B
end
return ____exports
