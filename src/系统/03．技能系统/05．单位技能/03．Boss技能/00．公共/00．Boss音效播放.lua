--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_CooPlay = ____require_result_0.Sound3DII_CooPlay
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
____exports["播放Boss坐标音效"] = function(path, x, y, cutoff)
    if path == "" then
        return
    end
    Sound3DII_CooPlay(
        path,
        x,
        y,
        0,
        cutoff
    )
end
____exports["延迟播放Boss坐标音效"] = function(path, x, y, delayMs, cutoff)
    if path == "" then
        return
    end
    addDelayedCallback(
        delayMs,
        function()
            ____exports["播放Boss坐标音效"](path, x, y, cutoff)
        end
    )
end
return ____exports
