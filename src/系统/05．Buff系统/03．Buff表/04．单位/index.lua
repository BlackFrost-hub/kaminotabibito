local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5C01_5370_5B88_536B_6218 = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战")
local _____5C01_5370_5B88_536B_6218Buff_8868 = ____01_FF0E_5C01_5370_5B88_536B_6218["封印守卫战Buff表"]
do
    local ____export = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
____exports["单位Buff表"] = __TS__ObjectAssign({}, _____5C01_5370_5B88_536B_6218Buff_8868)
____exports.default = ____exports["单位Buff表"]
return ____exports
