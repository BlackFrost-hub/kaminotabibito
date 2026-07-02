local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ObjectRest = ____lualib.__TS__ObjectRest
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
local ____02_FF0EDOT_89E3_6790 = require("系统.04．伤害系统.01．DOT定义.02．DOT解析")
local splitItemBuffSegments = ____02_FF0EDOT_89E3_6790.splitItemBuffSegments
function ____exports.createDotBaseUtils(self, deps)
    local jass = deps.jass
    local g = deps.g
    local itemsData = deps.itemsData
    local fourCCToString = deps.fourCCToString
    local GetItemTypeId = jass.GetItemTypeId
    local GetUnitTypeId = jass.GetUnitTypeId
    local function getStructureUnitTypeHandle(self)
        local ____jass_UNIT_TYPE_STRUCTURE_0 = jass.UNIT_TYPE_STRUCTURE
        if ____jass_UNIT_TYPE_STRUCTURE_0 == nil then
            ____jass_UNIT_TYPE_STRUCTURE_0 = g.UNIT_TYPE_STRUCTURE
        end
        local direct = ____jass_UNIT_TYPE_STRUCTURE_0
        if direct ~= nil then
            return direct
        end
        if type(jass.ConvertUnitType) == "function" then
            return jass.ConvertUnitType(64)
        end
        return nil
    end
    local function isDebuffDotTargetOk(self, source, target)
        if source == nil or target == nil or target == 0 then
            return false
        end
        local utStruct = getStructureUnitTypeHandle(nil)
        if utStruct ~= nil then
            if jass.IsUnitType(target, utStruct) == true then
                return false
            end
        end
        local srcP = jass.GetOwningPlayer(source)
        if srcP == nil then
            return false
        end
        return jass.IsUnitEnemy(target, srcP) == true
    end
    local function heroUnitTypeForIsUnitType(self)
        local ____jass_UNIT_TYPE_HERO_1 = jass.UNIT_TYPE_HERO
        if ____jass_UNIT_TYPE_HERO_1 == nil then
            ____jass_UNIT_TYPE_HERO_1 = g.UNIT_TYPE_HERO
        end
        local direct = ____jass_UNIT_TYPE_HERO_1
        if direct ~= nil then
            return direct
        end
        return jass.ConvertUnitType(2)
    end
    local function isSourceHeroPlayer1to4(self, unit)
        if not unit then
            return false
        end
        local owner = jass.GetOwningPlayer(unit)
        local playerIdx = -1
        do
            local i = 0
            while i <= 15 do
                if jass.Player(i) == owner then
                    playerIdx = i
                    break
                end
                i = i + 1
            end
        end
        if playerIdx < 0 or playerIdx > 3 then
            return false
        end
        local utHero = heroUnitTypeForIsUnitType(nil)
        if utHero ~= nil and jass.IsUnitType(unit, utHero) == true then
            return true
        end
        if jass.GetHeroLevel(unit) > 0 then
            return true
        end
        return false
    end
    local function unitItemInSlot(unit, slot)
        return jass.UnitItemInSlot(unit, slot)
    end
    local function getItemTypeId(item)
        return GetItemTypeId(item)
    end
    local function getBestDotFromUnit(self, unit, parseBuff, getProduct)
        local best = nil
        do
            local slot = 0
            while slot <= 5 do
                do
                    local item = unitItemInSlot(unit, slot)
                    if not item then
                        goto __continue25
                    end
                    local idStr = fourCCToString(getItemTypeId(item))
                    local entry = itemsData[idStr]
                    local segments = (entry and entry.Buff) ~= nil and splitItemBuffSegments(nil, entry.Buff) or ({})
                    do
                        local si = 0
                        while si < #segments do
                            do
                                local parsed = parseBuff(nil, segments[si + 1])
                                if not parsed then
                                    goto __continue28
                                end
                                local product = getProduct(nil, parsed)
                                if best == nil or product > best.product then
                                    best = __TS__ObjectAssign({}, parsed, {product = product})
                                end
                            end
                            ::__continue28::
                            si = si + 1
                        end
                    end
                end
                ::__continue25::
                slot = slot + 1
            end
        end
        if best == nil then
            return nil
        end
        local ____best_4 = best
        local product = ____best_4.product
        local result = __TS__ObjectRest(____best_4, {product = true})
        return result
    end
    local function getUnitMaxHp(self, targetUnit)
        if not targetUnit then
            return 0
        end
        local maxLifeState = nil
        if jass.UNIT_STATE_MAX_LIFE ~= nil then
            maxLifeState = jass.UNIT_STATE_MAX_LIFE
        elseif g.UNIT_STATE_MAX_LIFE ~= nil then
            maxLifeState = g.UNIT_STATE_MAX_LIFE
        else
            maxLifeState = jass.ConvertUnitState(1)
        end
        if maxLifeState == nil then
            return 0
        end
        local v = jass.GetUnitState(targetUnit, maxLifeState)
        return type(v) == "number" and __TS__NumberIsFinite(__TS__Number(v)) and v > 0 and v or 0
    end
    local function getTargetRegenHP(self, targetUnit)
        if not targetUnit then
            return 0
        end
        local typeId = GetUnitTypeId(targetUnit)
        local idStr = fourCCToString(typeId)
        local slk = _G.slk
        local slkUnit = slk ~= nil and slk.unit and slk.unit[idStr] or nil
        if slkUnit == nil then
            return 0
        end
        local regenStr = slkUnit.regenHP or slkUnit.regenHP
        if regenStr == nil or type(regenStr) ~= "string" then
            return 0
        end
        local n = __TS__ParseFloat(regenStr)
        return type(n) == "number" and not __TS__NumberIsNaN(__TS__Number(n)) and n or 0
    end
    return {
        isDebuffDotTargetOk = isDebuffDotTargetOk,
        isSourceHeroPlayer1to4 = isSourceHeroPlayer1to4,
        getBestDotFromUnit = getBestDotFromUnit,
        getUnitMaxHp = getUnitMaxHp,
        getTargetRegenHP = getTargetRegenHP
    }
end
return ____exports
