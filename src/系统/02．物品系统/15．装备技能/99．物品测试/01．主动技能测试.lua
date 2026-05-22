--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_6D4B_8BD5_914D_7F6E = require("系统.02．物品系统.15．装备技能.99．物品测试.00．测试配置")
local _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_53D1_653E_987A_5E8F = ____00_FF0E_6D4B_8BD5_914D_7F6E["物品主动技能测试发放顺序"]
local _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868 = ____00_FF0E_6D4B_8BD5_914D_7F6E["物品主动技能测试命令列表"]
local _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_8BF4_660E_6587_672C_5217_8868 = ____00_FF0E_6D4B_8BD5_914D_7F6E["物品主动技能测试命令说明文本列表"]
local _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_6E05_7406_88C5_5907_5217_8868 = ____00_FF0E_6D4B_8BD5_914D_7F6E["物品主动技能测试清理装备列表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_2["按名字反查物品ID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.物品相关函数.index")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_4["创建物品并注册排泄监听"]
local IssueTargetOrder = jass.IssueTargetOrder
local UnitAddItem = jass.UnitAddItem
local UnitRemoveItem = jass.UnitRemoveItem
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetItemTypeId = jass.GetItemTypeId
local UnitItemInSlot = jass.UnitItemInSlot
local _____6A21_5757_540D = "物品主动技能测试"
local function _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    local ____g_gg_unit_Hamg_0002_5 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_5 == nil then
        ____g_gg_unit_Hamg_0002_5 = _G.bj_lastCreatedUnit
    end
    local ____g_gg_unit_Hamg_0002_5_6 = ____g_gg_unit_Hamg_0002_5
    if ____g_gg_unit_Hamg_0002_5_6 == nil then
        ____g_gg_unit_Hamg_0002_5_6 = nil
    end
    return ____g_gg_unit_Hamg_0002_5_6
end
local SetItemPosition = jass.SetItemPosition
local function _____4E22_5F03_6D4B_8BD5_88C5_5907(unit)
    if unit == nil or unit == 0 then
        return
    end
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    do
        local i = 0
        while i < 6 do
            do
                local item = UnitItemInSlot(unit, i)
                if item == nil or item == 0 then
                    goto __continue6
                end
                local itemTypeId = GetItemTypeId(item)
                do
                    local j = 0
                    while j < #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_6E05_7406_88C5_5907_5217_8868 do
                        do
                            local _____88C5_5907_540D = _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_6E05_7406_88C5_5907_5217_8868[j + 1]
                            local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
                            if rawId == nil or rawId == "" then
                                goto __continue9
                            end
                            if stringToFourCCSafe(rawId) == itemTypeId then
                                UnitRemoveItem(unit, item)
                                SetItemPosition(item, x, y)
                                break
                            end
                        end
                        ::__continue9::
                        j = j + 1
                    end
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
end
local function _____53D1_653E_88C5_5907(unit, _____88C5_5907_540D)
    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
    if rawId == nil or rawId == "" then
        debugLogForce(_____6A21_5757_540D, "未找到装备ID", _____88C5_5907_540D)
        return
    end
    local item = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        stringToFourCCSafe(rawId),
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if item == nil or item == 0 then
        debugLogForce(_____6A21_5757_540D, "创建装备失败", _____88C5_5907_540D, rawId)
        return
    end
    local ok = IssueTargetOrder(unit, "smart", item)
    debugLogForce(_____6A21_5757_540D, "已创建并下达拾取命令", _____88C5_5907_540D, ok)
end
local function _____53D1_653E_5355_4E2A_88C5_5907(unit, _____5E8F_53F7)
    _____4E22_5F03_6D4B_8BD5_88C5_5907(unit)
    if _____5E8F_53F7 > 0 and _____5E8F_53F7 <= #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_53D1_653E_987A_5E8F then
        _____53D1_653E_88C5_5907(unit, _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_53D1_653E_987A_5E8F[_____5E8F_53F7])
        debugLogForce(_____6A21_5757_540D, "已发放测试装备", _____5E8F_53F7, _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_53D1_653E_987A_5E8F[_____5E8F_53F7])
    end
end
local function ____on_804A_5929wp_6D4B_8BD5(_player, command)
    local unit = _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到大法师单位")
        return
    end
    do
        local i = 0
        while i < #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868 do
            if command == _____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868[i + 1] then
                _____53D1_653E_5355_4E2A_88C5_5907(unit, i + 1)
                return
            end
            i = i + 1
        end
    end
end
do
    local i = 0
    while i < #_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868 do
        _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_5217_8868[i + 1], ____on_804A_5929wp_6D4B_8BD5)
        i = i + 1
    end
end
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试命令",
    table.concat(_____7269_54C1_4E3B_52A8_6280_80FD_6D4B_8BD5_547D_4EE4_8BF4_660E_6587_672C_5217_8868, " | ")
)
return ____exports
