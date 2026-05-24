local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local jass = require("jass.common")
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态")
local _____662F_5426_9ED1_5929 = ____require_result_1["是否黑天"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8F6C_56DB_4F4DID = ____require_result_2["转四位ID"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.05．异界Boss.02．赫萝.00．配置")
local _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_3["赫萝单位技能配置"]
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local IsUnitType = jass.IsUnitType
local SetUnitState = jass.SetUnitState
local SetUnitMoveSpeed = jass.SetUnitMoveSpeed
local ConvertUnitState = jass.ConvertUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____8D6B_841D_5355_4F4D_7C7B_578BID = _____8F6C_56DB_4F4DID(_____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____8D6B_841D_663C_591C_88AB_52A8_5355_4F4D_8868 = {}
local _____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID = 0
local function _____83B7_53D6_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____5E94_7528_8D6B_841D_663C_591C_72B6_6001(unit)
    if unit == nil or unit == 0 then
        return
    end
    if IsUnitType(unit, UNIT_TYPE_DEAD) then
        return
    end
    if GetUnitTypeId(unit) ~= _____8D6B_841D_5355_4F4D_7C7B_578BID then
        return
    end
    if _____662F_5426_9ED1_5929() then
        SetUnitState(
            unit,
            ConvertUnitState(37),
            _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["黑夜单位状态值"]
        )
        SetUnitMoveSpeed(unit, _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["黑夜移速"])
    else
        SetUnitState(
            unit,
            ConvertUnitState(37),
            _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["白天单位状态值"]
        )
        SetUnitMoveSpeed(unit, _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["白天移速"])
    end
end
local function _____5904_7406_8D6B_841D_663C_591C_88AB_52A8Tick()
    local keys = __TS__ObjectKeys(_____8D6B_841D_663C_591C_88AB_52A8_5355_4F4D_8868)
    do
        local i = 0
        while i < #keys do
            do
                local handleId = __TS__Number(keys[i + 1]) or 0
                if handleId <= 0 then
                    goto __continue12
                end
                local unit = _____8D6B_841D_663C_591C_88AB_52A8_5355_4F4D_8868[handleId]
                if unit == nil or unit == 0 or IsUnitType(unit, UNIT_TYPE_DEAD) then
                    __TS__Delete(_____8D6B_841D_663C_591C_88AB_52A8_5355_4F4D_8868, handleId)
                    goto __continue12
                end
                _____5E94_7528_8D6B_841D_663C_591C_72B6_6001(unit)
            end
            ::__continue12::
            i = i + 1
        end
    end
    if #__TS__ObjectKeys(_____8D6B_841D_663C_591C_88AB_52A8_5355_4F4D_8868) == 0 and _____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID ~= 0 then
        removePeriodicCallback(_____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID)
        _____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID = 0
    end
end
local function _____786E_4FDD_8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668()
    if _____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID ~= 0 then
        return
    end
    _____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID = addPeriodicCallback(_____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["检查间隔Ms"], _____5904_7406_8D6B_841D_663C_591C_88AB_52A8Tick)
end
____exports["启动赫萝昼夜被动"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    if GetUnitTypeId(unit) ~= _____8D6B_841D_5355_4F4D_7C7B_578BID then
        return
    end
    local handleId = _____83B7_53D6_53E5_67C4ID(unit)
    if handleId == 0 then
        return
    end
    _____8D6B_841D_663C_591C_88AB_52A8_5355_4F4D_8868[handleId] = unit
    _____786E_4FDD_8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668()
    _____5E94_7528_8D6B_841D_663C_591C_72B6_6001(unit)
end
____exports["停止赫萝昼夜被动"] = function(unit)
    local handleId = _____83B7_53D6_53E5_67C4ID(unit)
    if handleId == 0 then
        return
    end
    __TS__Delete(_____8D6B_841D_663C_591C_88AB_52A8_5355_4F4D_8868, handleId)
    if #__TS__ObjectKeys(_____8D6B_841D_663C_591C_88AB_52A8_5355_4F4D_8868) == 0 and _____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID ~= 0 then
        removePeriodicCallback(_____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID)
        _____8D6B_841D_663C_591C_88AB_52A8_5B9A_65F6_5668ID = 0
    end
end
return ____exports
