/** @noSelfInFile */

const common = require("jass.common") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, 玩家: any, 命令: string) => void) => void;
};
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, 玩家: any) => boolean;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, 表类型: string, 表键: any, 属性: string, 值类型: string) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};

const KillUnit = common.KillUnit as (this: void, 单位: any) => void;

const 测试命令 = "测试杀死水龙蛇";
const 模块名 = "被驱逐的水怪入口测试";

function on测试杀死水龙蛇(this: void, 玩家: any, _命令: string): void {
  if (!是允许测试玩家(玩家)) return;

  const 水龙蛇 = YDUserDataGetSafe("string", "Boss", "水龙蛇", "unit");
  if (水龙蛇 == null || 水龙蛇 === 0) {
    debugLogForce(模块名, "水龙蛇尚未完成初始注册，请等待地图 Boss 初始化后重试");
    return;
  }

  KillUnit(水龙蛇);
  debugLogForce(模块名, "已执行水龙蛇死亡，沃利尔斯应按正式死亡监听出现");
}

注册聊天命令监听(测试命令, on测试杀死水龙蛇);
