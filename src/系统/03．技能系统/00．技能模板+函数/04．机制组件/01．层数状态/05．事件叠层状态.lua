local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_4E8B_4EF6_53E0_5C42_8FC7_671FTick, getServerTime, _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868
local ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.01．可配置层数状态")
local _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001 = ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001["创建可配置层数状态"]
function ____on_4E8B_4EF6_53E0_5C42_8FC7_671FTick()
    local now = getServerTime()
    for key in pairs(_____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868[key]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668["推进过期"](_____63A7_5236_5668, now)
        end
    end
end
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
getServerTime = ____require_result_2.getServerTime
_____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868 = {}
local _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8BA1_6570 = 0
local _____4E8B_4EF6_53E0_5C42_8FC7_671FTickID = 0
local function _____5355_4F4D_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____5355_4F4D) then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____6765_6E90_5339_914D(_____914D_7F6E_6765_6E90, _____6765_6E90)
    if type(_____914D_7F6E_6765_6E90) == "string" then
        return _____914D_7F6E_6765_6E90 == _____6765_6E90
    end
    do
        local i = 0
        while i < #_____914D_7F6E_6765_6E90 do
            if _____914D_7F6E_6765_6E90[i + 1] == _____6765_6E90 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____786E_4FDD_4E8B_4EF6_53E0_5C42Tick()
    if _____4E8B_4EF6_53E0_5C42_8FC7_671FTickID ~= 0 then
        return
    end
    _____4E8B_4EF6_53E0_5C42_8FC7_671FTickID = addPeriodicCallback(200, ____on_4E8B_4EF6_53E0_5C42_8FC7_671FTick)
end
local function _____5C1D_8BD5_505C_6B62_4E8B_4EF6_53E0_5C42Tick()
    for key in pairs(_____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868) do
        if _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868[key] ~= nil then
            return
        end
    end
    if _____4E8B_4EF6_53E0_5C42_8FC7_671FTickID ~= 0 then
        removePeriodicCallback(_____4E8B_4EF6_53E0_5C42_8FC7_671FTickID)
        _____4E8B_4EF6_53E0_5C42_8FC7_671FTickID = 0
    end
end
local _____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0 = __TS__Class()
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.name = "事件叠层状态实现"
function _____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype.____constructor(self, _____540D_79F0, _____53C2_6570)
    self["单位状态表"] = {}
    self["已停止"] = false
    self["名称"] = _____540D_79F0
    self["参数"] = _____53C2_6570
    self["层数控制器"] = _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001(_____53C2_6570)
    _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8BA1_6570 = _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8BA1_6570 + 1
    self["控制器ID"] = _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8BA1_6570
    _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868[self["控制器ID"]] = self
    _____786E_4FDD_4E8B_4EF6_53E0_5C42Tick()
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["手动触发"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动触发"
    end
    return self["处理事件"](self, {["来源"] = "手动", ["单位"] = _____5355_4F4D, ["原因"] = _____539F_56E0}, _____5C42_6570)
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["处理事件"] = function(self, ctx, _____6307_5B9A_5C42_6570)
    if self["已停止"] then
        return 0
    end
    if not _____6765_6E90_5339_914D(self["参数"]["触发来源"], ctx["来源"]) then
        local ____self_3 = self["层数控制器"]
        return ____self_3["取层数"](____self_3, ctx["单位"])
    end
    if not _____5355_4F4D_6709_6548(ctx["单位"]) then
        return 0
    end
    if self["参数"]["过滤事件"] ~= nil and not self["参数"]["过滤事件"](ctx) then
        local ____self_4 = self["层数控制器"]
        return ____self_4["取层数"](____self_4, ctx["单位"])
    end
    local now = getServerTime()
    local _____72B6_6001 = self["取或建单位状态"](self, ctx["单位"])
    if now < _____72B6_6001["下次允许毫秒"] then
        local ____self_5 = self["层数控制器"]
        return ____self_5["取层数"](____self_5, ctx["单位"])
    end
    local _____589E_52A0_5C42_6570 = _____6307_5B9A_5C42_6570 ~= nil and _____6307_5B9A_5C42_6570 or self["计算增加层数"](self, ctx)
    if _____589E_52A0_5C42_6570 <= 0 then
        local ____self_6 = self["层数控制器"]
        return ____self_6["取层数"](____self_6, ctx["单位"])
    end
    local _____5185_7F6ECD_79D2 = self["参数"]["内置CD秒"] or 0
    if _____5185_7F6ECD_79D2 > 0 then
        _____72B6_6001["下次允许毫秒"] = now + _____5185_7F6ECD_79D2 * 1000
    end
    local ____self_7 = self["层数控制器"]
    local _____65E7_5C42_6570 = ____self_7["取层数"](____self_7, ctx["单位"])
    local _____65B0_5C42_6570 = self["应用层数增加"](
        self,
        ctx["单位"],
        _____589E_52A0_5C42_6570,
        ctx["原因"] or ctx["来源"],
        now
    )
    if self["参数"]["on事件触发"] ~= nil then
        self["参数"]["on事件触发"](ctx, _____65B0_5C42_6570)
    end
    self["尝试触发满层"](
        self,
        ctx,
        _____72B6_6001,
        _____65E7_5C42_6570,
        _____65B0_5C42_6570
    )
    return _____65B0_5C42_6570
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["消耗层数"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "消耗层数"
    end
    local ____self_8 = self["层数控制器"]
    local _____5F53_524D_5C42_6570 = ____self_8["取层数"](____self_8, _____5355_4F4D)
    local _____5B9E_9645_6D88_8017 = _____5C42_6570 > _____5F53_524D_5C42_6570 and _____5F53_524D_5C42_6570 or _____5C42_6570
    local ____self_9 = self["层数控制器"]
    local _____65B0_5C42_6570 = ____self_9["减少"](____self_9, _____5355_4F4D, _____5B9E_9645_6D88_8017, _____539F_56E0)
    self["重建持续记录到当前层数"](self, _____5355_4F4D, _____65B0_5C42_6570)
    return _____5B9E_9645_6D88_8017
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["消耗全部"] = function(self, _____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "消耗全部"
    end
    local ____self_10 = self["层数控制器"]
    local _____5F53_524D_5C42_6570 = ____self_10["取层数"](____self_10, _____5355_4F4D)
    self["清空"](self, _____5355_4F4D, _____539F_56E0)
    return _____5F53_524D_5C42_6570
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["取层数"] = function(self, _____5355_4F4D)
    local ____self_11 = self["层数控制器"]
    return ____self_11["取层数"](____self_11, _____5355_4F4D)
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["清空"] = function(self, _____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "清空"
    end
    local id = _____53D6_5355_4F4DID(_____5355_4F4D)
    if id ~= 0 then
        __TS__Delete(self["单位状态表"], id)
    end
    local ____self_12 = self["层数控制器"]
    ____self_12["清空"](____self_12, _____5355_4F4D, _____539F_56E0)
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    local ____self_13 = self["层数控制器"]
    ____self_13["销毁"](____self_13)
    self["单位状态表"] = {}
    __TS__Delete(_____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868, self["控制器ID"])
    _____5C1D_8BD5_505C_6B62_4E8B_4EF6_53E0_5C42Tick()
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["推进过期"] = function(self, now)
    local _____6301_7EED_6A21_5F0F = self["参数"]["持续模式"] or "无"
    if _____6301_7EED_6A21_5F0F == "无" then
        return
    end
    for key in pairs(self["单位状态表"]) do
        do
            local _____72B6_6001 = self["单位状态表"][key]
            if _____72B6_6001 == nil then
                goto __continue41
            end
            if _____6301_7EED_6A21_5F0F == "刷新持续时间" then
                if _____72B6_6001["刷新到期毫秒"] > 0 and now >= _____72B6_6001["刷新到期毫秒"] then
                    self["清空ByID"](
                        self,
                        __TS__Number(key),
                        "持续时间到期"
                    )
                end
                goto __continue41
            end
            self["推进独立层过期"](
                self,
                __TS__Number(key),
                _____72B6_6001,
                now
            )
        end
        ::__continue41::
    end
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["计算增加层数"] = function(self, ctx)
    local _____6BCF_6B21_5C42_6570 = self["参数"]["每次层数"]
    if type(_____6BCF_6B21_5C42_6570) == "function" then
        return _____6BCF_6B21_5C42_6570(ctx)
    end
    return _____6BCF_6B21_5C42_6570 or 1
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["应用层数增加"] = function(self, _____5355_4F4D, _____5C42_6570, _____539F_56E0, now)
    local _____6301_7EED_6A21_5F0F = self["参数"]["持续模式"] or "无"
    local _____6301_7EED_79D2 = self["参数"]["层持续秒"] or 0
    local _____72B6_6001 = self["取或建单位状态"](self, _____5355_4F4D)
    if _____6301_7EED_6A21_5F0F == "刷新持续时间" and _____6301_7EED_79D2 > 0 then
        _____72B6_6001["刷新到期毫秒"] = now + _____6301_7EED_79D2 * 1000
    end
    if _____6301_7EED_6A21_5F0F == "独立持续时间" and _____6301_7EED_79D2 > 0 then
        local ____72B6_6001__72EC_7ACB_5C42_14 = _____72B6_6001["独立层"]
        ____72B6_6001__72EC_7ACB_5C42_14[#____72B6_6001__72EC_7ACB_5C42_14 + 1] = {["层数"] = _____5C42_6570, ["到期毫秒"] = now + _____6301_7EED_79D2 * 1000}
        local _____603B_5C42_6570 = self["计算独立层总和"](self, _____72B6_6001)
        local ____self_15 = self["层数控制器"]
        return ____self_15["设置"](____self_15, _____5355_4F4D, _____603B_5C42_6570, _____539F_56E0)
    end
    local ____self_16 = self["层数控制器"]
    return ____self_16["增加"](____self_16, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["尝试触发满层"] = function(self, ctx, _____72B6_6001, _____65E7_5C42_6570, _____65B0_5C42_6570)
    local _____5DF2_6EE1_5C42 = _____65B0_5C42_6570 >= self["参数"]["最大层数"]
    local _____521A_6EE1_5C42 = _____65E7_5C42_6570 < self["参数"]["最大层数"] and _____5DF2_6EE1_5C42
    if not _____5DF2_6EE1_5C42 then
        _____72B6_6001["上次是否满层"] = false
        return
    end
    if self["参数"]["on满层"] ~= nil and (not _____72B6_6001["上次是否满层"] or _____521A_6EE1_5C42) then
        self["参数"]["on满层"](__TS__ObjectAssign({}, ctx, {["当前层数"] = _____65B0_5C42_6570, ["是否刚满层"] = _____521A_6EE1_5C42}))
    end
    _____72B6_6001["上次是否满层"] = true
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["取或建单位状态"] = function(self, _____5355_4F4D)
    local id = _____53D6_5355_4F4DID(_____5355_4F4D)
    local _____72B6_6001 = self["单位状态表"][id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["单位"] = _____5355_4F4D,
            ["下次允许毫秒"] = 0,
            ["刷新到期毫秒"] = 0,
            ["独立层"] = {},
            ["上次是否满层"] = false
        }
        self["单位状态表"][id] = _____72B6_6001
    end
    return _____72B6_6001
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["推进独立层过期"] = function(self, id, _____72B6_6001, now)
    local changed = false
    do
        local i = #_____72B6_6001["独立层"] - 1
        while i >= 0 do
            do
                if now < _____72B6_6001["独立层"][i + 1]["到期毫秒"] then
                    goto __continue58
                end
                __TS__ArraySplice(_____72B6_6001["独立层"], i, 1)
                changed = true
            end
            ::__continue58::
            i = i - 1
        end
    end
    if not changed then
        return
    end
    local _____5355_4F4D = self["读取单位引用"](self, id)
    if _____5355_4F4D == nil then
        __TS__Delete(self["单位状态表"], id)
        return
    end
    local ____self_17 = self["层数控制器"]
    ____self_17["设置"](
        ____self_17,
        _____5355_4F4D,
        self["计算独立层总和"](self, _____72B6_6001),
        "独立层到期"
    )
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["计算独立层总和"] = function(self, _____72B6_6001)
    local _____603B_6570 = 0
    do
        local i = 0
        while i < #_____72B6_6001["独立层"] do
            _____603B_6570 = _____603B_6570 + _____72B6_6001["独立层"][i + 1]["层数"]
            i = i + 1
        end
    end
    return _____603B_6570
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["重建持续记录到当前层数"] = function(self, _____5355_4F4D, _____5F53_524D_5C42_6570)
    local id = _____53D6_5355_4F4DID(_____5355_4F4D)
    local _____72B6_6001 = self["单位状态表"][id]
    if _____72B6_6001 == nil then
        return
    end
    if _____5F53_524D_5C42_6570 <= 0 then
        __TS__Delete(self["单位状态表"], id)
        return
    end
    if (self["参数"]["持续模式"] or "无") == "独立持续时间" then
        _____72B6_6001["独立层"] = {{
            ["层数"] = _____5F53_524D_5C42_6570,
            ["到期毫秒"] = getServerTime() + (self["参数"]["层持续秒"] or 0) * 1000
        }}
    end
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["清空ByID"] = function(self, id, _____539F_56E0)
    local _____5355_4F4D = self["读取单位引用"](self, id)
    __TS__Delete(self["单位状态表"], id)
    if _____5355_4F4D ~= nil then
        local ____self_18 = self["层数控制器"]
        ____self_18["清空"](____self_18, _____5355_4F4D, _____539F_56E0)
    end
end
_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0.prototype["读取单位引用"] = function(self, id)
    local _____72B6_6001 = self["单位状态表"][id]
    if _____72B6_6001 == nil then
        return nil
    end
    return _____72B6_6001["单位"]
end
____exports["创建事件叠层状态"] = function(_____53C2_6570)
    return __TS__New(_____4E8B_4EF6_53E0_5C42_72B6_6001_5B9E_73B0, _____53C2_6570["状态ID"], _____53C2_6570)
end
local function _____5206_53D1_4E8B_4EF6_53E0_5C42(ctx)
    for key in pairs(_____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868) do
        local _____63A7_5236_5668 = _____4E8B_4EF6_53E0_5C42_63A7_5236_5668_8868[key]
        if _____63A7_5236_5668 ~= nil then
            _____63A7_5236_5668["处理事件"](_____63A7_5236_5668, ctx)
        end
    end
end
local function ____on_4E8B_4EF6_53E0_5C42_4F24_5BB3_4E8B_4EF6(target, attacker, applied, snapshot)
    if applied <= 0 then
        return
    end
    if _____5355_4F4D_6709_6548(attacker) then
        _____5206_53D1_4E8B_4EF6_53E0_5C42({
            ["来源"] = snapshot ~= nil and snapshot.isNormalAttack == true and "普攻命中" or "造成伤害",
            ["单位"] = attacker,
            ["目标单位"] = target,
            ["伤害值"] = applied,
            ["伤害快照"] = snapshot,
            ["原因"] = "伤害事件"
        })
    end
    if _____5355_4F4D_6709_6548(target) then
        _____5206_53D1_4E8B_4EF6_53E0_5C42({
            ["来源"] = "受到伤害",
            ["单位"] = target,
            ["来源单位"] = attacker,
            ["伤害值"] = applied,
            ["伤害快照"] = snapshot,
            ["原因"] = "受到伤害"
        })
    end
end
local function ____on_4E8B_4EF6_53E0_5C42_65BD_6CD5_4E8B_4EF6(castingUnit, spellAbilityId)
    if not _____5355_4F4D_6709_6548(castingUnit) then
        return
    end
    _____5206_53D1_4E8B_4EF6_53E0_5C42({["来源"] = "释放英雄技能", ["单位"] = castingUnit, ["技能ID"] = spellAbilityId, ["原因"] = "释放英雄技能"})
end
registerAppliedFinalDamageListener(____on_4E8B_4EF6_53E0_5C42_4F24_5BB3_4E8B_4EF6)
registerSpellEffectListener(____on_4E8B_4EF6_53E0_5C42_65BD_6CD5_4E8B_4EF6)
return ____exports
