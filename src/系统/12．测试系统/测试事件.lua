--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local trg = jass:CreateTrigger()
local redPlayer = jass:Player(0)
playerUnitEvent.registerPlayerUnitEvent(trg, redPlayer, jass.EVENT_PLAYER_UNIT_SELECTED)
jass:TriggerAddAction(
    trg,
    function()
        local u = jass:GetTriggerUnit()
        if not u then
            return
        end
    end
)
return ____exports
