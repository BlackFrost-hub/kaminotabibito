--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 开关：设为 true 启用测试，false 禁用
local ENABLED = false
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocalInitialize = ____require_result_0.YDLocalInitialize
local YDLocal1Release = ____require_result_0.YDLocal1Release
local YDLocal5Set = ____require_result_0.YDLocal5Set
local YDLocal5Get = ____require_result_0.YDLocal5Get
local YDLocal7Set = ____require_result_0.YDLocal7Set
local YDLocal7Get = ____require_result_0.YDLocal7Get
local YDLocal1Set = ____require_result_0.YDLocal1Set
local YDLocal1Get = ____require_result_0.YDLocal1Get
local getG_SIndex = ____require_result_0.getG_SIndex
local setG_SIndex = ____require_result_0.setG_SIndex
local getG_LIndex = ____require_result_0.getG_LIndex
local setG_LIndex = ____require_result_0.setG_LIndex
local _indexStack = ____require_result_0._indexStack
local ____require_result_1 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
local YDLocalExecuteTrigger = ____require_result_1.YDLocalExecuteTrigger
local YDTriggerExecuteTrigger = ____require_result_1.YDTriggerExecuteTrigger
local saveParentIndex = ____require_result_1.saveParentIndex
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_2.debugLogForce
local function resolveGgTrgByKey(self, key)
    local a = jglobals[key]
    if a ~= nil and a ~= 0 then
        return a
    end
    local b = jass[key]
    if b ~= nil and b ~= 0 then
        return b
    end
    local c = _G[key]
    if c ~= nil and c ~= 0 then
        return c
    end
    return nil
end
local function testYDLocalReturn(self)
    debugLogForce(nil, "YDLocal测试", "===== 测试中文变量名 =====")
    local trg002 = resolveGgTrgByKey(nil, "gg_trg____________________002")
    debugLogForce(nil, "YDLocal测试", "查找触发器 gg_trg____________________002 =", trg002 or "nil")
    if trg002 then
        YDLocalInitialize(nil)
        local sIdx = getG_SIndex(nil)
        debugLogForce(
            nil,
            "YDLocal测试",
            "YDLocalInitialize 后 G_SIndex=" .. tostring(sIdx)
        )
        YDLocalExecuteTrigger(nil, trg002)
        saveParentIndex(nil, trg002)
        debugLogForce(nil, "YDLocal测试", "saveParentIndex 完成")
        YDLocal5Set(nil, "integer", "分法", 0)
        debugLogForce(nil, "YDLocal测试", "YDLocal5Set(integer, '分法', 0) 设置参数默认值")
        debugLogForce(nil, "YDLocal测试", "执行 YDTriggerExecuteTrigger...")
        YDTriggerExecuteTrigger(nil, trg002, false)
        local ret1 = YDLocal1Get(nil, "integer", "分法")
        local ret2 = YDLocal1Get(nil, "real", "多大的")
        local ret3 = YDLocal1Get(nil, "boolean", "你好")
        debugLogForce(nil, "YDLocal测试", "YDLocal1Get(integer, '分法') =", ret1)
        debugLogForce(nil, "YDLocal测试", "YDLocal1Get(real, '多大的') =", ret2)
        debugLogForce(nil, "YDLocal测试", "YDLocal1Get(boolean, '你好') =", ret3)
        local success = true
        if ret1 ~= 6678678 then
            debugLogForce(nil, "YDLocal测试", "❌ integer '分法' 失败，期望 6678678，实际", ret1)
            success = false
        end
        if ret2 ~= 78378376 then
            debugLogForce(nil, "YDLocal测试", "❌ real '多大的' 失败，期望 78378376，实际", ret2)
            success = false
        end
        if ret3 ~= true then
            debugLogForce(nil, "YDLocal测试", "❌ boolean '你好' 失败，期望 true，实际", ret3)
            success = false
        end
        if success then
            debugLogForce(nil, "YDLocal测试", "✅ 全部返回值测试成功！")
        end
        YDLocal1Release(nil)
        debugLogForce(
            nil,
            "YDLocal测试",
            "YDLocal1Release 后 G_SIndex=" .. tostring(getG_SIndex(nil))
        )
    else
        debugLogForce(nil, "YDLocal测试", "触发器未找到")
    end
    debugLogForce(nil, "YDLocal测试", "===== 测试结束 =====")
end
if ENABLED then
    local tm = jass:CreateTimer()
    jass:TimerStart(
        tm,
        1,
        false,
        function()
            testYDLocalReturn(nil)
            jass:DestroyTimer(tm)
        end
    )
end
return ____exports
