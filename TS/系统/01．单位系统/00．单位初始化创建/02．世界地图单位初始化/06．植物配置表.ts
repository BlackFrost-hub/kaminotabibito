/** @noSelfInFile */
/**
 * 自动生成文件，请勿手改。
 * 来源：JASS/世界地图/初始化创建单位.j/植物zw
 */

export interface 世界地图植物单位配置 {
  配置名: string;
  单位名: string;
  X: number;
  Y: number;
  朝向?: number | "随机";
  玩家ID?: number;
  YD表名?: string;
  YD键名?: string;
}

export interface 世界地图植物随机物品配置 {
  配置名: string;
  物品名: string;
  矩形变量名: string;
  创建数量: number;
}

export const 世界地图植物单位配置表: 世界地图植物单位配置[] = [
  {
    配置名: "聚灵花",
    单位名: "植物",
    X: -26501.9,
    Y: -16894.8,
    朝向: "随机",
    玩家ID: 15,
    YD表名: "植物",
    YD键名: "聚灵花",
  },
];

export const 世界地图植物随机物品配置表: 世界地图植物随机物品配置[] = [
  {
    配置名: "荧光草随机创建",
    物品名: "荧光草",
    矩形变量名: "gg_rct______________039",
    创建数量: 3,
  },
];

