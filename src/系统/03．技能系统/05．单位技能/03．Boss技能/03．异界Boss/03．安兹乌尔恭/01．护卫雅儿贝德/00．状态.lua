--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["创建雅儿贝德运行状态"] = function(unit)
    return {
        ["单位"] = unit,
        ["阶段状态"] = (unit == nil or unit == 0) and "未登场" or "正常护卫",
        ["当前生命比例"] = 1,
        ["守护连接生效"] = false,
        ["共同护盾生效"] = false,
        ["已初始化"] = unit ~= nil and unit ~= 0
    }
end
return ____exports
