/** @noSelfInFile */

const luaString: any = string;
const stringByte: any = luaString.byte;
const stringSub: any = luaString.sub;

function 获取Utf8字符字节数(this: void, 首字节: number): number {
  if (首字节 < 128) return 1;
  if (首字节 < 224) return 2;
  if (首字节 < 240) return 3;
  return 4;
}

function 估算特效字符宽度(this: void, 字符: string, 首字节: number, 字节数: number): number {
  if (字节数 === 1) {
    if (首字节 === 32) return 0.55;
    if (首字节 >= 48 && 首字节 <= 57) return 0.9;
    if ((首字节 >= 65 && 首字节 <= 90) || (首字节 >= 97 && 首字节 <= 122)) return 0.95;
    return 0.75;
  }
  if (字符 === "，" || 字符 === "。" || 字符 === "；" || 字符 === "：" || 字符 === "、") return 1.25;
  return 2;
}

export function 格式化奖励属性列(this: void, 文本: string, 列号: number, 每列最大行数: number): string {
  const 行列表 = 文本.split("\n");
  const 起始 = 列号 * 每列最大行数;
  const 结束 = 起始 + 每列最大行数;
  let 当前有效序号 = 0;
  let 结果 = "";
  for (let 序号 = 0; 序号 < 行列表.length; 序号++) {
    const 行 = 行列表[序号];
    if (行 === "") continue;
    if (当前有效序号 >= 起始 && 当前有效序号 < 结束) {
      if (结果 !== "") 结果 = 结果 + "\n";
      结果 = 结果 + "· " + 行;
    }
    当前有效序号++;
  }
  return 结果;
}

export function 按显示宽度换行(this: void, 文本: string, 每行最大宽度: number): string {
  let 结果 = "";
  let 当前行 = "";
  let 当前宽度 = 0;
  let 字节位置 = 1;
  while (字节位置 <= 文本.length) {
    const 首字节 = stringByte(文本, 字节位置) || 0;
    const 字节数 = 获取Utf8字符字节数(首字节);
    const 字符 = stringSub(文本, 字节位置, 字节位置 + 字节数 - 1);
    const 字符宽度 = 估算特效字符宽度(字符, 首字节, 字节数);
    if (当前行 !== "" && 当前宽度 + 字符宽度 > 每行最大宽度) {
      if (结果 !== "") 结果 = 结果 + "\n";
      结果 = 结果 + 当前行;
      当前行 = "";
      当前宽度 = 0;
    }
    当前行 = 当前行 + 字符;
    当前宽度 = 当前宽度 + 字符宽度;
    字节位置 = 字节位置 + 字节数;
  }
  if (当前行 !== "") {
    if (结果 !== "") 结果 = 结果 + "\n";
    结果 = 结果 + 当前行;
  }
  return 结果;
}

export function 格式化奖励特效列表(this: void, 文本: string): string {
  const 行列表 = 文本.split("\n");
  let 结果 = "";
  let 已写数量 = 0;
  for (let 序号 = 0; 序号 < 行列表.length; 序号++) {
    const 行 = 行列表[序号];
    if (行 === "") continue;
    if (结果 !== "") 结果 = 结果 + "\n";
    结果 = 结果 + 按显示宽度换行(行, 61);
    已写数量++;
    if (已写数量 >= 2) break;
  }
  return 结果;
}

