/** @noSelfInFile */
/**
 * 镜头高度控制
 *
 * 主键盘和数字小键盘的 +/- 每次调整触发玩家镜头距离 200。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const KEY_STATE = { UP: 1 } as const;

const 镜头高度步长 = 200;
const 默认镜头高度 = 3000;
const Boss测试镜头高度 = 默认镜头高度;
const 主键盘加号键 = 187;
const 主键盘减号键 = 189;
const 数字小键盘加号键 = 107;
const 数字小键盘减号键 = 109;

const CAMERA_FIELD_TARGET_DISTANCE = jass.CAMERA_FIELD_TARGET_DISTANCE;
const { SetCameraFieldForPlayer } = require("lib.扩展函数.BJ函数.07．杂项") as {
  SetCameraFieldForPlayer: (this: void, player: any, field: any, value: number, duration: number) => void;
};
const DzGetTriggerKeyPlayer = japi.DzGetTriggerKeyPlayer as (this: void) => any;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 玩家镜头步数: Record<number, number> = {};

let 已初始化 = false;

export function 按步长调整本地镜头高度(this: void, 步数: number): void {
  const 玩家 = DzGetTriggerKeyPlayer();
  if (玩家 == null || 玩家 === 0) return;
  const 玩家ID = jass.GetPlayerId(玩家) as number;
  const 新步数 = (玩家镜头步数[玩家ID] ?? 0) + 步数;
  玩家镜头步数[玩家ID] = 新步数;
  const 新高度 = 默认镜头高度 + 新步数 * 镜头高度步长;
  SetCameraFieldForPlayer(玩家, CAMERA_FIELD_TARGET_DISTANCE, 新高度, 0);
  debugLogForce("镜头高度控制", "按键回调成功", "playerId", 玩家ID, "step", 步数, "zOffset", 新高度);
}

/** 只调整指定玩家的本地镜头，避免传送时影响其他玩家。 */
export function 按步长调整玩家镜头高度(this: void, 玩家: any, 步数: number): void {
  if (玩家 == null || 玩家 === 0) return;
  const 玩家ID = jass.GetPlayerId(玩家) as number;
  const 新步数 = (玩家镜头步数[玩家ID] ?? 0) + 步数;
  玩家镜头步数[玩家ID] = 新步数;
  SetCameraFieldForPlayer(玩家, CAMERA_FIELD_TARGET_DISTANCE, 默认镜头高度 + 新步数 * 镜头高度步长, 0);
}

function 抬高镜头(this: any): void {
  按步长调整本地镜头高度(1);
}

function 降低镜头(this: any): void {
  按步长调整本地镜头高度(-1);
}

/** Boss 测试场景使用，每次都固定设置为默认镜头高度以上 400。 */
export function 抬高Boss测试镜头(this: void): void {
  const 玩家 = DzGetTriggerKeyPlayer();
  if (玩家 == null || 玩家 === 0) return;
  const 玩家ID = jass.GetPlayerId(玩家) as number;
  玩家镜头步数[玩家ID] = 0;
  SetCameraFieldForPlayer(玩家, CAMERA_FIELD_TARGET_DISTANCE, Boss测试镜头高度, 0);
}

export function init(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  const trigger = jass.CreateTrigger();
  japi.DzTriggerRegisterKeyEvent(trigger, 主键盘加号键, KEY_STATE.UP, true, null);
  japi.DzTriggerRegisterKeyEvent(trigger, 数字小键盘加号键, KEY_STATE.UP, true, null);
  japi.DzTriggerRegisterKeyEvent(trigger, 主键盘减号键, KEY_STATE.UP, true, null);
  japi.DzTriggerRegisterKeyEvent(trigger, 数字小键盘减号键, KEY_STATE.UP, true, null);
  jass.TriggerAddAction(trigger, function(this: void): void {
    const key = japi.DzGetTriggerKey() as number;
    debugLogForce("镜头高度控制", "键盘触发", "key", key);
    if (key === 主键盘加号键 || key === 数字小键盘加号键) 抬高镜头();
    if (key === 主键盘减号键 || key === 数字小键盘减号键) 降低镜头();
  });
}
