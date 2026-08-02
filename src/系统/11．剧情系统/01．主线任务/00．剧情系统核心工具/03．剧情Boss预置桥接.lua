local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_2["按名字反查Boss单位ID"]
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_3["按名字反查总单位ID"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_4["创建单位并登记排泄安全"]
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_5["立即移除单位并取消排泄登记"]
local ____require_result_6 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_6.TriggerRegisterUnitInRangeSimple
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_7["添加单位暂停"]
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_8["移除单位暂停"]
local ____require_result_9 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.06．Boss战护卫")
local _____767B_8BB0Boss_6218_5F85_5E26_5165_62A4_536B = ____require_result_9["登记Boss战待带入护卫"]
local CreateTrigger = jass.CreateTrigger
local CreateUnit = jass.CreateUnit
local GetHandleId = jass.GetHandleId
local GetTriggerUnit = jass.GetTriggerUnit
local GetTriggeringTrigger = jass.GetTriggeringTrigger
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SetUnitFacing = jass.SetUnitFacing
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local StopMusic = jass.StopMusic
local TriggerAddAction = jass.TriggerAddAction
____exports["剧情Boss预置暂停来源"] = "剧情系统:Boss预置"
local _____8303_56F4_9884_7F6E_89E6_53D1_914D_7F6E_8868 = {}
local _____5267_60C5Boss_9884_7F6E_968F_4ECE_8868 = {}
local _____5267_60C5Boss_6218_5E26_5165_968F_4ECE_8868 = {}
local _____5267_60C5Boss_9884_7F6E_968F_4ECE_641C_7D22_534A_5F84 = 120
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
--- 地图 JASS 已经摆放的战前随从优先复用；同一坐标的错误类型或重复单位会被清理。
-- 这样可以把旧地图预置和剧情配置的单位顺序统一起来。
local function _____83B7_53D6_6216_6E05_7406_9644_8FD1_9884_7F6E_968F_4ECE(unitTypeId, x, y)
    local group = CreateGroup()
    if group == nil or group == 0 then
        return nil
    end
    GroupEnumUnitsInRange(
        group,
        x,
        y,
        _____5267_60C5Boss_9884_7F6E_968F_4ECE_641C_7D22_534A_5F84,
        nil
    )
    local result = nil
    while true do
        do
            local candidate = FirstOfGroup(group)
            if candidate == nil or candidate == 0 then
                break
            end
            GroupRemoveUnit(group, candidate)
            local owner = GetOwningPlayer(candidate)
            local dx = GetUnitX(candidate) - x
            local dy = GetUnitY(candidate) - y
            local isStaticNeutralHostile = GetPlayerId(owner) == 15 and dx * dx + dy * dy <= _____5267_60C5Boss_9884_7F6E_968F_4ECE_641C_7D22_534A_5F84 * _____5267_60C5Boss_9884_7F6E_968F_4ECE_641C_7D22_534A_5F84
            if not isStaticNeutralHostile or not _____5355_4F4D_5B58_6D3B(candidate) then
                goto __continue5
            end
            if result == nil and GetUnitTypeId(candidate) == unitTypeId then
                result = candidate
            else
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(candidate)
            end
        end
        ::__continue5::
    end
    DestroyGroup(group)
    return result
end
local function _____89E3_6790Boss_8868_952E(____boss_952E)
    if ____boss_952E == nil or ____boss_952E == "" then
        return {["表名"] = "Boss", ["键名"] = ""}
    end
    local splitIndex = (string.find(____boss_952E, ".", nil, true) or 0) - 1
    if splitIndex < 0 then
        return {["表名"] = "Boss", ["键名"] = ____boss_952E}
    end
    return {
        ["表名"] = __TS__StringSubstring(____boss_952E, 0, splitIndex),
        ["键名"] = __TS__StringSubstring(____boss_952E, splitIndex + 1)
    }
end
local function ____on_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1()
    local trigger = GetTriggeringTrigger()
    if trigger == nil or trigger == 0 then
        return
    end
    local _____914D_7F6E = _____8303_56F4_9884_7F6E_89E6_53D1_914D_7F6E_8868[GetHandleId(trigger)]
    if _____914D_7F6E == nil then
        return
    end
    if _____914D_7F6E["需要剧情进度"] ~= nil and _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= _____914D_7F6E["需要剧情进度"] then
        return
    end
    _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587({
        ["片段ID"] = _____914D_7F6E["剧情片段ID"],
        ["触发配置名"] = _____914D_7F6E["配置名"],
        ["触发单位"] = GetTriggerUnit()
    })
    if _____914D_7F6E["剧情片段ID"] ~= nil and _____914D_7F6E["剧情片段ID"] ~= "" then
        local ____require_result_10 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
        local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_10["播放主线剧情片段"]
        _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____914D_7F6E["剧情片段ID"])
    end
end
____exports["注册剧情Boss范围预置触发器"] = function(bossUnit, _____6CE8_518C_8303_56F4, _____914D_7F6E_540D, _____5267_60C5_7247_6BB5ID, ____Boss_952E, _____9700_8981_5267_60C5_8FDB_5EA6)
    if bossUnit == nil or bossUnit == 0 then
        return nil
    end
    if not (_____6CE8_518C_8303_56F4 > 0) then
        return nil
    end
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, ____on_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1)
    TriggerRegisterUnitInRangeSimple(trigger, _____6CE8_518C_8303_56F4, bossUnit)
    _____8303_56F4_9884_7F6E_89E6_53D1_914D_7F6E_8868[GetHandleId(trigger)] = {["配置名"] = _____914D_7F6E_540D, ["剧情片段ID"] = _____5267_60C5_7247_6BB5ID, ["Boss键"] = ____Boss_952E, ["需要剧情进度"] = _____9700_8981_5267_60C5_8FDB_5EA6}
    return trigger
end
____exports["清理剧情Boss预置随从"] = function(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    local handleId = GetHandleId(bossUnit)
    local _____968F_4ECE_5217_8868 = _____5267_60C5Boss_9884_7F6E_968F_4ECE_8868[handleId] or _____5267_60C5Boss_6218_5E26_5165_968F_4ECE_8868[handleId]
    __TS__Delete(_____5267_60C5Boss_9884_7F6E_968F_4ECE_8868, handleId)
    __TS__Delete(_____5267_60C5Boss_6218_5E26_5165_968F_4ECE_8868, handleId)
    if _____968F_4ECE_5217_8868 == nil then
        return
    end
    do
        local i = 0
        while i < #_____968F_4ECE_5217_8868 do
            local unit = _____968F_4ECE_5217_8868[i + 1]
            if unit ~= nil and unit ~= 0 then
                _____79FB_9664_5355_4F4D_6682_505C(unit, ____exports["剧情Boss预置暂停来源"])
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
            end
            i = i + 1
        end
    end
end
____exports["创建并登记剧情Boss预置随从"] = function(bossUnit, _____53C2_6570_5217_8868)
    if bossUnit == nil or bossUnit == 0 or #_____53C2_6570_5217_8868 <= 0 then
        return {}
    end
    ____exports["清理剧情Boss预置随从"](bossUnit)
    local handleId = GetHandleId(bossUnit)
    local _____968F_4ECE_5217_8868 = {}
    do
        local i = 0
        while i < #_____53C2_6570_5217_8868 do
            do
                local _____53C2_6570 = _____53C2_6570_5217_8868[i + 1]
                local rawId = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____53C2_6570["单位名"])
                local unitTypeId = stringToFourCCSafe(rawId)
                if not (unitTypeId > 0) then
                    goto __continue30
                end
                local ____83B7_53D6_6216_6E05_7406_9644_8FD1_9884_7F6E_968F_4ECE_result_11 = _____83B7_53D6_6216_6E05_7406_9644_8FD1_9884_7F6E_968F_4ECE(unitTypeId, _____53C2_6570.X, _____53C2_6570.Y)
                if ____83B7_53D6_6216_6E05_7406_9644_8FD1_9884_7F6E_968F_4ECE_result_11 == nil then
                    ____83B7_53D6_6216_6E05_7406_9644_8FD1_9884_7F6E_968F_4ECE_result_11 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                        Player(15),
                        unitTypeId,
                        _____53C2_6570.X,
                        _____53C2_6570.Y,
                        _____53C2_6570["朝向"] or 0
                    )
                end
                local unit = ____83B7_53D6_6216_6E05_7406_9644_8FD1_9884_7F6E_968F_4ECE_result_11
                if unit == nil or unit == 0 then
                    goto __continue30
                end
                SetUnitFacing(unit, _____53C2_6570["朝向"] or 0)
                if _____53C2_6570["预创建后暂停"] == true then
                    _____6DFB_52A0_5355_4F4D_6682_505C(unit, ____exports["剧情Boss预置暂停来源"])
                end
                if _____53C2_6570["预创建后无敌"] == true then
                    SetUnitInvulnerable(unit, true)
                end
                _____968F_4ECE_5217_8868[#_____968F_4ECE_5217_8868 + 1] = unit
            end
            ::__continue30::
            i = i + 1
        end
    end
    if #_____968F_4ECE_5217_8868 > 0 then
        _____5267_60C5Boss_9884_7F6E_968F_4ECE_8868[handleId] = _____968F_4ECE_5217_8868
    end
    return _____968F_4ECE_5217_8868
end
--- 将战前静态随从交给 Boss 战护卫系统，战斗结束由护卫系统统一清理。
____exports["释放并登记剧情Boss预置随从"] = function(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return {}
    end
    local bossHandleId = GetHandleId(bossUnit)
    local _____968F_4ECE_5217_8868 = _____5267_60C5Boss_9884_7F6E_968F_4ECE_8868[bossHandleId]
    __TS__Delete(_____5267_60C5Boss_9884_7F6E_968F_4ECE_8868, bossHandleId)
    if _____968F_4ECE_5217_8868 == nil then
        return {}
    end
    local _____5E26_5165_5217_8868 = {}
    do
        local i = 0
        while i < #_____968F_4ECE_5217_8868 do
            do
                local unit = _____968F_4ECE_5217_8868[i + 1]
                if not _____5355_4F4D_5B58_6D3B(unit) then
                    goto __continue40
                end
                _____79FB_9664_5355_4F4D_6682_505C(unit, ____exports["剧情Boss预置暂停来源"])
                SetUnitInvulnerable(unit, false)
                if _____767B_8BB0Boss_6218_5F85_5E26_5165_62A4_536B(bossUnit, unit, "剧情Boss预置随从") then
                    _____5E26_5165_5217_8868[#_____5E26_5165_5217_8868 + 1] = unit
                end
            end
            ::__continue40::
            i = i + 1
        end
    end
    if #_____5E26_5165_5217_8868 > 0 then
        _____5267_60C5Boss_6218_5E26_5165_968F_4ECE_8868[bossHandleId] = _____5E26_5165_5217_8868
    end
    return _____5E26_5165_5217_8868
end
--- 树魔首领随从特性消费带入单位，避免初始化时重复补出同类型单位。
____exports["消费剧情Boss战带入随从"] = function(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return {}
    end
    local bossHandleId = GetHandleId(bossUnit)
    local _____968F_4ECE_5217_8868 = _____5267_60C5Boss_6218_5E26_5165_968F_4ECE_8868[bossHandleId] or ({})
    __TS__Delete(_____5267_60C5Boss_6218_5E26_5165_968F_4ECE_8868, bossHandleId)
    return _____968F_4ECE_5217_8868
end
____exports["创建并冻结剧情Boss预置"] = function(_____53C2_6570)
    local rawId = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____53C2_6570["Boss名"])
    local unitTypeId = stringToFourCCSafe(rawId)
    if not (unitTypeId > 0) then
        return nil
    end
    StopMusic(false)
    local bossUnit = CreateUnit(
        Player(15),
        unitTypeId,
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570["朝向"] or 0
    )
    if bossUnit == nil or bossUnit == 0 then
        return nil
    end
    if _____53C2_6570["预创建后暂停"] == true then
        _____6DFB_52A0_5355_4F4D_6682_505C(bossUnit, ____exports["剧情Boss预置暂停来源"])
    end
    if _____53C2_6570["预创建后无敌"] == true then
        SetUnitInvulnerable(bossUnit, true)
    end
    local _____952E_4FE1_606F = _____89E3_6790Boss_8868_952E(_____53C2_6570["Boss键"])
    if _____952E_4FE1_606F["键名"] ~= "" then
        YDUserDataSetSafe(
            "string",
            _____952E_4FE1_606F["表名"],
            _____952E_4FE1_606F["键名"],
            "unit",
            bossUnit
        )
    end
    if (_____53C2_6570["注册范围"] or 0) > 0 then
        ____exports["注册剧情Boss范围预置触发器"](
            bossUnit,
            _____53C2_6570["注册范围"] or 0,
            _____53C2_6570["范围触发配置名"] or _____53C2_6570["Boss名"] .. "范围预置触发",
            _____53C2_6570["范围触发剧情片段ID"],
            _____53C2_6570["Boss键"],
            _____53C2_6570["需要剧情进度"]
        )
    end
    return bossUnit
end
return ____exports
