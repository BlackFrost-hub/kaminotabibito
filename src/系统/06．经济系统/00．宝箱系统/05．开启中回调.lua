--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local callbacks = {}
____exports["注册宝箱开启中回调"] = function(callback)
    callbacks[#callbacks + 1] = callback
end
____exports["触发宝箱开启中回调"] = function(unit, target, progressBar, openTime, elapsed, chestConfig, ownerUnit)
    for ____, callback in ipairs(callbacks) do
        callback(
            unit,
            target,
            progressBar,
            openTime,
            elapsed,
            chestConfig,
            ownerUnit
        )
    end
end
return ____exports
