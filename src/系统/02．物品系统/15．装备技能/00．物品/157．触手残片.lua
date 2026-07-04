--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.18．尝试拾取物品中心")
local onTryPickupItem = ____require_result_0.onTryPickupItem
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____6062_590D_751F_547D_9B54_6CD5 = ____require_result_1["恢复生命魔法"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.12．物品与单位")
local _____83B7_53D6_5355_4F4D_6307_5B9A_7269_54C1 = ____require_result_2["获取单位指定物品"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.25．延迟批处理队列")
local _____521B_5EFA_5EF6_8FDF_6279_5904_7406_961F_5217 = ____require_result_3["创建延迟批处理队列"]
local ____require_result_4 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_4["按名字反查物品ID"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local GetItemCharges = jass.GetItemCharges
local SetItemCharges = jass.SetItemCharges
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____89E6_624B_6B8B_7247_914D_7F6E = {["物品名"] = "|cFF800000触手残片|r", ["触发最低已有次数"] = 2, ["每次拾取治疗已损生命比例"] = 0.2, ["最大次数"] = 5}
local _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____89E6_624B_6B8B_7247_914D_7F6E["物品名"]))
local function _____67E5_627E_5355_4F4D_89E6_624B_6B8B_7247(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID == 0 then
        return nil
    end
    return _____83B7_53D6_5355_4F4D_6307_5B9A_7269_54C1(_____5355_4F4D, _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID)
end
local function _____5904_7406_5355_4E2A_89E6_624B_6B8B_7247_62FE_53D6(_____5355_4F4D, _____62FE_53D6_524D_5DF2_6709_6B21_6570, _____62FE_53D6_6B21_6570)
    local _____89E6_624B_6B8B_7247 = _____67E5_627E_5355_4F4D_89E6_624B_6B8B_7247(_____5355_4F4D)
    if _____89E6_624B_6B8B_7247 == nil or _____89E6_624B_6B8B_7247 == 0 then
        return
    end
    local _____5F53_524D_6B21_6570 = GetItemCharges(_____89E6_624B_6B8B_7247)
    local _____5DF2_5B9E_9645_62FE_53D6_5230_6B8B_7247 = _____5F53_524D_6B21_6570 > _____62FE_53D6_524D_5DF2_6709_6B21_6570
    if _____5F53_524D_6B21_6570 > _____89E6_624B_6B8B_7247_914D_7F6E["最大次数"] then
        SetItemCharges(_____89E6_624B_6B8B_7247, _____89E6_624B_6B8B_7247_914D_7F6E["最大次数"])
    end
    if not _____5DF2_5B9E_9645_62FE_53D6_5230_6B8B_7247 then
        return
    end
    if _____62FE_53D6_6B21_6570 ~= 1 then
        return
    end
    if _____62FE_53D6_524D_5DF2_6709_6B21_6570 < _____89E6_624B_6B8B_7247_914D_7F6E["触发最低已有次数"] then
        return
    end
    local _____5DF2_635F_751F_547D = GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_LIFE) - GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE)
    if _____5DF2_635F_751F_547D <= 0 then
        return
    end
    _____6062_590D_751F_547D_9B54_6CD5(_____5355_4F4D, _____5355_4F4D, _____5DF2_635F_751F_547D * _____89E6_624B_6B8B_7247_914D_7F6E["每次拾取治疗已损生命比例"])
end
local _____89E6_624B_6B8B_7247_62FE_53D6_786E_8BA4_961F_5217 = _____521B_5EFA_5EF6_8FDF_6279_5904_7406_961F_5217(
    "触手残片拾取确认",
    {
        ["延迟毫秒"] = 10,
        ["处理"] = function(_____4E0A_4E0B_6587)
            _____5904_7406_5355_4E2A_89E6_624B_6B8B_7247_62FE_53D6(_____4E0A_4E0B_6587["单位"], _____4E0A_4E0B_6587["拾取前已有次数"], _____4E0A_4E0B_6587["拾取次数"])
        end
    }
)
local function ____on_89E6_624B_6B8B_7247_5C1D_8BD5_62FE_53D6(_____5355_4F4D, _____7269_54C1)
    if _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID == 0 then
        return
    end
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    if GetItemTypeId(_____7269_54C1) ~= _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID then
        return
    end
    local _____5DF2_6301_6709_89E6_624B_6B8B_7247 = _____67E5_627E_5355_4F4D_89E6_624B_6B8B_7247(_____5355_4F4D)
    local _____62FE_53D6_524D_5DF2_6709_6B21_6570 = _____5DF2_6301_6709_89E6_624B_6B8B_7247 ~= nil and _____5DF2_6301_6709_89E6_624B_6B8B_7247 ~= 0 and GetItemCharges(_____5DF2_6301_6709_89E6_624B_6B8B_7247) or 0
    _____89E6_624B_6B8B_7247_62FE_53D6_786E_8BA4_961F_5217["加入"]({
        ["单位"] = _____5355_4F4D,
        ["拾取前已有次数"] = _____62FE_53D6_524D_5DF2_6709_6B21_6570,
        ["拾取次数"] = GetItemCharges(_____7269_54C1)
    })
end
local function _____521D_59CB_5316_89E6_624B_6B8B_7247()
    if _____89E6_624B_6B8B_7247_7269_54C1_7C7B_578BID == 0 then
        return
    end
    onTryPickupItem(____on_89E6_624B_6B8B_7247_5C1D_8BD5_62FE_53D6)
end
_____521D_59CB_5316_89E6_624B_6B8B_7247()
return ____exports
