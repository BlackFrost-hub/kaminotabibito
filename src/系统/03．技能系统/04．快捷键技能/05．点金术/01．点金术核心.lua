--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_70B9_91D1_672F_914D_7F6E = require("系统.03．技能系统.04．快捷键技能.05．点金术.00．点金术配置")
local _____70B9_91D1_672F_914D_7F6E = ____00_FF0E_70B9_91D1_672F_914D_7F6E["点金术配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_1["解析配置内部ID"]
local _____89E3_6790_914D_7F6E_5185_90E8ID_5217_8868 = ____require_result_1["解析配置内部ID列表"]
local ____require_result_2 = require("lib.扩展函数.物品相关函数.装备数据查询")
local getItemDataEntry = ____require_result_2.getItemDataEntry
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_3.createTimedEffect
local ____require_result_4 = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字")
local _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57 = ____require_result_4["显示单位数值漂浮文字"]
local GetItemTypeId = jass.GetItemTypeId
local GetSpellTargetItem = jass.GetSpellTargetItem
local GetItemType = jass.GetItemType
local GetItemCharges = jass.GetItemCharges
local GetItemName = jass.GetItemName
local GetItemX = jass.GetItemX
local GetItemY = jass.GetItemY
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerState = jass.GetPlayerState
local SetPlayerState = jass.SetPlayerState
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local RemoveItem = jass.RemoveItem
local R2I = jass.R2I
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
local ITEM_TYPE_PURCHASABLE = jass.ITEM_TYPE_PURCHASABLE
local ITEM_TYPE_CHARGED = jass.ITEM_TYPE_CHARGED
local _____70B9_91D1_672F_6280_80FD_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____70B9_91D1_672F_914D_7F6E["技能ID"])
local _____7279_6B8A_4EF7_683C_7269_54C1_7C7B_578BID_5217_8868 = _____89E3_6790_914D_7F6E_5185_90E8ID_5217_8868(_____70B9_91D1_672F_914D_7F6E["特殊价格物品ID列表"])
local _____7981_6B62_7269_54C1_7C7B_578BID_5217_8868 = _____89E3_6790_914D_7F6E_5185_90E8ID_5217_8868(_____70B9_91D1_672F_914D_7F6E["禁止物品ID列表"])
local _____5DF2_521D_59CB_5316_70B9_91D1_672F = false
local function _____5217_8868_5305_542B(_____5217_8868, _____7269_54C1_7C7B_578BID)
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____5217_8868[i + 1] == _____7269_54C1_7C7B_578BID then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____8BFB_53D6_70B9_91D1_57FA_7840_4EF7_683C(_____7269_54C1)
    local _____6570_636E = getItemDataEntry(_____7269_54C1)
    if _____6570_636E == nil or type(_____6570_636E.goldPrice) ~= "number" then
        return nil
    end
    local _____7269_54C1_7C7B_578B = GetItemType(_____7269_54C1)
    local _____5145_80FD_6570 = GetItemCharges(_____7269_54C1)
    local _____6309_5145_80FD_8BA1_4EF7 = _____7269_54C1_7C7B_578B == ITEM_TYPE_PURCHASABLE or _____7269_54C1_7C7B_578B == ITEM_TYPE_CHARGED
    if _____6309_5145_80FD_8BA1_4EF7 and _____5145_80FD_6570 > 0 then
        return R2I(_____6570_636E.goldPrice * _____5145_80FD_6570)
    end
    return R2I(_____6570_636E.goldPrice)
end
local function _____663E_793A_70B9_91D1_5931_8D25(_____73A9_5BB6, _____7269_54C1)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____7269_54C1_540D = _____7269_54C1 ~= nil and _____7269_54C1 ~= 0 and GetItemName(_____7269_54C1) or "该物品"
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        15,
        (("|cFFFFFF00『系统提示』：|r" .. _____70B9_91D1_672F_914D_7F6E["失败提示前缀"]) .. _____7269_54C1_540D) .. "』无法点金"
    )
end
local function _____589E_52A0_73A9_5BB6_91D1_5E01(_____73A9_5BB6, _____91D1_5E01)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____5F53_524D_91D1_5E01 = GetPlayerState(_____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD)
    SetPlayerState(_____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD, _____5F53_524D_91D1_5E01 + _____91D1_5E01)
end
local function _____5904_7406_70B9_91D1_672F_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____6280_80FDID ~= _____70B9_91D1_672F_6280_80FD_7C7B_578BID then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    local _____76EE_6807_7269_54C1 = GetSpellTargetItem()
    if _____76EE_6807_7269_54C1 == nil or _____76EE_6807_7269_54C1 == 0 then
        _____663E_793A_70B9_91D1_5931_8D25(_____73A9_5BB6, nil)
        return
    end
    local _____7269_54C1_7C7B_578BID = GetItemTypeId(_____76EE_6807_7269_54C1)
    if _____5217_8868_5305_542B(_____7981_6B62_7269_54C1_7C7B_578BID_5217_8868, _____7269_54C1_7C7B_578BID) then
        _____663E_793A_70B9_91D1_5931_8D25(_____73A9_5BB6, _____76EE_6807_7269_54C1)
        return
    end
    local _____521D_59CB_4EF7_683C = _____8BFB_53D6_70B9_91D1_57FA_7840_4EF7_683C(_____76EE_6807_7269_54C1)
    if _____521D_59CB_4EF7_683C == nil then
        _____663E_793A_70B9_91D1_5931_8D25(_____73A9_5BB6, _____76EE_6807_7269_54C1)
        return
    end
    local _____4EF7_683C_5206_6BCD = _____5217_8868_5305_542B(_____7279_6B8A_4EF7_683C_7269_54C1_7C7B_578BID_5217_8868, _____7269_54C1_7C7B_578BID) and _____70B9_91D1_672F_914D_7F6E["特殊价格分母"] or _____70B9_91D1_672F_914D_7F6E["默认价格分母"]
    local _____83B7_5F97_91D1_5E01 = R2I(_____521D_59CB_4EF7_683C / _____4EF7_683C_5206_6BCD)
    local _____7269_54C1X = GetItemX(_____76EE_6807_7269_54C1)
    local _____7269_54C1Y = GetItemY(_____76EE_6807_7269_54C1)
    _____589E_52A0_73A9_5BB6_91D1_5E01(_____73A9_5BB6, _____83B7_5F97_91D1_5E01)
    _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(_____65BD_6CD5_5355_4F4D, _____83B7_5F97_91D1_5E01, {
        ["大小"] = 12,
        ["红"] = 255,
        ["绿"] = 255,
        ["蓝"] = 0,
        ["持续时间"] = 1,
        ["上飘速度"] = 0.07
    })
    createTimedEffect(
        _____70B9_91D1_672F_914D_7F6E["成功特效路径"],
        _____7269_54C1X,
        _____7269_54C1Y,
        0,
        _____70B9_91D1_672F_914D_7F6E["成功特效持续秒"]
    )
    RemoveItem(_____76EE_6807_7269_54C1)
end
____exports["init点金术"] = function()
    if _____5DF2_521D_59CB_5316_70B9_91D1_672F then
        return
    end
    _____5DF2_521D_59CB_5316_70B9_91D1_672F = true
    registerSpellEffectListener(_____5904_7406_70B9_91D1_672F_751F_6548)
end
return ____exports
