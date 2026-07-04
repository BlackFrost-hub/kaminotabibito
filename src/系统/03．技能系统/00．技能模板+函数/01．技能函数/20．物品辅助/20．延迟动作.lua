--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
____exports["延迟执行"] = function(_____5EF6_8FDF_6BEB_79D2, _____52A8_4F5C)
    if not (_____5EF6_8FDF_6BEB_79D2 > 0) then
        _____52A8_4F5C()
        return
    end
    addDelayedCallback(_____5EF6_8FDF_6BEB_79D2, _____52A8_4F5C)
end
____exports["延迟执行单位动作"] = function(unit, _____5EF6_8FDF_6BEB_79D2, _____52A8_4F5C)
    ____exports["延迟执行"](
        _____5EF6_8FDF_6BEB_79D2,
        function()
            if unit == nil or unit == 0 then
                return
            end
            _____52A8_4F5C(unit)
        end
    )
end
____exports["延迟执行双单位动作"] = function(source, target, _____5EF6_8FDF_6BEB_79D2, _____52A8_4F5C)
    ____exports["延迟执行"](
        _____5EF6_8FDF_6BEB_79D2,
        function()
            if source == nil or source == 0 or target == nil or target == 0 then
                return
            end
            _____52A8_4F5C(source, target)
        end
    )
end
return ____exports
