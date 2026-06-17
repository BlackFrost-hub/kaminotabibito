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
local _____6D6E_5B57_6A21_5757 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
local _____6280_80FD_4E8B_4EF6_6A21_5757 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local CreateFloatTextOnUnit = _____6D6E_5B57_6A21_5757.CreateFloatTextOnUnit
local registerSpellChannelListener = _____6280_80FD_4E8B_4EF6_6A21_5757.registerSpellChannelListener
local ITEM_USE_ORDER_IDS = __TS__New(Set, {
    852008,
    852009,
    852010,
    852011,
    852012,
    852013,
    852622
})
local function getAbilityName(unit, abilityId, level)
    if type(japi.DzGetUnitAbilityTip) == "function" then
        return japi.DzGetUnitAbilityTip(unit, abilityId) or ""
    end
    local abil = japi.EXGetUnitAbility(unit, abilityId)
    if not abil then
        return ""
    end
    return japi.EXGetAbilityDataString(abil, level, 215) or ""
end
local function onSpellChannel(castingUnit, spellAbilityId)
    if type(CreateFloatTextOnUnit) ~= "function" then
        return
    end
    if jass.IsUnitType(castingUnit, jass.UNIT_TYPE_MECHANICAL) then
        return
    end
    if jass.IsUnitType(castingUnit, jass.UNIT_TYPE_ANCIENT) then
        return
    end
    local orderId = jass.GetUnitCurrentOrder(castingUnit)
    if ITEM_USE_ORDER_IDS:has(orderId) then
        return
    end
    local level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId)
    local skillName = getAbilityName(castingUnit, spellAbilityId, level)
    if not skillName then
        return
    end
    CreateFloatTextOnUnit(castingUnit, skillName, {
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
if type(registerSpellChannelListener) == "function" then
    registerSpellChannelListener(onSpellChannel)
end
return ____exports
