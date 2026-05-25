local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5267_60C5_7247_6BB5_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．剧情片段配置表")
local _____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868 = ____01_FF0E_5267_60C5_7247_6BB5_914D_7F6E_8868.default
local _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6 = {["当前步骤索引"] = 0, ["当前倍速"] = 1, ["是否正在播放"] = false, ["是否请求跳过"] = false}
____exports["创建剧情播放器运行时"] = function()
    return __TS__ObjectAssign({}, _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6)
end
____exports["查找主线剧情片段"] = function(_____7247_6BB5ID)
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868 do
            local _____7247_6BB5 = _____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868[i + 1]
            if _____7247_6BB5["片段ID"] == _____7247_6BB5ID then
                return _____7247_6BB5
            end
            i = i + 1
        end
    end
    return nil
end
____exports["初始化剧情步骤播放器"] = function()
    local ____ = _____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868
end
return ____exports
