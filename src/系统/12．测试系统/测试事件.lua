--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．技能函数")
local EXGetUnitAbilityByIndex = ____require_result_0.EXGetUnitAbilityByIndex
local EXGetAbilityId = ____require_result_0.EXGetAbilityId
local YDWESetUnitAbilityDataString = ____require_result_0.YDWESetUnitAbilityDataString
local YDWESetUnitAbilityDataReal = ____require_result_0.YDWESetUnitAbilityDataReal
local ABILITY_DATA_NAME = ____require_result_0.ABILITY_DATA_NAME
local ABILITY_DATA_TIP = ____require_result_0.ABILITY_DATA_TIP
local ABILITY_DATA_DUR = ____require_result_0.ABILITY_DATA_DUR
local ABILITY_DATA_HERODUR = ____require_result_0.ABILITY_DATA_HERODUR
local trg = jass.CreateTrigger()
local redPlayer = jass.Player(0)
jass.TriggerRegisterPlayerUnitEvent(trg, redPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, nil)
jass.TriggerAddAction(
    trg,
    function()
        local u = jass.GetTriggerUnit()
        if not u then
            return
        end
        local found = false
        local ok1 = false
        local ok2 = false
        local okDur1 = false
        local okDur2 = false
        local okDur3 = false
        local abilId = 0
        do
            local i = 0
            while i <= 15 do
                local a = EXGetUnitAbilityByIndex(nil, u, i)
                if a then
                    local id = EXGetAbilityId(nil, a)
                    if id == 1095268197 then
                        found = true
                        abilId = id
                        break
                    end
                end
                i = i + 1
            end
        end
        if found then
            ok1 = YDWESetUnitAbilityDataString(
                nil,
                u,
                abilId,
                1,
                ABILITY_DATA_NAME,
                "测试"
            )
            ok2 = YDWESetUnitAbilityDataString(
                nil,
                u,
                abilId,
                1,
                ABILITY_DATA_TIP,
                "测试"
            )
            okDur1 = YDWESetUnitAbilityDataReal(
                nil,
                u,
                abilId,
                1,
                ABILITY_DATA_DUR,
                3
            )
            okDur2 = YDWESetUnitAbilityDataReal(
                nil,
                u,
                abilId,
                2,
                ABILITY_DATA_DUR,
                3
            )
            okDur3 = YDWESetUnitAbilityDataReal(
                nil,
                u,
                abilId,
                3,
                ABILITY_DATA_DUR,
                3
            )
            YDWESetUnitAbilityDataReal(
                nil,
                u,
                abilId,
                1,
                ABILITY_DATA_HERODUR,
                3
            )
            YDWESetUnitAbilityDataReal(
                nil,
                u,
                abilId,
                2,
                ABILITY_DATA_HERODUR,
                3
            )
            YDWESetUnitAbilityDataReal(
                nil,
                u,
                abilId,
                3,
                ABILITY_DATA_HERODUR,
                3
            )
        end
        local line = (((((((((((("[SelectEvent] 单位=" .. tostring(jass.GetUnitName(u))) .. " 找到=") .. tostring(found)) .. " 文本=") .. tostring(ok1)) .. ",") .. tostring(ok2)) .. " 持续时间=") .. tostring(okDur1)) .. ",") .. tostring(okDur2)) .. ",") .. tostring(okDur3)
        jass.DisplayTimedTextToPlayer(
            redPlayer,
            0,
            0,
            15,
            line
        )
    end
)
return ____exports
