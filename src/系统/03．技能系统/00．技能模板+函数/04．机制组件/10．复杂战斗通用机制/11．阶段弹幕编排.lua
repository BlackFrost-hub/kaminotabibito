--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5F39_5E55_6539_5411 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.06．改向与反弹.00．弹幕改向")
local _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C = ____00_FF0E_5F39_5E55_6539_5411["设置原生弹幕指定角度飞行"]
local ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具")
local _____4E24_70B9_65B9_5411_89D2 = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["两点方向角"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local function _____89E3_6790_76EE_6807_5355_4F4D(raw)
    local ____temp_1
    if type(raw) == "function" then
        ____temp_1 = raw()
    else
        ____temp_1 = raw
    end
    return ____temp_1
end
local function _____89E3_6790_76EE_6807_70B9(raw)
    if raw == nil then
        return nil
    end
    local ____temp_2
    if type(raw) == "function" then
        ____temp_2 = raw()
    else
        ____temp_2 = raw
    end
    return ____temp_2
end
____exports["注册阶段弹幕编排"] = function(_____53C2_6570)
    do
        local i = 0
        while i < #_____53C2_6570["规则列表"] do
            local _____89C4_5219 = _____53C2_6570["规则列表"][i + 1]
            local id = addDelayedCallback(
                _____89C4_5219["延迟秒"] * 1000,
                function()
                    local ____self_3 = _____53C2_6570["阶段上下文"]
                    if not ____self_3["是阶段"](____self_3, _____89C4_5219["阶段ID"]) then
                        return
                    end
                    local angle = _____89C4_5219["固定角度"]
                    if angle == nil then
                        local unit = _____89E3_6790_76EE_6807_5355_4F4D(_____89C4_5219["目标单位"])
                        if unit ~= nil and unit ~= 0 then
                            local bulletUnit = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
                            local bullet = bulletUnit["获取原生弹幕"](_____53C2_6570["弹幕ID"])
                            local ____temp_4
                            if bullet ~= nil then
                                ____temp_4 = bullet["弹幕单位"]
                            else
                                ____temp_4 = nil
                            end
                            local fromUnit = ____temp_4
                            if fromUnit ~= nil and fromUnit ~= 0 then
                                angle = _____4E24_70B9_65B9_5411_89D2(
                                    GetUnitX(fromUnit),
                                    GetUnitY(fromUnit),
                                    GetUnitX(unit),
                                    GetUnitY(unit)
                                )
                            end
                        end
                    end
                    if angle == nil then
                        local point = _____89E3_6790_76EE_6807_70B9(_____89C4_5219["目标点"])
                        if point ~= nil then
                            local bulletUnit = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
                            local bullet = bulletUnit["获取原生弹幕"](_____53C2_6570["弹幕ID"])
                            local ____temp_5
                            if bullet ~= nil then
                                ____temp_5 = bullet["弹幕单位"]
                            else
                                ____temp_5 = nil
                            end
                            local fromUnit = ____temp_5
                            if fromUnit ~= nil and fromUnit ~= 0 then
                                angle = _____4E24_70B9_65B9_5411_89D2(
                                    GetUnitX(fromUnit),
                                    GetUnitY(fromUnit),
                                    point.X,
                                    point.Y
                                )
                            end
                        end
                    end
                    if angle ~= nil then
                        _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C(_____53C2_6570["弹幕ID"], angle, _____89C4_5219["新速度"])
                    end
                end
            )
            if _____53C2_6570["清理"] ~= nil then
                local ____self_6 = _____53C2_6570["清理"]
                ____self_6["登记延迟回调"](
                    ____self_6,
                    (_____53C2_6570["名称"] .. "-阶段弹幕改向") .. tostring(i),
                    id
                )
            end
            i = i + 1
        end
    end
end
return ____exports
