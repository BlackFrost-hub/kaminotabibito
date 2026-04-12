--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
local track = ____01_FF0E_6838_5FC3_7EDF_8BA1.track
local untrack = ____01_FF0E_6838_5FC3_7EDF_8BA1.untrack
--- 泄露审计 - 漂浮文字
local jass = require("jass.common")
--- 创建漂浮文字 texttag（建议搭配 destroyTextTag 回收）
function ____exports.createTextTag(self, tag)
    if type(jass.CreateTextTag) ~= "function" then
        return nil
    end
    local tt = jass.CreateTextTag()
    track(nil, "texttag", tt, tag)
    return tt
end
function ____exports.destroyTextTag(self, tt)
    if not tt then
        return
    end
    untrack(nil, "texttag", tt)
    if type(jass.DestroyTextTag) == "function" then
        jass.DestroyTextTag(tt)
    end
end
return ____exports
