local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_4EC7_6068_5B58_50A8 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local getEnemyThreats = ____00_FF0E_4EC7_6068_5B58_50A8.getEnemyThreats
local getHighestThreat = ____00_FF0E_4EC7_6068_5B58_50A8.getHighestThreat
local ____02_FF0E_76EE_6807_9009_62E9 = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
local _____83B7_53D6_5E94_653B_51FB_76EE_6807 = ____02_FF0E_76EE_6807_9009_62E9["获取应攻击目标"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
local Player = jass.Player
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868 = {}
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
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____8DDD_79BB_5E73_65B9(source, target)
    local dx = GetUnitX(source) - GetUnitX(target)
    local dy = GetUnitY(source) - GetUnitY(target)
    return dx * dx + dy * dy
end
local function _____5355_4F4D_5728_5217_8868_4E2D(unit, list)
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
____exports["注册Boss技能测试目标"] = function(unit)
    if not _____5355_4F4D_6709_6548(unit) or _____5355_4F4D_5728_5217_8868_4E2D(unit, ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868) then
        return
    end
    ____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868[#____Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868 + 1] = unit
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
local function _____83B7_53D6_6709_6548Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868(boss)
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
local function _____83B7_53D6_73A9_5BB6_9996_4E2A_5B58_6D3B_82F1_96C4(whichPlayer)
    local registeredHero = getRegisteredPlayerHero(whichPlayer)
    if _____5355_4F4D_6709_6548(registeredHero) and IsUnitType(registeredHero, UNIT_TYPE_HERO) == true then
        return registeredHero
    end
    local group = CreateGroup()
    GroupEnumUnitsOfPlayer(group, whichPlayer, nil)
    local result = nil
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        if _____5355_4F4D_6709_6548(unit) and IsUnitType(unit, UNIT_TYPE_HERO) == true then
            result = unit
            break
        end
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    return result
end
____exports["获取Boss技能敌对英雄列表"] = function(boss)
    local result = {}
    if not _____5355_4F4D_6709_6548(boss) then
        return result
    end
    local testTargets = _____83B7_53D6_6709_6548Boss_6280_80FD_6D4B_8BD5_76EE_6807_5217_8868(boss)
    if #testTargets > 0 then
        return testTargets
    end
    local bossOwner = GetOwningPlayer(boss)
    do
        local pid = 0
        while pid <= 5 do
            local hero = _____83B7_53D6_73A9_5BB6_9996_4E2A_5B58_6D3B_82F1_96C4(Player(pid))
            if _____5355_4F4D_6709_6548(hero) and IsUnitEnemy(hero, bossOwner) == true then
                result[#result + 1] = hero
            end
            pid = pid + 1
        end
    end
    return result
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
                    goto __continue39
                end
                if _____5355_4F4D_5728_5217_8868_4E2D(hero, excludeList) then
                    goto __continue39
                end
                if filter ~= nil and not filter(hero) then
                    goto __continue39
                end
                if centerUnit ~= nil and centerUnit ~= 0 and radius2 > 0 and _____8DDD_79BB_5E73_65B9(centerUnit, hero) > radius2 then
                    goto __continue39
                end
                result[#result + 1] = hero
            end
            ::__continue39::
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
    return heroes[GetRandomInt(0, #heroes - 1) + 1]
end
____exports["获取Boss技能最近敌对英雄Ex"] = function(boss, centerUnit, radius, excludeList, filter, weight)
    local ____centerUnit_1 = centerUnit
    if ____centerUnit_1 == nil then
        ____centerUnit_1 = boss
    end
    local center = ____centerUnit_1
    local heroes = ____exports["获取Boss技能敌对英雄列表Ex"](
        boss,
        center,
        radius,
        excludeList,
        filter
    )
    local best = nil
    local bestScore = 999999999
    do
        local i = 0
        while i < #heroes do
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
    local best = nil
    local bestDistance = 999999999
    do
        local i = 0
        while i < #heroes do
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
    local best = nil
    local bestDistance = -1
    do
        local i = 0
        while i < #heroes do
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
return ____exports
