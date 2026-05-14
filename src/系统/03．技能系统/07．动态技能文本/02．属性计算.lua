local ____lualib = require("lualib_bundle")
local __TS__StringReplace = ____lualib.__TS__StringReplace
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local ____exports = {}
--- 动态技能文本 - 属性计算
-- 
-- 根据属性类型获取英雄的属性值，并计算公式结果
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local GetHeroInt = jass.GetHeroInt
local GetHeroAgi = jass.GetHeroAgi
local GetHeroStr = jass.GetHeroStr
local UNIT_STATE_ATTACK = 21
local UNIT_STATE_MAX_LIFE = 21
local UNIT_STATE_LIFE = 35
local function _____83B7_53D6_653B_51FB_529B(unit)
    return GetUnitState(unit, UNIT_STATE_ATTACK)
end
local function _____83B7_53D6_6700_5927_751F_547D_503C(unit)
    return GetUnitState(unit, UNIT_STATE_MAX_LIFE)
end
local function _____83B7_53D6_5F53_524D_751F_547D_503C(unit)
    return GetUnitState(unit, UNIT_STATE_LIFE)
end
local function _____83B7_53D6_667A_529B(unit)
    return GetHeroInt(unit, true)
end
local function _____83B7_53D6_654F_6377(unit)
    return GetHeroAgi(unit, true)
end
local function _____83B7_53D6_529B_91CF(unit)
    return GetHeroStr(unit, true)
end
--- 根据属性类型获取英雄属性值
____exports["获取属性值"] = function(unit, _____5C5E_6027)
    repeat
        local ____switch9 = _____5C5E_6027
        local ____cond9 = ____switch9 == "攻击力"
        if ____cond9 then
            return _____83B7_53D6_653B_51FB_529B(unit)
        end
        ____cond9 = ____cond9 or ____switch9 == "最大生命值"
        if ____cond9 then
            return _____83B7_53D6_6700_5927_751F_547D_503C(unit)
        end
        ____cond9 = ____cond9 or ____switch9 == "当前生命值"
        if ____cond9 then
            return _____83B7_53D6_5F53_524D_751F_547D_503C(unit)
        end
        ____cond9 = ____cond9 or ____switch9 == "智力"
        if ____cond9 then
            return _____83B7_53D6_667A_529B(unit)
        end
        ____cond9 = ____cond9 or ____switch9 == "敏捷"
        if ____cond9 then
            return _____83B7_53D6_654F_6377(unit)
        end
        ____cond9 = ____cond9 or ____switch9 == "力量"
        if ____cond9 then
            return _____83B7_53D6_529B_91CF(unit)
        end
        do
            return 0
        end
    until true
end
--- 解析倍率字符串，例如 "3" -> 3, "50%" -> 0.5
____exports["解析倍率"] = function(_____500D_7387_5B57_7B26_4E32)
    if (string.find(_____500D_7387_5B57_7B26_4E32, "%", nil, true) or 0) - 1 >= 0 then
        local _____6570_503C = __TS__ParseFloat(__TS__StringReplace(_____500D_7387_5B57_7B26_4E32, "%", ""))
        return _____6570_503C / 100
    end
    return __TS__ParseFloat(_____500D_7387_5B57_7B26_4E32)
end
--- 计算公式结果：属性值 × 倍率
____exports["计算公式伤害"] = function(unit, _____5C5E_6027, _____500D_7387_5B57_7B26_4E32)
    local _____5C5E_6027_503C = ____exports["获取属性值"](unit, _____5C5E_6027)
    local _____500D_7387 = ____exports["解析倍率"](_____500D_7387_5B57_7B26_4E32)
    return _____5C5E_6027_503C * _____500D_7387
end
return ____exports
