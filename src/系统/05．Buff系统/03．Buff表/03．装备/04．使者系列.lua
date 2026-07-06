--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
____exports["使者系列装备Buff表"] = {[_____5E38_89C4BuffID["使者魔炉_致盲"]] = {
    buffID = _____5E38_89C4BuffID["使者魔炉_致盲"],
    buffName = "致盲",
    icon = "ReplaceableTextures\\CommandButtons\\BTN000230.blp",
    effect = "",
    type = "Debuff:equipment:attribute",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 1,
    priority = 5,
    canPurge = true,
    tooltip = "受到了「使者魔炉」的致盲影响，在time秒内命中率降低data%。"
}}
____exports.default = ____exports["使者系列装备Buff表"]
return ____exports
