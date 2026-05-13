local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local Set = ____lualib.Set
local ____exports = {}
local isValidHandle, getHandleId, _____5F52_4E00_5316_70ED_952E, _____8BFB_53D6_6280_80FD_70ED_952E, _____5F53_524D_662F_5426_672C_673A_9009_4E2D_82F1_96C4, _____6309_547D_4EE4_5361_63A8_65AD_70ED_952E, _____5199_5165_6280_80FD_8BB0_5F55, ____on_82F1_96C4_6280_80FD_751F_6548, jass, japi, commandBarAbility, ydweAbility, YDWEGetUnitAbilityDataString, _____82F1_96C4_6280_80FD_8BB0_5F55_8868
function isValidHandle(self, handle)
    return handle ~= nil and handle ~= 0
end
function getHandleId(self, handle)
    if not isValidHandle(nil, handle) then
        return 0
    end
    return jass.GetHandleId(handle) or 0
end
function _____5F52_4E00_5316_70ED_952E(rawHotkey)
    local hotkey = tostring(rawHotkey)
    if hotkey == "Q" or hotkey == "q" then
        return "Q"
    end
    if hotkey == "W" or hotkey == "w" then
        return "W"
    end
    if hotkey == "E" or hotkey == "e" then
        return "E"
    end
    if hotkey == "R" or hotkey == "r" then
        return "R"
    end
    if hotkey == "D" or hotkey == "d" then
        return "D"
    end
    return nil
end
function _____8BFB_53D6_6280_80FD_70ED_952E(whichHero, abilityId)
    if not isValidHandle(nil, whichHero) or abilityId == 0 then
        return nil
    end
    local rawHotkey = YDWEGetUnitAbilityDataString(
        nil,
        whichHero,
        abilityId,
        1,
        ydweAbility.ABILITY_DATA_HOTKEY
    )
    if rawHotkey == nil or rawHotkey == "" then
        return nil
    end
    return _____5F52_4E00_5316_70ED_952E(rawHotkey)
end
function _____5F53_524D_662F_5426_672C_673A_9009_4E2D_82F1_96C4(whichHero)
    if not isValidHandle(nil, whichHero) then
        return false
    end
    local localPlayer = jass.GetLocalPlayer()
    if not isValidHandle(nil, localPlayer) then
        return false
    end
    if jass.GetOwningPlayer(whichHero) ~= localPlayer then
        return false
    end
    local focused = japi.DzGetMouseFocus()
    if focused == nil then
    end
    return true
end
function _____6309_547D_4EE4_5361_63A8_65AD_70ED_952E(whichHero, abilityId)
    if not _____5F53_524D_662F_5426_672C_673A_9009_4E2D_82F1_96C4(whichHero) then
        return nil
    end
    return commandBarAbility["按命令卡推断热键"](abilityId)
end
function _____5199_5165_6280_80FD_8BB0_5F55(whichHero, hotkey, abilityId)
    local heroId = getHandleId(nil, whichHero)
    if heroId == 0 or abilityId == 0 then
        return
    end
    local record = _____82F1_96C4_6280_80FD_8BB0_5F55_8868:get(heroId)
    if record == nil then
        record = {}
        _____82F1_96C4_6280_80FD_8BB0_5F55_8868:set(heroId, record)
    end
    if record[hotkey] ~= nil and record[hotkey] ~= 0 then
        return
    end
    record[hotkey] = abilityId
end
function ____on_82F1_96C4_6280_80FD_751F_6548()
    local whichHero = jass.GetTriggerUnit()
    if not isValidHandle(nil, whichHero) then
        return
    end
    local abilityId = jass.GetSpellAbilityId() or 0
    if abilityId == 0 then
        return
    end
    local hotkey = _____8BFB_53D6_6280_80FD_70ED_952E(whichHero, abilityId)
    local finalHotkey = hotkey or _____6309_547D_4EE4_5361_63A8_65AD_70ED_952E(whichHero, abilityId)
    if finalHotkey == nil then
        return
    end
    _____5199_5165_6280_80FD_8BB0_5F55(whichHero, finalHotkey, abilityId)
end
jass = require("jass.common")
japi = require("jass.japi")
local unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
commandBarAbility = require("系统.03．技能系统.05．动态技能说明.07．命令卡技能槽位")
ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
YDWEGetUnitAbilityDataString = ____require_result_0.YDWEGetUnitAbilityDataString
_____82F1_96C4_6280_80FD_8BB0_5F55_8868 = __TS__New(Map)
local _____5DF2_6302_63A5_82F1_96C4 = __TS__New(Set)
local _____6280_80FD_8BB0_5F55_89E6_53D1_5668 = nil
local function ____ensure_6280_80FD_8BB0_5F55_89E6_53D1_5668(self)
    if _____6280_80FD_8BB0_5F55_89E6_53D1_5668 ~= nil then
        return _____6280_80FD_8BB0_5F55_89E6_53D1_5668
    end
    _____6280_80FD_8BB0_5F55_89E6_53D1_5668 = jass.CreateTrigger()
    jass.TriggerAddAction(_____6280_80FD_8BB0_5F55_89E6_53D1_5668, ____on_82F1_96C4_6280_80FD_751F_6548)
    return _____6280_80FD_8BB0_5F55_89E6_53D1_5668
end
function ____exports.registerHeroSkillRecordHero(whichHero)
    if not isValidHandle(nil, whichHero) then
        return
    end
    local heroId = getHandleId(nil, whichHero)
    if heroId == 0 or _____5DF2_6302_63A5_82F1_96C4:has(heroId) then
        return
    end
    unitSpecificEventCenter.registerUnitEventTrigger(
        ____ensure_6280_80FD_8BB0_5F55_89E6_53D1_5668(nil),
        whichHero,
        jass.EVENT_UNIT_SPELL_EFFECT
    )
    _____5DF2_6302_63A5_82F1_96C4:add(heroId)
end
function ____exports.getHeroRecordedSkill(whichHero, hotkey)
    local heroId = getHandleId(nil, whichHero)
    if heroId == 0 then
        return 0
    end
    local record = _____82F1_96C4_6280_80FD_8BB0_5F55_8868:get(heroId)
    if record == nil then
        return 0
    end
    return record[hotkey] or 0
end
function ____exports.getHeroRecordedSkills(whichHero)
    local heroId = getHandleId(nil, whichHero)
    if heroId == 0 then
        return nil
    end
    return _____82F1_96C4_6280_80FD_8BB0_5F55_8868:get(heroId) or nil
end
return ____exports
