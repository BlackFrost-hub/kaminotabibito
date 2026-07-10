--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____6062_590D_751F_547D_9B54_6CD5 = ____require_result_0["恢复生命魔法"]
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_1["按名字反查物品ID"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品叠加函数")
local onAnyUnitItemStacked = ____require_result_3.onAnyUnitItemStacked
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local SetItemCharges = jass.SetItemCharges
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____89E6_624B_6B8B_7247_914D_7F6E = {["物品名"] = "|cFF800000触手残片|r", ["触发最低已有次数"] = 2, ["每次拾取治疗已损生命比例"] = 0.2, ["最大次数"] = 5}
local _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____89E6_624B_6B8B_7247_914D_7F6E["物品名"]))
local function ____on_89E6_624B_6B8B_7247_53E0_52A0(_____5355_4F4D, _____5408_5E76_540E_7269_54C1, _____88AB_53E0_52A0_7269_54C1, _____53E0_52A0_524D_6B21_6570, _____65B0_589E_6B21_6570, _____53E0_52A0_540E_6B21_6570)
    if _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID == 0 then
        return
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if _____5408_5E76_540E_7269_54C1 == nil or _____5408_5E76_540E_7269_54C1 == 0 then
        return
    end
    if _____88AB_53E0_52A0_7269_54C1 == nil or _____88AB_53E0_52A0_7269_54C1 == 0 then
        return
    end
    if GetItemTypeId(_____5408_5E76_540E_7269_54C1) ~= _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID then
        return
    end
    if GetItemTypeId(_____88AB_53E0_52A0_7269_54C1) ~= _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID then
        return
    end
    if _____53E0_52A0_540E_6B21_6570 > _____89E6_624B_6B8B_7247_914D_7F6E["最大次数"] then
        SetItemCharges(_____5408_5E76_540E_7269_54C1, _____89E6_624B_6B8B_7247_914D_7F6E["最大次数"])
    end
    if _____65B0_589E_6B21_6570 ~= 1 then
        return
    end
    if _____53E0_52A0_524D_6B21_6570 < _____89E6_624B_6B8B_7247_914D_7F6E["触发最低已有次数"] then
        return
    end
    local _____5DF2_635F_751F_547D = GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_LIFE) - GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE)
    if _____5DF2_635F_751F_547D <= 0 then
        return
    end
    _____6062_590D_751F_547D_9B54_6CD5(_____5355_4F4D, _____5355_4F4D, _____5DF2_635F_751F_547D * _____89E6_624B_6B8B_7247_914D_7F6E["每次拾取治疗已损生命比例"])
end
local function _____521D_59CB_5316_89E6_624B_6B8B_7247()
    if _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID == 0 then
        return
    end
    onAnyUnitItemStacked(____on_89E6_624B_6B8B_7247_53E0_52A0)
end
_____521D_59CB_5316_89E6_624B_6B8B_7247()
return ____exports
