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
local ____require_result_0 = require("系统.00．核心系统.03．漂浮文字函数")
local CreateFloatTextOnUnit = ____require_result_0.CreateFloatTextOnUnit
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local TriggerRegisterAnyUnitEventBJ = ____require_result_1.TriggerRegisterAnyUnitEventBJ
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
--- 获取技能名称（直接调用japi）
local function getAbilityName(self, unit, abilityId, level)
    local abil = japi.EXGetUnitAbility(unit, abilityId)
    if not abil then
        return ""
    end
    return japi.EXGetAbilityDataString(abil, level, ABILITY_DATA_TIP) or ""
end
--- 显示技能名字的触发动作
local function onSpellChannel(self)
    local unit = jass.GetTriggerUnit()
    local abilityId = jass.GetSpellAbilityId()
    if jass.IsUnitType(unit, jass.UNIT_TYPE_MECHANICAL) then
        return
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) then
        return
    end
    local orderId = jass.GetUnitCurrentOrder(unit)
    if ITEM_USE_ORDER_IDS:has(orderId) then
        return
    end
    local level = jass.GetUnitAbilityLevel(unit, abilityId)
    local skillName = getAbilityName(nil, unit, abilityId, level)
    if not skillName then
        return
    end
    CreateFloatTextOnUnit(nil, unit, skillName, {
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
--- 初始化显示技能名字系统
function ____exports.initShowSkillName(self)
    local trig = jass.CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(nil, trig, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    jass.TriggerAddAction(trig, onSpellChannel)
end
return ____exports
