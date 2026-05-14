local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__StringReplace = ____lualib.__TS__StringReplace
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local ____exports = {}
--- 动态技能文本 - 属性计算
-- 
-- 根据属性类型获取英雄的属性值，并计算公式结果
-- 属性通过 YDUserDataGet2 从玩家数据表中读取
local jass = require("jass.common")
local GetHeroStr = jass.GetHeroStr
local GetHeroAgi = jass.GetHeroAgi
local GetHeroInt = jass.GetHeroInt
local GetUnitState = jass.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet2 = ____require_result_0.YDUserDataGet2
local function _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, _____5C5E_6027_540D)
    local owner = jass.GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGet2(
        nil,
        "player",
        owner,
        _____5C5E_6027_540D,
        "real"
    )) or 0
end
--- 根据属性类型获取英雄属性值
____exports["获取属性值"] = function(unit, _____5C5E_6027)
    repeat
        local ____switch5 = _____5C5E_6027
        local ____cond5 = ____switch5 == "力量"
        if ____cond5 then
            return GetHeroStr(unit, true)
        end
        ____cond5 = ____cond5 or ____switch5 == "敏捷"
        if ____cond5 then
            return GetHeroAgi(unit, true)
        end
        ____cond5 = ____cond5 or ____switch5 == "智力"
        if ____cond5 then
            return GetHeroInt(unit, true)
        end
        ____cond5 = ____cond5 or ____switch5 == "全属性"
        if ____cond5 then
            return GetHeroStr(unit, true) + GetHeroAgi(unit, true) + GetHeroInt(unit, true)
        end
        ____cond5 = ____cond5 or ____switch5 == "攻击力"
        if ____cond5 then
            return GetUnitState(
                unit,
                ConvertUnitState(18)
            ) + GetUnitState(
                unit,
                ConvertUnitState(32)
            )
        end
        ____cond5 = ____cond5 or ____switch5 == "最大攻击力"
        if ____cond5 then
            return GetUnitState(
                unit,
                ConvertUnitState(18)
            ) + GetUnitState(
                unit,
                ConvertUnitState(32)
            )
        end
        ____cond5 = ____cond5 or ____switch5 == "基础攻击力"
        if ____cond5 then
            return GetUnitState(
                unit,
                ConvertUnitState(18)
            )
        end
        ____cond5 = ____cond5 or ____switch5 == "生命值"
        if ____cond5 then
            return GetUnitState(unit, 42)
        end
        ____cond5 = ____cond5 or ____switch5 == "最大生命值"
        if ____cond5 then
            return GetUnitState(unit, 42)
        end
        ____cond5 = ____cond5 or ____switch5 == "基础生命值"
        if ____cond5 then
            return GetUnitState(unit, 42) - _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "生命值")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔法值"
        if ____cond5 then
            return GetUnitState(unit, 44)
        end
        ____cond5 = ____cond5 or ____switch5 == "最大魔法值"
        if ____cond5 then
            return GetUnitState(unit, 44)
        end
        ____cond5 = ____cond5 or ____switch5 == "基础魔法值"
        if ____cond5 then
            return GetUnitState(unit, 44) - _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔法值")
        end
        ____cond5 = ____cond5 or ____switch5 == "护甲"
        if ____cond5 then
            return GetUnitState(
                unit,
                ConvertUnitState(32)
            )
        end
        ____cond5 = ____cond5 or ____switch5 == "攻速"
        if ____cond5 then
            return GetUnitState(
                unit,
                ConvertUnitState(81)
            )
        end
        ____cond5 = ____cond5 or ____switch5 == "移动速度"
        if ____cond5 then
            return GetUnitState(
                unit,
                ConvertUnitState(82)
            )
        end
        ____cond5 = ____cond5 or ____switch5 == "每秒攻速"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "每秒攻速")
        end
        ____cond5 = ____cond5 or ____switch5 == "暴击率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "暴击率")
        end
        ____cond5 = ____cond5 or ____switch5 == "暴击伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "暴击伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "命中率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "命中率")
        end
        ____cond5 = ____cond5 or ____switch5 == "闪避率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "闪避率")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔抗"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔抗")
        end
        ____cond5 = ____cond5 or ____switch5 == "被暴击率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "被暴击率")
        end
        ____cond5 = ____cond5 or ____switch5 == "被暴击伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "被暴击伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "护甲穿透"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "护甲穿透")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔法穿透"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔法穿透")
        end
        ____cond5 = ____cond5 or ____switch5 == "技能伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "技能伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "物理伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "物理伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔法伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔法伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "普攻伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "普攻伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "强化伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "强化伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔法普攻伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔法普攻伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "伤害%"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "伤害%")
        end
        ____cond5 = ____cond5 or ____switch5 == "最终伤害%"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "最终伤害%")
        end
        ____cond5 = ____cond5 or ____switch5 == "物理抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "物理抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "技能抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "技能抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "普攻抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "普攻抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "强化抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "强化抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "生命恢复"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "生命恢复")
        end
        ____cond5 = ____cond5 or ____switch5 == "生命恢复%"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "生命恢复%")
        end
        ____cond5 = ____cond5 or ____switch5 == "生命恢复效率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "生命恢复效率")
        end
        ____cond5 = ____cond5 or ____switch5 == "百分比生命回复"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "百分比生命回复")
        end
        ____cond5 = ____cond5 or ____switch5 == "生命恢复属性增幅"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "生命恢复属性增幅")
        end
        ____cond5 = ____cond5 or ____switch5 == "总生命恢复"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "总生命恢复")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔法恢复"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔法恢复")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔法恢复%"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔法恢复%")
        end
        ____cond5 = ____cond5 or ____switch5 == "百分比魔法回复"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "百分比魔法回复")
        end
        ____cond5 = ____cond5 or ____switch5 == "总魔法恢复"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "总魔法恢复")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔法消耗"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔法消耗")
        end
        ____cond5 = ____cond5 or ____switch5 == "技能治疗率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "技能治疗率")
        end
        ____cond5 = ____cond5 or ____switch5 == "受到的治疗率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "受到的治疗率")
        end
        ____cond5 = ____cond5 or ____switch5 == "伤害吸血"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "伤害吸血")
        end
        ____cond5 = ____cond5 or ____switch5 == "魔法伤害吸血"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "魔法伤害吸血")
        end
        ____cond5 = ____cond5 or ____switch5 == "普攻伤害吸血"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "普攻伤害吸血")
        end
        ____cond5 = ____cond5 or ____switch5 == "伤害减少"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "伤害减少")
        end
        ____cond5 = ____cond5 or ____switch5 == "伤害减少%"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "伤害减少%")
        end
        ____cond5 = ____cond5 or ____switch5 == "眩晕抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "眩晕抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "冷却缩减"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "冷却缩减")
        end
        ____cond5 = ____cond5 or ____switch5 == "召唤物伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "召唤物伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "召唤物抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "召唤物抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "金币获取率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "金币获取率")
        end
        ____cond5 = ____cond5 or ____switch5 == "经验获取率"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "经验获取率")
        end
        ____cond5 = ____cond5 or ____switch5 == "光属性伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "光属性伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "暗属性伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "暗属性伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "木属性伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "木属性伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "火属性伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "火属性伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "雷属性伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "雷属性伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "水属性伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "水属性伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "土属性伤害"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "土属性伤害")
        end
        ____cond5 = ____cond5 or ____switch5 == "光属性抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "光属性抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "暗属性抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "暗属性抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "木属性抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "木属性抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "火属性抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "火属性抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "雷属性抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "雷属性抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "水属性抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "水属性抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "土属性抗性"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "土属性抗性")
        end
        ____cond5 = ____cond5 or ____switch5 == "蝼蚁专精"
        if ____cond5 then
            return _____83B7_53D6_73A9_5BB6_5C5E_6027(unit, "蝼蚁专精")
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
