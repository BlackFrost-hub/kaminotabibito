--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.01．吃书清理")
local _____5904_7406_901A_7528_7269_54C1_5403_4E66_6E05_7406 = ____require_result_2["处理通用物品吃书清理"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.02．获取特效")
local _____5904_7406_901A_7528_7269_54C1_83B7_53D6_7279_6548 = ____require_result_3["处理通用物品获取特效"]
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.03．合成打造")
local _____5904_7406_901A_7528_7269_54C1_5408_6210_6253_9020 = ____require_result_4["处理通用物品合成打造"]
local ____require_result_5 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.04．领取技能")
local _____5904_7406_901A_7528_7269_54C1_9886_53D6_6280_80FD = ____require_result_5["处理通用物品领取技能"]
local ____require_result_6 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.01．传送集合.index")
local _____5904_7406_4E07_6D74_7194_7075_4F20_9001_95E8 = ____require_result_6["处理万浴熔灵传送门"]
local _____5DF2_521D_59CB_5316_901A_7528_7269_54C1_62FE_53D6 = false
local function ____on_901A_7528_7269_54C1_62FE_53D6(_____5355_4F4D, _____7269_54C1)
    if not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____5355_4F4D) then
        return
    end
    _____5904_7406_901A_7528_7269_54C1_5403_4E66_6E05_7406(_____5355_4F4D, _____7269_54C1)
    _____5904_7406_901A_7528_7269_54C1_83B7_53D6_7279_6548(_____5355_4F4D, _____7269_54C1)
    _____5904_7406_901A_7528_7269_54C1_5408_6210_6253_9020(_____5355_4F4D, _____7269_54C1)
    _____5904_7406_4E07_6D74_7194_7075_4F20_9001_95E8(_____5355_4F4D, _____7269_54C1)
    _____5904_7406_901A_7528_7269_54C1_9886_53D6_6280_80FD(_____5355_4F4D, _____7269_54C1)
end
local function _____521D_59CB_5316_901A_7528_7269_54C1()
    if _____5DF2_521D_59CB_5316_901A_7528_7269_54C1_62FE_53D6 then
        return
    end
    _____5DF2_521D_59CB_5316_901A_7528_7269_54C1_62FE_53D6 = true
    onItemPickup(____on_901A_7528_7269_54C1_62FE_53D6)
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
