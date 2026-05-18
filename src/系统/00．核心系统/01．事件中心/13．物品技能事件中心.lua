local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local _____73A9_5BB6_5355_4F4D_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local _____6280_80FD_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
____exports["物品技能事件玩家范围"] = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
}
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local GetTriggerUnit = jass.GetTriggerUnit
local GetManipulatedItem = jass.GetManipulatedItem
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetDestructable = jass.GetSpellTargetDestructable
local GetHandleId = jass.GetHandleId
local Location = jass.Location
local RemoveLocation = jass.RemoveLocation
local EVENT_PLAYER_UNIT_USE_ITEM = jass.EVENT_PLAYER_UNIT_USE_ITEM
local _____76D1_542C_5217_8868 = {}
local _____65BD_6CD5_8005_6280_80FD_4E0A_4E0B_6587_8868 = {}
local _____5DF2_521D_59CB_5316 = false
local _____4F7F_7528_7269_54C1_89E6_53D1_5668 = nil
local _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587 = nil
local _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_76EE_6807_70B9 = nil
local function _____5DF2_6CE8_518C_76D1_542C(_____56DE_8C03)
    do
        local i = 0
        while i < #_____76D1_542C_5217_8868 do
            if _____76D1_542C_5217_8868[i + 1] == _____56DE_8C03 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____6E05_7406_6700_8FD1_76EE_6807_70B9()
    if _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_76EE_6807_70B9 == nil or _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_76EE_6807_70B9 == 0 then
        return
    end
    RemoveLocation(_____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_76EE_6807_70B9)
    _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_76EE_6807_70B9 = nil
end
local function _____8BBE_7F6E_6700_8FD1_7269_54C1_6280_80FD_4E0A_4E0B_6587(_____4E0A_4E0B_6587)
    _____6E05_7406_6700_8FD1_76EE_6807_70B9()
    _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587 = _____4E0A_4E0B_6587
end
local function _____6E05_7406_6700_8FD1_7269_54C1_6280_80FD_4E0A_4E0B_6587()
    _____6E05_7406_6700_8FD1_76EE_6807_70B9()
    _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587 = nil
end
local function _____83B7_53D6_65BD_6CD5_8005_7F13_5B58_952E(_____65BD_6CD5_5355_4F4D)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____65BD_6CD5_5355_4F4D)
end
local function _____7F13_5B58_6280_80FD_751F_6548_4E0A_4E0B_6587(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    local _____65BD_6CD5_8005ID = _____83B7_53D6_65BD_6CD5_8005_7F13_5B58_952E(_____65BD_6CD5_5355_4F4D)
    if _____65BD_6CD5_8005ID == 0 then
        return
    end
    _____65BD_6CD5_8005_6280_80FD_4E0A_4E0B_6587_8868[_____65BD_6CD5_8005ID] = {
        ["技能ID"] = _____6280_80FDID,
        ["目标X"] = GetSpellTargetX(),
        ["目标Y"] = GetSpellTargetY(),
        ["目标单位"] = GetSpellTargetUnit(),
        ["目标可破坏物"] = GetSpellTargetDestructable()
    }
end
local function _____5206_53D1_7269_54C1_6280_80FD_4E8B_4EF6_76D1_542C(_____4E0A_4E0B_6587)
    _____8BBE_7F6E_6700_8FD1_7269_54C1_6280_80FD_4E0A_4E0B_6587(_____4E0A_4E0B_6587)
    do
        local i = 0
        while i < #_____76D1_542C_5217_8868 do
            local _____56DE_8C03 = _____76D1_542C_5217_8868[i + 1]
            if _____56DE_8C03 ~= nil then
                _____56DE_8C03(_____4E0A_4E0B_6587)
            end
            i = i + 1
        end
    end
    _____6E05_7406_6700_8FD1_7269_54C1_6280_80FD_4E0A_4E0B_6587()
end
local function _____5904_7406_7269_54C1_6280_80FD_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    if _____6280_80FDID == nil or _____6280_80FDID == 0 then
        return
    end
    _____7F13_5B58_6280_80FD_751F_6548_4E0A_4E0B_6587(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
end
local function _____5904_7406_4F7F_7528_7269_54C1_4E8B_4EF6()
    local _____65BD_6CD5_5355_4F4D = GetTriggerUnit()
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____7269_54C1 = GetManipulatedItem()
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    local _____65BD_6CD5_8005ID = _____83B7_53D6_65BD_6CD5_8005_7F13_5B58_952E(_____65BD_6CD5_5355_4F4D)
    if _____65BD_6CD5_8005ID == 0 then
        return
    end
    local _____5DF2_7F13_5B58_4E0A_4E0B_6587 = _____65BD_6CD5_8005_6280_80FD_4E0A_4E0B_6587_8868[_____65BD_6CD5_8005ID]
    __TS__Delete(_____65BD_6CD5_8005_6280_80FD_4E0A_4E0B_6587_8868, _____65BD_6CD5_8005ID)
    if _____5DF2_7F13_5B58_4E0A_4E0B_6587 == nil then
        return
    end
    if _____5DF2_7F13_5B58_4E0A_4E0B_6587["技能ID"] == nil or _____5DF2_7F13_5B58_4E0A_4E0B_6587["技能ID"] == 0 then
        return
    end
    _____5206_53D1_7269_54C1_6280_80FD_4E8B_4EF6_76D1_542C({
        ["施法单位"] = _____65BD_6CD5_5355_4F4D,
        ["物品"] = _____7269_54C1,
        ["技能ID"] = _____5DF2_7F13_5B58_4E0A_4E0B_6587["技能ID"],
        ["目标X"] = _____5DF2_7F13_5B58_4E0A_4E0B_6587["目标X"],
        ["目标Y"] = _____5DF2_7F13_5B58_4E0A_4E0B_6587["目标Y"],
        ["目标单位"] = _____5DF2_7F13_5B58_4E0A_4E0B_6587["目标单位"],
        ["目标可破坏物"] = _____5DF2_7F13_5B58_4E0A_4E0B_6587["目标可破坏物"]
    })
end
____exports["初始化物品技能事件中心"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____6280_80FD_4E8B_4EF6_4E2D_5FC3.registerSpellEffectListener(_____5904_7406_7269_54C1_6280_80FD_751F_6548)
    _____4F7F_7528_7269_54C1_89E6_53D1_5668 = CreateTrigger()
    _____73A9_5BB6_5355_4F4D_4E8B_4EF6_4E2D_5FC3.registerPlayerUnitEventForPlayerIds(_____4F7F_7528_7269_54C1_89E6_53D1_5668, ____exports["物品技能事件玩家范围"], EVENT_PLAYER_UNIT_USE_ITEM)
    TriggerAddAction(_____4F7F_7528_7269_54C1_89E6_53D1_5668, _____5904_7406_4F7F_7528_7269_54C1_4E8B_4EF6)
end
____exports["注册物品技能事件监听"] = function(_____56DE_8C03)
    if _____56DE_8C03 == nil then
        return
    end
    ____exports["初始化物品技能事件中心"]()
    if not _____5DF2_6CE8_518C_76D1_542C(_____56DE_8C03) then
        _____76D1_542C_5217_8868[#_____76D1_542C_5217_8868 + 1] = _____56DE_8C03
    end
end
____exports["取消注册物品技能事件监听"] = function(_____56DE_8C03)
    local _____7D22_5F15 = __TS__ArrayIndexOf(_____76D1_542C_5217_8868, _____56DE_8C03)
    if _____7D22_5F15 >= 0 then
        __TS__ArraySplice(_____76D1_542C_5217_8868, _____7D22_5F15, 1)
    end
end
____exports["获取最近一次物品技能ID"] = function()
    return _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587 == nil and 0 or _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587["技能ID"]
end
____exports["获取最近一次物品技能目标X"] = function()
    return _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587 == nil and 0 or _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587["目标X"]
end
____exports["获取最近一次物品技能目标Y"] = function()
    return _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587 == nil and 0 or _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587["目标Y"]
end
____exports["获取最近一次物品技能目标单位"] = function()
    local ____temp_0
    if _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587 == nil then
        ____temp_0 = nil
    else
        ____temp_0 = _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587["目标单位"]
    end
    return ____temp_0
end
____exports["获取最近一次物品技能目标点"] = function()
    if _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587 == nil then
        return nil
    end
    _____6E05_7406_6700_8FD1_76EE_6807_70B9()
    _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_76EE_6807_70B9 = Location(_____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587["目标X"], _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_4E0A_4E0B_6587["目标Y"])
    return _____6700_8FD1_4E00_6B21_7269_54C1_6280_80FD_76EE_6807_70B9
end
return ____exports
