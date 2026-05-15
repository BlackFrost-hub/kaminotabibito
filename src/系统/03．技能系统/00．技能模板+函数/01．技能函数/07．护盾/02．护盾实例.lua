local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_62A4_76FE_7C7B_578B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.01．护盾类型")
local _____62A4_76FE_7C7B_578B = ____01_FF0E_62A4_76FE_7C7B_578B["护盾类型"]
local _____7C7B_578B_4F18_5148_7EA7 = ____01_FF0E_62A4_76FE_7C7B_578B["类型优先级"]
local _____9ED8_8BA4_62B5_6321_4F18_5148_7EA7 = ____01_FF0E_62A4_76FE_7C7B_578B["默认抵挡优先级"]
--- 护盾实例管理
-- 
-- 职责：
-- - 护盾实例的创建、存储、删除
-- - 单位与护盾的映射关系
-- - 护盾ID分配
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
--- 护盾ID -> 护盾实例
local _____62A4_76FE_6620_5C04 = __TS__New(Map)
--- 单位ID -> 护盾ID列表
local _____5355_4F4D_62A4_76FE_6620_5C04 = __TS__New(Map)
--- 下一个护盾ID
local _____4E0B_4E00_4E2A_62A4_76FEID = 1
____exports["取句柄ID"] = function(h)
    if h == nil or h == 0 then
        return 0
    end
    return GetHandleId(h)
end
local function _____83B7_53D6_6709_5E8F_62A4_76FEID_5217_8868()
    local result = {}
    for ____, _____62A4_76FEID in __TS__Iterator(_____62A4_76FE_6620_5C04:keys()) do
        result[#result + 1] = _____62A4_76FEID
    end
    __TS__ArraySort(
        result,
        function(____, a, b) return a - b end
    )
    return result
end
--- 创建护盾实例（不触发开始回调，由调用方负责）
____exports["创建护盾实例"] = function(_____5355_4F4D, _____53C2_6570)
    local _____5355_4F4DID = ____exports["取句柄ID"](_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return nil
    end
    local ____4E0B_4E00_4E2A_62A4_76FEID_0 = _____4E0B_4E00_4E2A_62A4_76FEID
    _____4E0B_4E00_4E2A_62A4_76FEID = ____4E0B_4E00_4E2A_62A4_76FEID_0 + 1
    local id = ____4E0B_4E00_4E2A_62A4_76FEID_0
    local _____5B9E_4F8B = {
        id = id,
        ["单位"] = _____5355_4F4D,
        ["单位ID"] = _____5355_4F4DID,
        ["来源单位"] = _____53C2_6570["来源单位"],
        ["类型"] = _____53C2_6570["类型"] or _____62A4_76FE_7C7B_578B["通用"],
        ["初始值"] = _____53C2_6570["数值"],
        ["当前值"] = _____53C2_6570["数值"],
        ["总持续时间"] = _____53C2_6570["持续时间"] or 0,
        ["剩余时间"] = _____53C2_6570["持续时间"] or 0,
        ["类型优先级"] = _____53C2_6570["类型优先级"] or _____7C7B_578B_4F18_5148_7EA7[_____53C2_6570["类型"] or _____62A4_76FE_7C7B_578B["通用"]],
        ["抵挡优先级"] = _____53C2_6570["抵挡优先级"] or _____9ED8_8BA4_62B5_6321_4F18_5148_7EA7,
        ["显示护盾条"] = _____53C2_6570["显示护盾条"] ~= false,
        ["可驱散"] = _____53C2_6570["可驱散"] ~= false,
        ["标签"] = _____53C2_6570["标签"],
        ["开始回调"] = _____53C2_6570["开始回调"],
        ["破碎回调"] = _____53C2_6570["破碎回调"],
        ["到期回调"] = _____53C2_6570["到期回调"],
        ["结束回调"] = _____53C2_6570["结束回调"]
    }
    _____62A4_76FE_6620_5C04:set(id, _____5B9E_4F8B)
    local _____5355_4F4D_62A4_76FE_5217_8868 = _____5355_4F4D_62A4_76FE_6620_5C04:get(_____5355_4F4DID)
    if _____5355_4F4D_62A4_76FE_5217_8868 == nil then
        _____5355_4F4D_62A4_76FE_5217_8868 = {}
        _____5355_4F4D_62A4_76FE_6620_5C04:set(_____5355_4F4DID, _____5355_4F4D_62A4_76FE_5217_8868)
    end
    _____5355_4F4D_62A4_76FE_5217_8868[#_____5355_4F4D_62A4_76FE_5217_8868 + 1] = id
    return _____5B9E_4F8B
end
--- 获取护盾实例
____exports["获取护盾实例"] = function(_____62A4_76FEID)
    return _____62A4_76FE_6620_5C04:get(_____62A4_76FEID)
end
--- 删除护盾实例（不触发回调，由调用方负责）
____exports["删除护盾实例"] = function(_____62A4_76FEID)
    local _____5B9E_4F8B = _____62A4_76FE_6620_5C04:get(_____62A4_76FEID)
    if _____5B9E_4F8B == nil then
        return false
    end
    _____62A4_76FE_6620_5C04:delete(_____62A4_76FEID)
    local _____5355_4F4D_62A4_76FE_5217_8868 = _____5355_4F4D_62A4_76FE_6620_5C04:get(_____5B9E_4F8B["单位ID"])
    if _____5355_4F4D_62A4_76FE_5217_8868 ~= nil then
        local index = __TS__ArrayIndexOf(_____5355_4F4D_62A4_76FE_5217_8868, _____62A4_76FEID)
        if index >= 0 then
            __TS__ArraySplice(_____5355_4F4D_62A4_76FE_5217_8868, index, 1)
        end
        if #_____5355_4F4D_62A4_76FE_5217_8868 == 0 then
            _____5355_4F4D_62A4_76FE_6620_5C04:delete(_____5B9E_4F8B["单位ID"])
        end
    end
    return true
end
--- 获取单位的所有护盾ID
____exports["获取单位护盾列表"] = function(_____5355_4F4DID)
    return _____5355_4F4D_62A4_76FE_6620_5C04:get(_____5355_4F4DID) or ({})
end
--- 获取单位的所有护盾实例
____exports["获取单位护盾实例列表"] = function(_____5355_4F4DID)
    local ids = ____exports["获取单位护盾列表"](_____5355_4F4DID)
    local result = {}
    for ____, id in ipairs(ids) do
        local _____5B9E_4F8B = _____62A4_76FE_6620_5C04:get(id)
        if _____5B9E_4F8B ~= nil then
            result[#result + 1] = _____5B9E_4F8B
        end
    end
    return result
end
--- 删除单位的所有护盾
____exports["删除单位所有护盾"] = function(_____5355_4F4DID)
    local ids = ____exports["获取单位护盾列表"](_____5355_4F4DID)
    local deleted = {}
    for ____, id in ipairs(ids) do
        local _____5B9E_4F8B = _____62A4_76FE_6620_5C04:get(id)
        if _____5B9E_4F8B ~= nil then
            deleted[#deleted + 1] = _____5B9E_4F8B
        end
        _____62A4_76FE_6620_5C04:delete(id)
    end
    _____5355_4F4D_62A4_76FE_6620_5C04:delete(_____5355_4F4DID)
    return deleted
end
--- 检查单位是否有护盾
____exports["单位是否有护盾"] = function(_____5355_4F4DID)
    local list = _____5355_4F4D_62A4_76FE_6620_5C04:get(_____5355_4F4DID)
    return list ~= nil and #list > 0
end
--- 获取单位总护盾值
____exports["获取单位总护盾值"] = function(_____5355_4F4DID)
    local ids = ____exports["获取单位护盾列表"](_____5355_4F4DID)
    local total = 0
    for ____, id in ipairs(ids) do
        local _____5B9E_4F8B = _____62A4_76FE_6620_5C04:get(id)
        if _____5B9E_4F8B ~= nil then
            total = total + _____5B9E_4F8B["当前值"]
        end
    end
    return total
end
--- 获取单位指定类型护盾值
____exports["获取单位类型护盾值"] = function(_____5355_4F4DID, _____7C7B_578B)
    local ids = ____exports["获取单位护盾列表"](_____5355_4F4DID)
    local total = 0
    for ____, id in ipairs(ids) do
        local _____5B9E_4F8B = _____62A4_76FE_6620_5C04:get(id)
        if _____5B9E_4F8B ~= nil and _____5B9E_4F8B["类型"] == _____7C7B_578B then
            total = total + _____5B9E_4F8B["当前值"]
        end
    end
    return total
end
--- 清除所有护盾数据（用于测试或重置）
____exports["清除所有护盾数据"] = function()
    _____62A4_76FE_6620_5C04:clear()
    _____5355_4F4D_62A4_76FE_6620_5C04:clear()
    _____4E0B_4E00_4E2A_62A4_76FEID = 1
end
--- 获取所有活动护盾实例（供生命周期模块使用）
____exports["获取所有活动护盾实例"] = function()
    local result = {}
    local _____62A4_76FEID_5217_8868 = _____83B7_53D6_6709_5E8F_62A4_76FEID_5217_8868()
    do
        local i = 0
        while i < #_____62A4_76FEID_5217_8868 do
            local _____5B9E_4F8B = _____62A4_76FE_6620_5C04:get(_____62A4_76FEID_5217_8868[i + 1])
            if _____5B9E_4F8B ~= nil then
                result[#result + 1] = _____5B9E_4F8B
            end
            i = i + 1
        end
    end
    return result
end
return ____exports
