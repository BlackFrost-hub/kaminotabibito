local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____6280_80FD_4F24_5BB3_5B9E_4F8B_5B58_5728 = ____require_result_1["技能伤害实例存在"]
local _____6807_8BB0_6280_80FD_4F24_5BB3_5B9E_4F8B_9996_6B21_547D_4E2D = ____require_result_1["标记技能伤害实例首次命中"]
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_8BB0_5F55_8868 = {}
local _____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_81EA_589EID = 0
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
local function _____901A_8FC7_6765_6E90_8FC7_6EE4(snapshot, _____6765_6E90_8FC7_6EE4)
    if snapshot == nil or snapshot.isWrappedSkillDamage ~= true then
        return false
    end
    if snapshot.isEquipmentSkillDamage == true then
        return false
    end
    local sourceKind = snapshot.skillDamageSourceKind
    local filter = _____6765_6E90_8FC7_6EE4 or "任意非装备技能"
    if filter == "任意非装备技能" then
        return sourceKind == "单位技能" or sourceKind == "Boss技能" or sourceKind == "召唤物技能"
    end
    return sourceKind == filter
end
local function _____521B_5EFA_4E8B_4EF6(target, attacker, applied, snapshot, record)
    return {
        ["施法者"] = attacker,
        ["目标"] = target,
        ["本次伤害"] = applied,
        ["技能实例ID"] = snapshot.skillInstanceId,
        ["技能ID"] = snapshot.abilityId,
        ["来源类型"] = snapshot.skillDamageSourceKind,
        ["标签"] = snapshot.skillDamageTag,
        ["伤害快照"] = snapshot,
        ["配置"] = record["配置"]
    }
end
local function _____5C1D_8BD5_89E6_53D1_6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D(target, attacker, applied, snapshot, record)
    if not (applied > 0) then
        return
    end
    if not _____662F_654C_65B9_547D_4E2D(attacker, target) then
        return
    end
    local config = record["配置"]
    if not _____901A_8FC7_6765_6E90_8FC7_6EE4(snapshot, config["来源过滤"]) then
        return
    end
    local ____opt_result_4
    if snapshot ~= nil then
        ____opt_result_4 = snapshot.skillInstanceId
    end
    local instanceId = ____opt_result_4
    if instanceId == nil or instanceId <= 0 or not _____6280_80FD_4F24_5BB3_5B9E_4F8B_5B58_5728(instanceId) then
        return
    end
    if config["技能ID"] ~= nil and snapshot.abilityId ~= config["技能ID"] then
        return
    end
    if config["标签"] ~= nil and snapshot.skillDamageTag ~= config["标签"] then
        return
    end
    local event = _____521B_5EFA_4E8B_4EF6(
        target,
        attacker,
        applied,
        snapshot,
        record
    )
    if config["自定义过滤"] ~= nil and not config["自定义过滤"](event) then
        return
    end
    if not _____6807_8BB0_6280_80FD_4F24_5BB3_5B9E_4F8B_9996_6B21_547D_4E2D(instanceId) then
        return
    end
    config["on首次命中"](event)
end
local function ____on_6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    for key in pairs(_____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_8BB0_5F55_8868) do
        local record = _____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_8BB0_5F55_8868[__TS__Number(key) or 0]
        if record ~= nil then
            _____5C1D_8BD5_89E6_53D1_6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D(
                target,
                attacker,
                applied,
                snapshot,
                record
            )
        end
    end
end
registerAppliedFinalDamageListener(____on_6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_6700_7EC8_4F24_5BB3)
____exports["注册技能首次伤害命中模板"] = function(_____914D_7F6E)
    _____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_81EA_589EID = _____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_81EA_589EID + 1
    local id = _____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_81EA_589EID
    local record = {
        id = id,
        ["名称"] = _____914D_7F6E["名称"] or "技能首次伤害命中#" .. tostring(id),
        ["配置"] = _____914D_7F6E,
        ["停止"] = function()
            __TS__Delete(_____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_8BB0_5F55_8868, id)
        end
    }
    _____6280_80FD_9996_6B21_4F24_5BB3_547D_4E2D_8BB0_5F55_8868[id] = record
    return record
end
return ____exports
