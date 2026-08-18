--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local DEG_TO_RAD = jass.bj_DEGTORAD
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitState = jass.GetUnitState
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local SetUnitPathing = jass.SetUnitPathing
local RemoveUnit = jass.RemoveUnit
local DestroyEffect = jass.DestroyEffect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local EXSetEffectXY = japi.EXSetEffectXY
local EXSetEffectZ = japi.EXSetEffectZ
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local EXEffectMatScale = japi.EXEffectMatScale
local _____73AF_7ED5_5B9E_4F8B_81EA_589EID = 0
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____6807_51C6_5316_89D2_5EA6(angle)
    local result = angle % 360
    if result < 0 then
        result = result + 360
    end
    return result
end
local function _____53D6_6700_77ED_89D2_5EA6_5DEE(oldAngle, newAngle)
    local delta = _____6807_51C6_5316_89D2_5EA6(newAngle) - _____6807_51C6_5316_89D2_5EA6(oldAngle)
    if delta > 180 then
        delta = delta - 360
    elseif delta < -180 then
        delta = delta + 360
    end
    return delta
end
local function _____53D6_8282_70B9_671D_5411(mode, orbitAngle, correction)
    if mode == "保持" then
        return nil
    end
    if mode == "沿切线" then
        return orbitAngle + 90 + correction
    end
    if mode == "逆切线" then
        return orbitAngle - 90 + correction
    end
    if mode == "朝向中心" then
        return orbitAngle + 180 + correction
    end
    return orbitAngle + correction
end
local function _____9500_6BC1_73AF_7ED5_8282_70B9(node)
    if node["已销毁"] then
        return
    end
    node["已销毁"] = true
    if not node["自动销毁"] or node["句柄"] == nil or node["句柄"] == 0 then
        return
    end
    if node["类型"] == "单位" then
        RemoveUnit(node["句柄"])
    else
        DestroyEffect(node["句柄"])
    end
end
local function _____521B_5EFA_8FD0_884C_8282_70B9(params, nodeParams)
    local center = params["中心单位"]
    local initialAngle = (params["初始角度"] or 0) + (nodeParams["初始角度偏移"] or 0)
    local radius = nodeParams["半径"] or params["半径"]
    local x = GetUnitX(center) + radius * jass.Cos(initialAngle * DEG_TO_RAD)
    local y = GetUnitY(center) + radius * jass.Sin(initialAngle * DEG_TO_RAD)
    local facing = _____53D6_8282_70B9_671D_5411(nodeParams["朝向模式"] or "保持", initialAngle, nodeParams["朝向修正角度"] or 0) or 0
    local ____temp_2
    if nodeParams["类型"] == "单位" then
        ____temp_2 = nodeParams["单位"]
    else
        ____temp_2 = nodeParams["特效"]
    end
    local handle = ____temp_2
    local created = false
    if handle == nil or handle == 0 then
        if nodeParams["类型"] == "单位" then
            if nodeParams["单位类型ID"] == nil or nodeParams["单位类型ID"] == 0 or nodeParams["所有者"] == nil then
                return nil
            end
            handle = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                nodeParams["所有者"],
                nodeParams["单位类型ID"],
                x,
                y,
                facing
            )
        else
            if nodeParams["模型路径"] == nil or nodeParams["模型路径"] == "" then
                return nil
            end
            handle = jass.AddSpecialEffect(nodeParams["模型路径"], x, y)
        end
        created = true
    end
    if handle == nil or handle == 0 then
        return nil
    end
    if nodeParams["类型"] == "单位" then
        if nodeParams["禁用碰撞"] ~= false then
            SetUnitPathing(handle, false)
        end
        if nodeParams["缩放"] ~= nil then
            SetUnitScale(handle, nodeParams["缩放"], nodeParams["缩放"], nodeParams["缩放"])
        end
    elseif nodeParams["缩放"] ~= nil and type(EXEffectMatScale) == "function" then
        EXEffectMatScale(handle, nodeParams["缩放"], nodeParams["缩放"], nodeParams["缩放"])
    end
    local ____nodeParams__7C7B_578B_4 = nodeParams["类型"]
    local ____handle_5 = handle
    local ____temp_6 = nodeParams["初始角度偏移"] or 0
    local ____temp_7 = nodeParams["高度"] or 0
    local ____temp_8 = nodeParams["跟随中心飞行高度"] ~= false
    local ____temp_9 = nodeParams["朝向模式"] or "保持"
    local ____temp_10 = nodeParams["朝向修正角度"] or 0
    local ____nodeParams__81EA_52A8_9500_6BC1_3 = nodeParams["自动销毁"]
    if ____nodeParams__81EA_52A8_9500_6BC1_3 == nil then
        ____nodeParams__81EA_52A8_9500_6BC1_3 = created
    end
    return {
        ["类型"] = ____nodeParams__7C7B_578B_4,
        ["句柄"] = ____handle_5,
        ["半径"] = radius,
        ["角度偏移"] = ____temp_6,
        ["高度"] = ____temp_7,
        ["跟随中心飞行高度"] = ____temp_8,
        ["朝向模式"] = ____temp_9,
        ["朝向修正角度"] = ____temp_10,
        ["已应用特效朝向"] = nil,
        ["自动销毁"] = ____nodeParams__81EA_52A8_9500_6BC1_3,
        ["已销毁"] = false
    }
end
local function _____66F4_65B0_73AF_7ED5_8282_70B9(instance, node)
    if node["已销毁"] or node["句柄"] == nil or node["句柄"] == 0 then
        return false
    end
    if node["类型"] == "单位" and not _____5355_4F4D_6709_6548(node["句柄"]) then
        return false
    end
    local center = instance["参数"]["中心单位"]
    local angle = instance["当前角度"] + node["角度偏移"]
    local x = GetUnitX(center) + node["半径"] * jass.Cos(angle * DEG_TO_RAD)
    local y = GetUnitY(center) + node["半径"] * jass.Sin(angle * DEG_TO_RAD)
    local z = node["高度"] + (node["跟随中心飞行高度"] and GetUnitFlyHeight(center) or 0)
    local facing = _____53D6_8282_70B9_671D_5411(node["朝向模式"], angle, node["朝向修正角度"])
    if node["类型"] == "单位" then
        SetUnitX(node["句柄"], x)
        SetUnitY(node["句柄"], y)
        SetUnitFlyHeight(node["句柄"], z, 0)
        if facing ~= nil then
            SetUnitFacing(node["句柄"], facing)
        end
    else
        if type(EXSetEffectXY) == "function" then
            EXSetEffectXY(node["句柄"], x, y)
        end
        if type(EXSetEffectZ) == "function" then
            EXSetEffectZ(node["句柄"], z)
        end
        if facing ~= nil and type(EXEffectMatRotateZ) == "function" then
            local delta = node["已应用特效朝向"] == nil and facing or _____53D6_6700_77ED_89D2_5EA6_5DEE(node["已应用特效朝向"], facing)
            if delta ~= 0 then
                EXEffectMatRotateZ(node["句柄"], delta)
            end
            node["已应用特效朝向"] = _____6807_51C6_5316_89D2_5EA6(facing)
        end
    end
    return true
end
local function _____7ED3_675F_73AF_7ED5_5B9E_4F8B(instance, reason)
    if instance["已结束"] then
        return
    end
    instance["已结束"] = true
    if instance["周期ID"] ~= 0 then
        removePeriodicCallback(instance["周期ID"])
    end
    instance["周期ID"] = 0
    do
        local i = 0
        while i < #instance["节点"] do
            _____9500_6BC1_73AF_7ED5_8282_70B9(instance["节点"][i + 1])
            i = i + 1
        end
    end
    if instance["参数"]["结束回调"] ~= nil then
        instance["参数"]["结束回调"](instance, reason)
    end
end
local function _____63A8_8FDB_73AF_7ED5_5B9E_4F8B(variable)
    local instance = variable
    if instance == nil or instance["已结束"] or instance["已暂停"] then
        return
    end
    local params = instance["参数"]
    if params["中心失效时结束"] ~= false and not _____5355_4F4D_6709_6548(params["中心单位"]) then
        _____7ED3_675F_73AF_7ED5_5B9E_4F8B(instance, "中心失效")
        return
    end
    local interval = params["周期毫秒"] or 20
    instance["已运行毫秒"] = instance["已运行毫秒"] + interval
    instance["当前角度"] = _____6807_51C6_5316_89D2_5EA6(instance["当前角度"] + params["角速度"] * interval / 1000)
    local validCount = 0
    do
        local i = 0
        while i < #instance["节点"] do
            if _____66F4_65B0_73AF_7ED5_8282_70B9(instance, instance["节点"][i + 1]) then
                validCount = validCount + 1
            end
            i = i + 1
        end
    end
    if validCount <= 0 then
        _____7ED3_675F_73AF_7ED5_5B9E_4F8B(instance, "无有效节点")
        return
    end
    if params["每Tick"] ~= nil then
        params["每Tick"](instance)
    end
    if params["持续秒"] ~= nil and instance["已运行毫秒"] >= params["持续秒"] * 1000 then
        _____7ED3_675F_73AF_7ED5_5B9E_4F8B(instance, "持续时间结束")
    end
end
____exports["创建单位与特效环绕"] = function(params)
    if params == nil or not _____5355_4F4D_6709_6548(params["中心单位"]) or params["节点"] == nil or #params["节点"] <= 0 then
        return nil
    end
    _____73AF_7ED5_5B9E_4F8B_81EA_589EID = _____73AF_7ED5_5B9E_4F8B_81EA_589EID + 1
    local nodes = {}
    do
        local i = 0
        while i < #params["节点"] do
            local node = _____521B_5EFA_8FD0_884C_8282_70B9(params, params["节点"][i + 1])
            if node ~= nil then
                nodes[#nodes + 1] = node
            end
            i = i + 1
        end
    end
    if #nodes <= 0 then
        return nil
    end
    local instance
    instance = {
        ID = _____73AF_7ED5_5B9E_4F8B_81EA_589EID,
        ["参数"] = params,
        ["节点"] = nodes,
        ["当前角度"] = params["初始角度"] or 0,
        ["已运行毫秒"] = 0,
        ["周期ID"] = 0,
        ["已结束"] = false,
        ["已暂停"] = false,
        ["开始"] = function()
            if instance["已结束"] or instance["周期ID"] ~= 0 then
                return
            end
            instance["周期ID"] = addPeriodicCallback(params["周期毫秒"] or 20, _____63A8_8FDB_73AF_7ED5_5B9E_4F8B, instance)
        end,
        ["暂停"] = function()
            instance["已暂停"] = true
        end,
        ["恢复"] = function()
            instance["已暂停"] = false
        end,
        ["结束"] = function(reason)
            _____7ED3_675F_73AF_7ED5_5B9E_4F8B(instance, reason or "手动")
        end,
        ["设置半径"] = function(radius)
            params["半径"] = radius
            do
                local i = 0
                while i < #instance["节点"] do
                    instance["节点"][i + 1]["半径"] = radius
                    i = i + 1
                end
            end
        end,
        ["设置角速度"] = function(degreesPerSecond)
            params["角速度"] = degreesPerSecond
        end
    }
    do
        local i = 0
        while i < #nodes do
            _____66F4_65B0_73AF_7ED5_8282_70B9(instance, nodes[i + 1])
            i = i + 1
        end
    end
    if params["自动开始"] ~= false then
        instance["开始"]()
    end
    return instance
end
return ____exports
