--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
local track = ____01_FF0E_6838_5FC3_7EDF_8BA1.track
local untrack = ____01_FF0E_6838_5FC3_7EDF_8BA1.untrack
--- 泄露审计 - 触发器
local jass = require("jass.common")
function ____exports.createTrigger(self, tag)
    local trg = jass.CreateTrigger()
    track(nil, "trigger", trg, tag)
    return trg
end
function ____exports.destroyTrigger(self, trg)
    if not trg then
        return
    end
    untrack(nil, "trigger", trg)
    if type(jass.DestroyTrigger) == "function" then
        jass.DestroyTrigger(trg)
    end
end
return ____exports
