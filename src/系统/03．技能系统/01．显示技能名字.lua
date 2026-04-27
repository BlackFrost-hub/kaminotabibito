local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 显示技能名字系统
-- 
-- 功能：当单位施放技能时，在单位头顶显示技能名称的漂浮文字
-- 排除：机械单位、古树单位、使用物品（物品栏命令ID 852008-852013, 852622）
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
local CreateFloatTextOnUnit = ____require_result_0.CreateFloatTextOnUnit
local ____require_result_1 = require("系统.03．技能系统.00．技能事件.01．核心功能")
local registerSpellChannelListener = ____require_result_1.registerSpellChannelListener
local ABILITY_DATA_TIP = 215
local ITEM_USE_ORDER_IDS = __TS__New(Set, {
    852008,
    852009,
    852010,
    852011,
    852012,
    852013,
    852622
})
local function getAbilityName(self, unit, abilityId, level)
    local abil = japi:EXGetUnitAbility(unit, abilityId)
    if not abil then
        return ""
    end
    return japi:EXGetAbilityDataString(abil, level, ABILITY_DATA_TIP) or ""
end
local function onSpellChannel(self, castingUnit, spellAbilityId)
    if jass:IsUnitType(castingUnit, jass.UNIT_TYPE_MECHANICAL) then
        return
    end
    if jass:IsUnitType(castingUnit, jass.UNIT_TYPE_ANCIENT) then
        return
    end
    local orderId = jass:GetUnitCurrentOrder(castingUnit)
    if ITEM_USE_ORDER_IDS:has(orderId) then
        return
    end
    local level = jass:GetUnitAbilityLevel(castingUnit, spellAbilityId)
    local skillName = getAbilityName(nil, castingUnit, spellAbilityId, level)
    if not skillName then
        return
    end
    CreateFloatTextOnUnit(nil, castingUnit, skillName, {
        size = 9,
        red = 255,
        green = 255,
        blue = 255,
        alpha = 0,
        duration = 1,
        speedX = 0,
        speedY = 0.04,
        height = 20
    })
end
registerSpellChannelListener(nil, onSpellChannel)
return ____exports
