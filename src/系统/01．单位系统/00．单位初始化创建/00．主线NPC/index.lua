--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.00．主线NPC.01．主线NPC")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local ____require_result_0 = require("系统.01．单位系统.00．单位初始化创建.00．主线NPC.01．主线NPC")
local initMainStoryNPCsWithDelay = ____require_result_0.initMainStoryNPCsWithDelay
--- 初始化主线NPC
function ____exports.init(self)
    if type(initMainStoryNPCsWithDelay) == "function" then
        initMainStoryNPCsWithDelay(nil, 1)
    end
end
function ____exports.initMainStoryNpcEntry(self)
    ____exports.init(nil)
end
return ____exports
