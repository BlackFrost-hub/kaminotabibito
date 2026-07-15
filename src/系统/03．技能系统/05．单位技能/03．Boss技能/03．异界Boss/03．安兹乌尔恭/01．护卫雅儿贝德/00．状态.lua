--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["创建雅儿贝德运行状态"] = function(unit)
    return {
        ["单位"] = unit,
        ["阶段状态"] = (unit == nil or unit == 0) and "未登场" or "正常护卫",
        ["当前生命比例"] = 1,
        ["守护连接生效"] = false,
        ["共同护盾生效"] = false,
        ["失衡结束Ms"] = 0,
        ["下一个失衡生命比例"] = 0.8,
        ["上次普通技能Ms"] = 0,
        ["上次至尊拦截Ms"] = 0,
        ["上次守护回归Ms"] = 0,
        ["上次护卫反击Ms"] = 0,
        ["上次守护职责Ms"] = 0,
        ["已初始化"] = unit ~= nil and unit ~= 0
    }
end
return ____exports
