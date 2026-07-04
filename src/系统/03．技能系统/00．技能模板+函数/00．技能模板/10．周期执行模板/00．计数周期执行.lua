--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
____exports["启动计数周期执行"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["间隔毫秒"] <= 0 or _____53C2_6570["最大次数"] <= 0 or _____53C2_6570["on周期"] == nil then
        return nil
    end
    local _____5F53_524D_6B21_6570 = 0
    local timerID = 0
    local _____5DF2_7ED3_675F = false
    local _____63A7_5236_5668 = {
        ["最大次数"] = _____53C2_6570["最大次数"],
        ["取消"] = function()
            if _____5DF2_7ED3_675F then
                return
            end
            _____5DF2_7ED3_675F = true
            if timerID > 0 then
                removePeriodicCallback(timerID)
                timerID = 0
            end
            local ____opt_1 = _____53C2_6570["on取消"]
            if ____opt_1 ~= nil then
                ____opt_1()
            end
        end
    }
    local function _____7ED3_675F()
        if _____5DF2_7ED3_675F then
            return
        end
        _____5DF2_7ED3_675F = true
        if timerID > 0 then
            removePeriodicCallback(timerID)
            timerID = 0
        end
        local ____opt_3 = _____53C2_6570["on完成"]
        if ____opt_3 ~= nil then
            ____opt_3()
        end
    end
    local function ____on_8BA1_6570_5468_671F_6267_884CTick()
        if _____5DF2_7ED3_675F then
            return
        end
        _____5F53_524D_6B21_6570 = _____5F53_524D_6B21_6570 + 1
        local result = _____53C2_6570["on周期"]({["当前次数"] = _____5F53_524D_6B21_6570, ["最大次数"] = _____53C2_6570["最大次数"], ["控制器"] = _____63A7_5236_5668})
        if result == false then
            _____63A7_5236_5668["取消"]()
            return
        end
        if _____5F53_524D_6B21_6570 >= _____53C2_6570["最大次数"] then
            _____7ED3_675F()
        end
    end
    timerID = addPeriodicCallback(_____53C2_6570["间隔毫秒"], ____on_8BA1_6570_5468_671F_6267_884CTick)
    return _____63A7_5236_5668
end
return ____exports
