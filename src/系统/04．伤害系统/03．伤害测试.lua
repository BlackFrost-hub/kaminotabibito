local ____lualib = require("lualib_bundle")
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
--- 伤害测试开关（默认关闭，伤害判断已合并到伤害显示系统）
local ENABLED = true
local jass = require("jass.common")
local japi = require("jass.japi")
local _____4F24_5BB3_4E8B_4EF6 = require("系统.04．伤害系统.01．伤害事件")
local _____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local _____62A4_76FE_6A21_5757 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.index")
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
            v = japi.GetEventDamage()
        end
    )
    if v ~= nil and type(v) == "number" and not __TS__NumberIsNaN(v) then
        return v
    end
    return 0
end
--- 读取原始伤害（GetEventDamage 在某些环境可能返回改写前的值）
local function readOriginalDamage()
    local v
    pcall(function ()
            v = jass.GetEventDamage()
        end
    )
    if v ~= nil and type(v) == "number" and not __TS__NumberIsNaN(v) then
        return v
    end
    return 0
end
local function TrigActions()
    local unit = jass.GetTriggerUnit()
    local finalDamage = readEventDamageForDisplay()
    if not unit then
        return
    end
    local name = jass.GetUnitName(unit)
    local finalDamageStr = jass.R2S(finalDamage)
    local _____6709_62A4_76FE = _____62A4_76FE_6A21_5757["查询单位是否有护盾"](unit)
    local _____62A4_76FE_503C = _____6709_62A4_76FE and _____62A4_76FE_6A21_5757["查询单位总护盾值"](unit) or 0
    local g = _G
    local ____temp_0
    if type(g._shieldAbsorbAmount) == "number" then
        ____temp_0 = g._shieldAbsorbAmount
    else
        ____temp_0 = 0
    end
    local _____62A4_76FE_5438_6536 = ____temp_0
    local ____temp_1
    if type(g._shieldAbsorbType) == "string" then
        ____temp_1 = g._shieldAbsorbType
    else
        ____temp_1 = ""
    end
    local _____62A4_76FE_5438_6536_7C7B_578B_6587_672C = ____temp_1
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
        msg = (((((tostring(name) .. "受到了") .. tostring(finalDamageStr)) .. "点") .. prefix) .. typeText) .. "伤害"
    elseif prefix ~= "" then
        msg = ((((tostring(name) .. "受到了") .. tostring(finalDamageStr)) .. "点") .. prefix) .. "伤害"
    elseif typeText ~= "" then
        msg = ((((tostring(name) .. "受到了") .. tostring(finalDamageStr)) .. "点") .. typeText) .. "伤害"
    else
        msg = ((tostring(name) .. "受到了") .. tostring(finalDamageStr)) .. "点伤害"
    end
    if _____4F24_5BB3_51FD_6570.YDWEIsEventRangedDamage() then
        msg = msg .. "（远程）"
    end
    if _____6709_62A4_76FE and _____62A4_76FE_5438_6536 > 0 then
        msg = ((((((msg .. " [护盾吸收") .. tostring(jass.R2S(_____62A4_76FE_5438_6536))) .. "点") .. tostring(_____62A4_76FE_5438_6536_7C7B_578B_6587_672C)) .. "伤害, 剩余护盾:") .. tostring(jass.R2S(_____62A4_76FE_503C))) .. "]"
    elseif _____6709_62A4_76FE then
        msg = ((msg .. " [护盾:") .. tostring(jass.R2S(_____62A4_76FE_503C))) .. "]"
    end
    local source = nil
    pcall(function ()
            source = jass.GetEventDamageSource()
        end
    )
    if source == nil then
        pcall(function ()
                source = GetEventDamageSource()
            end
        )
    end
    if source ~= nil then
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
