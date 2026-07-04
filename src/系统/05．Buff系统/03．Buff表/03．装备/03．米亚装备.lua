--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
____exports["米亚装备Buff表"] = {[_____5E38_89C4BuffID["灵猫步伐之靴_灵猫跃步"]] = {
    buffID = _____5E38_89C4BuffID["灵猫步伐之靴_灵猫跃步"],
    buffName = "灵猫跃步",
    icon = "Equipment\\Icon\\Shoes\\spirit_cat_steps_boots.blp",
    effect = "",
    type = "Buff:equipment:attribute",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 0,
    priority = 5,
    canPurge = false,
    tooltip = "受到了「灵猫跃步」，在time秒内移动速度提高data%。"
}}
____exports.default = ____exports["米亚装备Buff表"]
return ____exports
