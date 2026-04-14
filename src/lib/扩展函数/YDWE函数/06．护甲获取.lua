--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass, g, ARMOR_REDUCTION_MULTIPLIER1, NATLOG_094, ARMOR_INVULNERABLE, DAMAGE_TEST, DAMAGE_LIFE, ARMOR_TEST_ABILITY
--- 获取单位护甲值（伤害测试法）
-- 通过造成测试伤害反算护甲值
-- 
-- @param u 目标单位
-- @returns 护甲值
function ____exports.YDWEGetUnitArmorByDamageTest(self, u)
    if u == nil then
        return 0
    end
    local life = jass.GetWidgetLife(u)
    if life < 0.405 then
        return 0
    end
    local test = life
    local redc = 0
    local enab = false
    local ____jass_GetTriggeringTrigger_0
    if jass.GetTriggeringTrigger then
        ____jass_GetTriggeringTrigger_0 = jass.GetTriggeringTrigger()
    else
        ____jass_GetTriggeringTrigger_0 = nil
    end
    local trig = ____jass_GetTriggeringTrigger_0
    local maxLife = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    if maxLife <= DAMAGE_LIFE then
        jass.UnitAddAbility(u, ARMOR_TEST_ABILITY)
    end
    if life <= DAMAGE_LIFE then
        jass.SetWidgetLife(u, DAMAGE_LIFE)
        test = DAMAGE_LIFE
    end
    if trig ~= nil and jass.IsTriggerEnabled(trig) then
        jass.DisableTrigger(trig)
        enab = true
    end
    local dmgTrigger = g.yd_DamageEventTrigger
    if dmgTrigger ~= nil then
        jass.DisableTrigger(dmgTrigger)
    end
    jass.UnitDamageTarget(
        u,
        u,
        DAMAGE_TEST,
        true,
        false,
        jass.ATTACK_TYPE_CHAOS,
        jass.DAMAGE_TYPE_NORMAL,
        nil
    )
    if dmgTrigger ~= nil then
        jass.EnableTrigger(dmgTrigger)
    end
    local newLife = jass.GetWidgetLife(u)
    redc = (DAMAGE_TEST - test + newLife) / DAMAGE_TEST
    if enab then
        jass.EnableTrigger(trig)
    end
    jass.UnitRemoveAbility(u, ARMOR_TEST_ABILITY)
    jass.SetWidgetLife(u, life)
    if redc >= 1 then
        return ARMOR_INVULNERABLE
    elseif redc < 0 then
        return -math.log(redc + 1) / NATLOG_094
    else
        return redc / (ARMOR_REDUCTION_MULTIPLIER1 * (1 - redc))
    end
end
jass = require("jass.common")
g = require("jass.globals")
--- 护甲状态常量
local UNIT_STATE_ARMOR = 32
ARMOR_REDUCTION_MULTIPLIER1 = 0.06
local ARMOR_REDUCTION_MULTIPLIER2 = 1 - ARMOR_REDUCTION_MULTIPLIER1
NATLOG_094 = math.log(ARMOR_REDUCTION_MULTIPLIER2)
ARMOR_INVULNERABLE = 917451.519
DAMAGE_TEST = 160
DAMAGE_LIFE = 300
ARMOR_TEST_ABILITY = 1097625443
--- 获取单位护甲值（简单方式）
-- 使用 GetUnitState + ConvertUnitState(0x20)
-- 
-- @param u 目标单位
-- @returns 护甲值
function ____exports.YDWEGetUnitArmor(self, u)
    if u == nil then
        return 0
    end
    if type(jass.ConvertUnitState) == "function" then
        local armorState = jass.ConvertUnitState(UNIT_STATE_ARMOR)
        return jass.GetUnitState(u, armorState)
    end
    return ____exports.YDWEGetUnitArmorByDamageTest(nil, u)
end
return ____exports
