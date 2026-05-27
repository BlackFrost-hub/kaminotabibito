local ____lualib = require("lualib_bundle")
local __TS__StringReplace = ____lualib.__TS__StringReplace
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local ____exports = {}
--- 动态技能文本 - 属性计算
-- 
-- 这里只保留当前动态文本白名单实际会用到的属性读取。
local jass = require("jass.common")
local japi = require("jass.japi")
local GetHeroStr = jass.GetHeroStr
local GetHeroAgi = jass.GetHeroAgi
local GetHeroInt = jass.GetHeroInt
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
--- 根据属性类型获取英雄属性值。
____exports["获取属性值"] = function(unit, _____5C5E_6027)
    repeat
        local ____switch3 = _____5C5E_6027
        local ____cond3 = ____switch3 == "力量"
        if ____cond3 then
            return GetHeroStr(unit, true)
        end
        ____cond3 = ____cond3 or ____switch3 == "敏捷"
        if ____cond3 then
            return GetHeroAgi(unit, true)
        end
        ____cond3 = ____cond3 or ____switch3 == "智力"
        if ____cond3 then
            return GetHeroInt(unit, true)
        end
        ____cond3 = ____cond3 or ____switch3 == "攻击力"
        if ____cond3 then
            return GetUnitStateJapi(
                unit,
                ConvertUnitState(21)
            )
        end
        ____cond3 = ____cond3 or ____switch3 == "当前生命值"
        if ____cond3 then
            return GetUnitState(unit, jass.UNIT_STATE_LIFE)
        end
        ____cond3 = ____cond3 or ____switch3 == "生命值"
        if ____cond3 then
            return GetUnitState(unit, jass.UNIT_STATE_LIFE)
        end
        ____cond3 = ____cond3 or ____switch3 == "最大生命值"
        if ____cond3 then
            return GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE)
        end
        ____cond3 = ____cond3 or ____switch3 == "当前魔法值"
        if ____cond3 then
            return GetUnitState(unit, jass.UNIT_STATE_MANA)
        end
        ____cond3 = ____cond3 or ____switch3 == "魔法值"
        if ____cond3 then
            return GetUnitState(unit, jass.UNIT_STATE_MANA)
        end
        ____cond3 = ____cond3 or ____switch3 == "最大魔法值"
        if ____cond3 then
            return GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA)
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
