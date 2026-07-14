local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local hid, _____751F_6210_6682_505C_6765_6E90_952E, _____67E5_627E_6682_505C_6765_6E90_5230_671F_4EFB_52A1_7D22_5F15, RMaxBJ, getServerTime, GetHandleId, _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868, _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868
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
function _____67E5_627E_6682_505C_6765_6E90_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID, _____6765_6E90)
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
____exports["获取单位暂停剩余时间"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return 0
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return 0
    end
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_6682_505C_6765_6E90_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID, _____6765_6E90)
    if _____4EFB_52A1_7D22_5F15 < 0 then
        return 0
    end
    return RMaxBJ(
        0,
        _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868[_____4EFB_52A1_7D22_5F15 + 1]["到期时间毫秒"] - getServerTime()
    ) * 0.001
end
--- 获取单位剩余暂停时间（秒）。
function ____exports.GS_LoadSuspend(u)
    return ____exports["获取单位暂停剩余时间"](u, "GS_Suspend")
end
--- Star扩展库 - 硬直/暂停系统
-- 
-- 来源于 SUSPEND.j，提供单位暂停控制功能。
-- 优先通过 EXPauseUnit(japi) 暂停单位，缺失时回退到 PauseUnit；两者统一由来源管理池调度。
-- 只有 EXPauseUnit 自带引用计数语义，PauseUnit 本身不要求调用次数配平。
-- 支持暂停时间累加、减少、取最大值等操作。
-- 
-- 业务统一接口（参数顺序统一为：单位、来源、时间）：
--   添加单位暂停(u, 来源)
--   移除单位暂停(u, 来源)
--   设置单位暂停时间(u, 来源, 秒)
--   增加单位暂停时间(u, 来源, 秒)
--   减少单位暂停时间(u, 来源, 秒)
--   单位是否暂停(u)
--   获取单位暂停剩余时间(u, 来源)
-- GS_* 与申请/释放占用系列仅保留给旧代码兼容，新业务不要继续使用。
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
local function _____6E05_7406_5355_4F4D_6682_505C_6765_6E90_5B9A_65F6_4EFB_52A1(______5355_4F4DID, ______6765_6E90)
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
    return (_____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0) > 0
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
_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868 = {}
local _____6682_505C_6765_6E90_5230_671F_9A71_52A8_5DF2_6CE8_518C = false
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
                while ____exports["获取单位暂停来源计数"](_____4EFB_52A1["单位"], _____4EFB_52A1["来源"]) > 0 do
                    if not ____exports["释放单位暂停占用"](_____4EFB_52A1["单位"], _____4EFB_52A1["来源"]) then
                        break
                    end
                end
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
        local ok = ____exports["申请单位暂停独立占用"](u, _____6765_6E90)
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
    return ____exports["释放单位暂停来源全部"](u, _____6765_6E90)
end
--- 业务层暂停接口：所有调用都必须传稳定且唯一的来源名。
-- 外部业务不要直接调用 EXPauseUnit / PauseUnit：前者需要配平计数，后者仅纳入同一管理入口。
____exports["添加单位暂停"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    _____6E05_7406_5355_4F4D_6682_505C_6765_6E90_5B9A_65F6_4EFB_52A1(_____5355_4F4DID, _____6765_6E90)
    return ____exports["申请单位暂停独立占用"](u, _____6765_6E90)
end
____exports["移除单位暂停"] = function(u, _____6765_6E90)
    return ____exports["释放单位暂停来源全部"](u, _____6765_6E90)
end
____exports["单位是否暂停"] = function(u)
    return ____exports["单位是否存在暂停占用"](u)
end
____exports["设置单位暂停时间"] = function(u, _____6765_6E90, _____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 <= 0 then
        return ____exports["移除单位暂停"](u, _____6765_6E90)
    end
    return ____exports["申请单位暂停占用定时"](u, _____6765_6E90, _____6301_7EED_65F6_95F4, "刷新")
end
____exports["增加单位暂停时间"] = function(u, _____6765_6E90, _____589E_52A0_65F6_95F4)
    if _____589E_52A0_65F6_95F4 <= 0 then
        return false
    end
    return ____exports["申请单位暂停占用定时"](u, _____6765_6E90, _____589E_52A0_65F6_95F4, "叠加")
end
____exports["减少单位暂停时间"] = function(u, _____6765_6E90, _____51CF_5C11_65F6_95F4)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" or _____51CF_5C11_65F6_95F4 <= 0 then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_6682_505C_6765_6E90_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID, _____6765_6E90)
    if _____4EFB_52A1_7D22_5F15 < 0 then
        return false
    end
    local _____4EFB_52A1 = _____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868[_____4EFB_52A1_7D22_5F15 + 1]
    _____4EFB_52A1["到期时间毫秒"] = _____4EFB_52A1["到期时间毫秒"] - _____51CF_5C11_65F6_95F4 * 1000
    if _____4EFB_52A1["到期时间毫秒"] > getServerTime() then
        return true
    end
    __TS__ArraySplice(_____6682_505C_6765_6E90_5230_671F_4EFB_52A1_5217_8868, _____4EFB_52A1_7D22_5F15, 1)
    return ____exports["释放单位暂停来源全部"](u, _____6765_6E90)
end
--- 暂停单位一段时间
-- 若单位已在暂停中，会重置暂停时间
-- 
-- @param u 目标单位
-- @param time 暂停时间（秒）
function ____exports.GS_Suspend(u, time)
    ____exports["设置单位暂停时间"](u, "GS_Suspend", time)
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
    if i == 0 then
        ____exports["增加单位暂停时间"](u, "GS_Suspend", r)
    elseif i == 1 then
        ____exports["减少单位暂停时间"](u, "GS_Suspend", r)
    elseif i == 2 and r > 0 then
        ____exports["申请单位暂停占用定时"](u, "GS_Suspend", r, "取最大")
    end
end
return ____exports
