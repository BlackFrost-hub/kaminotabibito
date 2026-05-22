--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_7EBF_914D_7F6E_9A71_52A8 = require("系统.11．剧情系统.01．主线任务.01．主线配置驱动")
local ____init_4E3B_7EBF_5267_60C5_914D_7F6E_9A71_52A8 = ____01_FF0E_4E3B_7EBF_914D_7F6E_9A71_52A8["init主线剧情配置驱动"]
do
    local ____export = require("系统.11．剧情系统.01．主线任务.00．主线任务配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.11．剧情系统.01．主线任务.01．主线配置驱动")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
function ____exports.init()
    ____init_4E3B_7EBF_5267_60C5_914D_7F6E_9A71_52A8()
end
return ____exports
