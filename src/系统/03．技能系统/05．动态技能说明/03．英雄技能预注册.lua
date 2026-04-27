local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.05．动态技能说明.00．常量定义")
local DYNAMIC_SKILL_TIP_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.DYNAMIC_SKILL_TIP_ENABLED
local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.03．技能系统.05．动态技能说明.01．核心功能")
local registerDynamicSkillTip = ____01_FF0E_6838_5FC3_529F_80FD.registerDynamicSkillTip
local refreshAllSkillTips = ____01_FF0E_6838_5FC3_529F_80FD.refreshAllSkillTips
local ABILITY_DATA_UBERTIP = ____01_FF0E_6838_5FC3_529F_80FD.ABILITY_DATA_UBERTIP
--- ==========================================================================================
-- 动态技能说明系统 - 英雄技能预注册
-- ==========================================================================================
-- 
-- 【功能】
-- 为玩家英雄桥接的单位自动预注册技能动态描述。
-- - 监听技能释放事件（走技能事件系统统一入口）
-- - 过滤物品技能（852008-852013）
-- - 自动为英雄技能注册动态描述
-- - 每2秒使用中心计时器自动刷新所有技能描述
-- 
-- 【使用方式】
-- 系统自动初始化，无需手动调用。
-- 
-- ==========================================================================================
local jass = require("jass.common")
local ITEM_SKILL_MIN = 852008
local ITEM_SKILL_MAX = 852013
local registeredSkills = __TS__New(Set)
local _periodicCallbackId = nil
--- 判断是否是物品技能
-- 直接检查命令ID是否在物品技能范围内
local function isItemSkillByOrder(self, unit)
    if not unit then
        return false
    end
    local currentOrder = jass:GetUnitCurrentOrder(unit)
    if not currentOrder then
        return false
    end
    return currentOrder >= ITEM_SKILL_MIN and currentOrder <= ITEM_SKILL_MAX
end
--- 获取技能唯一标识
local function getSkillKey(self, unit, abilityId)
    return (tostring(jass:GetHandleId(unit)) .. "_") .. tostring(abilityId)
end
--- 获取技能描述模板
-- 可以根据技能ID返回不同的模板
local function getSkillTemplate(self, abilityId)
    local abilityIdStr = tostring(abilityId)
    return "造成伤害: [100+{力量}*2+{等级}*10]|n消耗魔法: [{等级}*5]|n冷却时间: [10-{等级}*0.5]秒"
end
--- 处理技能释放事件
-- 技能获取走技能事件系统统一入口
local function onSpellEffect(self, castingUnit, spellAbilityId)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    if isItemSkillByOrder(nil, castingUnit) then
        return
    end
    local skillKey = getSkillKey(nil, castingUnit, spellAbilityId)
    if registeredSkills:has(skillKey) then
        return
    end
    local template = getSkillTemplate(nil, spellAbilityId)
    if not template then
        return
    end
    local level = jass:GetUnitAbilityLevel(castingUnit, spellAbilityId)
    if level <= 0 then
        return
    end
    local success = registerDynamicSkillTip(
        nil,
        castingUnit,
        spellAbilityId,
        template,
        level,
        ABILITY_DATA_UBERTIP
    )
    if success then
        registeredSkills:add(skillKey)
    end
end
--- 定期刷新所有技能描述
-- 每2秒执行一次
local function onPeriodicRefresh(self)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    refreshAllSkillTips(nil)
end
function ____exports.initHeroSkillPreregistration(self)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    local ____require_result_0 = require("系统.03．技能系统.00．技能事件.01．核心功能")
    local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
    registerSpellEffectListener(nil, onSpellEffect)
    local ____G_1 = _G
    local addPeriodicCallback = ____G_1.addPeriodicCallback
    _periodicCallbackId = addPeriodicCallback(nil, 2000, onPeriodicRefresh)
end
return ____exports
