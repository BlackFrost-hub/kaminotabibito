local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态")
local _____662F_5426_9ED1_5929 = ____require_result_0["是否黑天"]
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8F6C_56DB_4F4DID = ____require_result_1["转四位ID"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____require_result_2["创建周期机制调度器"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____53D6_5355_4F4DID = ____require_result_3["取单位ID"]
local _____5355_4F4D_672A_6807_8BB0_6B7B_4EA1 = ____require_result_3["单位未标记死亡"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.02．赫萝.00．配置")
local _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_4["赫萝单位技能配置"]
local GetUnitTypeId = jass.GetUnitTypeId
local SetUnitStateJapi = japi.SetUnitState
local SetUnitMoveSpeed = jass.SetUnitMoveSpeed
local ConvertUnitState = jass.ConvertUnitState
local _____8D6B_841D_5355_4F4D_7C7B_578BID = _____8F6C_56DB_4F4DID(_____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____8D6B_841D_663C_591C_88AB_52A8_4E0A_4E0B_6587 = {["单位列表"] = {}}
local _____8D6B_841D_663C_591C_88AB_52A8_4E0A_4E0B_6587_5217_8868 = {_____8D6B_841D_663C_591C_88AB_52A8_4E0A_4E0B_6587}
local _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668
local function _____5E94_7528_8D6B_841D_663C_591C_72B6_6001(unit)
    if not _____5355_4F4D_672A_6807_8BB0_6B7B_4EA1(unit) then
        return
    end
    if GetUnitTypeId(unit) ~= _____8D6B_841D_5355_4F4D_7C7B_578BID then
        return
    end
    if _____662F_5426_9ED1_5929() then
        SetUnitStateJapi(
            unit,
            ConvertUnitState(37),
            _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["黑夜单位状态值"]
        )
        SetUnitMoveSpeed(unit, _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["黑夜移速"])
    else
        SetUnitStateJapi(
            unit,
            ConvertUnitState(37),
            _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["白天单位状态值"]
        )
        SetUnitMoveSpeed(unit, _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["白天移速"])
    end
end
local function _____5904_7406_8D6B_841D_663C_591C_88AB_52A8Tick()
    local list = _____8D6B_841D_663C_591C_88AB_52A8_4E0A_4E0B_6587["单位列表"]
    do
        local i = #list - 1
        while i >= 0 do
            do
                local record = list[i + 1]
                if not _____5355_4F4D_672A_6807_8BB0_6B7B_4EA1(record["单位"]) then
                    __TS__ArraySplice(list, i, 1)
                    goto __continue9
                end
                _____5E94_7528_8D6B_841D_663C_591C_72B6_6001(record["单位"])
            end
            ::__continue9::
            i = i - 1
        end
    end
    if #list == 0 then
        if _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668 ~= nil then
            _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668["停止"](_____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668)
        end
    end
end
____exports["启动赫萝昼夜被动"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    if GetUnitTypeId(unit) ~= _____8D6B_841D_5355_4F4D_7C7B_578BID then
        return
    end
    local handleId = _____53D6_5355_4F4DID(unit)
    if handleId == 0 then
        return
    end
    local list = _____8D6B_841D_663C_591C_88AB_52A8_4E0A_4E0B_6587["单位列表"]
    local found = false
    do
        local i = 0
        while i < #list do
            do
                if list[i + 1]["句柄ID"] ~= handleId then
                    goto __continue17
                end
                list[i + 1]["单位"] = unit
                found = true
                break
            end
            ::__continue17::
            i = i + 1
        end
    end
    if not found then
        list[#list + 1] = {["句柄ID"] = handleId, ["单位"] = unit}
    end
    if _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668 == nil then
        _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668 = _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({
            ["名称"] = "赫萝-昼夜被动",
            ["间隔毫秒"] = _____8D6B_841D_5355_4F4D_6280_80FD_914D_7F6E["检查间隔Ms"],
            ["自动启动"] = false,
            ["取上下文列表"] = function()
                return _____8D6B_841D_663C_591C_88AB_52A8_4E0A_4E0B_6587_5217_8868
            end,
            ["可执行"] = function(context)
                return #context["单位列表"] > 0
            end,
            ["执行"] = function(_context)
                _____5904_7406_8D6B_841D_663C_591C_88AB_52A8Tick()
            end
        })
    end
    if not _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668["是否运行中"](_____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668) then
        _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668["启动"](_____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668)
    end
    _____5E94_7528_8D6B_841D_663C_591C_72B6_6001(unit)
end
____exports["停止赫萝昼夜被动"] = function(unit)
    local handleId = _____53D6_5355_4F4DID(unit)
    if handleId == 0 then
        return
    end
    local list = _____8D6B_841D_663C_591C_88AB_52A8_4E0A_4E0B_6587["单位列表"]
    do
        local i = #list - 1
        while i >= 0 do
            if list[i + 1]["句柄ID"] == handleId then
                __TS__ArraySplice(list, i, 1)
            end
            i = i - 1
        end
    end
    if #list == 0 then
        if _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668 ~= nil then
            _____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668["停止"](_____8D6B_841D_663C_591C_88AB_52A8_8C03_5EA6_5668)
        end
    end
end
return ____exports
