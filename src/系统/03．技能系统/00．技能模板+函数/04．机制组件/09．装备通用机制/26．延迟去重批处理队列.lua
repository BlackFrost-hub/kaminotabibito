local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
____exports["创建延迟去重批处理队列"] = function(_____540D_79F0, _____9009_9879)
    local _____961F_5217_8868 = {}
    local _____5DF2_5B89_6392_5904_7406 = false
    local _____5EF6_8FDF_6BEB_79D2 = _____9009_9879["延迟毫秒"] > 0 and _____9009_9879["延迟毫秒"] or 0
    local function _____6E05_7A7A_961F_5217_8868()
        for key in pairs(_____961F_5217_8868) do
            __TS__Delete(_____961F_5217_8868, key)
        end
    end
    local function _____6267_884C_6279_5904_7406()
        _____5DF2_5B89_6392_5904_7406 = false
        for key in pairs(_____961F_5217_8868) do
            do
                local _____4E0A_4E0B_6587 = _____961F_5217_8868[key]
                if _____4E0A_4E0B_6587 == nil then
                    goto __continue7
                end
                _____9009_9879["处理"](_____4E0A_4E0B_6587, key)
            end
            ::__continue7::
        end
        _____6E05_7A7A_961F_5217_8868()
    end
    return {
        ["名称"] = _____540D_79F0,
        ["加入"] = function(key, _____4E0A_4E0B_6587)
            local keyText = tostring(key)
            if keyText == "" then
                return
            end
            _____961F_5217_8868[keyText] = _____4E0A_4E0B_6587
            if _____5DF2_5B89_6392_5904_7406 then
                return
            end
            _____5DF2_5B89_6392_5904_7406 = true
            addDelayedCallback(_____5EF6_8FDF_6BEB_79D2, _____6267_884C_6279_5904_7406)
        end,
        ["清空"] = function()
            _____6E05_7A7A_961F_5217_8868()
            _____5DF2_5B89_6392_5904_7406 = false
        end
    }
end
return ____exports
