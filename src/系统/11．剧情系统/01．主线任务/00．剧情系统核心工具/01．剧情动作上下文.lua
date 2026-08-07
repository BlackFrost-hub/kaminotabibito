local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local _____5267_60C5_5165_53E3_8868_540D = "主线剧情入口"
local _____5267_60C5_8FDB_5EA6_8868_540D = "剧情进度"
local _____5267_60C5_8FDB_5EA6_952E = "整数"
local _____5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C_5668_8868 = {}
____exports["读取当前剧情动作上下文"] = function()
    return {
        ["片段ID"] = YDUserDataGetSafe("string", _____5267_60C5_5165_53E3_8868_540D, "剧情片段ID", "string"),
        ["触发配置名"] = YDUserDataGetSafe("string", _____5267_60C5_5165_53E3_8868_540D, "触发配置", "string"),
        ["触发单位"] = YDUserDataGetSafe("string", _____5267_60C5_5165_53E3_8868_540D, "触发单位", "unit")
    }
end
____exports["写入当前剧情动作上下文"] = function(_____4E0A_4E0B_6587)
    if _____4E0A_4E0B_6587["片段ID"] ~= nil then
        YDUserDataSetSafe(
            "string",
            _____5267_60C5_5165_53E3_8868_540D,
            "剧情片段ID",
            "string",
            _____4E0A_4E0B_6587["片段ID"]
        )
    end
    if _____4E0A_4E0B_6587["触发配置名"] ~= nil then
        YDUserDataSetSafe(
            "string",
            _____5267_60C5_5165_53E3_8868_540D,
            "触发配置",
            "string",
            _____4E0A_4E0B_6587["触发配置名"]
        )
    end
    if _____4E0A_4E0B_6587["触发单位"] ~= nil then
        YDUserDataSetSafe(
            "string",
            _____5267_60C5_5165_53E3_8868_540D,
            "触发单位",
            "unit",
            _____4E0A_4E0B_6587["触发单位"]
        )
    end
end
____exports["读取剧情进度"] = function()
    return __TS__Number(YDUserDataGetSafe("string", _____5267_60C5_8FDB_5EA6_8868_540D, _____5267_60C5_8FDB_5EA6_952E, "integer")) or 0
end
____exports["写入剧情进度"] = function(_____8FDB_5EA6)
    local _____65E7_8FDB_5EA6 = ____exports["读取剧情进度"]()
    YDUserDataSetSafe(
        "string",
        _____5267_60C5_8FDB_5EA6_8868_540D,
        _____5267_60C5_8FDB_5EA6_952E,
        "integer",
        _____8FDB_5EA6
    )
    if _____8FDB_5EA6 == _____65E7_8FDB_5EA6 then
        return
    end
    local _____76D1_542C_5668_6570_91CF = #_____5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C_5668_8868
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < _____76D1_542C_5668_6570_91CF do
            local _____76D1_542C_5668 = _____5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C_5668_8868[_____7D22_5F15 + 1]
            if _____76D1_542C_5668 ~= nil then
                _____76D1_542C_5668(_____8FDB_5EA6, _____65E7_8FDB_5EA6)
            end
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
____exports["注册剧情进度变更监听"] = function(_____76D1_542C_5668)
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C_5668_8868 do
            if _____5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C_5668_8868[_____7D22_5F15 + 1] == _____76D1_542C_5668 then
                return
            end
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
    _____5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C_5668_8868[#_____5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C_5668_8868 + 1] = _____76D1_542C_5668
end
return ____exports
