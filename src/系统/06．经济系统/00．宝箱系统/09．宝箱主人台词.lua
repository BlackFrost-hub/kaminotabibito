local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__StringReplace = ____lualib.__TS__StringReplace
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetRandomInt = jass.GetRandomInt
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerName = jass.GetPlayerName
local ____require_result_0 = require("系统.06．经济系统.00．宝箱系统.04．准备开启回调")
local _____6CE8_518C_5B9D_7BB1_51C6_5907_5F00_542F_56DE_8C03 = ____require_result_0["注册宝箱准备开启回调"]
local ____require_result_1 = require("系统.06．经济系统.00．宝箱系统.06．开启完成回调")
local _____6CE8_518C_5B9D_7BB1_5F00_542F_5B8C_6210_56DE_8C03 = ____require_result_1["注册宝箱开启完成回调"]
local ____require_result_2 = require("系统.06．经济系统.00．宝箱系统.07．主人广播")
local _____5E7F_64AD_5B9D_7BB1_4E3B_4EBA_63D0_793A = ____require_result_2["广播宝箱主人提示"]
local _____5E7F_64AD_5355_4F4D_7C7B_578B_63D0_793A = ____require_result_2["广播单位类型提示"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_3.stringToFourCC
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
local removePeriodicCallback = ____require_result_4.removePeriodicCallback
local getServerTime = ____require_result_4.getServerTime
local _____51C6_5907_5F00_542F_6301_7EED_6BEB_79D2 = 4800
local _____5F00_542F_5B8C_6210_6301_7EED_6BEB_79D2 = 4800
local _____5B9D_7BB1_53F0_8BCD_914D_7F6E = __TS__New(Map, {{"LTbs", {["准备开启"] = {"小老鼠，{开启者}，也太目中无人了吧？", "嘿，贪婪的家伙{开启者}，休想从我这儿轻松得手！"}, ["开启完成"] = {"{玩家名}，还真被你得手了，可恶！（莫斯特永久提高3%基础攻击力）", "我的珍藏！{玩家名}，你成功惹怒了我！（莫斯特永久提高3%基础攻击力）"}, ["冷却秒数"] = 5}}})
local _____51B7_5374_8868 = __TS__New(Map)
local _____51B7_5374_68C0_67E5_95F4_9694_6BEB_79D2 = 100
local _____51B7_5374_68C0_67E5_56DE_8C03ID = 0
local _____51B7_5374_952E_5217_8868 = {}
local _____51B7_5374_5230_671F_6BEB_79D2_5217_8868 = {}
local function _____6784_9020_51B7_5374_952E(_____9636_6BB5_540D, _____5F00_542F_8005, _____4E3B_4EBA_5355_4F4D, _____5B9D_7BB1_914D_7F6E)
    local openerId = _____5F00_542F_8005 and GetHandleId(_____5F00_542F_8005) or 0
    local ownerId = _____4E3B_4EBA_5355_4F4D and GetHandleId(_____4E3B_4EBA_5355_4F4D) or 0
    local ____opt_result_7
    if _____5B9D_7BB1_914D_7F6E ~= nil then
        ____opt_result_7 = _____5B9D_7BB1_914D_7F6E.destructableType
    end
    local ____opt_result_7_8 = ____opt_result_7
    if ____opt_result_7_8 == nil then
        ____opt_result_7_8 = ""
    end
    local chestType = ____opt_result_7_8
    return (((((_____9636_6BB5_540D .. ":") .. tostring(chestType)) .. ":") .. tostring(openerId)) .. ":") .. tostring(ownerId)
end
local function _____53D6_968F_673A_53F0_8BCD(_____5217_8868)
    if #_____5217_8868 == 0 then
        return nil
    end
    if #_____5217_8868 == 1 then
        return _____5217_8868[1]
    end
    local index = GetRandomInt(1, #_____5217_8868) - 1
    return _____5217_8868[index + 1]
end
local function _____66FF_6362_53F0_8BCD_53D8_91CF(_____6A21_677F, _____5F00_542F_8005)
    local _____6587_672C = _____6A21_677F
    local _____5F00_542F_8005_540D_5B57 = _____5F00_542F_8005 and GetUnitName(_____5F00_542F_8005) or "有人"
    local _____73A9_5BB6_540D_5B57 = _____5F00_542F_8005 and GetPlayerName(GetOwningPlayer(_____5F00_542F_8005)) or "有人"
    _____6587_672C = __TS__StringReplace(_____6587_672C, "{开启者}", ("（" .. _____5F00_542F_8005_540D_5B57) .. "）")
    _____6587_672C = __TS__StringReplace(_____6587_672C, "{玩家名}", _____73A9_5BB6_540D_5B57)
    return _____6587_672C
end
local function _____51B7_5374_7ED3_675F_56DE_8C03()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____51B7_5374_952E_5217_8868 do
            local key = _____51B7_5374_952E_5217_8868[i + 1]
            local dueMs = _____51B7_5374_5230_671F_6BEB_79D2_5217_8868[i + 1]
            if now >= dueMs then
                _____51B7_5374_8868:delete(key)
            else
                _____51B7_5374_952E_5217_8868[writeIndex + 1] = key
                _____51B7_5374_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = dueMs
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____51B7_5374_952E_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____51B7_5374_952E_5217_8868)
            table.remove(_____51B7_5374_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
    if #_____51B7_5374_952E_5217_8868 == 0 and _____51B7_5374_68C0_67E5_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____51B7_5374_68C0_67E5_56DE_8C03ID)
        _____51B7_5374_68C0_67E5_56DE_8C03ID = 0
    end
end
local function _____542F_52A8_51B7_5374_68C0_67E5()
    if _____51B7_5374_68C0_67E5_56DE_8C03ID ~= 0 then
        return
    end
    _____51B7_5374_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____51B7_5374_68C0_67E5_95F4_9694_6BEB_79D2, _____51B7_5374_7ED3_675F_56DE_8C03)
end
local function _____8BB0_5F55_51B7_5374(key, cooldownSeconds)
    _____51B7_5374_8868:set(key, true)
    _____51B7_5374_952E_5217_8868[#_____51B7_5374_952E_5217_8868 + 1] = key
    _____51B7_5374_5230_671F_6BEB_79D2_5217_8868[#_____51B7_5374_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + cooldownSeconds * 1000
    _____542F_52A8_51B7_5374_68C0_67E5()
end
local function _____5C1D_8BD5_5E7F_64AD_4E3B_4EBA_53F0_8BCD(_____9636_6BB5_540D, _____5F00_542F_8005, _____5B9D_7BB1_914D_7F6E, _____4E3B_4EBA_5355_4F4D)
    local ____opt_result_11
    if _____5B9D_7BB1_914D_7F6E ~= nil then
        ____opt_result_11 = _____5B9D_7BB1_914D_7F6E.destructableType
    end
    local chestType = ____opt_result_11
    if not chestType then
        return
    end
    local _____914D_7F6E = _____5B9D_7BB1_53F0_8BCD_914D_7F6E:get(chestType)
    if not _____914D_7F6E then
        return
    end
    local key = _____6784_9020_51B7_5374_952E(_____9636_6BB5_540D, _____5F00_542F_8005, _____4E3B_4EBA_5355_4F4D, _____5B9D_7BB1_914D_7F6E)
    if _____51B7_5374_8868:has(key) then
        return
    end
    local _____5019_9009 = _____9636_6BB5_540D == "prepare" and _____914D_7F6E["准备开启"] or _____914D_7F6E["开启完成"]
    local _____6A21_677F = _____53D6_968F_673A_53F0_8BCD(_____5019_9009)
    if not _____6A21_677F then
        return
    end
    local _____6587_672C = _____66FF_6362_53F0_8BCD_53D8_91CF(_____6A21_677F, _____5F00_542F_8005)
    if _____9636_6BB5_540D == "complete" then
        if _____4E3B_4EBA_5355_4F4D then
            _____5E7F_64AD_5B9D_7BB1_4E3B_4EBA_63D0_793A(_____4E3B_4EBA_5355_4F4D, _____6587_672C, _____5F00_542F_5B8C_6210_6301_7EED_6BEB_79D2)
        else
            local ____opt_result_16
            if _____5B9D_7BB1_914D_7F6E ~= nil then
                ____opt_result_16 = _____5B9D_7BB1_914D_7F6E["主人配置"]
            end
            local ____opt_result_17
            if ____opt_result_16 ~= nil then
                ____opt_result_17 = ____opt_result_16["单位类型"]
            end
            if ____opt_result_17 then
                _____5E7F_64AD_5355_4F4D_7C7B_578B_63D0_793A(
                    stringToFourCC(_____5B9D_7BB1_914D_7F6E["主人配置"]["单位类型"]),
                    _____6587_672C,
                    _____5F00_542F_5B8C_6210_6301_7EED_6BEB_79D2
                )
            else
                return
            end
        end
    elseif _____4E3B_4EBA_5355_4F4D then
        _____5E7F_64AD_5B9D_7BB1_4E3B_4EBA_63D0_793A(_____4E3B_4EBA_5355_4F4D, _____6587_672C, _____51C6_5907_5F00_542F_6301_7EED_6BEB_79D2)
    else
        local ____opt_result_22
        if _____5B9D_7BB1_914D_7F6E ~= nil then
            ____opt_result_22 = _____5B9D_7BB1_914D_7F6E["主人配置"]
        end
        local ____opt_result_23
        if ____opt_result_22 ~= nil then
            ____opt_result_23 = ____opt_result_22["单位类型"]
        end
        if ____opt_result_23 then
            _____5E7F_64AD_5355_4F4D_7C7B_578B_63D0_793A(
                stringToFourCC(_____5B9D_7BB1_914D_7F6E["主人配置"]["单位类型"]),
                _____6587_672C,
                _____51C6_5907_5F00_542F_6301_7EED_6BEB_79D2
            )
        else
            return
        end
    end
    _____8BB0_5F55_51B7_5374(key, _____914D_7F6E["冷却秒数"])
end
local function onChestPrepare(unit, _target, _progressBar, _openTime, chestConfig, ownerUnit)
    _____5C1D_8BD5_5E7F_64AD_4E3B_4EBA_53F0_8BCD("prepare", unit, chestConfig, ownerUnit)
end
local function onChestComplete(unit, _target, _progressBar, _openTime, chestConfig, ownerUnit)
    _____5C1D_8BD5_5E7F_64AD_4E3B_4EBA_53F0_8BCD("complete", unit, chestConfig, ownerUnit)
end
_____6CE8_518C_5B9D_7BB1_51C6_5907_5F00_542F_56DE_8C03(onChestPrepare)
_____6CE8_518C_5B9D_7BB1_5F00_542F_5B8C_6210_56DE_8C03(onChestComplete)
return ____exports
