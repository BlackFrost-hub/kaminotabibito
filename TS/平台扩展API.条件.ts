/** @noSelfInFile */

/**
 * 平台扩展 API 中文包装 - 条件。
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

export function 地图_关闭U币快速购买界面(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["DzAPI_Map_CancelQuickBuy"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 地图_使用地图商城道具数量型(this: void, 玩家: 玩家句柄, 键名: string, 数量: number): boolean {
  return (原生函数表["DzAPI_Map_ConsumeMallItem"] as (玩家: 玩家句柄, 键名: string, 数量: number) => boolean)(玩家, 键名, 数量);
}

export function 地图_开启_关闭游戏内辅助功能(this: void, 玩家: 玩家句柄, 选项: number, 是否启用: boolean): boolean {
  return (原生函数表["DzAPI_Map_EnablePlatformSettings"] as (玩家: 玩家句柄, 选项: number, 是否启用: boolean) => boolean)(玩家, 选项, 是否启用);
}

export function 地图_取服务器上的布尔变量(this: void, 玩家: 玩家句柄, 键名: string): boolean {
  return (原生函数表["DzAPI_Map_GetStoredBoolean"] as (玩家: 玩家句柄, 键名: string) => boolean)(玩家, 键名);
}

export function 地图_玩家是否拥有地图商城道具(this: void, 玩家: 玩家句柄, 键名: string): boolean {
  return (原生函数表["DzAPI_Map_HasMallItem"] as (玩家: 玩家句柄, 键名: string) => boolean)(玩家, 键名);
}

export function 地图_玩家是否当前地图作者(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["DzAPI_Map_IsAuthor"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 地图_玩家是否平台认证的主播(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["DzAPI_Map_IsBlueVIP"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 地图_玩家是否平台认证的鉴赏家(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["DzAPI_Map_IsConnoisseur"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 地图_本局游戏是否处于平台自测服(this: void): boolean {
  return (原生函数表["DzAPI_Map_IsMapTest"] as () => boolean)();
}

export function 地图_玩家是否平台尊享会员(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["DzAPI_Map_IsPlatformVIP"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 地图_玩家是否为真实玩家(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["DzAPI_Map_IsPlayer"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 地图_玩家是否装备指定平台装饰(this: void, 玩家: 玩家句柄, 皮肤类型: number, ID: number): boolean {
  return (原生函数表["DzAPI_Map_IsPlayerUsingSkin"] as (玩家: 玩家句柄, 皮肤类型: number, ID: number) => boolean)(玩家, 皮肤类型, ID);
}

export function 地图_玩家是否平台认证的职业选手(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["DzAPI_Map_IsRedVIP"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 地图_本局游戏是否天梯排位赛(this: void): boolean {
  return (原生函数表["DzAPI_Map_IsRPGLadder"] as () => boolean)();
}

export function 地图_本局游戏是否处于角色扮演游戏大厅(this: void): boolean {
  return (原生函数表["DzAPI_Map_IsRPGLobby"] as () => boolean)();
}

export function 地图_本局游戏是否快速匹配(this: void): boolean {
  return (原生函数表["DzAPI_Map_IsRPGQuickMatch"] as () => boolean)();
}

export function 地图_玩家在指定地图累计消费金额区间1到199(this: void, 玩家: 玩家句柄, 地图ID: number): boolean {
  return (原生函数表["DzAPI_Map_MapsConsumeLv1"] as (玩家: 玩家句柄, 地图ID: number) => boolean)(玩家, 地图ID);
}

export function 地图_玩家在指定地图累计消费金额区间200到499(this: void, 玩家: 玩家句柄, 地图ID: number): boolean {
  return (原生函数表["DzAPI_Map_MapsConsumeLv2"] as (玩家: 玩家句柄, 地图ID: number) => boolean)(玩家, 地图ID);
}

export function 地图_玩家在指定地图累计消费金额区间500到999(this: void, 玩家: 玩家句柄, 地图ID: number): boolean {
  return (原生函数表["DzAPI_Map_MapsConsumeLv3"] as (玩家: 玩家句柄, 地图ID: number) => boolean)(玩家, 地图ID);
}

export function 地图_玩家在指定地图累计消费金额区间1000以上(this: void, 玩家: 玩家句柄, 地图ID: number): boolean {
  return (原生函数表["DzAPI_Map_MapsConsumeLv4"] as (玩家: 玩家句柄, 地图ID: number) => boolean)(玩家, 地图ID);
}

export function 地图_打开地图商城道具购买界面(this: void, 玩家: 玩家句柄, 键名: string): boolean {
  return (原生函数表["DzAPI_Map_OpenMall"] as (玩家: 玩家句柄, 键名: string) => boolean)(玩家, 键名);
}

export function 地图_玩家标记(this: void, 玩家: 玩家句柄, 标签: number): boolean {
  return (原生函数表["DzAPI_Map_PlayerFlags"] as (玩家: 玩家句柄, 标签: number) => boolean)(玩家, 标签);
}

export function 地图_玩家地图商城道具是否读取成功(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["DzAPI_Map_PlayerLoadedItems"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 地图_使用U币快速购买地图商城道具(this: void, 玩家: 玩家句柄, 键名: string, 数量: number, 秒数: number): boolean {
  return (原生函数表["DzAPI_Map_QuickBuy"] as (玩家: 玩家句柄, 键名: string, 数量: number, 秒数: number) => boolean)(玩家, 键名, 数量, 秒数);
}

export function 地图_是否回流_收藏过地图的用户(this: void, 玩家: 玩家句柄, 标签: number): boolean {
  return (原生函数表["DzAPI_Map_Returns"] as (玩家: 玩家句柄, 标签: number) => boolean)(玩家, 标签);
}

export function 地图_保存服务器存档组(this: void, 玩家: 玩家句柄, 键名: string, 值: string): boolean {
  return (原生函数表["DzAPI_Map_SavePublicArchive"] as (玩家: 玩家句柄, 键名: string, 值: string) => boolean)(玩家, 键名, 值);
}

export function 地图_保存服务器存档_2(this: void, 玩家: 玩家句柄, 键名: string, 值: string): boolean {
  return (原生函数表["DzAPI_Map_SaveServerValue"] as (玩家: 玩家句柄, 键名: string, 值: string) => boolean)(玩家, 键名, 值);
}

export function 界面_获取复选框勾选状态(this: void, 勾选框界面: number): boolean {
  return (原生函数表["DzFrameGetCheckBoxState"] as (勾选框界面: number) => boolean)(勾选框界面);
}

export function 界面_是否有指定锚点(this: void, 界面: number, 锚点: number): boolean {
  return (原生函数表["DzFrameGetPointValid"] as (界面: number, 锚点: number) => boolean)(界面, 锚点);
}

export function 界面_获取控件是否焦点(this: void, 界面: number): boolean {
  return (原生函数表["DzFrameIsFocus"] as (界面: number) => boolean)(界面);
}

export function 聊天框是否打开(this: void): boolean {
  return (原生函数表["DzIsChatBoxOpen"] as () => boolean)();
}

export function 是否闰年(this: void, 年: number): boolean {
  return (原生函数表["DzIsLeapYear"] as (年: number) => boolean)(年);
}

export function 是否单位攻击类型(this: void, 单位: 单位句柄, 序号: number, 攻击类型: any): boolean {
  return (原生函数表["DzIsUnitAttackType"] as (单位: 单位句柄, 序号: number, 攻击类型: any) => boolean)(单位, 序号, 攻击类型);
}

export function 是否单位防御类型(this: void, 单位: 单位句柄, 防御类型: number): boolean {
  return (原生函数表["DzIsUnitDefenseType"] as (单位: 单位句柄, 防御类型: number) => boolean)(单位, 防御类型);
}

export function 硬件_当前游戏窗口是否活动窗口(this: void): boolean {
  return (原生函数表["DzIsWindowActive"] as () => boolean)();
}

export function 硬件_当前游戏是否窗口化模式(this: void): boolean {
  return (原生函数表["DzIsWindowMode"] as () => boolean)();
}

export function 单位_杀死指定凶手(this: void, 单位: 单位句柄, 单位2: 单位句柄): boolean {
  return (原生函数表["DzKillUnit"] as (单位: 单位句柄, 单位2: 单位句柄) => boolean)(单位, 单位2);
}

export function 投射物_发射炮火(this: void, 来源: 单位句柄, 目标: 控件句柄, 实数3: number, 实数4: number, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数15: any, 伤害: number, 弧度: number, 攻击: boolean, 标记: number, 实数20: number, 目标标记: number, 实数22: number, 实数23: number, 实数24: number, 实数25: number, 实数26: number): boolean {
  return (原生函数表["DzLaunchArtillery"] as (来源: 单位句柄, 目标: 控件句柄, 实数3: number, 实数4: number, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数15: any, 伤害: number, 弧度: number, 攻击: boolean, 标记: number, 实数20: number, 目标标记: number, 实数22: number, 实数23: number, 实数24: number, 实数25: number, 实数26: number) => boolean)(来源, 目标, 实数3, 实数4, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数15, 伤害, 弧度, 攻击, 标记, 实数20, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26);
}

export function 投射物_发射炮火穿透(this: void, 来源: 单位句柄, 目标: 控件句柄, 实数3: number, 实数4: number, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数15: any, 伤害: number, 弧度: number, 攻击: boolean, 标记: number, 实数20: number, 目标标记: number, 实数22: number, 实数23: number, 实数24: number, 实数25: number, 实数26: number, 实数27: number, 实数28: number, 范围: number): boolean {
  return (原生函数表["DzLaunchArtilleryLine"] as (来源: 单位句柄, 目标: 控件句柄, 实数3: number, 实数4: number, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数15: any, 伤害: number, 弧度: number, 攻击: boolean, 标记: number, 实数20: number, 目标标记: number, 实数22: number, 实数23: number, 实数24: number, 实数25: number, 实数26: number, 实数27: number, 实数28: number, 范围: number) => boolean)(来源, 目标, 实数3, 实数4, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数15, 伤害, 弧度, 攻击, 标记, 实数20, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26, 实数27, 实数28, 范围);
}

export function 投射物_发射箭矢(this: void, 来源: 单位句柄, 目标: 控件句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数13: any, 伤害: number, 弧度: number, 追踪: boolean, 布尔17: boolean, 布尔18: boolean, 攻击: boolean, 标记: number): boolean {
  return (原生函数表["DzLaunchMissile"] as (来源: 单位句柄, 目标: 控件句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数13: any, 伤害: number, 弧度: number, 追踪: boolean, 布尔17: boolean, 布尔18: boolean, 攻击: boolean, 标记: number) => boolean)(来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记);
}

export function 投射物_发射箭矢弹射(this: void, 来源: 单位句柄, 目标: 控件句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数13: any, 伤害: number, 弧度: number, 追踪: boolean, 布尔17: boolean, 布尔18: boolean, 攻击: boolean, 标记: number, 目标标记: number, 目标数量: number, 弹跳范围: number, 实数24: number): boolean {
  return (原生函数表["DzLaunchMissileBounce"] as (来源: 单位句柄, 目标: 控件句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数13: any, 伤害: number, 弧度: number, 追踪: boolean, 布尔17: boolean, 布尔18: boolean, 攻击: boolean, 标记: number, 目标标记: number, 目标数量: number, 弹跳范围: number, 实数24: number) => boolean)(来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 目标数量, 弹跳范围, 实数24);
}

export function 投射物_发射技能投射物腐臭蜂群(this: void, 来源: 单位句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 朝向: number, 实数9: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数14: any, 伤害: number, 标记: number, 目标标记: number, 实数18: number, 实数19: number, 最大伤害: number, 增益ID: number): boolean {
  return (原生函数表["DzLaunchMissileCarrionSwarmEx"] as (来源: 单位句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 朝向: number, 实数9: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数14: any, 伤害: number, 标记: number, 目标标记: number, 实数18: number, 实数19: number, 最大伤害: number, 增益ID: number) => boolean)(来源, 模型路径, 队伍颜色, 颜色, x, y, z, 朝向, 实数9, 缩放, 速度, 攻击类型, 伤害类型, 参数14, 伤害, 标记, 目标标记, 实数18, 实数19, 最大伤害, 增益ID);
}

export function 投射物_发射箭矢穿透(this: void, 来源: 单位句柄, 目标: 控件句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数13: any, 伤害: number, 弧度: number, 追踪: boolean, 布尔17: boolean, 布尔18: boolean, 攻击: boolean, 标记: number, 目标标记: number, 实数22: number, 实数23: number, 范围: number): boolean {
  return (原生函数表["DzLaunchMissileLine"] as (来源: 单位句柄, 目标: 控件句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数13: any, 伤害: number, 弧度: number, 追踪: boolean, 布尔17: boolean, 布尔18: boolean, 攻击: boolean, 标记: number, 目标标记: number, 实数22: number, 实数23: number, 范围: number) => boolean)(来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 实数22, 实数23, 范围);
}

export function 投射物_发射箭矢溅射(this: void, 来源: 单位句柄, 目标: 控件句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数13: any, 伤害: number, 弧度: number, 追踪: boolean, 布尔17: boolean, 布尔18: boolean, 攻击: boolean, 标记: number, 目标标记: number, 实数22: number, 实数23: number, 实数24: number, 实数25: number, 实数26: number): boolean {
  return (原生函数表["DzLaunchMissileSplash"] as (来源: 单位句柄, 目标: 控件句柄, 模型路径: string, 队伍颜色: number, 颜色: number, x: number, y: number, z: number, 缩放: number, 速度: number, 攻击类型: any, 伤害类型: any, 参数13: any, 伤害: number, 弧度: number, 追踪: boolean, 布尔17: boolean, 布尔18: boolean, 攻击: boolean, 标记: number, 目标标记: number, 实数22: number, 实数23: number, 实数24: number, 实数25: number, 实数26: number) => boolean)(来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26);
}

export function 坐标_是否可以能够通过物体(this: void, x: number, y: number, 碰撞大小: number, 碰撞类型: number): boolean {
  return (原生函数表["DzPositionCanPlaceAround"] as (x: number, y: number, 碰撞大小: number, 碰撞类型: number) => boolean)(x, y, 碰撞大小, 碰撞类型);
}

export function 对单位组添加命令到队列无目标(this: void, 单位组: 单位组句柄, 命令ID: number): boolean {
  return (原生函数表["DzQueueGroupImmediateOrderById"] as (单位组: 单位组句柄, 命令ID: number) => boolean)(单位组, 命令ID);
}

export function 对单位组添加命令到队列指定坐标(this: void, 单位组: 单位组句柄, 命令ID: number, x: number, y: number): boolean {
  return (原生函数表["DzQueueGroupPointOrderById"] as (单位组: 单位组句柄, 命令ID: number, x: number, y: number) => boolean)(单位组, 命令ID, x, y);
}

export function 队列_单位组目标命令按编号(this: void, 单位组: 单位组句柄, 命令ID: number, 目标控件: 控件句柄): boolean {
  return (原生函数表["DzQueueGroupTargetOrderById"] as (单位组: 单位组句柄, 命令ID: number, 目标控件: 控件句柄) => boolean)(单位组, 命令ID, 目标控件);
}

export function 对单位添加建造命令到队列(this: void, 农民: 单位句柄, 单位ID: number, x: number, y: number): boolean {
  return (原生函数表["DzQueueIssueBuildOrderById"] as (农民: 单位句柄, 单位ID: number, x: number, y: number) => boolean)(农民, 单位ID, x, y);
}

export function 对单位添加命令到队列无目标(this: void, 单位: 单位句柄, 命令ID: number): boolean {
  return (原生函数表["DzQueueIssueImmediateOrderById"] as (单位: 单位句柄, 命令ID: number) => boolean)(单位, 命令ID);
}

export function 队列_下达瞬时点位命令按编号(this: void, 单位: 单位句柄, 命令ID: number, x: number, y: number, 瞬时目标控件: 控件句柄): boolean {
  return (原生函数表["DzQueueIssueInstantPointOrderById"] as (单位: 单位句柄, 命令ID: number, x: number, y: number, 瞬时目标控件: 控件句柄) => boolean)(单位, 命令ID, x, y, 瞬时目标控件);
}

export function 队列_下达瞬时目标命令按编号(this: void, 单位: 单位句柄, 命令ID: number, 目标控件: 控件句柄, 瞬时目标控件: 控件句柄): boolean {
  return (原生函数表["DzQueueIssueInstantTargetOrderById"] as (单位: 单位句柄, 命令ID: number, 目标控件: 控件句柄, 瞬时目标控件: 控件句柄) => boolean)(单位, 命令ID, 目标控件, 瞬时目标控件);
}

export function 队列_下达中立目标命令按编号(this: void, 归属玩家: 玩家句柄, 中立建筑: 单位句柄, 单位ID: number, 目标: 控件句柄): boolean {
  return (原生函数表["DzQueueIssueNeutralTargetOrderById"] as (归属玩家: 玩家句柄, 中立建筑: 单位句柄, 单位ID: number, 目标: 控件句柄) => boolean)(归属玩家, 中立建筑, 单位ID, 目标);
}

export function 对单位添加命令到队列指定坐标(this: void, 单位: 单位句柄, 命令ID: number, x: number, y: number): boolean {
  return (原生函数表["DzQueueIssuePointOrderById"] as (单位: 单位句柄, 命令ID: number, x: number, y: number) => boolean)(单位, 命令ID, x, y);
}

export function 队列_下达目标命令按编号(this: void, 单位: 单位句柄, 命令ID: number, 目标控件: 控件句柄): boolean {
  return (原生函数表["DzQueueIssueTargetOrderById"] as (单位: 单位句柄, 命令ID: number, 目标控件: 控件句柄) => boolean)(单位, 命令ID, 目标控件);
}

export function 单位_是否可以被放置到坐标(this: void, 对象: 控件句柄, x: number, y: number): boolean {
  return (原生函数表["DzUnitCanPlaceAround"] as (对象: 控件句柄, x: number, y: number) => boolean)(对象, x, y);
}

export function 单位_技能_判断单位是否拥有技能包含模版技能(this: void, 单位: 单位句柄, 技能代码: number): boolean {
  return (原生函数表["DzUnitHasAbility"] as (单位: 单位句柄, 技能代码: number) => boolean)(单位, 技能代码);
}

export function 工作表的值布尔值(this: void, 整数1: number, 字符串2: string, 行: number, 列: number): boolean {
  return (原生函数表["DzXlsxWorksheetGetCellBoolean"] as (整数1: number, 字符串2: string, 行: number, 列: number) => boolean)(整数1, 字符串2, 行, 列);
}

export function 平台扩展_是否随机数是否存在(this: void, 玩家: 玩家句柄, 键名: string): boolean {
  return (原生函数表["KKApiCheckBackendLogicExists"] as (玩家: 玩家句柄, 键名: string) => boolean)(玩家, 键名);
}

export function 平台扩展_玩家平台该地图成就是否完成(this: void, 玩家: 玩家句柄, ID: string): boolean {
  return (原生函数表["KKApiIsAchievementCompleted"] as (玩家: 玩家句柄, ID: string) => boolean)(玩家, ID);
}

export function 平台扩展_是否在平台正常游戏中(this: void): boolean {
  return (原生函数表["KKApiIsGameMode"] as () => boolean)();
}

export function 平台扩展_是否玩家当前地图在游戏大厅置顶状态(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["KKApiIsPinned"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 平台扩展_玩家地图任务状态(this: void, 玩家: 玩家句柄, 整数2: number, 整数3: number): boolean {
  return (原生函数表["KKApiIsTaskInProgress"] as (玩家: 玩家句柄, 整数2: number, 整数3: number) => boolean)(玩家, 整数2, 整数3);
}

export function 平台扩展_发送云脚本数据(this: void, 玩家: 玩家句柄, 事件名称: string, 字符串3: string): boolean {
  return (原生函数表["KKApiMlScriptEvent"] as (玩家: 玩家句柄, 事件名称: string, 字符串3: string) => boolean)(玩家, 事件名称, 字符串3);
}

export function 平台扩展_判定测试大厅游戏时长区间(this: void, 玩家: 玩家句柄, 最小时长: number, 最大时长: number): boolean {
  return (原生函数表["KKApiPlayedTime"] as (玩家: 玩家句柄, 最小时长: number, 最大时长: number) => boolean)(玩家, 最小时长, 最大时长);
}

export function 平台扩展_取玩家身份类型(this: void, 玩家: 玩家句柄, ID: number): boolean {
  return (原生函数表["KKApiPlayerIdentityType"] as (玩家: 玩家句柄, ID: number) => boolean)(玩家, ID);
}

export function 平台扩展_随机只读存档删除随机数(this: void, 玩家: 玩家句柄, 键名: string): boolean {
  return (原生函数表["KKApiRemoveBackendLogicResult"] as (玩家: 玩家句柄, 键名: string) => boolean)(玩家, 键名);
}

export function 平台扩展_技能按钮_目标指示器点击目标单位(this: void, 鼠标类型: number, 目标: 控件句柄): boolean {
  return (原生函数表["KKCommandTargetClick"] as (鼠标类型: number, 目标: 控件句柄) => boolean)(鼠标类型, 目标);
}

export function 平台扩展_技能按钮_目标指示器点击地面坐标(this: void, 鼠标类型: number, x: number, y: number, z: number): boolean {
  return (原生函数表["KKCommandTerrainClick"] as (鼠标类型: number, x: number, y: number, z: number) => boolean)(鼠标类型, x, y, z);
}

export function 平台扩展_点_是否可以能够通过物体(this: void, 点: 点句柄, 碰撞大小: number, 碰撞类型: number): boolean {
  return (原生函数表["KKPositionCanPlaceAroundLoc"] as (点: 点句柄, 碰撞大小: number, 碰撞类型: number) => boolean)(点, 碰撞大小, 碰撞类型);
}

export function 平台扩展_界面_判断SimpleFrame类型控件是否显示(this: void, 简单界面: number): boolean {
  return (原生函数表["KKSimpleFrameIsVisible"] as (简单界面: number) => boolean)(简单界面);
}

export function 平台扩展_单位_是否可以被放置到点(this: void, 对象: 控件句柄, 点: 点句柄): boolean {
  return (原生函数表["KKUnitCanPlaceAroundLoc"] as (对象: 控件句柄, 点: 点句柄) => boolean)(对象, 点);
}

export function 平台扩展_物品_是否可以被放置到点(this: void, 对象: 控件句柄, 点: 点句柄): boolean {
  return (原生函数表["KKUnitCanPlaceAroundLocItem"] as (对象: 控件句柄, 点: 点句柄) => boolean)(对象, 点);
}

export function 请求额外_布尔数据(this: void, 数据类型: number, 玩家: 玩家句柄, 字符串3: string, 字符串4: string, 布尔5: boolean, 整数6: number, 整数7: number, 整数8: number): boolean {
  return (原生函数表["RequestExtraBooleanData"] as (数据类型: number, 玩家: 玩家句柄, 字符串3: string, 字符串4: string, 布尔5: boolean, 整数6: number, 整数7: number, 整数8: number) => boolean)(数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8);
}
