local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- 装备成长：单位使用物品时，若装备数据有 PowerUP 字段，执行属性成长。
-- 格式：  段1+段2+...，段内用 ; 分隔效果；time>0 表示临时（N秒后撤销），time0/无time=永久
-- 效果类型：Nstat / N%stat / Nexp / Nlevel / (level*N)stat / (level*N)exp
-- 规则详见 `.cursor/rules/equipment/heal-hot-format.md`
local jass = require("jass.common")
local g = require("jass.globals")
local itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
local applyEquipStatsTS = ____require_result_0.applyEquipStatsTS
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AddGoldWithFeedback = ____require_result_1.AddGoldWithFeedback
local fourCCToString = ____require_result_1.fourCCToString
--- key -> 显示名（与装备系统.ts STAT_CONFIG 保持一致）
local KEY_TO_NAME = {
    hp = "生命值",
    mp = "魔法值",
    dmg = "攻击力",
    armor = "护甲",
    atkSpeed = "攻速",
    movespeed = "叠加移动速度",
    str = "力量",
    agi = "敏捷",
    int = "智力",
    all = "全属性",
    critRate = "暴击率",
    critDmg = "暴击伤害",
    magicResist = "魔抗",
    hpRegen = "生命恢复",
    hpRegenPct = "生命恢复%",
    hpRegenEff = "生命恢复效率",
    skillHeal = "技能治疗率",
    healReceived = "受到的治疗率",
    mpRegen = "魔法恢复",
    mpRegenPct = "魔法恢复%",
    mpCost = "魔法消耗",
    cdReduction = "冷却缩减",
    accuracy = "命中率",
    dodge = "闪避率",
    armorPierce = "护甲穿透",
    magicPierce = "魔法穿透",
    skillDmg = "技能伤害",
    skillResist = "技能抗性",
    magicDmg = "魔法伤害",
    physDmg = "物理伤害",
    physResist = "物理抗性",
    enhanceDmg = "强化伤害",
    atkDmg = "普攻伤害",
    atkResist = "普攻抗性",
    lightDmg = "光属性伤害",
    lightResist = "光属性抗性",
    darkDmg = "暗属性伤害",
    darkResist = "暗属性抗性",
    woodDmg = "木属性伤害",
    woodResist = "木属性抗性",
    fireDmg = "火属性伤害",
    fireResist = "火属性抗性",
    thunderDmg = "雷属性伤害",
    thunderResist = "雷属性抗性",
    waterDmg = "水属性伤害",
    waterResist = "水属性抗性",
    MetalResist = "金属性抗性",
    summonDmg = "召唤物伤害",
    summonResist = "召唤物抗性",
    dmgReduction = "伤害减少",
    dmgReductionPct = "伤害减少%",
    lifeSteal = "伤害吸血",
    magicLifeSteal = "魔法伤害吸血",
    atkLifeSteal = "普攻伤害吸血",
    critRateTaken = "被暴击率",
    critDmgTaken = "被暴击伤害",
    stunResist = "眩晕抗性",
    magicAtkDmg = "魔法普攻伤害",
    antMastery = "蝼蚁专精",
    movespeed2 = "移动速度",
    dmgBonus = "伤害%",
    finalDamageMultiplier = "最终伤害%",
    expGainRate = "经验获取率",
    hpPct = "最大生命值%",
    baseDmgPct = "基础攻击力%",
    SpellReduce = "受到技伤减少",
    PhysReduce = "受到物伤减少"
}
--- 根据原始 key 字符串（大小写不敏感）查找 KEY_TO_NAME 里的正确 key
local function findStatKey(self, raw)
    if KEY_TO_NAME[raw] ~= nil then
        return raw
    end
    local rl = string.lower(raw)
    for k in pairs(KEY_TO_NAME) do
        if string.lower(k) == rl then
            return k
        end
    end
    return ""
end
local function parsePowerUP(self, powerUpStr)
    local segments = {}
    local rawSegs = __TS__StringSplit(powerUpStr, "+")
    do
        local si = 0
        while si < #rawSegs do
            do
                local rawSeg = __TS__StringTrim(rawSegs[si + 1])
                if rawSeg == "" then
                    goto __continue9
                end
                local tokens = __TS__ArrayFilter(
                    __TS__ArrayMap(
                        __TS__StringSplit(rawSeg, ";"),
                        function(____, x) return __TS__StringTrim(x) end
                    ),
                    function(____, x) return x ~= "" end
                )
                local timeSec = 0
                local effectTokens = {}
                for ____, t in ipairs(tokens) do
                    local tl = string.lower(t)
                    if (string.find(tl, "time", nil, true) or 0) - 1 == 0 then
                        local w = __TS__ParseFloat(__TS__StringSubstring(t, 4)) or 0
                        if w > timeSec then
                            timeSec = w
                        end
                    else
                        effectTokens[#effectTokens + 1] = t
                    end
                end
                local effects = {}
                for ____, t in ipairs(effectTokens) do
                    do
                        local tl0 = string.lower(t)
                        if __TS__StringEndsWith(tl0, "gold") then
                            if (string.find(tl0, "%gold", nil, true) or 0) - 1 >= 0 then
                                local pctStr = __TS__StringTrim(__TS__StringSubstring(
                                    t,
                                    0,
                                    (string.find(tl0, "%", nil, true) or 0) - 1
                                ))
                                local pctNum = __TS__ParseFloat(pctStr) or 0
                                effects[#effects + 1] = {type = "gold", isPct = true, value = pctNum / 100, isLevelMult = false}
                                goto __continue18
                            end
                            local core = __TS__StringTrim(__TS__StringSubstring(t, 0, #t - 4))
                            local dash = (string.find(core, "-", nil, true) or 0) - 1
                            if dash >= 0 then
                                local a = __TS__ParseFloat(__TS__StringTrim(__TS__StringSubstring(core, 0, dash))) or 0
                                local b = __TS__ParseFloat(__TS__StringTrim(__TS__StringSubstring(core, dash + 1))) or 0
                                local mn = a < b and a or b
                                local mx = a < b and b or a
                                effects[#effects + 1] = {
                                    type = "gold",
                                    isPct = false,
                                    value = 0,
                                    isLevelMult = false,
                                    min = mn,
                                    max = mx
                                }
                            else
                                local v = __TS__ParseFloat(core) or 0
                                effects[#effects + 1] = {
                                    type = "gold",
                                    isPct = false,
                                    value = 0,
                                    isLevelMult = false,
                                    min = v,
                                    max = v
                                }
                            end
                            goto __continue18
                        end
                        if (string.find(t, "(level*", nil, true) or 0) - 1 == 0 then
                            local closeIdx = (string.find(t, ")", nil, true) or 0) - 1
                            if closeIdx < 0 then
                                goto __continue18
                            end
                            local mult = __TS__ParseFloat(__TS__StringSubstring(t, 7, closeIdx)) or 0
                            local rawKey = __TS__StringTrim(__TS__StringSubstring(t, closeIdx + 1))
                            local kl = string.lower(rawKey)
                            if kl == "exp" then
                                effects[#effects + 1] = {type = "exp", isPct = false, value = mult, isLevelMult = true}
                            elseif kl == "level" then
                                effects[#effects + 1] = {type = "level", isPct = false, value = mult, isLevelMult = true}
                            else
                                local ak = findStatKey(nil, rawKey)
                                if ak ~= "" then
                                    effects[#effects + 1] = {
                                        type = "stat",
                                        key = ak,
                                        isPct = false,
                                        value = mult,
                                        isLevelMult = true
                                    }
                                end
                            end
                            goto __continue18
                        end
                        local pctIdx = (string.find(t, "%", nil, true) or 0) - 1
                        local isPct = pctIdx >= 0
                        local cleaned = isPct and __TS__StringSubstring(t, 0, pctIdx) .. __TS__StringSubstring(t, pctIdx + 1) or t
                        local numEnd = 0
                        while numEnd < #cleaned do
                            local ch = __TS__StringSubstring(cleaned, numEnd, numEnd + 1)
                            if ch >= "0" and ch <= "9" or ch == "." or numEnd == 0 and ch == "-" then
                                numEnd = numEnd + 1
                            else
                                break
                            end
                        end
                        local num = __TS__ParseFloat(__TS__StringSubstring(cleaned, 0, numEnd)) or 0
                        local rawKey = __TS__StringTrim(__TS__StringSubstring(cleaned, numEnd))
                        local kl = string.lower(rawKey)
                        if kl == "exp" then
                            effects[#effects + 1] = {type = "exp", isPct = false, value = num, isLevelMult = false}
                        elseif kl == "level" then
                            effects[#effects + 1] = {type = "level", isPct = false, value = num, isLevelMult = false}
                        elseif kl == "gold" then
                            if isPct then
                                effects[#effects + 1] = {type = "gold", isPct = true, value = num / 100, isLevelMult = false}
                            else
                                effects[#effects + 1] = {
                                    type = "gold",
                                    isPct = false,
                                    value = 0,
                                    isLevelMult = false,
                                    min = num,
                                    max = num
                                }
                            end
                        else
                            local ak = findStatKey(nil, rawKey)
                            if ak ~= "" then
                                effects[#effects + 1] = {
                                    type = "stat",
                                    key = ak,
                                    isPct = isPct,
                                    value = isPct and num / 100 or num,
                                    isLevelMult = false
                                }
                            end
                        end
                    end
                    ::__continue18::
                end
                if #effects > 0 then
                    segments[#segments + 1] = {effects = effects, timeSec = timeSec}
                end
            end
            ::__continue9::
            si = si + 1
        end
    end
    return segments
end
--- 通过 TS 装备属性应用器批量加/减属性
local function applyStats(self, unit, statEffects, isAdd)
    if #statEffects == 0 then
        return
    end
    local payload = isAdd and statEffects or __TS__ArrayMap(
        statEffects,
        function(____, x) return __TS__ObjectAssign({}, x, {value = -x.value}) end
    )
    applyEquipStatsTS(nil, unit, payload)
end
--- 分 10 份给经验，避免跳级触发不到
local function addHeroXP(self, unit, amount)
    if amount <= 0 then
        return
    end
    local chunk = math.floor(amount / 10)
    do
        local i = 0
        while i < 10 do
            jass.AddHeroXP(unit, chunk, true)
            i = i + 1
        end
    end
    local remainder = amount - chunk * 10
    if remainder > 0 then
        jass.AddHeroXP(unit, remainder, true)
    end
end
local function getHeroLevel(self, unit)
    return jass.GetHeroLevel(unit)
end
--- 获取单位当前属性的绝对值，用于百分比计算。
-- str/agi/int 用 GetHeroStr/Agi/Int；hp/mp 用 GetUnitState+ConvertUnitState；
-- dmg=ConvertUnitState(0x15)，armor=ConvertUnitState(0x20)（需要 japi）
local function getPctStatValue(self, unit, key)
    if key == "int" then
        return jass.GetHeroInt(unit, true)
    end
    if key == "str" then
        return jass.GetHeroStr(unit, true)
    end
    if key == "agi" then
        return jass.GetHeroAgi(unit, true)
    end
    if key == "hp" then
        return jass.GetUnitState(
            unit,
            jass.ConvertUnitState(1)
        )
    end
    if key == "mp" then
        return jass.GetUnitState(
            unit,
            jass.ConvertUnitState(3)
        )
    end
    if key == "dmg" then
        return jass.GetUnitState(
            unit,
            jass.ConvertUnitState(21)
        )
    end
    if key == "armor" then
        return jass.GetUnitState(
            unit,
            jass.ConvertUnitState(32)
        )
    end
    return 0
end
--- 对 unit 所属玩家的金币做一次百分比加减（pct 可负）
local function applyGoldPct(self, unit, pct)
    local player = jass.GetOwningPlayer(unit)
    if not player then
        return
    end
    local stateGold = jass.ConvertPlayerState(1)
    local cur = jass.GetPlayerState(player, stateGold)
    local delta = math.floor(cur * pct + 0.5)
    local newVal = cur + delta < 0 and 0 or cur + delta
    jass.SetPlayerState(player, stateGold, newVal)
end
local function executeSegment(self, unit, seg)
    local statEffects = {}
    local goldPct = 0
    local goldFixed = {}
    for ____, eff in ipairs(seg.effects) do
        do
            if eff.type == "gold" then
                if eff.isPct then
                    goldPct = goldPct + eff.value
                else
                    local mn = type(eff.min) == "number" and eff.min or 0
                    local mx = type(eff.max) == "number" and eff.max or mn
                    goldFixed[#goldFixed + 1] = {min = mn, max = mx}
                end
            elseif eff.type == "exp" then
                local amount = eff.isLevelMult and math.floor(getHeroLevel(nil, unit) * eff.value) or math.floor(eff.value)
                addHeroXP(nil, unit, amount)
            elseif eff.type == "level" then
                local cur = getHeroLevel(nil, unit)
                local add = eff.isLevelMult and math.floor(cur * eff.value) or math.floor(eff.value)
                if add > 0 then
                    jass.SetHeroLevel(unit, cur + add, true)
                end
            elseif eff.type == "stat" and eff.key ~= nil and eff.key ~= "" then
                local name = KEY_TO_NAME[eff.key]
                if name == nil then
                    goto __continue61
                end
                local val
                if eff.isPct then
                    val = getPctStatValue(nil, unit, eff.key) * eff.value
                elseif eff.isLevelMult then
                    val = getHeroLevel(nil, unit) * eff.value
                else
                    val = eff.value
                end
                statEffects[#statEffects + 1] = {name = name, key = eff.key, value = val}
            end
        end
        ::__continue61::
    end
    if goldPct ~= 0 then
        if seg.timeSec <= 0 then
            applyGoldPct(nil, unit, goldPct)
        else
            local capturedUnit = unit
            local capturedPct = goldPct
            local remaining = math.floor(seg.timeSec)
            local dt = jass.CreateTimer()
            if dt then
                local t = dt
                jass.TimerStart(
                    t,
                    1,
                    true,
                    function()
                        if capturedUnit then
                            if jass.IsUnitType(capturedUnit, jass.UNIT_TYPE_DEAD) then
                                jass.DestroyTimer(t)
                                return
                            end
                        end
                        applyGoldPct(nil, capturedUnit, capturedPct)
                        remaining = remaining - 1
                        if remaining <= 0 then
                            jass.DestroyTimer(t)
                        end
                    end
                )
            end
        end
    end
    if #goldFixed > 0 then
        do
            local i = 0
            while i < #goldFixed do
                local mn = math.floor(goldFixed[i + 1].min)
                local mx = math.floor(goldFixed[i + 1].max)
                local delta = mn
                if mx ~= mn then
                    local a = mn < mx and mn or mx
                    local b = mn < mx and mx or mn
                    delta = math.random(a, b)
                end
                if delta ~= 0 then
                    AddGoldWithFeedback(nil, {delta = delta, unit = unit})
                end
                i = i + 1
            end
        end
    end
    if #statEffects > 0 then
        applyStats(nil, unit, statEffects, true)
        if seg.timeSec > 0 then
            local capturedStats = statEffects
            local capturedUnit = unit
            local dt = jass.CreateTimer()
            if dt then
                local t = dt
                jass.TimerStart(
                    t,
                    seg.timeSec,
                    false,
                    function()
                        applyStats(nil, capturedUnit, capturedStats, false)
                        jass.DestroyTimer(t)
                    end
                )
            end
        end
    end
end
local function onUseItem(self)
    local unit = jass.GetManipulatingUnit()
    local item = jass.GetManipulatedItem()
    if not unit or not item then
        return
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if jass.IsUnitIllusionBJ(unit) then
        return
    end
    local itemId = jass.GetItemTypeId(item)
    local idStr = fourCCToString(nil, itemId)
    local entry = itemsData[idStr]
    if not entry or not entry.PowerUP then
        return
    end
    local glob = _G
    local key = (("__EquipPowerUP_" .. tostring(unit)) .. "_") .. idStr
    if glob[key] then
        return
    end
    glob[key] = true
    local ct = jass.CreateTimer()
    if ct then
        local t = ct
        jass.TimerStart(
            t,
            0.5,
            false,
            function()
                glob[key] = nil
                jass.DestroyTimer(t)
            end
        )
    end
    local segments = parsePowerUP(nil, entry.PowerUP)
    for ____, seg in ipairs(segments) do
        executeSegment(nil, unit, seg)
    end
end
local INIT_KEY = "__EquipPowerUPInited"
local function init(self)
    if g[INIT_KEY] then
        return
    end
    g[INIT_KEY] = true
    local ____jass_EVENT_PLAYER_UNIT_USE_ITEM_2 = jass.EVENT_PLAYER_UNIT_USE_ITEM
    if ____jass_EVENT_PLAYER_UNIT_USE_ITEM_2 == nil then
        ____jass_EVENT_PLAYER_UNIT_USE_ITEM_2 = 35
    end
    local useItemEv = ____jass_EVENT_PLAYER_UNIT_USE_ITEM_2
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i <= 6 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                useItemEv,
                nil
            )
            i = i + 1
        end
    end
    local ____this_4
    ____this_4 = jass
    local ____opt_3 = ____this_4.Player
    if ____opt_3 ~= nil then
        ____opt_3 = ____opt_3(____this_4, 13)
    end
    local p13 = ____opt_3
    if p13 ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, nil)
    end
    jass.TriggerAddAction(trig, onUseItem)
end
init(nil)
return ____exports
