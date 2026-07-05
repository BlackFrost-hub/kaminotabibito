--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_914D_7F6E = ____require_result_1["获取单位玩家英雄配置"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_2.SGSS_SetState
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____require_result_3["造成装备伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.04．持有战斗周期模板")
local _____6CE8_518C_6301_6709_6218_6597_5468_671F_6A21_677F = ____require_result_4["注册持有战斗周期模板"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_5.getUnitsInRange
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_6["创建Dz绑定单位特效"]
local _____662F_5426_5DF2_6709Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_6["是否已有Dz绑定单位特效"]
local _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_6["销毁Dz绑定单位特效"]
local stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local _____51A5_708E_4E4B_88D9_914D_7F6E = {
    ["物品名"] = "冥炎之裙",
    ["女性全属性加成"] = 15,
    ["周期秒"] = 1,
    ["作用范围"] = 300,
    ["每层每秒火焰伤害"] = 200,
    ["特效路径"] = "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl",
    ["特效挂点"] = "origin",
    ["特效键"] = "装备:冥炎之裙"
}
local _____51A5_708E_4E4B_88D9_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName(_____51A5_708E_4E4B_88D9_914D_7F6E["物品名"]))
local _____5DF2_521D_59CB_5316_51A5_708E_4E4B_88D9 = false
local function _____5355_4F4D_662F_82F1_96C4(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true
end
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____5355_4F4D_662F_5973_6027_82F1_96C4(unit)
    if not _____5355_4F4D_662F_82F1_96C4(unit) then
        return false
    end
    local config = _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_914D_7F6E(unit)
    return config ~= nil and config.gender == "female"
end
local function _____79FB_9664_51A5_708E_4E4B_88D9_6301_6709_8005(unit)
    _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548(unit, _____51A5_708E_4E4B_88D9_914D_7F6E["特效键"])
end
local function _____540C_6B65_51A5_708E_4E4B_88D9_6301_6709_8868_73B0(unit, currentCount)
    if not _____5355_4F4D_662F_82F1_96C4(unit) or currentCount <= 0 then
        _____79FB_9664_51A5_708E_4E4B_88D9_6301_6709_8005(unit)
        return
    end
    if not _____662F_5426_5DF2_6709Dz_7ED1_5B9A_5355_4F4D_7279_6548(unit, _____51A5_708E_4E4B_88D9_914D_7F6E["特效键"]) then
        _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548(unit, _____51A5_708E_4E4B_88D9_914D_7F6E["特效挂点"], _____51A5_708E_4E4B_88D9_914D_7F6E["特效路径"], _____51A5_708E_4E4B_88D9_914D_7F6E["特效键"])
    end
end
local function _____8C03_6574_51A5_708E_4E4B_88D9_5973_6027_5168_5C5E_6027(unit, deltaCount)
    if not _____5355_4F4D_662F_5973_6027_82F1_96C4(unit) or deltaCount == 0 then
        return
    end
    SGSS_SetState(unit, 6, _____51A5_708E_4E4B_88D9_914D_7F6E["女性全属性加成"] * deltaCount)
end
local function ____on_83B7_5F97_51A5_708E_4E4B_88D9(unit, _item, currentCount, previousCount)
    if not _____5355_4F4D_662F_82F1_96C4(unit) then
        return
    end
    if previousCount <= 0 and currentCount > 0 then
        _____8C03_6574_51A5_708E_4E4B_88D9_5973_6027_5168_5C5E_6027(unit, 1)
    end
    _____540C_6B65_51A5_708E_4E4B_88D9_6301_6709_8868_73B0(unit, currentCount > 0 and 1 or 0)
end
local function ____on_5931_53BB_51A5_708E_4E4B_88D9(unit, _item, currentCount, previousCount)
    if not _____5355_4F4D_662F_82F1_96C4(unit) then
        return
    end
    if currentCount <= 0 and previousCount > 0 then
        _____8C03_6574_51A5_708E_4E4B_88D9_5973_6027_5168_5C5E_6027(unit, -1)
    end
    _____540C_6B65_51A5_708E_4E4B_88D9_6301_6709_8868_73B0(unit, currentCount > 0 and 1 or 0)
end
local function ____on_51A5_708E_4E4B_88D9_6218_6597_5468_671F(event)
    local unit = event["单位"]
    if not _____5355_4F4D_662F_82F1_96C4(unit) then
        _____79FB_9664_51A5_708E_4E4B_88D9_6301_6709_8005(unit)
        return
    end
    if not _____662F_5426_5DF2_6709Dz_7ED1_5B9A_5355_4F4D_7279_6548(unit, _____51A5_708E_4E4B_88D9_914D_7F6E["特效键"]) then
        _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548(unit, _____51A5_708E_4E4B_88D9_914D_7F6E["特效挂点"], _____51A5_708E_4E4B_88D9_914D_7F6E["特效路径"], _____51A5_708E_4E4B_88D9_914D_7F6E["特效键"])
    end
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return
    end
    local damage = _____51A5_708E_4E4B_88D9_914D_7F6E["每层每秒火焰伤害"]
    local targets = getUnitsInRange(
        GetUnitX(unit),
        GetUnitY(unit),
        _____51A5_708E_4E4B_88D9_914D_7F6E["作用范围"]
    )
    do
        local j = 0
        while j < #targets do
            do
                local target = targets[j + 1]
                if target == nil or target == 0 or target == unit then
                    goto __continue23
                end
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue23
                end
                _____9020_6210_88C5_5907_4F24_5BB3(
                    unit,
                    target,
                    damage,
                    DAMAGE_TYPE_FIRE,
                    true,
                    nil,
                    {["伤害形态"] = "AOE"}
                )
            end
            ::__continue23::
            j = j + 1
        end
    end
end
____exports["初始化冥炎之裙持有效果"] = function()
    if _____5DF2_521D_59CB_5316_51A5_708E_4E4B_88D9 then
        return
    end
    _____5DF2_521D_59CB_5316_51A5_708E_4E4B_88D9 = true
    if _____51A5_708E_4E4B_88D9_7269_54C1ID == 0 then
        return
    end
    _____6CE8_518C_6301_6709_6218_6597_5468_671F_6A21_677F({
        ["名称"] = "冥炎之裙",
        ["物品类型ID"] = _____51A5_708E_4E4B_88D9_7269_54C1ID,
        ["周期秒"] = _____51A5_708E_4E4B_88D9_914D_7F6E["周期秒"],
        ["主体类型"] = "玩家英雄",
        ["on获取"] = function(event)
            ____on_83B7_5F97_51A5_708E_4E4B_88D9(event["单位"], event["物品"], event["持有数量"], event["前次数量"])
        end,
        ["on丢弃"] = function(event)
            ____on_5931_53BB_51A5_708E_4E4B_88D9(event["单位"], event["物品"], event["持有数量"], event["前次数量"])
        end,
        ["on周期"] = ____on_51A5_708E_4E4B_88D9_6218_6597_5468_671F
    })
end
____exports["初始化冥炎之裙持有效果"]()
return ____exports
