/**
 * 动态技能说明系统 - 公式解析器
 *
 * 提供安全的数学表达式解析和计算功能
 * 支持：+ - * / × ÷ ( ) 和数字
 */

const jass = require("jass.common") as any;
const { round } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  round: (value: number) => number;
};

// 导入常量
import {
  OPERATOR_MULTIPLY_CN,
  OPERATOR_DIVIDE_CN,
  OPERATOR_MULTIPLY_EN,
  OPERATOR_DIVIDE_EN,
  DECIMAL_MULTIPLIER,
} from "./00．常量定义";

// ==========================================================================================
// 字符串工具函数（替代正则表达式，tstl不支持正则）
// ==========================================================================================

/**
 * 移除字符串中的所有空格
 */
export function removeAllSpaces(s: string): string {
  let result = "";
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (c !== " " && c !== "\t" && c !== "\n" && c !== "\r") {
      result += c;
    }
  }
  return result;
}

/**
 * 检查字符是否为数字
 */
export function isDigit(c: string): boolean {
  return c >= "0" && c <= "9";
}

/**
 * 检查表达式是否只包含合法字符
 */
export function isValidExpression(expr: string): boolean {
  for (let i = 0; i < expr.length; i++) {
    const c = expr[i];
    if (!isDigit(c) && c !== "." && c !== "+" && c !== "-" &&
        c !== OPERATOR_MULTIPLY_EN && c !== OPERATOR_DIVIDE_EN &&
        c !== OPERATOR_MULTIPLY_CN && c !== OPERATOR_DIVIDE_CN &&
        c !== "(" && c !== ")") {
      return false;
    }
  }
  return true;
}

/**
 * 标准化表达式：将 × ÷ 转换为 * /
 */
export function normalizeExpression(expr: string): string {
  let result = "";
  for (let i = 0; i < expr.length; i++) {
    const c = expr[i];
    if (c === OPERATOR_MULTIPLY_CN) {
      result += OPERATOR_MULTIPLY_EN;
    } else if (c === OPERATOR_DIVIDE_CN) {
      result += OPERATOR_DIVIDE_EN;
    } else {
      result += c;
    }
  }
  return result;
}

/**
 * 全局替换字符串
 */
export function replaceAll(str: string, search: string, replace: string): string {
  let result = "";
  let i = 0;
  while (i < str.length) {
    if (str.substr(i, search.length) === search) {
      result += replace;
      i += search.length;
    } else {
      result += str[i];
      i++;
    }
  }
  return result;
}

/**
 * 查找字符在字符串中的位置
 */
export function indexOfChar(str: string, char: string, start: number = 0): number {
  for (let i = start; i < str.length; i++) {
    if (str[i] === char) return i;
  }
  return -1;
}

// ==========================================================================================
// 表达式解析器
// ==========================================================================================

/** 表达式解析器的当前位置 */
let parsePos = 0;
let parseExpr = "";

/**
 * 安全的数学表达式求值
 */
export function safeEval(expr: string): number {
  // 移除空格
  expr = removeAllSpaces(expr);

  // 标准化运算符
  expr = normalizeExpression(expr);

  // 验证表达式只包含合法字符
  if (!isValidExpression(expr)) {
    return 0;
  }

  // 使用递归下降解析器计算
  return parseExpression(expr);
}

/**
 * 解析表达式
 */
function parseExpression(expr: string): number {
  parsePos = 0;
  parseExpr = expr;
  return parseAddSub();
}

function parseNumber(): number {
  let start = parsePos;
  while (parsePos < parseExpr.length && (parseExpr[parsePos] === "." || isDigit(parseExpr[parsePos]))) {
    parsePos++;
  }
  const numStr = parseExpr.slice(start, parsePos);
  return parseFloat(numStr) || 0;
}

function parseFactor(): number {
  if (parsePos >= parseExpr.length) return 0;

  if (parseExpr[parsePos] === "(") {
    parsePos++;
    const result = parseTerm();
    if (parsePos < parseExpr.length && parseExpr[parsePos] === ")") parsePos++;
    return result;
  }
  if (parseExpr[parsePos] === "+" || parseExpr[parsePos] === "-") {
    const sign = parseExpr[parsePos] === "+" ? 1 : -1;
    parsePos++;
    return sign * parseFactor();
  }
  return parseNumber();
}

function parseTerm(): number {
  let result = parseFactor();
  while (parsePos < parseExpr.length && (parseExpr[parsePos] === OPERATOR_MULTIPLY_EN || parseExpr[parsePos] === OPERATOR_DIVIDE_EN)) {
    const op = parseExpr[parsePos];
    parsePos++;
    const right = parseFactor();
    result = op === OPERATOR_MULTIPLY_EN ? result * right : result / right;
  }
  return result;
}

function parseAddSub(): number {
  let result = parseTerm();
  while (parsePos < parseExpr.length && (parseExpr[parsePos] === "+" || parseExpr[parsePos] === "-")) {
    const op = parseExpr[parsePos];
    parsePos++;
    const right = parseTerm();
    result = op === "+" ? result + right : result - right;
  }
  return result;
}

/**
 * 格式化数字：整数不显示小数，浮点数最多2位
 */
export function formatNumber(value: number): string {
  if (!isFinite(value)) return "0";
  const intValue = jass.R2I(value);
  if (intValue === value) {
    return intValue.toString();
  }
  const rounded = round(value * DECIMAL_MULTIPLIER) / DECIMAL_MULTIPLIER;
  const intRounded = jass.R2I(rounded);
  if (intRounded === rounded) {
    return intRounded.toString();
  }
  return rounded.toString();
}

export {};
