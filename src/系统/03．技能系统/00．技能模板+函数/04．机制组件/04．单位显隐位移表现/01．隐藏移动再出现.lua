local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5C1D_8BD5_505C_6B62_9690_85CF_79FB_52A8_9A71_52A8, ____on_9690_85CF_79FB_52A8_518D_51FA_73B0Tick, ShowUnit, IsUnitType, UNIT_TYPE_DEAD, removePeriodicCallback, getServerTime, _____9690_85CF_79FB_52A8_9A71_52A8ID, _____9690_85CF_79FB_52A8_4EFB_52A1_8868
function _____5C1D_8BD5_505C_6B62_9690_85CF_79FB_52A8_9A71_52A8()
    for key in pairs(_____9690_85CF_79FB_52A8_4EFB_52A1_8868) do
        if _____9690_85CF_79FB_52A8_4EFB_52A1_8868[key] ~= nil then
            return
        end
    end
    if _____9690_85CF_79FB_52A8_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____9690_85CF_79FB_52A8_9A71_52A8ID)
        _____9690_85CF_79FB_52A8_9A71_52A8ID = 0
    end
end
function ____on_9690_85CF_79FB_52A8_518D_51FA_73B0Tick()
    local now = getServerTime()
    for key in pairs(_____9690_85CF_79FB_52A8_4EFB_52A1_8868) do
        do
            local _____4EFB_52A1 = _____9690_85CF_79FB_52A8_4EFB_52A1_8868[key]
            if _____4EFB_52A1 == nil or now < _____4EFB_52A1["到期时间Ms"] then
                goto __continue10
            end
            local _____5355_4F4D = _____4EFB_52A1["单位"]
            __TS__Delete(_____9690_85CF_79FB_52A8_4EFB_52A1_8868, key)
            if _____5355_4F4D == nil or _____5355_4F4D == 0 or IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) then
                if _____4EFB_52A1["on取消"] ~= nil then
                    _____4EFB_52A1["on取消"](_____5355_4F4D)
                end
                goto __continue10
            end
            ShowUnit(_____5355_4F4D, true)
            if _____4EFB_52A1["on出现"] ~= nil then
                _____4EFB_52A1["on出现"](_____5355_4F4D)
            end
        end
        ::__continue10::
    end
    _____5C1D_8BD5_505C_6B62_9690_85CF_79FB_52A8_9A71_52A8()
end
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
ShowUnit = jass.ShowUnit
IsUnitType = jass.IsUnitType
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
_____9690_85CF_79FB_52A8_9A71_52A8ID = 0
_____9690_85CF_79FB_52A8_4EFB_52A1_8868 = {}
local function _____786E_4FDD_9690_85CF_79FB_52A8_9A71_52A8()
    if _____9690_85CF_79FB_52A8_9A71_52A8ID ~= 0 then
        return
    end
    _____9690_85CF_79FB_52A8_9A71_52A8ID = addPeriodicCallback(50, ____on_9690_85CF_79FB_52A8_518D_51FA_73B0Tick)
end
____exports["隐藏移动再出现"] = function(_____53C2_6570)
    local _____5355_4F4D = _____53C2_6570["单位"]
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) then
        return
    end
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    if _____9690_85CF_79FB_52A8_4EFB_52A1_8868[_____5355_4F4DID] ~= nil then
        local _____65E7_4EFB_52A1 = _____9690_85CF_79FB_52A8_4EFB_52A1_8868[_____5355_4F4DID]
        __TS__Delete(_____9690_85CF_79FB_52A8_4EFB_52A1_8868, _____5355_4F4DID)
        ShowUnit(_____5355_4F4D, true)
        if _____65E7_4EFB_52A1["on取消"] ~= nil then
            _____65E7_4EFB_52A1["on取消"](_____5355_4F4D)
        end
    end
    ShowUnit(_____5355_4F4D, false)
    SetUnitX(_____5355_4F4D, _____53C2_6570["目标X"])
    SetUnitY(_____5355_4F4D, _____53C2_6570["目标Y"])
    if _____53C2_6570["on隐藏"] ~= nil then
        _____53C2_6570["on隐藏"](_____5355_4F4D)
    end
    _____9690_85CF_79FB_52A8_4EFB_52A1_8868[_____5355_4F4DID] = {
        ["单位"] = _____5355_4F4D,
        ["到期时间Ms"] = getServerTime() + _____53C2_6570["隐藏时间秒"] * 1000,
        ["on出现"] = _____53C2_6570["on出现"],
        ["on取消"] = _____53C2_6570["on取消"]
    }
    _____786E_4FDD_9690_85CF_79FB_52A8_9A71_52A8()
end
____exports["取消隐藏移动再出现"] = function(_____5355_4F4D, _____662F_5426_663E_793A)
    if _____662F_5426_663E_793A == nil then
        _____662F_5426_663E_793A = true
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    local _____4EFB_52A1 = _____9690_85CF_79FB_52A8_4EFB_52A1_8868[_____5355_4F4DID]
    if _____4EFB_52A1 == nil then
        return
    end
    __TS__Delete(_____9690_85CF_79FB_52A8_4EFB_52A1_8868, _____5355_4F4DID)
    if _____662F_5426_663E_793A then
        ShowUnit(_____5355_4F4D, true)
    end
    if _____4EFB_52A1["on取消"] ~= nil then
        _____4EFB_52A1["on取消"](_____5355_4F4D)
    end
    _____5C1D_8BD5_505C_6B62_9690_85CF_79FB_52A8_9A71_52A8()
end
return ____exports
