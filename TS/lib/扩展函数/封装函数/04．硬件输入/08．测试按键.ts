/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 测试按键（B键广播9999）
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
import { KEY } from "./01．常量定义";
import { isKeyDown, registerKeyEventRawStatus } from "./04．键盘函数";

// -------------------- 测试：B 键广播 9999 --------------------

function initTestKeyB(): void {
  if (typeof (jass as any).DisplayTimedTextToPlayer !== "function" || typeof (jass as any).Player !== "function") return;

  /**
   * 去抖 / 只在"松开"触发一次：
   *
   * 平台环境里键盘事件（DzTriggerRegisterKeyEventByCode）存在以下实测特性：
   * - 必须 `sync=false` 才会触发回调（sync=true 不触发）
   * - `status` 参数在 Lua/ByCode 这条链上不严格（0/1/2 都可能触发；甚至按住会重复派发）
   *
   * 因此不能指望只靠 status 区分按下/抬起。
   * 这里改用 DzIsKeyDown(keyCode) 做"边沿检测"：
   * - last=true 且 down=false 时，判定为"从按下→松开"，只触发一次。
   */
  const lastDownByPid: boolean[] = [];
  const getPid = typeof (jass as any).GetPlayerId === "function" ? (jass as any).GetPlayerId : null;

  // 监听任意键盘事件（status=0/1/2 全都注册），只在 "按下->松开" 边沿广播 9999
  const hook = (st: number) => {
    registerKeyEventRawStatus(KEY.B, st, false, () => {
      const p = typeof japi.DzGetTriggerKeyPlayer === "function" ? japi.DzGetTriggerKeyPlayer() : null;
      const pid = getPid && p ? getPid(p) : 0;
      const down = isKeyDown(KEY.B);
      const last = !!lastDownByPid[pid];
      lastDownByPid[pid] = down;
      if (last && !down) {
        for (let i = 0; i < 12; i++) {
          (jass as any).DisplayTimedTextToPlayer((jass as any).Player(i), 0, 0, 3, "9999");
        }
        if (typeof (jass as any).GetPlayerName === "function" && p) {
          (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 3, "from=" + (jass as any).GetPlayerName(p));
        }
      }
    });
  };

  hook(0);
  hook(1);
  hook(2);
  // 初始化为"未按下"，避免第一次事件误触发
  for (let i = 0; i < 12; i++) lastDownByPid[i] = false;
}

initTestKeyB();
