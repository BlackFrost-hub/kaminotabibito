local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
local hid, _____751F_6210_6682_505C_6765_6E90_952E, _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15, RMaxBJ, getServerTime, GetHandleId, _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868, _____786C_76F4_5230_671F_4EFB_52A1_5217_8868
function hid(h)
    return GetHandleId(h) or 0
end
function _____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____6765_6E90)
    return (tostring(_____5355_4F4DID) .. ":") .. _____6765_6E90
end
____exports["获取单位暂停来源计数"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return 0
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return 0
    end
    return _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____6765_6E90)] or 0
end
function _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID)
    do
        local i = 0
        while i < #_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 do
            if _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[i + 1]["单位ID"] == _____5355_4F4DID then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
--- 获取单位剩余暂停时间（秒）。
function ____exports.GS_LoadSuspend(u)
    if u == nil or u == 0 then
        return 0
    end
    local uid = hid(u)
    if uid == 0 then
        return 0
    end
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15(uid)
    if _____4EFB_52A1_7D22_5F15 < 0 then
        return 0
    end
    return RMaxBJ(
        0,
        _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[_____4EFB_52A1_7D22_5F15 + 1]["到期时间毫秒"] - getServerTime()
    ) * 0.001
end
--- Star扩展库 - 硬直/暂停系统
-- 
-- 来源于 SUSPEND.j，提供单位暂停控制功能。
-- 通过 EXPauseUnit(japi) 暂停单位，中心计时器驱动到期后自动恢复。
-- 支持暂停时间累加、减少、取最大值等操作。
-- 
-- 公开接口：
--   GS_Suspend(u, time)          - 暂停单位一段时间
--   GS_IsUnitSuspending(u)       - 检查单位是否处于暂停状态
--   GS_LoadSuspend(u)            - 获取单位剩余暂停时间
--   GS_UnitSuspend(u, i, r)      - 修改暂停时间（0=增加，1=减少，2=取最大值）
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
RMaxBJ = ____require_result_0.RMaxBJ
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
getServerTime = ____require_result_1.getServerTime
local japi = nil
do
    local function ____catch(_e)
        japi = nil
    end
    local ____try, ____hasReturned = pcall(function()
        japi = require("jass.japi")
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
end
local PauseUnit = jass.PauseUnit
GetHandleId = jass.GetHandleId
local EXPauseUnit = japi ~= nil and type(japi.EXPauseUnit) == "function" and japi.EXPauseUnit or nil
local _____5355_4F4D_6682_505C_5360_7528_603B_8868 = {}
_____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868 = {}
local _____5355_4F4D_6682_505C_5360_7528_5355_4F4D_8868 = {}
local _____5355_4F4D_6682_505C_6765_6E90_5217_8868_8868 = {}
local _____4EFB_610F_5355_4F4D_88AB_6682_505C_76D1_542C_5217_8868 = {}
local _____4EFB_610F_5355_4F4D_53D6_6D88_6682_505C_76D1_542C_5217_8868 = {}
local _____5355_4F4D_6682_505C_5360_7528_53D8_5316_76D1_542C_5217_8868 = {}
local function _____6CE8_518C_6682_505C_4E8B_4EF6_76D1_542C(list, cb)
    if cb == nil then
        return
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1] == cb then
                return
            end
            i = i + 1
        end
    end
    list[#list + 1] = cb
end
local function _____6CE8_518C_6682_505C_5360_7528_53D8_5316_76D1_542C(cb)
    if cb == nil then
        return
    end
    do
        local i = 0
        while i < #_____5355_4F4D_6682_505C_5360_7528_53D8_5316_76D1_542C_5217_8868 do
            if _____5355_4F4D_6682_505C_5360_7528_53D8_5316_76D1_542C_5217_8868[i + 1] == cb then
                return
            end
            i = i + 1
        end
    end
    _____5355_4F4D_6682_505C_5360_7528_53D8_5316_76D1_542C_5217_8868[#_____5355_4F4D_6682_505C_5360_7528_53D8_5316_76D1_542C_5217_8868 + 1] = cb
end
local function _____901A_77E5_6682_505C_4E8B_4EF6(list, event)
    do
        local i = 0
        while i < #list do
            list[i + 1](event)
            i = i + 1
        end
    end
end
local function _____901A_77E5_6682_505C_5360_7528_53D8_5316(event)
    do
        local i = 0
        while i < #_____5355_4F4D_6682_505C_5360_7528_53D8_5316_76D1_542C_5217_8868 do
            _____5355_4F4D_6682_505C_5360_7528_53D8_5316_76D1_542C_5217_8868[i + 1](event)
            i = i + 1
        end
    end
end
local function _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, _____662F_5426_6682_505C)
    if u == nil or u == 0 then
        return
    end
    if EXPauseUnit ~= nil then
        EXPauseUnit(u, _____662F_5426_6682_505C)
        return
    end
    PauseUnit(u, _____662F_5426_6682_505C)
end
local function _____52A0_5165_5355_4F4D_6682_505C_6765_6E90(_____5355_4F4DID, _____6765_6E90)
    local list = _____5355_4F4D_6682_505C_6765_6E90_5217_8868_8868[_____5355_4F4DID]
    if list == nil then
        list = {}
        _____5355_4F4D_6682_505C_6765_6E90_5217_8868_8868[_____5355_4F4DID] = list
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1] == _____6765_6E90 then
                return
            end
            i = i + 1
        end
    end
    list[#list + 1] = _____6765_6E90
end
local function _____79FB_9664_5355_4F4D_6682_505C_6765_6E90(_____5355_4F4DID, _____6765_6E90)
    local list = _____5355_4F4D_6682_505C_6765_6E90_5217_8868_8868[_____5355_4F4DID]
    if list == nil then
        return
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1] == _____6765_6E90 then
                __TS__ArraySplice(list, i, 1)
                break
            end
            i = i + 1
        end
    end
    if #list <= 0 then
        __TS__Delete(_____5355_4F4D_6682_505C_6765_6E90_5217_8868_8868, _____5355_4F4DID)
    end
end
local function _____590D_5236_5355_4F4D_6682_505C_6765_6E90_5217_8868(_____5355_4F4DID)
    local list = _____5355_4F4D_6682_505C_6765_6E90_5217_8868_8868[_____5355_4F4DID]
    local out = {}
    if list == nil then
        return out
    end
    do
        local i = 0
        while i < #list do
            out[#out + 1] = list[i + 1]
            i = i + 1
        end
    end
    return out
end
local _____6682_505C_5360_7528_6821_6B63_9A71_52A8_5DF2_6CE8_518C = false
local function _____6E05_7406_5355_4F4D_6682_505C_6765_6E90_5B9A_65F6_4EFB_52A1(______5355_4F4DID, ______6765_6E90)
end
local function _____6E05_7406_5355_4F4D_786C_76F4_5230_671F_4EFB_52A1(______5355_4F4DID)
end
local function ____on_6682_505C_5360_7528_6821_6B63_9A71_52A8()
    for key in pairs(_____5355_4F4D_6682_505C_5360_7528_603B_8868) do
        do
            local _____5355_4F4DID = __TS__ParseInt(key, 10)
            if __TS__NumberIsNaN(__TS__Number(_____5355_4F4DID)) then
                goto __continue43
            end
            local _____603B_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0
            if _____603B_8BA1_6570 <= 0 then
                goto __continue43
            end
            local u = _____5355_4F4D_6682_505C_5360_7528_5355_4F4D_8868[_____5355_4F4DID]
            if u ~= nil and u ~= 0 then
                _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, true)
            end
        end
        ::__continue43::
    end
end
local function _____786E_4FDD_6682_505C_5360_7528_6821_6B63_9A71_52A8()
    if _____6682_505C_5360_7528_6821_6B63_9A71_52A8_5DF2_6CE8_518C then
        return
    end
    _____6682_505C_5360_7528_6821_6B63_9A71_52A8_5DF2_6CE8_518C = true
    addPeriodicCallback(250, ____on_6682_505C_5360_7528_6821_6B63_9A71_52A8)
end
____exports["申请单位暂停占用"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    _____5355_4F4D_6682_505C_5360_7528_5355_4F4D_8868[_____5355_4F4DID] = u
    local _____6765_6E90_952E = _____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____6765_6E90)
    local _____539F_6765_6E90_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____6765_6E90_952E] or 0
    local _____65B0_6765_6E90_8BA1_6570 = _____539F_6765_6E90_8BA1_6570 + 1
    _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____6765_6E90_952E] = _____65B0_6765_6E90_8BA1_6570
    if _____539F_6765_6E90_8BA1_6570 > 0 then
        _____901A_77E5_6682_505C_5360_7528_53D8_5316({
            ["单位"] = u,
            ["单位ID"] = _____5355_4F4DID,
            ["来源"] = _____6765_6E90,
            ["来源计数"] = _____65B0_6765_6E90_8BA1_6570,
            ["总计数"] = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0,
            ["操作"] = "申请"
        })
        _____786E_4FDD_6682_505C_5360_7528_6821_6B63_9A71_52A8()
        return true
    end
    _____52A0_5165_5355_4F4D_6682_505C_6765_6E90(_____5355_4F4DID, _____6765_6E90)
    local _____539F_603B_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0
    local _____65B0_603B_8BA1_6570 = _____539F_603B_8BA1_6570 + 1
    _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] = _____65B0_603B_8BA1_6570
    _____901A_77E5_6682_505C_5360_7528_53D8_5316({
        ["单位"] = u,
        ["单位ID"] = _____5355_4F4DID,
        ["来源"] = _____6765_6E90,
        ["来源计数"] = _____65B0_6765_6E90_8BA1_6570,
        ["总计数"] = _____65B0_603B_8BA1_6570,
        ["操作"] = "申请"
    })
    if _____539F_603B_8BA1_6570 <= 0 then
        _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, true)
        _____901A_77E5_6682_505C_4E8B_4EF6(_____4EFB_610F_5355_4F4D_88AB_6682_505C_76D1_542C_5217_8868, {
            ["单位"] = u,
            ["单位ID"] = _____5355_4F4DID,
            ["来源"] = _____6765_6E90,
            ["来源计数"] = _____65B0_6765_6E90_8BA1_6570,
            ["总计数"] = _____65B0_603B_8BA1_6570
        })
    end
    _____786E_4FDD_6682_505C_5360_7528_6821_6B63_9A71_52A8()
    return true
end
____exports["释放单位暂停占用"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____6765_6E90_952E = _____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____6765_6E90)
    local _____539F_6765_6E90_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____6765_6E90_952E] or 0
    if _____539F_6765_6E90_8BA1_6570 <= 0 then
        return false
    end
    local _____65B0_6765_6E90_8BA1_6570 = _____539F_6765_6E90_8BA1_6570 - 1
    if _____539F_6765_6E90_8BA1_6570 <= 1 then
        __TS__Delete(_____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868, _____6765_6E90_952E)
        _____65B0_6765_6E90_8BA1_6570 = 0
        _____79FB_9664_5355_4F4D_6682_505C_6765_6E90(_____5355_4F4DID, _____6765_6E90)
    else
        _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____6765_6E90_952E] = _____65B0_6765_6E90_8BA1_6570
        _____901A_77E5_6682_505C_5360_7528_53D8_5316({
            ["单位"] = u,
            ["单位ID"] = _____5355_4F4DID,
            ["来源"] = _____6765_6E90,
            ["来源计数"] = _____65B0_6765_6E90_8BA1_6570,
            ["总计数"] = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0,
            ["操作"] = "释放"
        })
        return true
    end
    local _____539F_603B_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0
    local _____65B0_603B_8BA1_6570 = _____539F_603B_8BA1_6570
    if _____539F_603B_8BA1_6570 <= 1 then
        _____65B0_603B_8BA1_6570 = 0
        __TS__Delete(_____5355_4F4D_6682_505C_5360_7528_603B_8868, _____5355_4F4DID)
        _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, false)
        _____901A_77E5_6682_505C_5360_7528_53D8_5316({
            ["单位"] = u,
            ["单位ID"] = _____5355_4F4DID,
            ["来源"] = _____6765_6E90,
            ["来源计数"] = _____65B0_6765_6E90_8BA1_6570,
            ["总计数"] = _____65B0_603B_8BA1_6570,
            ["操作"] = "释放"
        })
        _____901A_77E5_6682_505C_4E8B_4EF6(_____4EFB_610F_5355_4F4D_53D6_6D88_6682_505C_76D1_542C_5217_8868, {
            ["单位"] = u,
            ["单位ID"] = _____5355_4F4DID,
            ["来源"] = _____6765_6E90,
            ["来源计数"] = _____65B0_6765_6E90_8BA1_6570,
            ["总计数"] = _____65B0_603B_8BA1_6570
        })
        __TS__Delete(_____5355_4F4D_6682_505C_5360_7528_5355_4F4D_8868, _____5355_4F4DID)
        __TS__Delete(_____5355_4F4D_6682_505C_6765_6E90_5217_8868_8868, _____5355_4F4DID)
    else
        _____65B0_603B_8BA1_6570 = _____539F_603B_8BA1_6570 - 1
        _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] = _____65B0_603B_8BA1_6570
        _____901A_77E5_6682_505C_5360_7528_53D8_5316({
            ["单位"] = u,
            ["单位ID"] = _____5355_4F4DID,
            ["来源"] = _____6765_6E90,
            ["来源计数"] = _____65B0_6765_6E90_8BA1_6570,
            ["总计数"] = _____65B0_603B_8BA1_6570,
            ["操作"] = "释放"
        })
    end
    return true
end
____exports["释放单位暂停来源全部"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    _____6E05_7406_5355_4F4D_6682_505C_6765_6E90_5B9A_65F6_4EFB_52A1(_____5355_4F4DID, _____6765_6E90)
    if _____6765_6E90 == "GS_Suspend" then
        _____6E05_7406_5355_4F4D_786C_76F4_5230_671F_4EFB_52A1(_____5355_4F4DID)
    end
    local changed = false
    while ____exports["获取单位暂停来源计数"](u, _____6765_6E90) > 0 do
        if not ____exports["释放单位暂停占用"](u, _____6765_6E90) then
            break
        end
        changed = true
    end
    return changed
end
____exports["申请单位暂停独立占用"] = function(u, _____6765_6E90)
    if ____exports["获取单位暂停来源计数"](u, _____6765_6E90) > 0 then
        return true
    end
    return ____exports["申请单位暂停占用"](u, _____6765_6E90)
end
____exports["设置单位暂停独立占用"] = function(u, _____6765_6E90, _____662F_5426_6682_505C)
    local _____662F_5426_6682_505C_2
    if _____662F_5426_6682_505C then
        _____662F_5426_6682_505C_2 = ____exports["申请单位暂停独立占用"](u, _____6765_6E90)
    else
        _____662F_5426_6682_505C_2 = ____exports["释放单位暂停来源全部"](u, _____6765_6E90)
    end
    return _____662F_5426_6682_505C_2
end
____exports["清除单位全部暂停占用"] = function(u)
    if u == nil or u == 0 then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____6765_6E90_5217_8868 = _____590D_5236_5355_4F4D_6682_505C_6765_6E90_5217_8868(_____5355_4F4DID)
    local changed = false
    do
        local i = 0
        while i < #_____6765_6E90_5217_8868 do
            if ____exports["释放单位暂停来源全部"](u, _____6765_6E90_5217_8868[i + 1]) then
                changed = true
            end
            i = i + 1
        end
    end
    return changed
end
____exports["单位是否存在暂停占用"] = function(u)
    if u == nil or u == 0 then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    return (_____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0) > 0
end
____exports["单位是否存在其他暂停占用"] = function(u, _____81EA_8EAB_6765_6E90)
    if u == nil or u == 0 then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____603B_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0
    if _____603B_8BA1_6570 <= 0 then
        return false
    end
    local _____81EA_8EAB_6765_6E90_5B58_5728 = _____81EA_8EAB_6765_6E90 ~= nil and _____81EA_8EAB_6765_6E90 ~= "" and (_____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____81EA_8EAB_6765_6E90)] or 0) > 0
    return _____603B_8BA1_6570 > (_____81EA_8EAB_6765_6E90_5B58_5728 and 1 or 0)
end
____exports["获取单位暂停占用总数"] = function(u)
    if u == nil or u == 0 then
        return 0
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return 0
    end
    return _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0
end
____exports["获取单位暂停来源列表"] = function(u)
    if u == nil or u == 0 then
        return {}
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return {}
    end
    return _____590D_5236_5355_4F4D_6682_505C_6765_6E90_5217_8868(_____5355_4F4DID)
end
____exports["获取单位暂停快照"] = function(u)
    if u == nil or u == 0 then
        return {["单位"] = u, ["单位ID"] = 0, ["总计数"] = 0, ["来源列表"] = {}}
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return {["单位"] = u, ["单位ID"] = 0, ["总计数"] = 0, ["来源列表"] = {}}
    end
    return {
        ["单位"] = u,
        ["单位ID"] = _____5355_4F4DID,
        ["总计数"] = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0,
        ["来源列表"] = _____590D_5236_5355_4F4D_6682_505C_6765_6E90_5217_8868(_____5355_4F4DID)
    }
end
____exports["刷新单位暂停底层状态"] = function(u)
    if u == nil or u == 0 then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____5E94_6682_505C = (_____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0) > 0
    _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, _____5E94_6682_505C)
    return _____5E94_6682_505C
end
____exports["注册任意单位被暂停监听"] = function(cb)
    _____6CE8_518C_6682_505C_4E8B_4EF6_76D1_542C(_____4EFB_610F_5355_4F4D_88AB_6682_505C_76D1_542C_5217_8868, cb)
end
____exports["注册任意单位取消暂停监听"] = function(cb)
    _____6CE8_518C_6682_505C_4E8B_4EF6_76D1_542C(_____4EFB_610F_5355_4F4D_53D6_6D88_6682_505C_76D1_542C_5217_8868, cb)
end
____exports["注册单位暂停占用变化监听"] = function(cb)
    _____6CE8_518C_6682_505C_5360_7528_53D8_5316_76D1_542C(cb)
end
local _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868 = {}
local _____6682_505C_6765_6E90_5230_671F_9A71_52A8_5DF2_6CE8_518C = false
local function _____67E5_627E_6682_505C_6765_6E90_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID, _____6765_6E90)
    do
        local i = 0
        while i < #_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868 do
            local _____4EFB_52A1 = _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868[i + 1]
            if _____4EFB_52A1["单位ID"] == _____5355_4F4DID and _____4EFB_52A1["来源"] == _____6765_6E90 then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
_____6E05_7406_5355_4F4D_6682_505C_6765_6E90_5B9A_65F6_4EFB_52A1 = function(_____5355_4F4DID, _____6765_6E90)
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_6682_505C_6765_6E90_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID, _____6765_6E90)
    if _____4EFB_52A1_7D22_5F15 >= 0 then
        __TS__ArraySplice(_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868, _____4EFB_52A1_7D22_5F15, 1)
    end
end
local function ____on_6682_505C_6765_6E90_5230_671F_9A71_52A8()
    if #_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868 == 0 then
        return
    end
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____5199_5165_4F4D_7F6E = 0
    do
        local i = 0
        while i < #_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868 do
            local _____4EFB_52A1 = _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868[i + 1]
            if _____5F53_524D_65F6_95F4_6BEB_79D2 >= _____4EFB_52A1["到期时间毫秒"] then
                ____exports["释放单位暂停占用"](_____4EFB_52A1["单位"], _____4EFB_52A1["来源"])
            else
                _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868[_____5199_5165_4F4D_7F6E + 1] = _____4EFB_52A1
                _____5199_5165_4F4D_7F6E = _____5199_5165_4F4D_7F6E + 1
            end
            i = i + 1
        end
    end
    while #_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868 > _____5199_5165_4F4D_7F6E do
        table.remove(_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868)
    end
end
local function _____786E_4FDD_6682_505C_6765_6E90_5230_671F_9A71_52A8()
    if _____6682_505C_6765_6E90_5230_671F_9A71_52A8_5DF2_6CE8_518C then
        return
    end
    _____6682_505C_6765_6E90_5230_671F_9A71_52A8_5DF2_6CE8_518C = true
    addPeriodicCallback(10, ____on_6682_505C_6765_6E90_5230_671F_9A71_52A8)
end
____exports["申请单位暂停占用定时"] = function(u, _____6765_6E90, _____6301_7EED_65F6_95F4, _____6A21_5F0F)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    if _____6301_7EED_65F6_95F4 <= 0 then
        _____6E05_7406_5355_4F4D_6682_505C_6765_6E90_5B9A_65F6_4EFB_52A1(_____5355_4F4DID, _____6765_6E90)
        return ____exports["释放单位暂停占用"](u, _____6765_6E90)
    end
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____6301_7EED_6BEB_79D2 = _____6301_7EED_65F6_95F4 * 1000
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_6682_505C_6765_6E90_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID, _____6765_6E90)
    local _____5F53_524D_6A21_5F0F = _____6A21_5F0F or "刷新"
    if _____4EFB_52A1_7D22_5F15 < 0 then
        local ok = ____exports["申请单位暂停占用"](u, _____6765_6E90)
        if not ok then
            return false
        end
        _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868[#_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868 + 1] = {["单位"] = u, ["单位ID"] = _____5355_4F4DID, ["来源"] = _____6765_6E90, ["到期时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + _____6301_7EED_6BEB_79D2}
        _____786E_4FDD_6682_505C_6765_6E90_5230_671F_9A71_52A8()
        return true
    end
    local _____4EFB_52A1 = _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868[_____4EFB_52A1_7D22_5F15 + 1]
    _____4EFB_52A1["单位"] = u
    if _____5F53_524D_6A21_5F0F == "叠加" then
        _____4EFB_52A1["到期时间毫秒"] = RMaxBJ(_____5F53_524D_65F6_95F4_6BEB_79D2, _____4EFB_52A1["到期时间毫秒"]) + _____6301_7EED_6BEB_79D2
    elseif _____5F53_524D_6A21_5F0F == "取最大" then
        _____4EFB_52A1["到期时间毫秒"] = RMaxBJ(_____4EFB_52A1["到期时间毫秒"], _____5F53_524D_65F6_95F4_6BEB_79D2 + _____6301_7EED_6BEB_79D2)
    else
        _____4EFB_52A1["到期时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + _____6301_7EED_6BEB_79D2
    end
    _____786E_4FDD_6682_505C_6765_6E90_5230_671F_9A71_52A8()
    return true
end
____exports["取消单位暂停占用定时"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_6682_505C_6765_6E90_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID, _____6765_6E90)
    if _____4EFB_52A1_7D22_5F15 >= 0 then
        __TS__ArraySplice(_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868, _____4EFB_52A1_7D22_5F15, 1)
    end
    return ____exports["释放单位暂停占用"](u, _____6765_6E90)
end
_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 = {}
local _____786C_76F4_5230_671F_9A71_52A8_5DF2_6CE8_518C = false
_____6E05_7406_5355_4F4D_786C_76F4_5230_671F_4EFB_52A1 = function(_____5355_4F4DID)
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID)
    if _____4EFB_52A1_7D22_5F15 >= 0 then
        __TS__ArraySplice(_____786C_76F4_5230_671F_4EFB_52A1_5217_8868, _____4EFB_52A1_7D22_5F15, 1)
    end
end
local function ____on_786C_76F4_5230_671F_9A71_52A8()
    if #_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 == 0 then
        return
    end
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____5199_5165_4F4D_7F6E = 0
    do
        local i = 0
        while i < #_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 do
            local _____4EFB_52A1 = _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[i + 1]
            if _____5F53_524D_65F6_95F4_6BEB_79D2 >= _____4EFB_52A1["到期时间毫秒"] then
                ____exports["释放单位暂停占用"](_____4EFB_52A1["单位"], "GS_Suspend")
            else
                _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[_____5199_5165_4F4D_7F6E + 1] = _____4EFB_52A1
                _____5199_5165_4F4D_7F6E = _____5199_5165_4F4D_7F6E + 1
            end
            i = i + 1
        end
    end
    while #_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 > _____5199_5165_4F4D_7F6E do
        table.remove(_____786C_76F4_5230_671F_4EFB_52A1_5217_8868)
    end
end
local function _____786E_4FDD_786C_76F4_5230_671F_9A71_52A8()
    if _____786C_76F4_5230_671F_9A71_52A8_5DF2_6CE8_518C then
        return
    end
    _____786C_76F4_5230_671F_9A71_52A8_5DF2_6CE8_518C = true
    addPeriodicCallback(10, ____on_786C_76F4_5230_671F_9A71_52A8)
end
--- 暂停单位一段时间
-- 若单位已在暂停中，会重置暂停时间
-- 
-- @param u 目标单位
-- @param time 暂停时间（秒）
function ____exports.GS_Suspend(u, time)
    if u == nil or u == 0 then
        return
    end
    local uid = hid(u)
    if uid == 0 then
        return
    end
    if time <= 0 then
        ____exports["释放单位暂停来源全部"](u, "GS_Suspend")
        return
    end
    local _____5230_671F_65F6_95F4_6BEB_79D2 = getServerTime() + RMaxBJ(0, time) * 1000
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15(uid)
    if _____4EFB_52A1_7D22_5F15 < 0 then
        ____exports["申请单位暂停占用"](u, "GS_Suspend")
        _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[#_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 + 1] = {["单位"] = u, ["单位ID"] = uid, ["到期时间毫秒"] = _____5230_671F_65F6_95F4_6BEB_79D2}
    else
        local _____4EFB_52A1 = _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[_____4EFB_52A1_7D22_5F15 + 1]
        _____4EFB_52A1["单位"] = u
        _____4EFB_52A1["到期时间毫秒"] = _____5230_671F_65F6_95F4_6BEB_79D2
    end
    _____786E_4FDD_786C_76F4_5230_671F_9A71_52A8()
end
--- 检查单位是否处于暂停状态
-- 
-- @param u 目标单位
-- @returns 是否正在暂停中
function ____exports.GS_IsUnitSuspending(u)
    if u == nil or u == 0 then
        return false
    end
    return ____exports.GS_LoadSuspend(u) > 0
end
--- 修改单位暂停时间
-- 
-- @param u 目标单位
-- @param i 操作类型：0=增加时间，1=减少时间，2=取最大值
-- @param r 时间值（秒）
function ____exports.GS_UnitSuspend(u, i, r)
    if u == nil or u == 0 then
        return
    end
    local currentRemain = ____exports.GS_LoadSuspend(u)
    if i == 0 then
        ____exports.GS_Suspend(u, currentRemain + r)
    elseif i == 1 then
        ____exports.GS_Suspend(
            u,
            RMaxBJ(0, currentRemain - r)
        )
    elseif i == 2 then
        ____exports.GS_Suspend(
            u,
            RMaxBJ(currentRemain, r)
        )
    end
end
return ____exports
