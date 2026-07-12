--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 导入本模块不会创建单位、事件、计时器或挑战媒介。
____exports["创建夏提雅运行时上下文"] = function()
    return {
        ["阶段"] = "未启动",
        ["当前猎血段数"] = 0,
        ["猎血段数过期时间Ms"] = 0,
        ["血印句柄列表"] = {},
        ["血宴层数"] = 0,
        ["已触发复生"] = false,
        ["已初始化"] = false
    }
end
return ____exports
