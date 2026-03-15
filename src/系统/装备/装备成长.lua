local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local ____exports = {}
--- 装备成长：单位使用物品时，若装备数据有 PowerUP 字段，执行属性成长。
-- 格式：  段1+段2+...，段内用 ; 分隔效果；time>0 表示临时（N秒后撤销），time0/无time=永久
-- 效果类型：Nstat / N%stat / Nexp / Nlevel / (level*N)stat / (level*N)exp
-- 规则详见 .cursor/rules/equip-heal-hot-format.md
local jass = require("jass.common")
local g = require("jass.globals")
local itemsData = require("系统.装备.装备数据").default
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
    baseDmgPct = "基础攻击力%"
}
local function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
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
                local __continue10
                repeat
                    local rawSeg = __TS__StringTrim(rawSegs[si + 1])
                    if rawSeg == "" then
                        __continue10 = true
                        break
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
                            local __continue19
                            repeat
                                if (string.find(t, "(level*", nil, true) or 0) - 1 == 0 then
                                    local closeIdx = (string.find(t, ")", nil, true) or 0) - 1
                                    if closeIdx < 0 then
                                        __continue19 = true
                                        break
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
                                    __continue19 = true
                                    break
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
                                    effects[#effects + 1] = {type = "gold", isPct = true, value = num / 100, isLevelMult = false}
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
                                __continue19 = true
                            until true
                            if not __continue19 then
                                break
                            end
                        end
                    end
                    if #effects > 0 then
                        segments[#segments + 1] = {effects = effects, timeSec = timeSec}
                    end
                    __continue10 = true
                until true
                if not __continue10 then
                    break
                end
            end
            si = si + 1
        end
    end
    return segments
end
--- key → ApplyItemBonus 读取的固定全局变量名
local KEY_TO_UDG = {
    hp = "udg_TempHp",
    mp = "udg_TempMp",
    dmg = "udg_TempDmg",
    armor = "udg_TempArmor",
    atkSpeed = "udg_TempAtkSpeed",
    movespeed = "udg_TempMoveSpeed",
    str = "udg_TempStr",
    agi = "udg_TempAgi",
    int = "udg_TempInt",
    all = "udg_TempAll"
}
--- 通过 ApplyItemBonus 批量加/减属性
-- value 永远传正数；isAdd 控制加/减方向（固定全局由 TempIsAdd 控制符号；TempAmount 需带符号用于数据追踪）
local function applyStats(self, unit, statEffects, isAdd)
    if #statEffects == 0 then
        return
    end
    g.udg_TempHp = 0
    g.udg_TempMp = 0
    g.udg_TempDmg = 0
    g.udg_TempArmor = 0
    g.udg_TempAtkSpeed = 0
    g.udg_TempMoveSpeed = 0
    g.udg_TempStr = 0
    g.udg_TempAgi = 0
    g.udg_TempInt = 0
    g.udg_TempAll = 0
    do
        local i = 0
        while i < #statEffects do
            local udgKey = KEY_TO_UDG[statEffects[i + 1].key]
            if udgKey ~= nil then
                g[udgKey] = statEffects[i + 1].value
            end
            i = i + 1
        end
    end
    jass.udg_TempUnit[1] = unit
    g.udg_TempIsAdd = isAdd
    g.udg_TempStatCount = #statEffects
    g.udg_TempString = {}
    g.udg_TempAmount = {}
    do
        local i = 0
        while i < #statEffects do
            g.udg_TempString[i + 1] = statEffects[i + 1].name
            g.udg_TempAmount[i + 1] = isAdd and statEffects[i + 1].value or -statEffects[i + 1].value
            i = i + 1
        end
    end
    if type(jass.ExecuteFunc) == "function" then
        jass.ExecuteFunc("ApplyItemBonus")
    end
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
            if type(jass.AddHeroXP) == "function" then
                jass.AddHeroXP(unit, chunk, true)
            end
            i = i + 1
        end
    end
    local remainder = amount - chunk * 10
    if remainder > 0 and type(jass.AddHeroXP) == "function" then
        jass.AddHeroXP(unit, remainder, true)
    end
end
local function getHeroLevel(self, unit)
    local ____temp_0
    if type(jass.GetHeroLevel) == "function" then
        ____temp_0 = jass.GetHeroLevel(unit)
    else
        ____temp_0 = 1
    end
    return ____temp_0
end
--- 获取单位当前属性的绝对值，用于百分比计算。
-- str/agi/int 用 GetHeroStr/Agi/Int；hp/mp 用 GetUnitState+ConvertUnitState；
-- dmg=ConvertUnitState(0x15)，armor=ConvertUnitState(0x20)（需要 japi）
local function getPctStatValue(self, unit, key)
    if key == "int" then
        local ____temp_1
        if type(jass.GetHeroInt) == "function" then
            ____temp_1 = jass.GetHeroInt(unit, true)
        else
            ____temp_1 = 0
        end
        return ____temp_1
    end
    if key == "str" then
        local ____temp_2
        if type(jass.GetHeroStr) == "function" then
            ____temp_2 = jass.GetHeroStr(unit, true)
        else
            ____temp_2 = 0
        end
        return ____temp_2
    end
    if key == "agi" then
        local ____temp_3
        if type(jass.GetHeroAgi) == "function" then
            ____temp_3 = jass.GetHeroAgi(unit, true)
        else
            ____temp_3 = 0
        end
        return ____temp_3
    end
    if key == "hp" then
        local ____temp_4
        if type(jass.GetUnitState) == "function" then
            ____temp_4 = jass.GetUnitState(
                unit,
                jass.ConvertUnitState(1)
            )
        else
            ____temp_4 = 0
        end
        return ____temp_4
    end
    if key == "mp" then
        local ____temp_5
        if type(jass.GetUnitState) == "function" then
            ____temp_5 = jass.GetUnitState(
                unit,
                jass.ConvertUnitState(3)
            )
        else
            ____temp_5 = 0
        end
        return ____temp_5
    end
    if key == "dmg" then
        local ____temp_6
        if type(jass.GetUnitState) == "function" then
            ____temp_6 = jass.GetUnitState(
                unit,
                jass.ConvertUnitState(21)
            )
        else
            ____temp_6 = 0
        end
        return ____temp_6
    end
    if key == "armor" then
        local ____temp_7
        if type(jass.GetUnitState) == "function" then
            ____temp_7 = jass.GetUnitState(
                unit,
                jass.ConvertUnitState(32)
            )
        else
            ____temp_7 = 0
        end
        return ____temp_7
    end
    return 0
end
--- 对 unit 所属玩家的金币做一次百分比加减（pct 可负）
local function applyGoldPct(self, unit, pct)
    if type(jass.GetOwningPlayer) ~= "function" then
        return
    end
    local player = jass.GetOwningPlayer(unit)
    if not player then
        return
    end
    local stateGold = jass.ConvertPlayerState(1)
    local ____temp_8
    if type(jass.GetPlayerState) == "function" then
        ____temp_8 = jass.GetPlayerState(player, stateGold)
    else
        ____temp_8 = 0
    end
    local cur = ____temp_8
    local delta = math.floor(cur * pct + 0.5)
    local newVal = cur + delta < 0 and 0 or cur + delta
    if type(jass.SetPlayerState) == "function" then
        jass.SetPlayerState(player, stateGold, newVal)
    end
end
local function executeSegment(self, unit, seg)
    local statEffects = {}
    local goldPct = 0
    for ____, eff in ipairs(seg.effects) do
        do
            local __continue64
            repeat
                if eff.type == "gold" then
                    goldPct = goldPct + eff.value
                elseif eff.type == "exp" then
                    local amount = eff.isLevelMult and math.floor(getHeroLevel(nil, unit) * eff.value) or math.floor(eff.value)
                    addHeroXP(nil, unit, amount)
                elseif eff.type == "level" then
                    local cur = getHeroLevel(nil, unit)
                    local add = eff.isLevelMult and math.floor(cur * eff.value) or math.floor(eff.value)
                    if add > 0 and type(jass.SetHeroLevel) == "function" then
                        jass.SetHeroLevel(unit, cur + add, true)
                    end
                elseif eff.type == "stat" and eff.key ~= nil and eff.key ~= "" then
                    local name = KEY_TO_NAME[eff.key]
                    if name == nil then
                        __continue64 = true
                        break
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
                __continue64 = true
            until true
            if not __continue64 then
                break
            end
        end
    end
    if goldPct ~= 0 then
        if seg.timeSec <= 0 then
            applyGoldPct(nil, unit, goldPct)
        else
            local capturedUnit = unit
            local capturedPct = goldPct
            local remaining = math.floor(seg.timeSec)
            local ____temp_9
            if type(jass.CreateTimer) == "function" then
                ____temp_9 = jass.CreateTimer()
            else
                ____temp_9 = nil
            end
            local dt = ____temp_9
            if dt and type(jass.TimerStart) == "function" then
                local t = dt
                jass.TimerStart(
                    t,
                    1,
                    true,
                    function()
                        applyGoldPct(nil, capturedUnit, capturedPct)
                        remaining = remaining - 1
                        if remaining <= 0 then
                            if type(jass.DestroyTimer) == "function" then
                                jass.DestroyTimer(t)
                            end
                        end
                    end
                )
            end
        end
    end
    if #statEffects > 0 then
        applyStats(nil, unit, statEffects, true)
        if seg.timeSec > 0 then
            local capturedStats = statEffects
            local capturedUnit = unit
            local ____temp_10
            if type(jass.CreateTimer) == "function" then
                ____temp_10 = jass.CreateTimer()
            else
                ____temp_10 = nil
            end
            local dt = ____temp_10
            if dt and type(jass.TimerStart) == "function" then
                local t = dt
                jass.TimerStart(
                    t,
                    seg.timeSec,
                    false,
                    function()
                        applyStats(nil, capturedUnit, capturedStats, false)
                        if type(jass.DestroyTimer) == "function" then
                            jass.DestroyTimer(t)
                        end
                    end
                )
            end
        end
    end
end
local function onUseItem(self)
    local ____temp_11
    if type(jass.GetManipulatingUnit) == "function" then
        ____temp_11 = jass.GetManipulatingUnit()
    else
        ____temp_11 = nil
    end
    local unit = ____temp_11
    local ____temp_12
    if type(jass.GetManipulatedItem) == "function" then
        ____temp_12 = jass.GetManipulatedItem()
    else
        ____temp_12 = nil
    end
    local item = ____temp_12
    if not unit or not item then
        return
    end
    if type(jass.IsUnitType) == "function" and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return
    end
    local ____temp_13
    if type(jass.GetItemTypeId) == "function" then
        ____temp_13 = jass.GetItemTypeId(item)
    else
        ____temp_13 = 0
    end
    local itemId = ____temp_13
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
    local ____temp_14
    if type(jass.CreateTimer) == "function" then
        ____temp_14 = jass.CreateTimer()
    else
        ____temp_14 = nil
    end
    local ct = ____temp_14
    if ct and type(jass.TimerStart) == "function" then
        local t = ct
        jass.TimerStart(
            t,
            0.5,
            false,
            function()
                glob[key] = nil
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
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
    local ____jass_EVENT_PLAYER_UNIT_USE_ITEM_15 = jass.EVENT_PLAYER_UNIT_USE_ITEM
    if ____jass_EVENT_PLAYER_UNIT_USE_ITEM_15 == nil then
        ____jass_EVENT_PLAYER_UNIT_USE_ITEM_15 = 35
    end
    local useItemEv = ____jass_EVENT_PLAYER_UNIT_USE_ITEM_15
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
    local ____this_17
    ____this_17 = jass
    local ____opt_16 = ____this_17.Player
    if ____opt_16 ~= nil then
        ____opt_16 = ____opt_16(____this_17, 13)
    end
    local p13 = ____opt_16
    if p13 ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, nil)
    end
    jass.TriggerAddAction(trig, onUseItem)
end
init(nil)
return ____exports
