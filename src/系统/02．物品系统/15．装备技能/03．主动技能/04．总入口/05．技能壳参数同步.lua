local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____02_FF0E_901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.02．通用物品技能槽位配置")
local _____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_53EF_7528_547D_4EE4ID_8868 = ____02_FF0E_901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E["通用物品技能槽位可用命令ID表"]
local _____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868 = ____02_FF0E_901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E["通用物品技能槽位配置表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemDrop = ____require_result_0.onItemDrop
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local platformAbilityAction = require("平台扩展API动作")
local GetItemTypeId = jass.GetItemTypeId
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local OrderId = jass.OrderId
local UnitItemInSlot = jass.UnitItemInSlot
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local _____5DF2_521D_59CB_5316_4E3B_52A8_6280_80FD_58F3_53C2_6570_540C_6B65 = false
local _____4E3B_52A8_7269_54C1_8FD0_884C_547D_4EE4ID_8868 = {}
local function _____662F_6709_6548_82F1_96C4(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true
end
local function _____5339_914D_4E3B_52A8_6280_80FD_69FD_4F4D_914D_7F6E(itemTypeId)
    for ____, _____914D_7F6E in ipairs(_____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868) do
        if stringToFourCCSafe(_____914D_7F6E["物编ID"]) == itemTypeId then
            return _____914D_7F6E
        end
    end
    return nil
end
local function _____53D6_7269_54C1_53E5_67C4ID(item)
    if item == nil or item == 0 then
        return 0
    end
    return GetHandleId(item) or 0
end
local function _____53D6_7269_54C1_8FD0_884C_547D_4EE4ID(item, _____914D_7F6E)
    local _____7269_54C1_53E5_67C4ID = _____53D6_7269_54C1_53E5_67C4ID(item)
    return _____7269_54C1_53E5_67C4ID > 0 and _____4E3B_52A8_7269_54C1_8FD0_884C_547D_4EE4ID_8868[_____7269_54C1_53E5_67C4ID] or _____914D_7F6E["命令ID"]
end
local function _____6536_96C6_5355_4F4D_5DF2_7528_4E3B_52A8_7269_54C1_547D_4EE4ID(unit, _____5F53_524D_7269_54C1)
    local _____5DF2_7528 = {}
    do
        local _____69FD_4F4D = 0
        while _____69FD_4F4D < 6 do
            do
                local _____7269_54C1 = UnitItemInSlot(unit, _____69FD_4F4D)
                if _____7269_54C1 == nil or _____7269_54C1 == 0 or _____7269_54C1 == _____5F53_524D_7269_54C1 then
                    goto __continue12
                end
                local _____914D_7F6E = _____5339_914D_4E3B_52A8_6280_80FD_69FD_4F4D_914D_7F6E(GetItemTypeId(_____7269_54C1))
                if _____914D_7F6E == nil then
                    goto __continue12
                end
                local _____547D_4EE4_7F16_53F7 = OrderId(_____53D6_7269_54C1_8FD0_884C_547D_4EE4ID(_____7269_54C1, _____914D_7F6E))
                if _____547D_4EE4_7F16_53F7 ~= 0 then
                    _____5DF2_7528[_____547D_4EE4_7F16_53F7] = true
                end
            end
            ::__continue12::
            _____69FD_4F4D = _____69FD_4F4D + 1
        end
    end
    return _____5DF2_7528
end
local function _____9009_62E9_53EF_7528_547D_4EE4ID(_____914D_7F6E, _____5DF2_7528)
    local _____9ED8_8BA4_547D_4EE4_7F16_53F7 = OrderId(_____914D_7F6E["命令ID"])
    if _____9ED8_8BA4_547D_4EE4_7F16_53F7 ~= 0 and _____5DF2_7528[_____9ED8_8BA4_547D_4EE4_7F16_53F7] ~= true then
        return _____914D_7F6E["命令ID"]
    end
    local _____53EF_7528_547D_4EE4ID_5217_8868 = _____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_53EF_7528_547D_4EE4ID_8868[_____914D_7F6E["目标类型"]]
    for ____, _____547D_4EE4ID in ipairs(_____53EF_7528_547D_4EE4ID_5217_8868) do
        local _____547D_4EE4_7F16_53F7 = OrderId(_____547D_4EE4ID)
        if _____547D_4EE4_7F16_53F7 ~= 0 and _____5DF2_7528[_____547D_4EE4_7F16_53F7] ~= true then
            return _____547D_4EE4ID
        end
    end
    return _____914D_7F6E["命令ID"]
end
local function _____540C_6B65_4E3B_52A8_7269_54C1_6280_80FD_58F3_547D_4EE4ID(unit, item, _____914D_7F6E)
    local _____6280_80FDID = stringToFourCCSafe(_____914D_7F6E["技能ID"])
    if _____6280_80FDID == 0 then
        return
    end
    local _____7269_54C1_53E5_67C4ID = _____53D6_7269_54C1_53E5_67C4ID(item)
    local _____53EF_7528_547D_4EE4ID = _____9009_62E9_53EF_7528_547D_4EE4ID(
        _____914D_7F6E,
        _____6536_96C6_5355_4F4D_5DF2_7528_4E3B_52A8_7269_54C1_547D_4EE4ID(unit, item)
    )
    local _____547D_4EE4_7F16_53F7 = OrderId(_____53EF_7528_547D_4EE4ID)
    if _____547D_4EE4_7F16_53F7 == 0 then
        return
    end
    platformAbilityAction["技能_设置技能命令编号"](unit, _____6280_80FDID, _____547D_4EE4_7F16_53F7)
    if _____7269_54C1_53E5_67C4ID <= 0 then
        return
    end
    if _____53EF_7528_547D_4EE4ID == _____914D_7F6E["命令ID"] then
        __TS__Delete(_____4E3B_52A8_7269_54C1_8FD0_884C_547D_4EE4ID_8868, _____7269_54C1_53E5_67C4ID)
    else
        _____4E3B_52A8_7269_54C1_8FD0_884C_547D_4EE4ID_8868[_____7269_54C1_53E5_67C4ID] = _____53EF_7528_547D_4EE4ID
    end
end
local function _____540C_6B65_4E3B_52A8_7269_54C1_6280_80FD_58F3_53C2_6570(unit, _____914D_7F6E)
    local _____6280_80FDID = stringToFourCCSafe(_____914D_7F6E["技能ID"])
    if _____6280_80FDID == 0 then
        return
    end
    platformAbilityAction["技能_设置技能冷却时间"](unit, _____6280_80FDID, 0, _____914D_7F6E["冷却时间"])
    platformAbilityAction["技能_设置技能魔法消耗"](unit, _____6280_80FDID, _____914D_7F6E["魔法消耗"])
    platformAbilityAction["技能_设置技能施法距离"](unit, _____6280_80FDID, _____914D_7F6E["施法距离"])
    local _____65BD_6CD5_533A_57DF = _____914D_7F6E["施法区域"] or 0
    if _____65BD_6CD5_533A_57DF > 0 then
        platformAbilityAction["技能_设置技能施法范围"](unit, _____6280_80FDID, _____65BD_6CD5_533A_57DF)
    end
end
local function ____on_4E3B_52A8_6280_80FD_7269_54C1_62FE_53D6(unit, item)
    if not _____662F_6709_6548_82F1_96C4(unit) then
        return
    end
    if item == nil or item == 0 then
        return
    end
    local _____914D_7F6E = _____5339_914D_4E3B_52A8_6280_80FD_69FD_4F4D_914D_7F6E(GetItemTypeId(item))
    if _____914D_7F6E == nil then
        return
    end
    _____540C_6B65_4E3B_52A8_7269_54C1_6280_80FD_58F3_547D_4EE4ID(unit, item, _____914D_7F6E)
    _____540C_6B65_4E3B_52A8_7269_54C1_6280_80FD_58F3_53C2_6570(unit, _____914D_7F6E)
end
local function ____on_4E3B_52A8_6280_80FD_7269_54C1_4E22_5F03(unit, item)
    local _____7269_54C1_53E5_67C4ID = _____53D6_7269_54C1_53E5_67C4ID(item)
    if _____7269_54C1_53E5_67C4ID > 0 then
        __TS__Delete(_____4E3B_52A8_7269_54C1_8FD0_884C_547D_4EE4ID_8868, _____7269_54C1_53E5_67C4ID)
    end
end
____exports["初始化主动技能壳参数同步"] = function()
    if _____5DF2_521D_59CB_5316_4E3B_52A8_6280_80FD_58F3_53C2_6570_540C_6B65 then
        return
    end
    _____5DF2_521D_59CB_5316_4E3B_52A8_6280_80FD_58F3_53C2_6570_540C_6B65 = true
    onItemPickup(____on_4E3B_52A8_6280_80FD_7269_54C1_62FE_53D6)
    onItemDrop(____on_4E3B_52A8_6280_80FD_7269_54C1_4E22_5F03)
end
return ____exports
