local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWETimerDestroyEffect = ____require_result_1.YDWETimerDestroyEffect
local ____require_result_2 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataSet = ____require_result_2.YDUserDataSet
local YDUserDataClear = ____require_result_2.YDUserDataClear
local ____require_result_3 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_3.resolveItemIdByName
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表")
local _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E = ____require_result_4["回沙之书累计配置"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_5.stringToFourCC
local GetHandleId = jass.GetHandleId
local GetItemTypeId = jass.GetItemTypeId
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UnitItemInSlot = jass.UnitItemInSlot
local CreateTimer = jass.CreateTimer
local GetExpiredTimer = jass.GetExpiredTimer
local DestroyTimer = jass.DestroyTimer
local TimerStart = jass.TimerStart
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local _____56DE_6C99_7D2F_8BA1_503C_8868 = {}
local _____56DE_6C99CD_8868 = {}
local _____56DE_6C99CD_8BA1_65F6_5668_8868 = {}
local _____56DE_6C99_514D_75AB_5F00_542F_8BA1_65F6_5668_8868 = {}
local _____56DE_6C99_514D_75AB_7ED3_675F_8BA1_65F6_5668_8868 = {}
local _____56DE_6C99_4E4B_4E66ID = stringToFourCC(
    nil,
    resolveItemIdByName(_____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["物品名"]) or ""
)
local function _____5355_4F4D_62E5_6709_88C5_5907(unit, itemTypeId)
    if unit == nil or unit == 0 or itemTypeId <= 0 then
        return false
    end
    do
        local slot = 0
        while slot < 6 do
            local item = UnitItemInSlot(unit, slot)
            if item ~= nil and item ~= 0 and GetItemTypeId(item) == itemTypeId then
                return true
            end
            slot = slot + 1
        end
    end
    return false
end
local function _____56DE_6C99CD_7ED3_675F()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)
    local hid = _____56DE_6C99CD_8BA1_65F6_5668_8868[timerId]
    __TS__Delete(_____56DE_6C99CD_8BA1_65F6_5668_8868, timerId)
    DestroyTimer(timer)
    if hid ~= nil then
        __TS__Delete(_____56DE_6C99CD_8868, hid)
    end
end
local function _____56DE_6C99_514D_75AB_7ED3_675F()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)
    local hid = _____56DE_6C99_514D_75AB_7ED3_675F_8BA1_65F6_5668_8868[timerId]
    __TS__Delete(_____56DE_6C99_514D_75AB_7ED3_675F_8BA1_65F6_5668_8868, timerId)
    DestroyTimer(timer)
    if hid == nil then
        return
    end
    local unit = hid
    YDUserDataSet(
        nil,
        "unit",
        unit,
        "免疫伤害",
        "boolean",
        false
    )
    YDUserDataClear(
        nil,
        "unit",
        unit,
        "伤害免疫",
        "boolean"
    )
end
local function _____56DE_6C99_514D_75AB_5F00_542F()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)
    local hid = _____56DE_6C99_514D_75AB_5F00_542F_8BA1_65F6_5668_8868[timerId]
    __TS__Delete(_____56DE_6C99_514D_75AB_5F00_542F_8BA1_65F6_5668_8868, timerId)
    DestroyTimer(timer)
    if hid == nil then
        return
    end
    local unit = hid
    YDUserDataSet(
        nil,
        "unit",
        unit,
        "免疫伤害",
        "boolean",
        true
    )
    local endTimer = CreateTimer()
    local endTimerId = GetHandleId(endTimer)
    _____56DE_6C99_514D_75AB_7ED3_675F_8BA1_65F6_5668_8868[endTimerId] = unit
    TimerStart(endTimer, 1.25, false, _____56DE_6C99_514D_75AB_7ED3_675F)
end
____exports["处理回沙之书累计"] = function(target, _attacker, applied)
    debugLogForce(
        "回沙之书",
        "进入处理",
        "target:",
        target,
        "applied:",
        applied
    )
    if target == nil or target == 0 or not (applied > 0) then
        debugLogForce("回沙之书", "提前返回: target或applied无效", target, applied)
        return
    end
    if not _____5355_4F4D_62E5_6709_88C5_5907(target, _____56DE_6C99_4E4B_4E66ID) then
        debugLogForce("回沙之书", "目标无回沙之书装备", "回沙之书ID:", _____56DE_6C99_4E4B_4E66ID)
        return
    end
    local hid = GetHandleId(target)
    local gain = applied * _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["法力恢复倍率"]
    if not (gain > 0) then
        return
    end
    _____56DE_6C99_7D2F_8BA1_503C_8868[hid] = (_____56DE_6C99_7D2F_8BA1_503C_8868[hid] or 0) + gain
    SetUnitState(
        target,
        UNIT_STATE_MANA,
        GetUnitState(target, UNIT_STATE_MANA) + gain
    )
    if (_____56DE_6C99_7D2F_8BA1_503C_8868[hid] or 0) >= _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["累计阈值"] then
        _____56DE_6C99_7D2F_8BA1_503C_8868[hid] = 0
        local eff = AddSpecialEffectTarget(_____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["特效路径"], target, "overhead")
        if eff ~= nil then
            YDWETimerDestroyEffect(nil, _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["特效持续时间"], eff)
        end
        if _____56DE_6C99CD_8868[hid] ~= true then
            _____56DE_6C99CD_8868[hid] = true
            local timer = CreateTimer()
            local timerId = GetHandleId(timer)
            _____56DE_6C99CD_8BA1_65F6_5668_8868[timerId] = hid
            TimerStart(timer, _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["冷却时间"], false, _____56DE_6C99CD_7ED3_675F)
        end
        local immuneTimer = CreateTimer()
        local immuneTimerId = GetHandleId(immuneTimer)
        _____56DE_6C99_514D_75AB_5F00_542F_8BA1_65F6_5668_8868[immuneTimerId] = target
        TimerStart(immuneTimer, 0.5, false, _____56DE_6C99_514D_75AB_5F00_542F)
    end
end
return ____exports
