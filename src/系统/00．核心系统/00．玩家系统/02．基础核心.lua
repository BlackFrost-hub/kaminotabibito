--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local moveFx = require("系统.00．核心系统.00．玩家系统.03．移速龙卷特效")
local _inited = false
local _tickCounter = 0
local function runAllFeatureSyncs(self)
    if type(moveFx.syncTornadoSpeedEffectsByHeroGroup) == "function" then
        moveFx:syncTornadoSpeedEffectsByHeroGroup()
    end
end
function ____exports.initPlayerUnitManager(self)
    if _inited then
        return
    end
    _inited = true
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
