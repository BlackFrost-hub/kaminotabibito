--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local callbacks = {}
____exports["注册宝箱准备开启回调"] = function(callback)
    callbacks[#callbacks + 1] = callback
end
____exports["触发宝箱准备开启回调"] = function(unit, target, progressBar, openTime, chestConfig, ownerUnit)
    for ____, callback in ipairs(callbacks) do
        callback(
            unit,
            target,
            progressBar,
            openTime,
            chestConfig,
            ownerUnit
        )
    end
end
return ____exports
