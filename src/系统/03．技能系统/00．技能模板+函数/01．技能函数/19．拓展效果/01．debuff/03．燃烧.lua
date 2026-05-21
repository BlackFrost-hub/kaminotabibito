local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____76EE_6807_5B58_6D3B, _____5C1D_8BD5_505C_6B62_72EC_7ACB_71C3_70E7_9A71_52A8, ____on_72EC_7ACB_71C3_70E7Tick, removePeriodicCallback, getBuffRuntime, dealBurnDamage, GetUnitState, UNIT_STATE_LIFE, _____72EC_7ACB_71C3_70E7_8868, _____72EC_7ACB_71C3_70E7_56DE_8C03ID
function _____76EE_6807_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
function _____5C1D_8BD5_505C_6B62_72EC_7ACB_71C3_70E7_9A71_52A8()
    for key in pairs(_____72EC_7ACB_71C3_70E7_8868) do
        if _____72EC_7ACB_71C3_70E7_8868[key] ~= nil then
            return
        end
    end
    if _____72EC_7ACB_71C3_70E7_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____72EC_7ACB_71C3_70E7_56DE_8C03ID)
        _____72EC_7ACB_71C3_70E7_56DE_8C03ID = 0
    end
end
function ____on_72EC_7ACB_71C3_70E7Tick()
    local active = 0
    for buffID in pairs(_____72EC_7ACB_71C3_70E7_8868) do
        do
            local record = _____72EC_7ACB_71C3_70E7_8868[buffID]
            if record == nil then
                goto __continue20
            end
            active = active + 1
            local runtime = getBuffRuntime(record.target, record.buffID)
            if runtime == nil or runtime.remaining <= 0 then
                __TS__Delete(_____72EC_7ACB_71C3_70E7_8868, buffID)
                goto __continue20
            end
            if not _____76EE_6807_5B58_6D3B(record.target) then
                goto __continue20
            end
            dealBurnDamage(record.source, record.target, record.damagePerSecond)
        end
        ::__continue20::
    end
    if active == 0 then
        _____5C1D_8BD5_505C_6B62_72EC_7ACB_71C3_70E7_9A71_52A8()
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
getBuffRuntime = ____require_result_1.getBuffRuntime
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local syncDotBuff = ____require_result_2.syncDotBuff
local ____require_result_3 = require("系统.04．伤害系统.02．dot伤害")
local getUnitBurn = ____require_result_3.getUnitBurn
dealBurnDamage = ____require_result_3.dealBurnDamage
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
GetUnitState = jass.GetUnitState
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____71C3_70E7DOT_7C7B_578B = "burn"
local _____71C3_70E7BUFFID = "D002"
local _____71C3_70E7_9ED8_8BA4_56FE_6807 = "BuffIcon\\DotRanShao.blp"
local _____71C3_70E7_9ED8_8BA4_7279_6548 = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl"
_____72EC_7ACB_71C3_70E7_8868 = {}
_____72EC_7ACB_71C3_70E7_56DE_8C03ID = 0
local _____72EC_7ACB_71C3_70E7_5E8F_53F7 = 0
local function _____53D6_5B57_7B26_4E32(value, fallback)
    return value ~= nil and value ~= "" and value or fallback
end
local function _____53D6_6570_503C(value, fallback)
    return type(value) == "number" and __TS__NumberIsFinite(__TS__Number(value)) and value > 0 and value or fallback
end
local function _____53D6_8F83_5927_503C(a, b)
    return a >= b and a or b
end
local function _____64AD_653E_9644_7740_7279_6548(target, modelPath, attachPoint, duration)
    if target == nil or target == 0 then
        return
    end
    if modelPath == "" then
        return
    end
    local effect = AddSpecialEffectTarget(modelPath, target, attachPoint ~= "" and attachPoint or "origin")
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(duration > 0 and duration or 0.75, effect)
    end
end
local function _____751F_6210_72EC_7ACB_71C3_70E7BuffID(target)
    _____72EC_7ACB_71C3_70E7_5E8F_53F7 = _____72EC_7ACB_71C3_70E7_5E8F_53F7 + 1
    return (("burn-instance-" .. tostring(GetHandleId(target))) .. "-") .. tostring(_____72EC_7ACB_71C3_70E7_5E8F_53F7)
end
local function _____786E_4FDD_72EC_7ACB_71C3_70E7_9A71_52A8()
    if _____72EC_7ACB_71C3_70E7_56DE_8C03ID ~= 0 then
        return
    end
    _____72EC_7ACB_71C3_70E7_56DE_8C03ID = addPeriodicCallback(1000, ____on_72EC_7ACB_71C3_70E7Tick)
end
local function ____on_72EC_7ACB_71C3_70E7_79FB_9664(_unit, buffID)
    __TS__Delete(_____72EC_7ACB_71C3_70E7_8868, buffID)
    _____5C1D_8BD5_505C_6B62_72EC_7ACB_71C3_70E7_9A71_52A8()
end
local function _____5E94_7528_5171_4EAB_71C3_70E7(source, target, _____53C2_6570)
    local current = getUnitBurn(target)
    local duration = _____53D6_6570_503C(_____53C2_6570["持续时间"], 0)
    local damage = _____53D6_6570_503C(_____53C2_6570["每秒伤害"], 0)
    if not (duration > 0) or not (damage > 0) then
        return false
    end
    local remaining = duration
    local effect = damage
    if current ~= nil then
        if (_____53C2_6570["持续模式"] or "刷新") == "叠加" then
            remaining = current.remaining + duration
        end
        effect = _____53D6_8F83_5927_503C(current.effect, effect)
    end
    if _____53C2_6570["最大持续时间"] ~= nil and _____53C2_6570["最大持续时间"] > 0 and remaining > _____53C2_6570["最大持续时间"] then
        remaining = _____53C2_6570["最大持续时间"]
    end
    syncDotBuff(
        _____71C3_70E7DOT_7C7B_578B,
        target,
        {
            effect = effect,
            remaining = remaining,
            sourceName = _____53D6_5B57_7B26_4E32(
                _____53C2_6570["来源名称"],
                GetUnitName(source)
            ),
            _dotParsedDuration = remaining
        }
    )
    _____64AD_653E_9644_7740_7279_6548(
        target,
        _____53D6_5B57_7B26_4E32(_____53C2_6570["特效路径"], _____71C3_70E7_9ED8_8BA4_7279_6548),
        _____53D6_5B57_7B26_4E32(_____53C2_6570["特效挂点"], "origin"),
        _____53D6_6570_503C(_____53C2_6570["特效持续时间"], 0.75)
    )
    return true
end
local function _____5E94_7528_72EC_7ACB_71C3_70E7(source, target, _____53C2_6570)
    local duration = _____53D6_6570_503C(_____53C2_6570["持续时间"], 0)
    local damage = _____53D6_6570_503C(_____53C2_6570["每秒伤害"], 0)
    if not (duration > 0) or not (damage > 0) then
        return false
    end
    local buffID = _____53D6_5B57_7B26_4E32(
        _____53C2_6570.BuffID,
        _____751F_6210_72EC_7ACB_71C3_70E7BuffID(target)
    )
    _____72EC_7ACB_71C3_70E7_8868[buffID] = {
        source = source,
        target = target,
        buffID = buffID,
        damagePerSecond = damage,
        sourceName = _____53D6_5B57_7B26_4E32(
            _____53C2_6570["来源名称"],
            GetUnitName(source)
        ),
        iconPath = _____53D6_5B57_7B26_4E32(_____53C2_6570["图标路径"], _____71C3_70E7_9ED8_8BA4_56FE_6807),
        effectPath = _____53D6_5B57_7B26_4E32(_____53C2_6570["特效路径"], _____71C3_70E7_9ED8_8BA4_7279_6548),
        effectAttachPoint = _____53D6_5B57_7B26_4E32(_____53C2_6570["特效挂点"], "origin"),
        effectDuration = _____53D6_6570_503C(_____53C2_6570["特效持续时间"], 0.75)
    }
    registerManualBuff(
        target,
        buffID,
        duration,
        damage,
        {sourceName = _____72EC_7ACB_71C3_70E7_8868[buffID].sourceName, iconOverride = _____72EC_7ACB_71C3_70E7_8868[buffID].iconPath, effectModelOverride = _____72EC_7ACB_71C3_70E7_8868[buffID].effectPath, onRemove = ____on_72EC_7ACB_71C3_70E7_79FB_9664}
    )
    _____64AD_653E_9644_7740_7279_6548(target, _____72EC_7ACB_71C3_70E7_8868[buffID].effectPath, _____72EC_7ACB_71C3_70E7_8868[buffID].effectAttachPoint, _____72EC_7ACB_71C3_70E7_8868[buffID].effectDuration)
    _____786E_4FDD_72EC_7ACB_71C3_70E7_9A71_52A8()
    return true
end
____exports["施加燃烧效果"] = function(source, target, _____53C2_6570)
    if source == nil or source == 0 then
        return false
    end
    if target == nil or target == 0 then
        return false
    end
    if _____53C2_6570 == nil then
        return false
    end
    local mode = _____53C2_6570["持续模式"] or "刷新"
    if mode == "独立" then
        return _____5E94_7528_72EC_7ACB_71C3_70E7(source, target, _____53C2_6570)
    end
    return _____5E94_7528_5171_4EAB_71C3_70E7(source, target, _____53C2_6570)
end
return ____exports
