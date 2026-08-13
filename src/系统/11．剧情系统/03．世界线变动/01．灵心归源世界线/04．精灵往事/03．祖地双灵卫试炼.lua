--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____91CD_7F6E_8BD5_70BC_72B6_6001_503C, _____6E05_7406_8BD5_70BC_9879, removePeriodicCallback, RemoveUnit, _____8BD5_70BC_5468_671FID
local ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI = require("系统.09．表现系统.15．世界坐标进度UI.index")
local _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["创建世界坐标进度UI"]
local _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["更新世界坐标进度UI"]
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["销毁世界坐标进度UI"]
local ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.01．祖地双灵卫副本配置")
local _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E = ____01_FF0E_7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["祖地双灵卫副本配置"]
local ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = require("系统.11．剧情系统.03．世界线变动.01．灵心归源世界线.04．精灵往事.02．祖地双灵卫副本状态")
local _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001 = ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001["祖地双灵卫副本状态"]
local _____7956_5730_53CC_7075_536B_8BD5_70BC_662F_5426_5168_90E8_5B8C_6210 = ____02_FF0E_7956_5730_53CC_7075_536B_526F_672C_72B6_6001["祖地双灵卫试炼是否全部完成"]
function _____91CD_7F6E_8BD5_70BC_72B6_6001_503C(state)
    state["锁定玩家ID"] = -1
    state["开始时间毫秒"] = 0
    state["累计数值"] = 0
end
function _____6E05_7406_8BD5_70BC_9879(state)
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(state["进度UI"])
    state["进度UI"] = nil
    if state["目标单位"] ~= nil and state["目标单位"] ~= 0 then
        RemoveUnit(state["目标单位"])
    end
    state["目标单位"] = nil
    state["已完成"] = false
    _____91CD_7F6E_8BD5_70BC_72B6_6001_503C(state)
end
____exports["清理祖地双灵卫试炼"] = function()
    if _____8BD5_70BC_5468_671FID ~= 0 then
        removePeriodicCallback(_____8BD5_70BC_5468_671FID)
        _____8BD5_70BC_5468_671FID = 0
    end
    _____6E05_7406_8BD5_70BC_9879(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["持续伤害"])
    _____6E05_7406_8BD5_70BC_9879(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["单次伤害"])
    _____6E05_7406_8BD5_70BC_9879(_____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["治疗"])
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼已创建"] = false
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼全部完成已派发"] = false
end
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_2.registerAppliedFinalDamageListener
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerAppliedFinalHealListener = ____require_result_3.registerAppliedFinalHealListener
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
removePeriodicCallback = ____require_result_4.removePeriodicCallback
local getServerTime = ____require_result_4.getServerTime
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_5["广播单位提示"]
local Player = jass.Player
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local SetUnitState = jass.SetUnitState
local GetUnitState = jass.GetUnitState
local SetUnitPathing = jass.SetUnitPathing
local PauseUnit = jass.PauseUnit
RemoveUnit = jass.RemoveUnit
local SetUnitStateJapi = japi.SetUnitState
local DzSetUnitModel = japi.DzSetUnitModel
local DzSetUnitName = japi.DzSetUnitName
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____8BD5_70BC_5237_65B0_95F4_9694_6BEB_79D2 = 100
local _____73A9_5BB6_6700_5C0FID = 0
local _____73A9_5BB6_6700_5927ID = 5
local _____8BD5_70BC_5168_90E8_5B8C_6210_56DE_8C03_5217_8868 = {}
local _____8BD5_70BC_4E8B_4EF6_5DF2_6CE8_518C = false
_____8BD5_70BC_5468_671FID = 0
local function _____662F_6709_6548_73A9_5BB6ID(playerId)
    return playerId >= _____73A9_5BB6_6700_5C0FID and playerId <= _____73A9_5BB6_6700_5927ID
end
local function _____83B7_53D6_6765_6E90_73A9_5BB6ID(source)
    if source == nil or source == 0 then
        return -1
    end
    local owner = GetOwningPlayer(source)
    if owner == nil then
        return -1
    end
    local playerId = GetPlayerId(owner)
    return _____662F_6709_6548_73A9_5BB6ID(playerId) and playerId or -1
end
local function _____8BBE_7F6E_8BD5_70BC_9776_751F_547D(unit, maximum, current)
    if unit == nil or unit == 0 then
        return
    end
    SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, maximum)
    SetUnitState(unit, UNIT_STATE_LIFE, current)
end
local function _____521B_5EFA_8BD5_70BC_9776(ownerId, x, y, facing, maximum, current)
    local unitTypeId = stringToFourCCSafe(_____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]["靶单位ID"])
    if unitTypeId == 0 then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(ownerId),
        unitTypeId,
        x,
        y,
        facing
    )
    if unit == nil or unit == 0 then
        return nil
    end
    if DzSetUnitModel ~= nil then
        DzSetUnitModel(unit, _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]["靶模型"])
    end
    SetUnitPathing(unit, false)
    PauseUnit(unit, true)
    _____8BBE_7F6E_8BD5_70BC_9776_751F_547D(unit, maximum, current)
    return unit
end
local function _____8BBE_7F6E_8BD5_70BC_9776_540D_79F0(unit, name)
    if unit ~= nil and unit ~= 0 and DzSetUnitName ~= nil then
        DzSetUnitName(unit, name)
    end
end
local function _____521B_5EFA_8BD5_70BC_8FDB_5EA6UI(x, y, maximum, current, title, ____type, suffix)
    return _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI({
        X = x,
        Y = y,
        Z = 300,
        ["最大值"] = maximum,
        ["当前值"] = current,
        ["标题"] = title,
        ["数值后缀"] = suffix,
        ["类型"] = ____type,
        ["平滑过渡秒"] = 0.1,
        ["初始显示"] = true,
        ["雾中可见"] = false
    })
end
local function _____5E7F_64AD_57C3_5FB7_91CC_5B89(text)
    local unit = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["埃德里安单位"]
    if unit ~= nil and unit ~= 0 then
        _____5E7F_64AD_5355_4F4D_63D0_793A(unit, text, 4200)
    end
end
local function _____91CD_5EFA_6301_7EED_4F24_5BB3_9776()
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["持续伤害"]
    if state["目标单位"] ~= nil and state["目标单位"] ~= 0 then
        RemoveUnit(state["目标单位"])
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]
    state["目标单位"] = _____521B_5EFA_8BD5_70BC_9776(
        cfg["伤害靶玩家ID"],
        cfg["持续伤害"].X,
        cfg["持续伤害"].Y,
        cfg["持续伤害"]["朝向"],
        cfg["持续伤害"]["最大生命"],
        cfg["持续伤害"]["最大生命"]
    )
    _____8BBE_7F6E_8BD5_70BC_9776_540D_79F0(state["目标单位"], "持续输出试炼靶")
end
local function _____91CD_5EFA_5355_6B21_4F24_5BB3_9776()
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["单次伤害"]
    if state["目标单位"] ~= nil and state["目标单位"] ~= 0 then
        RemoveUnit(state["目标单位"])
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]
    state["目标单位"] = _____521B_5EFA_8BD5_70BC_9776(
        cfg["伤害靶玩家ID"],
        cfg["单次伤害"].X,
        cfg["单次伤害"].Y,
        cfg["单次伤害"]["朝向"],
        cfg["单次伤害"]["最大生命"],
        cfg["单次伤害"]["最大生命"]
    )
    _____8BBE_7F6E_8BD5_70BC_9776_540D_79F0(state["目标单位"], "爆发伤害试炼靶")
end
local function _____91CD_5EFA_6CBB_7597_9776()
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["治疗"]
    if state["目标单位"] ~= nil and state["目标单位"] ~= 0 then
        RemoveUnit(state["目标单位"])
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]
    state["目标单位"] = _____521B_5EFA_8BD5_70BC_9776(
        cfg["治疗靶玩家ID"],
        cfg["治疗"].X,
        cfg["治疗"].Y,
        cfg["治疗"]["朝向"],
        cfg["治疗"]["最大生命"],
        cfg["治疗"]["初始生命"]
    )
    _____8BBE_7F6E_8BD5_70BC_9776_540D_79F0(state["目标单位"], "治疗试炼靶")
end
local function _____91CD_7F6E_6301_7EED_4F24_5BB3_8BD5_70BC()
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["持续伤害"]
    if state["已完成"] then
        return
    end
    _____91CD_7F6E_8BD5_70BC_72B6_6001_503C(state)
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]["持续伤害"]
    _____91CD_5EFA_6301_7EED_4F24_5BB3_9776()
    if state["进度UI"] ~= nil then
        state["进度UI"]["标题"] = "持续输出 0 DPS"
    end
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state["进度UI"], cfg["持续秒"], true)
end
local function _____91CD_7F6E_5355_6B21_4F24_5BB3_8BD5_70BC()
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["单次伤害"]
    if state["已完成"] then
        return
    end
    _____91CD_7F6E_8BD5_70BC_72B6_6001_503C(state)
    _____91CD_5EFA_5355_6B21_4F24_5BB3_9776()
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state["进度UI"], 0, true)
end
local function _____91CD_7F6E_6CBB_7597_8BD5_70BC()
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["治疗"]
    if state["已完成"] then
        return
    end
    _____91CD_7F6E_8BD5_70BC_72B6_6001_503C(state)
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]["治疗"]
    _____91CD_5EFA_6CBB_7597_9776()
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state["进度UI"], cfg["持续秒"], true)
end
local function _____6D3E_53D1_8BD5_70BC_5168_90E8_5B8C_6210()
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼全部完成已派发"] or not _____7956_5730_53CC_7075_536B_8BD5_70BC_662F_5426_5168_90E8_5B8C_6210() then
        return
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼全部完成已派发"] = true
    do
        local i = 0
        while i < #_____8BD5_70BC_5168_90E8_5B8C_6210_56DE_8C03_5217_8868 do
            _____8BD5_70BC_5168_90E8_5B8C_6210_56DE_8C03_5217_8868[i + 1]()
            i = i + 1
        end
    end
end
local function _____5B8C_6210_8BD5_70BC(____type)
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"][____type]
    if state["已完成"] then
        return
    end
    state["已完成"] = true
    state["锁定玩家ID"] = -1
    state["开始时间毫秒"] = 0
    if state["目标单位"] ~= nil and state["目标单位"] ~= 0 then
        RemoveUnit(state["目标单位"])
    end
    state["目标单位"] = nil
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(state["进度UI"])
    state["进度UI"] = nil
    if ____type == "持续伤害" then
        _____5E7F_64AD_57C3_5FB7_91CC_5B89("二十息间力量未衰，节奏也没有乱。很好，这一项通过了。")
    elseif ____type == "单次伤害" then
        _____5E7F_64AD_57C3_5FB7_91CC_5B89("这一击足以破开祖地的旧甲。不错，这一项通过了。")
    else
        _____5E7F_64AD_57C3_5FB7_91CC_5B89("危急之时仍能稳住同伴的性命。很好，这一项通过了。")
    end
    _____6D3E_53D1_8BD5_70BC_5168_90E8_5B8C_6210()
end
local function _____5904_7406_6301_7EED_4F24_5BB3(attacker, applied)
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["持续伤害"]
    if state["已完成"] or not (applied > 0) then
        return
    end
    local playerId = _____83B7_53D6_6765_6E90_73A9_5BB6ID(attacker)
    if playerId < 0 then
        return
    end
    if state["锁定玩家ID"] >= 0 and state["锁定玩家ID"] ~= playerId then
        _____5E7F_64AD_57C3_5FB7_91CC_5B89("试炼只认可一人的力量。有人插手，持续输出试炼重新开始。")
        _____91CD_7F6E_6301_7EED_4F24_5BB3_8BD5_70BC()
        return
    end
    if state["锁定玩家ID"] < 0 then
        state["锁定玩家ID"] = playerId
        state["开始时间毫秒"] = getServerTime()
    end
    state["累计数值"] = state["累计数值"] + applied
end
local function _____5904_7406_5355_6B21_4F24_5BB3(attacker, applied)
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["单次伤害"]
    if state["已完成"] or not (applied > 0) then
        return
    end
    local playerId = _____83B7_53D6_6765_6E90_73A9_5BB6ID(attacker)
    if playerId < 0 then
        return
    end
    if state["锁定玩家ID"] >= 0 and state["锁定玩家ID"] ~= playerId then
        _____5E7F_64AD_57C3_5FB7_91CC_5B89("试炼只认可一人的力量。有人插手，爆发伤害试炼重新开始。")
        _____91CD_7F6E_5355_6B21_4F24_5BB3_8BD5_70BC()
        return
    end
    if state["锁定玩家ID"] < 0 then
        state["锁定玩家ID"] = playerId
    end
    if applied > state["累计数值"] then
        state["累计数值"] = applied
    end
    local requirement = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]["单次伤害"]["单次伤害要求"]
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state["进度UI"], state["累计数值"] > requirement and requirement or state["累计数值"])
    if applied > requirement then
        _____5B8C_6210_8BD5_70BC("单次伤害")
    end
end
local function ____on_7956_5730_53CC_7075_536B_8BD5_70BC_6700_7EC8_4F24_5BB3(target, attacker, applied, _snapshot)
    if not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼已创建"] then
        return
    end
    if target == _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["持续伤害"]["目标单位"] then
        _____5904_7406_6301_7EED_4F24_5BB3(attacker, applied)
        return
    end
    if target == _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["单次伤害"]["目标单位"] then
        _____5904_7406_5355_6B21_4F24_5BB3(attacker, applied)
    end
end
local function ____on_7956_5730_53CC_7075_536B_8BD5_70BC_6700_7EC8_6CBB_7597(source, target, amount, _isItemHeal)
    if not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼已创建"] or target ~= _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["治疗"]["目标单位"] or not (amount > 0) then
        return
    end
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["治疗"]
    if state["已完成"] then
        return
    end
    local playerId = _____83B7_53D6_6765_6E90_73A9_5BB6ID(source)
    if playerId < 0 then
        return
    end
    if state["锁定玩家ID"] >= 0 and state["锁定玩家ID"] ~= playerId then
        _____5E7F_64AD_57C3_5FB7_91CC_5B89("试炼只认可一人的力量。有人插手，治疗试炼重新开始。")
        _____91CD_7F6E_6CBB_7597_8BD5_70BC()
        return
    end
    if state["锁定玩家ID"] < 0 then
        state["锁定玩家ID"] = playerId
        state["开始时间毫秒"] = getServerTime()
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]["治疗"]
    local currentLife = GetUnitState(state["目标单位"], UNIT_STATE_LIFE)
    if currentLife >= cfg["最大生命"] then
        _____5B8C_6210_8BD5_70BC("治疗")
    end
end
local function _____66F4_65B0_6301_7EED_4F24_5BB3_8BD5_70BC(now)
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["持续伤害"]
    if state["已完成"] or state["开始时间毫秒"] <= 0 then
        return
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]["持续伤害"]
    local elapsed = now - state["开始时间毫秒"]
    local remaining = cfg["持续秒"] - elapsed / 1000
    if remaining < 0 then
        remaining = 0
    end
    if state["进度UI"] ~= nil then
        local elapsedSeconds = elapsed > 0 and elapsed / 1000 or 0.1
        local currentDps = jass:R2I(state["累计数值"] / elapsedSeconds)
        state["进度UI"]["标题"] = ("持续输出 " .. tostring(nil, currentDps)) .. " DPS"
    end
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state["进度UI"], remaining, true)
    if elapsed < cfg["持续秒"] * 1000 then
        return
    end
    local requirement = cfg["每秒伤害要求"] * cfg["持续秒"]
    if state["累计数值"] >= requirement then
        state["累计数值"] = requirement
        _____5B8C_6210_8BD5_70BC("持续伤害")
        return
    end
    _____5E7F_64AD_57C3_5FB7_91CC_5B89("持续输出没有达到要求。调整呼吸，再来一次。")
    _____91CD_7F6E_6301_7EED_4F24_5BB3_8BD5_70BC()
end
local function _____66F4_65B0_6CBB_7597_8BD5_70BC(now)
    local state = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["治疗"]
    if state["已完成"] or state["开始时间毫秒"] <= 0 then
        return
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]["治疗"]
    local currentLife = GetUnitState(state["目标单位"], UNIT_STATE_LIFE)
    if currentLife >= cfg["最大生命"] then
        _____5B8C_6210_8BD5_70BC("治疗")
        return
    end
    local remaining = cfg["持续秒"] - (now - state["开始时间毫秒"]) / 1000
    if remaining < 0 then
        remaining = 0
    end
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state["进度UI"], remaining, true)
    if remaining <= 0 then
        _____5E7F_64AD_57C3_5FB7_91CC_5B89("治疗慢了一步。把握好时机，重新开始。")
        _____91CD_7F6E_6CBB_7597_8BD5_70BC()
    end
end
local function ____on_7956_5730_53CC_7075_536B_8BD5_70BC_5468_671F()
    if not _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼已创建"] then
        return
    end
    local now = getServerTime()
    _____66F4_65B0_6301_7EED_4F24_5BB3_8BD5_70BC(now)
    _____66F4_65B0_6CBB_7597_8BD5_70BC(now)
end
____exports["register祖地双灵卫试炼全部完成Listener"] = function(callback)
    if type(callback) ~= "function" then
        return
    end
    _____8BD5_70BC_5168_90E8_5B8C_6210_56DE_8C03_5217_8868[#_____8BD5_70BC_5168_90E8_5B8C_6210_56DE_8C03_5217_8868 + 1] = callback
end
____exports["创建祖地双灵卫试炼"] = function()
    if _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼已创建"] then
        return true
    end
    local cfg = _____7956_5730_53CC_7075_536B_526F_672C_914D_7F6E["试炼"]
    local _____6301_7EED_4F24_5BB3_72B6_6001 = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["持续伤害"]
    local _____5355_6B21_4F24_5BB3_72B6_6001 = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["单次伤害"]
    local _____6CBB_7597_72B6_6001 = _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼"]["治疗"]
    _____6301_7EED_4F24_5BB3_72B6_6001["目标单位"] = _____521B_5EFA_8BD5_70BC_9776(
        cfg["伤害靶玩家ID"],
        cfg["持续伤害"].X,
        cfg["持续伤害"].Y,
        cfg["持续伤害"]["朝向"],
        cfg["持续伤害"]["最大生命"],
        cfg["持续伤害"]["最大生命"]
    )
    _____5355_6B21_4F24_5BB3_72B6_6001["目标单位"] = _____521B_5EFA_8BD5_70BC_9776(
        cfg["伤害靶玩家ID"],
        cfg["单次伤害"].X,
        cfg["单次伤害"].Y,
        cfg["单次伤害"]["朝向"],
        cfg["单次伤害"]["最大生命"],
        cfg["单次伤害"]["最大生命"]
    )
    _____6CBB_7597_72B6_6001["目标单位"] = _____521B_5EFA_8BD5_70BC_9776(
        cfg["治疗靶玩家ID"],
        cfg["治疗"].X,
        cfg["治疗"].Y,
        cfg["治疗"]["朝向"],
        cfg["治疗"]["最大生命"],
        cfg["治疗"]["初始生命"]
    )
    _____8BBE_7F6E_8BD5_70BC_9776_540D_79F0(_____6301_7EED_4F24_5BB3_72B6_6001["目标单位"], "持续输出试炼靶")
    _____8BBE_7F6E_8BD5_70BC_9776_540D_79F0(_____5355_6B21_4F24_5BB3_72B6_6001["目标单位"], "爆发伤害试炼靶")
    _____8BBE_7F6E_8BD5_70BC_9776_540D_79F0(_____6CBB_7597_72B6_6001["目标单位"], "治疗试炼靶")
    _____6301_7EED_4F24_5BB3_72B6_6001["进度UI"] = _____521B_5EFA_8BD5_70BC_8FDB_5EA6UI(
        cfg["持续伤害"].X,
        cfg["持续伤害"].Y,
        cfg["持续伤害"]["持续秒"],
        cfg["持续伤害"]["持续秒"],
        "持续输出 0 DPS",
        "危险",
        "秒"
    )
    _____5355_6B21_4F24_5BB3_72B6_6001["进度UI"] = _____521B_5EFA_8BD5_70BC_8FDB_5EA6UI(
        cfg["单次伤害"].X,
        cfg["单次伤害"].Y,
        cfg["单次伤害"]["单次伤害要求"],
        0,
        "单次伤害",
        "奥术",
        ""
    )
    _____6CBB_7597_72B6_6001["进度UI"] = _____521B_5EFA_8BD5_70BC_8FDB_5EA6UI(
        cfg["治疗"].X,
        cfg["治疗"].Y,
        cfg["治疗"]["持续秒"],
        cfg["治疗"]["持续秒"],
        "限时治疗",
        "自然",
        "秒"
    )
    local created = _____6301_7EED_4F24_5BB3_72B6_6001["目标单位"] ~= nil and _____5355_6B21_4F24_5BB3_72B6_6001["目标单位"] ~= nil and _____6CBB_7597_72B6_6001["目标单位"] ~= nil and _____6301_7EED_4F24_5BB3_72B6_6001["进度UI"] ~= nil and _____5355_6B21_4F24_5BB3_72B6_6001["进度UI"] ~= nil and _____6CBB_7597_72B6_6001["进度UI"] ~= nil
    if not created then
        ____exports["清理祖地双灵卫试炼"]()
        return false
    end
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼已创建"] = true
    _____7956_5730_53CC_7075_536B_526F_672C_72B6_6001["试炼全部完成已派发"] = false
    if _____8BD5_70BC_5468_671FID == 0 then
        _____8BD5_70BC_5468_671FID = addPeriodicCallback(_____8BD5_70BC_5237_65B0_95F4_9694_6BEB_79D2, ____on_7956_5730_53CC_7075_536B_8BD5_70BC_5468_671F)
    end
    return true
end
____exports["init祖地双灵卫试炼"] = function()
    if _____8BD5_70BC_4E8B_4EF6_5DF2_6CE8_518C then
        return
    end
    _____8BD5_70BC_4E8B_4EF6_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_7956_5730_53CC_7075_536B_8BD5_70BC_6700_7EC8_4F24_5BB3)
    registerAppliedFinalHealListener(____on_7956_5730_53CC_7075_536B_8BD5_70BC_6700_7EC8_6CBB_7597)
end
return ____exports
