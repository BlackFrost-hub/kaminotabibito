--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
local track = ____01_FF0E_6838_5FC3_7EDF_8BA1.track
local untrack = ____01_FF0E_6838_5FC3_7EDF_8BA1.untrack
--- 泄露审计 - 单位组
local jass = require("jass.common")
function ____exports.createGroup(self, tag)
    local g = jass:CreateGroup()
    track(nil, "group", g, tag)
    return g
end
function ____exports.destroyGroup(self, gp)
    if not gp then
        return
    end
    untrack(nil, "group", gp)
    jass:DestroyGroup(gp)
end
return ____exports
