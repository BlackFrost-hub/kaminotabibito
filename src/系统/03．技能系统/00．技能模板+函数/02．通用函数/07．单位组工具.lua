local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
--- 通用函数 - 单位组便捷工具
-- 
-- 提供单位组快照、伤害、Buff、过滤、排序等常用操作。
-- 统一收敛重复的 `快照单位组` 逻辑，并集成快速Buff系统。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setBuff = ____require_result_0.SFB_setBuff
local SFB_setSlow = ____require_result_0.SFB_setSlow
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local _____5FEB_7167_7F13_5B58 = {}
local function _____6536_96C6_6210_5458()
    local _____5355_4F4D = GetEnumUnit()
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
        _____5FEB_7167_7F13_5B58[#_____5FEB_7167_7F13_5B58 + 1] = _____5355_4F4D
    end
end
--- 将 JASS 单位组转为数组快照。
-- 使用 ForGroup + GetEnumUnit，与旧 JASS 模板兼容。
____exports["快照单位组"] = function(_____5355_4F4D_7EC4)
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return {}
    end
    _____5FEB_7167_7F13_5B58 = {}
    ForGroup(_____5355_4F4D_7EC4, _____6536_96C6_6210_5458)
    local _____7ED3_679C = _____5FEB_7167_7F13_5B58
    _____5FEB_7167_7F13_5B58 = {}
    return _____7ED3_679C
end
--- 对单位组内所有单位造成伤害
-- 
-- @param 单位列表 单位数组（可用 快照单位组 或 getUnitsInRange 的返回值）
-- @param 来源 伤害来源单位
-- @param 伤害值 伤害数值
-- @param 伤害类型 可选，默认 DAMAGE_TYPE_NORMAL
____exports["单位组造成伤害"] = function(_____5355_4F4D_5217_8868, _____6765_6E90, _____4F24_5BB3_503C, _____4F24_5BB3_7C7B_578B)
    if not _____5355_4F4D_5217_8868 or #_____5355_4F4D_5217_8868 == 0 then
        return
    end
    if _____4F24_5BB3_503C <= 0 then
        return
    end
    local ____4F24_5BB3_7C7B_578B_1 = _____4F24_5BB3_7C7B_578B
    if ____4F24_5BB3_7C7B_578B_1 == nil then
        ____4F24_5BB3_7C7B_578B_1 = jass.DAMAGE_TYPE_NORMAL
    end
    local _____7C7B_578B = ____4F24_5BB3_7C7B_578B_1
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local ____jass_UnitDamageTarget_3 = jass.UnitDamageTarget
        local ____6765_6E90_2 = _____6765_6E90
        if ____6765_6E90_2 == nil then
            ____6765_6E90_2 = _____5355_4F4D
        end
        ____jass_UnitDamageTarget_3(
            jass,
            ____6765_6E90_2,
            _____5355_4F4D,
            _____4F24_5BB3_503C,
            false,
            false,
            jass.ATTACK_TYPE_NORMAL,
            _____7C7B_578B,
            jass.WEAPON_TYPE_WHOKNOWS
        )
    end
end
--- 对单位组内所有单位施加控制 Buff
-- 
-- @param 单位列表 单位数组
-- @param 来源 Buff来源单位（用于BuffUI显示）
-- @param 控制ID Buff类型
-- @param 持续时间 秒
____exports["单位组施加控制"] = function(_____5355_4F4D_5217_8868, _____6765_6E90, _____63A7_5236ID, _____6301_7EED_65F6_95F4)
    if not _____5355_4F4D_5217_8868 or #_____5355_4F4D_5217_8868 == 0 then
        return
    end
    if _____6301_7EED_65F6_95F4 <= 0 then
        return
    end
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        SFB_setBuff(
            nil,
            _____6765_6E90,
            _____5355_4F4D,
            _____63A7_5236ID,
            _____6301_7EED_65F6_95F4
        )
    end
end
--- 对单位组内所有单位施加减速
-- 
-- @param 单位列表 单位数组
-- @param 来源 Buff来源单位
-- @param 降低攻速 百分比
-- @param 降低移速 百分比
-- @param 持续时间 秒
____exports["单位组施加减速"] = function(_____5355_4F4D_5217_8868, _____6765_6E90, _____964D_4F4E_653B_901F, _____964D_4F4E_79FB_901F, _____6301_7EED_65F6_95F4)
    if not _____5355_4F4D_5217_8868 or #_____5355_4F4D_5217_8868 == 0 then
        return
    end
    if _____6301_7EED_65F6_95F4 <= 0 then
        return
    end
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        SFB_setSlow(
            nil,
            _____6765_6E90,
            _____5355_4F4D,
            _____964D_4F4E_653B_901F,
            _____964D_4F4E_79FB_901F,
            _____6301_7EED_65F6_95F4
        )
    end
end
--- 按条件过滤单位数组
-- 
-- @param 单位列表 单位数组
-- @param 条件 过滤函数，返回 true 保留
____exports["单位组过滤"] = function(_____5355_4F4D_5217_8868, _____6761_4EF6)
    if not _____5355_4F4D_5217_8868 then
        return {}
    end
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        if _____6761_4EF6(_____5355_4F4D) then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____5355_4F4D
        end
    end
    return _____7ED3_679C
end
--- 只保留敌方单位
____exports["过滤敌方"] = function(_____5355_4F4D_5217_8868, _____6240_6709_8005)
    return ____exports["单位组过滤"](
        _____5355_4F4D_5217_8868,
        function(u) return jass:IsUnitEnemy(u, _____6240_6709_8005) end
    )
end
--- 只保留友方单位（不含自身）
____exports["过滤友方排除自身"] = function(_____5355_4F4D_5217_8868, _____6240_6709_8005)
    return ____exports["单位组过滤"](
        _____5355_4F4D_5217_8868,
        function(u) return u ~= _____6240_6709_8005 and jass:IsUnitAlly(u, _____6240_6709_8005) end
    )
end
--- 按距离指定坐标从近到远排序
____exports["单位组按距离排序"] = function(_____5355_4F4D_5217_8868, _____4E2D_5FC3X, _____4E2D_5FC3Y)
    if not _____5355_4F4D_5217_8868 then
        return {}
    end
    local _____62F7_8D1D = {table.unpack(_____5355_4F4D_5217_8868)}
    __TS__ArraySort(
        _____62F7_8D1D,
        function(____, a, b)
            local dxA = jass:GetUnitX(a) - _____4E2D_5FC3X
            local dyA = jass:GetUnitY(a) - _____4E2D_5FC3Y
            local dxB = jass:GetUnitX(b) - _____4E2D_5FC3X
            local dyB = jass:GetUnitY(b) - _____4E2D_5FC3Y
            return dxA * dxA + dyA * dyA - (dxB * dxB + dyB * dyB)
        end
    )
    return _____62F7_8D1D
end
--- 按生命值从低到高排序
____exports["单位组按生命排序"] = function(_____5355_4F4D_5217_8868)
    if not _____5355_4F4D_5217_8868 then
        return {}
    end
    local _____62F7_8D1D = {table.unpack(_____5355_4F4D_5217_8868)}
    __TS__ArraySort(
        _____62F7_8D1D,
        function(____, a, b)
            return jass:GetUnitState(a, jass.UNIT_STATE_LIFE) - jass:GetUnitState(b, jass.UNIT_STATE_LIFE)
        end
    )
    return _____62F7_8D1D
end
return ____exports
