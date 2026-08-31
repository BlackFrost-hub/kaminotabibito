/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, 表名: string, 键: any, 属性名: string, 类型: string) => any;
  YDUserDataSetSafe: (this: void, 表名: string, 键: any, 属性名: string, 类型: string, 值: any) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const 书架提示文本 = "在书架处阅读了《远古精灵奥术》，魔法伤害+1%，魔法恢复+1/秒。";

function 处理奥术书架调查(this: void, _玩家ID: number, 施法单位: any, 调查点: any): boolean {
  void 调查点;
  const 当前恢复 = Number(YDUserDataGetSafe("unit", 施法单位, "魔法恢复", "real")) || 0;
  YDUserDataSetSafe("unit", 施法单位, "魔法恢复", "real", 当前恢复 + 1);
  const 玩家 = jass.GetOwningPlayer(施法单位);
  const 当前魔法伤害 = Number(YDUserDataGetSafe("player", 玩家, "魔法伤害", "real")) || 0;
  YDUserDataSetSafe("player", 玩家, "魔法伤害", "real", 当前魔法伤害 + 0.01);
  广播单位提示(施法单位, 书架提示文本, 3000);
  return true;
}

/** 注册精灵村的常驻环境互动探索点。 */
export function 注册精灵村探索点(this: void): void {
  注册环境互动调查点({
    ID: "精灵村.远古精灵奥术书架",
    X: 27751.7,
    Y: -27979.2,
    触发范围: 350,
    一次性: true,
    触发回调: 处理奥术书架调查,
  });
}

export {};
