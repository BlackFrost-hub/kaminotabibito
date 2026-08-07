/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册动态矩形区域, 注销动态矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  注册动态矩形区域: (this: void, 配置: {
    键: string;
    左: number;
    右: number;
    下: number;
    上: number;
    说明?: string;
  }) => any;
  注销动态矩形区域: (this: void, 键: string) => boolean;
};
const { SetStackedSoundBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  SetStackedSoundBJ: (this: void, add: boolean, soundHandle: any, rectHandle: any) => void;
};

const GetWorldBounds = jass.GetWorldBounds as (this: void) => any;
const GetRectMinX = jass.GetRectMinX as (this: void, rectHandle: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (this: void, rectHandle: any) => number;
const GetRectMinY = jass.GetRectMinY as (this: void, rectHandle: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (this: void, rectHandle: any) => number;
const CreateSound = jass.CreateSound as (
  this: void,
  fileName: string,
  looping: boolean,
  is3D: boolean,
  stopWhenOutOfRange: boolean,
  fadeInRate: number,
  fadeOutRate: number,
  eaxSetting: string,
) => any;
const StartSound = jass.StartSound as (this: void, soundHandle: any) => void;
const StopSound = jass.StopSound as (this: void, soundHandle: any, killWhenDone: boolean, fadeOut: boolean) => void;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  player: any,
  x: number,
  y: number,
  duration: number,
  text: string,
) => void;

const 模块名 = "全图动态BGM测试";
const 测试命令 = "全图BGM测试";
const 清理命令 = "全图BGM清理";
const 动态矩形键 = "测试.全图动态BGM";
const 测试音乐路径 = "Sound\\BGM\\Scene\\SealCore\\Ryo Kondo - Abode of the Ancient Gods.mp3";

let 测试矩形: any = null;
let 测试音频: any = null;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 清理全图BGM(this: void): boolean {
  const 有状态 = 句柄有效(测试矩形) || 句柄有效(测试音频);
  if (句柄有效(测试音频) && 句柄有效(测试矩形)) {
    SetStackedSoundBJ(false, 测试音频, 测试矩形);
  }
  if (句柄有效(测试音频)) {
    StopSound(测试音频, true, false);
  }
  const 注销成功 = 注销动态矩形区域(动态矩形键);
  测试矩形 = null;
  测试音频 = null;
  if (有状态 || 注销成功) {
    debugLogForce(模块名, "已清理", "动态矩形键", 动态矩形键, "注销成功", 注销成功);
  }
  return 有状态 || 注销成功;
}

function 开始全图BGM(this: void, player: any): void {
  if (!是允许测试玩家(player)) return;

  清理全图BGM();
  const 世界边界 = GetWorldBounds();
  if (!句柄有效(世界边界)) {
    debugLogForce(模块名, "创建失败", "原因=GetWorldBounds返回空句柄");
    DisplayTimedTextToPlayer(player, 0, 0, 6, "[全图BGM测试] 创建失败：无法取得地图边界。");
    return;
  }

  const 左 = GetRectMinX(世界边界);
  const 右 = GetRectMaxX(世界边界);
  const 下 = GetRectMinY(世界边界);
  const 上 = GetRectMaxY(世界边界);
  测试矩形 = 注册动态矩形区域({
    键: 动态矩形键,
    左,
    右,
    下,
    上,
    说明: "测试用当前地图全图动态矩形",
  });
  if (!句柄有效(测试矩形)) {
    debugLogForce(模块名, "创建失败", "原因=动态矩形创建失败", "左", 左, "右", 右, "下", 下, "上", 上);
    DisplayTimedTextToPlayer(player, 0, 0, 6, "[全图BGM测试] 创建失败：动态矩形无效。");
    return;
  }

  // 使用与旧 JASS BGM 一致的 2D、可循环参数，排除 3D 距离裁剪影响。
  测试音频 = CreateSound(测试音乐路径, true, false, false, 10, 10, "DefaultEAXON");
  if (!句柄有效(测试音频)) {
    注销动态矩形区域(动态矩形键);
    测试矩形 = null;
    debugLogForce(模块名, "创建失败", "原因=CreateSound返回空句柄", "音乐路径", 测试音乐路径);
    DisplayTimedTextToPlayer(player, 0, 0, 6, "[全图BGM测试] 创建失败：音频句柄无效。");
    return;
  }

  SetStackedSoundBJ(true, 测试音频, 测试矩形);
  StartSound(测试音频);
  debugLogForce(
    模块名,
    "创建并播放成功",
    "动态矩形键",
    动态矩形键,
    "左",
    左,
    "右",
    右,
    "下",
    下,
    "上",
    上,
    "音乐路径",
    测试音乐路径,
  );
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[全图BGM测试] 已创建全图动态矩形并播放测试音乐。输入“全图BGM清理”结束测试。");
}

function 执行清理命令(this: void, player: any, _command: string): void {
  if (!是允许测试玩家(player)) return;
  const 清理成功 = 清理全图BGM();
  DisplayTimedTextToPlayer(player, 0, 0, 6, 清理成功 ? "[全图BGM测试] 已清理测试矩形和音频。" : "[全图BGM测试] 当前没有需要清理的测试对象。");
}

注册聊天命令监听(测试命令, 开始全图BGM);
注册聊天命令监听(清理命令, 执行清理命令);
debugLogForce(模块名, "已注册命令", 测试命令, 清理命令);

export {};
