--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_2.doHeal
local ____require_result_3 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_3["按名字反查物品ID"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local GetItemCharges = jass.GetItemCharges
local SetItemCharges = jass.SetItemCharges
local UnitItemInSlot = jass.UnitItemInSlot
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____89E6_624B_6B8B_7247_914D_7F6E = {["物品名"] = "|cFF800000触手残片|r", ["触发最低已有次数"] = 2, ["每次拾取治疗已损生命比例"] = 0.2, ["最大次数"] = 5}
local _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____89E6_624B_6B8B_7247_914D_7F6E["物品名"]))
local _____5F85_5904_7406_89E6_624B_6B8B_7247_62FE_53D6_5217_8868 = {}
local _____5DF2_5B89_6392_89E6_624B_6B8B_7247_62FE_53D6_5904_7406 = false
local function _____67E5_627E_5355_4F4D_89E6_624B_6B8B_7247(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID == 0 then
        return nil
    end
    do
        local _____69FD_4F4D = 0
        while _____69FD_4F4D < 6 do
            local _____7269_54C1 = UnitItemInSlot(_____5355_4F4D, _____69FD_4F4D)
            if _____7269_54C1 ~= nil and _____7269_54C1 ~= 0 and GetItemTypeId(_____7269_54C1) == _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID then
                return _____7269_54C1
            end
            _____69FD_4F4D = _____69FD_4F4D + 1
        end
    end
    return nil
end
local function _____5904_7406_5355_4E2A_89E6_624B_6B8B_7247_62FE_53D6(_____5355_4F4D, _____62FE_53D6_6B21_6570)
    local _____89E6_624B_6B8B_7247 = _____67E5_627E_5355_4F4D_89E6_624B_6B8B_7247(_____5355_4F4D)
    if _____89E6_624B_6B8B_7247 == nil or _____89E6_624B_6B8B_7247 == 0 then
        return
    end
    local _____5F53_524D_6B21_6570 = GetItemCharges(_____89E6_624B_6B8B_7247)
    if _____5F53_524D_6B21_6570 > _____89E6_624B_6B8B_7247_914D_7F6E["最大次数"] then
        SetItemCharges(_____89E6_624B_6B8B_7247, _____89E6_624B_6B8B_7247_914D_7F6E["最大次数"])
    end
    if _____62FE_53D6_6B21_6570 ~= 1 then
        return
    end
    if _____5F53_524D_6B21_6570 < _____89E6_624B_6B8B_7247_914D_7F6E["触发最低已有次数"] + 1 then
        return
    end
    local _____5DF2_635F_751F_547D = GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_LIFE) - GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE)
    if _____5DF2_635F_751F_547D <= 0 then
        return
    end
    doHeal({
        HealSource = _____5355_4F4D,
        HealTarget = _____5355_4F4D,
        HealAmount = _____5DF2_635F_751F_547D * _____89E6_624B_6B8B_7247_914D_7F6E["每次拾取治疗已损生命比例"],
        ItemHeal = true,
        HealEffect = true
    })
end
local function _____5904_7406_5F85_5904_7406_89E6_624B_6B8B_7247_62FE_53D6()
    _____5DF2_5B89_6392_89E6_624B_6B8B_7247_62FE_53D6_5904_7406 = false
    while #_____5F85_5904_7406_89E6_624B_6B8B_7247_62FE_53D6_5217_8868 > 0 do
        do
            local _____4E0A_4E0B_6587 = table.remove(_____5F85_5904_7406_89E6_624B_6B8B_7247_62FE_53D6_5217_8868, 1)
            if _____4E0A_4E0B_6587 == nil then
                goto __continue14
            end
            _____5904_7406_5355_4E2A_89E6_624B_6B8B_7247_62FE_53D6(_____4E0A_4E0B_6587["单位"], _____4E0A_4E0B_6587["拾取次数"])
        end
        ::__continue14::
    end
end
local function ____on_89E6_624B_6B8B_7247_62FE_53D6(_____5355_4F4D, _____7269_54C1)
    if _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID == 0 then
        return
    end
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    if GetItemTypeId(_____7269_54C1) ~= _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID then
        return
    end
    _____5F85_5904_7406_89E6_624B_6B8B_7247_62FE_53D6_5217_8868[#_____5F85_5904_7406_89E6_624B_6B8B_7247_62FE_53D6_5217_8868 + 1] = {
        ["单位"] = _____5355_4F4D,
        ["拾取次数"] = GetItemCharges(_____7269_54C1)
    }
    if _____5DF2_5B89_6392_89E6_624B_6B8B_7247_62FE_53D6_5904_7406 then
        return
    end
    _____5DF2_5B89_6392_89E6_624B_6B8B_7247_62FE_53D6_5904_7406 = true
    addDelayedCallback(10, _____5904_7406_5F85_5904_7406_89E6_624B_6B8B_7247_62FE_53D6)
end
local function _____521D_59CB_5316_89E6_624B_6B8B_7247()
    if _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID == 0 then
        return
    end
    onItemPickup(____on_89E6_624B_6B8B_7247_62FE_53D6)
end
_____521D_59CB_5316_89E6_624B_6B8B_7247()
return ____exports
