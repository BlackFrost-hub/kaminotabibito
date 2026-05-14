/** @noSelfInFile */
/**
 * 聊天命令事件中心
 *
 * 功能：监听玩家聊天消息，支持注册特定命令的回调
 */

const jass = require("jass.common") as any;

type 聊天命令回调 = (this: void, player: any, command: string) => void;

const 创建触发器 = jass.CreateTrigger as () => any;
const 添加触发动作 = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const 注册玩家聊天事件 = jass.TriggerRegisterPlayerChatEvent as (
  trig: any,
  whichPlayer: any,
  chatMessageToDetect: string,
  exactMatchOnly: boolean
) => void;
const 获取触发玩家 = jass.GetTriggerPlayer as () => any;
const 获取聊天字符串 = jass.GetEventPlayerChatString as () => string;
const 获取玩家对象 = jass.Player as (index: number) => any;

const 命令监听器 = new Map<string, 聊天命令回调[]>();
let 已初始化 = false;

function 玩家聊天(this: void): void {
  const player = 获取触发玩家();
  if (player == null || player === 0) return;

  const chatString = 获取聊天字符串();
  if (chatString == null || chatString === "") return;

  const listeners = 命令监听器.get(chatString);
  if (listeners != null) {
    for (let i = 0; i < listeners.length; i++) {
      const callback = listeners[i];
      if (callback != null) callback(player, chatString);
    }
  }
}

function 初始化聊天事件中心(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  const trig = 创建触发器();
  添加触发动作(trig, 玩家聊天);

  for (let i = 0; i <= 15; i++) {
    注册玩家聊天事件(trig, 获取玩家对象(i), "", false);
  }
}

/**
 * 注册聊天命令监听。
 * 第一次使用时会自动初始化事件中心。
 */
export function 注册聊天命令监听(this: void, 命令: string, 回调: 聊天命令回调): void {
  if (回调 == null) return;
  if (命令 === "") return;

  初始化聊天事件中心();

  let list = 命令监听器.get(命令);
  if (list == null) {
    list = [];
    命令监听器.set(命令, list);
  }

  for (let i = 0; i < list.length; i++) {
    if (list[i] === 回调) return;
  }

  list.push(回调);
}

/**
 * 取消聊天命令监听。
 */
export function 取消聊天命令监听(this: void, 命令: string, 回调: 聊天命令回调): void {
  const list = 命令监听器.get(命令);
  if (list == null) return;

  const index = list.indexOf(回调);
  if (index >= 0) list.splice(index, 1);
}

export {};
