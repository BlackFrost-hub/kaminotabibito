local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5355_4F4D_6709_6548_591A_6BB5, _____6062_590D_591A_6BB5_6280_80FD_58F3, _____5220_9664_591A_6BB5_6FC0_6D3B_8BB0_5F55, _____7ED3_675F_591A_6BB5_6280_80FD_58F3, _____591A_6BB5_6280_80FD_58F3_7A97_53E3_8D85_65F6, removeDelayedCallback, GetOwningPlayer, SetPlayerAbilityAvailable, UnitRemoveAbility, GetHandleIdSafe, _____591A_6BB5_6FC0_6D3B_8868
function _____5355_4F4D_6709_6548_591A_6BB5(unit)
    return unit ~= nil and unit ~= 0
end
function _____6062_590D_591A_6BB5_6280_80FD_58F3(_____63A7_5236_5668)
    if not _____5355_4F4D_6709_6548_591A_6BB5(_____63A7_5236_5668["单位"]) then
        return
    end
    local owner = GetOwningPlayer(_____63A7_5236_5668["单位"])
    do
        local i = 0
        while i < #_____63A7_5236_5668["阶段列表"] do
            UnitRemoveAbility(_____63A7_5236_5668["单位"], _____63A7_5236_5668["阶段列表"][i + 1]["技能ID"])
            if owner ~= nil and owner ~= 0 then
                SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["阶段列表"][i + 1]["技能ID"], false)
            end
            i = i + 1
        end
    end
    if owner ~= nil and owner ~= 0 then
        SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["一段技能ID"], true)
    end
end
function _____5220_9664_591A_6BB5_6FC0_6D3B_8BB0_5F55(_____63A7_5236_5668)
    if not _____5355_4F4D_6709_6548_591A_6BB5(_____63A7_5236_5668["单位"]) then
        return
    end
    local id = GetHandleIdSafe(_____63A7_5236_5668["单位"])
    local _____6FC0_6D3B = _____591A_6BB5_6FC0_6D3B_8868[id]
    if _____6FC0_6D3B ~= nil and _____6FC0_6D3B["控制器"] == _____63A7_5236_5668 then
        __TS__Delete(_____591A_6BB5_6FC0_6D3B_8868, id)
    end
end
function _____7ED3_675F_591A_6BB5_6280_80FD_58F3(_____63A7_5236_5668, _____53D6_6D88_8BA1_65F6)
    if _____63A7_5236_5668 == nil or _____63A7_5236_5668["已结束"] then
        return false
    end
    _____63A7_5236_5668["已结束"] = true
    if _____53D6_6D88_8BA1_65F6 and _____63A7_5236_5668["窗口回调ID"] ~= 0 then
        removeDelayedCallback(_____63A7_5236_5668["窗口回调ID"])
    end
    _____63A7_5236_5668["窗口回调ID"] = 0
    _____6062_590D_591A_6BB5_6280_80FD_58F3(_____63A7_5236_5668)
    _____63A7_5236_5668["当前阶段"] = -1
    _____5220_9664_591A_6BB5_6FC0_6D3B_8BB0_5F55(_____63A7_5236_5668)
    return true
end
function _____591A_6BB5_6280_80FD_58F3_7A97_53E3_8D85_65F6(variable)
    local _____56DE_8C03_53D8_91CF = variable
    if _____56DE_8C03_53D8_91CF == nil then
        return
    end
    local _____63A7_5236_5668 = _____56DE_8C03_53D8_91CF["控制器"]
    if _____63A7_5236_5668 == nil or _____63A7_5236_5668["已结束"] or _____56DE_8C03_53D8_91CF.token ~= _____63A7_5236_5668.token then
        return
    end
    if _____5355_4F4D_6709_6548_591A_6BB5(_____63A7_5236_5668["单位"]) then
        local _____6FC0_6D3B = _____591A_6BB5_6FC0_6D3B_8868[GetHandleIdSafe(_____63A7_5236_5668["单位"])]
        if _____6FC0_6D3B == nil or _____6FC0_6D3B["控制器"] ~= _____63A7_5236_5668 or _____6FC0_6D3B.token ~= _____56DE_8C03_53D8_91CF.token then
            return
        end
    end
    _____7ED3_675F_591A_6BB5_6280_80FD_58F3(_____63A7_5236_5668, false)
    if _____63A7_5236_5668["窗口超时回调"] ~= nil then
        _____63A7_5236_5668["窗口超时回调"](_____63A7_5236_5668)
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local _____6280_80FD_8BF4_660E_52A8_4F5C = require("平台扩展API动作")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
removeDelayedCallback = ____require_result_0.removeDelayedCallback
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
GetOwningPlayer = jass.GetOwningPlayer
SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local UnitAddAbility = jass.UnitAddAbility
UnitRemoveAbility = jass.UnitRemoveAbility
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
GetHandleIdSafe = jass.GetHandleId
____exports["通用二段技能壳ID"] = {Q = "ASQ2", W = "ASW2", E = "ASE2", R = "ASR2"}
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
local function _____6062_590D_6280_80FD_58F3(_____63A7_5236_5668)
    if not _____5355_4F4D_6709_6548(_____63A7_5236_5668["单位"]) then
        return
    end
    UnitRemoveAbility(_____63A7_5236_5668["单位"], _____63A7_5236_5668["二段技能ID"])
    local owner = GetOwningPlayer(_____63A7_5236_5668["单位"])
    if owner == nil or owner == 0 then
        return
    end
    SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["二段技能ID"], false)
    SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["一段技能ID"], true)
end
local function _____7ED3_675F_6280_80FD_58F3(_____63A7_5236_5668, _____53D6_6D88_8BA1_65F6)
    if _____63A7_5236_5668 == nil or _____63A7_5236_5668["已结束"] then
        return false
    end
    _____63A7_5236_5668["已结束"] = true
    if _____53D6_6D88_8BA1_65F6 and _____63A7_5236_5668["超时回调ID"] ~= 0 then
        removeDelayedCallback(_____63A7_5236_5668["超时回调ID"])
    end
    _____63A7_5236_5668["超时回调ID"] = 0
    _____6062_590D_6280_80FD_58F3(_____63A7_5236_5668)
    return true
end
local function _____9650_65F6_4E8C_6BB5_6280_80FD_58F3_8D85_65F6(variable)
    local _____63A7_5236_5668 = variable
    if not _____7ED3_675F_6280_80FD_58F3(_____63A7_5236_5668, false) or _____63A7_5236_5668 == nil then
        return
    end
    if _____63A7_5236_5668["超时回调"] ~= nil then
        _____63A7_5236_5668["超时回调"](_____63A7_5236_5668)
    end
end
____exports["创建限时二段技能壳"] = function(_____53C2_6570)
    if not _____5355_4F4D_6709_6548(_____53C2_6570["单位"]) or _____53C2_6570["一段技能ID"] == 0 or _____53C2_6570["二段技能ID"] == 0 or _____53C2_6570["持续秒"] <= 0 then
        return nil
    end
    local owner = GetOwningPlayer(_____53C2_6570["单位"])
    if owner == nil or owner == 0 then
        return nil
    end
    UnitRemoveAbility(_____53C2_6570["单位"], _____53C2_6570["二段技能ID"])
    SetPlayerAbilityAvailable(owner, _____53C2_6570["一段技能ID"], false)
    if not UnitAddAbility(_____53C2_6570["单位"], _____53C2_6570["二段技能ID"]) then
        SetPlayerAbilityAvailable(owner, _____53C2_6570["一段技能ID"], true)
        return nil
    end
    SetPlayerAbilityAvailable(owner, _____53C2_6570["二段技能ID"], true)
    SetPlayerAbilityAvailable(owner, _____53C2_6570["二段技能ID"], true)
    if _____53C2_6570["二段说明"] ~= nil and _____53C2_6570["二段说明"] ~= "" then
        _____6280_80FD_8BF4_660E_52A8_4F5C["技能_设置技能提示"](_____53C2_6570["单位"], _____53C2_6570["二段技能ID"], _____53C2_6570["名称"])
        _____6280_80FD_8BF4_660E_52A8_4F5C["技能_设置技能提示扩展"](_____53C2_6570["单位"], _____53C2_6570["二段技能ID"], _____53C2_6570["二段说明"])
        _____6280_80FD_8BF4_660E_52A8_4F5C["技能_设置刷新数据"](_____53C2_6570["单位"], _____53C2_6570["二段技能ID"])
    end
    local _____63A7_5236_5668 = {
        ["名称"] = _____53C2_6570["名称"],
        ["单位"] = _____53C2_6570["单位"],
        ["一段技能ID"] = _____53C2_6570["一段技能ID"],
        ["二段技能ID"] = _____53C2_6570["二段技能ID"],
        ["超时回调ID"] = 0,
        ["已结束"] = false,
        ["数据"] = _____53C2_6570["数据"],
        ["超时回调"] = _____53C2_6570["超时回调"]
    }
    _____63A7_5236_5668["超时回调ID"] = addDelayedCallback(_____53C2_6570["持续秒"] * 1000, _____9650_65F6_4E8C_6BB5_6280_80FD_58F3_8D85_65F6, _____63A7_5236_5668)
    return _____63A7_5236_5668
end
____exports["确认限时二段技能壳"] = function(_____63A7_5236_5668)
    return _____7ED3_675F_6280_80FD_58F3(_____63A7_5236_5668, true)
end
____exports["清理限时二段技能壳"] = function(_____63A7_5236_5668)
    return _____7ED3_675F_6280_80FD_58F3(_____63A7_5236_5668, true)
end
_____591A_6BB5_6FC0_6D3B_8868 = {}
local _____591A_6BB5token_81EA_589E = 0
local _____591A_6BB5_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____591A_6BB5_9636_6BB5_914D_7F6E_6709_6548(_____9636_6BB5)
    return _____9636_6BB5 ~= nil and _____9636_6BB5["技能ID"] ~= 0 and _____9636_6BB5["窗口秒"] > 0
end
local function _____5F00_542F_591A_6BB5_9636_6BB5_8BA1_65F6(_____63A7_5236_5668, _____9636_6BB5)
    _____591A_6BB5token_81EA_589E = _____591A_6BB5token_81EA_589E + 1
    local token = _____591A_6BB5token_81EA_589E
    _____63A7_5236_5668.token = token
    _____591A_6BB5_6FC0_6D3B_8868[GetHandleIdSafe(_____63A7_5236_5668["单位"])] = {token = token, ["控制器"] = _____63A7_5236_5668}
    local _____56DE_8C03_53D8_91CF = {["控制器"] = _____63A7_5236_5668, token = token}
    _____63A7_5236_5668["窗口回调ID"] = addDelayedCallback(_____9636_6BB5["窗口秒"] * 1000, _____591A_6BB5_6280_80FD_58F3_7A97_53E3_8D85_65F6, _____56DE_8C03_53D8_91CF)
end
--- 加装第 index 个阶段技能能力（隐藏一段、启阶段技能）
local function _____8FDB_5165_591A_6BB5_9636_6BB5(_____63A7_5236_5668, index)
    local _____9636_6BB5 = _____63A7_5236_5668["阶段列表"][index + 1]
    if _____9636_6BB5 == nil or _____9636_6BB5["技能ID"] == 0 then
        return false
    end
    local owner = GetOwningPlayer(_____63A7_5236_5668["单位"])
    if owner == nil or owner == 0 then
        return false
    end
    UnitRemoveAbility(_____63A7_5236_5668["单位"], _____9636_6BB5["技能ID"])
    SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["一段技能ID"], false)
    if not UnitAddAbility(_____63A7_5236_5668["单位"], _____9636_6BB5["技能ID"]) then
        SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["一段技能ID"], true)
        return false
    end
    SetPlayerAbilityAvailable(owner, _____9636_6BB5["技能ID"], true)
    _____63A7_5236_5668["当前阶段"] = index
    _____5F00_542F_591A_6BB5_9636_6BB5_8BA1_65F6(_____63A7_5236_5668, _____9636_6BB5)
    return true
end
local function _____8BFB_53D6_9636_6BB5_9B54_8017(_____63A7_5236_5668, _____9636_6BB5)
    local _____9B54_8017 = type(_____9636_6BB5["阶段魔耗"]) == "function" and _____9636_6BB5["阶段魔耗"](_____63A7_5236_5668["单位"], _____9636_6BB5["数据"]) or _____9636_6BB5["阶段魔耗"]
    return _____9B54_8017 ~= nil and _____9B54_8017 > 0 and _____9B54_8017 or 0
end
local function _____6263_9664_9636_6BB5_9B54_8017(_____63A7_5236_5668, _____9B54_8017)
    if not (_____9B54_8017 > 0) then
        return
    end
    local _____5F53_524D_9B54_6CD5 = GetUnitState(_____63A7_5236_5668["单位"], UNIT_STATE_MANA)
    SetUnitState(_____63A7_5236_5668["单位"], UNIT_STATE_MANA, _____5F53_524D_9B54_6CD5 - _____9B54_8017)
end
local function _____591A_6BB5_6280_80FD_58F3_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if not _____5355_4F4D_6709_6548_591A_6BB5(dyingUnit) then
        return
    end
    local _____6FC0_6D3B = _____591A_6BB5_6FC0_6D3B_8868[GetHandleIdSafe(dyingUnit)]
    if _____6FC0_6D3B ~= nil then
        _____7ED3_675F_591A_6BB5_6280_80FD_58F3(_____6FC0_6D3B["控制器"], true)
    end
end
--- 开启多段技能窗口：一段技能确认后加装阶段列表首个能力，窗口超时自动复位。
-- 每次开启独立 token；同单位重复开启会先清理旧壳（旧超时回调不再生效）。
____exports["开启多段技能窗口"] = function(_____53C2_6570)
    if not _____5355_4F4D_6709_6548_591A_6BB5(_____53C2_6570["单位"]) or _____53C2_6570["一段技能ID"] == 0 or _____53C2_6570["阶段列表"] == nil or #_____53C2_6570["阶段列表"] <= 0 then
        return nil
    end
    do
        local i = 0
        while i < #_____53C2_6570["阶段列表"] do
            if not _____591A_6BB5_9636_6BB5_914D_7F6E_6709_6548(_____53C2_6570["阶段列表"][i + 1]) then
                return nil
            end
            i = i + 1
        end
    end
    local _____65E7_6FC0_6D3B = _____591A_6BB5_6FC0_6D3B_8868[GetHandleIdSafe(_____53C2_6570["单位"])]
    if _____65E7_6FC0_6D3B ~= nil then
        _____7ED3_675F_591A_6BB5_6280_80FD_58F3(_____65E7_6FC0_6D3B["控制器"], true)
    end
    local _____63A7_5236_5668 = {
        ["名称"] = _____53C2_6570["名称"],
        ["单位"] = _____53C2_6570["单位"],
        ["一段技能ID"] = _____53C2_6570["一段技能ID"],
        ["阶段列表"] = _____53C2_6570["阶段列表"],
        ["当前阶段"] = -1,
        token = 0,
        ["窗口回调ID"] = 0,
        ["已结束"] = false,
        ["数据"] = _____53C2_6570["数据"],
        ["窗口超时回调"] = _____53C2_6570["窗口超时回调"]
    }
    if not _____8FDB_5165_591A_6BB5_9636_6BB5(_____63A7_5236_5668, 0) then
        _____63A7_5236_5668["已结束"] = true
        _____6062_590D_591A_6BB5_6280_80FD_58F3(_____63A7_5236_5668)
        return nil
    end
    if not _____591A_6BB5_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____591A_6BB5_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(_____591A_6BB5_6280_80FD_58F3_6B7B_4EA1_6E05_7406)
    end
    return _____63A7_5236_5668
end
--- 确认当前阶段：扣魔（阶段魔耗）后进入下一阶段；已是最后阶段则结束整个多段壳。@returns true=成功确认；false=已结束/无效/加装下一阶段失败
____exports["确认多段技能阶段"] = function(_____63A7_5236_5668)
    if _____63A7_5236_5668 == nil or _____63A7_5236_5668["已结束"] then
        return false
    end
    if not _____5355_4F4D_6709_6548_591A_6BB5(_____63A7_5236_5668["单位"]) then
        return false
    end
    local _____9636_6BB5 = _____63A7_5236_5668["阶段列表"][_____63A7_5236_5668["当前阶段"] + 1]
    if not _____591A_6BB5_9636_6BB5_914D_7F6E_6709_6548(_____9636_6BB5) then
        return false
    end
    local _____9636_6BB5_9B54_8017 = _____8BFB_53D6_9636_6BB5_9B54_8017(_____63A7_5236_5668, _____9636_6BB5)
    if _____9636_6BB5_9B54_8017 > 0 and GetUnitState(_____63A7_5236_5668["单位"], UNIT_STATE_MANA) < _____9636_6BB5_9B54_8017 then
        return false
    end
    local _____4E0B_4E00_9636_6BB5 = _____63A7_5236_5668["当前阶段"] + 1
    local owner = GetOwningPlayer(_____63A7_5236_5668["单位"])
    if owner == nil or owner == 0 then
        return false
    end
    local _____4E0B_4E00_9636_6BB5_914D_7F6E = _____63A7_5236_5668["阶段列表"][_____4E0B_4E00_9636_6BB5 + 1]
    if _____4E0B_4E00_9636_6BB5 < #_____63A7_5236_5668["阶段列表"] then
        if not _____591A_6BB5_9636_6BB5_914D_7F6E_6709_6548(_____4E0B_4E00_9636_6BB5_914D_7F6E) then
            return false
        end
        UnitRemoveAbility(_____63A7_5236_5668["单位"], _____4E0B_4E00_9636_6BB5_914D_7F6E["技能ID"])
        if not UnitAddAbility(_____63A7_5236_5668["单位"], _____4E0B_4E00_9636_6BB5_914D_7F6E["技能ID"]) then
            return false
        end
    end
    _____6263_9664_9636_6BB5_9B54_8017(_____63A7_5236_5668, _____9636_6BB5_9B54_8017)
    UnitRemoveAbility(_____63A7_5236_5668["单位"], _____9636_6BB5["技能ID"])
    SetPlayerAbilityAvailable(owner, _____9636_6BB5["技能ID"], false)
    SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["一段技能ID"], true)
    if _____63A7_5236_5668["窗口回调ID"] ~= 0 then
        removeDelayedCallback(_____63A7_5236_5668["窗口回调ID"])
    end
    _____63A7_5236_5668["窗口回调ID"] = 0
    if _____4E0B_4E00_9636_6BB5 >= #_____63A7_5236_5668["阶段列表"] then
        return _____7ED3_675F_591A_6BB5_6280_80FD_58F3(_____63A7_5236_5668, false)
    end
    SetPlayerAbilityAvailable(owner, _____4E0B_4E00_9636_6BB5_914D_7F6E["技能ID"], true)
    SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["一段技能ID"], false)
    _____63A7_5236_5668["当前阶段"] = _____4E0B_4E00_9636_6BB5
    _____5F00_542F_591A_6BB5_9636_6BB5_8BA1_65F6(_____63A7_5236_5668, _____4E0B_4E00_9636_6BB5_914D_7F6E)
    return true
end
--- 主动清理多段技能壳（中断/收尾）：取消计时、移除全部阶段能力、恢复一段
____exports["清理多段技能壳"] = function(_____63A7_5236_5668)
    return _____7ED3_675F_591A_6BB5_6280_80FD_58F3(_____63A7_5236_5668, true)
end
--- 读取多段壳当前阶段索引（-1=未进入）
____exports["读取多段当前阶段"] = function(_____63A7_5236_5668)
    return _____63A7_5236_5668 == nil and -1 or _____63A7_5236_5668["当前阶段"]
end
return ____exports
