local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
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
local function applyBaseState(self, unit, name, value)
    if name == "攻击力" then
        SGSS_SetState(nil, unit, 1, value)
    elseif name == "护甲" then
        SGSS_SetState(nil, unit, 2, value)
    elseif name == "力量" then
        SGSS_SetState(nil, unit, 3, value)
    elseif name == "敏捷" then
        SGSS_SetState(nil, unit, 4, value)
    elseif name == "智力" then
        SGSS_SetState(nil, unit, 5, value)
    elseif name == "全属性" then
        SGSS_SetState(nil, unit, 6, value)
    elseif name == "生命值" then
        SGSS_SetState(nil, unit, 7, value)
    elseif name == "魔法值" then
        SGSS_SetState(nil, unit, 8, value)
    elseif name == "叠加移动速度" then
        SGSS_SetState(nil, unit, 9, value)
    elseif name == "攻速" then
        SGSS_SetState(nil, unit, 10, value)
    end
end
local function getHeroGroup(self)
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
function ____exports.applyEquipStatsTS(self, unit, stats)
    local readBack = {}
    if not unit or not stats or #stats == 0 then
        return readBack
    end
    local ____temp_3
    if type(jass.GetOwningPlayer) == "function" then
        ____temp_3 = jass.GetOwningPlayer(unit)
    else
        ____temp_3 = nil
    end
    local owner = ____temp_3
    local heroGroup = getHeroGroup(nil)
    local isHeroByGroup = not not (heroGroup and type(jass.IsUnitInGroup) == "function" and jass.IsUnitInGroup(unit, heroGroup))
    local isHeroByType = not not (type(jass.IsUnitType) == "function" and jass.UNIT_TYPE_HERO ~= nil and jass.IsUnitType(unit, jass.UNIT_TYPE_HERO))
    local isHero = isHeroByGroup or not heroGroup and isHeroByType
    for ____, s in ipairs(stats) do
        do
            local __continue18
            repeat
                local name = s.name
                local value = __TS__Number(s.value) or 0
                if value == 0 then
                    readBack[name] = 0
                    __continue18 = true
                    break
                end
                applyBaseState(nil, unit, name, value)
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
                    __continue18 = true
                    break
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
                if applyDynamicPercentProperty(nil, unit, name, value) then
                elseif name == "经验获取率" and owner and type(jass.SetPlayerHandicapXP) == "function" then
                    local t = __TS__Number(g.udg_T) or 1
                    local base = 0.35 + 0.65 * t
                    jass.SetPlayerHandicapXP(owner, base * value)
                end
                __continue18 = true
            until true
            if not __continue18 then
                break
            end
        end
    end
    return readBack
end
return ____exports
