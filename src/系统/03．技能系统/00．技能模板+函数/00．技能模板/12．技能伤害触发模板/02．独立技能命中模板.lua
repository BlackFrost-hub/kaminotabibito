local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____6280_80FD_4F24_5BB3_5B9E_4F8B_5B58_5728 = ____require_result_1["技能伤害实例存在"]
local _____662F_72EC_7ACB_6280_80FD_4F24_5BB3_5FEB_7167 = ____require_result_1["是独立技能伤害快照"]
local _____6CE8_518C_6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C = ____require_result_1["注册技能伤害实例结束监听"]
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_8BB0_5F55_8868 = {}
local _____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_81EA_589EID = 0
local function _____5355_4F4D_6709_6548_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____662F_654C_65B9_547D_4E2D(attacker, target)
    if not _____5355_4F4D_6709_6548_5B58_6D3B(attacker) or not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return false
    end
    return IsUnitEnemy(
        target,
        GetOwningPlayer(attacker)
    )
end
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_6280_80FD_5B9E_4F8BID(snapshot)
    local ____opt_result_4
    if snapshot ~= nil then
        ____opt_result_4 = snapshot.skillInstanceId
    end
    local id = __TS__Number(____opt_result_4) or 0
    return id > 0 and id or 0
end
local function _____53D6_9608_503C(config)
    local threshold = config["命中次数"] or 1
    return threshold > 1 and threshold or 1
end
local function _____53D6_5B9E_4F8B_8BA1_6570(record, instanceId)
    local data = record["实例计数表"][instanceId]
    if data == nil then
        data = {["总命中次数"] = 0, ["目标命中次数表"] = {}, ["已触发次数"] = 0}
        record["实例计数表"][instanceId] = data
    end
    return data
end
local function _____901A_8FC7_6765_6E90_8FC7_6EE4(snapshot, _____6765_6E90_8FC7_6EE4)
    if not _____662F_72EC_7ACB_6280_80FD_4F24_5BB3_5FEB_7167(snapshot) then
        return false
    end
    local sourceKind = snapshot.skillDamageSourceKind
    local filter = _____6765_6E90_8FC7_6EE4 or "任意非装备技能"
    if filter == "任意非装备技能" then
        return sourceKind == "单位技能" or sourceKind == "Boss技能" or sourceKind == "召唤物技能"
    end
    return sourceKind == filter
end
local function _____901A_8FC7_5F62_6001_8FC7_6EE4(snapshot, filter)
    local shapeFilter = filter or "任意"
    if shapeFilter == "任意" then
        return true
    end
    local ____opt_result_7
    if snapshot ~= nil then
        ____opt_result_7 = snapshot.skillDamageShape
    end
    return ____opt_result_7 == shapeFilter
end
local function _____901A_8FC7_57FA_7840_8FC7_6EE4(target, attacker, applied, snapshot, config)
    if not (applied > 0) then
        return false
    end
    if not _____901A_8FC7_6765_6E90_8FC7_6EE4(snapshot, config["来源过滤"]) then
        return false
    end
    if not _____6280_80FD_4F24_5BB3_5B9E_4F8B_5B58_5728(_____53D6_6280_80FD_5B9E_4F8BID(snapshot)) then
        return false
    end
    if (config["目标过滤"] or "敌方") == "敌方" and not _____662F_654C_65B9_547D_4E2D(attacker, target) then
        return false
    end
    if config["技能ID"] ~= nil and snapshot.abilityId ~= config["技能ID"] then
        return false
    end
    if config["标签"] ~= nil and snapshot.skillDamageTag ~= config["标签"] then
        return false
    end
    if not _____901A_8FC7_5F62_6001_8FC7_6EE4(snapshot, config["伤害形态"]) then
        return false
    end
    return true
end
local function _____521B_5EFA_4E8B_4EF6(target, attacker, applied, snapshot, record, totalCount, targetCount)
    return {
        ["施法者"] = attacker,
        ["目标"] = target,
        ["本次伤害"] = applied,
        ["技能实例ID"] = _____53D6_6280_80FD_5B9E_4F8BID(snapshot),
        ["技能ID"] = snapshot.abilityId,
        ["来源类型"] = snapshot.skillDamageSourceKind,
        ["标签"] = snapshot.skillDamageTag,
        ["伤害形态"] = snapshot.skillDamageShape,
        ["命中次数"] = totalCount,
        ["同目标命中次数"] = targetCount,
        ["是首次命中"] = totalCount == 1,
        ["是同目标首次命中"] = targetCount == 1,
        ["伤害快照"] = snapshot,
        ["配置"] = record["配置"]
    }
end
local function _____521B_5EFA_88AB_547D_4E2D_4E8B_4EF6(event)
    local result = event
    result["受击者"] = event["目标"]
    result["攻击者"] = event["施法者"]
    return result
end
local function _____5E94_89E6_53D1(event, data, record)
    local config = record["配置"]
    local maxTimes = config["每个技能实例最多触发次数"] or 0
    if maxTimes > 0 and data["已触发次数"] >= maxTimes then
        return false
    end
    local threshold = _____53D6_9608_503C(config)
    if (config["计数口径"] or "技能实例") == "同目标" then
        return event["同目标命中次数"] == threshold
    end
    return event["命中次数"] == threshold
end
local function _____5199_5165_547D_4E2D_8BA1_6570(data, targetId, totalCount, targetCount)
    data["总命中次数"] = totalCount
    if targetId > 0 then
        data["目标命中次数表"][targetId] = targetCount
    end
end
local function _____89E6_53D1_540E_5904_7406_8BA1_6570(data, targetId, record)
    data["已触发次数"] = data["已触发次数"] + 1
    if record["配置"]["触发后清空计数"] ~= true then
        return
    end
    if (record["配置"]["计数口径"] or "技能实例") == "同目标" then
        if targetId > 0 then
            __TS__Delete(data["目标命中次数表"], targetId)
        end
        return
    end
    data["总命中次数"] = 0
    data["目标命中次数表"] = {}
end
local function _____5C1D_8BD5_6267_884C_72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1(target, attacker, applied, snapshot, record)
    if record["已停止"] or not _____901A_8FC7_57FA_7840_8FC7_6EE4(
        target,
        attacker,
        applied,
        snapshot,
        record["配置"]
    ) then
        return
    end
    local instanceId = _____53D6_6280_80FD_5B9E_4F8BID(snapshot)
    local targetId = _____53D6_5355_4F4DID(target)
    local data = _____53D6_5B9E_4F8B_8BA1_6570(record, instanceId)
    local totalCount = data["总命中次数"] + 1
    local targetCount = targetId > 0 and (data["目标命中次数表"][targetId] or 0) + 1 or 0
    local event = _____521B_5EFA_4E8B_4EF6(
        target,
        attacker,
        applied,
        snapshot,
        record,
        totalCount,
        targetCount
    )
    if record["配置"]["自定义过滤"] ~= nil and not record["配置"]["自定义过滤"](event) then
        return
    end
    if not _____5E94_89E6_53D1(event, data, record) then
        _____5199_5165_547D_4E2D_8BA1_6570(data, targetId, totalCount, targetCount)
        return
    end
    _____5199_5165_547D_4E2D_8BA1_6570(data, targetId, totalCount, targetCount)
    record["配置"]["on命中"](event)
    _____89E6_53D1_540E_5904_7406_8BA1_6570(data, targetId, record)
end
local function ____on_72EC_7ACB_6280_80FD_547D_4E2D_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    for key in pairs(_____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_8BB0_5F55_8868) do
        local record = _____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_8BB0_5F55_8868[__TS__Number(key) or 0]
        if record ~= nil then
            _____5C1D_8BD5_6267_884C_72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1(
                target,
                attacker,
                applied,
                snapshot,
                record
            )
        end
    end
end
local function ____on_72EC_7ACB_6280_80FD_5B9E_4F8B_7ED3_675F(id)
    for key in pairs(_____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_8BB0_5F55_8868) do
        local record = _____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_8BB0_5F55_8868[__TS__Number(key) or 0]
        if record ~= nil then
            __TS__Delete(record["实例计数表"], id)
        end
    end
end
registerAppliedFinalDamageListener(____on_72EC_7ACB_6280_80FD_547D_4E2D_6700_7EC8_4F24_5BB3)
_____6CE8_518C_6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C(____on_72EC_7ACB_6280_80FD_5B9E_4F8B_7ED3_675F)
____exports["注册独立技能命中模板"] = function(_____914D_7F6E)
    _____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_81EA_589EID = _____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_81EA_589EID + 1
    local id = _____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_81EA_589EID
    local record
    record = {
        id = id,
        ["名称"] = _____914D_7F6E["名称"] or "独立技能命中#" .. tostring(id),
        ["配置"] = _____914D_7F6E,
        ["实例计数表"] = {},
        ["已停止"] = false,
        ["读取命中次数"] = function(_____6280_80FD_5B9E_4F8BID, _____76EE_6807)
            local data = record["实例计数表"][_____6280_80FD_5B9E_4F8BID]
            if data == nil then
                return 0
            end
            if _____76EE_6807 ~= nil then
                return data["目标命中次数表"][_____53D6_5355_4F4DID(_____76EE_6807)] or 0
            end
            return data["总命中次数"]
        end,
        ["清空"] = function(_____6280_80FD_5B9E_4F8BID)
            if _____6280_80FD_5B9E_4F8BID == nil or _____6280_80FD_5B9E_4F8BID <= 0 then
                record["实例计数表"] = {}
                return
            end
            __TS__Delete(record["实例计数表"], _____6280_80FD_5B9E_4F8BID)
        end,
        ["停止"] = function()
            record["已停止"] = true
            record["实例计数表"] = {}
            __TS__Delete(_____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_8BB0_5F55_8868, id)
        end
    }
    _____72EC_7ACB_6280_80FD_547D_4E2D_89E6_53D1_8BB0_5F55_8868[id] = record
    return record
end
____exports["注册独立技能首次命中模板"] = function(_____914D_7F6E)
    return ____exports["注册独立技能命中模板"](__TS__ObjectAssign({}, _____914D_7F6E, {["计数口径"] = "技能实例", ["命中次数"] = 1, ["on命中"] = _____914D_7F6E["on首次命中"]}))
end
____exports["注册被独立技能命中模板"] = function(_____914D_7F6E)
    return ____exports["注册独立技能命中模板"](__TS__ObjectAssign(
        {},
        _____914D_7F6E,
        {
            ["自定义过滤"] = function(event)
                if _____914D_7F6E["自定义过滤"] == nil then
                    return true
                end
                return _____914D_7F6E["自定义过滤"](_____521B_5EFA_88AB_547D_4E2D_4E8B_4EF6(event))
            end,
            ["on命中"] = function(event)
                _____914D_7F6E["on被命中"](_____521B_5EFA_88AB_547D_4E2D_4E8B_4EF6(event))
            end
        }
    ))
end
____exports["注册首次被独立技能命中模板"] = function(_____914D_7F6E)
    return ____exports["注册被独立技能命中模板"](__TS__ObjectAssign({}, _____914D_7F6E, {["计数口径"] = "同目标", ["命中次数"] = 1, ["on被命中"] = _____914D_7F6E["on首次被命中"]}))
end
return ____exports
