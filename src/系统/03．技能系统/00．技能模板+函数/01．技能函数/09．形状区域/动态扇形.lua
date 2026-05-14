local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____53D6_53E5_67C4ID, _____8BA1_7B97_5750_6807_8DDD_79BB, _____53D6_8F83_5C0F_503C, _____53D6_8F83_5927_503C, _____53D6_6247_5F62_63D0_793A_5708_5C3A_5BF8, _____786E_4FDD_52A8_6001_6247_5F62_7CFB_7EDF_5DF2_542F_52A8, _____6CE8_518C_52A8_6001_6247_5F62_5B9E_4F8B, _____6CE8_9500_52A8_6001_6247_5F62_5B9E_4F8B, _____52A8_6001_6247_5F62_7CFB_7EDFTick, jass, GetHandleId, addPeriodicCallback, removePeriodicCallback, getServerTime, _____52A8_6001_6247_5F62_5B9E_4F8BID_8BA1_6570_5668, _____52A8_6001_6247_5F62_7CFB_7EDF_56DE_8C03ID, _____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B
function _____53D6_53E5_67C4ID(h)
    return h ~= nil and h ~= 0 and GetHandleId(h) or 0 or 0
end
function _____8BA1_7B97_5750_6807_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return jass.SquareRoot(dx * dx + dy * dy)
end
function _____53D6_8F83_5C0F_503C(a, b)
    return a < b and a or b
end
function _____53D6_8F83_5927_503C(a, b)
    return a > b and a or b
end
function _____53D6_6247_5F62_63D0_793A_5708_5C3A_5BF8(_____534A_5F84)
    if _____534A_5F84 <= 0 then
        return 0.01
    end
    return _____534A_5F84 / 512
end
function _____786E_4FDD_52A8_6001_6247_5F62_7CFB_7EDF_5DF2_542F_52A8()
    if _____52A8_6001_6247_5F62_7CFB_7EDF_56DE_8C03ID ~= 0 then
        return
    end
    _____52A8_6001_6247_5F62_7CFB_7EDF_56DE_8C03ID = addPeriodicCallback(100, _____52A8_6001_6247_5F62_7CFB_7EDFTick)
end
function _____6CE8_518C_52A8_6001_6247_5F62_5B9E_4F8B(_____5B9E_4F8B)
    _____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B[#_____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B + 1] = _____5B9E_4F8B
    _____786E_4FDD_52A8_6001_6247_5F62_7CFB_7EDF_5DF2_542F_52A8()
end
function _____6CE8_9500_52A8_6001_6247_5F62_5B9E_4F8B(_____5B9E_4F8B)
    local _____7D22_5F15 = __TS__ArrayIndexOf(_____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B, _____5B9E_4F8B)
    if _____7D22_5F15 >= 0 then
        __TS__ArraySplice(_____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B, _____7D22_5F15, 1)
    end
    if #_____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B == 0 and _____52A8_6001_6247_5F62_7CFB_7EDF_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____52A8_6001_6247_5F62_7CFB_7EDF_56DE_8C03ID)
        _____52A8_6001_6247_5F62_7CFB_7EDF_56DE_8C03ID = 0
    end
end
function _____52A8_6001_6247_5F62_7CFB_7EDFTick()
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____7D22_5F15 = 0
    while _____7D22_5F15 < #_____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B do
        local _____5B9E_4F8B = _____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B[_____7D22_5F15 + 1]
        _____5B9E_4F8B["系统Tick"](_____5B9E_4F8B, _____5F53_524D_65F6_95F4_6BEB_79D2)
        if _____7D22_5F15 < #_____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B and _____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B[_____7D22_5F15 + 1] == _____5B9E_4F8B then
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
jass = require("jass.common")
local japi = require("jass.japi")
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitDamageTarget = jass.UnitDamageTarget
local EXSetEffectZ = japi.EXSetEffectZ
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_1.isUnitEnemy
local isUnitAlly = ____require_result_1.isUnitAlly
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_2["获取扇形区域单位"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_7EA2_8272_6247_5F62_63D0_793A_5708_7279_6548 = ____require_result_3["创建红色扇形提示圈特效"]
local _____8BBE_7F6E_6247_5F62_63D0_793A_5708_671D_5411_4E0E_5C3A_5BF8 = ____require_result_3["设置扇形提示圈朝向与尺寸"]
local _____91CD_64AD_63D0_793A_5708_52A8_753B = ____require_result_3["重播提示圈动画"]
local _____7ACB_5373_9500_6BC1_63D0_793A_5708_7279_6548 = ____require_result_3["立即销毁提示圈特效"]
local _____52A8_6001_6247_5F62_5B9E_73B0 = __TS__Class()
_____52A8_6001_6247_5F62_5B9E_73B0.name = "动态扇形实现"
function _____52A8_6001_6247_5F62_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["已过时间值"] = 0
    self["已销毁值"] = false
    self["特效句柄"] = nil
    self["提示圈特效"] = nil
    self["命中记录"] = {}
    _____52A8_6001_6247_5F62_5B9E_4F8BID_8BA1_6570_5668 = _____52A8_6001_6247_5F62_5B9E_4F8BID_8BA1_6570_5668 + 1
    self["实例ID"] = _____52A8_6001_6247_5F62_5B9E_4F8BID_8BA1_6570_5668
    self["参数"] = _____53C2_6570
    self["当前X"] = _____53C2_6570.X
    self["当前Y"] = _____53C2_6570.Y
    self["当前半径值"] = _____53C2_6570["起始半径"]
    self["上次半径值"] = _____53C2_6570["起始半径"]
    self["半径差值"] = _____53C2_6570["结束半径"] - _____53C2_6570["起始半径"]
    self["变化时间毫秒"] = _____53C2_6570["变化时间"] * 1000
    local _____539F_59CB_6BEB_79D2 = (_____53C2_6570["检测间隔"] or 0.02) * 1000
    self["检测间隔毫秒值"] = _____539F_59CB_6BEB_79D2 > 20 and _____539F_59CB_6BEB_79D2 or 20
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    self["创建时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2
    self["下次检测时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + self["检测间隔毫秒值"]
    if _____53C2_6570["模型路径"] then
        self["特效句柄"] = AddSpecialEffect(_____53C2_6570["模型路径"], self["当前X"], self["当前Y"])
        if self["特效句柄"] and _____53C2_6570["特效高度"] then
            EXSetEffectZ(self["特效句柄"], _____53C2_6570["特效高度"])
        end
    end
    if _____53C2_6570["显示提示特效"] ~= false and _____53C2_6570["变化时间"] > 0 then
        self["提示圈特效"] = _____521B_5EFA_7EA2_8272_6247_5F62_63D0_793A_5708_7279_6548(
            self["当前X"],
            self["当前Y"],
            _____53C2_6570["方向角"],
            _____53D6_6247_5F62_63D0_793A_5708_5C3A_5BF8(self["当前半径值"]),
            1 / _____53C2_6570["变化时间"]
        )
    end
    _____6CE8_518C_52A8_6001_6247_5F62_5B9E_4F8B(self)
end
_____52A8_6001_6247_5F62_5B9E_73B0.prototype["系统Tick"] = function(self, _____5F53_524D_65F6_95F4_6BEB_79D2)
    if self["已销毁值"] then
        return
    end
    self["已过时间值"] = (_____5F53_524D_65F6_95F4_6BEB_79D2 - self["创建时间毫秒"]) / 1000
    if _____5F53_524D_65F6_95F4_6BEB_79D2 - self["创建时间毫秒"] >= self["变化时间毫秒"] then
        self["上次半径值"] = self["当前半径值"]
        self["当前半径值"] = self["参数"]["结束半径"]
        self["执行检测"](self)
        self["销毁"](self)
        return
    end
    if _____5F53_524D_65F6_95F4_6BEB_79D2 < self["下次检测时间毫秒"] then
        return
    end
    self["下次检测时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + self["检测间隔毫秒值"]
    self["上次半径值"] = self["当前半径值"]
    local _____8FDB_5EA6 = (_____5F53_524D_65F6_95F4_6BEB_79D2 - self["创建时间毫秒"]) / self["变化时间毫秒"]
    self["当前半径值"] = self["参数"]["起始半径"] + self["半径差值"] * _____8FDB_5EA6
    if self["当前半径值"] < 0 then
        self["当前半径值"] = 0
    end
    self["执行检测"](self)
end
_____52A8_6001_6247_5F62_5B9E_73B0.prototype["执行检测"] = function(self)
    if self["已销毁值"] then
        return
    end
    local _____5F53_524D_534A_5F84 = self["当前半径值"]
    if _____5F53_524D_534A_5F84 <= 0 or self["参数"]["扇形角度"] <= 0 then
        return
    end
    if self["提示圈特效"] then
        _____8BBE_7F6E_6247_5F62_63D0_793A_5708_671D_5411_4E0E_5C3A_5BF8(
            self["提示圈特效"],
            self["参数"]["方向角"],
            _____53D6_6247_5F62_63D0_793A_5708_5C3A_5BF8(_____5F53_524D_534A_5F84)
        )
        _____91CD_64AD_63D0_793A_5708_52A8_753B(self["提示圈特效"], 0)
    end
    local _____6240_6709_5355_4F4D = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = self["当前X"],
        Y = self["当前Y"],
        ["半径"] = _____5F53_524D_534A_5F84,
        ["方向角"] = self["参数"]["方向角"],
        ["扇形角度"] = self["参数"]["扇形角度"],
        ["包含边界"] = true
    })
    local _____5F53_524D_547D_4E2D_5355_4F4D = {}
    local ____self__53C2_6570__53EA_547D_4E2D_65B0_589E_8303_56F4_4 = self["参数"]["只命中新增范围"]
    if ____self__53C2_6570__53EA_547D_4E2D_65B0_589E_8303_56F4_4 == nil then
        ____self__53C2_6570__53EA_547D_4E2D_65B0_589E_8303_56F4_4 = true
    end
    local _____53EA_547D_4E2D_65B0_589E_8303_56F4 = ____self__53C2_6570__53EA_547D_4E2D_65B0_589E_8303_56F4_4
    local ____self__53C2_6570__5141_8BB8_91CD_590D_547D_4E2D_5 = self["参数"]["允许重复命中"]
    if ____self__53C2_6570__5141_8BB8_91CD_590D_547D_4E2D_5 == nil then
        ____self__53C2_6570__5141_8BB8_91CD_590D_547D_4E2D_5 = false
    end
    local _____5141_8BB8_91CD_590D_547D_4E2D = ____self__53C2_6570__5141_8BB8_91CD_590D_547D_4E2D_5
    local _____5185_534A_5F84 = _____53EA_547D_4E2D_65B0_589E_8303_56F4 and _____53D6_8F83_5C0F_503C(self["上次半径值"], _____5F53_524D_534A_5F84) or 0
    local _____5916_534A_5F84 = _____53EA_547D_4E2D_65B0_589E_8303_56F4 and _____53D6_8F83_5927_503C(self["上次半径值"], _____5F53_524D_534A_5F84) or _____5F53_524D_534A_5F84
    for ____, _____5355_4F4D in ipairs(_____6240_6709_5355_4F4D) do
        do
            if not self["是否影响目标"](self, _____5355_4F4D) then
                goto __continue15
            end
            local _____8DDD_79BB = _____8BA1_7B97_5750_6807_8DDD_79BB(
                self["当前X"],
                self["当前Y"],
                GetUnitX(_____5355_4F4D),
                GetUnitY(_____5355_4F4D)
            )
            if _____53EA_547D_4E2D_65B0_589E_8303_56F4 then
                if _____8DDD_79BB > _____5916_534A_5F84 or _____8DDD_79BB < _____5185_534A_5F84 then
                    goto __continue15
                end
            end
            local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
            if not _____5141_8BB8_91CD_590D_547D_4E2D and self["命中记录"][_____5355_4F4DID] then
                goto __continue15
            end
            _____5F53_524D_547D_4E2D_5355_4F4D[#_____5F53_524D_547D_4E2D_5355_4F4D + 1] = _____5355_4F4D
            self["命中记录"][_____5355_4F4DID] = true
            if (self["参数"]["伤害值"] or 0) > 0 and ATTACK_TYPE_NORMAL then
                local ____self__53C2_6570__6240_6709_8005_6 = self["参数"]["所有者"]
                if ____self__53C2_6570__6240_6709_8005_6 == nil then
                    ____self__53C2_6570__6240_6709_8005_6 = _____5355_4F4D
                end
                UnitDamageTarget(
                    ____self__53C2_6570__6240_6709_8005_6,
                    _____5355_4F4D,
                    self["参数"]["伤害值"] or 0,
                    false,
                    false,
                    ATTACK_TYPE_NORMAL,
                    DAMAGE_TYPE_NORMAL,
                    nil
                )
            end
            local ____opt_7 = self["参数"]["on命中"]
            if ____opt_7 ~= nil then
                ____opt_7(_____5355_4F4D, _____5F53_524D_534A_5F84)
            end
        end
        ::__continue15::
    end
    local ____opt_9 = self["参数"]["on周期"]
    if ____opt_9 ~= nil then
        ____opt_9(_____5F53_524D_547D_4E2D_5355_4F4D, _____5F53_524D_534A_5F84, self["上次半径值"])
    end
end
_____52A8_6001_6247_5F62_5B9E_73B0.prototype["是否影响目标"] = function(self, _____5355_4F4D)
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
_____52A8_6001_6247_5F62_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁值"] then
        return
    end
    self["已销毁值"] = true
    _____6CE8_9500_52A8_6001_6247_5F62_5B9E_4F8B(self)
    if self["特效句柄"] then
        DestroyEffect(self["特效句柄"])
        self["特效句柄"] = nil
    end
    if self["提示圈特效"] then
        _____7ACB_5373_9500_6BC1_63D0_793A_5708_7279_6548(self["提示圈特效"])
        self["提示圈特效"] = nil
    end
    local ____opt_11 = self["参数"]["on销毁"]
    if ____opt_11 ~= nil then
        ____opt_11()
    end
end
__TS__SetDescriptor(
    _____52A8_6001_6247_5F62_5B9E_73B0.prototype,
    "当前半径",
    {get = function(self)
        return self["当前半径值"]
    end},
    true
)
__TS__SetDescriptor(
    _____52A8_6001_6247_5F62_5B9E_73B0.prototype,
    "已过时间",
    {get = function(self)
        return self["已过时间值"]
    end},
    true
)
__TS__SetDescriptor(
    _____52A8_6001_6247_5F62_5B9E_73B0.prototype,
    "已销毁",
    {get = function(self)
        return self["已销毁值"]
    end},
    true
)
_____52A8_6001_6247_5F62_5B9E_4F8BID_8BA1_6570_5668 = 0
_____52A8_6001_6247_5F62_7CFB_7EDF_56DE_8C03ID = 0
_____6D3B_8DC3_52A8_6001_6247_5F62_5B9E_4F8B = {}
____exports["创建动态扇形"] = function(_____53C2_6570)
    return __TS__New(_____52A8_6001_6247_5F62_5B9E_73B0, _____53C2_6570)
end
return ____exports
