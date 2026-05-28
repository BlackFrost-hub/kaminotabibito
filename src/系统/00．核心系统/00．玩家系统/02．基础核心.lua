--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____G_0 = _G
local onTick10ms = ____G_0.onTick10ms
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.01．移速龙卷特效")
local heroSelect = require("系统.00．核心系统.00．玩家系统.01．英雄选择.index")
local petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.03．背包满移交宠物")
local heroRevive = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.04．英雄复活系统")
local syncTornadoSpeedEffectsByRegisteredHeroes = moveTornado.syncTornadoSpeedEffectsByRegisteredHeroes
local initPetItemHandoff = petItemHandoff.initPetItemHandoff or petItemHandoff["初始化宠物移交"]
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
    if type(heroSelect["初始化英雄选择系统"]) == "function" then
        heroSelect["初始化英雄选择系统"]()
    end
    if type(heroRevive["初始化英雄复活"]) == "function" then
        heroRevive["初始化英雄复活"]()
    end
    onTick10ms(onPlayerUnitManagerTick)
end
return ____exports
