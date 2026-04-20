local ____lualib = require("lualib_bundle")
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
--- 伤害测试开关（默认关闭，伤害判断已合并到伤害显示系统）
local ENABLED = false
local jass = require("jass.common")
local japi = require("jass.japi")
local _____4F24_5BB3_4E8B_4EF6 = require("系统.04．伤害系统.01．伤害事件")
local _____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local function sendMsg(msg)
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
--- 伤害测试：`japi.GetEventDamage`（1.27 与 `YDWESetEventDamage` 改写后一致；无则 0）
local function readEventDamageForDisplay()
    local v
    pcall(function ()
            if type(japi.GetEventDamage) == "function" then
                v = japi.GetEventDamage()
            end
        end
    )
    if v ~= nil and type(v) == "number" and not __TS__NumberIsNaN(v) then
        return v
    end
    return 0
end
local function TrigActions()
    local unit = jass.GetTriggerUnit()
    local damage = readEventDamageForDisplay()
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
    sendMsg(msg)
end
local function TrigConditions()
    return true
end
local function init()
    if not ENABLED then
        return
    end
    local trg = jass.CreateTrigger()
    jass.TriggerAddCondition(
        trg,
        jass.Condition(TrigConditions)
    )
    _____4F24_5BB3_4E8B_4EF6:MNAnyUnitDamaged(trg, 60)
    jass.TriggerAddAction(trg, TrigActions)
end
init()
return ____exports
