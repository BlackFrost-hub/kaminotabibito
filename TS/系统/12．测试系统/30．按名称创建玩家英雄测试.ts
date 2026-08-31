/** @noSelfInFile */

const globals = require("jass.globals") as {
  gg_unit_Hamg_0002?: any;
};
const jass = require("jass.common") as any;

const { 注册聊天命令前缀监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令前缀监听: (this: void, 前缀: string, 回调: (this: void, 玩家: any, 命令: string) => void) => void;
};
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, 玩家: any) => boolean;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, 名称: string) => string | undefined;
};
const { directRegisterPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  directRegisterPlayerHero: (this: void, 玩家: any, 英雄: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};

const 获取单位X = jass.GetUnitX as (单位: any) => number;
const 获取单位Y = jass.GetUnitY as (单位: any) => number;
const 获取单位面向 = jass.GetUnitFacing as (单位: any) => number;
const 创建单位 = jass.CreateUnit as (玩家: any, 单位类型ID: number, x: number, y: number, 面向: number) => any;
const 判断单位类型 = jass.IsUnitType as (单位: any, 单位类型: any) => boolean;
const 单位类型英雄 = jass.UNIT_TYPE_HERO as any;
const 单位类型死亡 = jass.UNIT_TYPE_DEAD as any;

const 模块名 = "按名称创建玩家英雄测试";
const 命令前缀 = "-";
const 二十至二十五英雄单位ID表: Record<string, boolean> = {
  E00C: true,
  E00G: true,
  E00H: true,
  E00I: true,
  E00J: true,
  E00K: true,
};

function on按名称创建玩家英雄(this: void, 玩家: any, 命令: string): void {
  if (!是允许测试玩家(玩家)) return;

  const 英雄名称 = 命令.substring(命令前缀.length).trim();
  if (英雄名称 === "") {
    debugLogForce(模块名, "命令缺少英雄名", "用法", "-英雄名");
    return;
  }

  const 英雄单位字符串 = 按名字反查玩家英雄单位ID(英雄名称);
  if (英雄单位字符串 == null || 二十至二十五英雄单位ID表[英雄单位字符串] !== true) {
    debugLogForce(模块名, "只支持20-25号英雄", 英雄名称);
    return;
  }

  const 英雄单位类型ID = stringToFourCCSafe(英雄单位字符串);
  if (英雄单位类型ID === 0) {
    debugLogForce(模块名, "英雄单位ID无效", 英雄名称, 英雄单位字符串);
    return;
  }

  const 大法师 = globals.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0 || 判断单位类型(大法师, 单位类型死亡) === true) {
    debugLogForce(模块名, "未找到可用的预设大法师位置", "gg_unit_Hamg_0002");
    return;
  }

  const 英雄 = 创建单位(
    玩家,
    英雄单位类型ID,
    获取单位X(大法师),
    获取单位Y(大法师),
    获取单位面向(大法师),
  );
  if (英雄 == null || 英雄 === 0 || 判断单位类型(英雄, 单位类型英雄) !== true) {
    debugLogForce(模块名, "创建玩家英雄失败", 英雄名称, 英雄单位字符串);
    return;
  }

  directRegisterPlayerHero(玩家, 英雄);
  debugLogForce(模块名, "已创建并注册玩家英雄", 英雄名称, "单位ID", 英雄单位字符串);
}

注册聊天命令前缀监听(命令前缀, on按名称创建玩家英雄);

export {};
