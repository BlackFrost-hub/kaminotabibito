--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - 单位基础函数
-- 
-- 来源于 StarUnit.j，提供单位基础操作功能。
-- 
-- 公开接口：
--   SU_IsUnitInvincible(u)        - 判断单位是否无敌
--   SU_SetUnitFlyHeight(u, h, r)  - 设置单位飞行高度（自动添加飞行能力）
--   SU_GetHeroAllState(u, b)      - 获取英雄全属性
--   SU_GetUnitLostHPPercent(u)    - 获取单位已损失生命值百分比
--   SU_GetUnitLostHP(u)           - 获取单位已损失生命值
--   UnitAddHp(u, value, b)        - 为单位添加生命值（支持百分比）
--   SU_IsUnitDie(u)               - 判断单位是否死亡（高精度）
--   SU_ShowOrHideUnit(u, isShow)  - 设置单位可见性
local jass = require("jass.common")
--- 判断单位是否无敌
-- 检查 'Avul'(无敌技能)、'Bvul'(无敌Buff)、'BHds'(神圣护甲)
-- 
-- @param u 目标单位
-- @returns 是否无敌
function ____exports.SU_IsUnitInvincible(self, u)
    if u == nil or u == 0 then
        return false
    end
    local ____temp_0
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_0 = jass.GetUnitAbilityLevel(u, 1098282348)
    else
        ____temp_0 = 0
    end
    local avul = ____temp_0
    local ____temp_1
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_1 = jass.GetUnitAbilityLevel(u, 1115059564)
    else
        ____temp_1 = 0
    end
    local bvul = ____temp_1
    local ____temp_2
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_2 = jass.GetUnitAbilityLevel(u, 1112040563)
    else
        ____temp_2 = 0
    end
    local bhds = ____temp_2
    return avul ~= 0 or bvul ~= 0 or bhds ~= 0
end
--- 设置单位飞行高度（自动添加飞行能力）
-- 通过临时添加 'Amrf'(乌鸦形态) 技能让单位可以飞行
-- 
-- @param whichUnit 目标单位
-- @param newHeight 新的飞行高度
-- @param rate 变换速率
function ____exports.SU_SetUnitFlyHeight(self, whichUnit, newHeight, rate)
    if whichUnit == nil or whichUnit == 0 then
        return
    end
    local AMRF = 1097691750
    if type(jass.UnitAddAbility) == "function" then
        jass.UnitAddAbility(whichUnit, AMRF)
    end
    if type(jass.UnitRemoveAbility) == "function" then
        jass.UnitRemoveAbility(whichUnit, AMRF)
    end
    if type(jass.SetUnitFlyHeight) == "function" then
        jass.SetUnitFlyHeight(whichUnit, newHeight, rate)
    end
end
--- 获取英雄全属性（力量+敏捷+智力）
-- 
-- @param u 目标英雄
-- @param b 是否计算绿字（加成）
-- @returns 全属性数值
function ____exports.SU_GetHeroAllState(self, u, b)
    if u == nil or u == 0 then
        return 0
    end
    local ____temp_3
    if type(jass.GetHeroStr) == "function" then
        ____temp_3 = jass.GetHeroStr(u, b)
    else
        ____temp_3 = 0
    end
    local str = ____temp_3
    local ____temp_4
    if type(jass.GetHeroAgi) == "function" then
        ____temp_4 = jass.GetHeroAgi(u, b)
    else
        ____temp_4 = 0
    end
    local agi = ____temp_4
    local ____temp_5
    if type(jass.GetHeroInt) == "function" then
        ____temp_5 = jass.GetHeroInt(u, b)
    else
        ____temp_5 = 0
    end
    local int = ____temp_5
    return str + agi + int
end
--- 获取单位已损失生命值百分比
-- 
-- @param u 目标单位
-- @returns 已损失生命值百分比（0-1）
function ____exports.SU_GetUnitLostHPPercent(self, u)
    if u == nil or u == 0 then
        return 0
    end
    local ____temp_6
    if type(jass.GetUnitState) == "function" then
        ____temp_6 = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    else
        ____temp_6 = 0
    end
    local maxLife = ____temp_6
    local ____temp_7
    if type(jass.GetUnitState) == "function" then
        ____temp_7 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_7 = 0
    end
    local life = ____temp_7
    if maxLife <= 0 then
        return 0
    end
    return (maxLife - life) / maxLife
end
--- 获取单位已损失生命值
-- 
-- @param u 目标单位
-- @returns 已损失生命值
function ____exports.SU_GetUnitLostHP(self, u)
    if u == nil or u == 0 then
        return 0
    end
    local ____temp_8
    if type(jass.GetUnitState) == "function" then
        ____temp_8 = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    else
        ____temp_8 = 0
    end
    local maxLife = ____temp_8
    local ____temp_9
    if type(jass.GetUnitState) == "function" then
        ____temp_9 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_9 = 0
    end
    local life = ____temp_9
    return maxLife - life
end
--- 为单位添加生命值（支持百分比）
-- 
-- @param u 目标单位
-- @param value 增加值（若b为true则为百分比）
-- @param b 是否为百分比模式
function ____exports.UnitAddHp(self, u, value, b)
    if u == nil or u == 0 then
        return
    end
    local ____temp_10
    if type(jass.GetUnitState) == "function" then
        ____temp_10 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_10 = 0
    end
    local life = ____temp_10
    local ____temp_11
    if type(jass.GetUnitState) == "function" then
        ____temp_11 = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    else
        ____temp_11 = 0
    end
    local maxLife = ____temp_11
    local percent = maxLife > 0 and life / maxLife or 1
    local addValue = b and maxLife * value or value
    if type(jass.SetUnitState) == "function" then
        jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, maxLife + addValue)
        jass.SetUnitState(u, jass.UNIT_STATE_LIFE, (maxLife + addValue) * percent)
    end
end
--- 判断单位是否死亡（高精度）
-- 
-- @param u 目标单位
-- @returns 是否存活（true=存活，false=死亡）
function ____exports.SU_IsUnitDie(self, u)
    if u == nil or u == 0 then
        return true
    end
    local ____temp_12
    if type(jass.GetUnitState) == "function" then
        ____temp_12 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_12 = 0
    end
    local life = ____temp_12
    return life > 0.405
end
--- 设置单位可见性
-- 通过透明度和飞行高度实现显示/隐藏
-- 
-- @param u 目标单位
-- @param isShow true=显示，false=隐藏
function ____exports.SU_ShowOrHideUnit(self, u, isShow)
    if u == nil or u == 0 then
        return
    end
    if type(jass.SetUnitVertexColor) == "function" then
        if isShow then
            jass.SetUnitVertexColor(
                u,
                255,
                255,
                255,
                255
            )
        else
            jass.SetUnitVertexColor(
                u,
                255,
                255,
                255,
                0
            )
        end
    end
    if isShow then
        ____exports.SU_SetUnitFlyHeight(nil, u, 999999, 0)
    else
        ____exports.SU_SetUnitFlyHeight(nil, u, 0, 0)
    end
end
return ____exports
