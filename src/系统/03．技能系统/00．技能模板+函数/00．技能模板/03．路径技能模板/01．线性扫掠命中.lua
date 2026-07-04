local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_1["获取坐标范围敌人"]
local _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9 = ____require_result_1["单位是否有效且敌对"]
local GetHandleId = jass.GetHandleId
local Cos = jass.Cos
local Sin = jass.Sin
local _____4E0B_4E00_4E2A_7EBF_6027_626B_63A0_547D_4E2D_5B9E_4F8BID = 0
local _____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0 = __TS__Class()
_____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.name = "线性扫掠命中实现"
function _____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.prototype.____constructor(self, _____5B9E_4F8BID, _____53C2_6570)
    self["当前次数"] = 0
    self.timerID = 0
    self["已销毁"] = false
    self["已命中"] = {}
    self["实例ID"] = _____5B9E_4F8BID
    self["参数"] = _____53C2_6570
    self["当前X"] = _____53C2_6570["起点X"]
    self["当前Y"] = _____53C2_6570["起点Y"]
end
_____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.prototype["启动"] = function(self)
    if self["已销毁"] then
        return
    end
    if self["参数"]["施法单位"] == nil or self["参数"]["施法单位"] == 0 then
        return
    end
    if self["参数"]["最大次数"] <= 0 or self["参数"]["周期秒"] <= 0 then
        return
    end
    self.timerID = addPeriodicCallback(
        self["参数"]["周期秒"] * 1000,
        function() return self:tick() end
    )
end
_____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    if self.timerID ~= 0 then
        removePeriodicCallback(self.timerID)
        self.timerID = 0
    end
    local ____opt_2 = self["参数"]["on结束"]
    if ____opt_2 ~= nil then
        ____opt_2(self["实例ID"])
    end
end
function _____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.prototype.tick(self)
    if self["已销毁"] then
        return
    end
    self["当前次数"] = self["当前次数"] + 1
    self["当前X"] = self["当前X"] + Cos(self["参数"]["方向弧度"]) * self["参数"]["每次距离"]
    self["当前Y"] = self["当前Y"] + Sin(self["参数"]["方向弧度"]) * self["参数"]["每次距离"]
    local _____56DE_8C03_4E0A_4E0B_6587 = {
        ["实例ID"] = self["实例ID"],
        ["施法单位"] = self["参数"]["施法单位"],
        ["当前X"] = self["当前X"],
        ["当前Y"] = self["当前Y"],
        ["方向弧度"] = self["参数"]["方向弧度"],
        ["当前次数"] = self["当前次数"]
    }
    local ____opt_4 = self["参数"]["on步进"]
    if ____opt_4 ~= nil then
        ____opt_4(_____56DE_8C03_4E0A_4E0B_6587)
    end
    self["处理命中"](self, _____56DE_8C03_4E0A_4E0B_6587)
    if self["当前次数"] >= self["参数"]["最大次数"] then
        self["销毁"](self)
    end
end
_____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.prototype["处理命中"] = function(self, _____4E0A_4E0B_6587)
    if self["参数"]["作用范围"] <= 0 then
        return
    end
    local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(self["参数"]["施法单位"], _____4E0A_4E0B_6587["当前X"], _____4E0A_4E0B_6587["当前Y"], self["参数"]["作用范围"])
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____76EE_6807 = _____654C_4EBA_5217_8868[i + 1]
                if not self["是否可命中"](self, _____76EE_6807, _____4E0A_4E0B_6587) then
                    goto __continue17
                end
                local ____self__53C2_6570__540C_76EE_6807_53EA_547D_4E2D_4E00_6B21_6 = self["参数"]["同目标只命中一次"]
                if ____self__53C2_6570__540C_76EE_6807_53EA_547D_4E2D_4E00_6B21_6 == nil then
                    ____self__53C2_6570__540C_76EE_6807_53EA_547D_4E2D_4E00_6B21_6 = true
                end
                if ____self__53C2_6570__540C_76EE_6807_53EA_547D_4E2D_4E00_6B21_6 and self["是否已经命中"](self, _____76EE_6807) then
                    goto __continue17
                end
                self["标记已命中"](self, _____76EE_6807)
                local ____opt_7 = self["参数"]["on命中"]
                if ____opt_7 ~= nil then
                    ____opt_7(_____76EE_6807, _____4E0A_4E0B_6587)
                end
            end
            ::__continue17::
            i = i + 1
        end
    end
end
_____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.prototype["是否可命中"] = function(self, _____76EE_6807, _____4E0A_4E0B_6587)
    if not _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9(_____76EE_6807, self["参数"]["施法单位"]) then
        return false
    end
    if self["参数"]["目标筛选"] == nil then
        return true
    end
    return self["参数"]["目标筛选"](_____76EE_6807, _____4E0A_4E0B_6587)
end
_____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.prototype["是否已经命中"] = function(self, _____76EE_6807)
    local _____76EE_6807ID = GetHandleId(_____76EE_6807)
    return self["已命中"][_____76EE_6807ID] == true
end
_____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0.prototype["标记已命中"] = function(self, _____76EE_6807)
    local _____76EE_6807ID = GetHandleId(_____76EE_6807)
    self["已命中"][_____76EE_6807ID] = true
end
____exports["创建线性扫掠命中"] = function(_____53C2_6570)
    local ____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0_9 = _____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0
    _____4E0B_4E00_4E2A_7EBF_6027_626B_63A0_547D_4E2D_5B9E_4F8BID = _____4E0B_4E00_4E2A_7EBF_6027_626B_63A0_547D_4E2D_5B9E_4F8BID + 1
    local _____5B9E_4F8B = __TS__New(____7EBF_6027_626B_63A0_547D_4E2D_5B9E_73B0_9, _____4E0B_4E00_4E2A_7EBF_6027_626B_63A0_547D_4E2D_5B9E_4F8BID, _____53C2_6570)
    _____5B9E_4F8B["启动"](_____5B9E_4F8B)
    return _____5B9E_4F8B
end
return ____exports
