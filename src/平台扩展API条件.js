/** @noSelfInFile */
const 平台原生表 = require("jass.japi");
const 原生函数表 = 平台原生表;
export function 地图_关闭U币快速购买界面(玩家) {
    return 原生函数表["DzAPI_Map_CancelQuickBuy"](玩家);
}
export function 地图_使用地图商城道具数量型(玩家, 键名, 数量) {
    return 原生函数表["DzAPI_Map_ConsumeMallItem"](玩家, 键名, 数量);
}
export function 地图_开启_关闭游戏内辅助功能(玩家, 选项, 是否启用) {
    return 原生函数表["DzAPI_Map_EnablePlatformSettings"](玩家, 选项, 是否启用);
}
export function 地图_取服务器上的布尔变量(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetStoredBoolean"](玩家, 键名);
}
export function 地图_玩家是否拥有地图商城道具(玩家, 键名) {
    return 原生函数表["DzAPI_Map_HasMallItem"](玩家, 键名);
}
export function 地图_玩家是否当前地图作者(玩家) {
    return 原生函数表["DzAPI_Map_IsAuthor"](玩家);
}
export function 地图_玩家是否平台认证的主播(玩家) {
    return 原生函数表["DzAPI_Map_IsBlueVIP"](玩家);
}
export function 地图_玩家是否平台认证的鉴赏家(玩家) {
    return 原生函数表["DzAPI_Map_IsConnoisseur"](玩家);
}
export function 地图_本局游戏是否处于平台自测服() {
    return 原生函数表["DzAPI_Map_IsMapTest"]();
}
export function 地图_玩家是否平台尊享会员(玩家) {
    return 原生函数表["DzAPI_Map_IsPlatformVIP"](玩家);
}
export function 地图_玩家是否为真实玩家(玩家) {
    return 原生函数表["DzAPI_Map_IsPlayer"](玩家);
}
export function 地图_玩家是否装备指定平台装饰(玩家, 皮肤类型, ID) {
    return 原生函数表["DzAPI_Map_IsPlayerUsingSkin"](玩家, 皮肤类型, ID);
}
export function 地图_玩家是否平台认证的职业选手(玩家) {
    return 原生函数表["DzAPI_Map_IsRedVIP"](玩家);
}
export function 地图_本局游戏是否天梯排位赛() {
    return 原生函数表["DzAPI_Map_IsRPGLadder"]();
}
export function 地图_本局游戏是否处于角色扮演游戏大厅() {
    return 原生函数表["DzAPI_Map_IsRPGLobby"]();
}
export function 地图_本局游戏是否快速匹配() {
    return 原生函数表["DzAPI_Map_IsRPGQuickMatch"]();
}
export function 地图_玩家在指定地图累计消费金额区间1到199(玩家, 地图ID) {
    return 原生函数表["DzAPI_Map_MapsConsumeLv1"](玩家, 地图ID);
}
export function 地图_玩家在指定地图累计消费金额区间200到499(玩家, 地图ID) {
    return 原生函数表["DzAPI_Map_MapsConsumeLv2"](玩家, 地图ID);
}
export function 地图_玩家在指定地图累计消费金额区间500到999(玩家, 地图ID) {
    return 原生函数表["DzAPI_Map_MapsConsumeLv3"](玩家, 地图ID);
}
export function 地图_玩家在指定地图累计消费金额区间1000以上(玩家, 地图ID) {
    return 原生函数表["DzAPI_Map_MapsConsumeLv4"](玩家, 地图ID);
}
export function 地图_打开地图商城道具购买界面(玩家, 键名) {
    return 原生函数表["DzAPI_Map_OpenMall"](玩家, 键名);
}
export function 地图_玩家标记(玩家, 标签) {
    return 原生函数表["DzAPI_Map_PlayerFlags"](玩家, 标签);
}
export function 地图_玩家地图商城道具是否读取成功(玩家) {
    return 原生函数表["DzAPI_Map_PlayerLoadedItems"](玩家);
}
export function 地图_使用U币快速购买地图商城道具(玩家, 键名, 数量, 秒数) {
    return 原生函数表["DzAPI_Map_QuickBuy"](玩家, 键名, 数量, 秒数);
}
export function 地图_是否回流_收藏过地图的用户(玩家, 标签) {
    return 原生函数表["DzAPI_Map_Returns"](玩家, 标签);
}
export function 地图_保存服务器存档组(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_SavePublicArchive"](玩家, 键名, 值);
}
export function 地图_保存服务器存档_2(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_SaveServerValue"](玩家, 键名, 值);
}
export function 界面_获取复选框勾选状态(勾选框界面) {
    return 原生函数表["DzFrameGetCheckBoxState"](勾选框界面);
}
export function 界面_是否有指定锚点(界面, 锚点) {
    return 原生函数表["DzFrameGetPointValid"](界面, 锚点);
}
export function 界面_获取控件是否焦点(界面) {
    return 原生函数表["DzFrameIsFocus"](界面);
}
export function 聊天框是否打开() {
    return 原生函数表["DzIsChatBoxOpen"]();
}
export function 是否闰年(年) {
    return 原生函数表["DzIsLeapYear"](年);
}
export function 是否单位攻击类型(单位, 序号, 攻击类型) {
    return 原生函数表["DzIsUnitAttackType"](单位, 序号, 攻击类型);
}
export function 是否单位防御类型(单位, 防御类型) {
    return 原生函数表["DzIsUnitDefenseType"](单位, 防御类型);
}
export function 硬件_当前游戏窗口是否活动窗口() {
    return 原生函数表["DzIsWindowActive"]();
}
export function 硬件_当前游戏是否窗口化模式() {
    return 原生函数表["DzIsWindowMode"]();
}
export function 单位_杀死指定凶手(单位, 单位2) {
    return 原生函数表["DzKillUnit"](单位, 单位2);
}
export function 投射物_发射炮火(来源, 目标, 实数3, 实数4, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数15, 伤害, 弧度, 攻击, 标记, 实数20, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26) {
    return 原生函数表["DzLaunchArtillery"](来源, 目标, 实数3, 实数4, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数15, 伤害, 弧度, 攻击, 标记, 实数20, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26);
}
export function 投射物_发射炮火穿透(来源, 目标, 实数3, 实数4, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数15, 伤害, 弧度, 攻击, 标记, 实数20, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26, 实数27, 实数28, 范围) {
    return 原生函数表["DzLaunchArtilleryLine"](来源, 目标, 实数3, 实数4, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数15, 伤害, 弧度, 攻击, 标记, 实数20, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26, 实数27, 实数28, 范围);
}
export function 投射物_发射箭矢(来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记) {
    return 原生函数表["DzLaunchMissile"](来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记);
}
export function 投射物_发射箭矢弹射(来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 目标数量, 弹跳范围, 实数24) {
    return 原生函数表["DzLaunchMissileBounce"](来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 目标数量, 弹跳范围, 实数24);
}
export function 投射物_发射技能投射物腐臭蜂群(来源, 模型路径, 队伍颜色, 颜色, x, y, z, 朝向, 实数9, 缩放, 速度, 攻击类型, 伤害类型, 参数14, 伤害, 标记, 目标标记, 实数18, 实数19, 最大伤害, 增益ID) {
    return 原生函数表["DzLaunchMissileCarrionSwarmEx"](来源, 模型路径, 队伍颜色, 颜色, x, y, z, 朝向, 实数9, 缩放, 速度, 攻击类型, 伤害类型, 参数14, 伤害, 标记, 目标标记, 实数18, 实数19, 最大伤害, 增益ID);
}
export function 投射物_发射箭矢穿透(来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 实数22, 实数23, 范围) {
    return 原生函数表["DzLaunchMissileLine"](来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 实数22, 实数23, 范围);
}
export function 投射物_发射箭矢溅射(来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26) {
    return 原生函数表["DzLaunchMissileSplash"](来源, 目标, 模型路径, 队伍颜色, 颜色, x, y, z, 缩放, 速度, 攻击类型, 伤害类型, 参数13, 伤害, 弧度, 追踪, 布尔17, 布尔18, 攻击, 标记, 目标标记, 实数22, 实数23, 实数24, 实数25, 实数26);
}
// 注意:
// 1. DzPositionCanPlaceAround 更像“固定碰撞体能否放在该点”，不完全等于“当前单位能否连续位移到该点”。
// 2. 连续位移时它可能把单位自己当前占用的碰撞也算进去，出现前方空地但首步被自己卡住的误判。
// 3. 如必须把它用于强制位移判定，通常要先配合 EXSetUnitCollisionType 或同类碰撞设置一起处理。
// 4. 给其他 AI 的建议：默认优先考虑别的 API 或专用位移判定，不要直接把它当作所有单位位移的最终裁决。
export function 坐标_是否可以能够通过物体(x, y, 碰撞大小, 碰撞类型) {
    return 原生函数表["DzPositionCanPlaceAround"](x, y, 碰撞大小, 碰撞类型);
}
export function 对单位组添加命令到队列无目标(单位组, 命令ID) {
    return 原生函数表["DzQueueGroupImmediateOrderById"](单位组, 命令ID);
}
export function 对单位组添加命令到队列指定坐标(单位组, 命令ID, x, y) {
    return 原生函数表["DzQueueGroupPointOrderById"](单位组, 命令ID, x, y);
}
export function 队列_单位组目标命令按编号(单位组, 命令ID, 目标控件) {
    return 原生函数表["DzQueueGroupTargetOrderById"](单位组, 命令ID, 目标控件);
}
export function 对单位添加建造命令到队列(农民, 单位ID, x, y) {
    return 原生函数表["DzQueueIssueBuildOrderById"](农民, 单位ID, x, y);
}
export function 对单位添加命令到队列无目标(单位, 命令ID) {
    return 原生函数表["DzQueueIssueImmediateOrderById"](单位, 命令ID);
}
export function 队列_下达瞬时点位命令按编号(单位, 命令ID, x, y, 瞬时目标控件) {
    return 原生函数表["DzQueueIssueInstantPointOrderById"](单位, 命令ID, x, y, 瞬时目标控件);
}
export function 队列_下达瞬时目标命令按编号(单位, 命令ID, 目标控件, 瞬时目标控件) {
    return 原生函数表["DzQueueIssueInstantTargetOrderById"](单位, 命令ID, 目标控件, 瞬时目标控件);
}
export function 队列_下达中立目标命令按编号(归属玩家, 中立建筑, 单位ID, 目标) {
    return 原生函数表["DzQueueIssueNeutralTargetOrderById"](归属玩家, 中立建筑, 单位ID, 目标);
}
export function 对单位添加命令到队列指定坐标(单位, 命令ID, x, y) {
    return 原生函数表["DzQueueIssuePointOrderById"](单位, 命令ID, x, y);
}
export function 队列_下达目标命令按编号(单位, 命令ID, 目标控件) {
    return 原生函数表["DzQueueIssueTargetOrderById"](单位, 命令ID, 目标控件);
}
// 这个接口更接近“具体单位能否放到坐标”的语义；如果是连续位移，通常会比 DzPositionCanPlaceAround 更稳。
// 这个接口更接近“具体单位能否放到坐标”的语义；如果是连续位移，通常会比 DzPositionCanPlaceAround 更稳。
export function 单位_是否可以被放置到坐标(对象, x, y) {
    return 原生函数表["DzUnitCanPlaceAround"](对象, x, y);
}
export function 单位_技能_判断单位是否拥有技能包含模版技能(单位, 技能代码) {
    return 原生函数表["DzUnitHasAbility"](单位, 技能代码);
}
export function 工作表的值布尔值(整数1, 字符串2, 行, 列) {
    return 原生函数表["DzXlsxWorksheetGetCellBoolean"](整数1, 字符串2, 行, 列);
}
export function 平台扩展_是否随机数是否存在(玩家, 键名) {
    return 原生函数表["KKApiCheckBackendLogicExists"](玩家, 键名);
}
export function 平台扩展_玩家平台该地图成就是否完成(玩家, ID) {
    return 原生函数表["KKApiIsAchievementCompleted"](玩家, ID);
}
export function 平台扩展_是否在平台正常游戏中() {
    return 原生函数表["KKApiIsGameMode"]();
}
export function 平台扩展_是否玩家当前地图在游戏大厅置顶状态(玩家) {
    return 原生函数表["KKApiIsPinned"](玩家);
}
export function 平台扩展_玩家地图任务状态(玩家, 整数2, 整数3) {
    return 原生函数表["KKApiIsTaskInProgress"](玩家, 整数2, 整数3);
}
export function 平台扩展_发送云脚本数据(玩家, 事件名称, 字符串3) {
    return 原生函数表["KKApiMlScriptEvent"](玩家, 事件名称, 字符串3);
}
export function 平台扩展_判定测试大厅游戏时长区间(玩家, 最小时长, 最大时长) {
    return 原生函数表["KKApiPlayedTime"](玩家, 最小时长, 最大时长);
}
export function 平台扩展_取玩家身份类型(玩家, ID) {
    return 原生函数表["KKApiPlayerIdentityType"](玩家, ID);
}
export function 平台扩展_随机只读存档删除随机数(玩家, 键名) {
    return 原生函数表["KKApiRemoveBackendLogicResult"](玩家, 键名);
}
export function 平台扩展_技能按钮_目标指示器点击目标单位(鼠标类型, 目标) {
    return 原生函数表["KKCommandTargetClick"](鼠标类型, 目标);
}
export function 平台扩展_技能按钮_目标指示器点击地面坐标(鼠标类型, x, y, z) {
    return 原生函数表["KKCommandTerrainClick"](鼠标类型, x, y, z);
}
export function 平台扩展_点_是否可以能够通过物体(点, 碰撞大小, 碰撞类型) {
    return 原生函数表["KKPositionCanPlaceAroundLoc"](点, 碰撞大小, 碰撞类型);
}
export function 平台扩展_界面_判断SimpleFrame类型控件是否显示(简单界面) {
    return 原生函数表["KKSimpleFrameIsVisible"](简单界面);
}
export function 平台扩展_单位_是否可以被放置到点(对象, 点) {
    return 原生函数表["KKUnitCanPlaceAroundLoc"](对象, 点);
}
export function 平台扩展_物品_是否可以被放置到点(对象, 点) {
    return 原生函数表["KKUnitCanPlaceAroundLocItem"](对象, 点);
}
export function 请求额外_布尔数据(数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8) {
    return 原生函数表["RequestExtraBooleanData"](数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8);
}
