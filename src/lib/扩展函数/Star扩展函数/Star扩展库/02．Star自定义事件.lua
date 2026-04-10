--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
local YDLocalExecuteTrigger = ____require_result_0.YDLocalExecuteTrigger
local YDTriggerExecuteTrigger = ____require_result_0.YDTriggerExecuteTrigger
local StarBaseHT = nil
local skey_count = 0
local skey_countEx = 0
local skey_index = 0
local skey_indexEx = 0
local StarVarStr = ""
local initialized = false
local function init(self)
    if initialized then
        return
    end
    if type(jass.InitHashtable) ~= "function" then
        return
    end
    if type(jass.StringHash) ~= "function" then
        return
    end
    StarBaseHT = jass.InitHashtable()
    ____exports.StarBaseHT = StarBaseHT
    skey_count = jass.StringHash("count")
    ____exports.skey_count = skey_count
    skey_countEx = jass.StringHash("countEx")
    ____exports.skey_countEx = skey_countEx
    skey_index = jass.StringHash("index")
    ____exports.skey_index = skey_index
    skey_indexEx = jass.StringHash("indexEx")
    ____exports.skey_indexEx = skey_indexEx
    initialized = true
end
--- 获取自定义事件系统使用的全局哈希表
-- 
-- @returns 哈希表句柄，未初始化时返回 null
function ____exports.STES_GetTable(self)
    init(nil)
    return StarBaseHT
end
--- 为触发器注册自定义事件
-- 
-- @param t 目标触发器
-- @param name 事件名称
function ____exports.STES_Register(self, t, name)
    init(nil)
    if not StarBaseHT then
        return
    end
    if type(jass.GetHandleId) ~= "function" then
        return
    end
    local hash = jass.StringHash(name)
    local hd = jass.GetHandleId(t)
    local index = jass.LoadInteger(StarBaseHT, hash, skey_index)
    local index2 = jass.LoadInteger(StarBaseHT, hd, skey_index)
    if type(jass.SaveTriggerHandle) == "function" then
        jass.SaveTriggerHandle(StarBaseHT, hash, index, t)
    end
    jass.SaveInteger(StarBaseHT, hash, skey_index, index + 1)
    jass.SaveStr(StarBaseHT, hd, index2, name)
    jass.SaveInteger(StarBaseHT, hd, skey_index, index2 + 1)
end
--- 触发自定义事件，执行所有注册了该事件名的触发器
-- 
-- @param name 事件名称
function ____exports.STES_Fire(self, name)
    init(nil)
    if not StarBaseHT then
        return
    end
    if type(jass.StringHash) ~= "function" then
        return
    end
    if type(jass.LoadInteger) ~= "function" then
        return
    end
    local hash = jass.StringHash(name)
    local loopIndex = jass.LoadInteger(StarBaseHT, hash, skey_index)
    do
        local i = 0
        while i < loopIndex do
            local trg = jass.LoadTriggerHandle(StarBaseHT, hash, i)
            if trg then
                YDLocalExecuteTrigger(nil, trg)
                YDTriggerExecuteTrigger(nil, trg, false)
            end
            i = i + 1
        end
    end
end
____exports.StarBaseHT = StarBaseHT
____exports.skey_count = skey_count
____exports.skey_countEx = skey_countEx
____exports.skey_index = skey_index
____exports.skey_indexEx = skey_indexEx
____exports.StarVarStr = StarVarStr
return ____exports
