local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_6301_7EED_5355_4F4D_8FDE_7EBFTick, getServerTime
local ____17_FF0E_95EA_7535_6548_679C_4EE3_7801 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____9ED8_8BA4_95EA_7535_6548_679C_4EE3_7801 = ____17_FF0E_95EA_7535_6548_679C_4EE3_7801["默认闪电效果代码"]
function ____on_6301_7EED_5355_4F4D_8FDE_7EBFTick(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["推进"](
            _____5B9E_4F8B,
            getServerTime()
        )
    end
end
local jass = require("jass.common")
local AddLightningEx = jass.AddLightningEx
local MoveLightningEx = jass.MoveLightningEx
local DestroyLightning = jass.DestroyLightning
local SetLightningColor = jass.SetLightningColor
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isValidUnit = ____require_result_1.isValidUnit
local function _____8DDD_79BB_5E73_65B9(a, b)
    local dx = GetUnitX(a) - GetUnitX(b)
    local dy = GetUnitY(a) - GetUnitY(b)
    return dx * dx + dy * dy
end
local function _____53D6_5355_4F4DZ(_____5355_4F4D, _____9AD8_5EA6)
    return GetUnitFlyHeight(_____5355_4F4D) + _____9AD8_5EA6
end
local _____6301_7EED_5355_4F4D_8FDE_7EBF_5B9E_73B0 = __TS__Class()
_____6301_7EED_5355_4F4D_8FDE_7EBF_5B9E_73B0.name = "持续单位连线实现"
function _____6301_7EED_5355_4F4D_8FDE_7EBF_5B9E_73B0.prototype.____constructor(self, _____95EA_7535, _____53C2_6570)
    self["Tick回调ID"] = 0
    self["已停止"] = false
    self["闪电"] = _____95EA_7535
    self["参数"] = _____53C2_6570
    self["到期Ms"] = (_____53C2_6570["持续秒"] == nil or _____53C2_6570["持续秒"] <= 0) and 0 or getServerTime() + _____53C2_6570["持续秒"] * 1000
    self["Tick回调ID"] = addPeriodicCallback(_____53C2_6570["Tick间隔毫秒"] or 30, ____on_6301_7EED_5355_4F4D_8FDE_7EBFTick, self)
end
_____6301_7EED_5355_4F4D_8FDE_7EBF_5B9E_73B0.prototype["推进"] = function(self, now)
    if self["已停止"] then
        return
    end
    local _____8D77_70B9 = self["参数"]["起点单位"]
    local _____7EC8_70B9 = self["参数"]["终点单位"]
    if not isValidUnit(_____8D77_70B9) or not isValidUnit(_____7EC8_70B9) then
        self["停止"](self, "单位失效")
        return
    end
    if self["到期Ms"] > 0 and now >= self["到期Ms"] then
        self["停止"](self, "持续时间结束")
        return
    end
    local _____65AD_5F00_8DDD_79BB = self["参数"]["断开距离"]
    if _____65AD_5F00_8DDD_79BB ~= nil and _____65AD_5F00_8DDD_79BB > 0 and _____8DDD_79BB_5E73_65B9(_____8D77_70B9, _____7EC8_70B9) > _____65AD_5F00_8DDD_79BB * _____65AD_5F00_8DDD_79BB then
        self["停止"](self, "距离断开")
        return
    end
    MoveLightningEx(
        self["闪电"],
        false,
        GetUnitX(_____8D77_70B9),
        GetUnitY(_____8D77_70B9),
        _____53D6_5355_4F4DZ(_____8D77_70B9, self["参数"]["起点高度"] or 60),
        GetUnitX(_____7EC8_70B9),
        GetUnitY(_____7EC8_70B9),
        _____53D6_5355_4F4DZ(_____7EC8_70B9, self["参数"]["终点高度"] or 60)
    )
    if self["参数"]["on周期"] ~= nil then
        self["参数"]["on周期"](_____8D77_70B9, _____7EC8_70B9)
    end
end
_____6301_7EED_5355_4F4D_8FDE_7EBF_5B9E_73B0.prototype["停止"] = function(self, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动停止"
    end
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    if self["Tick回调ID"] ~= 0 then
        removePeriodicCallback(self["Tick回调ID"])
        self["Tick回调ID"] = 0
    end
    if self["闪电"] ~= nil and self["闪电"] ~= 0 then
        DestroyLightning(self["闪电"])
    end
    if self["参数"]["on断开"] ~= nil then
        self["参数"]["on断开"](_____539F_56E0)
    end
end
____exports["创建持续单位连线"] = function(_____53C2_6570)
    local _____8D77_70B9 = _____53C2_6570["起点单位"]
    local _____7EC8_70B9 = _____53C2_6570["终点单位"]
    if not isValidUnit(_____8D77_70B9) or not isValidUnit(_____7EC8_70B9) then
        return nil
    end
    local _____95EA_7535 = AddLightningEx(
        _____53C2_6570["闪电代码"] or _____9ED8_8BA4_95EA_7535_6548_679C_4EE3_7801,
        false,
        GetUnitX(_____8D77_70B9),
        GetUnitY(_____8D77_70B9),
        _____53D6_5355_4F4DZ(_____8D77_70B9, _____53C2_6570["起点高度"] or 60),
        GetUnitX(_____7EC8_70B9),
        GetUnitY(_____7EC8_70B9),
        _____53D6_5355_4F4DZ(_____7EC8_70B9, _____53C2_6570["终点高度"] or 60)
    )
    if _____95EA_7535 == nil or _____95EA_7535 == 0 then
        return nil
    end
    if _____53C2_6570["颜色"] ~= nil then
        SetLightningColor(
            _____95EA_7535,
            _____53C2_6570["颜色"].r,
            _____53C2_6570["颜色"].g,
            _____53C2_6570["颜色"].b,
            _____53C2_6570["颜色"].a
        )
    end
    local _____5B9E_4F8B = __TS__New(_____6301_7EED_5355_4F4D_8FDE_7EBF_5B9E_73B0, _____95EA_7535, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_2 = _____53C2_6570["清理"]
        ____self_2["登记清理"](
            ____self_2,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["停止"](_____5B9E_4F8B, "机制清理")
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
