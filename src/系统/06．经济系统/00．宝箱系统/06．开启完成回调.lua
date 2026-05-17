local ____lualib = require("lualib_bundle")
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____8C03_8BD5_6A21_5757 = "宝箱完成回调"
local callbacks = {}
local function _____5B89_5168_6267_884C_56DE_8C03(callback, unit, target, progressBar, openTime, chestConfig, ownerUnit)
    do
        local function ____catch(err)
            debugLogForce(_____8C03_8BD5_6A21_5757, "回调执行失败", "err=", err)
        end
        local ____try, ____hasReturned = pcall(function()
            callback(
                unit,
                target,
                progressBar,
                openTime,
                chestConfig,
                ownerUnit
            )
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
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
