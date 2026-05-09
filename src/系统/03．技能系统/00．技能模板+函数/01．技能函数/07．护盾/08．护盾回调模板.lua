--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_62A4_76FE_7C7B_578B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.01．护盾类型")
local _____62A4_76FE_7C7B_578B = ____01_FF0E_62A4_76FE_7C7B_578B["护盾类型"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
local CreateFloatTextOnUnit = ____require_result_0.CreateFloatTextOnUnit
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
____exports["护盾类型名称"] = {[_____62A4_76FE_7C7B_578B["通用"]] = "通用", [_____62A4_76FE_7C7B_578B["物理"]] = "物理", [_____62A4_76FE_7C7B_578B["魔法"]] = "魔法"}
--- 获取护盾类型中文名
local function _____83B7_53D6_62A4_76FE_7C7B_578B_540D(_____7C7B_578B)
    return ____exports["护盾类型名称"][_____7C7B_578B] or "未知"
end
--- 创建护盾开始特效回调
____exports["创建护盾开始特效回调"] = function(_____6A21_578B_8DEF_5F84, _____9644_7740_70B9)
    if _____9644_7740_70B9 == nil then
        _____9644_7740_70B9 = "origin"
    end
    return function(______5355_4F4D, ______62A4_76FEID)
        local eff = AddSpecialEffectTarget(_____6A21_578B_8DEF_5F84, ______5355_4F4D, _____9644_7740_70B9)
        if eff ~= nil then
            DestroyEffect(eff)
        end
    end
end
--- 创建护盾破碎特效回调
____exports["创建护盾破碎特效回调"] = function(_____6A21_578B_8DEF_5F84, _____9644_7740_70B9)
    if _____9644_7740_70B9 == nil then
        _____9644_7740_70B9 = "origin"
    end
    return function(______5355_4F4D, ______62A4_76FEID, ______5438_6536_4F24_5BB3)
        local eff = AddSpecialEffectTarget(_____6A21_578B_8DEF_5F84, ______5355_4F4D, _____9644_7740_70B9)
        if eff ~= nil then
            DestroyEffect(eff)
        end
    end
end
--- 创建护盾到期特效回调
____exports["创建护盾到期特效回调"] = function(_____6A21_578B_8DEF_5F84, _____9644_7740_70B9)
    if _____9644_7740_70B9 == nil then
        _____9644_7740_70B9 = "origin"
    end
    return function(______5355_4F4D, ______62A4_76FEID)
        local eff = AddSpecialEffectTarget(_____6A21_578B_8DEF_5F84, ______5355_4F4D, _____9644_7740_70B9)
        if eff ~= nil then
            DestroyEffect(eff)
        end
    end
end
--- 护盾类型对应颜色
local _____62A4_76FE_7C7B_578B_989C_8272 = {[_____62A4_76FE_7C7B_578B["物理"]] = {r = 180, g = 100, b = 30}, [_____62A4_76FE_7C7B_578B["魔法"]] = {r = 30, g = 30, b = 180}, [_____62A4_76FE_7C7B_578B["通用"]] = {r = 200, g = 200, b = 200}}
--- 显示护盾到期漂浮文字
____exports["显示护盾到期漂浮文字"] = function(_____5355_4F4D, _____62A4_76FE_7C7B_578B_503C)
    local _____989C_8272 = _____62A4_76FE_7C7B_578B_989C_8272[_____62A4_76FE_7C7B_578B_503C] or ({r = 200, g = 200, b = 200})
    local _____7C7B_578B_540D = ____exports["护盾类型名称"][_____62A4_76FE_7C7B_578B_503C] or "护盾"
    CreateFloatTextOnUnit(_____5355_4F4D, ("『" .. _____7C7B_578B_540D) .. "护盾消失』", {
        size = 10,
        red = _____989C_8272.r,
        green = _____989C_8272.g,
        blue = _____989C_8272.b,
        duration = 1.2,
        speedY = 0.06
    })
end
--- 显示护盾破碎漂浮文字
____exports["显示护盾破碎漂浮文字"] = function(_____5355_4F4D, _____62A4_76FE_7C7B_578B_503C)
    local _____989C_8272 = _____62A4_76FE_7C7B_578B_989C_8272[_____62A4_76FE_7C7B_578B_503C] or ({r = 200, g = 200, b = 200})
    local _____7C7B_578B_540D = ____exports["护盾类型名称"][_____62A4_76FE_7C7B_578B_503C] or "护盾"
    CreateFloatTextOnUnit(_____5355_4F4D, ("『" .. _____7C7B_578B_540D) .. "护盾破碎』", {
        size = 10,
        red = _____989C_8272.r,
        green = _____989C_8272.g,
        blue = _____989C_8272.b,
        duration = 1.2,
        speedY = 0.06
    })
end
return ____exports
