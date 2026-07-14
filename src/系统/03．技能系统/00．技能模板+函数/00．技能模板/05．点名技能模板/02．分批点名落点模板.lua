local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____05_FF0E_70B9_540D_9884_8B66_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.05．点名预警执行器")
local _____521B_5EFA_70B9_540D_9884_8B66_6267_884C_5668 = ____05_FF0E_70B9_540D_9884_8B66_6267_884C_5668["创建点名预警执行器"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local function _____9ED8_8BA4_9009_62E9_5206_6279_76EE_6807(_____76EE_6807_5217_8868, _____5E8F_53F7)
    if #_____76EE_6807_5217_8868 <= 0 then
        return nil
    end
    return _____76EE_6807_5217_8868[(_____5E8F_53F7 - 1) % #_____76EE_6807_5217_8868 + 1]
end
local function ____on_5206_6279_70B9_540D_8F6E_6B21_5F00_59CB(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or _____53C2_6570["实例"] == nil then
        return
    end
    local ____self_1 = _____53C2_6570["实例"]
    ____self_1["开始轮次"](____self_1, _____53C2_6570["序号"])
end
local _____5206_6279_70B9_540D_843D_70B9_6A21_677F_5B9E_73B0 = __TS__Class()
_____5206_6279_70B9_540D_843D_70B9_6A21_677F_5B9E_73B0.name = "分批点名落点模板实现"
function _____5206_6279_70B9_540D_843D_70B9_6A21_677F_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["启动回调ID列表"] = {}
    self["执行器列表"] = {}
    self["已完成轮数"] = 0
    self["已结束"] = false
    self["参数"] = _____53C2_6570
    self["轮数"] = _____53C2_6570["轮数"] > 0 and _____53C2_6570["轮数"] or 0
    do
        local i = 0
        while i < self["轮数"] do
            local _____5E8F_53F7 = i + 1
            local callbackId = addDelayedCallback(i * _____53C2_6570["轮次间隔秒"] * 1000, ____on_5206_6279_70B9_540D_8F6E_6B21_5F00_59CB, {["实例"] = self, ["序号"] = _____5E8F_53F7})
            local ____self__542F_52A8_56DE_8C03ID_5217_8868_2 = self["启动回调ID列表"]
            ____self__542F_52A8_56DE_8C03ID_5217_8868_2[#____self__542F_52A8_56DE_8C03ID_5217_8868_2 + 1] = callbackId
            i = i + 1
        end
    end
    if self["轮数"] <= 0 then
        self["自然结束"](self)
    end
end
_____5206_6279_70B9_540D_843D_70B9_6A21_677F_5B9E_73B0.prototype["开始轮次"] = function(self, _____5E8F_53F7)
    if self["已结束"] then
        return
    end
    local _____76EE_6807_5217_8868 = self["参数"]["取目标列表"](_____5E8F_53F7) or ({})
    local _____9009_62E9_76EE_6807 = self["参数"]["选择目标"] or _____9ED8_8BA4_9009_62E9_5206_6279_76EE_6807
    local _____76EE_6807 = _____9009_62E9_76EE_6807(_____76EE_6807_5217_8868, _____5E8F_53F7)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        if self["参数"]["on跳过"] ~= nil then
            self["参数"]["on跳过"](_____5E8F_53F7)
        end
        self["完成一轮"](self)
        return
    end
    local _____539F_63D0_793A_5708 = self["参数"]["提示圈"]
    local _____5B9E_4F8B = self
    local ____this_53C2_6570 = self["参数"]
    local ____521B_5EFA_70B9_540D_9884_8B66_6267_884C_5668_10 = _____521B_5EFA_70B9_540D_9884_8B66_6267_884C_5668
    local ____self__53C2_6570__6E05_7406_5 = self["参数"]["清理"]
    local ____temp_6 = ((self["参数"]["名称"] .. "·第") .. tostring(_____5E8F_53F7)) .. "轮"
    local ____76EE_6807_7 = _____76EE_6807
    local ____self__53C2_6570__9884_8B66_79D2_8 = self["参数"]["预警秒"]
    local ____self__53C2_6570__9501_5B9A_5750_6807_9 = self["参数"]["锁定坐标"]
    local ____temp_4
    if _____539F_63D0_793A_5708 == nil or _____539F_63D0_793A_5708 == false then
        ____temp_4 = _____539F_63D0_793A_5708
    else
        ____temp_4 = function(_____7ED3_679C)
            local _____6269_5C55_7ED3_679C = __TS__ObjectAssign({}, _____7ED3_679C, {["序号"] = _____5E8F_53F7})
            local ____temp_3
            if type(_____539F_63D0_793A_5708) == "function" then
                ____temp_3 = _____539F_63D0_793A_5708(_____6269_5C55_7ED3_679C)
            else
                ____temp_3 = _____539F_63D0_793A_5708
            end
            return ____temp_3
        end
    end
    local _____6267_884C_5668 = ____521B_5EFA_70B9_540D_9884_8B66_6267_884C_5668_10({
        ["清理"] = ____self__53C2_6570__6E05_7406_5,
        ["名称"] = ____temp_6,
        ["目标"] = ____76EE_6807_7,
        ["延迟秒"] = ____self__53C2_6570__9884_8B66_79D2_8,
        ["锁定坐标"] = ____self__53C2_6570__9501_5B9A_5750_6807_9,
        ["提示圈"] = ____temp_4,
        ["on锁定"] = function(_____7ED3_679C)
            if ____this_53C2_6570["on锁定"] ~= nil then
                ____this_53C2_6570["on锁定"](__TS__ObjectAssign({}, _____7ED3_679C, {["序号"] = _____5E8F_53F7}))
            end
        end,
        ["on结算"] = function(_____7ED3_679C)
            if _____5B9E_4F8B["已结束"] then
                return
            end
            ____this_53C2_6570["on结算"](__TS__ObjectAssign({}, _____7ED3_679C, {["序号"] = _____5E8F_53F7}))
            _____5B9E_4F8B["完成一轮"](_____5B9E_4F8B)
        end
    })
    local ____self__6267_884C_5668_5217_8868_11 = self["执行器列表"]
    ____self__6267_884C_5668_5217_8868_11[#____self__6267_884C_5668_5217_8868_11 + 1] = _____6267_884C_5668
end
_____5206_6279_70B9_540D_843D_70B9_6A21_677F_5B9E_73B0.prototype["取消"] = function(self)
    if self["已结束"] then
        return
    end
    self["已结束"] = true
    do
        local i = 0
        while i < #self["启动回调ID列表"] do
            local callbackId = self["启动回调ID列表"][i + 1]
            if callbackId ~= nil and callbackId ~= 0 then
                removeDelayedCallback(callbackId)
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #self["执行器列表"] do
            local _____6267_884C_5668 = self["执行器列表"][i + 1]
            if _____6267_884C_5668 ~= nil then
                _____6267_884C_5668["取消"](_____6267_884C_5668)
            end
            i = i + 1
        end
    end
    if self["参数"]["on取消"] ~= nil then
        self["参数"]["on取消"]()
    end
end
_____5206_6279_70B9_540D_843D_70B9_6A21_677F_5B9E_73B0.prototype["完成一轮"] = function(self)
    if self["已结束"] then
        return
    end
    self["已完成轮数"] = self["已完成轮数"] + 1
    if self["已完成轮数"] >= self["轮数"] then
        self["自然结束"](self)
    end
end
_____5206_6279_70B9_540D_843D_70B9_6A21_677F_5B9E_73B0.prototype["自然结束"] = function(self)
    if self["已结束"] then
        return
    end
    self["已结束"] = true
    if self["参数"]["on结束"] ~= nil then
        self["参数"]["on结束"]()
    end
end
____exports["开始分批点名落点模板"] = function(_____53C2_6570)
    local _____5B9E_4F8B = __TS__New(_____5206_6279_70B9_540D_843D_70B9_6A21_677F_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_12 = _____53C2_6570["清理"]
        ____self_12["登记清理"](
            ____self_12,
            _____53C2_6570["名称"],
            function()
                _____5B9E_4F8B["取消"](_____5B9E_4F8B)
            end
        )
    end
    return _____5B9E_4F8B
end
return ____exports
