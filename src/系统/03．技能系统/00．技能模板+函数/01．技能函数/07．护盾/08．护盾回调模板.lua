--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
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
--- 创建护盾开始调试回调
____exports["创建护盾开始调试回调"] = function(_____6A21_5757_540D)
    if _____6A21_5757_540D == nil then
        _____6A21_5757_540D = "护盾"
    end
    return function(_____5355_4F4D, _____62A4_76FEID)
        debugLogForce(
            _____6A21_5757_540D,
            "护盾开始",
            "单位=",
            _____5355_4F4D,
            "护盾ID=",
            _____62A4_76FEID
        )
    end
end
--- 创建护盾破碎调试回调
____exports["创建护盾破碎调试回调"] = function(_____6A21_5757_540D)
    if _____6A21_5757_540D == nil then
        _____6A21_5757_540D = "护盾"
    end
    return function(_____5355_4F4D, _____62A4_76FEID, _____5438_6536_4F24_5BB3)
        debugLogForce(
            _____6A21_5757_540D,
            "护盾破碎",
            "单位=",
            _____5355_4F4D,
            "护盾ID=",
            _____62A4_76FEID,
            "吸收=",
            _____5438_6536_4F24_5BB3
        )
    end
end
--- 创建护盾到期调试回调
____exports["创建护盾到期调试回调"] = function(_____6A21_5757_540D)
    if _____6A21_5757_540D == nil then
        _____6A21_5757_540D = "护盾"
    end
    return function(_____5355_4F4D, _____62A4_76FEID)
        debugLogForce(
            _____6A21_5757_540D,
            "护盾到期",
            "单位=",
            _____5355_4F4D,
            "护盾ID=",
            _____62A4_76FEID
        )
    end
end
--- 创建护盾结束调试回调
____exports["创建护盾结束调试回调"] = function(_____6A21_5757_540D)
    if _____6A21_5757_540D == nil then
        _____6A21_5757_540D = "护盾"
    end
    return function(_____5355_4F4D, _____62A4_76FEID, _____539F_56E0)
        debugLogForce(
            _____6A21_5757_540D,
            "护盾结束",
            "单位=",
            _____5355_4F4D,
            "护盾ID=",
            _____62A4_76FEID,
            "原因=",
            _____539F_56E0
        )
    end
end
--- 创建护盾完整调试回调（开始+破碎+到期+结束）
____exports["创建护盾完整调试回调"] = function(_____6A21_5757_540D)
    if _____6A21_5757_540D == nil then
        _____6A21_5757_540D = "护盾"
    end
    return {
        ["开始回调"] = ____exports["创建护盾开始调试回调"](_____6A21_5757_540D),
        ["破碎回调"] = ____exports["创建护盾破碎调试回调"](_____6A21_5757_540D),
        ["到期回调"] = ____exports["创建护盾到期调试回调"](_____6A21_5757_540D),
        ["结束回调"] = ____exports["创建护盾结束调试回调"](_____6A21_5757_540D)
    }
end
return ____exports
