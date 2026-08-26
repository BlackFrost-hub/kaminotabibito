local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local _____914D_7F6EID_7F13_5B58 = {}
--- 读取“名称#四位内部ID”；没有名称时也兼容直接传入四位 Rawcode。
____exports["解析配置内部ID"] = function(_____914D_7F6E_503C)
    if _____914D_7F6E_503C == nil or _____914D_7F6E_503C == "" then
        return 0
    end
    local _____5DF2_7F13_5B58 = _____914D_7F6EID_7F13_5B58[_____914D_7F6E_503C]
    if _____5DF2_7F13_5B58 ~= nil then
        return _____5DF2_7F13_5B58
    end
    local _____5206_9694_4F4D_7F6E = (string.find(_____914D_7F6E_503C, "#", nil, true) or 0) - 1
    local _____539F_59CBID = _____5206_9694_4F4D_7F6E > 0 and __TS__StringTrim(__TS__StringSubstring(_____914D_7F6E_503C, _____5206_9694_4F4D_7F6E + 1)) or __TS__StringTrim(_____914D_7F6E_503C)
    if #_____539F_59CBID ~= 4 then
        _____914D_7F6EID_7F13_5B58[_____914D_7F6E_503C] = 0
        return 0
    end
    local _____7C7B_578BID = stringToFourCCSafe(_____539F_59CBID)
    _____914D_7F6EID_7F13_5B58[_____914D_7F6E_503C] = _____7C7B_578BID
    return _____7C7B_578BID
end
____exports["解析配置内部ID列表"] = function(_____914D_7F6E_5217_8868)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____7C7B_578BID = ____exports["解析配置内部ID"](_____914D_7F6E_5217_8868[i + 1])
            if _____7C7B_578BID > 0 then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____7C7B_578BID
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
return ____exports
