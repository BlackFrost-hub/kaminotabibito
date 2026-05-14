/** @noSelfInFile */

/**
 * 平台扩展 API 中文包装 - 取值。
 */

type 玩家句柄 = any;
type 单位句柄 = any;
type 物品句柄 = any;
type 控件句柄 = any;
type 特效句柄 = any;
type 触发器句柄 = any;
type 点句柄 = any;
type 单位组句柄 = any;
type 技能句柄 = any;
type 代理句柄 = any;
type 漂浮字句柄 = any;
type 玩家组句柄 = any;
type 布尔表达式句柄 = any;
type 按钮句柄 = any;
type 对话框句柄 = any;
type 计时器对话框句柄 = any;
type 追踪物句柄 = any;
type 排行榜句柄 = any;
type 多面板句柄 = any;
type 多面板项句柄 = any;
type 区域句柄 = any;
type 矩形句柄 = any;
type 闪电句柄 = any;
type 音效句柄 = any;
type 可破坏物句柄 = any;

type 原生表 = Record<string, any>;
const 平台原生表 = require("jass.japi") as 原生表;
const 原生函数表 = 平台原生表 as Record<string, (...参数: any[]) => any>;

export function 地图_评论次数(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_CommentCount"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_地图评论次数(this: void): number {
  return (原生函数表["DzAPI_Map_CommentTotalCount"] as () => number)();
}

export function 地图_玩家在地图自定义排行榜上的排名(this: void, 玩家: 玩家句柄, ID: number): number {
  return (原生函数表["DzAPI_Map_CommentTotalCount1"] as (玩家: 玩家句柄, ID: number) => number)(玩家, ID);
}

export function 地图_玩家签到天数(this: void, 玩家: 玩家句柄, ID: number): number {
  return (原生函数表["DzAPI_Map_ContinuousCount"] as (玩家: 玩家句柄, ID: number) => number)(玩家, ID);
}

export function 地图_自定义排行榜上榜人数(this: void, ID: number): number {
  return (原生函数表["DzAPI_Map_CustomRankCount"] as (ID: number) => number)(ID);
}

export function 地图_自定义排行榜上的玩家昵称(this: void, ID: number, 排名: number): string {
  return (原生函数表["DzAPI_Map_CustomRankPlayerName"] as (ID: number, 排名: number) => string)(ID, 排名);
}

export function 地图_自定义排行榜上的玩家数值(this: void, ID: number, 排名: number): number {
  return (原生函数表["DzAPI_Map_CustomRankValue"] as (ID: number, 排名: number) => number)(ID, 排名);
}

export function 地图_玩家好友数量(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_FriendCount"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_取活动数据(this: void): string {
  return (原生函数表["DzAPI_Map_GetActivityData"] as () => string)();
}

export function 地图_玩家在地图社区上的互动数据(this: void, 玩家: 玩家句柄, 数据项: number): number {
  return (原生函数表["DzAPI_Map_GetForumData"] as (玩家: 玩家句柄, 数据项: number) => number)(玩家, 数据项);
}

export function 地图_本局游戏的开始时间(this: void): number {
  return (原生函数表["DzAPI_Map_GetGameStartTime"] as () => number)();
}

export function 地图_玩家在公会的职责(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetGuildRole"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_玩家天梯等级(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetLadderLevel"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_玩家天梯排名(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetLadderRank"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_玩家抽取地图宝箱总次数(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetLotteryUsedCount"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_玩家抽取指定地图宝箱次数(this: void, 玩家: 玩家句柄, 序号: number): number {
  return (原生函数表["DzAPI_Map_GetLotteryUsedCountEx"] as (玩家: 玩家句柄, 序号: number) => number)(玩家, 序号);
}

export function 地图_玩家地图商城道具剩余数量(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["DzAPI_Map_GetMallItemCount"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 地图_地图配置参数(this: void, 键名: string): string {
  return (原生函数表["DzAPI_Map_GetMapConfig"] as (键名: string) => string)(键名);
}

export function 地图_玩家地图等级(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetMapLevel"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_玩家在地图等级排行榜上的排名(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetMapLevelRank"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_本局游戏的地图模式(this: void): number {
  return (原生函数表["DzAPI_Map_GetMatchType"] as () => number)();
}

export function 地图_取平台贵宾(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetPlatformVIP"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_玩家在KK对战平台的完整昵称(this: void, 玩家: 玩家句柄): string {
  return (原生函数表["DzAPI_Map_GetPlayerUserName"] as (玩家: 玩家句柄) => string)(玩家);
}

export function 地图_取服务器存档组(this: void, 玩家: 玩家句柄, 键名: string): string {
  return (原生函数表["DzAPI_Map_GetPublicArchive"] as (玩家: 玩家句柄, 键名: string) => string)(玩家, 键名);
}

export function 地图_BOSS击杀后的掉落内容(this: void, 玩家: 玩家句柄, 键名: string): string {
  return (原生函数表["DzAPI_Map_GetServerArchiveDrop"] as (玩家: 玩家句柄, 键名: string) => string)(玩家, 键名);
}

export function 地图_BOSS击杀后的掉落数量(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["DzAPI_Map_GetServerArchiveEquip"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 地图_取服务器存储的数据(this: void, 玩家: 玩家句柄, 键名: string): string {
  return (原生函数表["DzAPI_Map_GetServerValue"] as (玩家: 玩家句柄, 键名: string) => string)(玩家, 键名);
}

export function 地图_取服务器值错误码(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetServerValueErrorCode"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_玩家本局游戏距上一局游戏的时间差(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_GetSinceLastPlayedSeconds"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_取服务器存储的技能类型(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["DzAPI_Map_GetStoredAbilityId"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 地图_取服务器上的整数变量(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["DzAPI_Map_GetStoredInteger"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 地图_取服务器存储的整数(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["DzAPI_Map_GetStoredIntegerEX"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 地图_取服务器上的实数变量(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["DzAPI_Map_GetStoredReal"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 地图_取服务器上的字符串变量(this: void, 玩家: 玩家句柄, 键名: string): string {
  return (原生函数表["DzAPI_Map_GetStoredString"] as (玩家: 玩家句柄, 键名: string) => string)(玩家, 键名);
}

export function 地图_取服务器存储的字符串(this: void, 玩家: 玩家句柄, 键名: string): string {
  return (原生函数表["DzAPI_Map_GetStoredStringEX"] as (玩家: 玩家句柄, 键名: string) => string)(玩家, 键名);
}

export function 地图_取服务器存储的单位类型(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["DzAPI_Map_GetStoredUnitType"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 地图_读取全局存档(this: void, 键名: string): string {
  return (原生函数表["DzAPI_Map_Global_GetStoreString"] as (键名: string) => string)(键名);
}

export function 地图_玩家在指定地图累计消耗平台金币(this: void, 玩家: 玩家句柄, 地图ID: number): number {
  return (原生函数表["DzAPI_Map_MapsConsumeGold"] as (玩家: 玩家句柄, 地图ID: number) => number)(玩家, 地图ID);
}

export function 地图_玩家在指定地图的平台木材消耗(this: void, 玩家: 玩家句柄, 地图ID: number): number {
  return (原生函数表["DzAPI_Map_MapsConsumeLumber"] as (玩家: 玩家句柄, 地图ID: number) => number)(玩家, 地图ID);
}

export function 地图_玩家在指定地图的地图等级(this: void, 玩家: 玩家句柄, 地图ID: number): number {
  return (原生函数表["DzAPI_Map_MapsLevel"] as (玩家: 玩家句柄, 地图ID: number) => number)(玩家, 地图ID);
}

export function 地图_玩家累计游戏时长(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_MapsTotalPlayed"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_玩家累计游戏局数(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["DzAPI_Map_PlayedGames"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 地图_取服务器存档(this: void, 玩家: 玩家句柄, 键名: string): string {
  return (原生函数表["DzAPI_Map_ServerArchive"] as (玩家: 玩家句柄, 键名: string) => string)(玩家, 键名);
}

export function 建造_异步获取当前正在建造的技能编号(this: void): number {
  return (原生函数表["DzAsyncGetCurrentBuildingAbilityId"] as () => number)();
}

export function 建造_异步获取当前正在建造的单位编号(this: void): number {
  return (原生函数表["DzAsyncGetCurrentBuildingUnitId"] as () => number)();
}

export function 按位与(this: void, 值A: number, 值B: number): number {
  return (原生函数表["DzBitAnd"] as (值A: number, 值B: number) => number)(值A, 值B);
}

export function 整数的2进制的位值(this: void, 整数值: number, 字节序号: number): number {
  return (原生函数表["DzBitGet"] as (整数值: number, 字节序号: number) => number)(整数值, 字节序号);
}

export function 整数的256进制的位值(this: void, 整数值: number, 字节序号: number): number {
  return (原生函数表["DzBitGetByte"] as (整数值: number, 字节序号: number) => number)(整数值, 字节序号);
}

export function 按位取反(this: void, 整数值: number): number {
  return (原生函数表["DzBitNot"] as (整数值: number) => number)(整数值);
}

export function 按位或(this: void, 值A: number, 值B: number): number {
  return (原生函数表["DzBitOr"] as (值A: number, 值B: number) => number)(值A, 值B);
}

export function 按位左移(this: void, 整数值: number, 移位位数: number): number {
  return (原生函数表["DzBitShiftLeft"] as (整数值: number, 移位位数: number) => number)(整数值, 移位位数);
}

export function 按位右移(this: void, 整数值: number, 移位位数: number): number {
  return (原生函数表["DzBitShiftRight"] as (整数值: number, 移位位数: number) => number)(整数值, 移位位数);
}

export function 四字节组合为整数(this: void, 字节1: number, 字节2: number, 字节3: number, 字节4: number): number {
  return (原生函数表["DzBitToInt"] as (字节1: number, 字节2: number, 字节3: number, 字节4: number) => number)(字节1, 字节2, 字节3, 字节4);
}

export function 按位异或(this: void, 值A: number, 值B: number): number {
  return (原生函数表["DzBitXor"] as (值A: number, 值B: number) => number)(值A, 值B);
}

export function 转换屏幕坐标到世界x坐标(this: void, x: number, y: number): number {
  return (原生函数表["DzConvertScreenPositionX"] as (x: number, y: number) => number)(x, y);
}

export function 转换屏幕坐标到世界y坐标(this: void, x: number, y: number): number {
  return (原生函数表["DzConvertScreenPositionY"] as (x: number, y: number) => number)(x, y);
}

export function 转化_目标允许字符串转整数(this: void, 目标类型: string): number {
  return (原生函数表["DzConvertStr2Targs"] as (目标类型: string) => number)(目标类型);
}

export function 转化_目标允许整数转字符串(this: void, 目标类型: number): string {
  return (原生函数表["DzConvertTargs2Str"] as (目标类型: number) => string)(目标类型);
}

export function 装饰物_新建地形装饰物(this: void, ID: number, 变体: number, x: number, y: number, z: number, 旋转角度: number, 缩放: number): number {
  return (原生函数表["DzDoodadCreate"] as (ID: number, 变体: number, x: number, y: number, z: number, 旋转角度: number, 缩放: number) => number)(ID, 变体, x, y, z, 旋转角度, 缩放);
}

export function 装饰物_装饰物动画数量(this: void, 装饰物: number): number {
  return (原生函数表["DzDoodadGetAnimationCount"] as (装饰物: number) => number)(装饰物);
}

export function 装饰物_装饰物动画名(this: void, 装饰物: number, 序号: number): string {
  return (原生函数表["DzDoodadGetAnimationName"] as (装饰物: number, 序号: number) => string)(装饰物, 序号);
}

export function 装饰物_装饰物动画时间(this: void, 装饰物: number, 序号: number): number {
  return (原生函数表["DzDoodadGetAnimationTime"] as (装饰物: number, 序号: number) => number)(装饰物, 序号);
}

export function 装饰物_装饰物当前动画编号(this: void, 装饰物: number): number {
  return (原生函数表["DzDoodadGetCurrentAnimationIndex"] as (装饰物: number) => number)(装饰物);
}

export function 装饰物_装饰物动画播放速度(this: void, 装饰物: number): number {
  return (原生函数表["DzDoodadGetTimeScale"] as (装饰物: number) => number)(装饰物);
}

export function 装饰物_装饰物的类型编号(this: void, 装饰物: number): number {
  return (原生函数表["DzDoodadGetTypeId"] as (装饰物: number) => number)(装饰物);
}

export function 装饰物_装饰物的横坐标坐标(this: void, 装饰物: number): number {
  return (原生函数表["DzDoodadGetX"] as (装饰物: number) => number)(装饰物);
}

export function 装饰物_装饰物的纵坐标坐标(this: void, 装饰物: number): number {
  return (原生函数表["DzDoodadGetY"] as (装饰物: number) => number)(装饰物);
}

export function 装饰物_装饰物的高度坐标(this: void, 装饰物: number): number {
  return (原生函数表["DzDoodadGetZ"] as (装饰物: number) => number)(装饰物);
}

export function 界面_添加模型(this: void, 父级界面: number): number {
  return (原生函数表["DzFrameAddModel"] as (父级界面: number) => number)(父级界面);
}

export function 界面_添加模型特效(this: void, 模型界面: number, 附着点: string, 模型路径: string): number {
  return (原生函数表["DzFrameAddModelEffect"] as (模型界面: number, 附着点: string, 模型路径: string) => number)(模型界面, 附着点, 模型路径);
}

export function 界面_原生_获取聊天输入栏控件(this: void): number {
  return (原生函数表["DzFrameGetChatEditBar"] as () => number)();
}

export function 界面_取子控件(this: void, 界面: number, 序号: number): number {
  return (原生函数表["DzFrameGetChild"] as (界面: number, 序号: number) => number)(界面, 序号);
}

export function 界面_取子控件数量(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetChildrenCount"] as (界面: number) => number)(界面);
}

export function 界面_取命令条按钮(this: void, 行: number, 列: number): number {
  return (原生函数表["DzFrameGetCommandBarButton"] as (行: number, 列: number) => number)(行, 列);
}

export function 界面_取技能自动施法指示器(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetCommandBarButtonAutoCastIndicator"] as (界面: number) => number)(界面);
}

export function 界面_取技能冷却指示器(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetCommandBarButtonCooldownIndicator"] as (界面: number) => number)(界面);
}

export function 界面_取技能右下角数字文本框体(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetCommandBarButtonNumberOverlay"] as (界面: number) => number)(界面);
}

export function 界面_取技能右下角数字文本控件(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetCommandBarButtonNumberText"] as (界面: number) => number)(界面);
}

export function 界面_获取控件绑定的整数(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetContext"] as (界面: number) => number)(界面);
}

export function 界面_取BUFF控件(this: void, 序号: number): number {
  return (原生函数表["DzFrameGetInfoPanelBuffButton"] as (序号: number) => number)(序号);
}

export function 界面_取框选控件(this: void, 序号: number): number {
  return (原生函数表["DzFrameGetInfoPanelSelectButton"] as (序号: number) => number)(序号);
}

export function 界面_获取低于控制台的底层Frame(this: void): number {
  return (原生函数表["DzFrameGetLowerLevelFrame"] as () => number)();
}

export function 界面_取模型颜色(this: void, 模型界面: number): number {
  return (原生函数表["DzFrameGetModelColor"] as (模型界面: number) => number)(模型界面);
}

export function 界面_取模型大小(this: void, 模型界面: number): number {
  return (原生函数表["DzFrameGetModelSize"] as (模型界面: number) => number)(模型界面);
}

export function 界面_取模型速度(this: void, 模型界面: number): number {
  return (原生函数表["DzFrameGetModelSpeed"] as (模型界面: number) => number)(模型界面);
}

export function 界面_取模型横坐标(this: void, 模型界面: number): number {
  return (原生函数表["DzFrameGetModelX"] as (模型界面: number) => number)(模型界面);
}

export function 界面_取模型纵坐标(this: void, 模型界面: number): number {
  return (原生函数表["DzFrameGetModelY"] as (模型界面: number) => number)(模型界面);
}

export function 界面_取模型高度(this: void, 模型界面: number): number {
  return (原生函数表["DzFrameGetModelZ"] as (模型界面: number) => number)(模型界面);
}

export function 界面_获取鼠标控件(this: void): number {
  return (原生函数表["DzFrameGetMouse"] as () => number)();
}

export function 界面_获取控件的全局名字(this: void, 界面: number): string {
  return (原生函数表["DzFrameGetName"] as (界面: number) => string)(界面);
}

export function 界面_取农民控件(this: void): number {
  return (原生函数表["DzFrameGetPeonBar"] as () => number)();
}

export function 界面_取相对锚点所在界面(this: void, 界面: number, 锚点: number): number {
  return (原生函数表["DzFrameGetPointRelative"] as (界面: number, 锚点: number) => number)(界面, 锚点);
}

export function 界面_取相对锚点的界面锚点(this: void, 界面: number, 锚点: number): number {
  return (原生函数表["DzFrameGetPointRelativePoint"] as (界面: number, 锚点: number) => number)(界面, 锚点);
}

export function 界面_取锚点横坐标坐标(this: void, 界面: number, 锚点: number): number {
  return (原生函数表["DzFrameGetPointX"] as (界面: number, 锚点: number) => number)(界面, 锚点);
}

export function 界面_取锚点纵坐标坐标(this: void, 界面: number, 锚点: number): number {
  return (原生函数表["DzFrameGetPointY"] as (界面: number, 锚点: number) => number)(界面, 锚点);
}

export function 界面_获取控件实际高度(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetRealHeight"] as (界面: number) => number)(界面);
}

export function 界面_获取控件实际宽度(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetRealWidth"] as (界面: number) => number)(界面);
}

export function 界面_触发的血条(this: void): number {
  return (原生函数表["DzFrameGetTriggerHpBar"] as () => number)();
}

export function 界面_触发血条的单位(this: void): 单位句柄 {
  return (原生函数表["DzFrameGetTriggerHpBarUnit"] as () => 单位句柄)();
}

export function 界面_取单位血条(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzFrameGetUnitHpBar"] as (单位: 单位句柄) => number)(单位);
}

export function 界面_取宽度(this: void, 界面: number): number {
  return (原生函数表["DzFrameGetWidth"] as (界面: number) => number)(界面);
}

export function 界面_游戏提示信息界面(this: void): number {
  return (原生函数表["DzFrameGetWorldFrameMessage"] as () => number)();
}

export function 界面_转换地图坐标为小地图x坐标(this: void, x: number, y: number): number {
  return (原生函数表["DzFrameWorldToMinimapPosX"] as (x: number, y: number) => number)(x, y);
}

export function 界面_转换地图坐标为小地图y坐标(this: void, x: number, y: number): number {
  return (原生函数表["DzFrameWorldToMinimapPosY"] as (x: number, y: number) => number)(x, y);
}

export function 取商店目标(this: void, 商店: 单位句柄, 玩家: 玩家句柄): 单位句柄 {
  return (原生函数表["DzGetActivePatron"] as (商店: 单位句柄, 玩家: 玩家句柄) => 单位句柄)(商店, 玩家);
}

export function 取普攻技能(this: void, 单位: 单位句柄): 技能句柄 {
  return (原生函数表["DzGetAttackAbility"] as (单位: 单位句柄) => 技能句柄)(单位);
}

export function 取当前缓存模型的数量(this: void): number {
  return (原生函数表["DzGetCacheModelCount"] as () => number)();
}

export function 鼠标界面(this: void): number {
  return (原生函数表["DzGetCursorFrame"] as () => number)();
}

export function 装饰物_获取当前地形装饰物数量(this: void): number {
  return (原生函数表["DzGetDoodadsCount"] as () => number)();
}

export function 取特效透明度(this: void, 特效: 特效句柄): number {
  return (原生函数表["DzGetEffectVertexAlpha"] as (特效: 特效句柄) => number)(特效);
}

export function 取特效颜色(this: void, 特效: 特效句柄): number {
  return (原生函数表["DzGetEffectVertexColor"] as (特效: 特效句柄) => number)(特效);
}

export function 取帧率帧数(this: void): number {
  return (原生函数表["DzGetFPS"] as () => number)();
}

export function 取游戏界面(this: void): number {
  return (原生函数表["DzGetGameUI"] as () => number)();
}

export function 界面_获取游戏外界面底层(this: void): number {
  return (原生函数表["DzGetGlueUI"] as () => number)();
}

export function 英雄_获取主属性(this: void, 单位: 单位句柄, 布尔2: boolean): number {
  return (原生函数表["DzGetHeroPrimaryAttribute"] as (单位: 单位句柄, 布尔2: boolean) => number)(单位, 布尔2);
}

export function 取英雄主属性附加(this: void, 单位: 单位句柄, 属性: number): number {
  return (原生函数表["DzGetHeroPrimaryAttributePlus"] as (单位: 单位句柄, 属性: number) => number)(单位, 属性);
}

export function 英雄_获取主属性类型(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetHeroPrimaryAttributeType"] as (单位: 单位句柄) => number)(单位);
}

export function 取物品技能(this: void, 特效: 物品句柄, 序号: number): 技能句柄 {
  return (原生函数表["DzGetItemAbility"] as (特效: 物品句柄, 序号: number) => 技能句柄)(特效, 序号);
}

export function 物品_获取物品的碰撞体积(this: void, 物品: 物品句柄): number {
  return (原生函数表["DzGetItemCollisionSize"] as (物品: 物品句柄) => number)(物品);
}

export function 取字符串数量(this: void): number {
  return (原生函数表["DzGetJassStringTableCount"] as () => number)();
}

export function 物品_当前选择的物品异步(this: void): 物品句柄 {
  return (原生函数表["DzGetLastSelectedItem"] as () => 物品句柄)();
}

export function 玩家_获取本地玩家的聊天频道(this: void): number {
  return (原生函数表["DzGetLocalChatRecipient"] as () => number)();
}

export function 取玩家选中的单位(this: void, 序号: number): 单位句柄 {
  return (原生函数表["DzGetLocalSelectUnit"] as (序号: number) => 单位句柄)(序号);
}

export function 取玩家选中的单位数量(this: void): number {
  return (原生函数表["DzGetLocalSelectUnitCount"] as () => number)();
}

export function 取预建造对象(this: void): 控件句柄 {
  return (原生函数表["DzGetOnBuildAgent"] as () => 控件句柄)();
}

export function 取建造的命令编号(this: void): number {
  return (原生函数表["DzGetOnBuildOrderId"] as () => number)();
}

export function 取建造的命令类型(this: void): number {
  return (原生函数表["DzGetOnBuildOrderType"] as () => number)();
}

export function 取监听到的技能(this: void): number {
  return (原生函数表["DzGetOnTargetAbilId"] as () => number)();
}

export function 取监听到技能预选目标(this: void): 控件句柄 {
  return (原生函数表["DzGetOnTargetAgent"] as () => 控件句柄)();
}

export function 取监听到技能预选目标_2(this: void): 控件句柄 {
  return (原生函数表["DzGetOnTargetInstantTarget"] as () => 控件句柄)();
}

export function 取监听到技能预选命令(this: void): number {
  return (原生函数表["DzGetOnTargetOrderId"] as () => number)();
}

export function 取监听到技能预选命令类型(this: void): number {
  return (原生函数表["DzGetOnTargetOrderType"] as () => number)();
}

export function 物品_玩家当前选择的物品同步(this: void, 玩家: 玩家句柄): 物品句柄 {
  return (原生函数表["DzGetPlayerLastSelectedItem"] as (玩家: 玩家句柄) => 物品句柄)(玩家);
}

export function 当前选择的单位异步(this: void): 单位句柄 {
  return (原生函数表["DzGetSelectedLeaderUnit"] as () => 单位句柄)();
}

export function 硬件_获取屏幕设备高度(this: void): number {
  return (原生函数表["DzGetSystemMetricsHeight"] as () => number)();
}

export function 硬件_获取屏幕设备宽度(this: void): number {
  return (原生函数表["DzGetSystemMetricsWidth"] as () => number)();
}

export function 坐标_获取地形高度轴高度(this: void, x: number, y: number): number {
  return (原生函数表["DzGetTerrainZ"] as (x: number, y: number) => number)(x, y);
}

export function 取时间日期从时间戳(this: void, 时间戳: number): string {
  return (原生函数表["DzGetTimeDateFromTimestamp"] as (时间戳: number) => string)(时间戳);
}

export function 取触发按键(this: void): number {
  return (原生函数表["DzGetTriggerKey"] as () => number)();
}

export function 取触发按键玩家(this: void): any {
  return (原生函数表["DzGetTriggerKeyPlayer"] as () => any)();
}

export function 技能_获取技能施法范围(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityArea"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能图标(this: void, 单位: 单位句柄, 技能ID: number): string {
  return (原生函数表["DzGetUnitAbilityArt"] as (单位: 单位句柄, 技能ID: number) => string)(单位, 技能ID);
}

export function 技能_设置技能魔法施放回复后摇(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityBackSwing"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取建造技能命令编号象牙塔(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityBuildOrderId"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能魔法施放点前摇(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityCastPoint"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能魔法施法时间(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityCastTime"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能当前冷却时间(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityCool"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能魔法消耗(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityCost"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能dataA(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityDataA"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能dataB(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityDataB"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能dataC(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityDataC"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能dataD(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityDataD"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能dataE(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityDataE"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取当前禁用的内部计数(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityDisabledCount"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能持续时间普通(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityDuration"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_工程升级_获取替换后的技能编号(this: void, 单位: 单位句柄, 旧ID: number): number {
  return (原生函数表["DzGetUnitAbilityEngineeringUpgradeNewId"] as (单位: 单位句柄, 旧ID: number) => number)(单位, 旧ID);
}

export function 技能_工程升级_获取替换前的技能编号(this: void, 单位: 单位句柄, 新ID: number): number {
  return (原生函数表["DzGetUnitAbilityEngineeringUpgradeOldId"] as (单位: 单位句柄, 新ID: number) => number)(单位, 新ID);
}

export function 技能_获取技能持续时间英雄(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityHeroDuration"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取当前是否禁用状态(this: void, 单位: 单位句柄, 技能ID: number): boolean {
  return (原生函数表["DzGetUnitAbilityIsDisabled"] as (单位: 单位句柄, 技能ID: number) => boolean)(单位, 技能ID);
}

export function 技能_获取技能最大冷却时间(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityMaxCool"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能投射物弧度(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityMissileArc"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能投射物模型(this: void, 单位: 单位句柄, 技能ID: number): string {
  return (原生函数表["DzGetUnitAbilityMissileArt"] as (单位: 单位句柄, 技能ID: number) => string)(单位, 技能ID);
}

export function 技能_获取技能投射物数量弹幕攻击(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityMissileCount"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能投射物伤害弹幕攻击(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityMissileDamage"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能投射物允许自导(this: void, 单位: 单位句柄, 技能ID: number): boolean {
  return (原生函数表["DzGetUnitAbilityMissileHoming"] as (单位: 单位句柄, 技能ID: number) => boolean)(单位, 技能ID);
}

export function 技能_获取技能投射物最大伤害弹幕攻击(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityMissileMaxDamage"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能投射物速度(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityMissileSpeed"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能命令编号(this: void, 单位: 单位句柄, 技能ID: number): number {
  return (原生函数表["DzGetUnitAbilityOrderId"] as (单位: 单位句柄, 技能ID: number) => number)(单位, 技能ID);
}

export function 技能_获取技能施法距离(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityRange"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取技能等级要求(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityReqLevel"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取魔法书的技能列表(this: void, 单位: 单位句柄, 技能ID: number): string {
  return (原生函数表["DzGetUnitAbilitySpellBookList"] as (单位: 单位句柄, 技能ID: number) => string)(单位, 技能ID);
}

export function 技能_获取技能目标允许(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityTargs"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 技能_获取当前科技条件是否达成(this: void, 单位: 单位句柄, 技能ID: number): boolean {
  return (原生函数表["DzGetUnitAbilityTechReach"] as (单位: 单位句柄, 技能ID: number) => boolean)(单位, 技能ID);
}

export function 技能_获取技能提示(this: void, 单位: 单位句柄, 技能ID: number): string {
  return (原生函数表["DzGetUnitAbilityTip"] as (单位: 单位句柄, 技能ID: number) => string)(单位, 技能ID);
}

export function 技能_获取技能提示扩展(this: void, 单位: 单位句柄, 技能ID: number): string {
  return (原生函数表["DzGetUnitAbilityUberTip"] as (单位: 单位句柄, 技能ID: number) => string)(单位, 技能ID);
}

export function 技能_获取建造技能单位编号象牙塔(this: void, 单位: 单位句柄, 技能代码: number): number {
  return (原生函数表["DzGetUnitAbilityUnitId"] as (单位: 单位句柄, 技能代码: number) => number)(单位, 技能代码);
}

export function 单位_获取单位作为目标类型(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitAsAttackTargetType"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取单位攻击1目标允许(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitAttack1TargetType"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取单位攻击2目标允许(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitAttack2TargetType"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取攻击最大目标数(this: void, 单位: 单位句柄, 序号: number): number {
  return (原生函数表["DzGetUnitAttackTargetCount"] as (单位: 单位句柄, 序号: number) => number)(单位, 序号);
}

export function 单位_获取魔法施放回复后摇(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitBackSwing"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取魔法施放点前摇(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitCastPoint"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取单位的碰撞体积(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitCollisionSize"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取单位控制命令是否被屏蔽(this: void, 单位: 单位句柄): boolean {
  return (原生函数表["DzGetUnitDisableControlOrder"] as (单位: 单位句柄) => boolean)(单位);
}

export function 单位_获取单位本地命令是否被屏蔽(this: void, 单位: 单位句柄): boolean {
  return (原生函数表["DzGetUnitDisableLocalOrder"] as (单位: 单位句柄) => boolean)(单位);
}

export function 单位_获取每秒生命恢复(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitLifeRegen"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取每秒魔法恢复(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitManaRegen"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取最高移动速度(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitMaxSpeed"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取最低移动速度(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitMinSpeed"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取单位头顶高度偏移(this: void, 单位: 控件句柄): number {
  return (原生函数表["DzGetUnitOverheadOffset"] as (单位: 控件句柄) => number)(单位);
}

export function 单位_获取投射物发射坐标横坐标(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitPojectileLaunchX"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取投射物发射坐标纵坐标(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitPojectileLaunchY"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取投射物发射坐标高度(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitPojectileLaunchZ"] as (单位: 单位句柄) => number)(单位);
}

export function 单位_获取单位高度轴高度(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzGetUnitZ"] as (单位: 单位句柄) => number)(单位);
}

export function 取单位组里单位数量(this: void, 单位组: 单位组句柄): number {
  return (原生函数表["DzGroupGetCount"] as (单位组: 单位组句柄) => number)(单位组);
}

export function 取单位组里指定索引的单位(this: void, 单位组: 单位组句柄, 序号: number): 单位句柄 {
  return (原生函数表["DzGroupGetUnitAt"] as (单位组: 单位组句柄, 序号: number) => 单位句柄)(单位组, 序号);
}

export function 物品_获取物品大小(this: void, 物品: 物品句柄): number {
  return (原生函数表["DzItemGetSize"] as (物品: 物品句柄) => number)(物品);
}

export function 物品_获取物品颜色(this: void, 物品: 物品句柄): number {
  return (原生函数表["DzItemGetVertexColor"] as (物品: 物品句柄) => number)(物品);
}

export function 检查字符串是否包含指定的子字符串(this: void, 字符串1: string, 目标字符串: string, 布尔3: boolean): boolean {
  return (原生函数表["DzStringContains"] as (字符串1: string, 目标字符串: string, 布尔3: boolean) => boolean)(字符串1, 目标字符串, 布尔3);
}

export function 字符串中查找子字符串并返回其位置(this: void, 字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean): number {
  return (原生函数表["DzStringFind"] as (字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean) => number)(字符串1, 目标字符串, 偏移, 布尔4);
}

export function 检查字符串第一个不包含指定字符串里任意字符的位置(this: void, 字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean): number {
  return (原生函数表["DzStringFindFirstNotOf"] as (字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean) => number)(字符串1, 目标字符串, 偏移, 布尔4);
}

export function 检测字符串里第一个包含指定字符串里任意字符的位置(this: void, 字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean): number {
  return (原生函数表["DzStringFindFirstOf"] as (字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean) => number)(字符串1, 目标字符串, 偏移, 布尔4);
}

export function 从后往前查找字符串中不包含指定字符串任意字符的所在位置(this: void, 字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean): number {
  return (原生函数表["DzStringFindLastNotOf"] as (字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean) => number)(字符串1, 目标字符串, 偏移, 布尔4);
}

export function 从后往前查找字符串中包含指定字符串任意字符的所在位置(this: void, 字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean): number {
  return (原生函数表["DzStringFindLastOf"] as (字符串1: string, 目标字符串: string, 偏移: number, 布尔4: boolean) => number)(字符串1, 目标字符串, 偏移, 布尔4);
}

export function 插入字符串(this: void, 字符串1: string, 位置: number, 目标字符串: string): string {
  return (原生函数表["DzStringInsert"] as (字符串1: string, 位置: number, 目标字符串: string) => string)(字符串1, 位置, 目标字符串);
}

export function 替换字符串(this: void, 字符串1: string, 目标字符串: string, 字符串3: string, 布尔4: boolean): string {
  return (原生函数表["DzStringReplace"] as (字符串1: string, 目标字符串: string, 字符串3: string, 布尔4: boolean) => string)(字符串1, 目标字符串, 字符串3, 布尔4);
}

export function 反转字符串(this: void, 字符串1: string): string {
  return (原生函数表["DzStringReverse"] as (字符串1: string) => string)(字符串1);
}

export function 删除字符串两边的空格(this: void, 字符串1: string): string {
  return (原生函数表["DzStringTrim"] as (字符串1: string) => string)(字符串1);
}

export function 删除字符串左边的空格(this: void, 字符串1: string): string {
  return (原生函数表["DzStringTrimLeft"] as (字符串1: string) => string)(字符串1);
}

export function 删除字符串右边的空格(this: void, 字符串1: string): string {
  return (原生函数表["DzStringTrimRight"] as (字符串1: string) => string)(字符串1);
}

export function 漂浮字_取当前漂浮文字的字体(this: void): string {
  return (原生函数表["DzTextTagGetFont"] as () => string)();
}

export function 漂浮字_取漂浮文字的阴影颜色(this: void, 类型: 漂浮字句柄): number {
  return (原生函数表["DzTextTagGetShadowColor"] as (类型: 漂浮字句柄) => number)(类型);
}

export function 单位_创建幻象单位(this: void, 玩家: 玩家句柄, 单位ID: number, x: number, y: number, 实数5: number): 单位句柄 {
  return (原生函数表["DzUnitCreateIllusion"] as (玩家: 玩家句柄, 单位ID: number, x: number, y: number, 实数5: number) => 单位句柄)(玩家, 单位ID, x, y, 实数5);
}

export function 单位_为单位创建幻象(this: void, 单位: 单位句柄): 单位句柄 {
  return (原生函数表["DzUnitCreateIllusionFromUnit"] as (单位: 单位句柄) => 单位句柄)(单位);
}

export function 单位_取单位的指定技能(this: void, 单位: 单位句柄, 技能编码: number): 技能句柄 {
  return (原生函数表["DzUnitFindAbility"] as (单位: 单位句柄, 技能编码: number) => 技能句柄)(单位, 技能编码);
}

export function 单位_取单位的命令数量(this: void, 单位: 单位句柄): number {
  return (原生函数表["DzUnitOrdersCount"] as (单位: 单位句柄) => number)(单位);
}

export function 工作表的值实数(this: void, 整数1: number, 字符串2: string, 行: number, 列: number): number {
  return (原生函数表["DzXlsxWorksheetGetCellFloat"] as (整数1: number, 字符串2: string, 行: number, 列: number) => number)(整数1, 字符串2, 行, 列);
}

export function 工作表的值整数(this: void, 整数1: number, 字符串2: string, 行: number, 列: number): number {
  return (原生函数表["DzXlsxWorksheetGetCellInteger"] as (整数1: number, 字符串2: string, 行: number, 列: number) => number)(整数1, 字符串2, 行, 列);
}

export function 工作表的值字符串(this: void, 整数1: number, 字符串2: string, 行: number, 列: number): string {
  return (原生函数表["DzXlsxWorksheetGetCellString"] as (整数1: number, 字符串2: string, 行: number, 列: number) => string)(整数1, 字符串2, 行, 列);
}

export function 单元格的数据类型(this: void, 整数1: number, 字符串2: string, 行: number, 列: number): number {
  return (原生函数表["DzXlsxWorksheetGetCellType"] as (整数1: number, 字符串2: string, 行: number, 列: number) => number)(整数1, 字符串2, 行, 列);
}

export function 工作表的总列数(this: void, 整数1: number, 字符串2: string): number {
  return (原生函数表["DzXlsxWorksheetGetColumnCount"] as (整数1: number, 字符串2: string) => number)(整数1, 字符串2);
}

export function 工作表的总行数(this: void, 整数1: number, 字符串2: string): number {
  return (原生函数表["DzXlsxWorksheetGetRowCount"] as (整数1: number, 字符串2: string) => number)(整数1, 字符串2);
}

export function 脚本扩展_执行(this: void, 脚本: string): string {
  return (原生函数表["EXExecuteScript"] as (脚本: string) => string)(脚本);
}

export function 技能扩展_取整数数据(this: void, 技能: any, 等级: number, 数据类型: number): number {
  return (原生函数表["EXGetAbilityDataInteger"] as (技能: any, 等级: number, 数据类型: number) => number)(技能, 等级, 数据类型);
}

export function 技能扩展_取实数数据(this: void, 技能: any, 等级: number, 数据类型: number): number {
  return (原生函数表["EXGetAbilityDataReal"] as (技能: any, 等级: number, 数据类型: number) => number)(技能, 等级, 数据类型);
}

export function 技能扩展_取字符串数据(this: void, 技能: any, 等级: number, 数据类型: number): string {
  return (原生函数表["EXGetAbilityDataString"] as (技能: any, 等级: number, 数据类型: number) => string)(技能, 等级, 数据类型);
}

export function 技能扩展_取编号(this: void, 技能: any): number {
  return (原生函数表["EXGetAbilityId"] as (技能: any) => number)(技能);
}

export function 技能扩展_取状态(this: void, 技能: any, 状态类型: number): number {
  return (原生函数表["EXGetAbilityState"] as (技能: any, 状态类型: number) => number)(技能, 状态类型);
}

export function 物品扩展_取字符串数据(this: void, 物品编码: number, 数据类型: number): string {
  return (原生函数表["EXGetItemDataString"] as (物品编码: number, 数据类型: number) => string)(物品编码, 数据类型);
}

export function 单位扩展_取技能(this: void, 单位: any, 技能编码: number): any {
  return (原生函数表["EXGetUnitAbility"] as (单位: any, 技能编码: number) => any)(单位, 技能编码);
}

export function 单位扩展_按序号取技能(this: void, 单位: any, 序号: number): any {
  return (原生函数表["EXGetUnitAbilityByIndex"] as (单位: any, 序号: number) => any)(单位, 序号);
}

export function 平台扩展_玩家平台该地图成就点数(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["KKApiAchievementPoints"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 平台扩展_取玩家在指定地图会员等级(this: void, 玩家: 玩家句柄, 地图ID: number): number {
  return (原生函数表["KKApiConsumeLevel"] as (玩家: 玩家句柄, 地图ID: number) => number)(玩家, 地图ID);
}

export function 平台扩展_取玩家当天总游戏局数(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["KKApiDayRounds"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 平台扩展_取随机数的组编号(this: void, 玩家: 玩家句柄, 键名: string): string {
  return (原生函数表["KKApiGetBackendLogicGroup"] as (玩家: 玩家句柄, 键名: string) => string)(玩家, 键名);
}

export function 平台扩展_取随机数的值(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["KKApiGetBackendLogicIntResult"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 平台扩展_取随机数的值_2(this: void, 玩家: 玩家句柄, 键名: string): string {
  return (原生函数表["KKApiGetBackendLogicStrResult"] as (玩家: 玩家句柄, 键名: string) => string)(玩家, 键名);
}

export function 平台扩展_取随机数的生成时间(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["KKApiGetBackendLogicUpdateTime"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 平台扩展_取赛事模式(this: void): string {
  return (原生函数表["KKApiGetCompetitionGameMode"] as () => string)();
}

export function 平台扩展_玩家在公会的等级(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["KKApiGetGuildLevel"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 平台扩展_取天梯投降的队伍编号(this: void): number {
  return (原生函数表["KKApiGetLadderSurrenderTeamId"] as () => number)();
}

export function 平台扩展_事件响应_商城道具最后变动的数量(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["KKApiGetMallItemUpdateCount"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 平台扩展_取地图版本号(this: void): string {
  return (原生函数表["KKApiGetMapVersion"] as () => string)();
}

export function 平台扩展_取服务器存档限制余额(this: void, 玩家: 玩家句柄, 键名: string): number {
  return (原生函数表["KKApiGetServerValueLimitLeft"] as (玩家: 玩家句柄, 键名: string) => number)(玩家, 键名);
}

export function 平台扩展_取变动的随机存档(this: void): string {
  return (原生函数表["KKApiGetSyncBackendLogic"] as () => string)();
}

export function 平台扩展_转换时间戳为具体时间(this: void, 时间戳: number): string {
  return (原生函数表["KKAPIGetTimeDateFromTimestamp"] as (时间戳: number) => string)(时间戳);
}

export function 平台扩展_取时间戳日份(this: void, 时间戳: number): number {
  return (原生函数表["KKAPIGetTimestampDay"] as (时间戳: number) => number)(时间戳);
}

export function 平台扩展_取时间戳月份(this: void, 时间戳: number): number {
  return (原生函数表["KKAPIGetTimestampMonth"] as (时间戳: number) => number)(时间戳);
}

export function 平台扩展_取时间戳年份(this: void, 时间戳: number): number {
  return (原生函数表["KKAPIGetTimestampYear"] as (时间戳: number) => number)(时间戳);
}

export function 平台扩展_宠物探险次数(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["KKApiMapExplorationNum"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 平台扩展_宠物探险时间(this: void, 玩家: 玩家句柄): number {
  return (原生函数表["KKApiMapExplorationTime"] as (玩家: 玩家句柄) => number)(玩家);
}

export function 平台扩展_测试大厅预约人数(this: void): number {
  return (原生函数表["KKApiMapOrderNum"] as () => number)();
}

export function 平台扩展_取玩家的平台编号(this: void, 玩家: 玩家句柄): string {
  return (原生函数表["KKApiPlayerGUID"] as (玩家: 玩家句柄) => string)(玩家);
}

export function 平台扩展_玩家地图任务当前进度(this: void, 玩家: 玩家句柄, 整数2: number): number {
  return (原生函数表["KKApiQueryTaskCurrentProgress"] as (玩家: 玩家句柄, 整数2: number) => number)(玩家, 整数2);
}

export function 平台扩展_玩家地图任务总进度(this: void, 玩家: 玩家句柄, 整数2: number): number {
  return (原生函数表["KKApiQueryTaskTotalProgress"] as (玩家: 玩家句柄, 整数2: number) => number)(玩家, 整数2);
}

export function 平台扩展_剩余次数(this: void, 玩家: 玩家句柄, 分组键: string): number {
  return (原生函数表["KKApiRandomSaveGameCount"] as (玩家: 玩家句柄, 分组键: string) => number)(玩家, 分组键);
}

export function 平台扩展_技能按钮_获取按钮上的技能编号(this: void, 整数1: number): number {
  return (原生函数表["KKCommandButtonGetAbilityId"] as (整数1: number) => number)(整数1);
}

export function 平台扩展_技能按钮_获取按钮上的命令编号(this: void, 整数1: number): number {
  return (原生函数表["KKCommandButtonGetOrderId"] as (整数1: number) => number)(整数1);
}

export function 平台扩展_界面_获取技能_物品按钮的冷却模型控件(this: void, 整数1: number): number {
  return (原生函数表["KKCommandGetCooldownModel"] as (整数1: number) => number)(整数1);
}

export function 平台扩展_转化_技能编号为整数(this: void, 整数值: number): number {
  return (原生函数表["KKConvertAbilId2Int"] as (整数值: number) => number)(整数值);
}

export function 平台扩展_转化_转颜色为整数(this: void, 整数值: number): number {
  return (原生函数表["KKConvertColor2Int"] as (整数值: number) => number)(整数值);
}

export function 平台扩展_转化_整数为技能编号(this: void, 整数值: number): number {
  return (原生函数表["KKConvertInt2AbilId"] as (整数值: number) => number)(整数值);
}

export function 平台扩展_转化_转整数为颜色(this: void, 整数值: number): number {
  return (原生函数表["KKConvertInt2Color"] as (整数值: number) => number)(整数值);
}

export function 平台扩展_技能_创建技能按钮控件(this: void): number {
  return (原生函数表["KKCreateCommandButton"] as () => number)();
}

export function 请求额外_整数数据(this: void, 数据类型: number, 玩家: 玩家句柄, 字符串3: string, 字符串4: string, 布尔5: boolean, 整数6: number, 整数7: number, 整数8: number): number {
  return (原生函数表["RequestExtraIntegerData"] as (数据类型: number, 玩家: 玩家句柄, 字符串3: string, 字符串4: string, 布尔5: boolean, 整数6: number, 整数7: number, 整数8: number) => number)(数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8);
}

export function 请求额外_实数数据(this: void, 数据类型: number, 玩家: 玩家句柄, 字符串3: string, 字符串4: string, 布尔5: boolean, 整数6: number, 整数7: number, 整数8: number): number {
  return (原生函数表["RequestExtraRealData"] as (数据类型: number, 玩家: 玩家句柄, 字符串3: string, 字符串4: string, 布尔5: boolean, 整数6: number, 整数7: number, 整数8: number) => number)(数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8);
}

export function 请求额外_字符串数据(this: void, 数据类型: number, 玩家: 玩家句柄, 字符串3: string, 字符串4: string, 布尔5: boolean, 整数6: number, 整数7: number, 整数8: number): string {
  return (原生函数表["RequestExtraStringData"] as (数据类型: number, 玩家: 玩家句柄, 字符串3: string, 字符串4: string, 布尔5: boolean, 整数6: number, 整数7: number, 整数8: number) => string)(数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8);
}
