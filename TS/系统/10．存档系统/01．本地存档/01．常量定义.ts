/** @noSelfInFile */
/**
 * 本地存档系统常量
 *
 * 存档文件写入玩家本机魔兽运行目录下的相对路径：
 * `syzl\prelocal_config.sav`
 *
 * 当前本地存档采用 ASCII 配置项。不要把中文 key 写进文件，
 * Preload 文件生成链路不保证 UTF-8 中文稳定。
 * 文件路径按魔兽根目录相对路径生成：
 * dir + `\pre` + file + `.sav`
 *
 * 注意：当前底层按 `存档3.j` 的 `SetPlayerTechMaxAllowed(Player(14/15), key, value)`
 * 格式写入 preload 文件，不再是纯文本 `DzSaveMemoryCache("...")` 文件。
 *
 * 示例：
 * `chouhen=true;dongtai=true;lengque=true;lanhao=true;chouhenjian=V;shoucejian=K;xianshijian=J`
 */

export const 本地存档目录 = "syzl";
export const 本地存档文件 = "local_config";
export const 本地存档版本 = 1;

export const 本地存档字段数量 = 64;

export const 本地存档字段 = {
  版本号: 1,

  动态技能文本开关: 10,
  仇恨漂浮文字开关: 11,
  QWERD冷却显示开关: 12,
  QWERD蓝耗显示开关: 13,

  仇恨面板热键: 30,
  游戏说明手册热键: 31,
  QWERD显示面板热键: 32,
} as const;

export const 本地存档默认值 = {
  [本地存档字段.版本号]: 本地存档版本,

  [本地存档字段.动态技能文本开关]: 1,
  [本地存档字段.仇恨漂浮文字开关]: 1,
  [本地存档字段.QWERD冷却显示开关]: 1,
  [本地存档字段.QWERD蓝耗显示开关]: 1,

  [本地存档字段.仇恨面板热键]: 86,
  [本地存档字段.游戏说明手册热键]: 75,
  [本地存档字段.QWERD显示面板热键]: 74,
} as Record<number, number>;
