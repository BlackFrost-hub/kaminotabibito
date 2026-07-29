local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_2.doHeal
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local GetOwningPlayer = jass.GetOwningPlayer
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local GetUnitStateJapi = japi.GetUnitState
local _____51FB_6740_56DE_590D_89E6_53D1_8BB0_5F55_8868 = {}
local _____51FB_6740_56DE_590D_51B7_5374_8868 = {}
local _____51FB_6740_56DE_590D_89E6_53D1_8BA1_6570 = 0
local _____5DF2_6CE8_518C_51FB_6740_56DE_590D_6B7B_4EA1_76D1_542C = false
local function _____5355_4F4D_6709_6548_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, jass.UNIT_STATE_LIFE) > 0.405
end
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_6700_5927_751F_547D(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) or GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) or 0
end
local function _____53D6_6700_5927_9B54_6CD5(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA) or GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA) or 0
end
local function _____53D6_51B7_5374_952E(unit, record)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return ""
    end
    return (tostring(record.ID) .. ":") .. tostring(id)
end
local function _____51B7_5374_901A_8FC7_5E76_8BB0_5F55(unit, record)
    local cd = record["配置"]["冷却秒数"] or 0
    if not (cd > 0) then
        return true
    end
    local key = _____53D6_51B7_5374_952E(unit, record)
    if key == "" then
        return false
    end
    local now = getServerTime()
    local ____end = _____51FB_6740_56DE_590D_51B7_5374_8868[key]
    if ____end ~= nil and now < ____end then
        return false
    end
    _____51FB_6740_56DE_590D_51B7_5374_8868[key] = now + cd * 1000
    return true
end
local function _____8BA1_7B97_6062_590D_751F_547D(unit, config)
    return (config["恢复生命值"] or 0) + _____53D6_6700_5927_751F_547D(unit) * (config["恢复最大生命比例"] or 0)
end
local function _____8BA1_7B97_6062_590D_9B54_6CD5(unit, config)
    return (config["恢复魔法值"] or 0) + _____53D6_6700_5927_9B54_6CD5(unit) * (config["恢复最大魔法比例"] or 0)
end
local function _____5C1D_8BD5_6267_884C_51FB_6740_56DE_590D(dyingUnit, killingUnit, record)
    if record["已停止"] or not _____5355_4F4D_6709_6548_5B58_6D3B(killingUnit) then
        return
    end
    if dyingUnit == nil or dyingUnit == 0 or dyingUnit == killingUnit then
        return
    end
    if record["配置"]["只触发敌方死亡"] ~= false and not IsUnitEnemy(
        dyingUnit,
        GetOwningPlayer(killingUnit)
    ) then
        return
    end
    local event = {["击杀单位"] = killingUnit, ["死亡单位"] = dyingUnit, ["配置"] = record["配置"]}
    if record["配置"]["触发条件"] ~= nil and not record["配置"]["触发条件"](event) then
        return
    end
    if not _____51B7_5374_901A_8FC7_5E76_8BB0_5F55(killingUnit, record) then
        return
    end
    local heal = _____8BA1_7B97_6062_590D_751F_547D(killingUnit, record["配置"])
    local mana = _____8BA1_7B97_6062_590D_9B54_6CD5(killingUnit, record["配置"])
    if not (heal > 0) and not (mana > 0) then
        return
    end
    doHeal({
        HealSource = killingUnit,
        HealTarget = killingUnit,
        HealAmount = heal,
        HealManaAmount = mana,
        ItemHeal = true,
        HealEffect = record["配置"]["使用默认生命特效"] == true or record["配置"]["生命特效路径"] ~= nil and record["配置"]["生命特效路径"] ~= "",
        HealEffectPath = record["配置"]["生命特效路径"],
        UseDefaultHealEffect = record["配置"]["使用默认生命特效"] == true,
        ManaEffect = record["配置"]["使用默认魔法特效"] == true or record["配置"]["魔法特效路径"] ~= nil and record["配置"]["魔法特效路径"] ~= "",
        ManaEffectPath = record["配置"]["魔法特效路径"],
        UseDefaultManaEffect = record["配置"]["使用默认魔法特效"] == true,
        ManaShowText = mana > 0
    })
    if record["配置"]["on触发后"] ~= nil then
        record["配置"]["on触发后"](event, heal, mana)
    end
end
local function ____on_51FB_6740_56DE_590D_6B7B_4EA1_4E8B_4EF6(dyingUnit, killingUnit)
    for key in pairs(_____51FB_6740_56DE_590D_89E6_53D1_8BB0_5F55_8868) do
        local record = _____51FB_6740_56DE_590D_89E6_53D1_8BB0_5F55_8868[__TS__Number(key) or 0]
        if record ~= nil then
            _____5C1D_8BD5_6267_884C_51FB_6740_56DE_590D(dyingUnit, killingUnit, record)
        end
    end
end
local function _____786E_4FDD_51FB_6740_56DE_590D_6B7B_4EA1_76D1_542C()
    if _____5DF2_6CE8_518C_51FB_6740_56DE_590D_6B7B_4EA1_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_51FB_6740_56DE_590D_6B7B_4EA1_76D1_542C = true
    registerDeathListener(____on_51FB_6740_56DE_590D_6B7B_4EA1_4E8B_4EF6)
end
____exports["注册击杀回复触发模板"] = function(_____914D_7F6E)
    _____786E_4FDD_51FB_6740_56DE_590D_6B7B_4EA1_76D1_542C()
    _____51FB_6740_56DE_590D_89E6_53D1_8BA1_6570 = _____51FB_6740_56DE_590D_89E6_53D1_8BA1_6570 + 1
    local id = _____51FB_6740_56DE_590D_89E6_53D1_8BA1_6570
    local record
    record = {
        ID = id,
        ["名称"] = _____914D_7F6E["名称"] or "击杀回复触发#" .. tostring(id),
        ["配置"] = _____914D_7F6E,
        ["已停止"] = false,
        ["停止"] = function()
            record["已停止"] = true
            __TS__Delete(_____51FB_6740_56DE_590D_89E6_53D1_8BB0_5F55_8868, id)
        end
    }
    _____51FB_6740_56DE_590D_89E6_53D1_8BB0_5F55_8868[id] = record
    return record
end
return ____exports
