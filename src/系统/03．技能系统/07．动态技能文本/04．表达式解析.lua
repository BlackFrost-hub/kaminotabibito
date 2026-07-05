local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local ____exports = {}
local getVariableValue, parseExpr, parseTerm, parseFactor, GetUnitAbilityLevel, GetHeroLevel, _____5C5E_6027_540D_79F0_96C6_5408
local ____02_FF0E_5C5E_6027_8BA1_7B97 = require("系统.03．技能系统.07．动态技能文本.02．属性计算")
local _____83B7_53D6_5C5E_6027_503C = ____02_FF0E_5C5E_6027_8BA1_7B97["获取属性值"]
function getVariableValue(variable, unit, abilityId)
    if variable == "技能等级" or variable == "等级" then
        return GetUnitAbilityLevel(unit, abilityId)
    end
    if variable == "英雄等级" then
        return GetHeroLevel(unit)
    end
    if _____5C5E_6027_540D_79F0_96C6_5408:has(variable) then
        return _____83B7_53D6_5C5E_6027_503C(unit, variable)
    end
    return 0
end
function parseExpr(tokens, pos, unit, abilityId)
    local result = parseTerm(tokens, pos, unit, abilityId)
    while result.pos < #tokens and (tokens[result.pos + 1].value == "+" or tokens[result.pos + 1].value == "-") do
        local op = tokens[result.pos + 1].value
        result.pos = result.pos + 1
        local right = parseTerm(tokens, result.pos, unit, abilityId)
        result.pos = right.pos
        if op == "+" then
            result.value = result.value + right.value
        else
            result.value = result.value - right.value
        end
    end
    return result
end
function parseTerm(tokens, pos, unit, abilityId)
    local result = parseFactor(tokens, pos, unit, abilityId)
    while result.pos < #tokens and (tokens[result.pos + 1].value == "*" or tokens[result.pos + 1].value == "×" or tokens[result.pos + 1].value == "/" or tokens[result.pos + 1].value == "÷") do
        local op = tokens[result.pos + 1].value
        result.pos = result.pos + 1
        local right = parseFactor(tokens, result.pos, unit, abilityId)
        result.pos = right.pos
        if op == "*" or op == "×" then
            result.value = result.value * right.value
        else
            if right.value ~= 0 then
                result.value = result.value / right.value
            end
        end
    end
    return result
end
function parseFactor(tokens, pos, unit, abilityId)
    if pos >= #tokens then
        return {value = 0, pos = pos}
    end
    local token = tokens[pos + 1]
    if token.type == "number" then
        return {
            value = __TS__ParseFloat(token.value) or 0,
            pos = pos + 1
        }
    end
    if token.type == "variable" then
        local value = getVariableValue(token.value, unit, abilityId)
        if pos + 1 < #tokens and tokens[pos + 1 + 1].value == "%" then
            return {value = value / 100, pos = pos + 2}
        end
        return {value = value, pos = pos + 1}
    end
    if token.type == "operator" and token.value == "%" then
        return {value = 0, pos = pos + 1}
    end
    if token.type == "lparen" then
        local result = parseExpr(tokens, pos + 1, unit, abilityId)
        if result.pos < #tokens and tokens[result.pos + 1].type == "rparen" then
            result.pos = result.pos + 1
        end
        if result.pos < #tokens and tokens[result.pos + 1].value == "%" then
            result.value = result.value / 100
            result.pos = result.pos + 1
        end
        return result
    end
    if token.type == "operator" and token.value == "-" then
        local result = parseFactor(tokens, pos + 1, unit, abilityId)
        result.value = -result.value
        return result
    end
    return {value = 0, pos = pos + 1}
end
--- 动态技能文本 - 表达式解析器
-- 
-- 支持：
-- - 四则运算：+ - * × / ÷
-- - 百分比：30% -> 0.3
-- - 括号：( )
-- - 属性变量：攻击力、智力 等
-- - 游戏变量：技能等级、英雄等级、等级
local jass = require("jass.common")
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
GetHeroLevel = jass.GetHeroLevel
_____5C5E_6027_540D_79F0_96C6_5408 = __TS__New(Set, {
    "力量",
    "敏捷",
    "智力",
    "全属性",
    "攻击力",
    "生命值",
    "魔法值",
    "护甲",
    "攻速",
    "移动速度",
    "每秒攻速",
    "最大攻击力",
    "基础攻击力",
    "最大生命值",
    "基础生命值",
    "最大魔法值",
    "基础魔法值",
    "暴击率",
    "暴击伤害",
    "命中率",
    "闪避率",
    "魔抗",
    "被暴击率",
    "被暴击伤害",
    "护甲穿透",
    "魔法穿透",
    "技能伤害",
    "主动技能伤害",
    "独立技能伤害",
    "装备伤害",
    "攻击特效伤害",
    "普攻强化伤害",
    "物理伤害",
    "魔法伤害",
    "普攻伤害",
    "强化伤害",
    "魔法普攻伤害",
    "伤害%",
    "最终伤害%",
    "物理抗性",
    "技能抗性",
    "普攻抗性",
    "强化抗性",
    "生命恢复",
    "生命恢复%",
    "生命恢复效率",
    "百分比生命回复",
    "生命恢复属性增幅",
    "总生命恢复",
    "魔法恢复",
    "魔法恢复%",
    "百分比魔法回复",
    "总魔法恢复",
    "魔法消耗",
    "技能治疗率",
    "受到的治疗率",
    "伤害吸血",
    "魔法伤害吸血",
    "普攻伤害吸血",
    "伤害减少",
    "伤害减少%",
    "眩晕抗性",
    "冷却缩减",
    "召唤物伤害",
    "召唤物抗性",
    "金币获取率",
    "经验获取率",
    "光属性伤害",
    "暗属性伤害",
    "木属性伤害",
    "火属性伤害",
    "雷属性伤害",
    "水属性伤害",
    "土属性伤害",
    "光属性抗性",
    "暗属性抗性",
    "木属性抗性",
    "火属性抗性",
    "雷属性抗性",
    "水属性抗性",
    "土属性抗性",
    "蝼蚁专精"
})
--- 词法分析：把字符串拆分成token
local function tokenize(expr)
    local tokens = {}
    local i = 0
    while i < #expr do
        do
            local ch = __TS__StringCharAt(expr, i)
            if ch == " " or ch == "\t" then
                i = i + 1
                goto __continue3
            end
            if ch >= "0" and ch <= "9" or ch == "." then
                local num = ""
                while i < #expr do
                    local c = __TS__StringCharAt(expr, i)
                    if c >= "0" and c <= "9" or c == "." then
                        num = num .. c
                        i = i + 1
                    else
                        break
                    end
                end
                tokens[#tokens + 1] = {type = "number", value = num}
                goto __continue3
            end
            if ch == "+" or ch == "-" or ch == "*" or ch == "×" or ch == "/" or ch == "÷" or ch == "%" then
                tokens[#tokens + 1] = {type = "operator", value = ch}
                i = i + 1
                goto __continue3
            end
            if ch == "(" or ch == "（" then
                tokens[#tokens + 1] = {type = "lparen", value = "("}
                i = i + 1
                goto __continue3
            end
            if ch == ")" or ch == "）" then
                tokens[#tokens + 1] = {type = "rparen", value = ")"}
                i = i + 1
                goto __continue3
            end
            if ch >= "一" and ch <= "鿿" then
                local name = ""
                while i < #expr do
                    local c = __TS__StringCharAt(expr, i)
                    if c >= "一" and c <= "鿿" then
                        name = name .. c
                        i = i + 1
                    else
                        break
                    end
                end
                tokens[#tokens + 1] = {type = "variable", value = name}
                goto __continue3
            end
            i = i + 1
        end
        ::__continue3::
    end
    return tokens
end
--- 解析并计算表达式
-- 例如：(攻击力×30%×技能等级) -> 根据实际值计算
____exports["计算表达式"] = function(expr, unit, abilityId)
    local tokens = tokenize(expr)
    local result = parseExpr(tokens, 0, unit, abilityId)
    return result.value
end
return ____exports
