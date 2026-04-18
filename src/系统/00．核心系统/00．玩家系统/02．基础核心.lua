--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local heroLinkage = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.index")
local _inited = false
local _tickCounter = 0
local function runAllFeatureSyncs(self)
    if type(heroLinkage.syncTornadoSpeedEffectsByRegisteredHeroes) == "function" then
        heroLinkage:syncTornadoSpeedEffectsByRegisteredHeroes()
    end
end
function ____exports.initPlayerUnitManager(self)
    if _inited then
        return
    end
    _inited = true
    if type(heroLinkage.initPetItemHandoff) == "function" then
        heroLinkage:initPetItemHandoff()
    end
    if type(heroLinkage.initPlayerHeroGetBridge) == "function" then
        heroLinkage:initPlayerHeroGetBridge()
    end
    onTick10ms(
        nil,
        function()
            _tickCounter = _tickCounter + 1
            if _tickCounter >= C.EXEC_EVERY_TICKS then
                _tickCounter = 0
                runAllFeatureSyncs(nil)
            end
        end
    )
end
return ____exports
