--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local CosBJ = ____01_FF0E_5171_4EAB.CosBJ
local GetUnitX = ____01_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____01_FF0E_5171_4EAB.GetUnitY
local SinBJ = ____01_FF0E_5171_4EAB.SinBJ
local _____53D6_5750_6807_671D_5411_89D2 = ____01_FF0E_5171_4EAB["取坐标朝向角"]
local _____8BA1_7B97_8DDD_79BB = ____01_FF0E_5171_4EAB["计算距离"]
local ____00_FF0E_8F68_8FF9_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.00．轨迹工具")
local _____53D6_91C7_6837_65B9_5411 = ____00_FF0E_8F68_8FF9_5DE5_5177["取采样方向"]
local _____53D6_5F39_5E55_8F68_8FF9_8FDB_5EA6 = ____00_FF0E_8F68_8FF9_5DE5_5177["取弹幕轨迹进度"]
local _____7EBF_6027_63D2_503C = ____00_FF0E_8F68_8FF9_5DE5_5177["线性插值"]
____exports["创建圆弧轨迹"] = function(_____5706_5FC3X, _____5706_5FC3Y, _____534A_5F84, _____8D77_59CB_89D2_5EA6, _____7ED3_675F_89D2_5EA6)
    return function(_____5B9E_4F8B, _delta)
        local t = _____53D6_5F39_5E55_8F68_8FF9_8FDB_5EA6(_____5B9E_4F8B)
        local _____89D2_5EA6 = _____7EBF_6027_63D2_503C(_____8D77_59CB_89D2_5EA6, _____7ED3_675F_89D2_5EA6, t)
        local x = _____5706_5FC3X + CosBJ(_____89D2_5EA6) * _____534A_5F84
        local y = _____5706_5FC3Y + SinBJ(_____89D2_5EA6) * _____534A_5F84
        return {
            X = x,
            Y = y,
            ["方向角"] = _____53D6_91C7_6837_65B9_5411(
                _____5B9E_4F8B["当前X"],
                _____5B9E_4F8B["当前Y"],
                x,
                y,
                _____5B9E_4F8B["当前方向角"]
            ),
            ["完成"] = t >= 1
        }
    end
end
____exports["创建追踪插值轨迹"] = function(_____76EE_6807_5355_4F4D, _____5230_8FBE_8DDD_79BB)
    if _____5230_8FBE_8DDD_79BB == nil then
        _____5230_8FBE_8DDD_79BB = 32
    end
    return function(_____5B9E_4F8B, delta)
        if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
            return {X = _____5B9E_4F8B["当前X"], Y = _____5B9E_4F8B["当前Y"], ["方向角"] = _____5B9E_4F8B["当前方向角"], ["完成"] = true}
        end
        local tx = GetUnitX(_____76EE_6807_5355_4F4D)
        local ty = GetUnitY(_____76EE_6807_5355_4F4D)
        local _____8DDD_79BB = _____8BA1_7B97_8DDD_79BB(_____5B9E_4F8B["当前X"], _____5B9E_4F8B["当前Y"], tx, ty)
        if _____8DDD_79BB <= _____5230_8FBE_8DDD_79BB then
            return {
                X = tx,
                Y = ty,
                ["方向角"] = _____53D6_5750_6807_671D_5411_89D2(_____5B9E_4F8B["当前X"], _____5B9E_4F8B["当前Y"], tx, ty),
                ["完成"] = true
            }
        end
        local _____6B65_957F = _____5B9E_4F8B["当前速度"] * delta
        local _____8FDB_5EA6 = _____8DDD_79BB > 0 and _____6B65_957F / _____8DDD_79BB or 1
        local _____5B89_5168_8FDB_5EA6 = _____8FDB_5EA6 > 1 and 1 or _____8FDB_5EA6
        local x = _____7EBF_6027_63D2_503C(_____5B9E_4F8B["当前X"], tx, _____5B89_5168_8FDB_5EA6)
        local y = _____7EBF_6027_63D2_503C(_____5B9E_4F8B["当前Y"], ty, _____5B89_5168_8FDB_5EA6)
        return {
            X = x,
            Y = y,
            ["方向角"] = _____53D6_5750_6807_671D_5411_89D2(_____5B9E_4F8B["当前X"], _____5B9E_4F8B["当前Y"], x, y),
            ["完成"] = _____5B89_5168_8FDB_5EA6 >= 1
        }
    end
end
return ____exports
