local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_6709_6548, _____8DDD_79BB_5E73_65B9, _____5355_4F4D_5728_5217_8868_4E2D, _____5355_4F4D_53EF_4F5C_4E3ABoss_6280_80FD_654C_5BF9_76EE_6807, _____5355_4F4D_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4, _____6DFB_52A0Boss_6280_80FD_654C_5BF9_76EE_6807, _____83B7_53D6_6709_6548Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868, _____6536_96C6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_6210_5458, _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167, getRegisteredPlayerHero, _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4, IsUnitType, IsUnitEnemy, GetOwningPlayer, GetUnitAbilityLevel, IsUnitIllusion, GetUnitX, GetUnitY, ForGroup, GetEnumUnit, UNIT_TYPE_DEAD, UNIT_TYPE_HERO, UNIT_TYPE_SUMMONED, UNIT_TYPE_ANCIENT, _____8757_866B_6280_80FDID, ____Boss_6280_80FD_9ED8_8BA4_76EE_6807_8303_56F4_5E73_65B9, ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868, _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167_7F13_5B58
local ____00_FF0E_4EC7_6068_5B58_50A8 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local getEnemyThreats = ____00_FF0E_4EC7_6068_5B58_50A8.getEnemyThreats
local getHighestThreat = ____00_FF0E_4EC7_6068_5B58_50A8.getHighestThreat
local ____02_FF0E_76EE_6807_9009_62E9 = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
local _____83B7_53D6_5E94_653B_51FB_76EE_6807 = ____02_FF0E_76EE_6807_9009_62E9["获取应攻击目标"]
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____8DDD_79BB_5E73_65B9(source, target)
    local dx = GetUnitX(source) - GetUnitX(target)
    local dy = GetUnitY(source) - GetUnitY(target)
    return dx * dx + dy * dy
end
function _____5355_4F4D_5728_5217_8868_4E2D(unit, list)
    if list == nil then
        return false
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1] == unit then
                return true
            end
            i = i + 1
        end
    end
    return false
end
function _____5355_4F4D_53EF_4F5C_4E3ABoss_6280_80FD_654C_5BF9_76EE_6807(unit, bossOwner)
    return _____5355_4F4D_6709_6548(unit) and IsUnitEnemy(unit, bossOwner) == true and IsUnitType(unit, UNIT_TYPE_SUMMONED) ~= true and IsUnitIllusion(unit) ~= true and GetUnitAbilityLevel(unit, _____8757_866B_6280_80FDID) <= 0 and IsUnitType(unit, UNIT_TYPE_ANCIENT) ~= true
end
function _____5355_4F4D_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(unit)
    return IsUnitType(unit, UNIT_TYPE_HERO) == true and getRegisteredPlayerHero(GetOwningPlayer(unit)) == unit
end
function _____6DFB_52A0Boss_6280_80FD_654C_5BF9_76EE_6807(unit, boss, bossOwner, playerHeroes, otherHeroes, normalUnits)
    if not _____5355_4F4D_53EF_4F5C_4E3ABoss_6280_80FD_654C_5BF9_76EE_6807(unit, bossOwner) then
        return
    end
    if _____8DDD_79BB_5E73_65B9(boss, unit) > ____Boss_6280_80FD_9ED8_8BA4_76EE_6807_8303_56F4_5E73_65B9 then
        return
    end
    if _____5355_4F4D_5728_5217_8868_4E2D(unit, playerHeroes) or _____5355_4F4D_5728_5217_8868_4E2D(unit, otherHeroes) or _____5355_4F4D_5728_5217_8868_4E2D(unit, normalUnits) then
        return
    end
    if _____5355_4F4D_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(unit) then
        playerHeroes[#playerHeroes + 1] = unit
    elseif IsUnitType(unit, UNIT_TYPE_HERO) == true then
        otherHeroes[#otherHeroes + 1] = unit
    else
        normalUnits[#normalUnits + 1] = unit
    end
end
function _____83B7_53D6_6709_6548Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868(boss)
    local result = {}
    local bossOwner = GetOwningPlayer(boss)
    do
        local i = #____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868 - 1
        while i >= 0 do
            local unit = ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868[i + 1]
            if not _____5355_4F4D_6709_6548(unit) then
                __TS__ArraySplice(____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868, i, 1)
            elseif IsUnitEnemy(unit, bossOwner) == true then
                result[#result + 1] = unit
            end
            i = i - 1
        end
    end
    return result
end
function _____6536_96C6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_6210_5458()
    local unit = GetEnumUnit()
    if unit ~= nil and unit ~= 0 then
        _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167_7F13_5B58[#_____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167_7F13_5B58 + 1] = unit
    end
end
function _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167()
    local group = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if group == nil or group == 0 then
        return {}
    end
    _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    ForGroup(group, _____6536_96C6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_6210_5458)
    local result = _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167_7F13_5B58
    _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    return result
end
____exports["获取Boss技能敌对目标列表"] = function(boss)
    local result = {}
    local playerHeroes = {}
    local otherHeroes = {}
    local normalUnits = {}
    if not _____5355_4F4D_6709_6548(boss) then
        return result
    end
    local bossOwner = GetOwningPlayer(boss)
    local testTargets = _____83B7_53D6_6709_6548Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868(boss)
    if #testTargets > 0 then
        do
            local i = 0
            while i < #testTargets do
                _____6DFB_52A0Boss_6280_80FD_654C_5BF9_76EE_6807(
                    testTargets[i + 1],
                    boss,
                    bossOwner,
                    playerHeroes,
                    otherHeroes,
                    normalUnits
                )
                i = i + 1
            end
        end
    else
        local _____73A9_5BB6_82F1_96C4_5217_8868 = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167()
        do
            local i = 0
            while i < #_____73A9_5BB6_82F1_96C4_5217_8868 do
                _____6DFB_52A0Boss_6280_80FD_654C_5BF9_76EE_6807(
                    _____73A9_5BB6_82F1_96C4_5217_8868[i + 1],
                    boss,
                    bossOwner,
                    playerHeroes,
                    otherHeroes,
                    normalUnits
                )
                i = i + 1
            end
        end
    end
    do
        local i = 0
        while i < #playerHeroes do
            result[#result + 1] = playerHeroes[i + 1]
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #otherHeroes do
            result[#result + 1] = otherHeroes[i + 1]
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #normalUnits do
            result[#result + 1] = normalUnits[i + 1]
            i = i + 1
        end
    end
    return result
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
_____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_0["获取玩家英雄单位组"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
IsUnitType = jass.IsUnitType
IsUnitEnemy = jass.IsUnitEnemy
GetOwningPlayer = jass.GetOwningPlayer
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
IsUnitIllusion = jass.IsUnitIllusion
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
ForGroup = jass.ForGroup
GetEnumUnit = jass.GetEnumUnit
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
UNIT_TYPE_SUMMONED = jass.UNIT_TYPE_SUMMONED
UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
_____8757_866B_6280_80FDID = stringToFourCCSafe("Aloc")
local ____Boss_6280_80FD_9ED8_8BA4_76EE_6807_8303_56F4 = 2500
____Boss_6280_80FD_9ED8_8BA4_76EE_6807_8303_56F4_5E73_65B9 = ____Boss_6280_80FD_9ED8_8BA4_76EE_6807_8303_56F4 * ____Boss_6280_80FD_9ED8_8BA4_76EE_6807_8303_56F4
____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868 = {}
_____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
____exports["获取Boss技能最高仇恨目标"] = function(boss, filter)
    return getHighestThreat(boss, filter)
end
____exports["获取Boss技能应攻击目标"] = function(boss, filter)
    return _____83B7_53D6_5E94_653B_51FB_76EE_6807(boss, filter)
end
____exports["获取Boss技能仇恨目标列表"] = function(boss, filter)
    local entries = getEnemyThreats(boss)
    if filter == nil then
        return entries
    end
    local result = {}
    do
        local i = 0
        while i < #entries do
            if filter(entries[i + 1]) then
                result[#result + 1] = entries[i + 1]
            end
            i = i + 1
        end
    end
    return result
end
local function _____83B7_53D6Boss_6280_80FD_76EE_6807_4F18_5148_7EA7(unit)
    if _____5355_4F4D_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(unit) then
        return 1
    end
    if IsUnitType(unit, UNIT_TYPE_HERO) == true then
        return 2
    end
    return 3
end
local function _____83B7_53D6_6700_9AD8_4F18_5148_7EA7_76EE_6807_6570_91CF(targets)
    if #targets <= 0 then
        return 0
    end
    local priority = _____83B7_53D6Boss_6280_80FD_76EE_6807_4F18_5148_7EA7(targets[1])
    local count = 1
    while count < #targets and _____83B7_53D6Boss_6280_80FD_76EE_6807_4F18_5148_7EA7(targets[count + 1]) == priority do
        count = count + 1
    end
    return count
end
____exports["注册Boss技能测试目标"] = function(unit)
    if not _____5355_4F4D_6709_6548(unit) or _____5355_4F4D_5728_5217_8868_4E2D(unit, ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868) then
        return
    end
    ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868[#____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868 + 1] = unit
end
--- 查询单位是否由 Boss 技能测试系统显式登记。
-- 这里不检查存活状态，因为单位死亡事件回调执行时仍需要识别刚死亡的测试靶。
____exports["是否已登记Boss技能测试目标"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return _____5355_4F4D_5728_5217_8868_4E2D(unit, ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868)
end
____exports["注销Boss技能测试目标"] = function(unit)
    do
        local i = #____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868 - 1
        while i >= 0 do
            if ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868[i + 1] == unit then
                __TS__ArraySplice(____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
end
____exports["获取Boss技能敌对英雄列表"] = function(boss)
    return ____exports["获取Boss技能敌对目标列表"](boss)
end
____exports["获取Boss技能敌对英雄列表Ex"] = function(boss, centerUnit, radius, excludeList, filter)
    local heroes = ____exports["获取Boss技能敌对英雄列表"](boss)
    local result = {}
    local radius2 = radius ~= nil and radius > 0 and radius * radius or 0
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue65
                end
                if _____5355_4F4D_5728_5217_8868_4E2D(hero, excludeList) then
                    goto __continue65
                end
                if filter ~= nil and not filter(hero) then
                    goto __continue65
                end
                if centerUnit ~= nil and centerUnit ~= 0 and radius2 > 0 and _____8DDD_79BB_5E73_65B9(centerUnit, hero) > radius2 then
                    goto __continue65
                end
                result[#result + 1] = hero
            end
            ::__continue65::
            i = i + 1
        end
    end
    return result
end
____exports["获取Boss技能随机敌对英雄"] = function(boss, centerUnit, radius, excludeList, filter)
    local heroes = ____exports["获取Boss技能敌对英雄列表Ex"](
        boss,
        centerUnit,
        radius,
        excludeList,
        filter
    )
    if #heroes <= 0 then
        return nil
    end
    local priorityCount = _____83B7_53D6_6700_9AD8_4F18_5148_7EA7_76EE_6807_6570_91CF(heroes)
    return heroes[GetRandomInt(0, priorityCount - 1) + 1]
end
____exports["获取Boss技能最近敌对英雄Ex"] = function(boss, centerUnit, radius, excludeList, filter, weight)
    local ____centerUnit_2 = centerUnit
    if ____centerUnit_2 == nil then
        ____centerUnit_2 = boss
    end
    local center = ____centerUnit_2
    local heroes = ____exports["获取Boss技能敌对英雄列表Ex"](
        boss,
        center,
        radius,
        excludeList,
        filter
    )
    local priorityCount = _____83B7_53D6_6700_9AD8_4F18_5148_7EA7_76EE_6807_6570_91CF(heroes)
    local best = nil
    local bestScore = 999999999
    do
        local i = 0
        while i < priorityCount do
            local hero = heroes[i + 1]
            local w = weight ~= nil and weight(hero) or 1
            local score = w > 0 and _____8DDD_79BB_5E73_65B9(center, hero) / w or _____8DDD_79BB_5E73_65B9(center, hero)
            if score < bestScore then
                bestScore = score
                best = hero
            end
            i = i + 1
        end
    end
    return best
end
____exports["获取Boss技能最近敌对英雄"] = function(boss)
    local heroes = ____exports["获取Boss技能敌对英雄列表"](boss)
    local priorityCount = _____83B7_53D6_6700_9AD8_4F18_5148_7EA7_76EE_6807_6570_91CF(heroes)
    local best = nil
    local bestDistance = 999999999
    do
        local i = 0
        while i < priorityCount do
            local distance = _____8DDD_79BB_5E73_65B9(boss, heroes[i + 1])
            if distance < bestDistance then
                bestDistance = distance
                best = heroes[i + 1]
            end
            i = i + 1
        end
    end
    return best
end
____exports["获取Boss技能最远敌对英雄"] = function(boss)
    local heroes = ____exports["获取Boss技能敌对英雄列表"](boss)
    local priorityCount = _____83B7_53D6_6700_9AD8_4F18_5148_7EA7_76EE_6807_6570_91CF(heroes)
    local best = nil
    local bestDistance = -1
    do
        local i = 0
        while i < priorityCount do
            local distance = _____8DDD_79BB_5E73_65B9(boss, heroes[i + 1])
            if distance > bestDistance then
                bestDistance = distance
                best = heroes[i + 1]
            end
            i = i + 1
        end
    end
    return best
end
____exports["获取Boss技能最远敌对英雄Ex"] = function(boss, centerUnit, radius, excludeList, filter)
    local ____centerUnit_3 = centerUnit
    if ____centerUnit_3 == nil then
        ____centerUnit_3 = boss
    end
    local center = ____centerUnit_3
    local heroes = ____exports["获取Boss技能敌对英雄列表Ex"](
        boss,
        center,
        radius,
        excludeList,
        filter
    )
    local priorityCount = _____83B7_53D6_6700_9AD8_4F18_5148_7EA7_76EE_6807_6570_91CF(heroes)
    local best = nil
    local bestDistance = -1
    do
        local i = 0
        while i < priorityCount do
            local distance = _____8DDD_79BB_5E73_65B9(center, heroes[i + 1])
            if distance > bestDistance then
                bestDistance = distance
                best = heroes[i + 1]
            end
            i = i + 1
        end
    end
    return best
end
return ____exports
