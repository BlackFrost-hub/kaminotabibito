--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心")
local registerHeroLevelListener = ____require_result_0.registerHeroLevelListener
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_1.onItemPickup
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.09．物品升级.00．升级属性加成")
local _____5904_7406_5355_4F4D_5347_7EA7_5C5E_6027_52A0_6210 = ____require_result_2["处理单位升级属性加成"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.09．物品升级.02．物品升级配置表")
local _____7269_54C1_5347_7EA7_89C4_5219_8868 = ____require_result_3["物品升级规则表"]
local GetItemTypeId = jass.GetItemTypeId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local _____5DF2_521D_59CB_5316_7269_54C1_5347_7EA7 = false
local function _____662F_82F1_96C4_5355_4F4D(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return IsUnitType(_____5355_4F4D, UNIT_TYPE_HERO) == true
end
local function ____on_7269_54C1_5347_7EA7_82F1_96C4_5347_7EA7(_____82F1_96C4_5355_4F4D)
    if not _____662F_82F1_96C4_5355_4F4D(_____82F1_96C4_5355_4F4D) then
        return
    end
    _____5904_7406_5355_4F4D_5347_7EA7_5C5E_6027_52A0_6210(_____82F1_96C4_5355_4F4D)
    do
        local i = 0
        while i < #_____7269_54C1_5347_7EA7_89C4_5219_8868 do
            local _____89C4_5219 = _____7269_54C1_5347_7EA7_89C4_5219_8868[i + 1]
            local ____opt_4 = _____89C4_5219["处理升级"]
            if ____opt_4 ~= nil then
                ____opt_4(_____82F1_96C4_5355_4F4D)
            end
            i = i + 1
        end
    end
end
local function ____on_7269_54C1_5347_7EA7_62FE_53D6(_____5355_4F4D, _____7269_54C1)
    if not _____662F_82F1_96C4_5355_4F4D(_____5355_4F4D) then
        return
    end
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    local _____7269_54C1_7C7B_578BID = GetItemTypeId(_____7269_54C1)
    do
        local i = 0
        while i < #_____7269_54C1_5347_7EA7_89C4_5219_8868 do
            do
                local _____89C4_5219 = _____7269_54C1_5347_7EA7_89C4_5219_8868[i + 1]
                if _____89C4_5219["物品类型ID"] ~= _____7269_54C1_7C7B_578BID then
                    goto __continue12
                end
                local ____opt_6 = _____89C4_5219["处理拾取"]
                if ____opt_6 ~= nil then
                    ____opt_6(_____5355_4F4D)
                end
            end
            ::__continue12::
            i = i + 1
        end
    end
end
____exports["初始化物品升级"] = function()
    if _____5DF2_521D_59CB_5316_7269_54C1_5347_7EA7 then
        return
    end
    _____5DF2_521D_59CB_5316_7269_54C1_5347_7EA7 = true
    registerHeroLevelListener(____on_7269_54C1_5347_7EA7_82F1_96C4_5347_7EA7)
    onItemPickup(____on_7269_54C1_5347_7EA7_62FE_53D6)
end
____exports["初始化物品升级"]()
return ____exports
