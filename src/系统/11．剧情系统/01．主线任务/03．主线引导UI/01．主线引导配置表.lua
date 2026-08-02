--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____09_FF0E_4E3B_7EBF_8282_70B9_914D_7F6E = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.09．主线节点配置")
local _____83B7_53D6_4E3B_7EBF_8282_70B9_914D_7F6E = ____09_FF0E_4E3B_7EBF_8282_70B9_914D_7F6E["获取主线节点配置"]
local ____require_result_0 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____require_result_0["读取剧情进度"]
local STRING_293 = "|cffffff00『主线引导』|r：穿过|cffff9900山谷|r前往|cffffcc99西里尔村落|r"
--- 进度 -> 配置映射表
local _____8FDB_5EA6_914D_7F6E_8868 = {}
_____8FDB_5EA6_914D_7F6E_8868[0] = {["提示文本"] = STRING_293, ["镜头X"] = -29104.8, ["镜头Y"] = -27527.1}
local function _____52A0_8F7D_4E3B_7EBF_8282_70B9_5F15_5BFC_914D_7F6E(_____8D77_59CB_8FDB_5EA6, _____7ED3_675F_8FDB_5EA6)
    do
        local _____8FDB_5EA6 = _____8D77_59CB_8FDB_5EA6
        while _____8FDB_5EA6 <= _____7ED3_675F_8FDB_5EA6 do
            do
                local _____8282_70B9 = _____83B7_53D6_4E3B_7EBF_8282_70B9_914D_7F6E(_____8FDB_5EA6)
                if _____8282_70B9 == nil then
                    goto __continue4
                end
                local _____914D_7F6E = {["提示文本"] = _____8282_70B9["提示文本"]}
                if _____8282_70B9["引导"] ~= nil then
                    _____914D_7F6E["镜头X"] = _____8282_70B9["引导"]["镜头X"]
                    _____914D_7F6E["镜头Y"] = _____8282_70B9["引导"]["镜头Y"]
                    _____914D_7F6E["镜头跟随单位"] = _____8282_70B9["引导"]["镜头跟随单位"]
                end
                _____8FDB_5EA6_914D_7F6E_8868[_____8FDB_5EA6] = _____914D_7F6E
            end
            ::__continue4::
            _____8FDB_5EA6 = _____8FDB_5EA6 + 1
        end
    end
end
____exports["刷新主线节点引导配置"] = function(_____8FDB_5EA6)
    local _____8282_70B9 = _____83B7_53D6_4E3B_7EBF_8282_70B9_914D_7F6E(_____8FDB_5EA6)
    if _____8282_70B9 == nil then
        _____8FDB_5EA6_914D_7F6E_8868[_____8FDB_5EA6] = nil
        return
    end
    local _____914D_7F6E = {["提示文本"] = _____8282_70B9["提示文本"]}
    if _____8282_70B9["引导"] ~= nil then
        _____914D_7F6E["镜头X"] = _____8282_70B9["引导"]["镜头X"]
        _____914D_7F6E["镜头Y"] = _____8282_70B9["引导"]["镜头Y"]
        _____914D_7F6E["镜头跟随单位"] = _____8282_70B9["引导"]["镜头跟随单位"]
    end
    _____8FDB_5EA6_914D_7F6E_8868[_____8FDB_5EA6] = _____914D_7F6E
end
_____52A0_8F7D_4E3B_7EBF_8282_70B9_5F15_5BFC_914D_7F6E(1, 49)
--- 根据剧情进度获取配置
-- 进度 < 1 时使用 0；否则直接使用进度值
____exports["获取进度配置"] = function()
    local _____8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    local key = _____8FDB_5EA6 < 1 and 0 or _____8FDB_5EA6
    return _____8FDB_5EA6_914D_7F6E_8868[key]
end
return ____exports
