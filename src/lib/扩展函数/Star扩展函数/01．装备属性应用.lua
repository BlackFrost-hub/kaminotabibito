local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet2 = ____require_result_0.YDUserDataGet2
local YDUserDataSet2 = ____require_result_0.YDUserDataSet2
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_1.SGSS_SetState
local SGSS_SetStatePercentumEX2 = ____require_result_1.SGSS_SetStatePercentumEX2
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.03．动态百分比属性")
local applyDynamicPercentProperty = ____require_result_2.applyDynamicPercentProperty
local function applyBaseState(unit, name, value)
    if name == "攻击力" then
        SGSS_SetState(unit, 1, value)
    elseif name == "护甲" then
        SGSS_SetState(unit, 2, value)
    elseif name == "力量" then
        SGSS_SetState(unit, 3, value)
    elseif name == "敏捷" then
        SGSS_SetState(unit, 4, value)
    elseif name == "智力" then
        SGSS_SetState(unit, 5, value)
    elseif name == "全属性" then
        SGSS_SetState(unit, 6, value)
    elseif name == "生命值" then
        SGSS_SetState(unit, 7, value)
    elseif name == "魔法值" then
        SGSS_SetState(unit, 8, value)
    elseif name == "叠加移动速度" then
        SGSS_SetState(unit, 9, value)
    elseif name == "攻速" then
        SGSS_SetState(unit, 10, value)
    elseif name == "视野" then
        SGSS_SetState(unit, 11, value)
    end
end
local function getHeroGroup()
    do
        local function ____catch(_e)
            return true, nil
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            return true, YDUserDataGet2(
                nil,
                "string",
                "玩家英雄",
                "单位组",
                "group"
            )
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
function ____exports.applyEquipStatsTS(unit, stats)
    local readBack = {}
    if not unit or not stats or #stats == 0 then
        return readBack
    end
    local owner = jass.GetOwningPlayer(unit)
    local heroGroup = getHeroGroup()
    local isHeroByGroup = not not (heroGroup and jass.IsUnitInGroup(unit, heroGroup))
    local isHeroByType = not not jass.IsUnitType(unit, jass.UNIT_TYPE_HERO)
    local isHero = isHeroByGroup or not heroGroup and isHeroByType
    for ____, s in ipairs(stats) do
        do
            local name = s.name
            local value = __TS__Number(s.value) or 0
            if value == 0 then
                readBack[name] = 0
                goto __continue19
            end
            applyBaseState(unit, name, value)
            if not isHero then
                local cur = __TS__Number(YDUserDataGet2(
                    nil,
                    "unit",
                    unit,
                    name,
                    "real"
                )) or 0
                local next = cur + value
                YDUserDataSet2(
                    nil,
                    "unit",
                    unit,
                    name,
                    "real",
                    next
                )
                readBack[name] = next
                goto __continue19
            end
            if name ~= "移动速度" and owner then
                local cur = __TS__Number(YDUserDataGet2(
                    nil,
                    "player",
                    owner,
                    name,
                    "real"
                )) or 0
                local next = cur + value
                YDUserDataSet2(
                    nil,
                    "player",
                    owner,
                    name,
                    "real",
                    next
                )
                readBack[name] = next
            end
            if applyDynamicPercentProperty(unit, name, value) then
            elseif name == "经验获取率" and owner then
                local t = __TS__Number(g.udg_T) or 1
                local base = 0.35 + 0.65 * t
                jass.SetPlayerHandicapXP(owner, base * value)
            end
        end
        ::__continue19::
    end
    return readBack
end
return ____exports
