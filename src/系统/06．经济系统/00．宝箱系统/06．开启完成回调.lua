local ____lualib = require("lualib_bundle")
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local callbacks = {}
local function _____5B89_5168_6267_884C_56DE_8C03(callback, unit, target, progressBar, openTime, chestConfig, ownerUnit)
    do
        pcall(function()
            callback(
                unit,
                target,
                progressBar,
                openTime,
                chestConfig,
                ownerUnit
            )
        end)
    end
end
____exports["注册宝箱开启完成回调"] = function(callback)
    if type(callback) ~= "function" then
        return
    end
    callbacks[#callbacks + 1] = callback
end
____exports["触发宝箱开启完成回调"] = function(unit, target, progressBar, openTime, chestConfig, ownerUnit)
    if #callbacks == 0 then
        return
    end
    local current = __TS__ArraySlice(callbacks)
    do
        local i = 0
        while i < #current do
            _____5B89_5168_6267_884C_56DE_8C03(
                current[i + 1],
                unit,
                target,
                progressBar,
                openTime,
                chestConfig,
                ownerUnit
            )
            i = i + 1
        end
    end
end
return ____exports
