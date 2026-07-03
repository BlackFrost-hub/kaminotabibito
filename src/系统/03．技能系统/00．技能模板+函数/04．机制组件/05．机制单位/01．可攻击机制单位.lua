local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____on_53EF_653B_51FB_673A_5236_5355_4F4D_6B7B_4EA1, GetHandleId, _____673A_5236_5355_4F4D_8868
function ____on_53EF_653B_51FB_673A_5236_5355_4F4D_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, _____51FB_6740_8005)
    if _____6B7B_4EA1_5355_4F4D == nil or _____6B7B_4EA1_5355_4F4D == 0 then
        return
    end
    local _____5B9E_4F8B = _____673A_5236_5355_4F4D_8868[GetHandleId(_____6B7B_4EA1_5355_4F4D)]
    if _____5B9E_4F8B ~= nil then
        _____5B9E_4F8B["处理死亡"](_____5B9E_4F8B, _____51FB_6740_8005)
    end
end
local jass = require("jass.common")
GetHandleId = jass.GetHandleId
local RemoveUnit = jass.RemoveUnit
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.index")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local unregisterDeathListener = ____require_result_1.unregisterDeathListener
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isValidUnit = ____require_result_2.isValidUnit
_____673A_5236_5355_4F4D_8868 = {}
local _____5DF2_6CE8_518C_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C = false
local function _____786E_4FDD_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C()
    if _____5DF2_6CE8_518C_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C = true
    registerDeathListener(____on_53EF_653B_51FB_673A_5236_5355_4F4D_6B7B_4EA1)
end
local function _____5C1D_8BD5_53D6_6D88_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C()
    for key in pairs(_____673A_5236_5355_4F4D_8868) do
        if _____673A_5236_5355_4F4D_8868[key] ~= nil then
            return
        end
    end
    if _____5DF2_6CE8_518C_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C then
        unregisterDeathListener(____on_53EF_653B_51FB_673A_5236_5355_4F4D_6B7B_4EA1)
        _____5DF2_6CE8_518C_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C = false
    end
end
local _____53EF_653B_51FB_673A_5236_5355_4F4D_5B9E_73B0 = __TS__Class()
_____53EF_653B_51FB_673A_5236_5355_4F4D_5B9E_73B0.name = "可攻击机制单位实现"
function _____53EF_653B_51FB_673A_5236_5355_4F4D_5B9E_73B0.prototype.____constructor(self, _____5355_4F4D, _____53C2_6570)
    self["已经销毁"] = false
    self["已经死亡"] = false
    self["单位"] = _____5355_4F4D
    self.ID = GetHandleId(_____5355_4F4D)
    self["参数"] = _____53C2_6570
    _____673A_5236_5355_4F4D_8868[self.ID] = self
    _____786E_4FDD_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C()
end
_____53EF_653B_51FB_673A_5236_5355_4F4D_5B9E_73B0.prototype["是否存活"] = function(self)
    return not self["已经销毁"] and not self["已经死亡"] and isValidUnit(self["单位"])
end
_____53EF_653B_51FB_673A_5236_5355_4F4D_5B9E_73B0.prototype["处理死亡"] = function(self, _____51FB_6740_8005)
    if self["已经死亡"] or self["已经销毁"] then
        return
    end
    self["已经死亡"] = true
    __TS__Delete(_____673A_5236_5355_4F4D_8868, self.ID)
    if self["参数"]["on死亡"] ~= nil then
        self["参数"]["on死亡"](self["单位"], _____51FB_6740_8005, self["参数"]["变量"])
    end
    _____5C1D_8BD5_53D6_6D88_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C()
end
_____53EF_653B_51FB_673A_5236_5355_4F4D_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已经销毁"] then
        return
    end
    self["已经销毁"] = true
    __TS__Delete(_____673A_5236_5355_4F4D_8868, self.ID)
    if self["参数"]["on销毁"] ~= nil then
        self["参数"]["on销毁"](self["单位"], self["参数"]["变量"])
    end
    if self["单位"] ~= nil and self["单位"] ~= 0 then
        RemoveUnit(self["单位"])
    end
    _____5C1D_8BD5_53D6_6D88_673A_5236_5355_4F4D_6B7B_4EA1_76D1_542C()
end
____exports["创建可攻击机制单位"] = function(_____53C2_6570)
    local ____521B_5EFA_53EC_5524_7269_13 = _____521B_5EFA_53EC_5524_7269
    local ____53C2_6570__4E3B_4EBA_5355_4F4D_4 = _____53C2_6570["主人单位"]
    local ____53C2_6570__6240_5C5E_73A9_5BB6_5 = _____53C2_6570["所属玩家"]
    local ____53C2_6570__5355_4F4D_7C7B_578B_6 = _____53C2_6570["单位类型"]
    local ____53C2_6570__540D_79F0_7 = _____53C2_6570["名称"]
    local ____53C2_6570__6A21_578B_8DEF_5F84_8 = _____53C2_6570["模型路径"]
    local ____53C2_6570_X_9 = _____53C2_6570.X
    local ____53C2_6570_Y_10 = _____53C2_6570.Y
    local ____53C2_6570__671D_5411_11 = _____53C2_6570["朝向"]
    local ____53C2_6570__6700_5927_751F_547D_12 = _____53C2_6570["最大生命"]
    local ____temp_3
    if _____53C2_6570["生命值受小怪倍率"] == false then
        ____temp_3 = false
    else
        ____temp_3 = true
    end
    local unit = ____521B_5EFA_53EC_5524_7269_13({
        ["主人单位"] = ____53C2_6570__4E3B_4EBA_5355_4F4D_4,
        ["所属玩家"] = ____53C2_6570__6240_5C5E_73A9_5BB6_5,
        ["单位类型"] = ____53C2_6570__5355_4F4D_7C7B_578B_6,
        ["单位名称"] = ____53C2_6570__540D_79F0_7,
        ["模型路径"] = ____53C2_6570__6A21_578B_8DEF_5F84_8,
        X = ____53C2_6570_X_9,
        Y = ____53C2_6570_Y_10,
        ["朝向"] = ____53C2_6570__671D_5411_11,
        ["生命值"] = ____53C2_6570__6700_5927_751F_547D_12,
        ["生命值受小怪倍率"] = ____temp_3,
        ["飞行高度"] = _____53C2_6570["飞行高度"],
        ["缩放"] = _____53C2_6570["缩放"],
        ["持续时间"] = _____53C2_6570["持续时间"]
    })
    if unit == nil or unit == 0 then
        return nil
    end
    local _____5B9E_4F8B = __TS__New(_____53EF_653B_51FB_673A_5236_5355_4F4D_5B9E_73B0, unit, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_14 = _____53C2_6570["清理"]
        ____self_14["登记清理"](
            ____self_14,
            _____53C2_6570["名称"] or "可攻击机制单位",
            function()
                _____5B9E_4F8B["销毁"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
