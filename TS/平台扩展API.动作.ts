/** @noSelfInFile */

/**
 * 平台扩展 API 中文包装 - 动作。
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

export function 设技能启用_禁用(this: void, 技能: 技能句柄, 是否启用: boolean, 是否隐藏界面: boolean): void {
  return (原生函数表["DzAbilitySetEnable"] as (技能: 技能句柄, 是否启用: boolean, 是否隐藏界面: boolean) => void)(技能, 是否启用, 是否隐藏界面);
}

export function 设技能数据_字符串(this: void, 技能: 技能句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAbilitySetStringData"] as (技能: 技能句柄, 键名: string, 值: string) => void)(技能, 键名, 值);
}

export function 地图_清理服务器数据(this: void, 玩家: 玩家句柄, 键名: string): void {
  return (原生函数表["DzAPI_Map_FlushStoredMission"] as (玩家: 玩家句柄, 键名: string) => void)(玩家, 键名);
}

export function 地图_上报本局游戏玩家数据(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_GameResult_CommitData"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 地图_上报本局游戏模式(this: void, 值: string): void {
  return (原生函数表["DzAPI_Map_GameResult_CommitGameMode"] as (值: string) => void)(值);
}

export function 地图_上报本局游戏结果(this: void, 玩家: 玩家句柄, 值: number): void {
  return (原生函数表["DzAPI_Map_GameResult_CommitGameResult"] as (玩家: 玩家句柄, 值: number) => void)(玩家, 值);
}

export function 地图_上报本局游戏结果不结束游戏(this: void, 玩家: 玩家句柄, 值: number): void {
  return (原生函数表["DzAPI_Map_GameResult_CommitGameResultNoEnd"] as (玩家: 玩家句柄, 值: number) => void)(玩家, 值);
}

export function 地图_上报本局游戏玩家排名(this: void, 玩家: 玩家句柄, 值: number): void {
  return (原生函数表["DzAPI_Map_GameResult_CommitPlayerRank"] as (玩家: 玩家句柄, 值: number) => void)(玩家, 值);
}

export function 地图_上报本局游戏玩家称号(this: void, 玩家: 玩家句柄, 值: string): void {
  return (原生函数表["DzAPI_Map_GameResult_CommitTitle"] as (玩家: 玩家句柄, 值: string) => void)(玩家, 值);
}

export function 地图_全局修改消息(this: void, 触发器: 触发器句柄): void {
  return (原生函数表["DzAPI_Map_Global_ChangeMsg"] as (触发器: 触发器句柄) => void)(触发器);
}

export function 地图_保存全局存档(this: void, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_Global_StoreString"] as (键名: string, 值: string) => void)(键名, 值);
}

export function 地图_天梯设玩家统计(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_Ladder_SetPlayerStat"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 地图_天梯提交字符串数据(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_Ladder_SetStat"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 地图_天梯提交技能数据(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["DzAPI_Map_Ladder_SubmitAblityIdData"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 地图_天梯提交布尔值数据(this: void, 玩家: 玩家句柄, 键名: string, 值: boolean): void {
  return (原生函数表["DzAPI_Map_Ladder_SubmitBooleanData"] as (玩家: 玩家句柄, 键名: string, 值: boolean) => void)(玩家, 键名, 值);
}

export function 地图_天梯提交整数数据(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["DzAPI_Map_Ladder_SubmitIntegerData"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 地图_天梯提交物品数据(this: void, 玩家: 玩家句柄, 键名: string, 值: 物品句柄): void {
  return (原生函数表["DzAPI_Map_Ladder_SubmitItemData"] as (玩家: 玩家句柄, 键名: string, 值: 物品句柄) => void)(玩家, 键名, 值);
}

export function 地图_天梯提交物品数据_2(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["DzAPI_Map_Ladder_SubmitItemIdData"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 地图_天梯设置玩家额外分(this: void, 玩家: 玩家句柄, 值: number): void {
  return (原生函数表["DzAPI_Map_Ladder_SubmitPlayerExtraExp"] as (玩家: 玩家句柄, 值: number) => void)(玩家, 值);
}

export function 地图_天梯提交玩家排名(this: void, 玩家: 玩家句柄, 值: number): void {
  return (原生函数表["DzAPI_Map_Ladder_SubmitPlayerRank"] as (玩家: 玩家句柄, 值: number) => void)(玩家, 值);
}

export function 地图_天梯提交获得称号(this: void, 玩家: 玩家句柄, 值: string): void {
  return (原生函数表["DzAPI_Map_Ladder_SubmitTitle"] as (玩家: 玩家句柄, 值: string) => void)(玩家, 值);
}

export function 地图_任务完成(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_MissionComplete"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 地图_触发BOSS击杀(this: void, 玩家: 玩家句柄, 键名: string): void {
  return (原生函数表["DzAPI_Map_OrpgTrigger"] as (玩家: 玩家句柄, 键名: string) => void)(玩家, 键名);
}

export function 地图_保存服务器存档(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_SaveServerArchive"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 地图_上报房间内显示的数据(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_Stat_SetStat"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 地图_统计提交单位数据(this: void, 玩家: 玩家句柄, 键名: string, 值: 单位句柄): void {
  return (原生函数表["DzAPI_Map_Stat_SubmitUnitData"] as (玩家: 玩家句柄, 键名: string, 值: 单位句柄) => void)(玩家, 键名, 值);
}

export function 地图_天梯提交单位类型数据(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["DzAPI_Map_Stat_SubmitUnitIdData"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 地图_上报埋点数据(this: void, 玩家: 玩家句柄, 事件键: string, 事件类型: string, 值: number): void {
  return (原生函数表["DzAPI_Map_Statistics"] as (玩家: 玩家句柄, 事件键: string, 事件类型: string, 值: number) => void)(玩家, 事件键, 事件类型, 值);
}

export function 地图_保存布尔值变量至服务器(this: void, 玩家: 玩家句柄, 键名: string, 值: boolean): void {
  return (原生函数表["DzAPI_Map_StoreBoolean"] as (玩家: 玩家句柄, 键名: string, 值: boolean) => void)(玩家, 键名, 值);
}

export function 地图_保存整数变量至服务器(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["DzAPI_Map_StoreInteger"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 地图_服务器存储整数(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["DzAPI_Map_StoreIntegerEX"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 地图_保存实数变量至服务器(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["DzAPI_Map_StoreReal"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 地图_保存字符串变量至服务器(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_StoreString"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 地图_服务器存储字符串(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["DzAPI_Map_StoreStringEX"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 地图_使用地图商城道具局数型(this: void, 玩家: 玩家句柄, 键名: string): void {
  return (原生函数表["DzAPI_Map_UseConsumablesItem"] as (玩家: 玩家句柄, 键名: string) => void)(玩家, 键名);
}

export function 结束普攻技能CD(this: void, 句柄: 技能句柄): void {
  return (原生函数表["DzAttackAbilityEndCooldown"] as (句柄: 技能句柄) => void)(句柄);
}

export function 绑定特效(this: void, 父界面: 控件句柄, 附着点: string, 特效: 特效句柄): void {
  return (原生函数表["DzBindEffect"] as (父界面: 控件句柄, 附着点: string, 特效: 特效句柄) => void)(父界面, 附着点, 特效);
}

export function 设整数的2进制的位值(this: void, 整数值: number, 字节序号: number, 字节值: number): number {
  return (原生函数表["DzBitSet"] as (整数值: number, 字节序号: number, 字节值: number) => number)(整数值, 字节序号, 字节值);
}

export function 设整数的256进制的位值(this: void, 整数值: number, 字节序号: number, 字节值: number): number {
  return (原生函数表["DzBitSetByte"] as (整数值: number, 字节序号: number, 字节值: number) => number)(整数值, 字节序号, 字节值);
}

export function 设魔兽窗口大小(this: void, 宽度: number, 高度: number): boolean {
  return (原生函数表["DzChangeWindowSize"] as (宽度: number, 高度: number) => boolean)(宽度, 高度);
}

export function 界面_创建(this: void, 名称: string, 父界面: number, ID: number): number {
  return (原生函数表["DzCreateFrame"] as (名称: string, 父界面: number, ID: number) => number)(名称, 父界面, ID);
}

export function 界面_按标签创建(this: void, 类型: string, 名称: string, 父界面: number, 模板: string, ID: number): number {
  return (原生函数表["DzCreateFrameByTagName"] as (类型: string, 名称: string, 父界面: number, 模板: string, ID: number) => number)(类型, 名称, 父界面, 模板, ID);
}

export function 游戏_禁用攻速限制(this: void): void {
  return (原生函数表["DzDisableAttackSpeedLimit"] as () => void)();
}

export function 游戏_屏蔽按键游戏UI消息(this: void, 玩家: 玩家句柄, 键码: number): void {
  return (原生函数表["DzDisableGameUIKeyboard"] as (玩家: 玩家句柄, 键码: number) => void)(玩家, 键码);
}

export function 界面_屏蔽所有物品指向UI(this: void): void {
  return (原生函数表["DzDisableItemPreselectUi"] as () => void)();
}

export function 界面_屏蔽所有单位指向UI跟血条(this: void): void {
  return (原生函数表["DzDisableUnitPreselectUi"] as () => void)();
}

export function 游戏_屏蔽按键窗口消息(this: void, 玩家: 玩家句柄, 键码: number): void {
  return (原生函数表["DzDisableWindowKeyboard"] as (玩家: 玩家句柄, 键码: number) => void)(玩家, 键码);
}

export function 装饰物_删除装饰物(this: void, 装饰物: number): void {
  return (原生函数表["DzDoodadRemove"] as (装饰物: number) => void)(装饰物);
}

export function 装饰物_装饰物播放动画(this: void, 装饰物: number, 动画名: string, 是否随机动画: boolean): void {
  return (原生函数表["DzDoodadSetAnimation"] as (装饰物: number, 动画名: string, 是否随机动画: boolean) => void)(装饰物, 动画名, 是否随机动画);
}

export function 装饰物_设装饰物颜色(this: void, 装饰物: number, 颜色: number): void {
  return (原生函数表["DzDoodadSetColor"] as (装饰物: number, 颜色: number) => void)(装饰物, 颜色);
}

export function 装饰物_设装饰物模型(this: void, 装饰物: number, 模型路径: string): void {
  return (原生函数表["DzDoodadSetModel"] as (装饰物: number, 模型路径: string) => void)(装饰物, 模型路径);
}

export function 装饰物_装饰物重置大小(this: void, 装饰物: number): void {
  return (原生函数表["DzDoodadSetOrientMatrixResize"] as (装饰物: number) => void)(装饰物);
}

export function 装饰物_设装饰物旋转(this: void, 装饰物: number, 角度: number, 轴x: number, 轴y: number, 轴z: number): void {
  return (原生函数表["DzDoodadSetOrientMatrixRotate"] as (装饰物: number, 角度: number, 轴x: number, 轴y: number, 轴z: number) => void)(装饰物, 角度, 轴x, 轴y, 轴z);
}

export function 装饰物_修改装饰物尺寸(this: void, 装饰物: number, x: number, y: number, z: number): void {
  return (原生函数表["DzDoodadSetOrientMatrixScale"] as (装饰物: number, x: number, y: number, z: number) => void)(装饰物, x, y, z);
}

export function 装饰物_设装饰物位置(this: void, 装饰物: number, x: number, y: number, z: number): void {
  return (原生函数表["DzDoodadSetPosition"] as (装饰物: number, x: number, y: number, z: number) => void)(装饰物, x, y, z);
}

export function 装饰物_改变装饰物队伍颜色(this: void, 装饰物: number, 颜色: number): void {
  return (原生函数表["DzDoodadSetTeamColor"] as (装饰物: number, 颜色: number) => void)(装饰物, 颜色);
}

export function 装饰物_设装饰物动画播放速度(this: void, 装饰物: number, 缩放: number): void {
  return (原生函数表["DzDoodadSetTimeScale"] as (装饰物: number, 缩放: number) => void)(装饰物, 缩放);
}

export function 装饰物_装饰物显示_隐藏(this: void, 装饰物: number, 是否启用: boolean): void {
  return (原生函数表["DzDoodadSetVisible"] as (装饰物: number, 是否启用: boolean) => void)(装饰物, 是否启用);
}

export function 特效_特效绑定特效(this: void, 句柄: 代理句柄, 字符串2: string, 特效: 特效句柄): void {
  return (原生函数表["DzEffectBindEffect"] as (句柄: 代理句柄, 字符串2: string, 特效: 特效句柄) => void)(句柄, 字符串2, 特效);
}

export function 允许查看指定单位技能(this: void, 单位: 单位句柄, 是否启用: boolean): void {
  return (原生函数表["DzEnableDrawSkillPanel"] as (单位: 单位句柄, 是否启用: boolean) => void)(单位, 是否启用);
}

export function 允许查看指定玩家单位技能(this: void, 玩家: 玩家句柄, 是否启用: boolean): void {
  return (原生函数表["DzEnableDrawSkillPanelByPlayer"] as (玩家: 玩家句柄, 是否启用: boolean) => void)(玩家, 是否启用);
}

export function 哈希表_开启保存空值逆天设置null(this: void, 是否启用: boolean): void {
  return (原生函数表["DzEnableHashtableSetNull"] as (是否启用: boolean) => void)(是否启用);
}

export function 游戏_修复单位命令事件泄漏(this: void): void {
  return (原生函数表["DzFixUnitEventMemoryLeak"] as () => void)();
}

export function 游戏_模拟按键游戏UI消息(this: void, 玩家: 玩家句柄, 键码: number, 是否按下: number): void {
  return (原生函数表["DzForceUiKeyboard"] as (玩家: 玩家句柄, 键码: number, 是否按下: number) => void)(玩家, 键码, 是否按下);
}

export function 界面_世界坐标_为绑定的Frame添加隐藏区域(this: void, 界面: number, 左: number, 下: number, 右: number, 上: number, 宽度: number, 高度: number): void {
  return (原生函数表["DzFrameBindAddHideRect"] as (界面: number, 左: number, 下: number, 右: number, 上: number, 宽度: number, 高度: number) => void)(界面, 左, 下, 右, 上, 宽度, 高度);
}

export function 界面_世界坐标_绑定Frame到单位实时位置(this: void, 界面: number, 单位: 控件句柄, 世界x: number, 世界y: number, 世界z: number, 屏幕x: number, 屏幕y: number, 雾中可见: boolean, 单位可见: boolean, 死亡可见: boolean): void {
  return (原生函数表["DzFrameBindWidget"] as (界面: number, 单位: 控件句柄, 世界x: number, 世界y: number, 世界z: number, 屏幕x: number, 屏幕y: number, 雾中可见: boolean, 单位可见: boolean, 死亡可见: boolean) => void)(界面, 单位, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见, 单位可见, 死亡可见);
}

export function 界面_世界坐标_绑定Frame到世界坐标实时位置(this: void, 界面: number, 世界x: number, 世界y: number, 世界z: number, 屏幕x: number, 屏幕y: number, 雾中可见: boolean): void {
  return (原生函数表["DzFrameBindWorldPos"] as (界面: number, 世界x: number, 世界y: number, 世界z: number, 屏幕x: number, 屏幕y: number, 雾中可见: boolean) => void)(界面, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见);
}

export function 界面_游戏界面限制设置(this: void, 是否启用: boolean): void {
  return (原生函数表["DzFrameEnableClipRect"] as (是否启用: boolean) => void)(是否启用);
}

export function 界面_血条刷新事件(this: void, 回调: () => void): void {
  return (原生函数表["DzFrameHookHpBar"] as (回调: () => void) => void)(回调);
}

export function 界面_移除模型特效(this: void, 模型界面: number, 特效界面: number): void {
  return (原生函数表["DzFrameRemoveModelEffect"] as (模型界面: number, 特效界面: number) => void)(模型界面, 特效界面);
}

export function 界面_设绝对点位(this: void, 界面: number, 点位: number, x: number, y: number): void {
  return (原生函数表["DzFrameSetAbsolutePoint"] as (界面: number, 点位: number, x: number, y: number) => void)(界面, 点位, x, y);
}

export function 界面_设透明度(this: void, 界面: number, 透明度: number): void {
  return (原生函数表["DzFrameSetAlpha"] as (界面: number, 透明度: number) => void)(界面, 透明度);
}

export function 界面_设模型界面播放动画编号(this: void, 界面: number, 序号: number, 整数3: number): void {
  return (原生函数表["DzFrameSetAnimateByIndex"] as (界面: number, 序号: number, 整数3: number) => void)(界面, 序号, 整数3);
}

export function 界面_设置复选框勾选状态(this: void, 勾选框界面: number, 是否勾选: boolean): void {
  return (原生函数表["DzFrameSetCheckBoxState"] as (勾选框界面: number, 是否勾选: boolean) => void)(勾选框界面, 是否勾选);
}

export function 界面_设控件视口(this: void, 界面: number, 是否启用: boolean): void {
  return (原生函数表["DzFrameSetClip"] as (界面: number, 是否启用: boolean) => void)(界面, 是否启用);
}

export function 界面_设置编辑框激活状态(this: void, 界面: number, 是否激活: boolean): void {
  return (原生函数表["DzFrameSetEditBoxActive"] as (界面: number, 是否激活: boolean) => void)(界面, 是否激活);
}

export function 界面_设置编辑框禁用输入法(this: void, 界面: number, 是否禁用: boolean): void {
  return (原生函数表["DzFrameSetEditBoxDisableIme"] as (界面: number, 是否禁用: boolean) => void)(界面, 是否禁用);
}

export function 界面_设字体(this: void, 界面: number, 参数2: string, 高度: number, 参数4: number): void {
  return (原生函数表["DzFrameSetFont"] as (界面: number, 参数2: string, 高度: number, 参数4: number) => void)(界面, 参数2, 高度, 参数4);
}

export function 界面_设置Frame控件忽略点击事件(this: void, 界面: number, 布尔2: boolean): void {
  return (原生函数表["DzFrameSetIgnoreTrackEvents"] as (界面: number, 布尔2: boolean) => void)(界面, 布尔2);
}

export function 界面_设模型2(this: void, 模型界面: number, 模型路径: string, 队伍颜色ID: number): void {
  return (原生函数表["DzFrameSetModel2"] as (模型界面: number, 模型路径: string, 队伍颜色ID: number) => void)(模型界面, 模型路径, 队伍颜色ID);
}

export function 界面_设模型动画(this: void, 模型界面: number, 动画: string): void {
  return (原生函数表["DzFrameSetModelAnimation"] as (模型界面: number, 动画: string) => void)(模型界面, 动画);
}

export function 界面_设模型动画按序号(this: void, 模型界面: number, 整数2: number): void {
  return (原生函数表["DzFrameSetModelAnimationByIndex"] as (模型界面: number, 整数2: number) => void)(模型界面, 整数2);
}

export function 界面_设模型镜头源(this: void, 模型界面: number, x: number, y: number, z: number): void {
  return (原生函数表["DzFrameSetModelCameraSource"] as (模型界面: number, x: number, y: number, z: number) => void)(模型界面, x, y, z);
}

export function 界面_设模型镜头目标(this: void, 模型界面: number, x: number, y: number, z: number): void {
  return (原生函数表["DzFrameSetModelCameraTarget"] as (模型界面: number, x: number, y: number, z: number) => void)(模型界面, x, y, z);
}

export function 界面_设模型颜色(this: void, 模型界面: number, 颜色: number): void {
  return (原生函数表["DzFrameSetModelColor"] as (模型界面: number, 颜色: number) => void)(模型界面, 颜色);
}

export function 界面_设模型启用宽屏幕(this: void, 界面: number, 是否启用: boolean): void {
  return (原生函数表["DzFrameSetModelEnableWideScreen"] as (界面: number, 是否启用: boolean) => void)(界面, 是否启用);
}

export function 界面_设模型矩阵重置(this: void, 模型界面: number): void {
  return (原生函数表["DzFrameSetModelMatReset"] as (模型界面: number) => void)(模型界面);
}

export function 界面_设模型粒子2大小(this: void, 模型界面: number, 缩放: number): void {
  return (原生函数表["DzFrameSetModelParticle2Size"] as (模型界面: number, 缩放: number) => void)(模型界面, 缩放);
}

export function 界面_设模型位置(this: void, 模型界面: number, x: number, y: number, z: number): void {
  return (原生函数表["DzFrameSetModelPosition"] as (模型界面: number, x: number, y: number, z: number) => void)(模型界面, x, y, z);
}

export function 界面_设模型旋转横坐标(this: void, 模型界面: number, x: number): void {
  return (原生函数表["DzFrameSetModelRotateX"] as (模型界面: number, x: number) => void)(模型界面, x);
}

export function 界面_设模型旋转纵坐标(this: void, 模型界面: number, y: number): void {
  return (原生函数表["DzFrameSetModelRotateY"] as (模型界面: number, y: number) => void)(模型界面, y);
}

export function 界面_设模型旋转高度(this: void, 模型界面: number, z: number): void {
  return (原生函数表["DzFrameSetModelRotateZ"] as (模型界面: number, z: number) => void)(模型界面, z);
}

export function 界面_设模型缩放(this: void, 模型界面: number, x: number, y: number, z: number): void {
  return (原生函数表["DzFrameSetModelScale"] as (模型界面: number, x: number, y: number, z: number) => void)(模型界面, x, y, z);
}

export function 界面_设模型大小(this: void, 模型界面: number, 大小: number): void {
  return (原生函数表["DzFrameSetModelSize"] as (模型界面: number, 大小: number) => void)(模型界面, 大小);
}

export function 界面_设模型速度(this: void, 模型界面: number, 速度: number): void {
  return (原生函数表["DzFrameSetModelSpeed"] as (模型界面: number, 速度: number) => void)(模型界面, 速度);
}

export function 界面_设模型贴图(this: void, 模型界面: number, 字符串2: string, 整数3: number): void {
  return (原生函数表["DzFrameSetModelTexture"] as (模型界面: number, 字符串2: string, 整数3: number) => void)(模型界面, 字符串2, 整数3);
}

export function 界面_设模型横坐标(this: void, 模型界面: number, x: number): void {
  return (原生函数表["DzFrameSetModelX"] as (模型界面: number, x: number) => void)(模型界面, x);
}

export function 界面_设模型纵坐标(this: void, 模型界面: number, y: number): void {
  return (原生函数表["DzFrameSetModelY"] as (模型界面: number, y: number) => void)(模型界面, y);
}

export function 界面_设模型高度(this: void, 模型界面: number, z: number): void {
  return (原生函数表["DzFrameSetModelZ"] as (模型界面: number, z: number) => void)(模型界面, z);
}

export function 界面_设置控件全局名字跟绑定整数(this: void, 界面: number, 名称: string, 上下文: number): void {
  return (原生函数表["DzFrameSetNameContext"] as (界面: number, 名称: string, 上下文: number) => void)(界面, 名称, 上下文);
}

export function 界面_设点位(this: void, 界面: number, 点位: number, 相对界面: number, 相对点位: number, x: number, y: number): void {
  return (原生函数表["DzFrameSetPoint"] as (界面: number, 点位: number, 相对界面: number, 相对点位: number, x: number, y: number) => void)(界面, 点位, 相对界面, 相对点位, x, y);
}

export function 界面_设优先级(this: void, 界面: number, 优先级: number): void {
  return (原生函数表["DzFrameSetPriority"] as (界面: number, 优先级: number) => void)(界面, 优先级);
}

export function 界面_设大小(this: void, 界面: number, 宽度: number, 高度: number): void {
  return (原生函数表["DzFrameSetSize"] as (界面: number, 宽度: number, 高度: number) => void)(界面, 宽度, 高度);
}

export function 界面_设界面纹理坐标(this: void, 界面: number, 左: number, 上: number, 右: number, 下: number): void {
  return (原生函数表["DzFrameSetTexCoord"] as (界面: number, 左: number, 上: number, 右: number, 下: number) => void)(界面, 左, 上, 右, 下);
}

export function 界面_设文本(this: void, 界面: number, 文本: string): void {
  return (原生函数表["DzFrameSetText"] as (界面: number, 文本: string) => void)(界面, 文本);
}

export function 界面_设文本对齐(this: void, 界面: number, 参数2: number): void {
  return (原生函数表["DzFrameSetTextAlignment"] as (界面: number, 参数2: number) => void)(界面, 参数2);
}

export function 界面_设文本颜色(this: void, 界面: number, 参数2: number, 单位组: number, 值B: number, 值A: number): void {
  return (原生函数表["DzFrameSetTextColor"] as (界面: number, 参数2: number, 单位组: number, 值B: number, 值A: number) => void)(界面, 参数2, 单位组, 值B, 值A);
}

export function 界面_设置文本控件字间距(this: void, 文本界面: number, 字距: number): void {
  return (原生函数表["DzFrameSetTextFontSpacing"] as (文本界面: number, 字距: number) => void)(文本界面, 字距);
}

export function 界面_设贴图(this: void, 界面: number, 贴图路径: string, 参数3: number): void {
  return (原生函数表["DzFrameSetTexture"] as (界面: number, 贴图路径: string, 参数3: number) => void)(界面, 贴图路径, 参数3);
}

export function 界面_显示(this: void, 界面: number, 是否显示: boolean): void {
  return (原生函数表["DzFrameShow"] as (界面: number, 是否显示: boolean) => void)(界面, 是否显示);
}

export function 界面_世界坐标_解除Frame的绑定(this: void, 界面: number): void {
  return (原生函数表["DzFrameUnBind"] as (界面: number) => void)(界面);
}

export function 界面_解锁右下角区域鼠标焦点限制(this: void, 是否解锁: boolean): void {
  return (原生函数表["DzFrameUnlockMouseRectLimit"] as (是否解锁: boolean) => void)(是否解锁);
}

export function 物品_模型重置旋转缩(this: void, 物品: 物品句柄): void {
  return (原生函数表["DzItemMatReset"] as (物品: 物品句柄) => void)(物品);
}

export function 物品_模型按照横坐标轴旋转(this: void, 物品: 物品句柄, x: number): void {
  return (原生函数表["DzItemMatRotateX"] as (物品: 物品句柄, x: number) => void)(物品, x);
}

export function 物品_模型按照纵坐标轴旋转(this: void, 物品: 物品句柄, y: number): void {
  return (原生函数表["DzItemMatRotateY"] as (物品: 物品句柄, y: number) => void)(物品, y);
}

export function 物品_模型按照高度轴旋转(this: void, 物品: 物品句柄, z: number): void {
  return (原生函数表["DzItemMatRotateZ"] as (物品: 物品句柄, z: number) => void)(物品, z);
}

export function 物品_模型按照横坐标纵坐标高度轴缩放(this: void, 物品: 物品句柄, x: number, y: number, z: number): void {
  return (原生函数表["DzItemMatScale"] as (物品: 物品句柄, x: number, y: number, z: number) => void)(物品, x, y, z);
}

export function 物品_设物品透明度0_255(this: void, 物品: 物品句柄, 颜色: number): void {
  return (原生函数表["DzItemSetAlpha"] as (物品: 物品句柄, 颜色: number) => void)(物品, 颜色);
}

export function 物品_设物品模型(this: void, 物品: 物品句柄, 字符串2: string): void {
  return (原生函数表["DzItemSetModel"] as (物品: 物品句柄, 字符串2: string) => void)(物品, 字符串2);
}

export function 物品_设物品头像(this: void, 物品: 物品句柄, 字符串2: string): void {
  return (原生函数表["DzItemSetPortrait"] as (物品: 物品句柄, 字符串2: string) => void)(物品, 字符串2);
}

export function 物品_物品大小(this: void, 物品: 物品句柄, 大小: number): void {
  return (原生函数表["DzItemSetSize"] as (物品: 物品句柄, 大小: number) => void)(物品, 大小);
}

export function 物品_设物品颜色(this: void, 物品: 物品句柄, 颜色: number): void {
  return (原生函数表["DzItemSetVertexColor"] as (物品: 物品句柄, 颜色: number) => void)(物品, 颜色);
}

export function 加载界面目录(this: void, 路径: string): void {
  return (原生函数表["DzLoadToc"] as (路径: string) => void)(路径);
}

export function 清除所有模型内存缓存(this: void): void {
  return (原生函数表["DzModelRemoveAllFromCache"] as () => void)();
}

export function 清除模型内存缓存(this: void, 路径: string): void {
  return (原生函数表["DzModelRemoveFromCache"] as (路径: string) => void)(路径);
}

export function 打开_群聊群链接(this: void, 链接: string): boolean {
  return (原生函数表["DzOpenQQGroupUrl"] as (链接: string) => boolean)(链接);
}

export function 设特效播放动画(this: void, 特效: 特效句柄, 动画: string, 链接: string): void {
  return (原生函数表["DzPlayEffectAnimation"] as (特效: 特效句柄, 动画: string, 链接: string) => void)(特效, 动画, 链接);
}

export function 玩家_发送聊天消息触发同步事件(this: void, 玩家: 玩家句柄, 消息: string, 接收者: number): void {
  return (原生函数表["DzPlayerSendChat"] as (玩家: 玩家句柄, 消息: string, 接收者: number) => void)(玩家, 消息, 接收者);
}

export function 添加中介命令到队列无目标(this: void, 归属玩家: 玩家句柄, 中立建筑: 单位句柄, 单位ID: number): boolean {
  return (原生函数表["DzQueueIssueNeutralImmediateOrderById"] as (归属玩家: 玩家句柄, 中立建筑: 单位句柄, 单位ID: number) => boolean)(归属玩家, 中立建筑, 单位ID);
}

export function 添加中介命令到队列指定坐标(this: void, 归属玩家: 玩家句柄, 中立建筑: 单位句柄, 单位ID: number, x: number, y: number): boolean {
  return (原生函数表["DzQueueIssueNeutralPointOrderById"] as (归属玩家: 玩家句柄, 中立建筑: 单位句柄, 单位ID: number, x: number, y: number) => boolean)(归属玩家, 中立建筑, 单位ID, x, y);
}

export function 监听建筑选位置(this: void, 回调: () => void): void {
  return (原生函数表["DzRegisterOnBuildLocal"] as (回调: () => void) => void)(回调);
}

export function 监听技能预选目标(this: void, 回调: () => void): void {
  return (原生函数表["DzRegisterOnTargetLocal"] as (回调: () => void) => void)(回调);
}

export function 降低玩家科技等级(this: void, 玩家: 玩家句柄, 整数2: number, 整数3: number): void {
  return (原生函数表["DzRemovePlayerTechResearched"] as (玩家: 玩家句柄, 整数2: number, 整数3: number) => void)(玩家, 整数2, 整数3);
}

export function 复活单位(this: void, 单位: 单位句柄, 玩家: 玩家句柄, 血: number, 实数4: number, x: number, y: number): void {
  return (原生函数表["DzReviveUnit"] as (单位: 单位句柄, 玩家: 玩家句柄, 血: number, 实数4: number, x: number, y: number) => void)(单位, 玩家, 血, 实数4, x, y);
}

export function 游戏_模拟按键窗口消息(this: void, 玩家: 玩家句柄, 键码: number, 是否按下: number): void {
  return (原生函数表["DzSendKeyboard"] as (玩家: 玩家句柄, 键码: number, 是否按下: number) => void)(玩家, 键码, 是否按下);
}

export function 设剪切板(this: void, 字符串1: string): boolean {
  return (原生函数表["DzSetClipboard"] as (字符串1: string) => boolean)(字符串1);
}

export function 装饰物_设置地形装饰物矩阵重置(this: void, 整数1: number): void {
  return (原生函数表["DzSetDoodadsMatReset"] as (整数1: number) => void)(整数1);
}

export function 装饰物_设置地形装饰物矩阵旋转横坐标轴(this: void, 整数1: number, x: number): void {
  return (原生函数表["DzSetDoodadsMatRotateX"] as (整数1: number, x: number) => void)(整数1, x);
}

export function 装饰物_设置地形装饰物矩阵旋转纵坐标轴(this: void, 整数1: number, y: number): void {
  return (原生函数表["DzSetDoodadsMatRotateY"] as (整数1: number, y: number) => void)(整数1, y);
}

export function 装饰物_设置装饰物矩阵旋转高度轴(this: void, 整数1: number, z: number): void {
  return (原生函数表["DzSetDoodadsMatRotateZ"] as (整数1: number, z: number) => void)(整数1, z);
}

export function 装饰物_设置地形装饰物矩阵缩放(this: void, 整数1: number, x: number, y: number, z: number): void {
  return (原生函数表["DzSetDoodadsMatScale"] as (整数1: number, x: number, y: number, z: number) => void)(整数1, x, y, z);
}

export function 设特效播放动画_2(this: void, 特效: 特效句柄, 序号: number, 整数3: number): void {
  return (原生函数表["DzSetEffectAnimation"] as (特效: 特效句柄, 序号: number, 整数3: number) => void)(特效, 序号, 整数3);
}

export function 特效_设置特效迷雾可见(this: void, 特效: 特效句柄, 是否可见: boolean): void {
  return (原生函数表["DzSetEffectFogVisible"] as (特效: 特效句柄, 是否可见: boolean) => void)(特效, 是否可见);
}

export function 特效_设置特效黑色阴影可见(this: void, 特效: 特效句柄, 是否可见: boolean): void {
  return (原生函数表["DzSetEffectMaskVisible"] as (特效: 特效句柄, 是否可见: boolean) => void)(特效, 是否可见);
}

export function 设特效模型(this: void, 特效: 特效句柄, 模型路径: string): void {
  return (原生函数表["DzSetEffectModel"] as (特效: 特效句柄, 模型路径: string) => void)(特效, 模型路径);
}

export function 设特效坐标(this: void, 特效: 特效句柄, x: number, y: number, z: number): void {
  return (原生函数表["DzSetEffectPos"] as (特效: 特效句柄, x: number, y: number, z: number) => void)(特效, x, y, z);
}

export function 特效缩放(this: void, 句柄: 特效句柄, 缩放: number): void {
  return (原生函数表["DzSetEffectScale"] as (句柄: 特效句柄, 缩放: number) => void)(句柄, 缩放);
}

export function 设特效队伍颜色(this: void, 句柄: 特效句柄, 玩家ID: number): void {
  return (原生函数表["DzSetEffectTeamColor"] as (句柄: 特效句柄, 玩家ID: number) => void)(句柄, 玩家ID);
}

export function 设特效透明度(this: void, 特效: 特效句柄, 透明度: number): void {
  return (原生函数表["DzSetEffectVertexAlpha"] as (特效: 特效句柄, 透明度: number) => void)(特效, 透明度);
}

export function 设特效颜色(this: void, 特效: 特效句柄, 颜色: number): void {
  return (原生函数表["DzSetEffectVertexColor"] as (特效: 特效句柄, 颜色: number) => void)(特效, 颜色);
}

export function 特效显示_隐藏(this: void, 句柄: 特效句柄, 是否启用: boolean): void {
  return (原生函数表["DzSetEffectVisible"] as (句柄: 特效句柄, 是否启用: boolean) => void)(句柄, 是否启用);
}

export function 游戏_设置全局移速上_下限(this: void, 建造最小: number, 建造最大: number, 单位最小: number, 单位最大: number, 实数5: number, 实数6: number, 实数7: number, 实数8: number, 实数9: number, 实数10: number): void {
  return (原生函数表["DzSetGlobalUnitMinMaxMoveSpeed"] as (建造最小: number, 建造最大: number, 单位最小: number, 单位最大: number, 实数5: number, 实数6: number, 实数7: number, 实数8: number, 实数9: number, 实数10: number) => void)(建造最小, 建造最大, 单位最小, 单位最大, 实数5, 实数6, 实数7, 实数8, 实数9, 实数10);
}

export function 英雄_设置主属性(this: void, 单位: 单位句柄, 属性: number): boolean {
  return (原生函数表["DzSetHeroPrimaryAttribute"] as (单位: 单位句柄, 属性: number) => boolean)(单位, 属性);
}

export function 英雄_设置属性成长(this: void, 单位: 单位句柄, 整数2: number, 值: number, 保留当前加成: boolean): boolean {
  return (原生函数表["DzSetHeroPrimaryAttributePlus"] as (单位: 单位句柄, 整数2: number, 值: number, 保留当前加成: boolean) => boolean)(单位, 整数2, 值, 保留当前加成);
}

export function 英雄_设置主属性类型(this: void, 单位: 单位句柄, 属性: number, 保留主属性加成: boolean): boolean {
  return (原生函数表["DzSetHeroPrimaryAttributeType"] as (单位: 单位句柄, 属性: number, 保留主属性加成: boolean) => boolean)(单位, 属性, 保留主属性加成);
}

export function 设英雄类型专名(this: void, 单位ID: number, 名称: string): void {
  return (原生函数表["DzSetHeroTypeProperName"] as (单位ID: number, 名称: string) => void)(单位ID, 名称);
}

export function 物品_修改物品碰撞体积(this: void, 物品: 物品句柄, 大小: number): void {
  return (原生函数表["DzSetItemCollisionSize"] as (物品: 物品句柄, 大小: number) => void)(物品, 大小);
}

export function 游戏_限制最高帧数(this: void, 最大FPS: number): void {
  return (原生函数表["DzSetMaxFps"] as (最大FPS: number) => void)(最大FPS);
}

export function 游戏_设置攻速上限(this: void, 实数1: number, 实数2: number): void {
  return (原生函数表["DzSetMinMaxAttackSpeedFactor"] as (实数1: number, 实数2: number) => void)(实数1, 实数2);
}

export function 游戏_设置移速可叠加(this: void, 是否启用: boolean): void {
  return (原生函数表["DzSetMoveSpeedBonusesStack"] as (是否启用: boolean) => void)(是否启用);
}

export function 设粒子2大小(this: void, 控件: 代理句柄, 缩放: number): void {
  return (原生函数表["DzSetPariticle2Size"] as (控件: 代理句柄, 缩放: number) => void)(控件, 缩放);
}

export function 技能_设置技能施法范围(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityArea"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能图标(this: void, 单位: 单位句柄, 技能ID: number, 字符串3: string): boolean {
  return (原生函数表["DzSetUnitAbilityArt"] as (单位: 单位句柄, 技能ID: number, 字符串3: string) => boolean)(单位, 技能ID, 字符串3);
}

export function 技能_设置技能魔法施放回复后摇_2(this: void, 单位: 单位句柄, 技能ID: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityBackSwing"] as (单位: 单位句柄, 技能ID: number, 值: number) => boolean)(单位, 技能ID, 值);
}

export function 技能_设置建造技能模型象牙塔(this: void, 单位: 单位句柄, 技能代码: number, 模型路径: string, 模型缩放: number): boolean {
  return (原生函数表["DzSetUnitAbilityBuildModel"] as (单位: 单位句柄, 技能代码: number, 模型路径: string, 模型缩放: number) => boolean)(单位, 技能代码, 模型路径, 模型缩放);
}

export function 技能_设置建造技能命令编号象牙塔(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityBuildOrderId"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能按钮位置(this: void, 单位: 单位句柄, 技能代码: number, x: number, y: number): boolean {
  return (原生函数表["DzSetUnitAbilityButtonPos"] as (单位: 单位句柄, 技能代码: number, x: number, y: number) => boolean)(单位, 技能代码, x, y);
}

export function 技能_设置技能魔法施放点前摇(this: void, 单位: 单位句柄, 技能ID: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityCastPoint"] as (单位: 单位句柄, 技能ID: number, 值: number) => boolean)(单位, 技能ID, 值);
}

export function 技能_设置技能魔法施法时间(this: void, 单位: 单位句柄, 技能ID: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityCastTime"] as (单位: 单位句柄, 技能ID: number, 值: number) => boolean)(单位, 技能ID, 值);
}

export function 技能_设置技能冷却时间(this: void, 单位: 单位句柄, 技能代码: number, 冷却: number, 最大冷却: number): boolean {
  return (原生函数表["DzSetUnitAbilityCool"] as (单位: 单位句柄, 技能代码: number, 冷却: number, 最大冷却: number) => boolean)(单位, 技能代码, 冷却, 最大冷却);
}

export function 技能_设置技能魔法消耗(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityCost"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能dataA(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityDataA"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能dataB(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityDataB"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能dataC(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityDataC"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能dataD(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityDataD"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能dataE(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityDataE"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能禁用(this: void, 单位: 单位句柄, 技能ID: number): boolean {
  return (原生函数表["DzSetUnitAbilityDisable"] as (单位: 单位句柄, 技能ID: number) => boolean)(单位, 技能ID);
}

export function 技能_设置技能持续时间普通(this: void, 单位: 单位句柄, 技能ID: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityDuration"] as (单位: 单位句柄, 技能ID: number, 值: number) => boolean)(单位, 技能ID, 值);
}

export function 技能_设置技能启用(this: void, 单位: 单位句柄, 技能ID: number): boolean {
  return (原生函数表["DzSetUnitAbilityEnable"] as (单位: 单位句柄, 技能ID: number) => boolean)(单位, 技能ID);
}

export function 技能_工程升级_替换技能要相同模板(this: void, 单位: 单位句柄, 旧ID: number, 新ID: number, 更新英雄技能: boolean): boolean {
  return (原生函数表["DzSetUnitAbilityEngineeringUpgrade"] as (单位: 单位句柄, 旧ID: number, 新ID: number, 更新英雄技能: boolean) => boolean)(单位, 旧ID, 新ID, 更新英雄技能);
}

export function 技能_工程升级_取消替换技能(this: void, 单位: 单位句柄, 旧ID: number): boolean {
  return (原生函数表["DzSetUnitAbilityEngineeringUpgradeCancel"] as (单位: 单位句柄, 旧ID: number) => boolean)(单位, 旧ID);
}

export function 技能_设置技能持续时间英雄(this: void, 单位: 单位句柄, 技能ID: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityHeroDuration"] as (单位: 单位句柄, 技能ID: number, 值: number) => boolean)(单位, 技能ID, 值);
}

export function 技能_设置技能快捷键(this: void, 单位: 单位句柄, 技能代码: number, 键名: string): boolean {
  return (原生函数表["DzSetUnitAbilityHotkey"] as (单位: 单位句柄, 技能代码: number, 键名: string) => boolean)(单位, 技能代码, 键名);
}

export function 技能_设置技能投射物弧度(this: void, 单位: 单位句柄, 技能ID: number, 弹道弧度: number): boolean {
  return (原生函数表["DzSetUnitAbilityMissileArc"] as (单位: 单位句柄, 技能ID: number, 弹道弧度: number) => boolean)(单位, 技能ID, 弹道弧度);
}

export function 技能_设置技能投射物模型(this: void, 单位: 单位句柄, 技能ID: number, 弹道美术: string): boolean {
  return (原生函数表["DzSetUnitAbilityMissileArt"] as (单位: 单位句柄, 技能ID: number, 弹道美术: string) => boolean)(单位, 技能ID, 弹道美术);
}

export function 技能_设置技能投射物数量弹幕攻击(this: void, 单位: 单位句柄, 技能ID: number, 弹道数量: number): boolean {
  return (原生函数表["DzSetUnitAbilityMissileCount"] as (单位: 单位句柄, 技能ID: number, 弹道数量: number) => boolean)(单位, 技能ID, 弹道数量);
}

export function 技能_设置技能投射物伤害弹幕攻击(this: void, 单位: 单位句柄, 技能ID: number, 伤害: number, 最大伤害: number, 参数5: any, 参数6: any): boolean {
  return (原生函数表["DzSetUnitAbilityMissileDamage"] as (单位: 单位句柄, 技能ID: number, 伤害: number, 最大伤害: number, 参数5: any, 参数6: any) => boolean)(单位, 技能ID, 伤害, 最大伤害, 参数5, 参数6);
}

export function 技能_设置技能投射物允许自导(this: void, 单位: 单位句柄, 技能ID: number, 弹道追踪: boolean): boolean {
  return (原生函数表["DzSetUnitAbilityMissileHoming"] as (单位: 单位句柄, 技能ID: number, 弹道追踪: boolean) => boolean)(单位, 技能ID, 弹道追踪);
}

export function 技能_设置技能投射物速度(this: void, 单位: 单位句柄, 技能ID: number, 弹道速度: number): boolean {
  return (原生函数表["DzSetUnitAbilityMissileSpeed"] as (单位: 单位句柄, 技能ID: number, 弹道速度: number) => boolean)(单位, 技能ID, 弹道速度);
}

export function 技能_设置技能命令编号(this: void, 单位: 单位句柄, 技能ID: number, 命令ID: number): boolean {
  return (原生函数表["DzSetUnitAbilityOrderId"] as (单位: 单位句柄, 技能ID: number, 命令ID: number) => boolean)(单位, 技能ID, 命令ID);
}

export function 技能_设置技能施法距离(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityRange"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能等级要求(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityReqLevel"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置魔法书技能列表添加新技能(this: void, 单位: 单位句柄, 技能ID: number, 添加技能ID: number): boolean {
  return (原生函数表["DzSetUnitAbilitySpellBookAddAbility"] as (单位: 单位句柄, 技能ID: number, 添加技能ID: number) => boolean)(单位, 技能ID, 添加技能ID);
}

export function 技能_设置魔法书的技能列表(this: void, 单位: 单位句柄, 技能ID: number, 技能列表: string, 保存冷却: boolean): boolean {
  return (原生函数表["DzSetUnitAbilitySpellBookList"] as (单位: 单位句柄, 技能ID: number, 技能列表: string, 保存冷却: boolean) => boolean)(单位, 技能ID, 技能列表, 保存冷却);
}

export function 技能_设置魔法书技能列表移除指定技能(this: void, 单位: 单位句柄, 技能ID: number, 移除技能ID: number): boolean {
  return (原生函数表["DzSetUnitAbilitySpellBookRemoveAbility"] as (单位: 单位句柄, 技能ID: number, 移除技能ID: number) => boolean)(单位, 技能ID, 移除技能ID);
}

export function 技能_设置技能目标允许(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityTargs"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置技能科技条件达成(this: void, 单位: 单位句柄, 技能ID: number, 达成: boolean): boolean {
  return (原生函数表["DzSetUnitAbilityTechReach"] as (单位: 单位句柄, 技能ID: number, 达成: boolean) => boolean)(单位, 技能ID, 达成);
}

export function 技能_设置技能科技条件文本(this: void, 单位: 单位句柄, 技能ID: number, 提示: string): boolean {
  return (原生函数表["DzSetUnitAbilityTechReachTip"] as (单位: 单位句柄, 技能ID: number, 提示: string) => boolean)(单位, 技能ID, 提示);
}

export function 技能_设置技能提示(this: void, 单位: 单位句柄, 技能ID: number, 提示: string): boolean {
  return (原生函数表["DzSetUnitAbilityTip"] as (单位: 单位句柄, 技能ID: number, 提示: string) => boolean)(单位, 技能ID, 提示);
}

export function 技能_设置技能提示扩展(this: void, 单位: 单位句柄, 技能ID: number, 扩展提示: string): boolean {
  return (原生函数表["DzSetUnitAbilityUberTip"] as (单位: 单位句柄, 技能ID: number, 扩展提示: string) => boolean)(单位, 技能ID, 扩展提示);
}

export function 技能_设置建造技能单位编号象牙塔(this: void, 单位: 单位句柄, 技能代码: number, 值: number): boolean {
  return (原生函数表["DzSetUnitAbilityUnitId"] as (单位: 单位句柄, 技能代码: number, 值: number) => boolean)(单位, 技能代码, 值);
}

export function 技能_设置刷新数据(this: void, 单位: 单位句柄, 技能ID: number): boolean {
  return (原生函数表["DzSetUnitAbilityUpdate"] as (单位: 单位句柄, 技能ID: number) => boolean)(单位, 技能ID);
}

export function 单位_设置单位作为目标类型(this: void, 单位: 单位句柄, 目标类型: number): void {
  return (原生函数表["DzSetUnitAsAttackTargetType"] as (单位: 单位句柄, 目标类型: number) => void)(单位, 目标类型);
}

export function 单位_设置单位攻击1目标允许(this: void, 单位: 单位句柄, 目标类型: number): void {
  return (原生函数表["DzSetUnitAttack1TargetType"] as (单位: 单位句柄, 目标类型: number) => void)(单位, 目标类型);
}

export function 单位_设置单位攻击2目标允许(this: void, 单位: 单位句柄, 目标类型: number): void {
  return (原生函数表["DzSetUnitAttack2TargetType"] as (单位: 单位句柄, 目标类型: number) => void)(单位, 目标类型);
}

export function 单位_设置攻击最大目标数(this: void, 单位: 单位句柄, 序号: number, 目标数量: number): boolean {
  return (原生函数表["DzSetUnitAttackTargetCount"] as (单位: 单位句柄, 序号: number, 目标数量: number) => boolean)(单位, 序号, 目标数量);
}

export function 设单位攻击类型(this: void, 单位: 单位句柄, 序号: number, 攻击类型: any): void {
  return (原生函数表["DzSetUnitAttackType"] as (单位: 单位句柄, 序号: number, 攻击类型: any) => void)(单位, 序号, 攻击类型);
}

export function 单位_设置魔法施放回复后摇(this: void, 单位: 单位句柄, 实数2: number): boolean {
  return (原生函数表["DzSetUnitBackSwing"] as (单位: 单位句柄, 实数2: number) => boolean)(单位, 实数2);
}

export function 单位_设置魔法施放点前摇(this: void, 单位: 单位句柄, 施法点位: number): boolean {
  return (原生函数表["DzSetUnitCastPoint"] as (单位: 单位句柄, 施法点位: number) => boolean)(单位, 施法点位);
}

export function 单位_修改单位碰撞体积(this: void, 单位: 单位句柄, 大小: number): void {
  return (原生函数表["DzSetUnitCollisionSize"] as (单位: 单位句柄, 大小: number) => void)(单位, 大小);
}

export function 设单位数据缓存整数(this: void, 单位ID: number, ID: number, 序号: number, 整数4: number): void {
  return (原生函数表["DzSetUnitDataCacheInteger"] as (单位ID: number, ID: number, 序号: number, 整数4: number) => void)(单位ID, ID, 序号, 整数4);
}

export function 设单位防御类型(this: void, 单位: 单位句柄, 防御类型: number): void {
  return (原生函数表["DzSetUnitDefenseType"] as (单位: 单位句柄, 防御类型: number) => void)(单位, 防御类型);
}

export function 设单位描述(this: void, 单位: 单位句柄, 值: string): void {
  return (原生函数表["DzSetUnitDescription"] as (单位: 单位句柄, 值: string) => void)(单位, 值);
}

export function 单位_设置单位屏蔽控制命令模拟失控(this: void, 单位: 单位句柄, 是否禁用: boolean): void {
  return (原生函数表["DzSetUnitDisableControlOrder"] as (单位: 单位句柄, 是否禁用: boolean) => void)(单位, 是否禁用);
}

export function 单位_设置单位屏蔽本地命令模拟失控(this: void, 单位: 单位句柄, 是否禁用: boolean): void {
  return (原生函数表["DzSetUnitDisableLocalOrder"] as (单位: 单位句柄, 是否禁用: boolean) => void)(单位, 是否禁用);
}

export function 单位_设置单位禁用攻击(this: void, 单位: 单位句柄, 是否禁用: boolean): void {
  return (原生函数表["DzUnitDisableAttack"] as (单位: 单位句柄, 是否禁用: boolean) => void)(单位, 是否禁用);
}

export function 单位_设置单位是否忽略点击(this: void, 单位: 单位句柄, 布尔2: boolean): void {
  return (原生函数表["DzSetUnitHitIgnore"] as (单位: 单位句柄, 布尔2: boolean) => void)(单位, 布尔2);
}

export function 单位_设置每秒生命恢复(this: void, 单位: 单位句柄, 回复: number): boolean {
  return (原生函数表["DzSetUnitLifeRegen"] as (单位: 单位句柄, 回复: number) => boolean)(单位, 回复);
}

export function 单位_设置每秒魔法恢复(this: void, 单位: 单位句柄, 回复: number): boolean {
  return (原生函数表["DzSetUnitManaRegen"] as (单位: 单位句柄, 回复: number) => boolean)(单位, 回复);
}

export function 单位_设置最高移动速度(this: void, 单位: 单位句柄, 速度: number, 忽略变形: boolean): boolean {
  return (原生函数表["DzSetUnitMaxSpeed"] as (单位: 单位句柄, 速度: number, 忽略变形: boolean) => boolean)(单位, 速度, 忽略变形);
}

export function 单位_设置最低移动速度(this: void, 单位: 单位句柄, 速度: number, 忽略变形: boolean): boolean {
  return (原生函数表["DzSetUnitMinSpeed"] as (单位: 单位句柄, 速度: number, 忽略变形: boolean) => boolean)(单位, 速度, 忽略变形);
}

export function 设单位普攻弹道弧度(this: void, 单位: 单位句柄, 弧度: number): void {
  return (原生函数表["DzSetUnitMissileArc"] as (单位: 单位句柄, 弧度: number) => void)(单位, 弧度);
}

export function 设单位普攻弹道自导允许(this: void, 单位: 单位句柄, 是否启用: boolean): void {
  return (原生函数表["DzSetUnitMissileHoming"] as (单位: 单位句柄, 是否启用: boolean) => void)(单位, 是否启用);
}

export function 设单位普攻弹道模型(this: void, 单位: 单位句柄, 模型路径: string): void {
  return (原生函数表["DzSetUnitMissileModel"] as (单位: 单位句柄, 模型路径: string) => void)(单位, 模型路径);
}

export function 设单位普攻弹道速度(this: void, 单位: 单位句柄, 速度: number): void {
  return (原生函数表["DzSetUnitMissileSpeed"] as (单位: 单位句柄, 速度: number) => void)(单位, 速度);
}

export function 设单位名字(this: void, 单位: 单位句柄, 名称: string): void {
  return (原生函数表["DzSetUnitName"] as (单位: 单位句柄, 名称: string) => void)(单位, 名称);
}

export function 设单位头像模型(this: void, 单位: 单位句柄, 模型路径: string): void {
  return (原生函数表["DzSetUnitPortrait"] as (单位: 单位句柄, 模型路径: string) => void)(单位, 模型路径);
}

export function 设单位的鼠标指向UI和血条显示_隐藏(this: void, 单位: 单位句柄, 是否显示: boolean): void {
  return (原生函数表["DzSetUnitPreselectUIVisible"] as (单位: 单位句柄, 是否显示: boolean) => void)(单位, 是否显示);
}

export function 设英雄称谓(this: void, 单位: 单位句柄, 名称: string): void {
  return (原生函数表["DzSetUnitProperName"] as (单位: 单位句柄, 名称: string) => void)(单位, 名称);
}

export function 单位_修改单位选择圈缩放(this: void, 单位: 单位句柄, 缩放: number): void {
  return (原生函数表["DzSetUnitSelectScale"] as (单位: 单位句柄, 缩放: number) => void)(单位, 缩放);
}

export function 设单位类型名称(this: void, 单位ID: number, 名称: string): void {
  return (原生函数表["DzSetUnitTypeName"] as (单位ID: number, 名称: string) => void)(单位ID, 名称);
}

export function 单位_设置横坐标纵坐标坐标不打断命令(this: void, 单位: 单位句柄, x: number, y: number): boolean {
  return (原生函数表["DzSetUnitXY"] as (单位: 单位句柄, x: number, y: number) => boolean)(单位, x, y);
}

export function 单位缩放(this: void, 单位: 控件句柄, 缩放: number): void {
  return (原生函数表["DzSetWidgetSpriteScale"] as (单位: 控件句柄, 缩放: number) => void)(单位, 缩放);
}

export function 设控件贴图(this: void, 句柄: 代理句柄, 字符串2: string, 替换ID: number): void {
  return (原生函数表["DzSetWidgetTexture"] as (句柄: 代理句柄, 字符串2: string, 替换ID: number) => void)(句柄, 字符串2, 替换ID);
}

export function 简单消息界面_显示游戏提示信息(this: void, 界面: number, 文本: string, 颜色: number, 持续时间: number, 布尔5: boolean): void {
  return (原生函数表["DzSimpleMessageFrameAddMessage"] as (界面: number, 文本: string, 颜色: number, 持续时间: number, 布尔5: boolean) => void)(界面, 文本, 颜色, 持续时间, 布尔5);
}

export function 简单消息界面_清理游戏提示信息(this: void, 界面: number): void {
  return (原生函数表["DzSimpleMessageFrameClear"] as (界面: number) => void)(界面);
}

export function 漂浮字_设漂浮文字字体(this: void, 文件名: string): void {
  return (原生函数表["DzTextTagSetFont"] as (文件名: string) => void)(文件名);
}

export function 漂浮字_设漂浮文字阴影颜色(this: void, 类型: 漂浮字句柄, 颜色: number): void {
  return (原生函数表["DzTextTagSetShadowColor"] as (类型: 漂浮字句柄, 颜色: number) => void)(类型, 颜色);
}

export function 漂浮字_设漂浮文字透明度(this: void, 类型: 漂浮字句柄, 透明度: number): void {
  return (原生函数表["DzTextTagSetStartAlpha"] as (类型: 漂浮字句柄, 透明度: number) => void)(类型, 透明度);
}

export function 设帧率显示_隐藏(this: void, 显示: boolean): void {
  return (原生函数表["DzToggleFPS"] as (显示: boolean) => void)(显示);
}

export function 平台_触发注册按键事件按代码(this: void, 触发器: any, 按键代码: number, 参数3: number, 同步: boolean, 参数5: () => void): void {
  return (原生函数表["DzTriggerRegisterKeyEventByCode"] as (触发器: any, 按键代码: number, 参数3: number, 同步: boolean, 参数5: () => void) => void)(触发器, 按键代码, 参数3, 同步, 参数5);
}

export function 解除绑定特效(this: void, 特效: 特效句柄): void {
  return (原生函数表["DzUnbindEffect"] as (特效: 特效句柄) => void)(特效);
}

export function 单位_清除单位命令队列(this: void, 单位: 单位句柄, 布尔2: boolean): void {
  return (原生函数表["DzUnitOrdersClear"] as (单位: 单位句柄, 布尔2: boolean) => void)(单位, 布尔2);
}

export function 单位_执行单位的命令队列(this: void, 单位: 单位句柄): void {
  return (原生函数表["DzUnitOrdersExec"] as (单位: 单位句柄) => void)(单位);
}

export function 单位_强制停止单位当前命令(this: void, 单位: 单位句柄, 清空队列: boolean): void {
  return (原生函数表["DzUnitOrdersForceStop"] as (单位: 单位句柄, 清空队列: boolean) => void)(单位, 清空队列);
}

export function 单位_反转单位命令队列(this: void, 单位: 单位句柄): void {
  return (原生函数表["DzUnitOrdersReverse"] as (单位: 单位句柄) => void)(单位);
}

export function 单位_设单位实例的移动类型(this: void, 单位: 单位句柄, 移动类型: string): void {
  return (原生函数表["DzUnitSetMoveType"] as (单位: 单位句柄, 移动类型: string) => void)(单位, 移动类型);
}

export function 单位_界面添加等级数组整数(this: void, 单位ID: number, ID: number, 整数3: number, 整数4: number): void {
  return (原生函数表["DzUnitUIAddLevelArrayInteger"] as (单位ID: number, ID: number, 整数3: number, 整数4: number) => void)(单位ID, ID, 整数3, 整数4);
}

export function 解锁BLP像素限制(this: void, 是否启用: boolean): void {
  return (原生函数表["DzUnlockBlpSizeLimit"] as (是否启用: boolean) => void)(是否启用);
}

export function 解锁JASS字节码限制(this: void, 是否启用: boolean): void {
  return (原生函数表["DzUnlockOpCodeLimit"] as (是否启用: boolean) => void)(是否启用);
}

export function 自定义指定单位的小地图图标(this: void, 单位: 单位句柄, 路径: string): void {
  return (原生函数表["DzWidgetSetMinimapIcon"] as (单位: 单位句柄, 路径: string) => void)(单位, 路径);
}

export function 开启_关闭自定义指定单位的小地图图标(this: void, 单位: 单位句柄, 是否启用: boolean): void {
  return (原生函数表["DzWidgetSetMinimapIconEnable"] as (单位: 单位句柄, 是否启用: boolean) => void)(单位, 是否启用);
}

export function 硬件_设置游戏窗口位置(this: void, x: number, y: number): void {
  return (原生函数表["DzWindowSetPoint"] as (x: number, y: number) => void)(x, y);
}

export function 硬件_设置游戏窗口大小(this: void, 宽度: number, 高度: number): void {
  return (原生函数表["DzWindowSetSize"] as (宽度: number, 高度: number) => void)(宽度, 高度);
}

export function 打印调试信息到平台日志(this: void, 消息: string): void {
  return (原生函数表["DzWriteLog"] as (消息: string) => void)(消息);
}

export function 关闭_工作表(this: void, 整数1: number): boolean {
  return (原生函数表["DzXlsxClose"] as (整数1: number) => boolean)(整数1);
}

export function 打开_Excel文件(this: void, 文件路径: string): number {
  return (原生函数表["DzXlsxOpen"] as (文件路径: string) => number)(文件路径);
}

export function 扩展_禁用单位碰撞(this: void, 单位: any, 类型: number): void {
  return (原生函数表["EXDisableUnitCollision"] as (单位: any, 类型: number) => void)(单位, 类型);
}

export function 扩展_特效矩阵旋转高度(this: void, E: any, 角度: number): void {
  return (原生函数表["EXEffectMatRotateZ"] as (E: any, 角度: number) => void)(E, 角度);
}

export function 扩展_特效矩阵缩放(this: void, E: any, x: number, y: number, z: number): void {
  return (原生函数表["EXEffectMatScale"] as (E: any, x: number, y: number, z: number) => void)(E, x, y, z);
}

export function 扩展_启用单位碰撞(this: void, 单位: any, 类型: number): void {
  return (原生函数表["EXEnableUnitCollision"] as (单位: any, 类型: number) => void)(单位, 类型);
}

export function 单位扩展_暂停(this: void, 单位: any, 参数2: boolean): void {
  return (原生函数表["EXPauseUnit"] as (单位: any, 参数2: boolean) => void)(单位, 参数2);
}

export function 技能扩展_设杂项DataA(this: void, 技能: any, 单位ID: number): boolean {
  return (原生函数表["EXSetAbilityAEmeDataA"] as (技能: any, 单位ID: number) => boolean)(技能, 单位ID);
}

export function 技能扩展_设整数数据(this: void, 技能: any, 等级: number, 数据类型: number, 值: number): boolean {
  return (原生函数表["EXSetAbilityDataInteger"] as (技能: any, 等级: number, 数据类型: number, 值: number) => boolean)(技能, 等级, 数据类型, 值);
}

export function 技能扩展_设实数数据(this: void, 技能: any, 等级: number, 数据类型: number, 值: number): boolean {
  return (原生函数表["EXSetAbilityDataReal"] as (技能: any, 等级: number, 数据类型: number, 值: number) => boolean)(技能, 等级, 数据类型, 值);
}

export function 技能扩展_设字符串数据(this: void, 技能: any, 等级: number, 数据类型: number, 值: string): boolean {
  return (原生函数表["EXSetAbilityDataString"] as (技能: any, 等级: number, 数据类型: number, 值: string) => boolean)(技能, 等级, 数据类型, 值);
}

export function 技能扩展_设状态(this: void, 技能: any, 状态类型: number, 值: number): boolean {
  return (原生函数表["EXSetAbilityState"] as (技能: any, 状态类型: number, 值: number) => boolean)(技能, 状态类型, 值);
}

export function 扩展_设特效大小(this: void, E: any, 大小: number): void {
  return (原生函数表["EXSetEffectSize"] as (E: any, 大小: number) => void)(E, 大小);
}

export function 扩展_设特效速度(this: void, E: any, 速度: number): void {
  return (原生函数表["EXSetEffectSpeed"] as (E: any, 速度: number) => void)(E, 速度);
}

export function 扩展_设特效高度(this: void, 特效: any, z: number): void {
  return (原生函数表["EXSetEffectZ"] as (特效: any, z: number) => void)(特效, z);
}

export function 物品扩展_设字符串数据(this: void, 物品编码: number, 数据类型: number, 值: string): boolean {
  return (原生函数表["EXSetItemDataString"] as (物品编码: number, 数据类型: number, 值: string) => boolean)(物品编码, 数据类型, 值);
}

export function 单位扩展_设数组字符串(this: void, 单位ID: number, ID: number, 整数3: number, 名称: string): boolean {
  return (原生函数表["EXSetUnitArrayString"] as (单位ID: number, ID: number, 整数3: number, 名称: string) => boolean)(单位ID, ID, 整数3, 名称);
}

export function 单位扩展_设碰撞类型(this: void, 是否启用: boolean, 单位: any, 类型: number): void {
  return (原生函数表["EXSetUnitCollisionType"] as (是否启用: boolean, 单位: any, 类型: number) => void)(是否启用, 单位, 类型);
}

export function 单位扩展_设朝向(this: void, 单位: any, 角度: number): void {
  return (原生函数表["EXSetUnitFacing"] as (单位: any, 角度: number) => void)(单位, 角度);
}

export function 单位扩展_设整数(this: void, 单位ID: number, ID: number, 整数3: number): boolean {
  return (原生函数表["EXSetUnitInteger"] as (单位ID: number, ID: number, 整数3: number) => boolean)(单位ID, ID, 整数3);
}

export function 单位扩展_设移动类型(this: void, 单位: any, 类型: number): void {
  return (原生函数表["EXSetUnitMoveType"] as (单位: any, 类型: number) => void)(单位, 类型);
}

export function 平台扩展_批量存档添加条目(this: void, 玩家: 玩家句柄, 键名: string, 值: string, 布尔4: boolean): boolean {
  return (原生函数表["KKApiAddBatchSaveArchive"] as (玩家: 玩家句柄, 键名: string, 值: string, 布尔4: boolean) => boolean)(玩家, 键名, 值, 布尔4);
}

export function 平台扩展_添加条目_布尔值(this: void, 玩家: 玩家句柄, 键名: string, 值: boolean): void {
  return (原生函数表["KKApiAddBatchSaveArchiveBoolean"] as (玩家: 玩家句柄, 键名: string, 值: boolean) => void)(玩家, 键名, 值);
}

export function 平台扩展_添加条目_整数(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["KKApiAddBatchSaveArchiveInteger"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 平台扩展_添加条目_实数(this: void, 玩家: 玩家句柄, 键名: string, 值: number): void {
  return (原生函数表["KKApiAddBatchSaveArchiveReal"] as (玩家: 玩家句柄, 键名: string, 值: number) => void)(玩家, 键名, 值);
}

export function 平台扩展_添加条目_字符串(this: void, 玩家: 玩家句柄, 键名: string, 值: string): void {
  return (原生函数表["KKApiAddBatchSaveArchiveString"] as (玩家: 玩家句柄, 键名: string, 值: string) => void)(玩家, 键名, 值);
}

export function 平台扩展_批量存档开始保存(this: void, 玩家: 玩家句柄): boolean {
  return (原生函数表["KKApiBeginBatchSaveArchive"] as (玩家: 玩家句柄) => boolean)(玩家);
}

export function 平台扩展_批量存档结束保存(this: void, 玩家: 玩家句柄, 布尔2: boolean): boolean {
  return (原生函数表["KKApiEndBatchSaveArchive"] as (玩家: 玩家句柄, 布尔2: boolean) => boolean)(玩家, 布尔2);
}

export function 平台扩展_初始化平台键位显示设置(this: void, 玩家: 玩家句柄, 整数2: number, 字符串3: string, 数据: string): boolean {
  return (原生函数表["KKApiInitializeGameKey"] as (玩家: 玩家句柄, 整数2: number, 字符串3: string, 数据: string) => boolean)(玩家, 整数2, 字符串3, 数据);
}

export function 平台扩展_随机只读存档生成随机数(this: void, 玩家: 玩家句柄, 键名: string, 分组键: string): boolean {
  return (原生函数表["KKApiRequestBackendLogic"] as (玩家: 玩家句柄, 键名: string, 分组键: string) => boolean)(玩家, 键名, 分组键);
}

export function 平台扩展_技能按钮_鼠标点击技能按钮(this: void, 整数1: number, 鼠标类型: number): void {
  return (原生函数表["KKCommandButtonClick"] as (整数1: number, 鼠标类型: number) => void)(整数1, 鼠标类型);
}

export function 平台扩展_界面_设置技能_物品按钮的冷却模型缩放大小(this: void, 整数1: number, 大小: number): void {
  return (原生函数表["KKCommandSetCooldownModelSize"] as (整数1: number, 大小: number) => void)(整数1, 大小);
}

export function 平台扩展_界面_设置技能_物品按钮的冷却模型缩放指定宽高比例(this: void, 整数1: number, 宽度: number, 高度: number): void {
  return (原生函数表["KKCommandSetCooldownModelSize2"] as (整数1: number, 宽度: number, 高度: number) => void)(整数1, 宽度, 高度);
}

export function 平台扩展_技能按钮_删除技能按钮(this: void, 整数1: number): void {
  return (原生函数表["KKDestroyCommandButton"] as (整数1: number) => void)(整数1);
}

export function 平台扩展_世界坐标_绑定Frame到物品实时位置(this: void, 界面: number, 单位: 控件句柄, 世界x: number, 世界y: number, 世界z: number, 屏幕x: number, 屏幕y: number, 雾中可见: boolean, 物品可见: boolean): void {
  return (原生函数表["KKFrameBindItem"] as (界面: number, 单位: 控件句柄, 世界x: number, 世界y: number, 世界z: number, 屏幕x: number, 屏幕y: number, 雾中可见: boolean, 物品可见: boolean) => void)(界面, 单位, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见, 物品可见);
}

export function 平台扩展_技能按钮_绑定单位技能(this: void, 整数1: number, 单位: 单位句柄, 技能代码: number): void {
  return (原生函数表["KKSetCommandUnitAbility"] as (整数1: number, 单位: 单位句柄, 技能代码: number) => void)(整数1, 单位, 技能代码);
}

export function 平台扩展_设单位整数物编数据(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWESetUnitDataCacheInteger"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据农民可建造建筑(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddBuildsIds"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据制造的物品(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddMakesItemIds"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据科技需求值(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddRequiresAmounts"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据科技需求(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddRequiresTechcode"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据科技需求_2(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddRequiresUnitCode"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据可研究的科技(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddResearchesIds"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据出售的物品(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddSellsItemIds"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据出售的单位(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddSellsUnitIds"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据可训练的单位(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddTrainsIds"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}

export function 平台扩展_设单位物编数据建筑升级(this: void, 单位ID: number, ID: number, 整数3: number): void {
  return (原生函数表["KKWEUnitUIAddUpgradesIds"] as (单位ID: number, ID: number, 整数3: number) => void)(单位ID, ID, 整数3);
}
