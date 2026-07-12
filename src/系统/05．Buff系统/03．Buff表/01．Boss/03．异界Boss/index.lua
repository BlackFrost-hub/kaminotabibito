local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5B89_5179_4E4C_5C14_606D = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.01．安兹乌尔恭")
local _____5B89_5179_4E4C_5C14_606DBuff_8868 = ____01_FF0E_5B89_5179_4E4C_5C14_606D["安兹乌尔恭Buff表"]
local ____02_FF0E_590F_63D0_96C5 = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.02．夏提雅")
local _____590F_63D0_96C5Buff_8868 = ____02_FF0E_590F_63D0_96C5["夏提雅Buff表"]
do
    local ____export = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.01．安兹乌尔恭")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.02．夏提雅")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
____exports["异界BossBuff表"] = __TS__ObjectAssign({}, _____5B89_5179_4E4C_5C14_606DBuff_8868, _____590F_63D0_96C5Buff_8868)
return ____exports
