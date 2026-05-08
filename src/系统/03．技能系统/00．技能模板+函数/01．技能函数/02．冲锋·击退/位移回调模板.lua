--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 位移回调模板
-- 
-- 为冲锋/击退系统提供可复用的回调工厂函数。
-- 配合 `击退系统.ts` 的 `开始回调`、`结束回调`、`命中回调` 使用。
local jass = require("jass.common")
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitDamageTarget = jass.UnitDamageTarget
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setBuff = ____require_result_0.SFB_setBuff
local SFB_setSlow = ____require_result_0.SFB_setSlow
____exports["创建位移开始特效回调"] = function(_____6A21_578B_8DEF_5F84)
    return function(_____5355_4F4D, _ID)
        local _____7279_6548 = AddSpecialEffect(
            _____6A21_578B_8DEF_5F84,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
            DestroyEffect(_____7279_6548)
        end
    end
end
____exports["创建位移结束特效回调"] = function(_____6A21_578B_8DEF_5F84)
    return function(_____5355_4F4D, ______539F_56E0, _ID)
        local _____7279_6548 = AddSpecialEffect(
            _____6A21_578B_8DEF_5F84,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D)
        )
        if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
            DestroyEffect(_____7279_6548)
        end
    end
end
____exports["创建位移结束伤害回调"] = function(_____4F24_5BB3, _____6765_6E90)
    return function(_____5355_4F4D, _____539F_56E0, _ID)
        if _____539F_56E0 == "死亡" or _____539F_56E0 == "主单位死亡" then
            return
        end
        local ____6765_6E90_1 = _____6765_6E90
        if ____6765_6E90_1 == nil then
            ____6765_6E90_1 = _____5355_4F4D
        end
        local _____4F24_5BB3_6765_6E90 = ____6765_6E90_1
        UnitDamageTarget(
            _____4F24_5BB3_6765_6E90,
            _____5355_4F4D,
            _____4F24_5BB3,
            false,
            false,
            jass.ATTACK_TYPE_NORMAL,
            jass.DAMAGE_TYPE_NORMAL,
            jass.WEAPON_TYPE_WHOKNOWS
        )
    end
end
____exports["创建位移结束控制回调"] = function(_____63A7_5236ID, _____6301_7EED_65F6_95F4)
    return function(_____5355_4F4D, _____539F_56E0, _ID)
        if _____539F_56E0 == "死亡" or _____539F_56E0 == "主单位死亡" then
            return
        end
        SFB_setBuff(_____5355_4F4D, _____5355_4F4D, _____63A7_5236ID, _____6301_7EED_65F6_95F4)
    end
end
____exports["创建命中特效回调"] = function(_____6A21_578B_8DEF_5F84)
    return function(______79FB_52A8_5355_4F4D, _____76EE_6807_5355_4F4D, _ID)
        local _____7279_6548 = AddSpecialEffect(
            _____6A21_578B_8DEF_5F84,
            GetUnitX(_____76EE_6807_5355_4F4D),
            GetUnitY(_____76EE_6807_5355_4F4D)
        )
        if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
            DestroyEffect(_____7279_6548)
        end
    end
end
____exports["创建命中控制回调"] = function(_____63A7_5236ID, _____6301_7EED_65F6_95F4)
    return function(_____79FB_52A8_5355_4F4D, _____76EE_6807_5355_4F4D, _ID)
        SFB_setBuff(_____79FB_52A8_5355_4F4D, _____76EE_6807_5355_4F4D, _____63A7_5236ID, _____6301_7EED_65F6_95F4)
    end
end
____exports["创建位移回调"] = function(_____9009_9879)
    local _____7ED3_679C = {}
    if _____9009_9879["开始特效"] then
        _____7ED3_679C["开始回调"] = ____exports["创建位移开始特效回调"](_____9009_9879["开始特效"])
    end
    local _____7ED3_675F_56DE_8C03_5217_8868 = {}
    if _____9009_9879["结束特效"] then
        _____7ED3_675F_56DE_8C03_5217_8868[#_____7ED3_675F_56DE_8C03_5217_8868 + 1] = ____exports["创建位移结束特效回调"](_____9009_9879["结束特效"])
    end
    if _____9009_9879["结束伤害"] ~= nil and _____9009_9879["结束伤害"] > 0 then
        _____7ED3_675F_56DE_8C03_5217_8868[#_____7ED3_675F_56DE_8C03_5217_8868 + 1] = ____exports["创建位移结束伤害回调"](_____9009_9879["结束伤害"], _____9009_9879["结束伤害来源"])
    end
    if _____9009_9879["结束控制"] ~= nil and _____9009_9879["结束控制时间"] ~= nil and _____9009_9879["结束控制时间"] > 0 then
        _____7ED3_675F_56DE_8C03_5217_8868[#_____7ED3_675F_56DE_8C03_5217_8868 + 1] = ____exports["创建位移结束控制回调"](_____9009_9879["结束控制"], _____9009_9879["结束控制时间"])
    end
    if #_____7ED3_675F_56DE_8C03_5217_8868 > 0 then
        _____7ED3_679C["结束回调"] = function(self, _____5355_4F4D, _____539F_56E0, ID)
            for ____, _____56DE_8C03 in ipairs(_____7ED3_675F_56DE_8C03_5217_8868) do
                _____56DE_8C03(_____5355_4F4D, _____539F_56E0, ID)
            end
        end
    end
    local _____547D_4E2D_56DE_8C03_5217_8868 = {}
    if _____9009_9879["命中特效"] then
        _____547D_4E2D_56DE_8C03_5217_8868[#_____547D_4E2D_56DE_8C03_5217_8868 + 1] = ____exports["创建命中特效回调"](_____9009_9879["命中特效"])
    end
    if _____9009_9879["命中控制"] ~= nil and _____9009_9879["命中控制时间"] ~= nil and _____9009_9879["命中控制时间"] > 0 then
        _____547D_4E2D_56DE_8C03_5217_8868[#_____547D_4E2D_56DE_8C03_5217_8868 + 1] = ____exports["创建命中控制回调"](_____9009_9879["命中控制"], _____9009_9879["命中控制时间"])
    end
    if #_____547D_4E2D_56DE_8C03_5217_8868 > 0 then
        _____7ED3_679C["命中回调"] = function(self, _____79FB_52A8_5355_4F4D, _____76EE_6807_5355_4F4D, ID)
            for ____, _____56DE_8C03 in ipairs(_____547D_4E2D_56DE_8C03_5217_8868) do
                _____56DE_8C03(_____79FB_52A8_5355_4F4D, _____76EE_6807_5355_4F4D, ID)
            end
        end
    end
    return _____7ED3_679C
end
return ____exports
