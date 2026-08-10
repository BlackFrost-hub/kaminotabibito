/** @noSelfInFile */
/**
 * 自动生成文件，请勿手改。
 * 来源：JASS/世界地图/未命名触发器（中立生物：沙丘之虫随机创建）
 */

export interface 中立生物创建配置 {
  配置名: string;
  单位名: string;
  矩形区域名称: string;
  创建数量: number;
  玩家ID?: number;
  朝向?: number;
}

export const 世界地图中立生物配置表: 中立生物创建配置[] = [
  {
    配置名: "沙丘之虫随机创建",
    单位名: "ndwm",
    矩形区域名称: "沙漠区域.区域1",
    创建数量: 18,
    玩家ID: 15,
    朝向: 0.0,
  },
];

export default 世界地图中立生物配置表;
