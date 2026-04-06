--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 任意测试文件
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．封装函数")
local fourCCToString = ____require_result_0.fourCCToString
local printToPlayer = ____require_result_0.printToPlayer
local ____require_result_1 = require("lib.扩展函数.03．BJ函数")
local TriggerRegisterAnyUnitEventBJ = ____require_result_1.TriggerRegisterAnyUnitEventBJ
local OrderIdToString = ____require_result_1.OrderIdToString
--- 测试技能命令ID捕获
-- 监听所有玩家使用技能事件，捕获命令ID
local function testSpellOrderCapture(self)
    local ____temp_2
    if type(jass.CreateTrigger) == "function" then
        ____temp_2 = jass.CreateTrigger()
    else
        ____temp_2 = nil
    end
    local trig = ____temp_2
    if not trig then
        return
    end
    local ev = jass.EVENT_PLAYER_UNIT_SPELL_EFFECT
    if not ev then
        return
    end
    TriggerRegisterAnyUnitEventBJ(nil, trig, ev)
    jass.TriggerAddAction(
        trig,
        function()
            local ____temp_3
            if type(jass.GetTriggerUnit) == "function" then
                ____temp_3 = jass.GetTriggerUnit()
            else
                ____temp_3 = nil
            end
            local triggerUnit = ____temp_3
            if not triggerUnit then
                return
            end
            local ____temp_4
            if type(jass.GetUnitCurrentOrder) == "function" then
                ____temp_4 = jass.GetUnitCurrentOrder(triggerUnit)
            else
                ____temp_4 = 0
            end
            local orderId = ____temp_4
            local orderIdStr = OrderIdToString(nil, orderId)
            local ____temp_5
            if type(jass.GetSpellAbilityId) == "function" then
                ____temp_5 = jass.GetSpellAbilityId()
            else
                ____temp_5 = 0
            end
            local abilityId = ____temp_5
            local abilityIdStr = fourCCToString(nil, abilityId)
            local ____temp_6
            if type(jass.GetUnitName) == "function" then
                ____temp_6 = jass.GetUnitName(triggerUnit)
            else
                ____temp_6 = "未知单位"
            end
            local unitName = ____temp_6
            local ITEM_USE_MIN = 852008
            local ITEM_USE_MAX = 852013
            local isUsingItem = orderId >= ITEM_USE_MIN and orderId <= ITEM_USE_MAX
            local msg = (((((((((("使用技能! 单位: " .. tostring(unitName)) .. " 命令ID: ") .. tostring(orderId)) .. " (") .. orderIdStr) .. ") 技能ID: ") .. tostring(abilityId)) .. " (") .. abilityIdStr) .. ") ") .. (isUsingItem and "【使用物品】" or "")
            printToPlayer(
                nil,
                jass.Player(0),
                msg,
                5
            )
        end
    )
end
testSpellOrderCapture(nil)
local t = jass.CreateTimer()
jass.TimerStart(
    t,
    1,
    false,
    function()
        local u = jass.gg_unit_Hamg_0002
        if u then
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                10,
                "单位存在! Hamg Primary: " .. tostring(jass.GetUnitName(u))
            )
        else
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                10,
                "gg_unit_Hamg_0002 不存在!"
            )
        end
        jass.DestroyTimer(t)
    end
)
local t2 = jass.CreateTimer()
jass.TimerStart(
    t2,
    1,
    false,
    function()
        local u = jass.gg_unit_htow_0030
        if u then
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                10,
                "gg_unit_htow_0030 存在!"
            )
        else
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                10,
                "gg_unit_htow_0030 不存在!"
            )
        end
        jass.DestroyTimer(t2)
    end
)
return ____exports
