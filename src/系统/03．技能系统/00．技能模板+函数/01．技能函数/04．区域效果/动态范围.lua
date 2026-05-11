local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____786E_4FDD_52A8_6001_8303_56F4_7CFB_7EDF_5DF2_542F_52A8, _____6CE8_518C_52A8_6001_8303_56F4_5B9E_4F8B, _____6CE8_9500_52A8_6001_8303_56F4_5B9E_4F8B, _____52A8_6001_8303_56F4_7CFB_7EDFTick, _____53D6_8F83_5C0F_503C, addPeriodicCallback, removePeriodicCallback, getServerTime, _____52A8_6001_8303_56F4_5B9E_4F8BID_8BA1_6570_5668, _____52A8_6001_8303_56F4_7CFB_7EDF_56DE_8C03ID, _____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B
function _____786E_4FDD_52A8_6001_8303_56F4_7CFB_7EDF_5DF2_542F_52A8()
    if _____52A8_6001_8303_56F4_7CFB_7EDF_56DE_8C03ID ~= 0 then
        return
    end
    _____52A8_6001_8303_56F4_7CFB_7EDF_56DE_8C03ID = addPeriodicCallback(20, _____52A8_6001_8303_56F4_7CFB_7EDFTick)
end
function _____6CE8_518C_52A8_6001_8303_56F4_5B9E_4F8B(_____5B9E_4F8B)
    _____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B[#_____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B + 1] = _____5B9E_4F8B
    _____786E_4FDD_52A8_6001_8303_56F4_7CFB_7EDF_5DF2_542F_52A8()
end
function _____6CE8_9500_52A8_6001_8303_56F4_5B9E_4F8B(_____5B9E_4F8B)
    local _____7D22_5F15 = __TS__ArrayIndexOf(_____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B, _____5B9E_4F8B)
    if _____7D22_5F15 >= 0 then
        __TS__ArraySplice(_____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B, _____7D22_5F15, 1)
    end
    if #_____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B == 0 and _____52A8_6001_8303_56F4_7CFB_7EDF_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____52A8_6001_8303_56F4_7CFB_7EDF_56DE_8C03ID)
        _____52A8_6001_8303_56F4_7CFB_7EDF_56DE_8C03ID = 0
    end
end
function _____52A8_6001_8303_56F4_7CFB_7EDFTick()
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____7D22_5F15 = 0
    while _____7D22_5F15 < #_____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B do
        local _____5B9E_4F8B = _____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B[_____7D22_5F15 + 1]
        _____5B9E_4F8B["系统Tick"](_____5B9E_4F8B, _____5F53_524D_65F6_95F4_6BEB_79D2)
        if _____7D22_5F15 < #_____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B and _____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B[_____7D22_5F15 + 1] == _____5B9E_4F8B then
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
function _____53D6_8F83_5C0F_503C(a, b)
    return a < b and a or b
end
--- 通用函数 - 动态范围
-- 支持半径随时间动态变化的范围伤害效果。
-- 扩散：起始半径 → 结束半径（从小到大）
-- 收缩：起始半径 → 结束半径（从大到小）
-- 每次 tick 对当前半径内目标造成一次伤害。
-- 使用中心计时器 addPeriodicCallback 做周期检测，不额外创建 timer。
local jass = require("jass.common")
local japi = require("jass.japi")
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
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
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_8584_5706_5F62_63D0_793A_5708_7279_6548 = ____require_result_3["创建薄圆形提示圈特效"]
local _____7ACB_5373_9500_6BC1_63D0_793A_5708_7279_6548 = ____require_result_3["立即销毁提示圈特效"]
local _____52A8_6001_8303_56F4_5B9E_73B0 = __TS__Class()
_____52A8_6001_8303_56F4_5B9E_73B0.name = "动态范围实现"
function _____52A8_6001_8303_56F4_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["已过时间值"] = 0
    self["已销毁值"] = false
    self["特效句柄"] = nil
    self["提示圈特效"] = nil
    _____52A8_6001_8303_56F4_5B9E_4F8BID_8BA1_6570_5668 = _____52A8_6001_8303_56F4_5B9E_4F8BID_8BA1_6570_5668 + 1
    self["实例ID"] = _____52A8_6001_8303_56F4_5B9E_4F8BID_8BA1_6570_5668
    self["参数"] = _____53C2_6570
    self["当前X"] = _____53C2_6570.X
    self["当前Y"] = _____53C2_6570.Y
    self["当前半径值"] = _____53C2_6570["起始半径"]
    self["半径差值"] = _____53C2_6570["结束半径"] - _____53C2_6570["起始半径"]
    self["变化时间毫秒"] = _____53C2_6570["变化时间"] * 1000
    local _____539F_59CB_6BEB_79D2 = (_____53C2_6570["检测间隔"] or 0.1) * 1000
    self["检测间隔毫秒值"] = _____539F_59CB_6BEB_79D2 > 20 and _____539F_59CB_6BEB_79D2 or 20
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    self["创建时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2
    self["结束时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + self["变化时间毫秒"]
    self["当前段目标时间毫秒"] = _____53D6_8F83_5C0F_503C(self["创建时间毫秒"] + self["检测间隔毫秒值"], self["结束时间毫秒"])
    if _____53C2_6570["模型路径"] then
        self["特效句柄"] = AddSpecialEffect(_____53C2_6570["模型路径"], self["当前X"], self["当前Y"])
        if self["特效句柄"] and _____53C2_6570["特效高度"] then
            EXSetEffectZ(self["特效句柄"], _____53C2_6570["特效高度"])
        end
    end
    if _____53C2_6570["变化时间"] > 0 then
        self["创建当前段提示特效"](self, self["创建时间毫秒"])
    end
    _____6CE8_518C_52A8_6001_8303_56F4_5B9E_4F8B(self)
end
_____52A8_6001_8303_56F4_5B9E_73B0.prototype["系统Tick"] = function(self, _____5F53_524D_65F6_95F4_6BEB_79D2)
    if self["已销毁值"] then
        return
    end
    self["已过时间值"] = (_____5F53_524D_65F6_95F4_6BEB_79D2 - self["创建时间毫秒"]) / 1000
    if _____5F53_524D_65F6_95F4_6BEB_79D2 < self["当前段目标时间毫秒"] then
        return
    end
    while not self["已销毁值"] and _____5F53_524D_65F6_95F4_6BEB_79D2 >= self["当前段目标时间毫秒"] do
        self["销毁当前段提示特效"](self)
        self["当前半径值"] = self["取指定时间半径"](self, self["当前段目标时间毫秒"])
        self["执行检测"](self)
        if self["当前段目标时间毫秒"] >= self["结束时间毫秒"] then
            self["销毁"](self)
            return
        end
        self["当前段目标时间毫秒"] = _____53D6_8F83_5C0F_503C(self["当前段目标时间毫秒"] + self["检测间隔毫秒值"], self["结束时间毫秒"])
        if _____5F53_524D_65F6_95F4_6BEB_79D2 < self["当前段目标时间毫秒"] then
            self["创建当前段提示特效"](self, _____5F53_524D_65F6_95F4_6BEB_79D2)
        end
    end
end
_____52A8_6001_8303_56F4_5B9E_73B0.prototype["执行检测"] = function(self)
    if self["已销毁值"] then
        return
    end
    local _____5F53_524D_534A_5F84 = self["当前半径值"]
    if _____5F53_524D_534A_5F84 <= 0 then
        return
    end
    local _____6240_6709_5355_4F4D = getUnitsInRange(self["当前X"], self["当前Y"], _____5F53_524D_534A_5F84)
    local _____76EE_6807_5355_4F4D = {}
    for ____, _____5355_4F4D in ipairs(_____6240_6709_5355_4F4D) do
        if self["是否影响目标"](self, _____5355_4F4D) then
            _____76EE_6807_5355_4F4D[#_____76EE_6807_5355_4F4D + 1] = _____5355_4F4D
        end
    end
    if (self["参数"]["伤害值"] or 0) > 0 and ATTACK_TYPE_NORMAL then
        for ____, _____5355_4F4D in ipairs(_____76EE_6807_5355_4F4D) do
            local ____self__53C2_6570__6240_6709_8005_4 = self["参数"]["所有者"]
            if ____self__53C2_6570__6240_6709_8005_4 == nil then
                ____self__53C2_6570__6240_6709_8005_4 = _____5355_4F4D
            end
            UnitDamageTarget(
                ____self__53C2_6570__6240_6709_8005_4,
                _____5355_4F4D,
                self["参数"]["伤害值"] or 0,
                false,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_NORMAL,
                nil
            )
        end
    end
    local ____opt_5 = self["参数"]["on周期"]
    if ____opt_5 ~= nil then
        ____opt_5(_____76EE_6807_5355_4F4D, _____5F53_524D_534A_5F84)
    end
end
_____52A8_6001_8303_56F4_5B9E_73B0.prototype["是否影响目标"] = function(self, _____5355_4F4D)
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
_____52A8_6001_8303_56F4_5B9E_73B0.prototype["取指定时间半径"] = function(self, _____76EE_6807_65F6_95F4_6BEB_79D2)
    if self["变化时间毫秒"] <= 0 then
        return self["参数"]["结束半径"]
    end
    local _____8FDB_5EA6 = (_____76EE_6807_65F6_95F4_6BEB_79D2 - self["创建时间毫秒"]) / self["变化时间毫秒"]
    if _____8FDB_5EA6 < 0 then
        _____8FDB_5EA6 = 0
    elseif _____8FDB_5EA6 > 1 then
        _____8FDB_5EA6 = 1
    end
    local _____534A_5F84 = self["参数"]["起始半径"] + self["半径差值"] * _____8FDB_5EA6
    return _____534A_5F84 < 0 and 0 or _____534A_5F84
end
_____52A8_6001_8303_56F4_5B9E_73B0.prototype["创建当前段提示特效"] = function(self, _____5F53_524D_65F6_95F4_6BEB_79D2)
    if self["参数"]["变化时间"] <= 0 then
        return
    end
    local _____5F53_524D_6BB5_76EE_6807_534A_5F84 = self["取指定时间半径"](self, self["当前段目标时间毫秒"])
    if _____5F53_524D_6BB5_76EE_6807_534A_5F84 <= 0 then
        return
    end
    local _____5269_4F59_6301_7EED_65F6_95F4_6BEB_79D2 = self["当前段目标时间毫秒"] - _____5F53_524D_65F6_95F4_6BEB_79D2
    if _____5269_4F59_6301_7EED_65F6_95F4_6BEB_79D2 <= 0 then
        return
    end
    local _____5269_4F59_6301_7EED_65F6_95F4_79D2 = _____5269_4F59_6301_7EED_65F6_95F4_6BEB_79D2 / 1000
    self["提示圈特效"] = _____521B_5EFA_8584_5706_5F62_63D0_793A_5708_7279_6548(
        self["当前X"],
        self["当前Y"],
        _____5F53_524D_6BB5_76EE_6807_534A_5F84,
        1 / _____5269_4F59_6301_7EED_65F6_95F4_79D2,
        self["参数"]["所有者"]
    )
end
_____52A8_6001_8303_56F4_5B9E_73B0.prototype["销毁当前段提示特效"] = function(self)
    if not self["提示圈特效"] then
        return
    end
    _____7ACB_5373_9500_6BC1_63D0_793A_5708_7279_6548(self["提示圈特效"])
    self["提示圈特效"] = nil
end
_____52A8_6001_8303_56F4_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁值"] then
        return
    end
    self["已销毁值"] = true
    _____6CE8_9500_52A8_6001_8303_56F4_5B9E_4F8B(self)
    if self["特效句柄"] then
        DestroyEffect(self["特效句柄"])
        self["特效句柄"] = nil
    end
    self["销毁当前段提示特效"](self)
    local ____opt_7 = self["参数"]["on销毁"]
    if ____opt_7 ~= nil then
        ____opt_7()
    end
end
__TS__SetDescriptor(
    _____52A8_6001_8303_56F4_5B9E_73B0.prototype,
    "当前半径",
    {get = function(self)
        return self["当前半径值"]
    end},
    true
)
__TS__SetDescriptor(
    _____52A8_6001_8303_56F4_5B9E_73B0.prototype,
    "已过时间",
    {get = function(self)
        return self["已过时间值"]
    end},
    true
)
__TS__SetDescriptor(
    _____52A8_6001_8303_56F4_5B9E_73B0.prototype,
    "已销毁",
    {get = function(self)
        return self["已销毁值"]
    end},
    true
)
_____52A8_6001_8303_56F4_5B9E_4F8BID_8BA1_6570_5668 = 0
_____52A8_6001_8303_56F4_7CFB_7EDF_56DE_8C03ID = 0
_____6D3B_8DC3_52A8_6001_8303_56F4_5B9E_4F8B = {}
____exports["创建动态范围"] = function(_____53C2_6570)
    return __TS__New(_____52A8_6001_8303_56F4_5B9E_73B0, _____53C2_6570)
end
return ____exports
