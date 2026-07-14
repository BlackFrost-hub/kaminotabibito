local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____on_7761_7720_4FDD_5E95_68C0_67E5, _____786E_4FDD_4FDD_5E95_68C0_67E5_9A71_52A8, getServerTime, addPeriodicCallback, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____7761_7720_72B6_6001_8868, _____7761_7720_76EE_6807ID_5217_8868, _____7761_7720_7ED3_675F_539F_56E0_8868, _____4FDD_5E95_68C0_67E5_9A71_52A8_5DF2_6CE8_518C
function ____on_7761_7720_4FDD_5E95_68C0_67E5()
    if #_____7761_7720_76EE_6807ID_5217_8868 == 0 then
        return
    end
    local now = getServerTime()
    local index = 0
    while index < #_____7761_7720_76EE_6807ID_5217_8868 do
        do
            local id = _____7761_7720_76EE_6807ID_5217_8868[index + 1]
            local _____72B6_6001 = _____7761_7720_72B6_6001_8868[id]
            if _____72B6_6001 == nil then
                __TS__ArraySplice(_____7761_7720_76EE_6807ID_5217_8868, index, 1)
                goto __continue42
            end
            if _____72B6_6001["等待保底后打破"] and now >= _____72B6_6001["保底到期毫秒"] and _____72B6_6001["已累计伤害"] >= _____72B6_6001["伤害阈值"] then
                _____7761_7720_7ED3_675F_539F_56E0_8868[id] = "伤害打破"
                _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["目标单位"], ____exports["睡眠BuffID"])
                goto __continue42
            end
            index = index + 1
        end
        ::__continue42::
    end
end
function _____786E_4FDD_4FDD_5E95_68C0_67E5_9A71_52A8()
    if _____4FDD_5E95_68C0_67E5_9A71_52A8_5DF2_6CE8_518C then
        return
    end
    _____4FDD_5E95_68C0_67E5_9A71_52A8_5DF2_6CE8_518C = true
    addPeriodicCallback(50, ____on_7761_7720_4FDD_5E95_68C0_67E5)
end
--- 睡眠系统
-- 
-- 睡眠的底层控制走统一暂停占用；Buff 条仍使用 C016 的睡眠图标与睡眠头顶特效。
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_0.getServerTime
addPeriodicCallback = ____require_result_0.addPeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local getBuffRuntime = ____require_result_2.getBuffRuntime
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_3["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_3["移除单位暂停"]
local ____require_result_4 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_UnitPlay = ____require_result_4.Sound3DII_UnitPlay
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local IsUnitType = jass.IsUnitType
____exports["睡眠BuffID"] = "C016"
____exports["睡眠图标路径"] = "ReplaceableTextures\\CommandButtons\\BTNSleep.blp"
____exports["睡眠特效路径"] = "Abilities\\Spells\\Undead\\Sleep\\SleepTarget.mdl"
____exports["睡眠特效挂点"] = "overhead"
____exports["睡眠默认音效路径"] = "Abilities\\Spells\\Undead\\Sleep\\SleepBirth1.wav"
____exports["睡眠默认音效裁断距离"] = 1600
_____7761_7720_72B6_6001_8868 = {}
_____7761_7720_76EE_6807ID_5217_8868 = {}
_____7761_7720_7ED3_675F_539F_56E0_8868 = {}
local _____88AB_7761_7720_76D1_542C_5217_8868 = {}
local _____9192_6765_76D1_542C_5217_8868 = {}
local _____7761_7720_6253_7834_76D1_542C_5217_8868 = {}
local _____5DF2_521D_59CB_5316 = false
_____4FDD_5E95_68C0_67E5_9A71_52A8_5DF2_6CE8_518C = false
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____5355_4F4D_6709_6548_4E14_5B58_6D3B(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return IsUnitType(unit, jass.UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_975E_8D1F_6570(value, fallback)
    if value == nil or type(value) ~= "number" or not __TS__NumberIsFinite(__TS__Number(value)) then
        return fallback
    end
    return value > 0 and value or 0
end
local function _____52A0_5165_7761_7720_76EE_6807ID(id)
    do
        local i = 0
        while i < #_____7761_7720_76EE_6807ID_5217_8868 do
            if _____7761_7720_76EE_6807ID_5217_8868[i + 1] == id then
                return
            end
            i = i + 1
        end
    end
    _____7761_7720_76EE_6807ID_5217_8868[#_____7761_7720_76EE_6807ID_5217_8868 + 1] = id
end
local function _____79FB_9664_7761_7720_76EE_6807ID(id)
    do
        local i = 0
        while i < #_____7761_7720_76EE_6807ID_5217_8868 do
            if _____7761_7720_76EE_6807ID_5217_8868[i + 1] == id then
                __TS__ArraySplice(_____7761_7720_76EE_6807ID_5217_8868, i, 1)
                return
            end
            i = i + 1
        end
    end
end
local function _____6CE8_518C_7761_7720_76D1_542C(list, cb)
    if cb == nil then
        return
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1] == cb then
                return
            end
            i = i + 1
        end
    end
    list[#list + 1] = cb
end
local function _____6784_5EFA_7761_7720_4E8B_4EF6(_____72B6_6001, _____539F_56E0)
    return {
        ["目标单位"] = _____72B6_6001["目标单位"],
        ["目标单位ID"] = _____72B6_6001["目标单位ID"],
        ["来源单位"] = _____72B6_6001["来源单位"],
        ["持续时间"] = _____72B6_6001["持续时间"],
        ["保底时间"] = _____72B6_6001["保底时间"],
        ["伤害阈值"] = _____72B6_6001["伤害阈值"],
        ["已累计伤害"] = _____72B6_6001["已累计伤害"],
        ["打破者"] = _____72B6_6001["打破者"],
        ["打破伤害"] = _____72B6_6001["打破伤害"],
        ["原因"] = _____539F_56E0
    }
end
local function _____901A_77E5_7761_7720_76D1_542C(list, event)
    do
        local i = 0
        while i < #list do
            list[i + 1](event)
            i = i + 1
        end
    end
end
local function _____53D6_6682_505C_6765_6E90(_____76EE_6807_5355_4F4DID)
    return "SleepBuff:" .. tostring(_____76EE_6807_5355_4F4DID)
end
local function _____64AD_653E_7761_7720_9ED8_8BA4_97F3_6548(unit)
    Sound3DII_UnitPlay(____exports["睡眠默认音效路径"], unit, ____exports["睡眠默认音效裁断距离"])
end
local function _____6E05_9664_7761_7720_72B6_6001(_____72B6_6001, _____539F_56E0)
    __TS__Delete(_____7761_7720_72B6_6001_8868, _____72B6_6001["目标单位ID"])
    __TS__Delete(_____7761_7720_7ED3_675F_539F_56E0_8868, _____72B6_6001["目标单位ID"])
    _____79FB_9664_7761_7720_76EE_6807ID(_____72B6_6001["目标单位ID"])
    _____79FB_9664_5355_4F4D_6682_505C(_____72B6_6001["目标单位"], _____72B6_6001["暂停来源"])
    local event = _____6784_5EFA_7761_7720_4E8B_4EF6(_____72B6_6001, _____539F_56E0)
    if _____539F_56E0 == "伤害打破" then
        _____901A_77E5_7761_7720_76D1_542C(_____7761_7720_6253_7834_76D1_542C_5217_8868, event)
    end
    _____901A_77E5_7761_7720_76D1_542C(_____9192_6765_76D1_542C_5217_8868, event)
end
local function ____on_7761_7720Buff_79FB_9664(unit, _buffID, row)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return
    end
    local _____72B6_6001 = _____7761_7720_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    local pending = _____7761_7720_7ED3_675F_539F_56E0_8868[id]
    local _____539F_56E0 = pending or "驱散"
    if pending == nil and row ~= nil and type(row.remaining) == "number" and row.remaining <= 0 then
        _____539F_56E0 = "到期"
    end
    _____6E05_9664_7761_7720_72B6_6001(_____72B6_6001, _____539F_56E0)
end
local function _____5C1D_8BD5_4F24_5BB3_6253_7834_7761_7720(_____72B6_6001, attacker, damage)
    if _____72B6_6001["伤害阈值"] <= 0 or _____72B6_6001["已累计伤害"] < _____72B6_6001["伤害阈值"] then
        return
    end
    local now = getServerTime()
    _____72B6_6001["打破者"] = attacker
    _____72B6_6001["打破伤害"] = damage
    if now < _____72B6_6001["保底到期毫秒"] then
        _____72B6_6001["等待保底后打破"] = true
        _____786E_4FDD_4FDD_5E95_68C0_67E5_9A71_52A8()
        return
    end
    _____7761_7720_7ED3_675F_539F_56E0_8868[_____72B6_6001["目标单位ID"]] = "伤害打破"
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["目标单位"], ____exports["睡眠BuffID"])
end
local function ____on_7761_7720_6700_7EC8_4F24_5BB3(target, attacker, applied, _snapshot)
    if applied <= 0 then
        return
    end
    local id = _____53D6_5355_4F4DID(target)
    if id == 0 then
        return
    end
    local _____72B6_6001 = _____7761_7720_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["已累计伤害"] = _____72B6_6001["已累计伤害"] + applied
    _____5C1D_8BD5_4F24_5BB3_6253_7834_7761_7720(_____72B6_6001, attacker, applied)
end
____exports["初始化睡眠系统"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerAppliedFinalDamageListener(____on_7761_7720_6700_7EC8_4F24_5BB3)
end
____exports["注册任意单位被睡眠监听"] = function(cb)
    _____6CE8_518C_7761_7720_76D1_542C(_____88AB_7761_7720_76D1_542C_5217_8868, cb)
end
____exports["注册任意单位醒来监听"] = function(cb)
    _____6CE8_518C_7761_7720_76D1_542C(_____9192_6765_76D1_542C_5217_8868, cb)
end
____exports["注册任意单位睡眠被打破监听"] = function(cb)
    _____6CE8_518C_7761_7720_76D1_542C(_____7761_7720_6253_7834_76D1_542C_5217_8868, cb)
end
____exports["单位正在睡眠"] = function(unit)
    local id = _____53D6_5355_4F4DID(unit)
    return id ~= 0 and _____7761_7720_72B6_6001_8868[id] ~= nil
end
____exports["清除睡眠"] = function(unit, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动"
    end
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return false
    end
    local _____72B6_6001 = _____7761_7720_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return false
    end
    _____7761_7720_7ED3_675F_539F_56E0_8868[id] = _____539F_56E0
    if _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, ____exports["睡眠BuffID"]) then
        return true
    end
    _____6E05_9664_7761_7720_72B6_6001(_____72B6_6001, _____539F_56E0)
    return true
end
____exports["施加睡眠"] = function(_____53C2_6570)
    ____exports["初始化睡眠系统"]()
    if _____53C2_6570 == nil then
        return false
    end
    local _____76EE_6807_5355_4F4D = _____53C2_6570["目标单位"]
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return false
    end
    local _____6301_7EED_65F6_95F4 = _____53D6_975E_8D1F_6570(_____53C2_6570["持续时间"], 0)
    if _____6301_7EED_65F6_95F4 <= 0 then
        return false
    end
    local _____76EE_6807_5355_4F4DID = _____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)
    if _____76EE_6807_5355_4F4DID == 0 then
        return false
    end
    if _____7761_7720_72B6_6001_8868[_____76EE_6807_5355_4F4DID] ~= nil then
        ____exports["清除睡眠"](_____76EE_6807_5355_4F4D, "覆盖")
    end
    local now = getServerTime()
    local _____4FDD_5E95_65F6_95F4 = _____53D6_975E_8D1F_6570(_____53C2_6570["保底时间"], 0)
    if _____4FDD_5E95_65F6_95F4 > _____6301_7EED_65F6_95F4 then
        _____4FDD_5E95_65F6_95F4 = _____6301_7EED_65F6_95F4
    end
    local _____4F24_5BB3_9608_503C = _____53D6_975E_8D1F_6570(_____53C2_6570["伤害阈值"], 1)
    local _____6682_505C_6765_6E90 = _____53D6_6682_505C_6765_6E90(_____76EE_6807_5355_4F4DID)
    local _____72B6_6001 = {
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["目标单位ID"] = _____76EE_6807_5355_4F4DID,
        ["来源单位"] = _____53C2_6570["来源单位"],
        ["开始时间毫秒"] = now,
        ["到期时间毫秒"] = now + _____6301_7EED_65F6_95F4 * 1000,
        ["保底到期毫秒"] = now + _____4FDD_5E95_65F6_95F4 * 1000,
        ["持续时间"] = _____6301_7EED_65F6_95F4,
        ["保底时间"] = _____4FDD_5E95_65F6_95F4,
        ["伤害阈值"] = _____4F24_5BB3_9608_503C,
        ["已累计伤害"] = 0,
        ["暂停来源"] = _____6682_505C_6765_6E90,
        ["等待保底后打破"] = false
    }
    _____7761_7720_72B6_6001_8868[_____76EE_6807_5355_4F4DID] = _____72B6_6001
    _____52A0_5165_7761_7720_76EE_6807ID(_____76EE_6807_5355_4F4DID)
    local _____6765_6E90_540D_79F0 = _____53C2_6570["来源名称"] ~= nil and _____53C2_6570["来源名称"] ~= "" and _____53C2_6570["来源名称"] or (_____53C2_6570["来源单位"] ~= nil and _____53C2_6570["来源单位"] ~= 0 and GetUnitName(_____53C2_6570["来源单位"]) or "睡眠")
    registerManualBuff(
        _____76EE_6807_5355_4F4D,
        ____exports["睡眠BuffID"],
        _____6301_7EED_65F6_95F4,
        _____4F24_5BB3_9608_503C,
        {
            sourceName = _____6765_6E90_540D_79F0,
            iconOverride = ____exports["睡眠图标路径"],
            effectModelOverride = ____exports["睡眠特效路径"],
            effectValue2 = _____4FDD_5E95_65F6_95F4,
            onRemove = ____on_7761_7720Buff_79FB_9664,
            tickWhilePaused = true
        }
    )
    if getBuffRuntime(_____76EE_6807_5355_4F4D, ____exports["睡眠BuffID"]) == nil then
        __TS__Delete(_____7761_7720_72B6_6001_8868, _____76EE_6807_5355_4F4DID)
        _____79FB_9664_7761_7720_76EE_6807ID(_____76EE_6807_5355_4F4DID)
        return false
    end
    if not _____6DFB_52A0_5355_4F4D_6682_505C(_____76EE_6807_5355_4F4D, _____6682_505C_6765_6E90) then
        _____7761_7720_7ED3_675F_539F_56E0_8868[_____76EE_6807_5355_4F4DID] = "手动"
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____76EE_6807_5355_4F4D, ____exports["睡眠BuffID"])
        return false
    end
    _____64AD_653E_7761_7720_9ED8_8BA4_97F3_6548(_____76EE_6807_5355_4F4D)
    _____901A_77E5_7761_7720_76D1_542C(
        _____88AB_7761_7720_76D1_542C_5217_8868,
        _____6784_5EFA_7761_7720_4E8B_4EF6(_____72B6_6001)
    )
    if _____4FDD_5E95_65F6_95F4 > 0 then
        _____786E_4FDD_4FDD_5E95_68C0_67E5_9A71_52A8()
    end
    return true
end
return ____exports
