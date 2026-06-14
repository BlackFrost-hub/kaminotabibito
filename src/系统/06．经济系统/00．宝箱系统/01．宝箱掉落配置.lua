local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayPushArray = ____lualib.__TS__ArrayPushArray
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local jass = require("jass.common")
local ____require_result_0 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
local getChestConfigByString = ____require_result_0.getChestConfigByString
local ____require_result_1 = require("系统.02．物品系统.01．装备数据")
local items = ____require_result_1.items
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_2.resolveItemIdByName
local ____require_result_3 = require("系统.02．物品系统.14．按等级随机装备")
local _____6309_7269_54C1_6C60_540D_968F_673A_88C5_5907ID = ____require_result_3["按物品池名随机装备ID"]
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____require_result_4["广播提示玩家槽数"]
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6 = ____require_result_5["发送头像提示给玩家"]
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setBuff = ____require_result_6.SFB_setBuff
local ____require_result_7 = require("系统.00．核心系统.01．颜色常量")
local _____88C5_5907_7B49_7EA7_663E_793A_6587_672C = ____require_result_7["装备等级显示文本"]
local _____88C5_5907_540D_5B57_989C_8272_6587_672C = ____require_result_7["装备名字颜色文本"]
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_8.debugLogForce
local ____require_result_9 = require("系统.02．物品系统.09．装备排泄")
local setLastCreatedItem = ____require_result_9.setLastCreatedItem
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local CreateItem = jass.CreateItem
local GetWidgetLife = jass.GetWidgetLife
local SetWidgetLife = jass.SetWidgetLife
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerName = jass.GetPlayerName
local Player = jass.Player
local _____5587_53ED_8DEF_5F84 = "UI\\xiaoxi\\UInotice.tga"
local _____88C5_5907_7CFB_7EDF_6D88_606F_6301_7EED_6BEB_79D2 = 6500
local function stringToFourCC(s)
    if s == nil or #s < 4 then
        return 0
    end
    local a = #s > 0 and (string.byte(s, 1) or 0 / 0) or 0
    local b = #s > 1 and (string.byte(s, 2) or 0 / 0) or 0
    local c = #s > 2 and (string.byte(s, 3) or 0 / 0) or 0
    local d = #s > 3 and (string.byte(s, 4) or 0 / 0) or 0
    return a * 16777216 + b * 65536 + c * 256 + d
end
local itemAliasMap = __TS__New(Map)
local DROP_OFFSETS = {
    {dx = 0, dy = 0},
    {dx = 18, dy = 0},
    {dx = -18, dy = 0},
    {dx = 0, dy = 18},
    {dx = 0, dy = -18},
    {dx = 12, dy = 12},
    {dx = -12, dy = 12},
    {dx = 12, dy = -12},
    {dx = -12, dy = -12}
}
local function _____6807_51C6_5316_7269_54C1_522B_540D(name)
    local result = ""
    do
        local i = 0
        while i < #name do
            do
                local ch = __TS__StringCharAt(name, i)
                if ch == "|" then
                    local next = __TS__StringCharAt(name, i + 1)
                    if next == "r" or next == "R" then
                        i = i + 1
                        goto __continue6
                    end
                    if next == "c" or next == "C" then
                        i = i + 9
                        goto __continue6
                    end
                end
                result = result .. ch
            end
            ::__continue6::
            i = i + 1
        end
    end
    return __TS__StringTrim(result)
end
local function _____6CE8_518C_7269_54C1_522B_540D(alias, itemId)
    local normalized = _____6807_51C6_5316_7269_54C1_522B_540D(alias)
    if not normalized then
        return
    end
    if not itemAliasMap:has(normalized) then
        itemAliasMap:set(normalized, itemId)
    end
end
for ____, ____value in ipairs(__TS__ObjectEntries(items)) do
    local itemId = ____value[1]
    local data = ____value[2]
    itemAliasMap:set(itemId, itemId)
    if data and data.name then
        _____6CE8_518C_7269_54C1_522B_540D(data.name, itemId)
    end
end
local function _____6309_540D_5B57_67E5_627E_7269_54C1ID(name)
    local normalized = _____6807_51C6_5316_7269_54C1_522B_540D(name)
    for ____, ____value in ipairs(__TS__ObjectEntries(items)) do
        local itemId = ____value[1]
        local data = ____value[2]
        if _____6807_51C6_5316_7269_54C1_522B_540D(data and data.name or "") == normalized then
            return itemId
        end
    end
    return nil
end
local function _____89E3_6790_6389_843D_7269_54C1ID(token)
    local trimmed = __TS__StringTrim(token)
    if not trimmed then
        return trimmed
    end
    if #trimmed == 4 and items[trimmed] ~= nil then
        return trimmed
    end
    return resolveItemIdByName(trimmed) or itemAliasMap:get(_____6807_51C6_5316_7269_54C1_522B_540D(trimmed)) or _____6309_540D_5B57_67E5_627E_7269_54C1ID(trimmed) or trimmed
end
local function randomReal01()
    return GetRandomReal(0, 1) or 0
end
local function randomInt(min, max)
    return GetRandomInt(min, max) or min
end
local function _____89E3_6790_7269_54C1_6C60(poolStr)
    local entries = {}
    local parts = __TS__StringSplit(poolStr, ";")
    for ____, part in ipairs(parts) do
        do
            local trimmed = __TS__StringTrim(part)
            if not trimmed then
                goto __continue26
            end
            if __TS__StringIncludes(trimmed, ":") then
                local splitParts = __TS__StringSplit(trimmed, ":")
                local id = _____89E3_6790_6389_843D_7269_54C1ID(splitParts[1] or "")
                local parsedWeight = __TS__ParseFloat(splitParts[2] or "")
                local weight = parsedWeight > 0 and parsedWeight or 1
                debugLogForce(
                    "宝箱掉落配置",
                    "解析池条目",
                    "raw=",
                    trimmed,
                    "id=",
                    id,
                    "weight=",
                    weight
                )
                entries[#entries + 1] = {id = id, weight = weight}
            else
                local id = _____89E3_6790_6389_843D_7269_54C1ID(trimmed)
                debugLogForce(
                    "宝箱掉落配置",
                    "解析池条目",
                    "raw=",
                    trimmed,
                    "id=",
                    id,
                    "weight=",
                    1
                )
                entries[#entries + 1] = {id = id, weight = 1}
            end
        end
        ::__continue26::
    end
    return entries
end
local function _____6309_6743_91CD_62BD_53D6_53EF_91CD_590D(pool, picks)
    local result = {}
    local totalWeight = 0
    for ____, entry in ipairs(pool) do
        totalWeight = totalWeight + entry.weight
    end
    if totalWeight <= 0 then
        return result
    end
    do
        local i = 0
        while i < picks do
            local r = randomReal01() * totalWeight
            for ____, entry in ipairs(pool) do
                r = r - entry.weight
                if r <= 0 then
                    result[#result + 1] = entry.id
                    break
                end
            end
            i = i + 1
        end
    end
    return result
end
local function _____6309_5747_5300_62BD_53D6_4E0D_91CD_590D(pool, picks)
    local shuffled = {table.unpack(pool)}
    do
        local i = #shuffled - 1
        while i >= 1 do
            local j = randomInt(1, i + 1) - 1
            local t = shuffled[i + 1]
            shuffled[i + 1] = shuffled[j + 1]
            shuffled[j + 1] = t
            i = i - 1
        end
    end
    local count = picks < #shuffled and picks or #shuffled
    return __TS__ArrayMap(
        __TS__ArraySlice(shuffled, 0, count),
        function(____, entry) return entry.id end
    )
end
local function _____6309_5206_6570_7B5B_9009_7269_54C1(min, max)
    local result = {}
    local entries = __TS__ArraySort(
        __TS__ObjectEntries(items),
        function(____, ____bindingPattern0, ____bindingPattern1)
            local a
            a = ____bindingPattern0[1]
            local b
            b = ____bindingPattern1[1]
            return a < b and -1 or (a > b and 1 or 0)
        end
    )
    for ____, ____value in ipairs(entries) do
        local itemId = ____value[1]
        local data = ____value[2]
        do
            local score = data and data.score
            if score == nil then
                goto __continue46
            end
            if score < min or score > max then
                goto __continue46
            end
            result[#result + 1] = itemId
        end
        ::__continue46::
    end
    return result
end
local function _____89E3_6790_5FC5_6389_7269_54C1(alwaysStr)
    if not alwaysStr then
        return {}
    end
    local result = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(alwaysStr, ";"),
            function(____, s) return _____89E3_6790_6389_843D_7269_54C1ID(s) end
        ),
        function(____, itemId) return items[itemId] ~= nil end
    )
    debugLogForce(
        "宝箱掉落配置",
        "解析必掉",
        "raw=",
        alwaysStr,
        "result=",
        table.concat(result, ",")
    )
    return result
end
local function _____6309_6389_843D_6A21_5F0F_6267_884C(dropMode, picks)
    local result = {}
    if dropMode.always ~= nil and dropMode.always then
        __TS__ArrayPushArray(
            result,
            _____89E3_6790_5FC5_6389_7269_54C1(dropMode.always)
        )
    end
    repeat
        local ____switch56 = dropMode.type
        local ____cond56 = ____switch56 == "pool"
        if ____cond56 then
            do
                local pool = _____89E3_6790_7269_54C1_6C60(dropMode.items)
                if #pool > 0 and picks > 0 then
                    local hasWeight = __TS__ArraySome(
                        pool,
                        function(____, entry) return entry.weight ~= 1 end
                    )
                    local drawn = hasWeight and _____6309_6743_91CD_62BD_53D6_53EF_91CD_590D(pool, picks) or _____6309_5747_5300_62BD_53D6_4E0D_91CD_590D(pool, picks)
                    __TS__ArrayPushArray(result, drawn)
                end
                break
            end
        end
        ____cond56 = ____cond56 or ____switch56 == "mixed"
        if ____cond56 then
            do
                local pool = _____89E3_6790_7269_54C1_6C60(dropMode.items)
                if #pool > 0 then
                    pool = __TS__ArrayFilter(
                        pool,
                        function(____, entry)
                            local ____opt_16 = items[entry.id]
                            local score = ____opt_16 and ____opt_16.score
                            return score ~= nil and score >= dropMode.range.min and score <= dropMode.range.max
                        end
                    )
                end
                if #pool > 0 and picks > 0 then
                    __TS__ArrayPushArray(
                        result,
                        _____6309_6743_91CD_62BD_53D6_53EF_91CD_590D(pool, picks)
                    )
                end
                break
            end
        end
        ____cond56 = ____cond56 or ____switch56 == "score"
        if ____cond56 then
            do
                local itemIds = _____6309_5206_6570_7B5B_9009_7269_54C1(dropMode.range.min, dropMode.range.max)
                if #itemIds > 0 and picks > 0 then
                    local pool = __TS__ArrayMap(
                        itemIds,
                        function(____, id) return {id = id, weight = 1} end
                    )
                    __TS__ArrayPushArray(
                        result,
                        _____6309_5747_5300_62BD_53D6_4E0D_91CD_590D(pool, picks)
                    )
                end
                break
            end
        end
    until true
    return result
end
local function _____6309_6743_91CD_62BD_53D6_7B49_7EA7_6C60(_____5019_9009_7B49_7EA7_6C60)
    local _____603B_6743_91CD = 0
    for ____, _____5019_9009 in ipairs(_____5019_9009_7B49_7EA7_6C60) do
        _____603B_6743_91CD = _____603B_6743_91CD + _____5019_9009["权重"]
    end
    if _____603B_6743_91CD <= 0 then
        return nil
    end
    local r = randomReal01() * _____603B_6743_91CD
    for ____, _____5019_9009 in ipairs(_____5019_9009_7B49_7EA7_6C60) do
        r = r - _____5019_9009["权重"]
        if r <= 0 then
            return _____5019_9009
        end
    end
    return _____5019_9009_7B49_7EA7_6C60[#_____5019_9009_7B49_7EA7_6C60]
end
local function _____5E7F_64AD_5B9D_7BB1_88C5_5907_6D88_606F(_____52A8_4F5C, _____4E0A_4E0B_6587)
    local ____debugLogForce_21 = debugLogForce
    local ____array_20 = __TS__SparseArrayNew(
        "宝箱掉落配置",
        "广播检查",
        "ownerUnit=",
        _____4E0A_4E0B_6587["宝箱主人"] ~= nil,
        "itemId=",
        _____4E0A_4E0B_6587["最近装备物品ID"] or "",
        "levelText=",
        _____4E0A_4E0B_6587["最近装备等级文本"] or "",
        "chestType="
    )
    local ____opt_18 = _____4E0A_4E0B_6587["宝箱配置"]
    __TS__SparseArrayPush(____array_20, ____opt_18 and ____opt_18.destructableType or "")
    ____debugLogForce_21(__TS__SparseArraySpread(____array_20))
    if not _____4E0A_4E0B_6587["开启者"] or not _____4E0A_4E0B_6587["最近装备物品ID"] or not _____4E0A_4E0B_6587["最近装备等级文本"] then
        debugLogForce("宝箱掉落配置", "跳过装备系统消息", "reason=", "missing_context")
        return
    end
    local ____opt_22 = items[_____4E0A_4E0B_6587["最近装备物品ID"]]
    local _____88C5_5907_540D = ____opt_22 and ____opt_22.name or _____4E0A_4E0B_6587["最近装备物品ID"]
    local _____73A9_5BB6_540D = GetPlayerName(GetOwningPlayer(_____4E0A_4E0B_6587["开启者"]))
    local _____7B49_7EA7Key = __TS__StringTrim(tostring(_____4E0A_4E0B_6587["最近装备等级文本"] or ""))
    local _____7B49_7EA7_6587_672C = _____88C5_5907_7B49_7EA7_663E_793A_6587_672C(nil, _____7B49_7EA7Key, _____7B49_7EA7Key)
    local _____88C5_5907_6587_672C = _____88C5_5907_540D_5B57_989C_8272_6587_672C(nil, _____88C5_5907_540D, _____7B49_7EA7Key)
    local _____6587_672C = ((((_____73A9_5BB6_540D .. _____52A8_4F5C["文本前缀"]) .. _____7B49_7EA7_6587_672C) .. "装备『") .. _____88C5_5907_6587_672C) .. "』"
    debugLogForce(
        "宝箱掉落配置",
        "发送装备系统消息",
        "text=",
        _____6587_672C,
        "icon=",
        _____5587_53ED_8DEF_5F84
    )
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
                Player(_____73A9_5BB6ID),
                _____5587_53ED_8DEF_5F84,
                _____6587_672C,
                _____88C5_5907_7CFB_7EDF_6D88_606F_6301_7EED_6BEB_79D2
            )
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
local function _____6267_884C_9AD8_7EA7_6389_843D_52A8_4F5C(_____52A8_4F5C, _____7ED3_679C, _____4E0A_4E0B_6587)
    repeat
        local ____switch79 = _____52A8_4F5C.type
        local ____cond79 = ____switch79 == "创建物品"
        if ____cond79 then
            do
                local itemId = _____89E3_6790_6389_843D_7269_54C1ID(_____52A8_4F5C["物品"])
                if items[itemId] ~= nil then
                    _____7ED3_679C[#_____7ED3_679C + 1] = itemId
                end
                return
            end
        end
        ____cond79 = ____cond79 or ____switch79 == "创建物品二选一"
        if ____cond79 then
            do
                local roll = randomInt(1, 2)
                local itemId = _____89E3_6790_6389_843D_7269_54C1ID(roll == 1 and _____52A8_4F5C["物品1"] or _____52A8_4F5C["物品2"])
                if items[itemId] ~= nil then
                    _____7ED3_679C[#_____7ED3_679C + 1] = itemId
                end
                return
            end
        end
        ____cond79 = ____cond79 or ____switch79 == "按装备等级随机创建"
        if ____cond79 then
            do
                local _____5019_9009_7B49_7EA7_6C60 = _____6309_6743_91CD_62BD_53D6_7B49_7EA7_6C60(_____52A8_4F5C["候选等级池"])
                if not _____5019_9009_7B49_7EA7_6C60 then
                    return
                end
                local itemId = _____6309_7269_54C1_6C60_540D_968F_673A_88C5_5907ID(_____5019_9009_7B49_7EA7_6C60["池名"])
                debugLogForce(
                    "宝箱掉落配置",
                    "按等级池随机装备",
                    "pool=",
                    _____5019_9009_7B49_7EA7_6C60["池名"],
                    "itemId=",
                    itemId
                )
                if not itemId or items[itemId] == nil then
                    return
                end
                _____7ED3_679C[#_____7ED3_679C + 1] = itemId
                _____4E0A_4E0B_6587["最近装备物品ID"] = itemId
                _____4E0A_4E0B_6587["最近装备等级文本"] = _____5019_9009_7B49_7EA7_6C60["广播等级文本"]
                return
            end
        end
        ____cond79 = ____cond79 or ____switch79 == "对开启者施加效果"
        if ____cond79 then
            do
                if not _____4E0A_4E0B_6587["开启者"] then
                    return
                end
                debugLogForce(
                    "宝箱掉落配置",
                    "命中负面效果段",
                    "lifeKeep=",
                    _____52A8_4F5C["保留当前生命比例"] or "nil",
                    "buffId=",
                    _____52A8_4F5C.BuffID or "nil",
                    "buffTime=",
                    _____52A8_4F5C["Buff持续时间"] or "nil"
                )
                if _____52A8_4F5C["保留当前生命比例"] ~= nil then
                    local _____5F53_524D_751F_547D = GetWidgetLife(_____4E0A_4E0B_6587["开启者"])
                    SetWidgetLife(_____4E0A_4E0B_6587["开启者"], _____5F53_524D_751F_547D * _____52A8_4F5C["保留当前生命比例"])
                end
                if _____52A8_4F5C.BuffID ~= nil and _____52A8_4F5C["Buff持续时间"] ~= nil then
                    SFB_setBuff(_____4E0A_4E0B_6587["开启者"], _____4E0A_4E0B_6587["开启者"], _____52A8_4F5C.BuffID, _____52A8_4F5C["Buff持续时间"])
                end
                return
            end
        end
        ____cond79 = ____cond79 or ____switch79 == "发送广播提示"
        if ____cond79 then
            do
                _____5E7F_64AD_5B9D_7BB1_88C5_5907_6D88_606F(_____52A8_4F5C, _____4E0A_4E0B_6587)
                return
            end
        end
    until true
end
local function _____6267_884C_9AD8_7EA7_6389_843D(config, _____4E0A_4E0B_6587)
    local _____9AD8_7EA7_6389_843D = config["高级掉落"]
    if not _____9AD8_7EA7_6389_843D then
        return {}
    end
    local roll = _____4E0A_4E0B_6587["指定主随机"] ~= nil and _____4E0A_4E0B_6587["指定主随机"] or randomInt(1, 100)
    debugLogForce(
        "宝箱掉落配置",
        "高级掉落主随机",
        "type=",
        config.destructableType,
        "roll=",
        roll,
        "preRolled=",
        _____4E0A_4E0B_6587["指定主随机"] ~= nil
    )
    for ____, _____6389_843D_6BB5 in ipairs(_____9AD8_7EA7_6389_843D["随机段"]) do
        do
            if roll < _____6389_843D_6BB5["最小值"] or roll > _____6389_843D_6BB5["最大值"] then
                goto __continue94
            end
            debugLogForce(
                "宝箱掉落配置",
                "命中高级掉落段",
                "min=",
                _____6389_843D_6BB5["最小值"],
                "max=",
                _____6389_843D_6BB5["最大值"],
                "actionCount=",
                #_____6389_843D_6BB5["动作"]
            )
            local result = {}
            for ____, _____52A8_4F5C in ipairs(_____6389_843D_6BB5["动作"]) do
                _____6267_884C_9AD8_7EA7_6389_843D_52A8_4F5C(_____52A8_4F5C, result, _____4E0A_4E0B_6587)
            end
            return result
        end
        ::__continue94::
    end
    return {}
end
____exports["执行宝箱掉落"] = function(config, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
    local ____debugLogForce_28 = debugLogForce
    local ____config_destructableType_26 = config.destructableType
    local ____config_name_27 = config.name
    local ____opt_24 = config.dropMode
    ____debugLogForce_28(
        "宝箱掉落配置",
        "executeChestDrop",
        "type=",
        ____config_destructableType_26,
        "name=",
        ____config_name_27,
        "mode=",
        ____opt_24 and ____opt_24.type or "none",
        "picks=",
        config.picks or 0
    )
    if config["高级掉落"] then
        return _____6267_884C_9AD8_7EA7_6389_843D(config, {
            ["开启者"] = opener,
            ["宝箱主人"] = ownerUnit,
            ["宝箱配置"] = config,
            x = 0,
            y = 0,
            ["指定主随机"] = _____6307_5B9A_4E3B_968F_673A
        })
    end
    if config.dropMode == nil then
        return {}
    end
    return _____6309_6389_843D_6A21_5F0F_6267_884C(config.dropMode, config.picks or 0)
end
____exports["按可破坏物掉落"] = function(destructableType, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
    local config = getChestConfigByString(destructableType)
    if not config then
        debugLogForce("宝箱掉落配置", "未找到宝箱配置", "type=", destructableType)
        return {}
    end
    debugLogForce(
        "宝箱掉落配置",
        "命中宝箱配置",
        "type=",
        destructableType,
        "name=",
        config.name
    )
    return ____exports["执行宝箱掉落"](config, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
end
____exports["按宝箱配置掉落"] = function(config, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
    debugLogForce(
        "宝箱掉落配置",
        "直接使用宝箱配置",
        "type=",
        config.destructableType,
        "name=",
        config.name
    )
    return ____exports["执行宝箱掉落"](config, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
end
____exports["创建掉落物品"] = function(itemId, x, y)
    if not items[itemId] then
        debugLogForce(
            "宝箱掉落配置",
            "未解析到物品ID",
            itemId,
            "x=",
            x,
            "y=",
            y
        )
    end
    local item = CreateItem(
        stringToFourCC(itemId),
        x,
        y
    )
    debugLogForce(
        "宝箱掉落配置",
        "创建掉落物品",
        "itemId=",
        itemId,
        "x=",
        x,
        "y=",
        y,
        "created=",
        item ~= nil
    )
    if item then
        setLastCreatedItem(item)
    end
    return item
end
local function _____83B7_53D6_6389_843D_504F_79FB(index)
    return DROP_OFFSETS[index % #DROP_OFFSETS + 1] or DROP_OFFSETS[1]
end
____exports["宝箱位置掉落"] = function(destructableType, x, y, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
    local itemIds = ____exports["按可破坏物掉落"](destructableType, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
    debugLogForce(
        "宝箱掉落配置",
        "宝箱掉落结果",
        "type=",
        destructableType,
        "x=",
        x,
        "y=",
        y,
        "itemIds=",
        table.concat(itemIds, ",")
    )
    local createdItems = {}
    do
        local i = 0
        while i < #itemIds do
            local offset = _____83B7_53D6_6389_843D_504F_79FB(i)
            local item = ____exports["创建掉落物品"](itemIds[i + 1], x + offset.dx, y + offset.dy)
            if item then
                createdItems[#createdItems + 1] = item
            end
            i = i + 1
        end
    end
    debugLogForce(
        "宝箱掉落配置",
        "宝箱掉落完成",
        "type=",
        destructableType,
        "count=",
        #createdItems
    )
    return createdItems
end
____exports["宝箱配置掉落"] = function(config, x, y, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
    local itemIds = ____exports["按宝箱配置掉落"](config, opener, ownerUnit, _____6307_5B9A_4E3B_968F_673A)
    debugLogForce(
        "宝箱掉落配置",
        "宝箱掉落结果",
        "type=",
        config.destructableType,
        "x=",
        x,
        "y=",
        y,
        "itemIds=",
        table.concat(itemIds, ",")
    )
    local createdItems = {}
    do
        local i = 0
        while i < #itemIds do
            local offset = _____83B7_53D6_6389_843D_504F_79FB(i)
            local item = ____exports["创建掉落物品"](itemIds[i + 1], x + offset.dx, y + offset.dy)
            if item then
                createdItems[#createdItems + 1] = item
            end
            i = i + 1
        end
    end
    debugLogForce(
        "宝箱掉落配置",
        "宝箱掉落完成",
        "type=",
        config.destructableType,
        "count=",
        #createdItems
    )
    return createdItems
end
____exports.executeChestDrop = ____exports["执行宝箱掉落"]
____exports.dropItemsByDestructable = ____exports["按可破坏物掉落"]
____exports.dropItemsByChestConfig = ____exports["按宝箱配置掉落"]
____exports.createDropItem = ____exports["创建掉落物品"]
____exports.dropItemsFromChest = ____exports["宝箱位置掉落"]
____exports.dropItemsFromChestConfig = ____exports["宝箱配置掉落"]
return ____exports
