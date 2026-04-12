--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
local track = ____01_FF0E_6838_5FC3_7EDF_8BA1.track
local untrack = ____01_FF0E_6838_5FC3_7EDF_8BA1.untrack
--- 泄露审计 - 特效
local jass = require("jass.common")
--- 创建特效：你可以先用原生创建好 effect，再传进来 trackEffect(tag, effect)
function ____exports.trackEffect(self, tag, eff)
    track(nil, "effect", eff, tag)
end
function ____exports.destroyEffect(self, eff)
    if not eff then
        return
    end
    untrack(nil, "effect", eff)
    if type(jass.DestroyEffect) == "function" then
        jass.DestroyEffect(eff)
    end
end
return ____exports
