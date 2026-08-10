/** @noSelfInFile */

const jglobals = require("jass.globals") as Record<string, any>;
const { 读取地图预设矩形区域配置 } = require("系统.07．地形系统.09．动态矩形区域注册表.03．地图预设矩形区域配置表") as {
  读取地图预设矩形区域配置: (this: void, 名称: string) => {
    地图矩形变量名?: string;
    矩形区域名称列表?: string[];
  } | undefined;
};
const 动态矩形区域 = require("系统.07．地形系统.09．动态矩形区域注册表.02．动态矩形区域动作") as {
  获取动态矩形区域: (this: void, 键: string) => any;
  按配置键注册动态矩形区域: (this: void, 键: string) => any;
};

const 获取动态矩形区域 = 动态矩形区域.获取动态矩形区域;
const 按配置键注册动态矩形区域 = 动态矩形区域.按配置键注册动态矩形区域;

/** 通过语义名称读取地图预置矩形；兼容直接传入旧 gg_rct 变量名。 */
export function 获取地图预设矩形区域(this: void, 名称或变量名: string): any {
  if (名称或变量名 == null || 名称或变量名 === "") return null;
  const 配置 = 读取地图预设矩形区域配置(名称或变量名);
  const 变量名 = 配置 != null ? 配置.地图矩形变量名 : 名称或变量名;
  if (变量名 == null || 变量名 === "") return null;
  return jglobals[变量名] || null;
}

/** 地图预置矩形优先；没有预置定义时读取或创建已有动态矩形配置。 */
export function 获取矩形区域(this: void, 名称: string): any {
  const 地图矩形 = 获取地图预设矩形区域(名称);
  if (地图矩形 != null && 地图矩形 !== 0) return 地图矩形;
  return 获取动态矩形区域(名称) || 按配置键注册动态矩形区域(名称);
}

function 追加矩形区域(this: void, 名称: string, 结果: any[], 已展开组合: Record<string, boolean>): void {
  if (名称 == null || 名称 === "") return;
  const 配置 = 读取地图预设矩形区域配置(名称);
  if (配置 != null && 配置.矩形区域名称列表 != null) {
    if (已展开组合[名称]) return;
    已展开组合[名称] = true;
    for (let i = 0; i < 配置.矩形区域名称列表.length; i++) {
      追加矩形区域(配置.矩形区域名称列表[i], 结果, 已展开组合);
    }
    return;
  }
  const 矩形 = 获取矩形区域(名称);
  if (矩形 != null && 矩形 !== 0) 结果.push(矩形);
}

export function 获取矩形区域列表(this: void, 名称列表: string[]): any[] {
  const 结果: any[] = [];
  const 已展开组合: Record<string, boolean> = {};
  for (let i = 0; i < 名称列表.length; i++) {
    追加矩形区域(名称列表[i], 结果, 已展开组合);
  }
  return 结果;
}
