--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
____exports["灼热食用Buff表"] = {[_____5E38_89C4BuffID["灼热食用"]] = {
    buffID = _____5E38_89C4BuffID["灼热食用"],
    buffName = "灼热",
    icon = "BuffIcon\\Equipment\\scorching-buff-64.blp",
    effect = "",
    type = "Buff:equipment:attribute",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 0,
    priority = 5,
    canPurge = false,
    tooltip = "品尝了烤熔岩灵鱼，在time秒内火属性伤害提高data%。"
}}
____exports.default = ____exports["灼热食用Buff表"]
return ____exports
