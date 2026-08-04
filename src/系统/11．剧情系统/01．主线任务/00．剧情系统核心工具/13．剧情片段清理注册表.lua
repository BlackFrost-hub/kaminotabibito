--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5267_60C5_7247_6BB5_6E05_7406_8868 = {}
--- 注册片段级清理回调。播放器在正常结束和 ESC 跳过时都会调用，回调必须幂等。
____exports["注册剧情片段清理"] = function(_____7247_6BB5ID, _____6E05_7406_51FD_6570)
    if _____7247_6BB5ID == "" or _____6E05_7406_51FD_6570 == nil then
        return
    end
    _____5267_60C5_7247_6BB5_6E05_7406_8868[_____7247_6BB5ID] = _____6E05_7406_51FD_6570
end
____exports["执行剧情片段清理"] = function(_____7247_6BB5ID)
    if _____7247_6BB5ID == "" then
        return
    end
    local _____6E05_7406_51FD_6570 = _____5267_60C5_7247_6BB5_6E05_7406_8868[_____7247_6BB5ID]
    if _____6E05_7406_51FD_6570 == nil then
        return
    end
    _____6E05_7406_51FD_6570()
end
return ____exports
