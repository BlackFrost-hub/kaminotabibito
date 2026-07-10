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
local applyStats, _____505C_6B62_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5, _____786E_4FDD_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5, _____5B89_6392_88C5_5907_6210_957F_5C5E_6027_56DE_9000, _____5B89_6392_88C5_5907_6210_957F_9632_6296_6E05_7406, _____5904_7406_88C5_5907_6210_957F_5C5E_6027_56DE_9000_5230_671F, _____5904_7406_88C5_5907_6210_957F_9632_6296_5230_671F, ____on_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5, addPeriodicCallback, removePeriodicCallback, getServerTime, applyEquipStatsTS, _____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2, _____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868, _____88C5_5907_6210_957F_56DE_9000_5C5E_6027_5217_8868, _____88C5_5907_6210_957F_56DE_9000_5230_671F_6BEB_79D2_5217_8868, _____88C5_5907_6210_957F_9632_6296_952E_5217_8868, _____88C5_5907_6210_957F_9632_6296_5230_671F_6BEB_79D2_5217_8868, _____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_56DE_8C03ID
function applyStats(unit, statEffects, isAdd)
    if #statEffects == 0 then
        return
    end
    local payload = isAdd and statEffects or __TS__ArrayMap(
        statEffects,
        function(____, x) return __TS__ObjectAssign({}, x, {value = -x.value}) end
    )
    applyEquipStatsTS(unit, payload)
end
function _____505C_6B62_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5()
    if _____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_56DE_8C03ID)
    _____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_56DE_8C03ID = 0
end
function _____786E_4FDD_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5()
    if _____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_56DE_8C03ID > 0 then
        return
    end
    _____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2, ____on_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5)
end
function _____5B89_6392_88C5_5907_6210_957F_5C5E_6027_56DE_9000(unit, stats, delaySec)
    _____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868[#_____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868 + 1] = unit
    _____88C5_5907_6210_957F_56DE_9000_5C5E_6027_5217_8868[#_____88C5_5907_6210_957F_56DE_9000_5C5E_6027_5217_8868 + 1] = stats
    _____88C5_5907_6210_957F_56DE_9000_5230_671F_6BEB_79D2_5217_8868[#_____88C5_5907_6210_957F_56DE_9000_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + delaySec * 1000
    _____786E_4FDD_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5()
end
function _____5B89_6392_88C5_5907_6210_957F_9632_6296_6E05_7406(key, delaySec)
    _____88C5_5907_6210_957F_9632_6296_952E_5217_8868[#_____88C5_5907_6210_957F_9632_6296_952E_5217_8868 + 1] = key
    _____88C5_5907_6210_957F_9632_6296_5230_671F_6BEB_79D2_5217_8868[#_____88C5_5907_6210_957F_9632_6296_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + delaySec * 1000
    _____786E_4FDD_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5()
end
function _____5904_7406_88C5_5907_6210_957F_5C5E_6027_56DE_9000_5230_671F(now)
    local writeIndex = 0
    do
        local i = 0
        while i < #_____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868 do
            if now >= _____88C5_5907_6210_957F_56DE_9000_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                applyStats(_____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868[i + 1], _____88C5_5907_6210_957F_56DE_9000_5C5E_6027_5217_8868[i + 1], false)
            else
                _____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868[writeIndex + 1] = _____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868[i + 1]
                _____88C5_5907_6210_957F_56DE_9000_5C5E_6027_5217_8868[writeIndex + 1] = _____88C5_5907_6210_957F_56DE_9000_5C5E_6027_5217_8868[i + 1]
                _____88C5_5907_6210_957F_56DE_9000_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____88C5_5907_6210_957F_56DE_9000_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868)
            table.remove(_____88C5_5907_6210_957F_56DE_9000_5C5E_6027_5217_8868)
            table.remove(_____88C5_5907_6210_957F_56DE_9000_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
end
function _____5904_7406_88C5_5907_6210_957F_9632_6296_5230_671F(now)
    local writeIndex = 0
    do
        local i = 0
        while i < #_____88C5_5907_6210_957F_9632_6296_952E_5217_8868 do
            if now >= _____88C5_5907_6210_957F_9632_6296_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                _G[_____88C5_5907_6210_957F_9632_6296_952E_5217_8868[i + 1]] = nil
            else
                _____88C5_5907_6210_957F_9632_6296_952E_5217_8868[writeIndex + 1] = _____88C5_5907_6210_957F_9632_6296_952E_5217_8868[i + 1]
                _____88C5_5907_6210_957F_9632_6296_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____88C5_5907_6210_957F_9632_6296_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____88C5_5907_6210_957F_9632_6296_952E_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____88C5_5907_6210_957F_9632_6296_952E_5217_8868)
            table.remove(_____88C5_5907_6210_957F_9632_6296_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
end
function ____on_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5()
    local now = getServerTime()
    _____5904_7406_88C5_5907_6210_957F_5C5E_6027_56DE_9000_5230_671F(now)
    _____5904_7406_88C5_5907_6210_957F_9632_6296_5230_671F(now)
    if #_____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868 <= 0 and #_____88C5_5907_6210_957F_9632_6296_952E_5217_8868 <= 0 then
        _____505C_6B62_88C5_5907_6210_957F_8BA1_65F6_68C0_67E5()
    end
end
--- 装备成长：单位使用物品时，若装备数据有 PowerUP 字段，执行属性成长。
-- 格式：  段1+段2+...，段内用 ; 分隔效果；time>0 表示临时（N秒后撤销），time0/无time=永久
-- 效果类型：Nstat / N%stat / Nexp / Nlevel / (level*N)stat / (level*N)exp
-- 规则详见 `.cursor/rules/gameplay/equipment/heal-hot-format.md`
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local round = ____require_result_1.round
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemUse = ____require_result_2.onItemUse
local g = require("jass.globals")
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AddGoldWithFeedback = ____require_result_3.AddGoldWithFeedback
local fourCCToString = ____require_result_3.fourCCToString
local ____require_result_4 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local IsUnitIllusionBJ = ____require_result_4.IsUnitIllusionBJ
local itemRelatedFns = require("lib.扩展函数.物品相关函数.index")
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
applyEquipStatsTS = ____require_result_5.applyEquipStatsTS
local ____G_6 = _G
local onSecond = ____G_6.onSecond
local offSecond = ____G_6.offSecond
local function parsePowerUP(powerUpStr)
    local segments = {}
    local rawSegs = __TS__StringSplit(powerUpStr, "+")
    do
        local si = 0
        while si < #rawSegs do
            do
                local rawSeg = __TS__StringTrim(rawSegs[si + 1])
                if rawSeg == "" then
                    goto __continue4
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
                                goto __continue13
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
                            goto __continue13
                        end
                        if (string.find(t, "(level*", nil, true) or 0) - 1 == 0 then
                            local closeIdx = (string.find(t, ")", nil, true) or 0) - 1
                            if closeIdx < 0 then
                                goto __continue13
                            end
                            local mult = __TS__ParseFloat(__TS__StringSubstring(t, 7, closeIdx)) or 0
                            local rawKey = __TS__StringTrim(__TS__StringSubstring(t, closeIdx + 1))
                            local kl = string.lower(rawKey)
                            if kl == "exp" then
                                effects[#effects + 1] = {type = "exp", isPct = false, value = mult, isLevelMult = true}
                            elseif kl == "level" then
                                effects[#effects + 1] = {type = "level", isPct = false, value = mult, isLevelMult = true}
                            else
                                local ak = itemRelatedFns.findStatKey(rawKey)
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
                            goto __continue13
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
                            local ak = itemRelatedFns.findStatKey(rawKey)
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
                    ::__continue13::
                end
                if #effects > 0 then
                    segments[#segments + 1] = {effects = effects, timeSec = timeSec}
                end
            end
            ::__continue4::
            si = si + 1
        end
    end
    return segments
end
--- 分 10 份给经验，避免跳级触发不到
local function addHeroXP(unit, amount)
    if amount <= 0 then
        return
    end
    local chunk = jass.R2I(amount / 10)
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
local function getHeroLevel(unit)
    return jass.GetHeroLevel(unit)
end
--- 获取单位当前属性的绝对值，用于百分比计算。
-- str/agi/int 用 GetHeroStr/Agi/Int；hp/mp 用 GetUnitState+ConvertUnitState；
-- dmg=ConvertUnitState(0x15)，armor=ConvertUnitState(0x20)（需要 japi）
local function getPctStatValue(unit, key)
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
local function applyGoldPct(unit, pct)
    local player = jass.GetOwningPlayer(unit)
    if not player then
        return
    end
    local stateGold = jass.ConvertPlayerState(1)
    local cur = jass.GetPlayerState(player, stateGold)
    local delta = round(cur * pct)
    local newVal = cur + delta < 0 and 0 or cur + delta
    jass.SetPlayerState(player, stateGold, newVal)
end
local function executeSegment(unit, seg)
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
                local ____eff_isLevelMult_7
                if eff.isLevelMult then
                    ____eff_isLevelMult_7 = jass.R2I(getHeroLevel(unit) * eff.value)
                else
                    ____eff_isLevelMult_7 = jass.R2I(eff.value)
                end
                local amount = ____eff_isLevelMult_7
                addHeroXP(unit, amount)
            elseif eff.type == "level" then
                local cur = getHeroLevel(unit)
                local ____eff_isLevelMult_8
                if eff.isLevelMult then
                    ____eff_isLevelMult_8 = jass.R2I(cur * eff.value)
                else
                    ____eff_isLevelMult_8 = jass.R2I(eff.value)
                end
                local add = ____eff_isLevelMult_8
                if add > 0 then
                    jass.SetHeroLevel(unit, cur + add, true)
                end
            elseif eff.type == "stat" and eff.key ~= nil and eff.key ~= "" then
                local name = itemRelatedFns.KEY_TO_NAME[eff.key]
                if name == nil then
                    goto __continue56
                end
                local val
                if eff.isPct then
                    val = getPctStatValue(unit, eff.key) * eff.value
                elseif eff.isLevelMult then
                    val = getHeroLevel(unit) * eff.value
                else
                    val = eff.value
                end
                statEffects[#statEffects + 1] = {name = name, key = eff.key, value = val}
            end
        end
        ::__continue56::
    end
    if goldPct ~= 0 then
        if seg.timeSec <= 0 then
            applyGoldPct(unit, goldPct)
        else
            local capturedUnit = unit
            local capturedPct = goldPct
            local remaining = jass.R2I(seg.timeSec)
            local cb
            cb = function()
                if capturedUnit and jass.IsUnitType(capturedUnit, jass.UNIT_TYPE_DEAD) then
                    offSecond(cb)
                    return
                end
                applyGoldPct(capturedUnit, capturedPct)
                remaining = remaining - 1
                if remaining <= 0 then
                    offSecond(cb)
                end
            end
            onSecond(cb)
        end
    end
    if #goldFixed > 0 then
        do
            local i = 0
            while i < #goldFixed do
                local mn = jass.R2I(goldFixed[i + 1].min)
                local mx = jass.R2I(goldFixed[i + 1].max)
                local delta = mn
                if mx ~= mn then
                    local ____temp_9
                    if mn < mx then
                        ____temp_9 = mn
                    else
                        ____temp_9 = mx
                    end
                    local a = ____temp_9
                    local ____temp_10
                    if mn < mx then
                        ____temp_10 = mx
                    else
                        ____temp_10 = mn
                    end
                    local b = ____temp_10
                    delta = jass.GetRandomInt(a, b)
                end
                if delta ~= 0 then
                    AddGoldWithFeedback(nil, {delta = delta, unit = unit})
                end
                i = i + 1
            end
        end
    end
    if #statEffects > 0 then
        applyStats(unit, statEffects, true)
        if seg.timeSec > 0 then
            local capturedStats = statEffects
            local capturedUnit = unit
            _____5B89_6392_88C5_5907_6210_957F_5C5E_6027_56DE_9000(capturedUnit, capturedStats, seg.timeSec)
        end
    end
end
local function onUseItem()
    local unit = jass.GetManipulatingUnit()
    local item = jass.GetManipulatedItem()
    if not unit or not item then
        return
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if IsUnitIllusionBJ(nil, unit) then
        return
    end
    local entry = itemRelatedFns.getItemDataEntry(item)
    if not entry or not entry.PowerUP then
        return
    end
    local glob = _G
    local idStr = fourCCToString(GetItemTypeId(item))
    local key = (("__EquipPowerUP_" .. tostring(unit)) .. "_") .. idStr
    if glob[key] then
        return
    end
    glob[key] = true
    _____5B89_6392_88C5_5907_6210_957F_9632_6296_6E05_7406(key, 0.5)
    local segments = parsePowerUP(entry.PowerUP)
    for ____, seg in ipairs(segments) do
        executeSegment(unit, seg)
    end
end
local INIT_KEY = "__EquipPowerUPInited"
_____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2 = 10
_____88C5_5907_6210_957F_56DE_9000_5355_4F4D_5217_8868 = {}
_____88C5_5907_6210_957F_56DE_9000_5C5E_6027_5217_8868 = {}
_____88C5_5907_6210_957F_56DE_9000_5230_671F_6BEB_79D2_5217_8868 = {}
_____88C5_5907_6210_957F_9632_6296_952E_5217_8868 = {}
_____88C5_5907_6210_957F_9632_6296_5230_671F_6BEB_79D2_5217_8868 = {}
_____88C5_5907_6210_957F_8BA1_65F6_68C0_67E5_56DE_8C03ID = 0
local function init()
    if g[INIT_KEY] then
        return
    end
    g[INIT_KEY] = true
    onItemUse(function(unit, item)
        onUseItem()
    end)
end
init()
return ____exports
