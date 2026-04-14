--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local _____4F24_5BB3_4E8B_4EF6 = require("系统.04．伤害系统.01．伤害事件")
local _____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
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
local function TrigActions(self)
    local unit = jass.GetTriggerUnit()
    local damage = jass.GetEventDamage()
    if not unit then
        return
    end
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
    local damageTypeParts = {}
    if _____4F24_5BB3_51FD_6570.isFireDamage() then
        damageTypeParts[#damageTypeParts + 1] = "火"
    end
    if _____4F24_5BB3_51FD_6570.isWaterDamage() then
        damageTypeParts[#damageTypeParts + 1] = "冰"
    end
    if _____4F24_5BB3_51FD_6570.isThunderDamage() then
        damageTypeParts[#damageTypeParts + 1] = "雷"
    end
    if _____4F24_5BB3_51FD_6570.isMetalDamage() then
        damageTypeParts[#damageTypeParts + 1] = "毒"
    end
    if _____4F24_5BB3_51FD_6570.isLightDamage() then
        damageTypeParts[#damageTypeParts + 1] = "光"
    end
    if _____4F24_5BB3_51FD_6570.YDWEIsEventDamageType(jass.DAMAGE_TYPE_MAGIC) then
        damageTypeParts[#damageTypeParts + 1] = "魔法"
    end
    if _____4F24_5BB3_51FD_6570.isWoodDamage() then
        damageTypeParts[#damageTypeParts + 1] = "风"
    end
    if _____4F24_5BB3_51FD_6570.isDarkDamage() then
        damageTypeParts[#damageTypeParts + 1] = "暗"
    end
    if _____4F24_5BB3_51FD_6570.isPhysicalDamage() then
        damageTypeParts[#damageTypeParts + 1] = "物理"
    end
    local typeText = ""
    if #damageTypeParts > 0 then
        typeText = table.concat(damageTypeParts, "")
        if _____4F24_5BB3_51FD_6570.isMagicDamage() then
            typeText = typeText .. "魔法"
        end
    end
    local isEnhanced = _____4F24_5BB3_51FD_6570.isEnhancedDamage()
    local isTrue = _____4F24_5BB3_51FD_6570.isTrueDamage()
    local prefix = ""
    if _____4F24_5BB3_51FD_6570.isNormalAttack() then
        prefix = "普攻"
    elseif _____4F24_5BB3_51FD_6570.isSkillAttack() then
        prefix = "技能攻击"
    elseif _____4F24_5BB3_51FD_6570.isSkillDamage() then
        prefix = "技能"
    end
    if isEnhanced and prefix ~= "" then
        prefix = prefix .. "强化"
    end
    if isTrue and prefix ~= "" then
        prefix = prefix .. "精神"
    end
    local msg
    if prefix ~= "" and typeText ~= "" then
        msg = (((((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点") .. prefix) .. typeText) .. "伤害"
    elseif prefix ~= "" then
        msg = ((((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点") .. prefix) .. "伤害"
    elseif typeText ~= "" then
        msg = ((((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点") .. typeText) .. "伤害"
    else
        msg = ((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点伤害"
    end
    if _____4F24_5BB3_51FD_6570.YDWEIsEventRangedDamage() then
        msg = msg .. "（远程）"
    end
    local source = nil
    if type(jass.GetEventDamageSource) == "function" then
        pcall(function ()
                source = jass.GetEventDamageSource()
            end
        )
    end
    if source == nil then
        pcall(function ()
                source = GetEventDamageSource()
            end
        )
    end
    if source ~= nil and type(jass.GetUnitName) == "function" then
        local sourceName = jass.GetUnitName(source)
        if sourceName ~= nil and sourceName ~= "" then
            msg = (msg .. " 伤害来源：") .. tostring(sourceName)
        end
    end
    sendMsg(nil, msg)
end
local function TrigConditions(self)
    return true
end
local function init(self)
    local trg = jass.CreateTrigger()
    if type(jass.TriggerAddCondition) == "function" and type(jass.Condition) == "function" then
        jass.TriggerAddCondition(
            trg,
            jass.Condition(TrigConditions)
        )
    end
    _____4F24_5BB3_4E8B_4EF6:MNAnyUnitDamaged(trg, 60)
    if type(jass.TriggerAddAction) == "function" then
        jass.TriggerAddAction(trg, TrigActions)
    end
end
init(nil)
return ____exports
