--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Buff系统 - 初始化入口
-- 
-- 不在这里做 export * 聚合，避免加载期把 BuffUI / Buff表 / 控制抗性
-- 卷入同一条导出链，触发运行时 critical dependency。
local buffPoolCore = require("系统.05．Buff系统.00．Buff系统")
local buffUIMod = require("系统.05．Buff系统.02．BuffUI")
local controlResistMod = require("系统.05．Buff系统.01．控制抗性.index")
local sleepMod = require("系统.05．Buff系统.07．睡眠系统")
local ____Buff_7CFB_7EDF_5DF2_521D_59CB_5316 = false
function ____exports.init()
    if ____Buff_7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    ____Buff_7CFB_7EDF_5DF2_521D_59CB_5316 = true
    buffPoolCore.initBuffSystem()
    require("系统.05．Buff系统.01．Buff表")
    buffUIMod.init()
    require("系统.05．Buff系统.03．BuffJASS桥接")
    require("系统.05．Buff系统.05．Buff清除函数")
    controlResistMod.initControlResist()
    sleepMod["初始化睡眠系统"]()
end
return ____exports
