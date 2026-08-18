local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local GetUnitState, UNIT_STATE_LIFE
____exports["单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____5355_4F4D_662F_5426_6682_505C = ____require_result_2["单位是否暂停"]
local ____require_result_3 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_3.PlaySoundOnUnitBJ
local PlaySoundAtPointBJ = ____require_result_3.PlaySoundAtPointBJ
local bj_DEGTORAD = jass.bj_DEGTORAD
local Cos = jass.Cos
local Sin = jass.Sin
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight
local GetOwningPlayer = jass.GetOwningPlayer
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitPathing = jass.SetUnitPathing
local RemoveUnit = jass.RemoveUnit
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local _____98DE_5200_78B0_649E_679A_4E3E_7EC4 = nil
local function _____679A_4E3E_98DE_5200_78B0_649E_654C_4EBA(source, x, y, radius)
    local result = {}
    if _____98DE_5200_78B0_649E_679A_4E3E_7EC4 == nil or _____98DE_5200_78B0_649E_679A_4E3E_7EC4 == 0 then
        _____98DE_5200_78B0_649E_679A_4E3E_7EC4 = jass.CreateGroup()
    end
    jass.GroupClear(_____98DE_5200_78B0_649E_679A_4E3E_7EC4)
    jass.GroupEnumUnitsInRange(
        _____98DE_5200_78B0_649E_679A_4E3E_7EC4,
        x,
        y,
        radius,
        nil
    )
    while true do
        do
            local unit = jass.FirstOfGroup(_____98DE_5200_78B0_649E_679A_4E3E_7EC4)
            if unit == nil or unit == 0 then
                break
            end
            jass.GroupRemoveUnit(_____98DE_5200_78B0_649E_679A_4E3E_7EC4, unit)
            if not ____exports["单位存活"](unit) then
                goto __continue4
            end
            if jass.IsUnitType(unit, UNIT_TYPE_STRUCTURE) then
                goto __continue4
            end
            if jass.IsUnitType(unit, UNIT_TYPE_MECHANICAL) then
                goto __continue4
            end
            if jass.IsUnitType(unit, UNIT_TYPE_ANCIENT) then
                goto __continue4
            end
            if not jass.IsUnitEnemy(
                unit,
                GetOwningPlayer(source)
            ) then
                goto __continue4
            end
            result[#result + 1] = unit
        end
        ::__continue4::
    end
    return result
end
local _____54B2_591C_5468_671F_4EFB_52A1_8868 = {}
local _____54B2_591C_5468_671F_4EFB_52A1_81EA_589EID = 0
local _____54B2_591C_5468_671F_4EFB_52A1_6570_91CF = 0
local _____54B2_591C_5468_671F_9A71_52A8ID = 0
local _____54B2_591C_5468_671F_9A71_52A8_95F4_9694_6BEB_79D2 = 10
local function _____63A8_8FDB_54B2_591C_5468_671F_4EFB_52A1()
    local ids = {}
    for key in pairs(_____54B2_591C_5468_671F_4EFB_52A1_8868) do
        local task = _____54B2_591C_5468_671F_4EFB_52A1_8868[key]
        if task ~= nil then
            ids[#ids + 1] = task.ID
        end
    end
    do
        local i = 0
        while i < #ids do
            do
                local task = _____54B2_591C_5468_671F_4EFB_52A1_8868[ids[i + 1]]
                if task == nil then
                    goto __continue16
                end
                task["已累计毫秒"] = task["已累计毫秒"] + _____54B2_591C_5468_671F_9A71_52A8_95F4_9694_6BEB_79D2
                if task["已累计毫秒"] < task["间隔毫秒"] then
                    goto __continue16
                end
                task["已累计毫秒"] = task["已累计毫秒"] - task["间隔毫秒"]
                task["回调"](task["变量"])
            end
            ::__continue16::
            i = i + 1
        end
    end
end
____exports["注册咲夜周期任务"] = function(intervalMs, callback, variable)
    _____54B2_591C_5468_671F_4EFB_52A1_81EA_589EID = _____54B2_591C_5468_671F_4EFB_52A1_81EA_589EID + 1
    local id = _____54B2_591C_5468_671F_4EFB_52A1_81EA_589EID
    _____54B2_591C_5468_671F_4EFB_52A1_8868[id] = {
        ID = id,
        ["间隔毫秒"] = math.max(
            _____54B2_591C_5468_671F_9A71_52A8_95F4_9694_6BEB_79D2,
            math.floor(intervalMs + 0.5)
        ),
        ["已累计毫秒"] = 0,
        ["回调"] = callback,
        ["变量"] = variable
    }
    _____54B2_591C_5468_671F_4EFB_52A1_6570_91CF = _____54B2_591C_5468_671F_4EFB_52A1_6570_91CF + 1
    if _____54B2_591C_5468_671F_9A71_52A8ID == 0 then
        _____54B2_591C_5468_671F_9A71_52A8ID = addPeriodicCallback(_____54B2_591C_5468_671F_9A71_52A8_95F4_9694_6BEB_79D2, _____63A8_8FDB_54B2_591C_5468_671F_4EFB_52A1)
    end
    return id
end
____exports["移除咲夜周期任务"] = function(id)
    if id == 0 or _____54B2_591C_5468_671F_4EFB_52A1_8868[id] == nil then
        return
    end
    __TS__Delete(_____54B2_591C_5468_671F_4EFB_52A1_8868, id)
    _____54B2_591C_5468_671F_4EFB_52A1_6570_91CF = _____54B2_591C_5468_671F_4EFB_52A1_6570_91CF - 1
    if _____54B2_591C_5468_671F_4EFB_52A1_6570_91CF <= 0 and _____54B2_591C_5468_671F_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____54B2_591C_5468_671F_9A71_52A8ID)
        _____54B2_591C_5468_671F_9A71_52A8ID = 0
        _____54B2_591C_5468_671F_4EFB_52A1_6570_91CF = 0
    end
end
____exports["两点角度"] = function(x1, y1, x2, y2)
    return jass.Atan2(y2 - y1, x2 - x1) / bj_DEGTORAD
end
____exports["极坐标X"] = function(x, distance, angle)
    return x + distance * Cos(angle * bj_DEGTORAD)
end
____exports["极坐标Y"] = function(y, distance, angle)
    return y + distance * Sin(angle * bj_DEGTORAD)
end
____exports["创建咲夜单位壳"] = function(caster, unitTypeId, x, y, facing)
    local shell = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        GetOwningPlayer(caster),
        unitTypeId,
        x,
        y,
        facing
    )
    if shell == nil or shell == 0 then
        return nil
    end
    SetUnitPathing(shell, false)
    SetUnitFlyHeight(
        shell,
        GetUnitDefaultFlyHeight(shell) + GetUnitFlyHeight(caster),
        0
    )
    return shell
end
____exports["安全移除单位壳"] = function(unit)
    if unit ~= nil and unit ~= 0 then
        RemoveUnit(unit)
    end
end
____exports["播放咲夜单位音效"] = function(globalName, unit)
    local sound = jglobals[globalName]
    if sound ~= nil and sound ~= 0 and unit ~= nil and unit ~= 0 then
        PlaySoundOnUnitBJ(sound, 100, unit)
    end
end
____exports["播放咲夜坐标音效"] = function(globalName, x, y)
    local sound = jglobals[globalName]
    if sound == nil or sound == 0 then
        return
    end
    PlaySoundAtPointBJ(
        sound,
        100,
        x,
        y,
        0
    )
end
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local function _____6062_590D_77ED_786C_76F4(variable)
    local params = variable
    if params == nil then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(params["单位"], params["来源"])
end
____exports["施加短硬直并播放动作"] = function(unit, source, seconds, animation)
    _____6DFB_52A0_5355_4F4D_6682_505C(unit, source)
    if animation ~= nil and animation ~= "" then
        jass.SetUnitAnimation(unit, animation)
    end
    addDelayedCallback(
        math.max(
            1,
            math.floor(seconds * 1000 + 0.5)
        ),
        _____6062_590D_77ED_786C_76F4,
        {["单位"] = unit, ["来源"] = source}
    )
end
local _____54B2_591C_98DE_5200_767B_8BB0_8868 = {}
____exports["登记咲夜飞刀"] = function(controller)
    if controller["单位"] == nil or controller["单位"] == 0 or controller["主人"] == nil or controller["主人"] == 0 then
        return
    end
    _____54B2_591C_98DE_5200_767B_8BB0_8868[jass.GetHandleId(controller["单位"])] = controller
end
____exports["注销咲夜飞刀"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    __TS__Delete(
        _____54B2_591C_98DE_5200_767B_8BB0_8868,
        jass.GetHandleId(unit)
    )
end
____exports["获取咲夜现存飞刀"] = function(owner, centerX, centerY, radius)
    local result = {}
    local radiusSq = radius == nil and -1 or radius * radius
    for key in pairs(_____54B2_591C_98DE_5200_767B_8BB0_8868) do
        do
            local controller = _____54B2_591C_98DE_5200_767B_8BB0_8868[key]
            if controller == nil or controller["主人"] ~= owner then
                goto __continue45
            end
            if not ____exports["单位存活"](controller["单位"]) then
                __TS__Delete(_____54B2_591C_98DE_5200_767B_8BB0_8868, key)
                goto __continue45
            end
            if radiusSq >= 0 and centerX ~= nil and centerY ~= nil then
                local dx = GetUnitX(controller["单位"]) - centerX
                local dy = GetUnitY(controller["单位"]) - centerY
                if dx * dx + dy * dy > radiusSq then
                    goto __continue45
                end
            end
            result[#result + 1] = controller
        end
        ::__continue45::
    end
    return result
end
local function _____7ED3_675F_76F4_7EBF_98DE_5200(state)
    if state["已结束"] then
        return
    end
    state["已结束"] = true
    if state["周期ID"] ~= 0 then
        ____exports["移除咲夜周期任务"](state["周期ID"])
    end
    state["周期ID"] = 0
    ____exports["注销咲夜飞刀"](state["单位"])
    ____exports["安全移除单位壳"](state["单位"])
    if state["参数"]["结束回调"] ~= nil then
        state["参数"]["结束回调"](state)
    end
end
local function _____63A8_8FDB_76F4_7EBF_98DE_5200(variable)
    local state = variable
    if state == nil or state["已结束"] then
        return
    end
    local shell = state["单位"]
    if not ____exports["单位存活"](shell) or not ____exports["单位存活"](state["参数"]["施法者"]) then
        _____7ED3_675F_76F4_7EBF_98DE_5200(state)
        return
    end
    if _____5355_4F4D_662F_5426_6682_505C(shell) then
        return
    end
    local nextX = ____exports["极坐标X"](
        GetUnitX(shell),
        state["参数"]["每Tick位移"],
        state["角度"]
    )
    local nextY = ____exports["极坐标Y"](
        GetUnitY(shell),
        state["参数"]["每Tick位移"],
        state["角度"]
    )
    SetUnitX(shell, nextX)
    SetUnitY(shell, nextY)
    state["已飞行距离"] = state["已飞行距离"] + state["参数"]["每Tick位移"]
    local targets = _____679A_4E3E_98DE_5200_78B0_649E_654C_4EBA(state["参数"]["施法者"], nextX, nextY, state["参数"]["命中半径"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                local targetId = jass.GetHandleId(target)
                if state["参数"]["命中去重"] == true and state["已命中"][targetId] then
                    goto __continue60
                end
                state["已命中"][targetId] = true
                local result = state["参数"]["命中回调"](target, state)
                if result == "结束" then
                    _____7ED3_675F_76F4_7EBF_98DE_5200(state)
                    return
                end
                if result == "反弹" then
                    state["角度"] = (state["角度"] + 180) % 360
                    SetUnitFacing(shell, state["角度"])
                    break
                end
            end
            ::__continue60::
            i = i + 1
        end
    end
    if state["已飞行距离"] >= state["参数"]["最大距离"] then
        _____7ED3_675F_76F4_7EBF_98DE_5200(state)
    end
end
____exports["创建直线飞刀"] = function(params)
    local shell = ____exports["创建咲夜单位壳"](
        params["施法者"],
        params["单位类型ID"],
        params.X,
        params.Y,
        params["角度"]
    )
    if shell == nil or shell == 0 then
        return nil
    end
    local state = {
        ["参数"] = params,
        ["单位"] = shell,
        ["角度"] = params["角度"],
        ["已飞行距离"] = 0,
        ["周期ID"] = 0,
        ["已结束"] = false,
        ["已命中"] = {}
    }
    ____exports["登记咲夜飞刀"]({
        ["单位"] = shell,
        ["主人"] = params["施法者"],
        ["取角度"] = function()
            return state["角度"]
        end,
        ["设置角度"] = function(value)
            state["角度"] = value
            SetUnitFacing(state["单位"], value)
        end,
        ["取每Tick位移"] = function()
            return state["参数"]["每Tick位移"]
        end,
        ["设置每Tick位移"] = function(value)
            state["参数"]["每Tick位移"] = value
        end,
        ["取已飞行距离"] = function()
            return state["已飞行距离"]
        end,
        ["设置已飞行距离"] = function(value)
            state["已飞行距离"] = value
        end,
        ["取最大距离"] = function()
            return state["参数"]["最大距离"]
        end,
        ["设置最大距离"] = function(value)
            state["参数"]["最大距离"] = value
        end,
        ["结束"] = function()
            _____7ED3_675F_76F4_7EBF_98DE_5200(state)
        end
    })
    state["周期ID"] = ____exports["注册咲夜周期任务"](params["周期毫秒"], _____63A8_8FDB_76F4_7EBF_98DE_5200, state)
    return state
end
return ____exports
