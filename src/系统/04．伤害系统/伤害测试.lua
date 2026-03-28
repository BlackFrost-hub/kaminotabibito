--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 伤害事件测试：任意单位受到伤害时发送「XX单位受到了XX伤害」
-- 若 JASS 里 YDWEIsEventDamageType(COLD) 将 udg_TempInteger[1] 置为 1，伤害事件在 JASS 后立即读出并传入 tempInteger，此处置 0 并发送 111。
local jass = require("jass.common")
local g = require("jass.globals")
local damageEvent = require("系统.04．伤害系统.伤害事件")
local function sendMsg(self, msg)
    if type(jass.DisplayTextToPlayer) ~= "function" then
        return
    end
    do
        local i = 0
        while i <= 15 do
            local p = jass.Player(i)
            if p ~= nil then
                jass.DisplayTextToPlayer(p, 0, 0, msg)
            end
            i = i + 1
        end
    end
end
local function onDamage(self, unit, damage, damageType, isFirstInBatch, isLastInBatch)
    if not unit then
        return
    end
    local hb = damageEvent.hasBit
    local ____temp_0
    if type(jass.GetUnitName) == "function" then
        ____temp_0 = jass.GetUnitName(unit)
    else
        ____temp_0 = "单位"
    end
    local name = ____temp_0
    local ____temp_1
    if type(jass.R2S) == "function" then
        ____temp_1 = jass.R2S(damage)
    else
        ____temp_1 = tostring(damage)
    end
    local damageStr = ____temp_1
    local isSkill = hb(nil, damageType, 2048)
    local isPhysical = hb(nil, damageType, 4096)
    local isAttack = hb(nil, damageType, 8192)
    local isRanged = hb(nil, damageType, 16384)
    local msg
    if isSkill then
        local attrNames = {
            {1, "普通"},
            {2, "强化"},
            {4, "火属性"},
            {8, "冰属性"},
            {16, "雷属性"},
            {32, "金属性"},
            {64, "光属性"},
            {128, "魔法"},
            {256, "精神"},
            {512, "风属性"},
            {1024, "暗属性"}
        }
        local detail = ""
        do
            local a = 0
            while a < #attrNames do
                if hb(nil, damageType, attrNames[a + 1][1]) then
                    detail = ("（" .. attrNames[a + 1][2]) .. "）"
                    break
                end
                a = a + 1
            end
        end
        if (isAttack or isRanged) and (isFirstInBatch or isLastInBatch) then
            msg = (((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点技能攻击伤害") .. detail
        else
            msg = (((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点技能伤害") .. detail
        end
    elseif isRanged then
        msg = (((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点远程普攻") .. (isPhysical and "（物理）" or "")
    elseif isAttack then
        msg = (((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点普攻伤害") .. (isPhysical and "（物理）" or "")
    elseif hb(nil, damageType, 256) then
        msg = ((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点精神伤害"
    elseif hb(nil, damageType, 4) then
        msg = ((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点火属性伤害"
    else
        msg = ((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点伤害"
    end
    local j = jass
    local ____temp_2
    if j.udg_TempUnit ~= nil and j.udg_TempUnit[6] ~= nil then
        ____temp_2 = j.udg_TempUnit[6]
    else
        ____temp_2 = nil
    end
    local source = ____temp_2
    if source ~= nil and type(jass.GetUnitName) == "function" then
        local sourceName = jass.GetUnitName(source)
        if sourceName ~= nil and sourceName ~= "" then
            msg = (msg .. " 伤害来源：") .. tostring(sourceName)
        end
    end
    sendMsg(
        nil,
        ((msg .. " [类型:") .. tostring(damageType)) .. "]"
    )
end
damageEvent:registerDamageCallback(onDamage, 60)
return ____exports
