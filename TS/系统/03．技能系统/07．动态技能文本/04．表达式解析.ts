/** @noSelfInFile */
/**
 * 动态技能文本 - 表达式解析器
 *
 * 支持：
 * - 四则运算：+ - * × / ÷
 * - 百分比：30% -> 0.3
 * - 括号：( )
 * - 属性变量：攻击力、智力 等
 * - 游戏变量：技能等级、英雄等级、等级
 */

const jass = require("jass.common") as any;

const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilcode: number) => number;
const GetHeroLevel = jass.GetHeroLevel as (hero: any) => number;

import { 获取属性值 } from "./02．属性计算";
import type { 属性类型 } from "./01．公式配置";

type Token = {
  type: "number" | "operator" | "lparen" | "rparen" | "variable";
  value: string;
};

const 属性名称集合 = new Set<string>([
  "力量", "敏捷", "智力", "全属性",
  "攻击力", "生命值", "魔法值", "护甲", "攻速", "移动速度", "每秒攻速",
  "最大攻击力", "基础攻击力", "最大生命值", "基础生命值", "最大魔法值", "基础魔法值",
  "暴击率", "暴击伤害", "命中率", "闪避率", "魔抗",
  "被暴击率", "被暴击伤害",
  "护甲穿透", "魔法穿透",
  "技能伤害", "主动技能伤害", "独立技能伤害", "装备伤害", "攻击特效伤害", "普攻强化伤害", "物理伤害", "魔法伤害", "普攻伤害", "强化伤害", "魔法普攻伤害",
  "伤害%", "最终伤害%",
  "物理抗性", "技能抗性", "普攻抗性", "强化抗性",
  "生命恢复", "生命恢复%", "生命恢复效率", "百分比生命回复", "生命恢复属性增幅", "总生命恢复",
  "魔法恢复", "魔法恢复%", "百分比魔法回复", "总魔法恢复", "魔法消耗",
  "技能治疗率", "受到的治疗率",
  "伤害吸血", "魔法伤害吸血", "普攻伤害吸血",
  "伤害减少", "伤害减少%",
  "眩晕抗性", "冷却缩减",
  "召唤物伤害", "召唤物抗性",
  "金币获取率", "经验获取率",
  "光属性伤害", "暗属性伤害", "木属性伤害", "火属性伤害", "雷属性伤害", "水属性伤害", "土属性伤害",
  "光属性抗性", "暗属性抗性", "木属性抗性", "火属性抗性", "雷属性抗性", "水属性抗性", "土属性抗性",
  "蝼蚁专精",
]);

/**
 * 词法分析：把字符串拆分成token
 */
function tokenize(expr: string): Token[] {
  const tokens: Token[] = [];
  let i = 0;

  while (i < expr.length) {
    const ch = expr.charAt(i);

    // 跳过空白
    if (ch === " " || ch === "\t") {
      i++;
      continue;
    }

    // 数字
    if ((ch >= "0" && ch <= "9") || ch === ".") {
      let num = "";
      while (i < expr.length) {
        const c = expr.charAt(i);
        if ((c >= "0" && c <= "9") || c === ".") {
          num += c;
          i++;
        } else {
          break;
        }
      }
      tokens.push({ type: "number", value: num });
      continue;
    }

    // 运算符
    if (ch === "+" || ch === "-" || ch === "*" || ch === "×" || ch === "/" || ch === "÷" || ch === "%") {
      tokens.push({ type: "operator", value: ch });
      i++;
      continue;
    }

    // 括号
    if (ch === "(" || ch === "（") {
      tokens.push({ type: "lparen", value: "(" });
      i++;
      continue;
    }
    if (ch === ")" || ch === "）") {
      tokens.push({ type: "rparen", value: ")" });
      i++;
      continue;
    }

    // 变量名（中文）
    if (ch >= "\u4e00" && ch <= "\u9fff") {
      let name = "";
      while (i < expr.length) {
        const c = expr.charAt(i);
        if (c >= "\u4e00" && c <= "\u9fff") {
          name += c;
          i++;
        } else {
          break;
        }
      }
      tokens.push({ type: "variable", value: name });
      continue;
    }

    i++;
  }

  return tokens;
}

/**
 * 获取变量的值
 */
function getVariableValue(
  this: void,
  variable: string,
  unit: any,
  abilityId: number
): number {
  // 游戏变量
  if (variable === "技能等级" || variable === "等级") {
    return GetUnitAbilityLevel(unit, abilityId);
  }
  if (variable === "英雄等级") {
    return GetHeroLevel(unit);
  }

  // 属性变量
  if (属性名称集合.has(variable)) {
    return 获取属性值(unit, variable as 属性类型);
  }

  return 0;
}

/**
 * 简单的递归下降表达式解析器
 *
 * 语法：
 *   expr   = term (('+' | '-') term)*
 *   term   = factor (('*' | '×' | '/' | '÷') factor)*
 *   factor = number | variable | '%' | '(' expr ')' | '-' factor
 */

type ParseResult = {
  value: number;
  pos: number;
};

function parseExpr(
  this: void,
  tokens: Token[],
  pos: number,
  unit: any,
  abilityId: number
): ParseResult {
  let result = parseTerm(tokens, pos, unit, abilityId);

  while (
    result.pos < tokens.length &&
    (tokens[result.pos].value === "+" || tokens[result.pos].value === "-")
  ) {
    const op = tokens[result.pos].value;
    result.pos++;
    const right = parseTerm(tokens, result.pos, unit, abilityId);
    result.pos = right.pos;
    if (op === "+") {
      result.value = result.value + right.value;
    } else {
      result.value = result.value - right.value;
    }
  }

  return result;
}

function parseTerm(
  this: void,
  tokens: Token[],
  pos: number,
  unit: any,
  abilityId: number
): ParseResult {
  let result = parseFactor(tokens, pos, unit, abilityId);

  while (
    result.pos < tokens.length &&
    (tokens[result.pos].value === "*" ||
      tokens[result.pos].value === "×" ||
      tokens[result.pos].value === "/" ||
      tokens[result.pos].value === "÷")
  ) {
    const op = tokens[result.pos].value;
    result.pos++;
    const right = parseFactor(tokens, result.pos, unit, abilityId);
    result.pos = right.pos;
    if (op === "*" || op === "×") {
      result.value = result.value * right.value;
    } else {
      if (right.value !== 0) {
        result.value = result.value / right.value;
      }
    }
  }

  return result;
}

function parseFactor(
  this: void,
  tokens: Token[],
  pos: number,
  unit: any,
  abilityId: number
): ParseResult {
  if (pos >= tokens.length) {
    return { value: 0, pos };
  }

  const token = tokens[pos];

  // 数字
  if (token.type === "number") {
    return { value: parseFloat(token.value) || 0, pos: pos + 1 };
  }

  // 变量
  if (token.type === "variable") {
    const value = getVariableValue(token.value, unit, abilityId);
    // 检查下一个token是否是%，如果是则转换为小数
    if (pos + 1 < tokens.length && tokens[pos + 1].value === "%") {
      return { value: value / 100, pos: pos + 2 };
    }
    return { value, pos: pos + 1 };
  }

  // 百分比符号（单独出现）
  if (token.type === "operator" && token.value === "%") {
    return { value: 0, pos: pos + 1 };
  }

  // 左括号
  if (token.type === "lparen") {
    const result = parseExpr(tokens, pos + 1, unit, abilityId);
    if (result.pos < tokens.length && tokens[result.pos].type === "rparen") {
      result.pos++;
    }
    // 检查括号后是否跟%
    if (result.pos < tokens.length && tokens[result.pos].value === "%") {
      result.value = result.value / 100;
      result.pos++;
    }
    return result;
  }

  // 负号
  if (token.type === "operator" && token.value === "-") {
    const result = parseFactor(tokens, pos + 1, unit, abilityId);
    result.value = -result.value;
    return result;
  }

  return { value: 0, pos: pos + 1 };
}

/**
 * 解析并计算表达式
 * 例如：(攻击力×30%×技能等级) -> 根据实际值计算
 */
export function 计算表达式(
  this: void,
  expr: string,
  unit: any,
  abilityId: number
): number {
  const tokens = tokenize(expr);
  const result = parseExpr(tokens, 0, unit, abilityId);
  return result.value;
}
