local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local dispatchChangeOwnerListeners, onChangeOwner, jass, playerUnitEvent, changeOwnerListeners, initialized
function dispatchChangeOwnerListeners(list, changingUnit)
    do
        local i = 0
        while i < #list do
            local callback = list[i + 1]
            if callback ~= nil then
                callback(changingUnit)
            end
            i = i + 1
        end
    end
end
function onChangeOwner()
    local changingUnit = jass.GetTriggerUnit()
    if changingUnit == nil then
        return
    end
    dispatchChangeOwnerListeners(changeOwnerListeners, changingUnit)
end
--- 初始化单位所有者变更事件。
function ____exports.initChangeOwnerEvent()
    if initialized then
        return
    end
    initialized = true
    local trig = jass.CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ____exports.CHANGE_OWNER_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_CHANGE_OWNER)
    jass.TriggerAddAction(trig, onChangeOwner)
end
jass = require("jass.common")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
____exports.CHANGE_OWNER_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
}
changeOwnerListeners = {}
initialized = false
local function hasListener(list, callback)
    do
        local i = 0
        while i < #list do
            if list[i + 1] == callback then
                return true
            end
            i = i + 1
        end
    end
    return false
end
--- 注册单位所有者变更监听。
-- 第一次使用时会自动初始化事件；同一回调不会重复注册。
function ____exports.registerChangeOwnerListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initChangeOwnerEvent()
    if not hasListener(changeOwnerListeners, callback) then
        changeOwnerListeners[#changeOwnerListeners + 1] = callback
    end
end
--- 取消单位所有者变更监听。
function ____exports.unregisterChangeOwnerListener(callback)
    local index = __TS__ArrayIndexOf(changeOwnerListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(changeOwnerListeners, index, 1)
    end
end
return ____exports
