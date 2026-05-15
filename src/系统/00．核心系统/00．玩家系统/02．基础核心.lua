--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____G_0 = _G
local onTick10ms = ____G_0.onTick10ms
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local heroLinkage = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.index")
local syncTornadoSpeedEffectsByRegisteredHeroes = heroLinkage.syncTornadoSpeedEffectsByRegisteredHeroes
local initPlayerHeroGetBridge = heroLinkage.initPlayerHeroGetBridge
local initPetItemHandoff = heroLinkage.initPetItemHandoff
local _inited = false
local _tickCounter = 0
local function runAllFeatureSyncs()
    if type(syncTornadoSpeedEffectsByRegisteredHeroes) == "function" then
        syncTornadoSpeedEffectsByRegisteredHeroes()
    end
end
local function onPlayerUnitManagerTick()
    _tickCounter = _tickCounter + 1
    if _tickCounter >= C.EXEC_EVERY_TICKS then
        _tickCounter = 0
        runAllFeatureSyncs()
    end
end
function ____exports.initPlayerUnitManager()
    if _inited then
        return
    end
    _inited = true
    if type(initPetItemHandoff) == "function" then
        initPetItemHandoff()
    end
    if type(initPlayerHeroGetBridge) == "function" then
        initPlayerHeroGetBridge()
    end
    onTick10ms(onPlayerUnitManagerTick)
end
return ____exports
