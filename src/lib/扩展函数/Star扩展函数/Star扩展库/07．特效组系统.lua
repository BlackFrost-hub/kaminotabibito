local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
--- Star扩展库 - 特效组系统
-- 
-- 来源于 EG.j，管理特效（effect）的分组集合。
-- 原版使用 hashtable 存储，现改用 Lua table 实现，性能更优。
-- 
-- 公开接口：
--   EG_CreateEffectGroup()                - 创建特效组，返回组ID
--   EG_RemoveGroup(id)                    - 移除特效组
--   EG_ClearGroup(id)                     - 清空特效组内所有特效
--   EG_GroupAddEffect(e, id)              - 添加特效到组（不允许重复）
--   EG_GroupAddEffectEx(e, id)            - 添加特效到组（允许重复）
--   EG_RemoveEffectOfGroup(e, id)         - 从组中移除特效
--   EG_ForGroup(id, callback)             - 遍历特效组，对每个特效调用回调
--   EG_GetFirstOfGroup(id)                - 获取组中第一个特效
--   EG_GetRandomOfGroup(id)               - 获取组中随机一个特效
--   EG_IsEffectOnGroup(e, id)             - 特效是否在组中，返回索引或-1
--   EG_IsGroupHaveEffect(e, id)           - 特效是否在组中，返回布尔
--   EG_IsGroupEmpty(id)                   - 特效组是否为空
--   EG_GetCount(id)                       - 获取特效组中特效数量
--   EG_GetAt(id, i)                       - 获取组中第i个特效
--   EG_GroupAddGroup(srcId, destId)       - 将destId组内所有特效添加到srcId组
--   EG_I2EG(id)                           - 整数转特效组ID（恒等）
--   EG_EG2I(eg)                           - 特效组ID转整数（恒等）
local jass = require("jass.common")
local nextGroupId = 5000001
local groups = {}
--- 创建一个特效组
-- 
-- @returns 特效组ID
function ____exports.EG_CreateEffectGroup(self)
    local id = nextGroupId
    nextGroupId = nextGroupId + 1
    groups[id] = {}
    return id
end
--- 移除特效组
-- 
-- @param id 特效组ID
function ____exports.EG_RemoveGroup(self, id)
    __TS__Delete(groups, id)
end
--- 清空特效组内所有特效
-- 
-- @param id 特效组ID
function ____exports.EG_ClearGroup(self, id)
    local g = groups[id]
    if g == nil then
        return
    end
    __TS__ArraySetLength(g, 0)
end
--- 添加特效到组（不允许重复）
-- 
-- @param e 特效句柄
-- @param id 特效组ID
-- @returns 是否添加成功
function ____exports.EG_GroupAddEffect(self, e, id)
    local g = groups[id]
    if g == nil then
        return false
    end
    do
        local i = 0
        while i < #g do
            if g[i + 1] == e then
                return false
            end
            i = i + 1
        end
    end
    g[#g + 1] = e
    return true
end
--- 添加特效到组（允许重复）
-- 
-- @param e 特效句柄
-- @param id 特效组ID
-- @returns 是否添加成功
function ____exports.EG_GroupAddEffectEx(self, e, id)
    local g = groups[id]
    if g == nil then
        return false
    end
    g[#g + 1] = e
    return true
end
--- 从组中移除特效（swap-with-last法，O(1)移除）
-- 
-- @param e 特效句柄
-- @param id 特效组ID
-- @returns 是否移除成功
function ____exports.EG_RemoveEffectOfGroup(self, e, id)
    local g = groups[id]
    if g == nil then
        return false
    end
    local max = #g - 1
    if max < 0 then
        return false
    end
    do
        local i = 0
        while i <= max do
            if g[i + 1] == e then
                if i ~= max then
                    g[i + 1] = g[max + 1]
                end
                table.remove(g)
                return true
            end
            i = i + 1
        end
    end
    return false
end
--- 遍历特效组，对每个特效调用回调
-- 回调中可安全调用 EG_RemoveEffectOfGroup 移除当前特效
-- 
-- @param id 特效组ID
-- @param callback 回调函数，参数为当前遍历到的特效
function ____exports.EG_ForGroup(self, id, callback)
    local g = groups[id]
    if g == nil then
        return
    end
    local i = 0
    while i < #g do
        local e = g[i + 1]
        local lenBefore = #g
        callback(nil, e)
        if #g < lenBefore then
        else
            i = i + 1
        end
    end
end
--- 获取组中第一个特效
-- 
-- @param id 特效组ID
-- @returns 第一个特效，组为空时返回null
function ____exports.EG_GetFirstOfGroup(self, id)
    local g = groups[id]
    if g == nil or #g == 0 then
        return nil
    end
    return g[1]
end
--- 获取组中随机一个特效
-- 
-- @param id 特效组ID
-- @returns 随机特效，组为空时返回null
function ____exports.EG_GetRandomOfGroup(self, id)
    local g = groups[id]
    if g == nil or #g == 0 then
        return nil
    end
    local max = #g - 1
    if max < 0 then
        return nil
    end
    local idx = jass:GetRandomInt(0, max)
    return g[idx]
end
--- 特效是否在指定特效组中
-- 
-- @param e 特效句柄
-- @param id 特效组ID
-- @returns 索引位置，不存在返回-1
function ____exports.EG_IsEffectOnGroup(self, e, id)
    local g = groups[id]
    if g == nil then
        return -1
    end
    do
        local i = 0
        while i < #g do
            if g[i + 1] == e then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
--- 特效是否在指定特效组中
-- 
-- @param e 特效句柄
-- @param id 特效组ID
-- @returns 是否存在
function ____exports.EG_IsGroupHaveEffect(self, e, id)
    return ____exports.EG_IsEffectOnGroup(nil, e, id) ~= -1
end
--- 特效组是否为空
-- 
-- @param id 特效组ID
-- @returns 是否为空
function ____exports.EG_IsGroupEmpty(self, id)
    local g = groups[id]
    if g == nil then
        return true
    end
    return #g == 0
end
--- 获取特效组中特效数量
-- 
-- @param id 特效组ID
-- @returns 特效数量
function ____exports.EG_GetCount(self, id)
    local g = groups[id]
    if g == nil then
        return 0
    end
    return #g
end
--- 获取特效组中第i个特效
-- 
-- @param id 特效组ID
-- @param i 索引（0-based）
-- @returns 特效句柄，越界返回null
function ____exports.EG_GetAt(self, id, i)
    local g = groups[id]
    if g == nil then
        return nil
    end
    if i < 0 or i >= #g then
        return nil
    end
    return g[i + 1]
end
--- 将destId组内所有特效添加到srcId组（不允许重复添加）
-- 
-- @param srcId 目标特效组ID
-- @param destId 源特效组ID
function ____exports.EG_GroupAddGroup(self, srcId, destId)
    local src = groups[srcId]
    local dest = groups[destId]
    if src == nil or dest == nil then
        return
    end
    do
        local i = 0
        while i < #dest do
            ____exports.EG_GroupAddEffect(nil, dest[i + 1], srcId)
            i = i + 1
        end
    end
end
--- 整数转特效组ID（恒等转换）
function ____exports.EG_I2EG(self, id)
    return id
end
--- 特效组ID转整数（恒等转换）
function ____exports.EG_EG2I(self, eg)
    return eg
end
return ____exports
