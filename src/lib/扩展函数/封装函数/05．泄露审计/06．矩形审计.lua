--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
local track = ____01_FF0E_6838_5FC3_7EDF_8BA1.track
local untrack = ____01_FF0E_6838_5FC3_7EDF_8BA1.untrack
--- 泄露审计 - 矩形
local jass = require("jass.common")
function ____exports.trackRect(self, tag, rect)
    track(nil, "rect", rect, tag)
end
function ____exports.removeRect(self, rect)
    if not rect then
        return
    end
    untrack(nil, "rect", rect)
    jass:RemoveRect(rect)
end
return ____exports
