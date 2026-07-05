--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 跳跃回调模板
-- 
-- 为跳跃/击飞系统提供可复用的回调工厂函数。
-- 配合 `跳跃系统.ts` 的 `开始回调`、`结束回调` 使用。
local jass = require("jass.common")
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setBuff = ____require_result_1.SFB_setBuff
____exports["创建跳跃开始特效回调"] = function(_____6A21_578B_8DEF_5F84)
    return function(_____5355_4F4D, ______8DF3_8DC3ID)
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
____exports["创建跳跃结束特效回调"] = function(_____6A21_578B_8DEF_5F84)
    return function(_____5355_4F4D, ______539F_56E0, ______8DF3_8DC3ID)
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
____exports["创建跳跃结束伤害回调"] = function(_____4F24_5BB3, _____6765_6E90, _____6807_8BB0)
    return function(_____5355_4F4D, _____539F_56E0, ______8DF3_8DC3ID)
        if _____539F_56E0 == "死亡" or _____539F_56E0 == "主单位死亡" then
            return
        end
        local ____6765_6E90_2 = _____6765_6E90
        if ____6765_6E90_2 == nil then
            ____6765_6E90_2 = _____5355_4F4D
        end
        local _____4F24_5BB3_6765_6E90 = ____6765_6E90_2
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = _____4F24_5BB3_6765_6E90,
            ["目标"] = _____5355_4F4D,
            ["伤害"] = _____4F24_5BB3,
            ["伤害类型"] = jass.DAMAGE_TYPE_NORMAL,
            ranged = false,
            attackType = jass.ATTACK_TYPE_NORMAL,
            weaponType = jass.WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = _____6807_8BB0 and _____6807_8BB0["来源类型"] or "单位技能",
            ["技能ID"] = _____6807_8BB0 and _____6807_8BB0["技能ID"],
            ["技能实例ID"] = _____6807_8BB0 and _____6807_8BB0["技能实例ID"],
            ["标签"] = _____6807_8BB0 and _____6807_8BB0["技能标签"],
            ["参与技能伤害加成"] = _____6807_8BB0 and _____6807_8BB0["参与技能伤害加成"]
        })
    end
end
____exports["创建跳跃结束控制回调"] = function(_____63A7_5236ID, _____6301_7EED_65F6_95F4)
    return function(_____5355_4F4D, _____539F_56E0, ______8DF3_8DC3ID)
        if _____539F_56E0 == "死亡" or _____539F_56E0 == "主单位死亡" then
            return
        end
        SFB_setBuff(_____5355_4F4D, _____5355_4F4D, _____63A7_5236ID, _____6301_7EED_65F6_95F4)
    end
end
____exports["创建跳跃回调"] = function(_____9009_9879)
    local _____7ED3_679C = {}
    if _____9009_9879["开始特效"] then
        _____7ED3_679C["开始回调"] = ____exports["创建跳跃开始特效回调"](_____9009_9879["开始特效"])
    end
    local _____7ED3_675F_56DE_8C03_5217_8868 = {}
    if _____9009_9879["结束特效"] then
        _____7ED3_675F_56DE_8C03_5217_8868[#_____7ED3_675F_56DE_8C03_5217_8868 + 1] = ____exports["创建跳跃结束特效回调"](_____9009_9879["结束特效"])
    end
    if _____9009_9879["结束伤害"] ~= nil and _____9009_9879["结束伤害"] > 0 then
        _____7ED3_675F_56DE_8C03_5217_8868[#_____7ED3_675F_56DE_8C03_5217_8868 + 1] = ____exports["创建跳跃结束伤害回调"](_____9009_9879["结束伤害"], _____9009_9879["结束伤害来源"], _____9009_9879["结束伤害标记"])
    end
    if _____9009_9879["结束控制"] ~= nil and _____9009_9879["结束控制时间"] ~= nil and _____9009_9879["结束控制时间"] > 0 then
        _____7ED3_675F_56DE_8C03_5217_8868[#_____7ED3_675F_56DE_8C03_5217_8868 + 1] = ____exports["创建跳跃结束控制回调"](_____9009_9879["结束控制"], _____9009_9879["结束控制时间"])
    end
    if #_____7ED3_675F_56DE_8C03_5217_8868 > 0 then
        _____7ED3_679C["结束回调"] = function(self, _____5355_4F4D, _____539F_56E0, _____8DF3_8DC3ID)
            for ____, _____56DE_8C03 in ipairs(_____7ED3_675F_56DE_8C03_5217_8868) do
                _____56DE_8C03(_____5355_4F4D, _____539F_56E0, _____8DF3_8DC3ID)
            end
        end
    end
    return _____7ED3_679C
end
return ____exports
