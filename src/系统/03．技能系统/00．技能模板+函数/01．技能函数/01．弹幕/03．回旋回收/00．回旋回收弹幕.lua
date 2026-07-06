--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_8F68_8FF9 = ____index["创建二阶贝塞尔轨迹"]
local _____521B_5EFA_539F_751F_5F39_5E55 = ____index["创建原生弹幕"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index")
local _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB = ____require_result_0["按英雄技能距离修正上下文修正距离"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local SquareRoot = jass.SquareRoot
local Atan2 = jass.Atan2
local bj_RADTODEG = jass.bj_RADTODEG
local CosBJ = require("lib.扩展函数.BJ函数.12．数学函数").CosBJ
local SinBJ = require("lib.扩展函数.BJ函数.12．数学函数").SinBJ
local function _____8BA1_7B97_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
local function _____8BA1_7B97_6301_7EED_65F6_95F4(_____8DDD_79BB, _____901F_5EA6)
    if _____901F_5EA6 <= 0 then
        return 0.01
    end
    local t = _____8DDD_79BB / _____901F_5EA6
    return t > 0.01 and t or 0.01
end
local function _____521B_5EFA_56DE_7A0B_9501_5B9A_65BD_6CD5_8005_8F68_8FF9(_____65BD_6CD5_8005, _____5230_8FBE_534A_5F84)
    return function(_____5B9E_4F8B, delta)
        local targetX = GetUnitX(_____65BD_6CD5_8005)
        local targetY = GetUnitY(_____65BD_6CD5_8005)
        local dx = targetX - _____5B9E_4F8B["当前X"]
        local dy = targetY - _____5B9E_4F8B["当前Y"]
        local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy)
        local _____65B9_5411_89D2 = Atan2(dy, dx) * bj_RADTODEG
        local _____6B65_957F = _____5B9E_4F8B["当前速度"] * delta
        if _____8DDD_79BB <= _____5230_8FBE_534A_5F84 or _____8DDD_79BB <= _____6B65_957F or _____8DDD_79BB <= 0.01 then
            return {X = targetX, Y = targetY, ["方向角"] = _____65B9_5411_89D2, ["完成"] = true}
        end
        local _____6BD4_4F8B = _____6B65_957F / _____8DDD_79BB
        return {X = _____5B9E_4F8B["当前X"] + dx * _____6BD4_4F8B, Y = _____5B9E_4F8B["当前Y"] + dy * _____6BD4_4F8B, ["方向角"] = _____65B9_5411_89D2, ["完成"] = false}
    end
end
____exports["创建回旋回收弹幕"] = function(_____53C2_6570)
    local _____65BD_6CD5_8005 = _____53C2_6570["施法者"]
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        return
    end
    local startX = GetUnitX(_____65BD_6CD5_8005)
    local startY = GetUnitY(_____65BD_6CD5_8005)
    local face = GetUnitFacing(_____65BD_6CD5_8005)
    local _____8DDD_79BB = _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB(_____53C2_6570["距离"], _____53C2_6570["英雄技能距离修正"], "弹幕飞行距离")
    local endX = startX + CosBJ(face) * _____8DDD_79BB
    local endY = startY + SinBJ(face) * _____8DDD_79BB
    local _____504F_79FB = _____53C2_6570["曲线偏移"] or 180
    local ctrlX = startX + CosBJ(face + 90) * _____504F_79FB + CosBJ(face) * _____8DDD_79BB * 0.5
    local ctrlY = startY + SinBJ(face + 90) * _____504F_79FB + SinBJ(face) * _____8DDD_79BB * 0.5
    local _____53BB_7A0B_8DDD_79BB = _____8BA1_7B97_8DDD_79BB(startX, startY, endX, endY)
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____65BD_6CD5_8005,
        X = startX,
        Y = startY,
        ["方向角"] = face,
        ["弹幕单位类型"] = _____53C2_6570["弹幕单位类型"],
        ["模型"] = _____53C2_6570["模型"],
        ["附着特效模型"] = _____53C2_6570["附着特效模型"],
        ["速度"] = _____53C2_6570["速度"],
        ["生命周期"] = _____8BA1_7B97_6301_7EED_65F6_95F4(_____53BB_7A0B_8DDD_79BB, _____53C2_6570["速度"]),
        ["最大距离"] = _____53BB_7A0B_8DDD_79BB,
        ["轨迹采样器"] = _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_8F68_8FF9(
            startX,
            startY,
            ctrlX,
            ctrlY,
            endX,
            endY
        ),
        ["命中半径"] = _____53C2_6570["命中半径"] or 96,
        ["伤害值"] = _____53C2_6570["去程伤害"] or 0,
        ["伤害形态"] = "AOE",
        ["每单位最大命中次数"] = _____53C2_6570["去程每单位最大命中次数"] or 1,
        ["on结束"] = function()
            local returnStartX = endX
            local returnStartY = endY
            local ownerX = GetUnitX(_____65BD_6CD5_8005)
            local ownerY = GetUnitY(_____65BD_6CD5_8005)
            local _____56DE_7A0B_8DDD_79BB = _____8BA1_7B97_8DDD_79BB(returnStartX, returnStartY, ownerX, ownerY)
            local returnCtrlX = (returnStartX + ownerX) * 0.5 - CosBJ(face + 90) * _____504F_79FB
            local returnCtrlY = (returnStartY + ownerY) * 0.5 - SinBJ(face + 90) * _____504F_79FB
            local _____56DE_7A0B_9501_5B9A_65BD_6CD5_8005 = _____53C2_6570["回程锁定施法者"] == true
            _____521B_5EFA_539F_751F_5F39_5E55({
                ["所有者"] = _____65BD_6CD5_8005,
                X = returnStartX,
                Y = returnStartY,
                ["方向角"] = face + 180,
                ["弹幕单位类型"] = _____53C2_6570["弹幕单位类型"],
                ["模型"] = _____53C2_6570["模型"],
                ["附着特效模型"] = _____53C2_6570["附着特效模型"],
                ["速度"] = _____53C2_6570["速度"],
                ["生命周期"] = _____56DE_7A0B_9501_5B9A_65BD_6CD5_8005 and 5 or _____8BA1_7B97_6301_7EED_65F6_95F4(_____56DE_7A0B_8DDD_79BB, _____53C2_6570["速度"]),
                ["最大距离"] = _____56DE_7A0B_9501_5B9A_65BD_6CD5_8005 and _____8DDD_79BB * 3 or _____56DE_7A0B_8DDD_79BB,
                ["轨迹采样器"] = _____56DE_7A0B_9501_5B9A_65BD_6CD5_8005 and _____521B_5EFA_56DE_7A0B_9501_5B9A_65BD_6CD5_8005_8F68_8FF9(_____65BD_6CD5_8005, _____53C2_6570["命中半径"] or 96) or _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_8F68_8FF9(
                    returnStartX,
                    returnStartY,
                    returnCtrlX,
                    returnCtrlY,
                    ownerX,
                    ownerY
                ),
                ["命中半径"] = _____53C2_6570["命中半径"] or 96,
                ["伤害值"] = _____53C2_6570["回程伤害"] or _____53C2_6570["去程伤害"] or 0,
                ["伤害形态"] = "AOE",
                ["每单位最大命中次数"] = _____53C2_6570["回程每单位最大命中次数"] or 1,
                ["on结束"] = function()
                    if _____53C2_6570["on结束"] ~= nil then
                        _____53C2_6570["on结束"]()
                    end
                end
            })
        end
    })
end
return ____exports
