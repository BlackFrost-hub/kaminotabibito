--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____7194_5CA9_5B9D_77F3_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["熔岩宝石配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_1["监听指定物品获取丢弃"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____9020_6210_706B_7130_4F24_5BB3 = ____require_result_3["造成火焰伤害"]
local _____53D6_6700_5927_751F_547D = ____require_result_3["取最大生命"]
local _____64AD_653E_70B9_7279_6548 = ____require_result_3["播放点特效"]
local _____53D6_5355_4F4DX = ____require_result_3["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_3["取单位Y"]
local _____5355_4F4D_5B58_6D3B = ____require_result_3["单位存活"]
local jass = require("jass.common")
local RemoveItem = jass.RemoveItem
local GetOwningPlayer = jass.GetOwningPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local function ____on_7194_5CA9_5B9D_77F3_83B7_5F97(unit, item, currentCount, previousCount)
    if currentCount <= 1 or previousCount <= 0 then
        return
    end
    if item ~= nil and item ~= 0 then
        RemoveItem(item)
    end
    DisplayTimedTextToPlayer(
        GetOwningPlayer(unit),
        0,
        0,
        10,
        _____7194_5CA9_5B9D_77F3_914D_7F6E["重复佩戴提示"]
    )
end
local function ____on_7194_5CA9_5B9D_77F3_8109_51B2(unit, target)
    local damage = _____7194_5CA9_5B9D_77F3_914D_7F6E["固定火焰伤害"] + _____53D6_6700_5927_751F_547D(unit) * _____7194_5CA9_5B9D_77F3_914D_7F6E["最大生命火焰伤害比例"]
    _____9020_6210_706B_7130_4F24_5BB3(unit, target, damage)
    _____64AD_653E_70B9_7279_6548(
        _____7194_5CA9_5B9D_77F3_914D_7F6E["特效路径"],
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target)
    )
end
local function ____on_7194_5CA9_5B9D_77F3_5468_671F(unit, currentCount)
    if currentCount <= 0 then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return
    end
    local targets = getUnitsInRange(
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        _____7194_5CA9_5B9D_77F3_914D_7F6E["作用范围"]
    )
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if target == nil or target == 0 or target == unit then
                    goto __continue10
                end
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue10
                end
                ____on_7194_5CA9_5B9D_77F3_8109_51B2(unit, target)
            end
            ::__continue10::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_7194_5CA9_5B9D_77F3()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["熔岩宝石"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["熔岩宝石"], ["间隔毫秒"] = _____7194_5CA9_5B9D_77F3_914D_7F6E["间隔毫秒"], ["周期回调"] = ____on_7194_5CA9_5B9D_77F3_5468_671F})
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____83B7_5F97_7269_54C1_88C5_5907ID["熔岩宝石"], ____on_7194_5CA9_5B9D_77F3_83B7_5F97)
end
_____521D_59CB_5316_7194_5CA9_5B9D_77F3()
return ____exports
