local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local withTimer = ____require_result_0.withTimer
local stopTimer = ____require_result_0.stopTimer
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local AddUnitAnimationProperties = jass.AddUnitAnimationProperties
local UNIT_ALIVE_LIFE = 0.405
local _____52A8_753B_5B88_62A4_5B9E_4F8B_8868 = {}
local _____4E0B_4E00_4E2A_52A8_753B_5B88_62A4ID = 1
local _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = false
local function _____5355_4F4D_5B58_6D3B(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if GetUnitTypeId(unit) == 0 then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_DEAD) then
        return false
    end
    return GetUnitState(unit, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
local function _____64AD_653E_5B88_62A4_52A8_753B(_____5B9E_4F8B)
    local _____53C2_6570 = _____5B9E_4F8B["参数"]
    if _____53C2_6570["附加动画属性"] ~= nil and _____53C2_6570["附加动画属性"] ~= "" and type(AddUnitAnimationProperties) == "function" then
        AddUnitAnimationProperties(_____5B9E_4F8B["单位"], _____53C2_6570["附加动画属性"], true)
    end
    if _____53C2_6570["动画编号"] ~= nil then
        SetUnitAnimationByIndex(_____5B9E_4F8B["单位"], _____53C2_6570["动画编号"])
        return
    end
    if _____53C2_6570["动画名"] ~= nil and _____53C2_6570["动画名"] ~= "" then
        SetUnitAnimation(_____5B9E_4F8B["单位"], _____53C2_6570["动画名"])
    end
end
local function _____505C_6B62_5B9E_4F8B(_____5B9E_4F8B)
    if _____5B9E_4F8B["已停止"] then
        return
    end
    _____5B9E_4F8B["已停止"] = true
    stopTimer(_____5B9E_4F8B["计时器"])
    __TS__Delete(_____52A8_753B_5B88_62A4_5B9E_4F8B_8868, _____5B9E_4F8B.ID)
end
local function ____on_52A8_753B_5B88_62A4Tick(_____5B9E_4F8B)
    if _____5B9E_4F8B["已停止"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
        _____505C_6B62_5B9E_4F8B(_____5B9E_4F8B)
        return
    end
    _____64AD_653E_5B88_62A4_52A8_753B(_____5B9E_4F8B)
end
local function ____on_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____6B7B_4EA1_5355_4F4DID = GetHandleId(dyingUnit)
    for key in pairs(_____52A8_753B_5B88_62A4_5B9E_4F8B_8868) do
        do
            local _____5B9E_4F8B = _____52A8_753B_5B88_62A4_5B9E_4F8B_8868[key]
            if _____5B9E_4F8B == nil or _____5B9E_4F8B["已停止"] then
                goto __continue16
            end
            if GetHandleId(_____5B9E_4F8B["单位"]) == _____6B7B_4EA1_5355_4F4DID then
                _____505C_6B62_5B9E_4F8B(_____5B9E_4F8B)
            end
        end
        ::__continue16::
    end
end
local function _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_6B7B_4EA1_76D1_542C = true
    registerDeathListener(____on_5355_4F4D_6B7B_4EA1)
end
____exports["创建单位动画守护"] = function(_____53C2_6570)
    if not _____5355_4F4D_5B58_6D3B(_____53C2_6570["单位"]) then
        return nil
    end
    if _____53C2_6570["动画编号"] == nil and (_____53C2_6570["动画名"] == nil or _____53C2_6570["动画名"] == "") then
        return nil
    end
    if _____53C2_6570["死亡时清理"] ~= false then
        _____786E_4FDD_6B7B_4EA1_76D1_542C()
    end
    local ____4E0B_4E00_4E2A_52A8_753B_5B88_62A4ID_2 = _____4E0B_4E00_4E2A_52A8_753B_5B88_62A4ID
    _____4E0B_4E00_4E2A_52A8_753B_5B88_62A4ID = ____4E0B_4E00_4E2A_52A8_753B_5B88_62A4ID_2 + 1
    local ID = ____4E0B_4E00_4E2A_52A8_753B_5B88_62A4ID_2
    local _____95F4_9694_79D2 = _____53C2_6570["间隔秒"] ~= nil and _____53C2_6570["间隔秒"] > 0 and _____53C2_6570["间隔秒"] or 0.5
    local _____5B9E_4F8B = {
        ID = ID,
        ["单位"] = _____53C2_6570["单位"],
        ["计时器"] = nil,
        ["参数"] = _____53C2_6570,
        ["已停止"] = false
    }
    _____52A8_753B_5B88_62A4_5B9E_4F8B_8868[ID] = _____5B9E_4F8B
    if _____53C2_6570["立即播放"] ~= false then
        _____64AD_653E_5B88_62A4_52A8_753B(_____5B9E_4F8B)
    end
    _____5B9E_4F8B["计时器"] = withTimer(
        _____95F4_9694_79D2,
        function() return ____on_52A8_753B_5B88_62A4Tick(_____5B9E_4F8B) end,
        true,
        _____53C2_6570["调试名"] or "单位动画守护"
    )
    return {ID = ID, ["单位"] = _____53C2_6570["单位"]}
end
____exports["停止单位动画守护"] = function(_____53E5_67C4)
    if _____53E5_67C4 == nil then
        return
    end
    local ID = type(_____53E5_67C4) == "number" and _____53E5_67C4 or _____53E5_67C4.ID
    local _____5B9E_4F8B = _____52A8_753B_5B88_62A4_5B9E_4F8B_8868[ID]
    if _____5B9E_4F8B == nil then
        return
    end
    _____505C_6B62_5B9E_4F8B(_____5B9E_4F8B)
end
return ____exports
