local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_5355_4F4DID, ____on_7194_5CA9_5B9D_77F3_8109_51B2, ____on_7194_5CA9_5B9D_77F3_6218_6597_5468_671F, _____52A0_5165_7194_5CA9_5B9D_77F3_6218_6597_72B6_6001, _____79FB_9664_7194_5CA9_5B9D_77F3_6218_6597_72B6_6001, _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF, _____521B_5EFA_6218_6597_72B6_6001_89E6_53D1_5668, getUnitsInRange, _____9020_6210_706B_7130_4F24_5BB3, _____53D6_6700_5927_751F_547D, _____64AD_653E_70B9_7279_6548, _____53D6_5355_4F4DX, _____53D6_5355_4F4DY, _____5355_4F4D_5B58_6D3B, GetHandleId, _____7194_5CA9_5B9D_77F3_6218_6597_72B6_6001_8868
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____7194_5CA9_5B9D_77F3_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["熔岩宝石配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
function ____on_7194_5CA9_5B9D_77F3_8109_51B2(unit, target)
    local damage = _____7194_5CA9_5B9D_77F3_914D_7F6E["固定火焰伤害"] + _____53D6_6700_5927_751F_547D(unit) * _____7194_5CA9_5B9D_77F3_914D_7F6E["最大生命火焰伤害比例"]
    _____9020_6210_706B_7130_4F24_5BB3(unit, target, damage)
    _____64AD_653E_70B9_7279_6548(
        _____7194_5CA9_5B9D_77F3_914D_7F6E["特效路径"],
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target)
    )
end
function ____on_7194_5CA9_5B9D_77F3_6218_6597_5468_671F(event)
    local unit = event["单位"]
    local currentCount = _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(unit, _____83B7_5F97_7269_54C1_88C5_5907ID["熔岩宝石"])
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
                    goto __continue15
                end
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue15
                end
                ____on_7194_5CA9_5B9D_77F3_8109_51B2(unit, target)
            end
            ::__continue15::
            i = i + 1
        end
    end
end
function _____52A0_5165_7194_5CA9_5B9D_77F3_6218_6597_72B6_6001(unit)
    local unitId = _____53D6_5355_4F4DID(unit)
    if unitId == 0 or _____7194_5CA9_5B9D_77F3_6218_6597_72B6_6001_8868[unitId] ~= nil then
        return
    end
    _____7194_5CA9_5B9D_77F3_6218_6597_72B6_6001_8868[unitId] = _____521B_5EFA_6218_6597_72B6_6001_89E6_53D1_5668({
        ["名称"] = "熔岩宝石",
        ["单位"] = unit,
        ["主体类型"] = "玩家英雄",
        ["周期触发秒"] = _____7194_5CA9_5B9D_77F3_914D_7F6E["间隔毫秒"] / 1000,
        ["on周期触发"] = ____on_7194_5CA9_5B9D_77F3_6218_6597_5468_671F
    })
end
function _____79FB_9664_7194_5CA9_5B9D_77F3_6218_6597_72B6_6001(unit)
    local unitId = _____53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    local _____63A7_5236_5668 = _____7194_5CA9_5B9D_77F3_6218_6597_72B6_6001_8868[unitId]
    if _____63A7_5236_5668 ~= nil then
        _____63A7_5236_5668["停止"]()
        __TS__Delete(_____7194_5CA9_5B9D_77F3_6218_6597_72B6_6001_8868, unitId)
    end
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_0["监听指定物品获取丢弃"]
_____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF = ____require_result_0["获取单位当前持有指定物品数量"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.07．战斗状态触发器")
_____521B_5EFA_6218_6597_72B6_6001_89E6_53D1_5668 = ____require_result_1["创建战斗状态触发器"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
_____9020_6210_706B_7130_4F24_5BB3 = ____require_result_3["造成火焰伤害"]
_____53D6_6700_5927_751F_547D = ____require_result_3["取最大生命"]
_____64AD_653E_70B9_7279_6548 = ____require_result_3["播放点特效"]
_____53D6_5355_4F4DX = ____require_result_3["取单位X"]
_____53D6_5355_4F4DY = ____require_result_3["取单位Y"]
_____5355_4F4D_5B58_6D3B = ____require_result_3["单位存活"]
local jass = require("jass.common")
GetHandleId = jass.GetHandleId
local RemoveItem = jass.RemoveItem
local GetOwningPlayer = jass.GetOwningPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
_____7194_5CA9_5B9D_77F3_6218_6597_72B6_6001_8868 = {}
local function ____on_7194_5CA9_5B9D_77F3_83B7_5F97(unit, item, currentCount, previousCount)
    if currentCount > 1 and previousCount > 0 then
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
    if currentCount > 0 then
        _____52A0_5165_7194_5CA9_5B9D_77F3_6218_6597_72B6_6001(unit)
    end
end
local function ____on_7194_5CA9_5B9D_77F3_5931_53BB(unit, _item, currentCount, _previousCount)
    if currentCount <= 0 then
        _____79FB_9664_7194_5CA9_5B9D_77F3_6218_6597_72B6_6001(unit)
    end
end
local function _____521D_59CB_5316_7194_5CA9_5B9D_77F3()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["熔岩宝石"] == 0 then
        return
    end
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____83B7_5F97_7269_54C1_88C5_5907ID["熔岩宝石"], ____on_7194_5CA9_5B9D_77F3_83B7_5F97, ____on_7194_5CA9_5B9D_77F3_5931_53BB)
end
_____521D_59CB_5316_7194_5CA9_5B9D_77F3()
return ____exports
