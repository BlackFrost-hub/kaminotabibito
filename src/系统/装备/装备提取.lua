local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local jass = require("jass.common")
local mod = require("系统.装备.装备数据")
local itemsData = mod.items or mod.default or ({})
local function getFirstHeroOfPlayer(self, p)
    local g = jass.CreateGroup()
    jass.GroupEnumUnitsOfPlayer(
        g,
        p,
        jass.Filter(function() return jass.IsUnitType(
            jass.GetFilterUnit(),
            jass.UNIT_TYPE_HERO
        ) end)
    )
    local u = jass.FirstOfGroup(g)
    jass.DestroyGroup(g)
    return u
end
local function stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
local function getItemsByScoreRange(self, minScore, maxScore)
    local result = {}
    for ____, id in ipairs(__TS__ObjectKeys(itemsData)) do
        do
            local __continue6
            repeat
                if type(id) ~= "string" or #id ~= 4 then
                    __continue6 = true
                    break
                end
                local entry = itemsData[id]
                if not entry then
                    __continue6 = true
                    break
                end
                local score = entry.score
                if score ~= nil and score >= minScore and score <= maxScore then
                    result[#result + 1] = id
                end
                __continue6 = true
            until true
            if not __continue6 then
                break
            end
        end
    end
    return result
end
local function shuffleArray(self, arr)
    local a = __TS__ArraySlice(arr)
    do
        local i = #a - 1
        while i > 0 do
            local j = math.floor(math.random() * (i + 1))
            local ____temp_0 = {a[j + 1], a[i + 1]}
            a[i + 1] = ____temp_0[1]
            a[j + 1] = ____temp_0[2]
            i = i - 1
        end
    end
    return a
end
local function createRandomItemInScoreRange(self, minScore, maxScore, x, y)
    local candidates = shuffleArray(
        nil,
        getItemsByScoreRange(nil, minScore, maxScore)
    )
    if #candidates == 0 then
        return nil
    end
    local itemId = candidates[1]
    if type(itemId) ~= "string" or #itemId ~= 4 then
        return nil
    end
    local fourcc = stringToFourCC(nil, itemId)
    return jass.CreateItem(fourcc, x, y)
end
local function onChat233(self)
    math.randomseed(os.clock() * 1000000)
    local ok, item = pcall(function () return createRandomItemInScoreRange(
                nil,
                200,
                250,
                0,
                0
            ) end
        )
    if ok and item then
        local player = jass.GetTriggerPlayer()
        local hero = getFirstHeroOfPlayer(nil, player)
        if hero then
            jass.IssueNeutralTargetOrder(player, hero, "smart", item)
        end
    elseif not ok then
        _G.print(
            "【装备提取】错误:",
            tostring(item)
        )
    end
end
local function init(self)
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i <= 11 do
            jass.TriggerRegisterPlayerChatEvent(
                trig,
                jass.Player(i),
                "233",
                true
            )
            i = i + 1
        end
    end
    jass.TriggerAddAction(trig, onChat233)
end
init(nil)
return ____exports
