/** @noSelfInFile */

export interface 升级属性加成配置 {
  属性名: string;
  数值类型: "integer" | "real";
  应用属性名: string;
}

export interface 物品升级规则 {
  装备名: string;
  物品类型ID: number;
  处理升级?: (this: void, 单位: any) => void;
  处理拾取?: (this: void, 单位: any) => void;
}

export {};
