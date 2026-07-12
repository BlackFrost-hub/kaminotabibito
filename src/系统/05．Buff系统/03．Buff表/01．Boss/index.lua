local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____index = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.index")
local _____4E3B_7EBFBossBuff_8868 = ____index["主线BossBuff表"]
local ____index = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.index")
local _____6311_6218_4E0E_9690_85CFBossBuff_8868 = ____index["挑战与隐藏BossBuff表"]
local ____index = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.index")
local _____5F02_754CBossBuff_8868 = ____index["异界BossBuff表"]
do
    local ____export = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
____exports["BossBuff表"] = __TS__ObjectAssign({}, _____4E3B_7EBFBossBuff_8868, _____6311_6218_4E0E_9690_85CFBossBuff_8868, _____5F02_754CBossBuff_8868)
____exports.default = ____exports["BossBuff表"]
return ____exports
