--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemDrop = ____require_result_0.onItemDrop
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____662F_73A9_5BB6_82F1_96C4_6216BB = ____require_result_2["是玩家英雄或BB"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.01．吃书清理")
local _____5904_7406_901A_7528_7269_54C1_5403_4E66_6E05_7406 = ____require_result_3["处理通用物品吃书清理"]
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.02．获取特效")
local _____5904_7406_901A_7528_7269_54C1_83B7_53D6_7279_6548 = ____require_result_4["处理通用物品获取特效"]
local ____require_result_5 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.03．合成打造")
local _____5904_7406_901A_7528_7269_54C1_5408_6210_6253_9020 = ____require_result_5["处理通用物品合成打造"]
local _____5904_7406_4E00_6B21_6027_6253_9020_58F3_5408_6210 = ____require_result_5["处理一次性打造壳合成"]
local ____require_result_6 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____662F_4E00_6B21_6027_6253_9020_58F3 = ____require_result_6["是一次性打造壳"]
local ____require_result_7 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.04．领取技能")
local _____5904_7406_901A_7528_7269_54C1_9886_53D6_6280_80FD = ____require_result_7["处理通用物品领取技能"]
local ____require_result_8 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.01．传送集合.index")
local _____5904_7406_4E07_6D74_7194_7075_4F20_9001_95E8 = ____require_result_8["处理万浴熔灵传送门"]
local _____5DF2_521D_59CB_5316_901A_7528_7269_54C1_62FE_53D6 = false
local _____6253_9020_58F3_80CC_5305_7A33_5B9A_7B49_5F85_6BEB_79D2 = 400
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local function ____on_901A_7528_7269_54C1_62FE_53D6(_____5355_4F4D, _____7269_54C1)
    if not _____662F_73A9_5BB6_82F1_96C4_6216BB(_____5355_4F4D) then
        return
    end
    if _____662F_4E00_6B21_6027_6253_9020_58F3(_____7269_54C1) then
        _____5904_7406_4E00_6B21_6027_6253_9020_58F3_5408_6210(
            _____5355_4F4D,
            GetItemTypeId(_____7269_54C1),
            _____7269_54C1
        )
        return
    end
    _____5904_7406_901A_7528_7269_54C1_5403_4E66_6E05_7406(_____5355_4F4D, _____7269_54C1)
    _____5904_7406_901A_7528_7269_54C1_83B7_53D6_7279_6548(_____5355_4F4D, _____7269_54C1)
    _____5904_7406_901A_7528_7269_54C1_5408_6210_6253_9020(_____5355_4F4D, _____7269_54C1)
    _____5904_7406_4E07_6D74_7194_7075_4F20_9001_95E8(_____5355_4F4D, _____7269_54C1)
    _____5904_7406_901A_7528_7269_54C1_9886_53D6_6280_80FD(_____5355_4F4D, _____7269_54C1)
end
local function _____6267_884C_5EF6_8FDF_6253_9020_58F3_5408_6210(_____4E0A_4E0B_6587)
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    _____5904_7406_4E00_6B21_6027_6253_9020_58F3_5408_6210(_____4E0A_4E0B_6587["单位"], _____4E0A_4E0B_6587["物品类型ID"], _____4E0A_4E0B_6587["物品"])
end
local function ____on_4E00_6B21_6027_6253_9020_58F3_4E22_5F03(_____5355_4F4D, _____7269_54C1)
    if not _____662F_73A9_5BB6_82F1_96C4_6216BB(_____5355_4F4D) or not _____662F_4E00_6B21_6027_6253_9020_58F3(_____7269_54C1) then
        return
    end
    local _____4E0A_4E0B_6587 = {
        ["单位"] = _____5355_4F4D,
        ["物品类型ID"] = GetItemTypeId(_____7269_54C1),
        ["物品"] = _____7269_54C1
    }
    addDelayedCallback(_____6253_9020_58F3_80CC_5305_7A33_5B9A_7B49_5F85_6BEB_79D2, _____6267_884C_5EF6_8FDF_6253_9020_58F3_5408_6210, _____4E0A_4E0B_6587)
end
local function _____521D_59CB_5316_901A_7528_7269_54C1()
    if _____5DF2_521D_59CB_5316_901A_7528_7269_54C1_62FE_53D6 then
        return
    end
    _____5DF2_521D_59CB_5316_901A_7528_7269_54C1_62FE_53D6 = true
    onItemPickup(____on_901A_7528_7269_54C1_62FE_53D6)
    onItemDrop(____on_4E00_6B21_6027_6253_9020_58F3_4E22_5F03)
end
_____521D_59CB_5316_901A_7528_7269_54C1()
do
    local ____export = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.01．吃书清理")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.02．获取特效")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.03．合成打造")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.04．领取技能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.01．传送集合.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
return ____exports
