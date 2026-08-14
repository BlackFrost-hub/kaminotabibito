local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_63D0_7C73_8BFA_65AF = require("系统.05．Buff系统.03．Buff表.02．英雄.01．提米诺斯")
local _____63D0_7C73_8BFA_65AFBuff_8868 = ____01_FF0E_63D0_7C73_8BFA_65AF["提米诺斯Buff表"]
local ____02_FF0E_6B27_83F2_8389_4E9A = require("系统.05．Buff系统.03．Buff表.02．英雄.02．欧菲莉亚")
local _____6B27_83F2_8389_4E9ABuff_8868 = ____02_FF0E_6B27_83F2_8389_4E9A["欧菲莉亚Buff表"]
____exports["英雄Buff表"] = __TS__ObjectAssign({}, _____63D0_7C73_8BFA_65AFBuff_8868, _____6B27_83F2_8389_4E9ABuff_8868)
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.01．提米诺斯")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.02．欧菲莉亚")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
____exports.default = ____exports["英雄Buff表"]
return ____exports
