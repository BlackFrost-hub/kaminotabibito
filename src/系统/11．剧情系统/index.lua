--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_516C_5171 = require("系统.11．剧情系统.00．公共.index")
local ____init_516C_5171 = ____00_FF0E_516C_5171.init
local ____01_FF0E_4E3B_7EBF_4EFB_52A1 = require("系统.11．剧情系统.01．主线任务.index")
local ____init_4E3B_7EBF_4EFB_52A1 = ____01_FF0E_4E3B_7EBF_4EFB_52A1.init
do
    local ____export = require("系统.11．剧情系统.00．公共.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.11．剧情系统.01．主线任务.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.11．剧情系统.02．支线任务.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
function ____exports.init()
    ____init_516C_5171()
    ____init_4E3B_7EBF_4EFB_52A1()
end
return ____exports
