--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local _____8BA1_7B97_8DDD_79BB = ____01_FF0E_5171_4EAB["计算距离"]
local _____53D6_5750_6807_671D_5411_89D2 = ____01_FF0E_5171_4EAB["取坐标朝向角"]
local _____9650_5236_8303_56F4 = ____01_FF0E_5171_4EAB["限制范围"]
____exports["线性插值"] = function(from, to, progress)
    return from + (to - from) * progress
end
____exports["取弹幕轨迹进度"] = function(_____5B9E_4F8B)
    local _____53C2_6570 = _____5B9E_4F8B["参数"]
    if _____53C2_6570["生命周期"] ~= nil and _____53C2_6570["生命周期"] > 0 then
        return _____9650_5236_8303_56F4(_____5B9E_4F8B["已运行时间"] / _____53C2_6570["生命周期"], 0, 1)
    end
    if _____53C2_6570["最大距离"] ~= nil and _____53C2_6570["最大距离"] > 0 then
        return _____9650_5236_8303_56F4(_____5B9E_4F8B["已飞行距离"] / _____53C2_6570["最大距离"], 0, 1)
    end
    return 0
end
____exports["取采样方向"] = function(oldX, oldY, newX, newY, fallback)
    if _____8BA1_7B97_8DDD_79BB(oldX, oldY, newX, newY) <= 0.01 then
        return fallback
    end
    return _____53D6_5750_6807_671D_5411_89D2(oldX, oldY, newX, newY)
end
____exports["创建直线定点轨迹"] = function(_____8D77_70B9X, _____8D77_70B9Y, _____7EC8_70B9X, _____7EC8_70B9Y)
    return function(_____5B9E_4F8B)
        local progress = ____exports["取弹幕轨迹进度"](_____5B9E_4F8B)
        local x = ____exports["线性插值"](_____8D77_70B9X, _____7EC8_70B9X, progress)
        local y = ____exports["线性插值"](_____8D77_70B9Y, _____7EC8_70B9Y, progress)
        return {
            X = x,
            Y = y,
            ["方向角"] = ____exports["取采样方向"](
                _____5B9E_4F8B["当前X"],
                _____5B9E_4F8B["当前Y"],
                x,
                y,
                _____5B9E_4F8B["当前方向角"]
            ),
            ["完成"] = progress >= 1
        }
    end
end
return ____exports
