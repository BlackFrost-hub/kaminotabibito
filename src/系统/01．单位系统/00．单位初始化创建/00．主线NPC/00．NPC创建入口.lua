--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_7EBFNPC = require("系统.01．单位系统.00．单位初始化创建.00．主线NPC.01．主线NPC")
local initMainStoryNPCsWithDelay = ____01_FF0E_4E3B_7EBFNPC.initMainStoryNPCsWithDelay
--- 主线 NPC 创建入口
-- 对应旧 JASS InitTrig_____________NPC4_0S 的初始化行为。
function ____exports.initMainStoryNpcEntry(self)
    initMainStoryNPCsWithDelay(nil, 1)
end
function ____exports.init(self)
    ____exports.initMainStoryNpcEntry(nil)
end
____exports.default = ____exports.initMainStoryNpcEntry
return ____exports
