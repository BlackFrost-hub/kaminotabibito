local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____786E_4FDD_533A_57DF_6548_679C_7CFB_7EDF_5DF2_542F_52A8, _____6CE8_518C_533A_57DF_6548_679C_5B9E_4F8B, _____6CE8_9500_533A_57DF_6548_679C_5B9E_4F8B, _____533A_57DF_6548_679C_7CFB_7EDFTick, addPeriodicCallback, removePeriodicCallback, getServerTime, _____533A_57DF_6548_679C_5B9E_4F8BID_8BA1_6570_5668, _____533A_57DF_6548_679C_7CFB_7EDF_56DE_8C03ID, _____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B
function _____786E_4FDD_533A_57DF_6548_679C_7CFB_7EDF_5DF2_542F_52A8()
    if _____533A_57DF_6548_679C_7CFB_7EDF_56DE_8C03ID ~= 0 then
        return
    end
    _____533A_57DF_6548_679C_7CFB_7EDF_56DE_8C03ID = addPeriodicCallback(100, _____533A_57DF_6548_679C_7CFB_7EDFTick)
end
function _____6CE8_518C_533A_57DF_6548_679C_5B9E_4F8B(_____5B9E_4F8B)
    _____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B[#_____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B + 1] = _____5B9E_4F8B
    _____786E_4FDD_533A_57DF_6548_679C_7CFB_7EDF_5DF2_542F_52A8()
end
function _____6CE8_9500_533A_57DF_6548_679C_5B9E_4F8B(_____5B9E_4F8B)
    local _____7D22_5F15 = __TS__ArrayIndexOf(_____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B, _____5B9E_4F8B)
    if _____7D22_5F15 >= 0 then
        __TS__ArraySplice(_____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B, _____7D22_5F15, 1)
    end
    if #_____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B == 0 and _____533A_57DF_6548_679C_7CFB_7EDF_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____533A_57DF_6548_679C_7CFB_7EDF_56DE_8C03ID)
        _____533A_57DF_6548_679C_7CFB_7EDF_56DE_8C03ID = 0
    end
end
function _____533A_57DF_6548_679C_7CFB_7EDFTick()
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____7D22_5F15 = 0
    while _____7D22_5F15 < #_____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B do
        local _____5B9E_4F8B = _____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B[_____7D22_5F15 + 1]
        _____5B9E_4F8B["系统Tick"](_____5B9E_4F8B, _____5F53_524D_65F6_95F4_6BEB_79D2)
        if _____7D22_5F15 < #_____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B and _____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B[_____7D22_5F15 + 1] == _____5B9E_4F8B then
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
--- 通用函数 - 区域效果
-- 
-- 支持持续性区域效果：周期性伤害、进入/离开事件、地面特效等。
-- 使用中心计时器 addPeriodicCallback 做周期检测，不额外创建 timer。
local jass = require("jass.common")
local japi = require("jass.japi")
local GetHandleId = jass.GetHandleId
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local CreateGroup = jass.CreateGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local DestroyGroup = jass.DestroyGroup
local UnitDamageTarget = jass.UnitDamageTarget
local EXSetEffectZ = japi.EXSetEffectZ
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_2.isUnitEnemy
local isUnitAlly = ____require_result_2.isUnitAlly
local _____533A_57DF_6548_679C_5B9E_73B0 = __TS__Class()
_____533A_57DF_6548_679C_5B9E_73B0.name = "区域效果实现"
function _____533A_57DF_6548_679C_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["当前单位集合"] = {}
    self["已暂停值"] = false
    self["已销毁值"] = false
    self["特效句柄"] = nil
    self["首次检测值"] = true
    self["单位最后进入时间"] = {}
    self["单位最后离开时间"] = {}
    _____533A_57DF_6548_679C_5B9E_4F8BID_8BA1_6570_5668 = _____533A_57DF_6548_679C_5B9E_4F8BID_8BA1_6570_5668 + 1
    self["实例ID"] = _____533A_57DF_6548_679C_5B9E_4F8BID_8BA1_6570_5668
    self["参数"] = _____53C2_6570
    self["当前X"] = _____53C2_6570.X
    self["当前Y"] = _____53C2_6570.Y
    self["剩余时间值"] = _____53C2_6570["持续时间"]
    self["检测间隔秒值"] = _____53C2_6570["检测间隔"] or 0.02
    local _____539F_59CB_6BEB_79D2 = self["检测间隔秒值"] * 1000
    self["检测间隔毫秒值"] = _____539F_59CB_6BEB_79D2 > 20 and _____539F_59CB_6BEB_79D2 or 20
    self["防抖间隔毫秒值"] = (_____53C2_6570["防抖间隔"] or 0.2) * 1000
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    self["下次检测时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + self["检测间隔毫秒值"]
    self["销毁时间毫秒"] = _____53C2_6570["持续时间"] > 0 and _____5F53_524D_65F6_95F4_6BEB_79D2 + _____53C2_6570["持续时间"] * 1000 or 0
    if _____53C2_6570["模型路径"] then
        self["特效句柄"] = AddSpecialEffect(_____53C2_6570["模型路径"], self["当前X"], self["当前Y"])
        if self["特效句柄"] and _____53C2_6570["特效高度"] then
            EXSetEffectZ(self["特效句柄"], _____53C2_6570["特效高度"])
        end
    end
    _____6CE8_518C_533A_57DF_6548_679C_5B9E_4F8B(self)
end
_____533A_57DF_6548_679C_5B9E_73B0.prototype["系统Tick"] = function(self, _____5F53_524D_65F6_95F4_6BEB_79D2)
    if self["已暂停值"] or self["已销毁值"] then
        return
    end
    if self["销毁时间毫秒"] > 0 and _____5F53_524D_65F6_95F4_6BEB_79D2 >= self["销毁时间毫秒"] then
        self["销毁"](self)
        return
    end
    if _____5F53_524D_65F6_95F4_6BEB_79D2 < self["下次检测时间毫秒"] then
        return
    end
    self["下次检测时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + self["检测间隔毫秒值"]
    self["执行检测"](self)
end
_____533A_57DF_6548_679C_5B9E_73B0.prototype["执行检测"] = function(self)
    if self["已暂停值"] or self["已销毁值"] then
        return
    end
    local _____95F4_9694 = self["检测间隔秒值"]
    if self["参数"]["持续时间"] > 0 then
        self["剩余时间值"] = self["剩余时间值"] - _____95F4_9694
        if self["剩余时间值"] <= 0 then
            self["销毁"](self)
            return
        end
    end
    local _____5F53_524D_5355_4F4D = getUnitsInRange(self["当前X"], self["当前Y"], self["参数"]["半径"])
    local _____65B0_96C6_5408 = {}
    local _____662F_9996_6B21 = self["首次检测值"]
    if _____662F_9996_6B21 then
        self["首次检测值"] = false
    end
    local _____5F53_524D_65F6_95F4 = getServerTime()
    local _____9632_6296_6BEB_79D2 = self["防抖间隔毫秒值"]
    for ____, _____5355_4F4D in ipairs(_____5F53_524D_5355_4F4D) do
        do
            local hid = GetHandleId(_____5355_4F4D)
            if not self["是否影响目标"](self, _____5355_4F4D) then
                goto __continue14
            end
            _____65B0_96C6_5408[hid] = _____5355_4F4D
            if not _____662F_9996_6B21 and not self["当前单位集合"][hid] then
                local _____4E0A_6B21_79BB_5F00 = self["单位最后离开时间"][hid]
                if _____4E0A_6B21_79BB_5F00 == nil or _____5F53_524D_65F6_95F4 - _____4E0A_6B21_79BB_5F00 >= _____9632_6296_6BEB_79D2 then
                    local ____opt_3 = self["参数"]["on进入"]
                    if ____opt_3 ~= nil then
                        ____opt_3(_____5355_4F4D)
                    end
                end
                self["单位最后进入时间"][hid] = _____5F53_524D_65F6_95F4
            end
        end
        ::__continue14::
    end
    for hid in pairs(self["当前单位集合"]) do
        if not _____65B0_96C6_5408[hid] then
            local _____4E0A_6B21_8FDB_5165 = self["单位最后进入时间"][hid]
            if _____4E0A_6B21_8FDB_5165 == nil or _____5F53_524D_65F6_95F4 - _____4E0A_6B21_8FDB_5165 >= _____9632_6296_6BEB_79D2 then
                local ____opt_5 = self["参数"]["on离开"]
                if ____opt_5 ~= nil then
                    ____opt_5(self["当前单位集合"][hid])
                end
            end
            self["单位最后离开时间"][hid] = _____5F53_524D_65F6_95F4
        end
    end
    self["当前单位集合"] = _____65B0_96C6_5408
    local _____5F53_524D_5355_4F4D_6570_7EC4 = __TS__ObjectValues(_____65B0_96C6_5408)
    if self["参数"]["周期伤害"] and self["参数"]["周期伤害"] > 0 and ATTACK_TYPE_NORMAL then
        for ____, _____5355_4F4D in ipairs(_____5F53_524D_5355_4F4D_6570_7EC4) do
            local ____self__53C2_6570__6240_6709_8005_7 = self["参数"]["所有者"]
            if ____self__53C2_6570__6240_6709_8005_7 == nil then
                ____self__53C2_6570__6240_6709_8005_7 = _____5355_4F4D
            end
            UnitDamageTarget(
                ____self__53C2_6570__6240_6709_8005_7,
                _____5355_4F4D,
                self["参数"]["周期伤害"],
                false,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_NORMAL,
                nil
            )
        end
    end
    local ____opt_8 = self["参数"]["on周期"]
    if ____opt_8 ~= nil then
        ____opt_8(_____5F53_524D_5355_4F4D_6570_7EC4)
    end
end
_____533A_57DF_6548_679C_5B9E_73B0.prototype["是否影响目标"] = function(self, _____5355_4F4D)
    local _____5F71_54CD_76EE_6807 = self["参数"]["影响目标"] or "敌方"
    local _____6240_6709_8005 = self["参数"]["所有者"]
    if _____5F71_54CD_76EE_6807 == "全部" then
        return true
    end
    if not _____6240_6709_8005 then
        return true
    end
    if _____5F71_54CD_76EE_6807 == "敌方" then
        return isUnitEnemy(_____5355_4F4D, _____6240_6709_8005)
    end
    return isUnitAlly(_____5355_4F4D, _____6240_6709_8005)
end
_____533A_57DF_6548_679C_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁值"] then
        return
    end
    self["已销毁值"] = true
    _____6CE8_9500_533A_57DF_6548_679C_5B9E_4F8B(self)
    if self["特效句柄"] then
        DestroyEffect(self["特效句柄"])
        self["特效句柄"] = nil
    end
    local ____opt_10 = self["参数"]["on销毁"]
    if ____opt_10 ~= nil then
        ____opt_10()
    end
    self["当前单位集合"] = {}
    self["单位最后进入时间"] = {}
    self["单位最后离开时间"] = {}
end
_____533A_57DF_6548_679C_5B9E_73B0.prototype["暂停"] = function(self)
    self["已暂停值"] = true
end
_____533A_57DF_6548_679C_5B9E_73B0.prototype["恢复"] = function(self)
    self["已暂停值"] = false
end
_____533A_57DF_6548_679C_5B9E_73B0.prototype["移动到"] = function(self, X, Y)
    self["当前X"] = X
    self["当前Y"] = Y
    if self["特效句柄"] and self["参数"]["模型路径"] then
        DestroyEffect(self["特效句柄"])
        self["特效句柄"] = AddSpecialEffect(self["参数"]["模型路径"], X, Y)
        if self["特效句柄"] and self["参数"]["特效高度"] then
            EXSetEffectZ(self["特效句柄"], self["参数"]["特效高度"])
        end
    end
    local _____5F53_524D_65F6_95F4 = getServerTime()
    local _____9632_6296_6BEB_79D2 = self["防抖间隔毫秒值"]
    for hid in pairs(self["当前单位集合"]) do
        local _____4E0A_6B21_8FDB_5165 = self["单位最后进入时间"][hid]
        if _____4E0A_6B21_8FDB_5165 == nil or _____5F53_524D_65F6_95F4 - _____4E0A_6B21_8FDB_5165 >= _____9632_6296_6BEB_79D2 then
            local ____opt_12 = self["参数"]["on离开"]
            if ____opt_12 ~= nil then
                ____opt_12(self["当前单位集合"][hid])
            end
        end
        self["单位最后离开时间"][hid] = _____5F53_524D_65F6_95F4
    end
    self["当前单位集合"] = {}
end
__TS__SetDescriptor(
    _____533A_57DF_6548_679C_5B9E_73B0.prototype,
    "剩余时间",
    {get = function(self)
        return self["剩余时间值"]
    end},
    true
)
__TS__SetDescriptor(
    _____533A_57DF_6548_679C_5B9E_73B0.prototype,
    "当前区域内单位",
    {get = function(self)
        return __TS__ObjectValues(self["当前单位集合"])
    end},
    true
)
__TS__SetDescriptor(
    _____533A_57DF_6548_679C_5B9E_73B0.prototype,
    "已暂停",
    {get = function(self)
        return self["已暂停值"]
    end},
    true
)
_____533A_57DF_6548_679C_5B9E_4F8BID_8BA1_6570_5668 = 0
_____533A_57DF_6548_679C_7CFB_7EDF_56DE_8C03ID = 0
_____6D3B_8DC3_533A_57DF_6548_679C_5B9E_4F8B = {}
____exports["创建区域效果"] = function(_____53C2_6570)
    return __TS__New(_____533A_57DF_6548_679C_5B9E_73B0, _____53C2_6570)
end
return ____exports
