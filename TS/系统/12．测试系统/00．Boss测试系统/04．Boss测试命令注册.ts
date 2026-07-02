/** @noSelfInFile */

import type { Boss测试注册配置 } from "./00．Boss测试类型";

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};

const jass = require("jass.common") as any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;

function 发送Boss测试提示(this: void, player: any, Boss名称: string, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[" + Boss名称 + "测试] " + text);
}

function 生成命令说明(this: void, 配置: Boss测试注册配置): string {
  let text = "";
  const list = 配置.技能命令列表;
  for (let i = 0; i < list.length; i++) {
    text = text + " " + list[i].序号.toString() + list[i].名称;
  }
  return 配置.命令前缀 + text + "。";
}

export function 注册Boss测试命令组(this: void, 配置: Boss测试注册配置): void {
  注册聊天命令监听(配置.命令前缀, function Boss测试主命令(this: void, player: any): void {
    const context = 配置.创建或获取上下文(player);
    if (context == null) return;
    发送Boss测试提示(player, 配置.Boss名称, "已创建/复用测试场景。" + 生成命令说明(配置));
  });

  const list = 配置.技能命令列表;
  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    注册聊天命令监听(配置.命令前缀 + item.序号.toString(), function Boss测试技能命令(this: void, player: any): void {
      const context = 配置.创建或获取上下文(player);
      if (context == null) return;
      item.执行(player, context);
      发送Boss测试提示(player, 配置.Boss名称, "已测试：" + item.名称 + "。");
    });
  }
}
