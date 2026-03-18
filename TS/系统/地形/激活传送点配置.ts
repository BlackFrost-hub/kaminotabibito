// 自动生成 - 激活传送点配置
export interface PointConfig {
  id: string;
  name: string;
  left: number;
  bottom: number;
  right: number;
  top: number;
  UnitID?: string;
  text?: string;
  reveal?: string;
  condition?: string;
  enabled: boolean;
}

export const 激活传送点配置: Record<string, PointConfig> = {
  "1": {
    id: "1",
    name: "111",
    left: 384,
    bottom: -288,
    right: 800,
    top: 192,
    UnitID: "gg_unit_htow_0030",
    text: "|cffffff00『系统提示』|r：激活了|cffff8080『精灵森』|r传送点。",
    reveal: "gg_rct______________002",
    enabled: true
  },
  "2": {
    id: "2",
    name: "精灵森",
    left: -25344,
    bottom: -19328,
    right: -24832,
    top: -18976,
    UnitID: "gg_unit_n025_0373",
    text: "|cffffff00『系统提示』|r：激活了|cffff8080『精灵森』|r传送点。",
    reveal: "gg_rct________________RYEMC",
    enabled: false
  },
  "3": {
    id: "3",
    name: "恶魔领地",
    left: 20896,
    bottom: -16224,
    right: 21280,
    top: -15744,
    UnitID: "gg_unit_ndrr_0005",
    text: "|cffffff00『系统提示』|r：激活『恶魔领地』传送点。",
    enabled: false
  },
  "4": {
    id: "4",
    name: "恶魔迷宫口",
    left: 22752,
    bottom: -8832,
    right: 23424,
    top: -8128,
    UnitID: "gg_unit_ndrr_0036",
    text: "|cffffff00『系统提示』|r：激活『恶魔迷宫口』传送点。",
    enabled: false
  },
  "5": {
    id: "5",
    name: "王之墓冢",
    left: 10144,
    bottom: -16352,
    right: 10720,
    top: -15808,
    UnitID: "gg_unit_ndrr_0069",
    text: "|cffffff00『系统提示』|r：激活『王之墓冢』传送点。",
    enabled: false
  }
};
export default 激活传送点配置;
